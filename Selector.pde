class Selector { // - - - - - 
  /* 
  Wrapper for ToggleButton class, holds multiple buttons 
  and only one can be selected at a time.
  */
  int x, y, w, h;
  ArrayList<ToggleButton> buttons = new ArrayList<ToggleButton>(); // Buttons stored in panel
  ToggleButton selection; // Currently selected button
  String title; // Title of selector panel
  String hoveredDesc;
  
  Selector(String title, int x, int y, int w, int h){
    this.x = x; 
    this.y = y;
    this.w = w;
    this.h = h;
    this.title = title;
  }
  
  /* Adds Button to selector panel */
  void addButton(String title, String description, String value){
    // place button at correct height based on how many buttons are added
    buttons.add(new ToggleButton(title, description, value, x + 20, y + 30 + buttons.size() * 30));
    // Select the top button
    selection = buttons.get(0);
  }
  
  /* Checks if any buttons are pressed/Hovered*/
  void handleEvents(){
    // Pressed
    for (ToggleButton button : buttons){
      if (button.is_pressed()){
        // Deselect old button
        selection.isSelected = false;
        // Select new button
        selection = button;
      }
    }
    selection.isSelected = true;
    
    // Hovered
    for (ToggleButton button : buttons){
      if(button.is_hovered()){
        hoveredDesc = button.description;
        break;
      }
      // No buttons hovered
      hoveredDesc = null;
    }
    
  }
  
  
  
  void render(){
    // Render box
    noFill();
    stroke(0);
    strokeWeight(2);
    rect(x, y, w, h);
    
    // Render title
    fill(0);
    textSize(20);
    textAlign(CENTER);
    strokeWeight(1);
    text(title, x + w / 2, y - 10);
    
    // Render each button
    for (ToggleButton button : buttons){
      button.render();
    }
  }
  
}


class ToggleButton{ // - - - - - 
  /* 
  Button that can be toggled on or off, displayed by filled or empty circle
  */
  String text; // Displayed on button
  String value; // Value returned if button is pressed (for wrapper class Selector)
  String description; // Value returned if button is hovered (for wrapper class Selector)
  int x, y;
  float w, h;
  boolean isSelected; // Render button as pressed
  boolean pressed; // So button press is registered only once per click
  
  ToggleButton(String text, String description, String value, int x, int y){
    this.text = text;
    this.x = x;
    this.y = y;
    this.value = value;
    this.description = description;
    pressed = false;
    textSize(15);
    w = textWidth(text);
    h = textAscent() + textDescent();
  }
  
  boolean is_pressed(){
    // If mouse is pressing on button
    if (mouseX > x && mouseX < x + w + 20 && mouseY < y && mouseY > y - h){
      // Set that mouse was pressed
      if (mousePressed){
        pressed = true;
      }
      // On release of mouse change state
      else if (pressed){
        pressed = false;
        return true;
      }
    }
    return false;
  }
  
  boolean is_hovered(){
    // Mouse over
    if (mouseX > x && mouseX < x + w + 20 && mouseY < y && mouseY > y - h){
      return true;
    }
    return false;
  }
  
  void render(){
    textSize(15);
    // Render filled circle
    if (isSelected){
      fill(75, 75, 255);
      noStroke();
      circle(x, y - 7, 7);
      
      noFill();
      stroke(75, 75, 255);
      strokeWeight(2);
      circle(x, y - 7, 14);
    }
    // Render empty circle
    else {
      noFill();
      stroke(0, 0, 0);
      strokeWeight(2);
      circle(x, y - 7, 14);
    }
    
    // Render text
    stroke(0, 0, 0);
    strokeWeight(1);
    fill(0, 0, 0);
    textAlign(LEFT);
    text(text, x + 20, y);
  }
  
}

class rectButton{ // - - - - - 
  /* 
  Regular button that can be pressed
  */
  String text; // Displayed on button
  String description;
  int x, y;
  float w, h;
  boolean isSelected;
  boolean pressed; // So button press is registered only once per click
  int fontSize;
  
  rectButton(String text, String description, int fontSize, int x, int y, int w, int h){
    this.text = text;
    this.description = description;
    this.fontSize = fontSize;
    this.x = x;
    this.y = y;
    pressed = false;
    this.w = w;
    this.h = h;
  }
  
  boolean is_pressed(){
    // If mouse is over button
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h){
      isSelected = true;
      
      // Set if mouse was pressed
      if (mousePressed){
        pressed = true;
      }
      // On release of mouse change state
      else if (pressed){
        pressed = false;
        return true;
      }
    }
    else{
      isSelected = false;
    }
    return false;
  }
  
  boolean is_hovered(){
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h){
      return true;
    }
    return false;
  }
  
  void render(){
    // Render smaller rect
    if (isSelected){
      noFill();
      stroke(0);
      strokeWeight(2);
      rect(x + 2.5, y + 2.5, w - 5, h - 5);
    }
    // Render normal rect
    else {
      noFill();
      stroke(0);
      strokeWeight(2);
      rect(x, y, w, h);
    }
    
    textSize(fontSize);
    // Render text
    stroke(0);
    strokeWeight(1);
    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    text(text, x + w / 2, y + h / 2);
  }
  
}


class Slider{ // - - - -
  String title; // Displayed below slider
  String description; // 
  float min, max;
  float value; // Value of slider
  float pos; // Bar position
  
  float x, y, w, h;
  
  Slider(String title, String description, float min, float max, int x, int y, int w, int h){
    this.title = title;
    this.description = description;
    this.min = min;
    this.max = max;
    
    pos = w / 2;
    value = map_range(pos, 0, w, min, max);
    
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  // Adjust slider
  void handleEvents(){
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h && mousePressed){
      pos = (mouseX - x);
      value = map_range(pos, 0, w, min, max);
    }
  }
  
  boolean is_hovered(){
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h){
      return true;
    }
    return false;
  }
  
  // Coverts one range of numbers to another range
  private float map_range(float input, float in_start, float in_end, float out_start, float out_end){
    float slope = (out_end - out_start) / (in_end - in_start);
    return out_start + slope * (input - in_start);
  }
  
  
  
  void render(){
    // Text
    textSize(17);
    textAlign(CENTER);
    text(title, x + w / 2, y + h);
    
    // Line
    stroke(0);
    strokeWeight(2);
    line(x, y + 10, x + w, y + 10); // Main
    
    line(x, y + 15, x, y + 5); // Left
    line(x + w / 2, y + 15, x + w / 2, y + 5); // Center
    line(x + w, y + 15, x + w, y + 5); // Right
    
    // Bar
    strokeWeight(1);
    fill(75, 75, 255);
    rect(x + pos - 3, y + 2, 6, 16);
    
  }
  
  
}
