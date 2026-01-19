#include <bits/stdc++.h>
using namespace std;

#define loop(n) for(int i=0;i<n;i++)

/**
 * Kruskal's Algorithm Implementation
 * 
 * Finds the Minimum Spanning Tree (MST) of a connected, undirected, and weighted graph
 * using the Disjoint Set Union (DSU) data structure .
 * 
 * First sort the edges based on their weights.
 * Then iterate through the sorted edges and add them to the MST if not already connected
 * 
**/ 
class DisjointSet{
    vector<int> parent,size_of_vertices;

    public:
    DisjointSet(int n){
        parent.resize(n);
        size_of_vertices.resize(n,1);
        loop(n) parent[i] = i;
    }

    int find_par(int u){
        if(u==parent[u]) return u;
        return parent[u] = find_par(parent[u]);
    }

    void union_by_size(int u,int v){
        int parent_u = find_par(u);
        int parent_v = find_par(v);
        if(parent_u == parent_v) return;

        if(size_of_vertices[parent_u]>size_of_vertices[parent_v]){
            parent[parent_v] = parent_u;
            size_of_vertices[parent_u] += size_of_vertices[parent_v];
        } else {
            parent[parent_u] = parent_v;
            size_of_vertices[parent_v] += size_of_vertices[parent_u];
        }
    }
};

int main(){
    std::cout << "Enter number of nodes and edges: ";
    int n,e;
    std::cin >> n >> e;
    vector<array<int,3>> edges;
    std::cout << "Enter edges (u v weight): \n";

    loop(e){
        int u,v,w;
        std::cin >> u >> v >> w;
        edges.push_back({w,u,v});
    }

    sort(edges.begin(),edges.end());

    DisjointSet ds(n);
    int mst_weight = 0;
    std::cout << "Edges in the Minimum Spanning Tree:\n";
    for(auto edge:edges){
        int w = edge[0];
        int u = edge[1];
        int v = edge[2];

        if(ds.find_par(u) != ds.find_par(v)){
            ds.union_by_size(u,v);
            mst_weight += w;
            std:: cout << u << " -- " << v << " == " << w << "\n";
        }
    }
    std:: cout << "Total weight of MST: " << mst_weight << "\n";
    return 0;
}