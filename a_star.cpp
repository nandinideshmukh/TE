#include <iostream>
#include <algorithm>
#include <cmath>
#include <vector>
#include <queue>
#include <unordered_set>
#include <climits>

using namespace std;

/**
 *
 * Node of the grid or puzzle
 *
 * **/
class Node
{
    vector<Node *> neighbors;
    int fn, gn, hn;
    int x, y;

public:
    Node *par;
    Node(Node *par = nullptr)
    {
        this->par = par;
        fn = gn = hn = 0;
        x = 0, y = 0;
    }

    int calculate_fn()
    {
        this->fn = this->gn + this->hn;
        return this->fn;
    }

    int set_gn(int gn)
    {
        this->gn = gn;
        return this->gn;
    }

    int set_hn(int hn)
    {
        this->hn = hn;
        return this->hn;
    }
    void set_position(int x_, int y_)
    {
        x = x_;
        y = y_;
    }
    void set_parent(Node *par)
    {
        this->par = par;
    }
    void add_neighbor(Node *n)
    {
        neighbors.push_back(n);
    }

    int get_fn() const { return fn; }
    int get_gn() const { return gn; }
    int get_hn() const { return hn; }
    int get_x() const { return x; }
    int get_y() const { return y; }

    vector<Node *> &get_neighbours()
    {
        return neighbors;
    }

    bool operator<(const Node &other) const
    {
        return fn > other.fn;
    }
};

/**
 *
 * Parent abstract class
 * Heuristic functions may be user-defined.
 *
 **/
class Heuristic
{
public:
    virtual int calculate_score(Node *curr, Node *goal) = 0;
    virtual ~Heuristic() {};
};

/**
 *
 * Implement heuristic function(s)
 *
 * **/

class ChildHeuristic : public Heuristic
{
public:
    int calculate_score(Node *curr, Node *goal)
    {
        return abs(curr->get_x() - goal->get_x()) + abs(curr->get_y() - goal->get_y());
    }
};

/**
 *
 * Path finding algorithm!
 *
 **/

class Pathfinder
{
private:
    Heuristic *heuristic;
    vector<Node *> open_list;
    unordered_set<Node *> closed_set;

    // struct CompareNode
    // {
    //     bool operator()(Node *a, Node *b)
    //     {
    //         return a->get_fn() > b->get_fn();
    //     }
    // };
    vector<Node *> reconstruct_path(Node *goal)
    {
        vector<Node *> path;
        Node *current = goal;

        while (current != nullptr)
        {
            path.push_back(current);
            current = current->par;
        }

        reverse(path.begin(), path.end());
        return path;
    }

public:
    // member initializer list
    Pathfinder(Heuristic *h) : heuristic(h) {}

    vector<Node *> find_path(Node *start, Node *goal)
    {
        priority_queue<Node *, vector<Node *>> open_pq;

        start->set_gn(0);
        start->set_hn(heuristic->calculate_score(start, goal));
        start->calculate_fn();
        start->set_parent(nullptr);

        open_pq.push(start);

        while (!open_pq.empty())
        {
            Node *current = open_pq.top();
            open_pq.pop();

            if (current == goal)
            {
                return reconstruct_path(current);
            }

            closed_set.insert(current);

            for (Node *neighbour : current->get_neighbours())
            {
                if (closed_set.find(neighbour) != closed_set.end())
                {
                    continue;
                }

                int tentative_g = current->get_gn() + 1;

                if (tentative_g < neighbour->get_gn() ||
                    find(open_list.begin(), open_list.end(), neighbour) == open_list.end())
                {

                    neighbour->set_parent(current);
                    neighbour->set_gn(tentative_g);
                    neighbour->set_hn(heuristic->calculate_score(neighbour, goal));
                    neighbour->calculate_fn();

                    if (find(open_list.begin(), open_list.end(), neighbour) == open_list.end())
                    {
                        open_list.push_back(neighbour);
                        open_pq.push(neighbour);
                    }
                }
            }
        }

        return vector<Node *>();
    }
};

int main()
{
    const int GRID_SIZE = 5;
    vector<vector<Node *>> grid(GRID_SIZE, vector<Node *>(GRID_SIZE, nullptr));

    for (int i = 0; i < GRID_SIZE; i++)
    {
        for (int j = 0; j < GRID_SIZE; j++)
        {
            grid[i][j] = new Node();
            grid[i][j]->set_position(i, j);
        }
    }

    for (int i = 0; i < GRID_SIZE; i++)
    {
        for (int j = 0; j < GRID_SIZE; j++)
        {
            if (i > 0)
                grid[i][j]->add_neighbor(grid[i - 1][j]);
            if (i < GRID_SIZE - 1)
                grid[i][j]->add_neighbor(grid[i + 1][j]);
            if (j > 0)
                grid[i][j]->add_neighbor(grid[i][j - 1]);
            if (j < GRID_SIZE - 1)
                grid[i][j]->add_neighbor(grid[i][j + 1]);
        }
    }

    ChildHeuristic manhattan;
    Pathfinder pf(&manhattan);

    Node *start = grid[0][0];
    Node *goal = grid[2][2];

    vector<Node *> path = pf.find_path(start, goal);

    cout << "Path found:" << endl;
    for (Node *node : path)
    {
        cout << "(" << node->get_x() << ", " << node->get_y() << ") ";
    }
    cout << endl;

    for (auto &row : grid)
    {
        for (Node *node : row)
        {
            delete node;
        }
    }

    return 0;
}

// Visualize here: https://qiao.github.io/PathFinding.js/visual/
