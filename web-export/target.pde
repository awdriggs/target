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
class Point {
  /* PVector target; */
  PVector location;
  float fitness = 0;
  float distance;
  //constructor, set a random location
  /* Point(PVector _target){ */
  Point(){
    /* target = _target; */

    //set a random point to start
    location = new PVector(random(width), random(height));
  }

  // Constructor, set to a given location
  Point(PVector _location) {
    // We could make a copy if necessary
    // genes = (PVector []) newgenes.clone();
    location = _location;
  }

  //calculate fitness
  void calculateFitness(){
    //find the distance
    distance = location.dist(goal);
    //normalize the distance
    float distanceNormalized = norm(distance, 0, width);
    /* println(distance); */

    float inverse = 1 - distanceNormalized;
    //do 1 minus the normalized distance

    fitness = pow(2,inverse); //hug advantage! maybe make it not exponential?
    /* fitness = inverse; //no advantage! */
    /* println("i: ", inverse); */
    /* println("f: ", fitness); */

    //add something here, if it is within a range of the target
    //multiple fitness by 100
    if(distance < 20) fitness *= 100;
  }

  //crossover
  Point crossover(Point partner){
    PVector childLocation = new PVector();

    //flip a coin to see who's x value to take
    float coin = random(1);
    if(coin >= 0.5){
      childLocation.x = location.x;
    } else {
      childLocation.x = partner.location.x;
    }

    //flip a coint to see who's y value to take
    coin = random(1);
    if(coin >= 0.5){
      childLocation.y = location.y;
    } else {
      childLocation.y = partner.location.y;
    }

    //return a new pvect with the new location
    return new Point(childLocation);
  }

  //mutate
  void mutate(float _mRate){
    int stepSize = 50;
    if(random(1) < _mRate){
      /* location.x = random(width); */
      //don't do a totally random locate, just change by a little
      if(random(1) > 0.5){
        location.x += random(stepSize);
        location.y += random(stepSize);
      } else {
        location.x -= random(stepSize);
        location.y -= random(stepSize);
      }
    }

    /* if(random(1) < _mRate){ */
    /*   /1* location.y = random(height); *1/ */
    /*   if(random(1) > 0.5){ */
    /*     location.y += random(stepSize); */
    /*   } else { */
    /*     location.y -= random(stepSize); */
    /*   } */
    /* } */
  }

  //display
  void display(int _size){
    ellipse(location.x, location.y, _size, _size);
  }

}

