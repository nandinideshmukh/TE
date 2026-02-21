#include <bits/stdc++.h>
using namespace std;

/**
 * Dijkstra's Algorithm Implementation
 * Calculates the shortest path from source node to all other nodes
 * in a weighted undirected graph using a priority queue (min-heap).
 **/ 

void make_graph(vector<vector<pair<int,int>>>& graph, int edges){
    for(int i=0;i<edges;i++){
        int u,v,w;
        cin>>u>>v>>w;
        graph[u].push_back({v,w});
        graph[v].push_back({u,w}); // for undirected graph , comment if directed
    }
}

void dijkstra(int src,vector<vector<pair<int,int>>>& graph){
    vector<int> dist(graph.size(),INT_MAX);

    // min heap { distance, node }
    priority_queue<pair<int,int>,vector<pair<int,int>>,greater<pair<int,int>>> pq;
    dist[src] = 0;
    pq.push({0,src});
    while(!pq.empty()){
        auto  it = pq.top();
        pq.pop();int node = it.second,w = it.first;

        for(auto ngbr:graph[node]){
            int adjN = ngbr.first, wt = ngbr.second;
            if(dist[adjN]>w+wt){
                dist[adjN] = w+wt;
                pq.push({dist[adjN],adjN});
            }
        }
    }

    for(int i=0;i<graph.size();i++){
        if(dist[i]==INT_MAX){
            std:: cout << "Node " << i << ": Unreachable\n";
        } else {
            std:: cout << "Node " << i << ": " << dist[i] << "\n";
        }
    }
}


int main(){

    int n,e;
    std::cout << "Enter number of nodes and edges: ";
    std::cin >> n >> e;
    vector<vector<pair<int,int>>> graph(n);
    make_graph(graph,e);
    int src = 0;
    std:: cout << "Enter source node: ";
    std:: cin >> src;
    
    dijkstra(src,graph);

}