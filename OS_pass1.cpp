
#include <bits/stdc++.h>
#include <fstream>

// sab jagah maps and vectors use kiye gaye hai

// to check whether these are declarative/imperative or not
const std::vector<std::string> declrative_check = {"DL", "DS", "DC"};
const std::vector<std::string> imperative_check = {"MOVER", "MOVEM", "ADD", "SUB"};
const std::vector<std::string> directive_check = {"START", "END", "LTORG"};

std::vector<std::pair<std::string, int>> decl_ans;
std::vector<std::pair<std::string, int>> imp_ans;

// sym,stats,code
std::unordered_map<std::string, std::pair<std::string, std::string>> mot;

// label , address
std::vector<std::pair<std::string, int>> sym_table;
std::vector<std::pair<std::string, int>> literal_table;
// count of literals in the asm file
std::unordered_map<std::string, int> pool_table;
std::map<std::string, int> register_table;
std::map<int, std::string> IC_table;

void init_register()
{
    register_table["R1"] = 1;
    register_table["R2"] = 2;
    register_table["R3"] = 3;
    register_table["R4"] = 4;
}

void init_mot()
{
    // storing machine pnuemonics in mot map
    mot.insert({"MOVEM", {"IS", "B8"}});
    mot.insert({"MOVER", {"IS", "A8"}});
    mot.insert({"ADD", {"IS", "A1"}});
    mot.insert({"SUB", {"IS", "B1"}});
    mot.insert({"DL", {"DS", "A0"}});
    mot.insert({"DS", {"DS", "B0"}});
    mot.insert({"DC", {"DS", "C0"}});
    mot.insert({"LTORG", {"AD", "D0"}});
    mot.insert({"START", {"AD", "D1"}});
    mot.insert({"END", {"AD", "D2"}});
}

void display_mot()
{
    std::ofstream outfile("out.txt", std::ios::app);
    outfile << std::endl
            << std::endl
            << "Mnemonic Operation Table: \n";
    for (const auto &it : mot)
    {

        std::string sym = it.first;
        std::string stats = it.second.first;
        std::string code = it.second.second;

        outfile << "\t" << sym << " - >"
                << " { " << stats << " , " << code << " } " << std::endl;
    }
    outfile.close();
}

void display_reg()
{
    std::ofstream outfile("out.txt", std::ios::app);
    outfile << std::endl
            << std::endl
            << "Register Table: \n";
    for (const auto &it : register_table)
    {

        std::string sym = it.first;
        int stats = it.second;

        outfile << "\t" << sym << " - > "
                << stats << std::endl;
    }
    outfile.close();
}

bool isImp(const std::string &word)
{
    return std::find(imperative_check.begin(), imperative_check.end(), word) != imperative_check.end();
}

bool isDecl(const std::string &word)
{
    return std::find(declrative_check.begin(), declrative_check.end(), word) != declrative_check.end();
}

bool isOpcode(const std::string &word)
{
    return isImp(word) || isDecl(word) || std::find(directive_check.begin(), directive_check.end(), word) != directive_check.end();
}

std::string is_literal(const std::string &s)
{
    if (s.size() >= 3 && s[0] == '=' && s[1] == '\'' && s.back() == '\'')
        return s;
    return "";
}

int findSymbolIndex(const std::string &sym)
{
    for (int i = 0; i < sym_table.size(); i++)
    {
        if (sym_table[i].first == sym)
            return i + 1;
    }
    // sym_table.push_back({sym, -1});
    return sym_table.size();
}

int findLiteralIndex(const std::string &lit)
{
    for (int i = 0; i < literal_table.size(); i++)
    {
        if (literal_table[i].first == lit)
            return i + 1;
    }
    // literal_table.push_back({lit, -1});
    return literal_table.size();
}
int main()
{
    std::ifstream file("pass1.asm", std::ios::in);
    if (!file.is_open())
    {
        std::cerr << "Failed to open file.\n";
        return 1;
    }

    int loc_ctr = 0; // Location counter
    std::string line;
    init_mot();
    init_register();

    while (std::getline(file, line))
    {
        std::istringstream iss(line);
        std::string label, opcode, operand;

        std::vector<std::string> tokens;
        std::string token;
        while (iss >> token)
        {
            std::string ic_line = "";

            if (is_literal(token) != "")
            {
                literal_table.push_back({is_literal(token), loc_ctr});
                int lit_index = findLiteralIndex(operand);
                ic_line += " (L," + std::to_string(lit_index) + ")";
                IC_table[loc_ctr] = (ic_line);
                pool_table["#"]++;
                continue;
            }
            if (isImp(token))
            {
                imp_ans.push_back({token, loc_ctr});
            }
            else if (isDecl(token))
            {
                decl_ans.push_back({token, loc_ctr});
            }
            tokens.push_back(token);
        }

        if (tokens.empty())
            continue;

        if (!isOpcode(tokens[0]))
        {
            label = tokens[0];
            if (tokens.size() > 1)
                opcode = tokens[1];
            if (tokens.size() > 2)
                operand = tokens[2];

            sym_table.push_back({label, loc_ctr});
        }
        else
        {
            opcode = tokens[0];
            if (tokens.size() > 1)
                operand = tokens[1];

            if (opcode == "START")
            {
                loc_ctr = std::stoi(operand);
                IC_table[loc_ctr] = ("(AD,01) (C," + operand + ")");
                continue;
            }
            if (opcode == "LTORG" || opcode == "END")
            {
                for (auto &lit : literal_table)
                {
                    if (lit.second == -1)
                    {
                        lit.second = loc_ctr;
                        IC_table[loc_ctr] = "(DL,02) (C," + lit.first.substr(2, lit.first.size() - 3) + ")";
                        loc_ctr++;
                    }
                }
                // continue;
            }
        }

        // dikhna chahiye sahi ja raha hai
        // std::cout << opcode << "\t" << operand << std::endl;

        if (isOpcode(opcode))
        {
            std::string ic_line = "";

            // mot lookup
            auto mot_entry = mot.find(opcode);
            if (mot_entry != mot.end())
            {
                ic_line += "(" + mot_entry->second.first + "," + mot_entry->second.second + ")";
            }

            if (!operand.empty())

            {
                std::cout << token << "\t";
                // std::cout << operand[1] << "\t";
                if (token[0] == '=')
                {
                    int lit_index = findLiteralIndex(token);
                    ic_line += " (L," + std::to_string(lit_index) + ")";
                }
                if (register_table.find(operand.substr(0, 2)) != register_table.end())
                {
                    ic_line += "(R, " + std::to_string(register_table[operand.substr(0, 2)]) + ")";
                }
                if (!isdigit(operand[0]))
                {
                    int sym_index = findSymbolIndex(operand);
                    ic_line += " (S," + std::to_string(sym_index) + ")";
                }
                else
                {
                    ic_line += " (C," + operand + ")";
                }
            }

            IC_table[loc_ctr] = (ic_line);
        }

        // location counter incremented by 1
        loc_ctr += 1;
    }

    file.close();
    // std::cout << "Literal Table:\n";
    // for (const auto &entry : literal_table)
    // {
    //     std::cout << entry.first << " -> " << entry.second << '\n';
    // }
    // std::cout << std::endl;
    // std::cout << std::endl;
    // std::cout << "Symbol Table:\n";
    // for (const auto &entry : sym_table)
    // {
    //     std::cout << entry.first << " -> " << entry.second << '\n';
    // }
    // std::cout << std::endl;
    // std::cout << std::endl;
    // std::cout << "Imperative Table:\n";

    // for (const auto &entry : imp_ans)
    // {
    //     std::cout << entry.first << " -> " << entry.second << '\n';
    // }
    // std::cout << "Declarative Table:\n";
    // for (const auto &entry : decl_ans)
    // {
    //     std::cout << entry.first << " -> " << entry.second << '\n';
    // }
    // std::cout << std::endl;
    // std::cout << std::endl;
    // std::cout << "Pool Table:\n";
    // for (const auto &entry : mp)
    // {
    //     std::cout << entry.first << " -> " << entry.second << '\n';
    // }

    // std::cout << "\nIntermediate Code (IC):\n";
    // for (auto &ic : IC_table)
    // {
    //     std::cout << ic.first << " -> " << ic.second << "\n";
    // }
    std::fstream outputFile("out.txt", std::ios::app);
    if (!outputFile.is_open())
    {
        std::cerr << "Failed to open file.\n";
        return 1;
    }

    outputFile << "\nIntermediate Code (IC):\n";
    for (auto &ic : IC_table)
    {
        outputFile << ic.first << " -> " << ic.second << "\n";
    }
    outputFile << std::endl;
    outputFile << std::endl;
    outputFile << "Symbol Table:\n";
    for (const auto &entry : sym_table)
    {
        outputFile << entry.first << " -> " << entry.second << '\n';
    }
    outputFile << std::endl;
    outputFile << std::endl;
    outputFile << "Imperative Table:\n";

    for (const auto &entry : imp_ans)
    {
        outputFile << entry.first << " -> " << entry.second << '\n';
    }
    outputFile << std::endl;
    outputFile << std::endl;
    outputFile << "Declarative Table:\n";
    for (const auto &entry : decl_ans)
    {
        outputFile << entry.first << " -> " << entry.second << '\n';
    }

    outputFile << std::endl;
    outputFile << std::endl;
    outputFile << "Literal Table:\n";
    for (const auto &entry : literal_table)
    {
        outputFile << entry.first << " -> " << entry.second << '\n';
    }
    outputFile << std::endl;
    outputFile << std::endl;
    outputFile << "Pool Table:\n";
    for (const auto &entry : pool_table)
    {
        outputFile << entry.first << " -> " << entry.second << '\n';
    }
    outputFile << std::endl;
    outputFile << std::endl;

    display_mot();
    display_reg();

    outputFile << "--------------------------------------------------------------------------------------------------------------------------- " << std::endl;

    std::cout << std::endl;
    std::cout << std::endl;

    outputFile.close();
    // now display like(loc_ctr,stats,code) for

    return 0;
}
// mot.cpp
// Displaying mot.cpp.
