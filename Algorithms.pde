import java.util.PriorityQueue; // Priority queue so algorithms can run in O(1) time with automatic sorting
import java.util.Queue; // Works as first in first out array
import java.util.LinkedList;
import java.util.Map; // HashMap for backtracking with key, value pairs

class Algorithms{
  /* 
  Class that holds all algorithms, heuristics, and path rendering functions.
  Everything in class is designed to be called multiple times within a while loop
  */
  Options options;
  // Algorithm state vars;
  private boolean isRunning;
  private boolean pathReady;
  boolean setupComplete;
  
  // Returns true if algorithm is running
  boolean isRunning(){ return isRunning;}
  
  boolean pathIsReady(){ return pathReady;}
  
  
  // Algorithm Vars - - -
  ArrayList<Node> path = new ArrayList<Node>(); // Path returned from algorithm
  // All nodes that have been found but not searched
  private PriorityQueue<Node> openSetPQueue = new PriorityQueue();   // Priority queue is faster than hash set and is sorted from least to greatest automatically
  private Queue<Node> openSetQueue = new LinkedList<Node>();
  
  private HashMap<Node,Node> cameFrom  = new HashMap<Node,Node>();  // To keep track of path
  
  Node lastCurrent = new Node(0, 0);
  
  // Constructor - - -
  Algorithms(){
    options = new Options();
    isRunning = false;
    pathReady = false;
  }
  
  void reset(){
    isRunning = false;
    setupComplete = false;
  }
  
  
  void reconstruct_path(HashMap<Node,Node> cameFrom, Node current){
    // Only needs to be called once, backtracks and reverses the order of the nodes in cameFrom
    path.clear();
    path.add(0, current);
    while (cameFrom.containsKey(current)){
      current = cameFrom.get(current);
      path.add(path.size(), current); // Index 0 for start-finish, Index path.size for finish to start
    }
    // remove start and finish nodes
    path.remove(path.size() - 1);
    path.remove(0);
    pathReady = true;
  }
  
  void showPath(){
    Node node = path.get(0);
    node.set_path();
    path.remove(0);
    if (path.size() == 0){
      pathReady = false;
    }
  }
  
  // Algorithms - - - - -
  void run(Node[][] field, Node start, Node goal){  
    isRunning = true;
    
    switch (options.algorithm){
      case ("a_star"):
        a_star(field, start, goal);
        break;
        
      case ("breadthFS"):
        breadthFS(field, start, goal);
        break;
       
      case("dijkstra"):
        options.heuristic = "one";
        a_star(field, start, goal);
        break;
         
      default:
        throw new RuntimeException("Algorithm: " + options.algorithm + " does not exist!");
    }
  }

  
  // A Star / Dijkstra's - - - -
  void a_star(Node[][] field, Node start, Node goal){
    
    // Setup algorithm once
    if (!setupComplete){
      openSetPQueue.clear();
      openSetPQueue.add(start);
      
      // To keep track of path
      cameFrom.clear();
      
      start.g = 0;
      start.f = heuristic(start, goal);
      setupComplete = true;
    }
    if (!openSetPQueue.isEmpty()){
      // Get node with lowest fScore
      Node current = openSetPQueue.peek();
      
      // Found goal
      if (current == goal){
        reconstruct_path(cameFrom, current);
        goal.set_finish();
        start.set_start();
        isRunning = false;
        setupComplete = false;
        return;
      }
      
      openSetPQueue.remove(current);
      
      for (Node neighbor : current.get_neighbours(field, options.canMoveDiagonal)){
        // Current gScore + distance to neighbor (distance varies depending on heuristic)
        float tentative_gScore = current.g + heuristic(current, neighbor);
        
        if (tentative_gScore < neighbor.g){
          // Path to neighbor is better than any others so far
          cameFrom.put(neighbor, current);
          neighbor.g = tentative_gScore;
          neighbor.f = neighbor.g + heuristic(neighbor, goal);
          
          // Add neighbor to openSet if not already in
          if (!openSetPQueue.contains(neighbor)){
            openSetPQueue.add(neighbor);
            neighbor.set_open();
          }
        }
      }
      if (current != start){

        if (options.showCurrent){
          current.set_path();
          lastCurrent.set_closed();
          lastCurrent = current;
        }
        else current.set_closed();
          

      }
      // Algorithm is still searchiing
      return;
    }
    // Failed to find a path
    isRunning = false;
    setupComplete = false;
  }
  
  // Breadth-first Search - - - -
  void breadthFS(Node[][] field, Node start, Node goal){
    // Run setup the first time
    if (!setupComplete){
      openSetQueue.clear();
      // Add start node to queue
      openSetQueue.add(start);
      
      // To keep track of path
      cameFrom.clear();
      
      setupComplete = true;
    }
    
    // If queue is not empty
    if (!openSetQueue.isEmpty()){
      Node current = openSetQueue.poll();
      if (current != start){
        if (options.showCurrent){
          current.set_path();
          lastCurrent.set_closed();
          lastCurrent = current;
        }
        else current.set_closed();
      }
      
      // Reached the end goal
      if (current == goal){
        reconstruct_path(cameFrom, current);
        goal.set_finish();
        start.set_start();
        isRunning = false;
        setupComplete = false;
        return;
      }
      
      // For each neighbour of the current node
      for (Node neighbour : current.get_neighbours(field,options.canMoveDiagonal)){
        // Skip if neighbor is already added
        if (neighbour.is_open() || neighbour.is_closed() || neighbour.is_start()){
          continue;
        }
        // Add the neighbour to the queue
        openSetQueue.add(neighbour);
        neighbour.set_open();
        cameFrom.put(neighbour, current);
      }
      // Still running
      return;
    }
    // Could not find a path
    isRunning = false;
    setupComplete = false;
  }
  

  // Heuristics - - - - -
  float heuristic(Node node, Node goal){
    // Function will return distance between nodes based on heuristic selected in options.heuristic
    
    // Distance from node to goal
    int dx = abs(node.get_row() - goal.get_row());
    int dy = abs(node.get_col() - goal.get_col());   
    
    switch (options.heuristic){
      case ("manhattan"):
        // Uses Octile if diagonal is enabled
        if (!options.canMoveDiagonal){
          return manhattan(dx, dy) * (1 + 1500);
        }
        else {
          return octile(dx, dy) * (1 + 1500);
        }
        
      case ("euclidean"):
       return euclidean(dx, dy);
       
      case ("octile"):
       return octile(dx, dy * (1 + 1500));
       
      case ("chebyshev"):
       return chebyshev(dx, dy) * (1 + 1500);
       
      case ("one"):
        return 1;
         
      default:
        throw new RuntimeException("Heuristic: " + options.heuristic + " does not exist!");
    }
  }
  
    // Manhattan - Does not work with diagonal
    float manhattan(int dx, int dy){
      return dx + dy;
    }
    
    // Euclidean - Cardinal = 1, diagonal = ~1.4
    float euclidean(int dx, int dy){
      return sqrt(dx * dx + dy * dy);
    }
    
    // Octile - Cardinal = 1, diagonal = ~1.4
    float octile(int dx, int dy){
      return (dx + dy) + (sqrt(2) - 2) * min(dx, dy);
    }
    
    // Chebyshev - Cardinal = 1, diagonal = 1
    float chebyshev(int dx, int dy){
      return max(dx, dy);
    }
    
    
    // Class for algorithm settings - - - -
    class Options{
      /* 
      Groups all algorithm settings in one place for clean and easy access
      */
      private String algorithm;
      private String heuristic;
      boolean canMoveDiagonal;
      boolean showCurrent;
      
      Options(){
        algorithm = "a_star";
        heuristic = "manhattan";
        setupComplete = false;
        canMoveDiagonal = false;
      }
      
      // Set Algorithms 
      void set_algorithm_a_star() {algorithm = "a_star";}
      
      
      // Set Heuristics
      void set_heuristic_manhattan() { heuristic = "manhattan"; }
      void set_heuristic_euclidean() { heuristic = "euclidean"; }
      void set_heuristic_octile() { heuristic = "octile"; }
      void set_heuristic_chebyshev() { heuristic = "chebyshev"; }
    }

}
