import java.util.*;

// Simple implementation of FIFO replacement algorithm .
// This algo doesn't consider page frequency , page recency or anything .
public class PageReplacement {
    public static void main(String[] args) {
        Queue<Integer> q = new LinkedList<>();
        HashSet<Integer> st = new HashSet<>();
        int capacity = 3;

        int[] pages = { 2, 3, 4, 5, 2, 3, 4, 5 };
        int page_faults = 0;
        int page_hits = 0;

        int n = pages.length;
        for (int i = 0; i < n; i++) {
            if (st.size() < capacity) {
                if (!st.contains(pages[i])) {
                    page_faults++;
                    st.add(pages[i]);
                    q.offer(pages[i]);
                } else
                    page_hits++;
            } else {
                if (!st.contains(pages[i])) {
                    page_faults++;
                    int fifo_page = q.poll();
                    st.remove(fifo_page);
                    st.add(pages[i]);
                    q.offer(pages[i]);
                } else
                    page_hits++;
            }

        }
        System.out.println("\nNumber of page faults occured is: " + page_faults + "\n");
        System.out.println("\nNumber of page hits occured is: " + page_hits + "\n");

        // LRU
        page_faults = 0;
        page_hits = 0;
        HashSet<Integer> st2 = new HashSet<>();

        // stores page and indexes of recently used items .
        HashMap<Integer, Integer> lru = new HashMap<>();

        for (int i = 0; i < n; i++) {
            if (st2.size() < capacity) {
                if (!st2.contains(pages[i])) {
                    st2.add(pages[i]);
                    page_faults++;
                }
                lru.put(pages[i], i);
            } else {
                if (!st2.contains(pages[i])) {
                    int cmp = Integer.MAX_VALUE, val = Integer.MIN_VALUE;

                    Iterator<Integer> itr = st2.iterator();

                    while (itr.hasNext()) {
                        int temp = itr.next();
                        if (lru.get(temp) < cmp) {
                            cmp = lru.get(temp);
                            val = temp;
                        }
                    }

                    st2.remove(val);
                    st2.add(pages[i]);

                    page_faults++;
                }
                lru.put(pages[i], i);

            }
        }
        System.out.println("\nNumber of page faults occured is: " + page_faults + "\n");
        System.out.println("\nNumber of page hits occured is: " + page_hits + "\n");

        // Simulation -> https://os-project-page-replacement.vercel.app/
    }
}
