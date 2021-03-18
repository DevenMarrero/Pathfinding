class Algorithms{
  String heuristicName;
  boolean diagonal;
  
  // Algorithms
  
  boolean A_star(Node[][] field, int startx, int starty, int goalx, int goaly){
    
    return false;
  }
  

  // Heuristics - - - 
  float heuristic(Node node, Node goal){
    
    int x1 = node.get_pos()[0];
    int y1 = node.get_pos()[1];
    int x2 = goal.get_pos()[0];
    int y2 = goal.get_pos()[2];
    
    switch (heuristicName){
      case ("manhattan"):
        // Uses Octile if diagonal is enabled
        if (!diagonal){
          return manhattan(x1, y1, x2, y2);
        }
        else {
          return octile(x1, y1, x2, y2);
        }
        
      case ("euclidean"):
       return euclidean(x1, y1, x2, y2);
       
      case ("octile"):
       return octile(x1, y1, x2, y2);
       
      case ("chebyshev"):
       return chebyshev(x1, y1, x2, y2);
         
      default:
        throw new RuntimeException("Heuristic: " + heuristicName + " does not exist");
    }
  }
  
    // Manhattan - Does not work with diagonal
    float manhattan(int x1, int y1, int x2, int y2){
      int dx = abs(x1 - x2);
      int dy = abs(x1 - x2);
      return dx + dy;
    }
    
    // Euclidean - Cardinal = 1, diagonal = ~1.4
    float euclidean(int x1, int y1, int x2, int y2){
      int dx = abs(x1 - x2);
      int dy = abs(x1 - x2);
      return sqrt(dx * dx + dy * dy);
    }
    
    // Octile - Cardinal = 1, diagonal = ~1.4
    float octile(int x1, int y1, int x2, int y2){
      int dx = abs(x1 - x2);
      int dy = abs(x1 - x2);   
      return (dx + dy) + (sqrt(2) - 2) * min(dx, dy);
    }
    
    // Chebyshev - Cardinal = 1, diagonal = 1
    float chebyshev(int x1, int y1, int x2, int y2){
      int dx = abs(x1 - x2);
      int dy = abs(x1 - x2);
      return max(dx, dy);
    }

  
  
}
