import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.Semaphore;

class Synchronization {
    public static void main(String[] args) {
        // noticable difference is when you put (1,1) and (2,2) bhari haaa
        SemaphoreMutex buffer = new SemaphoreMutex(2, 2); // Create a parameterized SemaphoreMutex
        
        // Passing the same buffer here as threads must work on the same Queue
        Producer producer = new Producer(buffer);
        Consumer consumer = new Consumer(buffer);
        Thread t1 = new Thread(producer, "Producer-Thread");
        Thread t2 = new Thread(consumer, "Consumer-Thread");
        t1.start();
        t2.start();
    }

}

class SemaphoreMutex {
    int threads_at_a_time;
    Semaphore sm_full, sm_empty;
    int capacity;
    Queue<Integer> q = new LinkedList<>();
    Semaphore mutex;

    public SemaphoreMutex(int threads_at_a_time, int capacity) {
        this.threads_at_a_time = threads_at_a_time;
        this.mutex = new Semaphore(threads_at_a_time);
        this.capacity = capacity;
        this.sm_empty = new Semaphore(capacity); // all are empty at the start
        this.sm_full = new Semaphore(0); // 0 for all
    }

    public void produce(int item) {
        try {
            sm_empty.acquire();
            mutex.acquire();
            q.add(item);
            System.out.println("\nproduced " + item + " by " + Thread.currentThread().getName());

            mutex.release();
            sm_full.release();
        } catch (Exception e) {
            System.err.println("\nerror occured " + e);
        }
    }

    public void consume() {
        try {
            sm_full.acquire();
            mutex.acquire();
            if (q.isEmpty()) {
                System.out.println("\nno more items to consume!");
            }
            int consumed_item = q.poll();

            System.out.println("\nconsumed " + consumed_item + " by " + Thread.currentThread().getName());
            mutex.release();
            sm_empty.release();
        } catch (Exception e) {
            System.err.println("\nerror occured " + e);
        }
    }

}

class Producer implements Runnable {
    private SemaphoreMutex buffer;

    public Producer(SemaphoreMutex buffer) {
        this.buffer = buffer;
    }

    @Override
    public void run() {
        for (int i = 0; i < 10; i++) {
            try {
                buffer.produce(i);
                Thread.sleep(100); // delay between calls to the produce() method
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

class Consumer implements Runnable {
    private SemaphoreMutex buffer;

    public Consumer(SemaphoreMutex buffer) {
        this.buffer = buffer;
    }

    @Override
    public void run() {
        for (int i = 0; i < 10; i++) {
            try {
                buffer.consume();
                Thread.sleep(150); // delay between calls to the consume() method
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

// Its good ->
// https://www.slideshare.net/slideshow/access-specifiersmodifiers-in-java/110525136
