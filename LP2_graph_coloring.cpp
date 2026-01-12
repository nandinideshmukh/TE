#include <bits/stdc++.h>
using namespace std;

const bool graph[101][101] = {
        {0,1,1,1 },
        { 1,0,0,1 },
        { 0,1,0,1 },
        { 1,1,0,0 },
        // { },
    };
const int n = 4;
const int m = 4;
std::vector<int> color(n+1,0);
bool isSafe(int i,int col){
    for(int j=0;j<n;j++){
        if(i!=j && graph[i][j] == 1 && color[j]==col)
        return false;
    }
    return true;
}

bool solveProblem(int i){
    if(i==n) return true;
    
    for(int j=1;j<=m;j++){
        if(isSafe(i,j)){
            color[i] = j;
            if(solveProblem(i+1)) return true;
            color[i] = 0;
        }
    }
    return false;
    
}

int main()
{
    cout << solveProblem(1);
    
    return 0;
}
