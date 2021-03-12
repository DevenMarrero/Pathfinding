class Node {
  private color colour;
  
  // Constructor
  Node(){
    colour = WHITE;
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
  
  // Draw Node
  void render(int row, int column){
    fill(colour);
    stroke(0, 0, 0);
    square(column * nodeSize, row * nodeSize, nodeSize);
  }
  
}
