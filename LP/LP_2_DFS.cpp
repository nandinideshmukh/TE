#include <bits/stdc++.h>
using namespace std;

bool isCycleUtil(int i, vector<vector<int>> &adj, vector<bool> &vis, int parent)
{
    vis[i] = true;

    for (auto &it : adj[i])
    {
        if (!vis[it])
        {
            if (isCycleUtil(it, adj, vis, i))
                return true;
        }
        else if (it != parent)
            return true;
    }
    return false;
}

bool unidirected_cycle_detection(int V, vector<vector<int>> &adj)
{
    vector<bool> vis(V, false);
    for (int i = 0; i < V; i++)
    {
        if (!vis[i])
        {
            if (isCycleUtil(i, adj, vis, -1))
                return true;
        }
    }
    return false;
}

bool isCyclic(int i, vector<bool> &vis, vector<vector<int>> &adj , vector<bool> &path)
{
    vis[i] = true;
    path[i] = true;
    for (auto &it : adj[i])
    {
        if (!vis[it])
        {
            if (isCyclic(it, vis, adj, path))
                return true;
        }
        else if (path[it])
            return true;
    }
    path[i] = false;
    return false;
}

bool direct_cycle_detection(int V, vector<vector<int>> &adj)
{
    vector<bool> vis(V, 0);
    vector<bool> pathVis(V, 0);

    for (int i = 0; i < V; i++)
    {
        if (!vis[i])
        {
            if (isCyclic(i, vis, adj, pathVis) == true)
                return true;
        }
    }
    return false;
}

int main()
{
    int n, e;
    std::cout << "\nenter number of nodes and edges: ";
    cin >> n >> e;

    bool isDirected;
    cout << "\nDo you want the graph to be directed(0 or 1)?  ";
    cin >> isDirected;

    vector<vector<int>> adj(n);
    cout << "\nEnter (u,v) from->to: \n";
    for (int i = 0; i < e; i++)
    {
        int u, v;
        cin >> u >> v;
        adj[u].push_back(v);
        if (!isDirected)
        {
            adj[v].push_back(u);
        }
    }

    if (isDirected)
    {
        if (direct_cycle_detection(n, adj))
            cout << "graph has a cycle present in it!!\n";
        else
        {
            cout << "\nno cycle present!";
        }
    }
    else
    {
        if (unidirected_cycle_detection(n, adj))
            cout << "graph has a cycle present in it!!\n";
        else
        {
            cout <<"\nno cycle present!";
        }
    }
    return 0;
}
