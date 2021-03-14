class Node {
  private color colour;
  private int row;
  private int col;
  
  // Constructor
  Node(int row, int col){
    colour = WHITE;
    this.row = row;
    this.col = col;
  }

  // Get state
  boolean is_start() {return colour == GREEN;}
  boolean is_finish() {return colour == RED;}
  boolean is_empty() {return colour == WHITE;}
  boolean is_wall() {return colour == GREY;}
  boolean is_open() {return colour == PURPLE;}
  boolean is_closed() {return colour == TURQUOISE;}
  
  // Set state
  void set_start() {colour = GREEN;}
  void set_finish() {colour = RED;}
  void set_empty() {colour = WHITE;}
  void set_wall() {colour = GREY;}
  void set_open() {colour = PURPLE;}
  void set_closed() {colour = TURQUOISE;}
  
  // Get row/col
  int [] get_pos(){
    return new int [] {row, col};
  }
  
  
  // Returns all traversable nodes connected to row, col
  ArrayList<Node> get_neighbours(Node[][] field, boolean diagonal){
    ArrayList<Node> neighbours = new ArrayList<Node>();
    
    // UP
    if(row - 1 >= 0 && !field[row - 1][col].is_wall()){
      neighbours.add(field[row - 1][col]);
    }
    // DOWN
    if (row + 1 != field.length - 1 && !field[row + 1][col].is_wall()){
      neighbours.add(field[row + 1][col]);
    }
    // LEFT
    if (col - 1 >= 0 && !field[row][col - 1].is_wall()){
      neighbours.add(field[row][col - 1]);
    }
    // RIGHT
    if (col + 1 != field[row].length - 1 && !field[row][col + 1].is_wall()){
      neighbours.add(field[row][col + 1]);
    }
    
    // Diagonals
    if (diagonal){
      // Top right
      if (row - 1 >= 0 && col + 1 != field[row].length - 1 && !field[row - 1][col + 1].is_wall()){
        // Not a corner
        if (!(field[row - 1][col].is_wall() && field[row][col + 1].is_wall())){
          neighbours.add(field[row - 1][col + 1]);
        }
      }
      
      // Top left
      if (row - 1 >= 0 && col - 1 >= 0 && !field[row - 1][col - 1].is_wall()){
        // Not a corner
        if (!(field[row - 1][col].is_wall() && field[row][col - 1].is_wall())){
          neighbours.add(field[row - 1][col - 1]);
        }
      }
      
      // Bottom right
      if (row + 1 != field.length - 1 && col + 1 != field[row].length - 1 && !field[row + 1][col + 1].is_wall()){
        // Not a corner
        if (!(field[row + 1][col].is_wall() && field[row][col + 1].is_wall())){
          neighbours.add(field[row + 1][col + 1]);
        }
      }
      
      // Bottom left
      if (row + 1 != field.length - 1 && col - 1 >= 0 && !field[row + 1][col - 1].is_wall()){
        // Not a corner
        if (!(field[row + 1][col].is_wall() && field[row][col - 1].is_wall())){
          neighbours.add(field[row + 1][col - 1]);
        }
      }
    }
    
    return neighbours;
  }
  
  
  // Draw Node
  void render(int row, int column){
    fill(colour);
    stroke(0, 0, 0);
    square(column * nodeSize, row * nodeSize, nodeSize);
  }
  
  
}
