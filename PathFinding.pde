//
//  PathFinding.pde
//
//  Title: PathFinding
//  Description: Visualization tool for testing diferent pathfinding algorithms 
//  Created by: Deven
//  Created on: March 12th, 2021
//  Last Updated: March 21th, 2021
//  Known Limitations: 


// Algorithm Vars
Algorithms algorithm;

Node[][] grid;
ArrayList<Node> walls = new ArrayList<Node>(); // Keep track of walls when clearing grid
Node start;
Node goal;

// Drawing vars
int nodeSize = 15;
boolean dragStart = false;
boolean dragFinish = false;
boolean erasing  = false;
boolean drawing = false;
int lastRow;
int lastCol;
int cursor; // Mouse cursor

// Menu vars
Selector algSelector;
Selector heurSelector;
ToggleButton diagonalButton; 

rectButton startButton;
rectButton resetButton;
rectButton clearButton;

Slider speedSlider;

String descText;


void setup(){ 
  clear_grid();
  // Place start and finish nodes
  grid[24][20].set_start();
  start = grid[24][20];
  grid[24][30].set_finish();
  goal = grid[24][30];
  
  surface.setTitle("Pathfinding Visualizer");  
  // Set size and locationof screen
  surface.setSize(nodeSize * grid.length + 200, nodeSize * grid[0].length + 100);
  surface.setLocation(displayWidth/2 - width/2, displayHeight/2 - height/2);
  
  // create object that contains algorithms.
  algorithm = new Algorithms();
  
  // Create selection menus and add buttons to them
  algSelector = new Selector("ALGORITHMS", width - 180, 50, 160, 250); // Title, x, y, w, h
  descText = "";
  algSelector.addButton("A*", descText, "a_star");
  
  heurSelector = new Selector("HEURISTICS", width - 180, 350, 160, 140); // Title, x, y, w, h
  
  descText = "Manhattan distance measures grid distance in terms of only horizontal and vertical movement. Each step in any direction is given a distance of 1. If Allow Diagonal is selected it will use Octile instead.";
  heurSelector.addButton("Manhattan", descText, "manhattan");
  
  descText = "Octile distance is the standard for measuring distance on a grid that allows for diagonal movement. A horizontal or vertical step is given a distance of 1 and a diagonal step is given the distance √2 (~1.41).";
  heurSelector.addButton("Octile", descText, "octile");
  
  descText = "Euclidean distance is normally only seen when the object can move at any angle within a space. Returns the direct line distance between a node and the goal. It does not work as well when implemented on a grid.";
  heurSelector.addButton("Euclidean", descText, "euclidean");
  
  descText = "Chebyshev distance is most often described as moving like a king piece from chess, a step in any direction, whether horizontal, vertical, or diagonal, is given a distance of 1.";
  heurSelector.addButton("Chebyshev", descText, "chebyshev");
  
  // Create independent buttons
  descText = "If selected the algorithm can move diagonally, otherwise it will only move vertically and horizontally.";
  diagonalButton = new ToggleButton("Allow Diagonal", descText, "diagonal", width - 160, 570); // Allow diagonal
  
  descText = "Runs the algorithm with the selected settings.";
  startButton = new rectButton("START", descText, 25, width - 150, 715, 100, 40); //  Start
  descText = "Stops running and sets grid to how it was originally.";
  resetButton = new rectButton("RESET", descText, 20, width - 190, 670, 80, 30); // Reset
  descText = "Stops running and removes the path created by the algorithm.";
  clearButton = new rectButton("CLEAR", descText, 20, width - 90, 670, 80, 30); // Clear
  
  descText = "Adjusts the speed of which the algorithm runs. Ranges from 5 - 100 fps";
  speedSlider = new Slider("Speed", descText, 5, 100, width - 170, 590, 140, 35); // title, min, max, x, y, w, h
}

void draw(){
  background(230, 230, 230);
  handleEvents(); // Handle user input and modify grid
  update(); // Step through algorithm if running
  render(); // Draw everythiing on screen
}

// Handles input from user - - - - - - - - - - - - - - -
void handleEvents(){
  // Alg is not running
  if (!algorithm.isRunning){
    frameRate(200);
    int row = mouseY / nodeSize;
    int col = mouseX / nodeSize;
    
    boolean offGrid = false;
    
    // Mouse is off grid
    if(row < 0 || row > grid.length - 1 || col < 0 || col > grid[row].length - 1) offGrid = true;
  
    // Left click - -
    if (mousePressed && mouseButton == LEFT){
      if (!offGrid){
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
    }
    
    // Right click - -
    else if (mousePressed && mouseButton == RIGHT){
      if (!offGrid){
        // Empty node
        if (grid[row][col].is_wall()){
          grid[row][col].set_empty();
        }
      }
    }
    
    // No click - -
    else {
      dragStart = false;
      dragFinish = false;
      erasing = false;
      drawing  = false;
    }
  
    // Selection menus/Buttons - - - -
    algSelector.handleEvents();
    heurSelector.handleEvents();
    
    if (diagonalButton.is_pressed()){
      if (diagonalButton.isSelected) diagonalButton.isSelected = false;
      else if (!diagonalButton.isSelected) diagonalButton.isSelected = true;
    }
    
    // Start Pressed
    if (startButton.is_pressed()){
      clear_path();
      algorithm.isRunning = true;
    }
  }
  
  // Algorithm is running
  else {

  }
  
  // Indiferent if algorithm is running
  
  // Reset Button
  if (resetButton.is_pressed()){
    algorithm.reset();
    clear_grid();
    grid[24][20].set_start();
    start = grid[24][20];
    grid[24][30].set_finish();
    goal = grid[24][30];
  }
  
  // Clear button
  if (clearButton.is_pressed()){
    algorithm.reset();
    clear_path();
  }
  
  // speedSlider
  speedSlider.handleEvents();
  
  // Change cursor and description for hovered buttons
  cursor = HAND;
  if (algSelector.hoveredDesc != null){ descText = algSelector.hoveredDesc; } // Algorithm selector
  else if(heurSelector.hoveredDesc != null){ descText = heurSelector.hoveredDesc; } // Heuristic selector
  else if(diagonalButton.is_hovered()){ descText = diagonalButton.description; } // Diagonal button
  else if(resetButton.is_hovered()){ descText = resetButton.description; } // Reset button
  else if(clearButton.is_hovered()){ descText = clearButton.description; } // Clear Button
  else if(speedSlider.is_hovered()) { descText = speedSlider.description; }
  
  // Nothing hovered
  else{
  descText = "Use the mouse to drag the green and red start/finish nodes around the grid, click and drag on the grid to draw and erase obstacles. Choose an algorithm from the panel on the right and press start." ;
  cursor = ARROW;
  }
  // Change cursor here to avoid flickering
  cursor(cursor);
  
}


// Update the gameState- - - - - - - - - - - -
void update(){
  // Set alg options from menu
  algorithm.options.algorithm = algSelector.selection.value;
  algorithm.options.heuristic = heurSelector.selection.value;
  
  // Set diagonal option
  if(diagonalButton.isSelected) algorithm.options.canMoveDiagonal = true;
  else algorithm.options.canMoveDiagonal = false;
  
  // Run alg if ready
  if (algorithm.isRunning){
    frameRate(speedSlider.value);
    int result = algorithm.run(grid, start, goal); // -1 = fail, 0 = still running, 1 = found path
    
    if (result == -1){ // Alg Failed
      
    }
    else if (result == 1){ // Alg complete
    }
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
  
  // Draw selection panels
  algSelector.render();
  heurSelector.render();
  
  // Draw buttons
  diagonalButton.render();
  startButton.render();
  resetButton.render();
  clearButton.render();
  
  // Draw slider
  speedSlider.render();
  
  // Draw options box
  fill(0);
  textSize(20);
  textAlign(CENTER);
  text("OPTIONS", width - 180 + 160 / 2, 540 - 10);
  
  noFill();
  strokeWeight(2);
  rect(width - 180, 540, 160, 100);
  
  // Draw description
  textSize(18);
  textAlign(LEFT);
  fill(0);
  text(descText, 10, height - 90, 750, height - 5);
  
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
