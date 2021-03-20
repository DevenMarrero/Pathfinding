//
//  PathFinding.pde
//
//  Title: PathFinding
//  Description: Visualization tool for testing diferent pathfinding algorithms 
//  Created by: Deven
//  Created on: March 12th, 2021
//  Last Updated: March 19th, 2021
//  Known Limitations: 


// Visualizer Vars
Node[][] grid;
ArrayList<Node> walls = new ArrayList<Node>();
Node start;
Node goal;

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
color WHITE = color(255, 255, 255);    // Empty
color PURPLE = color(234, 166, 247);   // Open
color ORANGE = color(255, 165, 0);     // Path
color GREY = color(128, 128, 128);     // Wall
color TURQUOISE = color(152, 237, 230);// Closed


void setup(){ 
  clear_grid();
  // Place start and finish nodes
  grid[24][20].set_start();
  start = grid[24][20];
  grid[24][30].set_finish();
  goal = grid[24][30];
    
  // Allows the screen to be resized
  surface.setResizable(true);
  surface.setSize(nodeSize * grid.length, nodeSize * grid[0].length);
  
  // create object that contains algorithms.
  algorithm = new Algorithms();
  
  algorithm.options.set_heuristic_manhattan();
  algorithm.options.set_algorithm_a_star();
  algorithm.options.canMoveDiagonal = false;
}

void draw(){
  // Not running algorithm
  if (!algorithm.isRunning){
    frameRate(100);
    handleEvents();
  } 
  else {
    frameRate(25);
    update();
  }
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
      if (!grid[row][col].is_finish() && !grid[row][col].is_wall()){
        grid[row][col].set_start();
        start = grid[row][col];
        
        lastRow = row;
        lastCol = col;
      }
      // If not go back
      else {
        grid[lastRow][lastCol].set_start();
        start = grid[lastRow][lastCol];
      }
    }
    
    // Dragging finish - 
    else if (dragFinish){
      grid[lastRow][lastCol].set_empty();
      
      // Node is empty
      if(!grid[row][col].is_start() && !grid[row][col].is_wall()){
        grid[row][col].set_finish();
        goal = grid[row][col];
      
        lastRow = row;
        lastCol = col;
      }
      // If not go back
      else {
        grid[lastRow][lastCol].set_finish();
        goal = grid[lastRow][lastCol];
      }
    }
    
    // Erasing -
    else if (erasing && !drawing){
      if (grid[row][col].is_wall( )){
        grid[row][col].set_empty();
      }
    }
    
    // Empty node
    else if (!grid[row][col].is_start() && !grid[row][col].is_finish() && !grid[row][col].is_wall()) {
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
  int result = algorithm.run(grid, start, goal); // -1 = fail, 0 = still running, 1 = found path
  
  if (result == -1){
    
  }
  else if (result == 1){
  }

}


// Renders the screen - - - - - - - - - - - - - - -
void render(){
  if (algorithm.pathIsReady()){
    algorithm.showPath();
  }
  
  // Draw grid
  for (int r = 0; r < grid.length; r++){
    for (int c = 0; c < grid[r].length; c++){
      grid[r][c].render(r,c);
    }
  }
  
}


// Clears the entire grid - - -
void clear_grid(){
  // Empty old grid
  grid = new Node[50][50];
  
  // Fill Grid
  for (int r = 0; r < grid.length; r++){
    for (int c = 0; c < grid[r].length; c++){
      grid[r][c] = new Node(r, c);
    }
  }
}

// Clears the algorithm's path from the grid - - -
void clear_path(){
  walls.clear();
  int startRow = start.get_row();
  int startCol = start.get_col();
  int goalRow = goal.get_row();
  int goalCol = goal.get_col();
  
  for (int r = 0; r < grid.length; r++){
    for (int c = 0; c < grid[r].length; c++){
      if (grid[r][c].is_wall()){
        walls.add(grid[r][c]);
      }
    }
  }
  
  clear_grid();
  // Re-add start and finish nodes
  grid[startRow][startCol].set_start();
  grid[goalRow][goalCol].set_finish();
  start = grid[startRow][startCol];
  goal = grid[goalRow][goalCol];
  
  // Re-add wall nodes
  for (Node wall : walls){
    grid[wall.get_row()][wall.get_col()].set_wall();
  }
}



void keyPressed(){
  if (key == ' '){
    //clear_path();
    clear_path();
    algorithm.isRunning = true;
  }
}
