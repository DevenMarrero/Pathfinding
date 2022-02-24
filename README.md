# Pathfinding
https://user-images.githubusercontent.com/70239160/155470864-bf475adc-34a5-4776-9a72-1e5154d53dad.mp4

Pathfinding visualization tool made in Processing3 with Java. High School major Java project. The following is a write-up handed in with the assignment

For my major Java project, I wanted the core of my program to be centered around being a tool that shows how different algorithms solve similar problems. When it came to deciding 
what type of algorithms I wanted to demonstrate I originally landed on sorting, after some research I found that I was more interested in pathfinding and maze generation 
algorithms so I choose those two for my research topics. I feel that this project is on par with my major C++ project in complexity and my completed program is something that I 
am proud of. The design of my code is made to be modular and easy to incorporate in any type of program. Each element of the UI has its own class that contains methods to render 
the element as well as handle any events such as mouse presses. Each node on the grid also is its own object that has methods for changing its state and finding neighboring nodes.
If I had more time I would also make the grid into a class so I could have all its variables and functions grouped together which would make my code cleaner.  

I wanted to make my program as user friendly as possible and I did that by adding a description box on the bottom of the screen that changes its text whenever a button is hovered 
over and explains what that button does. I made the descriptions as clear as I could by getting feedback from family and friends on how I could change the wording. I also made my 
UI very minimal and did not include any hidden menus so the user can always see what buttons are available. Changing the cursor to the hand icon when hovered over a button also 
helps the user understand what can be pressed. 

My program succeeds as a pathfinding visualization tool by meeting all the original goals I set for it. Users can manipulate the grid by moving the start and finish nodes and 
then drawing walls in between them. Once ready they can choose from four different algorithms and run them back-to-back to see the difference in how each one works. The user can 
also change settings related to the algorithms and see what effect they have on the performance. I added tools to my program such as the Show Current button and the Speed slider 
to help the user figure out more on what the algorithm is doing.  

Because my program is about showing different algorithms, the main way I could have improved it was by adding more of them. As of now my program has four different ones and I 
did not add more because of my lack of time to delve into much more complex algorithms. The other part of my program that had to be minimized due to time constraints were the 
maze generation algorithms. My plan was to put nearly the same amount of focus on maze generation that I did on pathfinding. I wanted to have another selection panel with 
multiple algorithms that would generate different shaped mazes however the priority later shifted to adding better pathfinding and the maze generation was moved to a single 
button with one algorithm. 
