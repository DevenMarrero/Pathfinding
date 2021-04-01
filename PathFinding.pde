//
//  PathFinding.pde
//
//  Title: PathFinding
//  Description: Visualization tool for testing diferent pathfinding algorithms 
//  Created by: Deven
//  Created on: March 12th, 2021
//  Last Updated: March 31th, 2021
//  Known Limitations: 

import java.util.ArrayDeque;

// Algorithm Vars
Algorithms algorithm; 

Node[][] grid;
ArrayList<Node> walls; // Keep track of walls when clearing grid
Node start;
Node goal;

// Drawing vars
int nodeSize = 15;
boolean dragStart;
boolean dragFinish;
boolean erasing;
boolean drawing;
int lastRow;
int lastCol;
int cursor; // Mouse cursor

// Maze Vars
boolean mazeSetup = false;
boolean mazeRunning = false;
ArrayDeque<Node> nodeStack = new ArrayDeque();
Node lastNode = new Node(0, 0);
boolean mazeShowCurrent;

// Menu vars
Selector algSelector;
Selector heurSelector;
ToggleButton diagonalButton; 
ToggleButton showCurrentButton;

rectButton mazeButton;
rectButton startButton;
rectButton resetButton;
rectButton clearButton;

Slider speedSlider;

String descText;


void setup(){ 
  // Setup grid
  clear_grid();
  // Place start and finish nodes
  grid[24][20].set_start();
  start = grid[24][20];
  grid[24][30].set_finish();
  goal = grid[24][30];
  nodeSize = 15;
  
  // Setup screen
  surface.setTitle("Pathfinding Visualizer"); // Title
  surface.setSize(nodeSize * grid.length + 200, nodeSize * grid[0].length + 100); // ScreenSize
  surface.setLocation(displayWidth/2 - width/2, displayHeight/2 - height/2); // Center Screen
  
  // Setup vars
  walls = new ArrayList<Node>();
  dragStart = false;
  dragFinish = false;
  erasing  = false;
  drawing = false;

  
  // create object that contains algorithms.
  algorithm = new Algorithms();
  
  // Create selection menus and add buttons to them
  // Algorithm Selector
  algSelector = new Selector("ALGORITHMS", width - 180, 50, 160, 140); // Title, x, y, w, h
  
  descText = "A* is a popular pathfinding algorithms due to its speed and intelligence. It is an informed algorithm and uses heuristics to estimate the distance from the current node it is checking to the goal as well as the start and then moves to the lowest one.";
  algSelector.addButton("A*", descText, "a_star"); // Title, description, value
  
  descText = "Best-First-Search is an informed algorithm that uses heuristics to determine the shortest path. It is less complex than A* as decisions are based only on forward distance. This can lead to Best F.S checking less and being faster in some scenarios.";
  algSelector.addButton("Best F.S.",descText, "bestFS");
  
  descText = "Breadth-First-Search is an uninformed algorithm that searches for the goal by checking every single node in the current layer before moving on to the next. BFS does not use heuristics.";
  algSelector.addButton("Breadth F.S.", descText, "breadthFS");
  
  descText = "Dijkstra's Algorithm can be made using the exact same code as the A* algorithm but unlike A* it is not an informed algorithm. It does not use heuristics and instead gives every direction a value of 1.";
  algSelector.addButton("Dijkstra", descText, "dijkstra");
  
  // Heuristic Selector
  heurSelector = new Selector("HEURISTICS", width - 180, 250, 160, 140); // Title, x, y, w, h
  
  descText = "Manhattan distance measures grid distance in terms of only horizontal and vertical movement. Each step in the cardinal directions is given a distance of 1. If Allow Diagonal is selected it will use Octile instead.";
  heurSelector.addButton("Manhattan", descText, "manhattan");
  
  descText = "Octile distance is the standard for measuring distance on a grid that allows for diagonal movement. A horizontal or vertical step is given a distance of 1 and a diagonal step is given the distance √2 (~1.41).";
  heurSelector.addButton("Octile", descText, "octile");
  
  descText = "Euclidean distance is normally only seen when the object can move at any angle within a space. Returns the direct line distance between a node and the goal. It does not work as well when implemented on a grid.";
  heurSelector.addButton("Euclidean", descText, "euclidean");
  
  descText = "Chebyshev distance is most often described as moving like a king piece from chess, a step in any direction, whether horizontal, vertical, or diagonal, is given a distance of 1.";
  heurSelector.addButton("Chebyshev", descText, "chebyshev");
  
  // Create independent buttons
  descText = "If selected, the search algorithms can move diagonally, otherwise they will only move vertically and horizontally.";
  diagonalButton = new ToggleButton("Allow Diagonal", descText, "diagonal", width - 160, 480); // Allow diagonal
  
  descText = "If selected, the search and maze algorithms will show the curent node they are working on by setting it to orange. This is only a visual change.";
  showCurrentButton = new ToggleButton("Show Current", descText, "showCurrent", width - 160, 510); // Current
  
  descText = "Generates a maze using a randomized depth-first-search algorithm. The algorithm randomly changes directions until it hits a dead end then backtracks until it finds another place to branch off.";
  mazeButton = new rectButton("GENERATE MAZE", descText, 20, width - 190, 615, 180, 35);
  descText = "Stops running and sets grid to how it was upon startup.";
  resetButton = new rectButton("RESET", descText, 20, width - 190, 665, 80, 30); // Reset
  descText = "Stops running and removes the path created by the algorithm.";
  clearButton = new rectButton("CLEAR", descText, 20, width - 90, 665, 80, 30); // Clear
  descText = "Runs the algorithm with the selected settings.";
  startButton = new rectButton("START", descText, 25, width - 150, 710, 100, 40); //  Start
  
  descText = "Adjusts the speed of which the algorithms will run. Ranges from 5 - 100 FPS";
  speedSlider = new Slider("Speed", descText, 5, 100, width - 170, 530, 140, 35); // title, min, max, x, y, w, h
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
  if (!algorithm.isRunning && !mazeRunning){
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
    algSelector.handlePress();
    heurSelector.handlePress();
    
    if (diagonalButton.is_pressed()){
      if (diagonalButton.isSelected) diagonalButton.isSelected = false;
      else if (!diagonalButton.isSelected) diagonalButton.isSelected = true;
    }
    
    if (showCurrentButton.is_pressed()){
      if (showCurrentButton.isSelected) showCurrentButton.isSelected = false;
      else if (!showCurrentButton.isSelected) showCurrentButton.isSelected = true;
    }
    
    // Maze Pressed
    if (mazeButton.is_pressed()){
      mazeRunning = true;
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
    // Reset maze
    mazeRunning = false;
    mazeSetup = false;
    algorithm.reset();
    // Reset grid
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
  
  // Selector panels
  algSelector.handleHover();
  heurSelector.handleHover();
  
  // Change cursor and description for hovered buttons
  cursor = HAND;
  if (algSelector.hoveredDesc != null) descText = algSelector.hoveredDesc; // Algorithm selector
  else if(heurSelector.hoveredDesc != null) descText = heurSelector.hoveredDesc; // Heuristic selector
  else if(diagonalButton.is_hovered()) descText = diagonalButton.description; // Diagonal button
  else if (showCurrentButton.is_hovered()) descText = showCurrentButton.description; // ShowCurrent Button
  else if (mazeButton.is_hovered()) descText = mazeButton.description; // mazeButton
  else if(resetButton.is_hovered()) descText = resetButton.description; // Reset button
  else if(clearButton.is_hovered()) descText = clearButton.description; // Clear Button
  else if(speedSlider.is_hovered()) descText = speedSlider.description; // Speed Slider
  else if(startButton.is_hovered()) descText = startButton.description; // Start Button
  
  // Nothing hovered
  else{
    descText = "Use the mouse to drag the green and red start/finish nodes around the grid, click and drag on the grid to draw and erase obstacles. Choose an algorithm from the panel on the right and press start to see it running." ;
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
  
  if (showCurrentButton.isSelected) {
    algorithm.options.showCurrent = true; 
    mazeShowCurrent = true;
  }
  else {
    algorithm.options.showCurrent = false;
    mazeShowCurrent = false;
  }
  
  // Run alg if ready
  if (algorithm.isRunning){
    // Adjust framerate to slider value
    frameRate(speedSlider.value);
    // Run algorithm
    algorithm.run(grid, start, goal);
  }
  
  else if (mazeRunning){
    frameRate(speedSlider.value);
    generate_maze();
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
  showCurrentButton.render();
  mazeButton.render();
  startButton.render();
  resetButton.render();
  clearButton.render();
  
  // Draw slider
  speedSlider.render();
  
  // Draw options box
  // Title
  fill(0);
  textSize(20);
  textAlign(CENTER);
  text("OPTIONS", width - 100, 440);
  
  // Box
  noFill();
  strokeWeight(2);
  rect(width - 180, 450, 160, 130);
  
  // Draw description
  textSize(18);
  textAlign(LEFT);
  fill(0);
  text(descText, 10, height - 90, 750, height - 5);
  
}

void generate_maze(){
  // First run
  if (!mazeSetup){
    
    // Make entire grid walls
    for (int r = 0; r < grid.length; r++){
      for (int c = 0; c < grid[r].length; c++){
        grid[r][c].set_wall();
      }
    }
    
    // nodes to explore
    nodeStack.clear();
    
    // Start at top left
    grid[0][0].set_empty();
    nodeStack.push(grid[0][0]);
    
    mazeSetup = true;
  }
  
  // While nodes in stack
  if (!nodeStack.isEmpty()){
    // Get cell at top of the stack
    Node node = nodeStack.pop();
    
    if (mazeShowCurrent){
      node.set_path();
      lastNode.set_empty();
      lastNode = node;
    }
    else node.set_empty();
    
    ArrayList<Node> neighbours = node.get_maze_neighbours(grid);
    
    // If node has neighbours 
    if (!neighbours.isEmpty()){
      // Add node back to stack
      nodeStack.push(node);
      
      // Pick random neighbour
      int randIndex = int(random(neighbours.size()));
      Node neighbour = neighbours.get(randIndex);
      
      // Mark neighbour as visited
      neighbour.set_empty();
      // Connect neighbour to current node
      connect_nodes(node, neighbour);
      // Add neighbour to stack
      nodeStack.push(neighbour);
    } 
  }
  else{
  // Maze Finished
    mazeSetup = false;
    mazeRunning = false;
    
    // Add start and finish nodes
    grid[0][0].set_start();
    start = grid[0][0];
    grid[48][48].set_finish();
    goal = grid[48][48];
  }
}

void connect_nodes(Node node1, Node node2){
  int rowDiff = (node1.row - node2.row) / -2;
  int colDiff = (node1.col - node2.col) / -2; 
  grid[node1.row + rowDiff][node1.col + colDiff].set_empty();
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
