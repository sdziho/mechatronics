import processing.serial.*; // imports library for serial communication
import java.awt.event.KeyEvent; // imports library for reading the data from the serial port
import java.io.IOException;
Serial myPort; // defines Object Serial
// defubes variables
String angle="";
String distance="";
String data="";
String noObject;
float pixsDistance;
int iAngle=0, iDistance=0;
int index1=0;
int index2=0;
int counter=0;
int flag=0;
float max;
int[] niz=new int[181];
float[] niz2=new float[181];
PGraphics pg;
PFont orcFont;



void setup() {
  pg = createGraphics(1200, 700);
  pg.beginDraw();
  pg.clear();
  pg.endDraw();
  //width,height
  for(int i=0;i<=180;i++)niz[i]=5000;
  size (1200, 700); // ***CHANGE THIS TO YOUR SCREEN RESOLUTION***
  
  smooth();
  
  myPort = new Serial(this,"COM6", 115200); // starts the serial communication
  myPort.bufferUntil('.'); // reads the data from the serial port up to the character '.'. So actually it reads this: angle,distance.
}
void draw() {
  fill(98,245,31);
  // simulating motion blur and slow fade of the moving line
  noStroke();
  fill(0,4); 
  rect(0, 0, width, height-height*0.065); 
 // fill(98,245,31); // green color
  fill(50,150,31);
  strokeWeight(1);
  stroke(255);
  rect(1000, 50, 120, 50,18);
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}

void serialEvent (Serial myPort) { // starts reading data from the Serial Port
  // reads the data from the Serial Port up to the character '.' and puts it into the String variable "data".
  data = myPort.readStringUntil('.');
  data = data.substring(0,data.length()-1);
  
  index1 = data.indexOf(","); // find the character ',' and puts it into the variable "index1"
  angle= data.substring(0, index1); // read the data from position "0" to position of the variable index1 or thats the value of the angle the Arduino Board sent into the Serial Port
  distance= data.substring(index1+1, data.length()); // read the data from position "index1" to the end of the data pr thats the value of the distance
  
  // converts the String variables into Integer
  iAngle = int(angle);
  iDistance = int(distance);
  niz[counter]=iDistance;
  print(niz[180]);
  print(" ");
  if(counter==0)flag=1;
  if(counter==180)flag=0;
  if(flag==1)counter++;
  else counter--;
}
void drawRadar() {
  pushMatrix();
  translate(width/2,height-height*0.074); // moves the starting coordinats to new location
  noFill();
  strokeWeight(1);
  stroke(98,245,31);
  // draws the arc lines
  arc(0,0,(width/2),(width/2),PI,TWO_PI);
  arc(0,0,(width/4),(width/4),PI,TWO_PI);
  arc(0,0,(width*0.75),(width*0.75),PI,TWO_PI);
  arc(0,0,(width),(width),PI,TWO_PI);
  // draws the angle lines
  line(-width/2,0,width/2,0);
  line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
  line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
  line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
  line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
  line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));
  line((-width/2)*cos(radians(30)),0,width/2,0);
  popMatrix();
}
void drawObject() {
  pushMatrix();
  translate(width/2,height-height*0.074); // moves the starting coordinats to new location
  strokeWeight(9);
  stroke(255,10,10); // red color
  pixsDistance = iDistance*(width/2)/2000; // covers the distance from the sensor from cm to pixels
  // limiting the range to 20m
  if(iDistance<=2000&&iDistance>1){
    point(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)));
    niz2[iAngle]=pixsDistance;
    if(iDistance<max) max=iDistance;
  }
  popMatrix();
}
void drawLine() {
  pushMatrix();
  strokeWeight(5);
  stroke(30,250,60);
  translate(width/2,height-height*0.074); // moves the starting coordinats to new location
  line(0,0,(height-height*0.12)*cos(radians(iAngle)),-(height-height*0.12)*sin(radians(iAngle))); // draws the line according to the angle
  
  popMatrix();
}
void drawText() { // draws the texts on the screen
  
  pushMatrix();
  textSize(20);
  fill(255);
  text("Capture", 1022, 82);
  fill(0,0,0);
  noStroke();
  rect(0, height-height*0.0648, width, height);
  fill(98,245,31);
  textSize(25);
  
  text("5m",width*5/8-40,height-height*0.0833);
  text("10m",width*6/8-55,height-height*0.0833);
  text("15m",width*7/8-55,height-height*0.0833);
  text("20m",width-55,height-height*0.0833);
  textSize(40);
  max=min(niz);
  
  text("Najblizi objekat je udaljen: " + max/100.0 + "m", width/8, height-height*0.0277);
  
  
  fill(98,245,60);
  translate((width-width*0.4994)+width/2*cos(radians(30)),(height-height*0.0907)-width/2*sin(radians(30)));
  rotate(-radians(-60));
  text("30°",0,0);
  resetMatrix();
  translate((width-width*0.503)+width/2*cos(radians(60)),(height-height*0.0888)-width/2*sin(radians(60)));
  rotate(-radians(-30));
  text("60°",0,0);
  resetMatrix();
  translate((width-width*0.507)+width/2*cos(radians(90)),(height-height*0.0833)-width/2*sin(radians(90)));
  rotate(radians(0));
  text("90°",0,0);
  resetMatrix();
  translate(width-width*0.513+width/2*cos(radians(120)),(height-height*0.07129)-width/2*sin(radians(120)));
  rotate(radians(-30));
  text("120°",0,0);
  resetMatrix();
  translate((width-width*0.5104)+width/2*cos(radians(150)),(height-height*0.0574)-width/2*sin(radians(150)));
  rotate(radians(-60));
  text("150°",0,0);
  popMatrix(); 
}

void mousePressed() {
   if (mouseX >= 1000 && mouseX <= 1120 && mouseY >= 50 && mouseY <= 110) {
      
      pg.beginDraw();
      pg.background(100);
      pg.strokeWeight(7);
      pg.stroke(255,10,10); 
      for(int i=0;i<=180;i++){
        pg.point(width/2+niz2[i]*cos(radians(i)),height-height*0.074-niz2[i]*sin(radians(i)));
      }
      
      pg.strokeWeight(4);
      pg.stroke(255); 
      pg.line(width/2,height-height*0.07,100,height-height*0.07);
      pg.line(width/2,height-height*0.07,width-100,height-height*0.07);
      pg.line(width/2,height-height*0.07,width/2,100);
      
      pg.strokeWeight(7);
      pg.stroke(255);
      pg.point(width/2,height-height*0.07);
      
      pg.text("5m",width*5/8,height-height*0.0833);
      pg.text("10m",width*6/8,height-height*0.0833);
      pg.text("15m",width*7/8,height-height*0.0833);
      pg.text("5m",width-width*5/8,height-height*0.0833);
      pg.text("10m",width-width*6/8,height-height*0.0833);
      pg.text("15m",width-width*7/8,height-height*0.0833);
      pg.text("5m",width/2+10,height-height*0.07-width/8);
      pg.text("10m",width/2+10,height-height*0.07-width*2/8);
      pg.text("15m",width/2+10,height-height*0.07-width*3/8);
      
      pg.endDraw();
      image(pg, 0, 0); 
      pg.save("img.png");
   }
  
}
