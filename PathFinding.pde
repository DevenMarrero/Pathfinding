//
//  PathFinding.pde
//
//  Title: PathFinding
//  Description: Visualization tool for testing diferent pathfinding algorithms 
//  Created by: Deven
//  Created on: March 12th, 2021
//  Last Updated: March 17th, 2021
//  Known Limitations: 


// Visualizer Vars
Node[][] grid;
int nodeSize = 15;
boolean dragStart = false;
boolean dragFinish = false;
boolean erasing  = false;
boolean drawing = false;
int lastRow;
int lastCol;

Algorithms algorithm;


// Colours
color RED = color(255, 0, 0);          // Finish
color GREEN = color(0, 225, 0);        // Start
color BLUE = color(0, 0, 255);         //
color YELLOW = color(255, 255, 0);     //
color WHITE = color(255, 255, 255);    // Empty
color BLACK = color(0, 0, 0);          // 
color PURPLE = color(234, 166, 247);   // Open
color ORANGE = color(255, 165, 0);     // 
color GREY = color(128, 128, 128);     // Wall
color TURQUOISE = color(152, 237, 230);// Closed


void setup(){ 
  clear_grid();
    
  // Allows the screen to be resized
  surface.setResizable(true);
  surface.setSize(nodeSize * grid.length, nodeSize * grid[0].length);
  
  // create object that contains algorithms.
  algorithm = new Algorithms();
}

void draw(){
  handleEvents();
  update();
  render();
}

// Handles input from user - - - - - - - - - - - - - - -
void handleEvents(){
  int row = mouseY / nodeSize;
  int col = mouseX / nodeSize;
  
  // Mouse off screen
  if(row < 0) row = 0;
  if(row > grid.length - 1) row = grid.length - 1;
  if(col < 0) col = 0;
  if(col > grid[row].length - 1) col = grid[row].length - 1;

  // Left click - -
  if (mousePressed && mouseButton == LEFT){
    
    // Dragging start -
    if (dragStart){
      grid[lastRow][lastCol].set_empty();
      
      // Node is empty  
      if (grid[row][col].is_empty( )){
        grid[row][col].set_start();
        
        lastRow = row;
        lastCol = col;
      }
      // If not go back
      else grid[lastRow][lastCol].set_start();
    }
    
    // Dragging finish - 
    else if (dragFinish){
      grid[lastRow][lastCol].set_empty();
      
      // Node is empty
      if(grid[row][col].is_empty()){
        grid[row][col].set_finish();
      
        lastRow = row;
        lastCol = col;
      }
      // If not go back
      else grid[lastRow][lastCol].set_finish();
    }
    
    // Erasing -
    else if (erasing && !drawing){
      if (grid[row][col].is_wall( )){
        grid[row][col].set_empty();
      }
    }
    
    // Empty node 
    else if (grid[row][col].is_empty()) {
      grid[row][col].set_wall();
      drawing = true;
    }
    
    // Wall node
    else if (grid[row][col].is_wall()){
      erasing = true;
    }
    
    // Start node
    else if (grid[row][col].is_start()) {
      dragStart = true;
      lastRow = row;
      lastCol = col;
    }
    
    // Finish node
    else if (grid[row][col].is_finish()) {
      dragFinish = true;
      lastRow = row;
      lastCol = col;
    }
  }
  
  // Right click - -
  else if (mousePressed && mouseButton == RIGHT){
    // Empty node
    if (grid[row][col].is_wall()){
      grid[row][col].set_empty();
    }
  }
  
  // No click - -
  else {
    dragStart = false;
    dragFinish = false;
    erasing = false;
    drawing  = false;
    
  }
}


// Update the gameState- - - - - - - - - - - -
void update(){
  
}


// Renders the screen - - - - - - - - - - - - - - -
void render(){
  // Draw grid
  for (int r = 0; r < grid.length; r++){
    for (int c = 0; c < grid[r].length; c++){
      grid[r][c].render(r,c);
    }
  }
  
}


// Clears the entire grid
void clear_grid(){
  // Empty old grid
  grid = new Node[50][50];
  
  // Fill Grid
  for (int r = 0; r < grid.length; r++){
    for (int c = 0; c < grid[r].length; c++){
      grid[r][c] = new Node(r, c);
    }
  }
  // Place start and finish nodes
  grid[24][20].colour = GREEN;
  grid[24][30].colour = RED;
}
