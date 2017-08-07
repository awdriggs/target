PVector goal;
Point[] population = new Point[25];
float mutationRate = 0.1;
int pointSize = 5;

void setup() {
  size(500, 500);
  goal = new PVector(random(width), random(height));

  /* noLoop(); */
  background(0);
  noStroke();

  for(int i = 0; i < population.length; i++){
    population[i] = new Point();
  }
  noCursor();
  frameRate(15);
}

void draw() {
  
  /* noStroke(); */
  /* fill(0,100); */
  /* rect(0, 0, width, height); */
  background(0);
  stroke(55);
  /* ellipse(goal.x, goal.y, 20, 20); */
  line(goal.x-10, goal.y, goal.x+10, goal.y);
  line(goal.x, goal.y-10, goal.x, goal.y+10);
  
  noFill();
  /* fill(255); */
  stroke(255);
  for(int i = 0; i < population.length; i++){
    population[i].display(pointSize);
    population[i].calculateFitness(); //fitness score needed for selection
  }

  //SELECTION
  // create the mating pool
  ArrayList<Point> matingPool = new ArrayList<Point>();

  for(int i = 0; i < population.length; i++){
    for(int j = 0; j < population[i].fitness * 100; j++){
      //add to the mating pool
      matingPool.add(population[i]);
    }
  }

  //REPRODUCE
  for(int i = 0; i < population.length; i++){
    if(population[i].distance > 5){
      int a = int(random(matingPool.size()));
      int b = int(random(matingPool.size()));

      Point parentA = matingPool.get(a);
      Point parentB = matingPool.get(b);

      Point child = parentA.crossover(parentB);

      //mutate
      child.mutate(mutationRate);
      population[i] = child;
    }
  }

  noFill();
   /* ellipse(mouseX, mouseY, 20, 20); *1/ */
  line(mouseX-10, mouseY, mouseX+10, mouseY);
  line(mouseX, mouseY-10, mouseX, mouseY+10);
  
}

void mouseReleased(){
  goal = new PVector(mouseX, mouseY);
  
  for(int i = 0; i < population.length; i++){
    population[i] = new Point();
  }
}
