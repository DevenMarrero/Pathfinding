class Selector {
  int x, y, w, h;
  ArrayList<SelectorButton> buttons = new ArrayList<SelectorButton>();
  SelectorButton selection;
  String title;
  
  Selector(String title, int x, int y, int w, int h){
    this.x = x; 
    this.y = y;
    this.w = w;
    this.h = h;
    this.title = title;
  }
  
  void addButton(String title, String value){
    buttons.add(new SelectorButton(title, value, x + 20, y + 30 + buttons.size() * 30));
    selection = buttons.get(0);
  }
  
  void handleEvents(){
    for (SelectorButton button : buttons){
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
    for (SelectorButton button : buttons){
      button.render();
    }
  }
  
}


class SelectorButton{
  String text;
  int x, y;
  float w, h;
  boolean isSelected;
  String value;
  int count = 0;
  
  SelectorButton(String text, String value, int x, int y){
    this.text = text;
    this.x = x;
    this.y = y;
    this.value = value;
    textSize(15);
    w = textWidth(text);
    h = textAscent() + textDescent();
  }
  
  boolean isPressed(){
    if (mouseX > x && mouseX < x + w + 20 && mouseY < y && mouseY > y - h && mousePressed){
      count++;
      if (count > 7){
        count = 0;
        return true;
      }
    }
    return false;
  }
  
  void render(){
    textSize(15);
    if (isSelected){
      fill(75, 75, 255);
      noStroke();
      circle(x, y - 7, 7);
      
      noFill();
      stroke(75, 75, 255);
      circle(x, y - 7, 14);
    }
    else {
      noFill();
      stroke(0, 0, 0);
      circle(x, y - 7, 14);
    }
    
    stroke(0, 0, 0);
    fill(0, 0, 0);
    textAlign(LEFT);
    text(text, x + 20, y);
  }
  
}
