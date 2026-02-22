import java.util.*;

public class BestFirstNextWorst {
    int n, m;
    int[] processSize;
    int[] blocks;
    int[] original;

    public static void main(String[] args) {
        BestFirstNextWorst memory_allocation = new BestFirstNextWorst(3, 3);
        memory_allocation.best_fit();
        memory_allocation.first_fit();
        memory_allocation.next_fit();
        memory_allocation.worst_fit();
    }

    public BestFirstNextWorst(int n, int m) {
        this.n = n;
        this.m = m;
        processSize = new int[n];
        blocks = new int[m];
        Scanner sc = new Scanner(System.in);

        System.out.println("\nenter block(s) capacity: ");
        for (int i = 0; i < m; i++)
            blocks[i] = sc.nextInt();

        System.out.println("\nenter processes/process capacity: ");
        for (int i = 0; i < n; i++)
            processSize[i] = sc.nextInt();

        original = blocks.clone();
    }

    void resetBlocks() {
        blocks = original.clone();
    }

    void displayResults(int[] allocation) {
        for (int i = 0; i < n; i++) {
            if (allocation[i] != -1)
                System.out.println("process " + i + " allocated to block " + allocation[i] + 1);
            else
                System.out.println("process " + i + " not allocated");
        }

        // System.out.println();

        // for (int i = 0; i < n; i++)
        //     System.out.println(processSize[i]);

    }

    void best_fit() {
        int[] allocation = new int[n];
        for (int i = 0; i < n; i++)
            allocation[i] = -1;

        for (int i = 0; i < n; i++) {
            int best = -1;
            for (int j = 0; j < m; j++) {
                if (blocks[j] >= processSize[i]) {
                    if (best == -1 || blocks[j] < blocks[best]) {
                        best = j;
                    }

                }
            }
            if (best != -1) {
                allocation[i] = best;
                blocks[best] -= processSize[i];
            }
        }
        System.out.println("\nBest Fit: ");
        displayResults(allocation);
        resetBlocks();
    }

    void first_fit() {
        int[] allocation = new int[n];
        for (int i = 0; i < n; i++)
            allocation[i] = -1;

        for (int i = 0; i < n; i++) {

            for (int j = 0; j < m; j++) {
                if (blocks[j] >= processSize[i]) {
                    allocation[i] = j;
                    blocks[j] -= processSize[i];
                    break;
                }
            }

        }
        System.out.println("\nFirst fit");
        displayResults(allocation);
        resetBlocks();
    }

    void next_fit() {
        int[] allocation = new int[n];
        Arrays.fill(allocation, -1);
        int last = 0;

        for (int i = 0; i < n; i++) {
            int count = 0;
            while (count < m) {
                if (blocks[last] >= processSize[i]) {
                    allocation[i] = last;
                    blocks[last] -= processSize[i];
                    break;
                }

                last = (last + 1) % m;
                count++;
            }
        }
        System.out.println("\nNext Fit: ");
        displayResults(allocation);
        resetBlocks();
    }

    void worst_fit() {
        int[] allocation = new int[n];
        for (int i = 0; i < n; i++)
            allocation[i] = -1;

        for (int i = 0; i < n; i++) {
            int worst = -1;
            for (int j = 0; j < m; j++) {
                if (blocks[j] >= processSize[i]) {
                    if (worst == -1 || blocks[j] > blocks[worst]) {
                        worst = j;
                    }

                }
            }
            if (worst != -1) {
                allocation[i] = worst;
                blocks[worst] -= processSize[i];
            }
        }
        System.out.println("\nWorst Fit: ");
        displayResults(allocation);
        resetBlocks();
    }

}
