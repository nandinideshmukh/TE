#include <bits/stdc++.h>
using namespace std;

/**
 * Prim's Algorithm Implementation
 *
 * Finds the Minimum Spanning Tree (MST) of a connected, undirected, and weighted graph
 * using a priority queue (min-heap).
 *
 * Start from an arbitrary node, add all its edges to the min-heap.
 * Repeatedly extract the minimum weight edge from the heap and add it to the MST
 * if it connects a new vertex.
 **/

void make_graph(vector<vector<pair<int, int>>> &graph, int edges)
{
    for (int i = 0; i < edges; i++)
    {
        int u, v, w;
        cin >> u >> v >> w;
        graph[u].push_back({v, w});
        graph[v].push_back({u, w}); // for undirected graph , comment if directed
    }
}

int prims(vector<vector<pair<int, int>>> &graph, int src)
{
    vector<bool> boolean_visited(graph.size(), false);
    int mst_wt = 0;
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq;

    pq.push({0, src}); // {weight,node}
    while (!pq.empty())
    {
        auto it = pq.top();
        pq.pop();
        int weight = it.first;
        int node = it.second;
        if (boolean_visited[node])
            continue;
        boolean_visited[node] = true;
        mst_wt += weight;
        for (auto ngbr : graph[node])
        {
            int adjN = ngbr.first;
            int wt = ngbr.second;
            if (!boolean_visited[adjN])
            {
                pq.push({wt, adjN});
            }
        }
    }
    std::cout << "MST constructed using Prim's Algorithm\n"<< mst_wt;
    return mst_wt;
}

int main()
{
    int n, e;
    // std :: cout << professional
    std::cout << "Enter number of nodes and edges: ";
    std::cin >> n >> e;
    vector<vector<pair<int, int>>> graph(n);
    make_graph(graph, e);
    int src = 0;
    std::cout << "Enter source node: ";
    std::cin >> src;
    int mst_weight = prims(graph, src);
    std::cout << "Total weight of MST: " << mst_weight << "\n";

    return 0;
}
