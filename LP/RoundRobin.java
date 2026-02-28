import java.util.*;

class RoundRobin{
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter number of processes: ");
        int n = sc.nextInt();
        int[] at = new int[n];
        int[] tat = new int[n];
        int[] wt = new int[n];
        int[] bt = new int[n];
        int time_quantum = 2; // seconds

        // enter arrival time elements
        System.out.println("Enter arrival time elements: ");
        for (int i = 0; i < n; i++)
            at[i] = sc.nextInt();

        // enter burst time elements
        System.out.println("Enter burst time elements:");
        for (int i = 0; i < n; i++)
            bt[i] = sc.nextInt();

        Queue<Integer> q = new LinkedList<>();
        int[] remaining_time = bt.clone();
        int[] ct = new int[n];
        int time = 0, completed = 0;

        while (completed < n) {
            for (int i = 0; i < n; i++) {
                if (at[i] <= time && remaining_time[i] > 0 && !q.contains(i) && ct[i] == 0) {
                    q.offer(i);
                }
            }

            if (q.isEmpty()) {
                time++;
                continue;
            }

            int current_process = q.poll();

            if (remaining_time[current_process] > time_quantum) {
                time += time_quantum;
                remaining_time[current_process] -= time_quantum;

                for (int i = 0; i < n; i++) {
                    if (at[i] <= time && remaining_time[i] > 0 && !q.contains(i) && !q.contains(current_process)
                            && ct[i] == 0 && i != current_process) {
                        q.offer(i);
                    }
                }

                q.offer(current_process);
            } else {
                time += remaining_time[current_process];
                ct[current_process] = time;
                remaining_time[current_process] = 0;
                completed++;

                for (int i = 0; i < n; i++) {
                    if (at[i] <= time && remaining_time[i] > 0 && !q.contains(i) && ct[i] == 0) {
                        q.offer(i);
                    }
                }
            }
        }

        System.out.println(" Gantt chart is: ");
        System.out.println("\tP\tAT\tBT\tCT\tTAT\tWT");
        float avg_tat = 0, avg_wt = 0;
        for (int i = 0; i < n; i++) {
            tat[i] = ct[i] - at[i];
            wt[i] = tat[i] - bt[i];
            avg_tat += tat[i];
            avg_wt += wt[i];
            System.out.println("\t" + (i + 1) + " \t" + at[i] + "\t" + bt[i] + "\t" + ct[i] + "\t" + tat[i] + "\t" +
                    wt[i] + "\t");
        }
        System.out.println("Average Turnaround Time: " + (avg_tat / n));
        System.out.println("Average Waiting Time: " + (avg_wt / n));

        sc.close();
    }
}