class Selector {
  /* 
  Wrapper for ToggleButton class, holds multiple buttons 
  and only one can be selected at a time.
  */
  int x, y, w, h;
  ArrayList<ToggleButton> buttons = new ArrayList<ToggleButton>(); // Buttons stored in panel
  ToggleButton selection; // Currently selected button
  String title; // Title of selector panel
  
  Selector(String title, int x, int y, int w, int h){
    this.x = x; 
    this.y = y;
    this.w = w;
    this.h = h;
    this.title = title;
  }
  
  /* Adds Button to selector panel */
  void addButton(String title, String value){
    // place button at correct height based on how many buttons are added
    buttons.add(new ToggleButton(title, value, x + 20, y + 30 + buttons.size() * 30));
    // Select the top button
    selection = buttons.get(0);
  }
  
  /* Checks if any buttons are pressed*/
  void handleEvents(){
    for (ToggleButton button : buttons){
      if (button.isPressed()){
        // Deselect old button
        selection.isSelected = false;
        // Select new button
        selection = button;
      }
    }
    selection.isSelected = true;
  }
  
  
  
  void render(){
    // Render box
    noFill();
    stroke(0);
    rect(x, y, w, h);
    
    // Render title
    fill(0);
    textSize(20);
    textAlign(CENTER);
    text(title, x + w / 2, y - 10);
    
    // Render each button
    for (ToggleButton button : buttons){
      button.render();
    }
  }
  
}


class ToggleButton{
  /* 
  Button that can be toggled on or off, displayed by filled or empty circle
  */
  String text; // Displayed on button
  int x, y;
  float w, h;
  boolean isSelected; // Render button as pressed
  String value; // Value returned if button is pressed (for wrapper class Selector)
  boolean pressed; // So button press is registered only once per click
  
  ToggleButton(String text, String value, int x, int y){
    this.text = text;
    this.x = x;
    this.y = y;
    this.value = value;
    pressed = false;
    textSize(15);
    w = textWidth(text);
    h = textAscent() + textDescent();
  }
  
  boolean isPressed(){
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
  
  void render(){
    textSize(15);
    // Render filled circle
    if (isSelected){
      fill(75, 75, 255);
      noStroke();
      circle(x, y - 7, 7);
      
      noFill();
      stroke(75, 75, 255);
      circle(x, y - 7, 14);
    }
    // Render empty circle
    else {
      noFill();
      stroke(0, 0, 0);
      circle(x, y - 7, 14);
    }
    
    // Render text
    stroke(0, 0, 0);
    fill(0, 0, 0);
    textAlign(LEFT);
    text(text, x + 20, y);
  }
  
}

class rectButton{
  /* 
  Regular button that can be pressed
  */
  String text; // Displayed on button
  int x, y;
  float w, h;
  boolean isSelected;
  boolean pressed; // So button press is registered only once per click
  int fontSize;
  
  rectButton(String text, int fontSize, int x, int y, int w, int h){
    this.text = text;
    this.fontSize = fontSize;
    this.x = x;
    this.y = y;
    pressed = false;
    this.w = w;
    this.h = h;
  }
  
  boolean isPressed(){
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
  
  void render(){
    // Render smaller rect
    if (isSelected){
      noFill();
      stroke(0);
      rect(x + 2.5, y + 2.5, w - 5, h - 5);
    }
    // Render normal rect
    else {
      noFill();
      stroke(0);
      rect(x, y, w, h);
    }
    
    textSize(fontSize);
    // Render text
    stroke(0, 0, 0);
    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    text(text, x + w / 2, y + h / 2);
  }
  
}
