# GA Reversing Truck with mamdani type fuzzy controller
Train fuzzy controller with Genetic Algorithm for reversing truck

Overview : 
1. Here is mamdani type fuzzy control model.
2. We have a “png” file above, which is the learning curve plot from previous training.
3. The file called “MAMDANIwithGA.m” is the main code.
4. Following the main code guide, the GA will start to evolve our fuzzy controller to reach our goal!

Our goal :
1. The goal is reversing the car(represented as a triangle, the sharp angle is the head of the car) to the location around  
   (50,100) with the angle "phi"(calculated from the x-axis to the axis that crosses the head and the tail of the car) around 
   90 degrees.
2. Minimizing "docking_error", which defined as : 
  

