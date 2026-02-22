import java.util.*;

public class FcfsSjfPriority {
    static Scanner sc = new Scanner(System.in);

    public static void main(String[] args) {
        // here number of processes is 4
        // simulator => https://scheduling-algorithm-simulator.vercel.app/
        while (true) {
            System.err.println("do you want to study something else ?");
            String s = sc.next();
            if (s.equalsIgnoreCase("y")) {
                System.out.println("\nexiting...\n");
                break;
            }
            new FcfsSjfPriority(4);

        }
    }

    // static belongs to the class rather than the object
    List<Integer> at = new ArrayList<>();
    List<Integer> bt = new ArrayList<>();
    List<Integer> wt = new ArrayList<>();
    List<Integer> tat = new ArrayList<>();
    List<Integer> ct = new ArrayList<>();
    List<Process> processes = new ArrayList<>();
    int n;

    public FcfsSjfPriority(int n) {
        this.n = n;
        System.out.println("\nenter arrival time of processes :");
        ((ArrayList<Integer>) at).ensureCapacity(n);
        ((ArrayList<Integer>) bt).ensureCapacity(n);

        for (int i = 0; i < n; i++)
            at.add(sc.nextInt());

        System.out.println("\nenter burst time of processes :");
        for (int i = 0; i < n; i++)
            bt.add(sc.nextInt());

        for (int i = 0; i < n; i++) {
            processes.add(new Process(i + 1, at.get(i), bt.get(i)));
        }

        int choice;
        System.out.println("\nenter which scheduling algorithm you want to execute: \n1.fcfs\n2.sjf\n3.priority ");
        choice = sc.nextInt();
        processes.sort(Comparator.comparingInt(p -> p.at));
        if (choice == 1) {
            FcFs();
        } else if (choice == 2) {
            Srtf();
        } else if (choice == 3) {
            Priority();
        }
    }

    void displayResults() {
        System.out.println("\nID\tAT\tBT\tCT\tTAT\tWT");
        float avg_tat = 0, avg_wt = 0;
        for (Process p : processes) {
            int arr = p.at, bst = p.bt, cmt = p.ct, tunt = p.tat, wat = p.wt;
            avg_tat += tunt;
            avg_wt += wat;
            System.out.println("\n" + p.id + "\t" + arr + "\t" + bst + "\t" + cmt + "\t" + tunt + "\t" + wat);
        }
        System.out.println("\nAvg waiting time: " + (avg_wt / n));
        System.out.println("Avg tunAround time: " + (avg_tat / n));
        System.out.println("Done !!");
    }

    void FcFs() {
        int curr_time = 0;
        for (Process p : processes) {
            if (p.at > curr_time) {
                curr_time = p.at;
            }
            curr_time += p.bt;
            p.ct = curr_time;
            p.tat = p.ct - p.at;
            p.wt = p.tat - p.bt;
        }
        displayResults();
    }

    void Srtf() {
        // sort according to burst time
        processes.sort(Comparator.comparingInt(p -> p.bt));

        int completed = 0, time = 0;
        while (completed < n) {

            Process current = null;
            int min_remain_bt = Integer.MAX_VALUE;
            for (Process p : processes) {
                if (!p.complete && p.remaining_bt > 0 && p.at <= time) {
                    if (p.remaining_bt < min_remain_bt) {
                        current = p;
                        min_remain_bt = p.remaining_bt;
                    }
                }
            }
            time++;
            if (current == null) {
                continue;
            }
            current.remaining_bt--;
            if (current.remaining_bt == 0) {
                current.complete = true;
                current.ct = time;
                current.tat = current.ct - current.at;
                current.wt = current.tat - current.bt;
                completed++;
            }

        }

        displayResults();

        // simulator => https://sajdoko.github.io/sjf-preemptive-simulator/
    }

    void Priority() {
        int completed = 0, time = 0;
        System.out.println("\nEnter priority (higher number = higher priority):");

        for (Process p : processes) {
            p.priority = sc.nextInt();
        }
        while (completed < n) {
            Process curr = null;
            int max_priority = Integer.MIN_VALUE;
            for (Process p : processes) {
                if (!p.complete && p.remaining_bt > 0 && p.at <= time) {
                    if (p.priority > max_priority) {
                        curr = p;
                        max_priority = p.priority;
                    } else if (p.priority == max_priority) {
                        if (curr != null && p.at < curr.at) {
                            curr = p;
                        }
                    }
                }
            }
            if (curr == null) {
                time++;
                continue;
            }

            time += curr.bt;

            curr.ct = time;
            curr.tat = curr.ct - curr.at;
            curr.wt = curr.tat - curr.bt;

            curr.complete = true;
            completed++;
        }
        displayResults();
    }

}

class Process {
    int id, at, bt, ct, tat, wt;
    int priority;
    boolean complete = false;
    int remaining_bt;

    Process(int id, int at, int bt) {
        this.id = id;
        this.at = at;
        this.bt = bt;
        this.remaining_bt = bt;
    }
}