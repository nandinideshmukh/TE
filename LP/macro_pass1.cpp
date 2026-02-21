#include <fstream>
#include <bits/stdc++.h>
using namespace std;

int kp = 0, pp = 0;
int mdtp = 1, kpdtp = 1;
int ind = 1;

fstream asmFile("input.asm", ios::in);
fstream mdt("macroprocessor/mdt.txt", ios::app);
const string search_macro = "MACRO";
const string search_end = "MEND";

struct mnt
{
    int index;
    string name;
    int pp = 0, kp = 0, mdtp = 0, kpdtp = 0;
};

struct kpdtab
{
    string name;
    string value;
    int index;
};

void write_mnt_to_json(mnt mt[], int count)
{
    ofstream jsonFile("mnt.json");
    if (!jsonFile.is_open())
    {
        cerr << "Error opening mnt.json for writing\n";
        return;
    }

    jsonFile << "[\n";

    for (int i = 0; i < count; ++i)
    {
        jsonFile << "  {\n";
        jsonFile << "    \"index\": " << mt[i].index << ",\n";
        jsonFile << "    \"name\": \"" << mt[i].name << "\",\n";
        jsonFile << "    \"pp\": " << mt[i].pp << ",\n";
        jsonFile << "    \"kp\": " << mt[i].kp << ",\n";
        jsonFile << "    \"mdtp\": " << mt[i].mdtp << ",\n";
        jsonFile << "    \"kpdtp\": " << mt[i].kpdtp << "\n";
        jsonFile << "  }";
        if (i != count - 1)
            jsonFile << ",";
        jsonFile << "\n";
    }

    jsonFile << "]\n";
    jsonFile.close();

    cout << "MNT saved to mnt.json\n";
}

void generate_mnt()
{
    if (!asmFile.is_open())
    {
        cerr << "File not found!\n";
        return;
    }
    string line;
    mnt mt[3]; // Assume max 3 macros
    int pt = 0;
    set<char> st;
    bool flag = false;

    int local_mdtp = 0;
    int local_kpdtp = 1;

    while (getline(asmFile, line))
    {
        stringstream ss(line);
        string token;
        local_mdtp++;

        while (ss >> token)
        {
            if (token == search_macro)
            {
                flag = true;
                mt[pt].index = ind++;
                mt[pt].mdtp = local_mdtp;
                mt[pt].kpdtp = local_kpdtp;

                mt[pt].pp = 0;
                mt[pt].kp = 0;

                st.clear();
                continue;
            }

            if (flag)
            {
                mt[pt].name = token;
                flag = false;
                continue;
            }

            if (token[0] == '&' && !st.count(token[1]))
            {
                if (token.find('=') != string::npos)
                {
                    mt[pt].kp++;
                }
                mt[pt].pp++;
                st.insert(token[1]);
                continue;
            }

            if (token == search_end)
            {
                local_kpdtp += mt[pt].kp;
                pt++;
            }
        }
        write_mnt_to_json(mt, pt);
    }

    // // Output mdtp and kpdtp for each macro
    // for (int i = 0; i < pt; ++i)
    // {
    //     cout << "Macro: " << mt[i].name << endl;
    //     cout << "pp: " << mt[i].pp << endl;
    //     cout << "kp: " << mt[i].kp << endl;

    //     cout << "MDTP: " << mt[i].mdtp << endl;
    //     cout << "KPDTP: " << mt[i].kpdtp << endl;
    //     cout << "----------------------\n";
    // }
}

void generate_mdt()
{
    asmFile.clear();
    asmFile.seekg(0);

    ofstream mdtFile("/home/pict/Downloads/31116/macroprocessor/mdt.txt");
    if (!mdtFile.is_open())
    {
        cerr << "Cannot open MDT file for writing\n";
        return;
    }

    string line;
    bool inMacro = false;
    mnt mt[3];
    int mdtLine = 1;
    int currentMacroIndex = -1;

    map<string, int> posParams; // &param -> position index
    map<string, int> keyParams; // &param -> keyword index

    while (getline(asmFile, line))
    {
        stringstream ss(line);
        string firstToken;
        ss >> firstToken;

        if (firstToken == search_macro)
        {
            inMacro = true;
            currentMacroIndex++;
            posParams.clear();
            keyParams.clear();

            getline(asmFile, line);
            stringstream paramSS(line);
            string macroName;
            paramSS >> macroName;

            int posIndex = 1, keyIndex = 1;
            string param;
            while (paramSS >> param)
            {
                if (!param.empty() && param.back() == ',')
                    param.pop_back();

                size_t eqPos = param.find('=');
                string paramName = (eqPos == string::npos) ? param : param.substr(0, eqPos);

                if (paramName[0] != '&')
                    continue;

                if (eqPos == string::npos)
                    posParams[paramName] = posIndex++;
                else
                    keyParams[paramName] = keyIndex++;
            }

            mt[currentMacroIndex].mdtp = mdtLine;
            continue;
        }

        if (firstToken == search_end)
        {
            inMacro = false;
            mdtFile << mdtLine++ << "\tMEND\n";
            continue;
        }

        if (inMacro)
        {
            stringstream lineSS(line);
            string word;
            string newLine;

            while (lineSS >> word)
            {
                if (!word.empty() && word[0] == '&')
                {
                    string cleanParam = word;
                    while (!cleanParam.empty() && !isalnum(cleanParam.back()) && cleanParam.back() != '_')
                        cleanParam.pop_back();

                    if (posParams.count(cleanParam))
                        word = "(P," + to_string(posParams[cleanParam]) + ")";
                    else if (keyParams.count(cleanParam))
                        word = "(K," + to_string(keyParams[cleanParam]) + ")";
                }
                newLine += word + " ";
            }

            mdtFile << mdtLine++ << "\t" << newLine << "\n";
        }
    }

    mdtFile.close();
    cout << "MDT generated with " << mdtLine - 1 << " lines.\n";
}

int main()
{
    generate_mnt();
    generate_mdt();

    return 0;
}
