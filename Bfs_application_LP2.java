import java.util.*;

public class Bfs_application_LP2{
  static Map<String, List<String>> networkGraph = new HashMap<>();

  public static void main(String[] args){
    Queue<packetNetwork> queue = new ArrayDeque<>();
    Set<State> visited = new HashSet<>();

    networkGraph.put("A", Arrays.asList("B", "C"));
    networkGraph.put("B", Arrays.asList("D"));
    networkGraph.put("C", Arrays.asList("D", "E"));
    networkGraph.put("D", Arrays.asList("F"));
    networkGraph.put("E", Arrays.asList("F"));
    networkGraph.put("F", Arrays.asList("G"));
    networkGraph.put("G", Arrays.asList("H"));
    networkGraph.put("H", new ArrayList<>());

    queue.add(new packetNetwork("A", "H", "P1", 16, "SensorData"));
    queue.add(new packetNetwork("B", "G", "P2", 14, "VideoStream"));
    queue.add(new packetNetwork("C", "F", "P3", 23, "voice message"));
    int time = 0;
    while(!queue.isEmpty()){
      packetNetwork p = queue.peek();
      queue.poll();
      
      if (p.getTtl() <= 0) {
        System.out.println("Packet expired: " + p.getId());
        continue;
      }
      
      State currentState = new State(p.getSrc(), p.getId(),p.getDst());

      if (visited.contains(currentState)) {
        continue;
      }
      
      visited.add(currentState);
      
      
      if (p.getSrc().equals(p.getDst())) {
        // duplicates added repetitively
        System.out.println("Packet delivered successfully to " + p.getDst() +" in "+time + " seconds.");
        System.out.println();
        continue;
      }
      time++;

      List<String> neighbors = networkGraph.get(p.getSrc());
      if (neighbors == null || neighbors.isEmpty()) {
        System.out.println("No route from network " + p.getSrc());
        System.out.println();
        continue;
      }

      for (String nextHop : neighbors) {
        
System.out.println("Sending message: "+p.getPayload() + " from " + p.getSrc() + " to " + p.getDst() + " message Id: " + p.getId());
        packetNetwork newPacket = new packetNetwork(
            nextHop,
            p.getDst(),
            p.getId(),
            p.getTtl() - 1,
            p.getPayload()
        );

        if (newPacket.getTtl() > 0) {
          queue.offer(newPacket);
        }
      }

      System.out.println();
    }
  }
}

class packetNetwork{
  private String src ;
  private String dst;
  private String id;
  private int ttl ;
  private String payload;

  packetNetwork(String src,String dst,String id, Integer ttl , String payload){
    this.src = src;
    this.dst = dst;
    this.id = id;
    this.ttl = ttl;
    this.payload = payload;
  }

  Integer getTtl(){
    return this.ttl;
  }

  String getSrc(){
    return this.src;
  }

  String getDst(){
    return this.dst;
  }
 
  String getId(){
    return this.id;
  }

  String getPayload(){
    return this.payload;
  }

  void decrementTtl() {
    if (this.ttl > 0) {
      this.ttl--; 
    }
  }
  
}

class State {
  String src,dst;
  String packetId;

  State(String src, String packetId,String dst) {
    this.src = src;
    this.dst = dst;
    this.packetId = packetId;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    // for checking if object belongs to same class
    if (o.getClass() != this.getClass()) return false;
    State s =  (State) o;
    return src.equals(s.src) && packetId.equals(s.packetId) && dst.equals(s.dst);  }

  @Override
  public int hashCode() {
    return Objects.hash(src, packetId,dst);
  }
}
