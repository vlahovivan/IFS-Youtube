/*

Created by Ivan Vlahov
u/spiritcs

If you want to share anything made using this program,
please give me credit by linking my Youtube channel
and the video link below:

https://www.youtube.com/user/ivanvlahov922
https://youtu.be/km-ctEk8-lE

*/

// Code may not be optimised


String saveDirectory = "";

float mhw, mhh; // left side of the screen, menu half width and menu half height
float shw, shh; // right side of the screen, square half width and square half height
float tx, ty; 	// translation values for x and y


int tIndex = 0; // index of the current Transformation in the menu

ArrayList<Transformation> tList = new ArrayList<Transformation>(); // list of all the transformations
ArrayList<Slider> sList = new ArrayList<Slider>(); // list of all the sliders
Slider a, b, c, d, e, f, weight; // all the sliders

boolean simulationGoing = false, simulationStarted = false; // variable that is true if and only if the simulation is currently happening 
float simX = random(-1.0, 1.0), simY = random(-1.0, 1.0), simNewX, simNewY; // simulation variables
ArrayList<Float> weightConds = new ArrayList<Float>(); 
float maxWeight, randVar;

boolean displayDomains = true;
boolean keysCanWork = true;

void setup() {
	fullScreen();


// Code used to determine the path where the program saves frames
	if(System.getProperty("os.name").contains("Windows")){
		saveDirectory = "C:\\Users\\" + System.getProperty("user.name") + "\\Pictures\\AppIFS\\";
	}

// Setup
	tx = width-height/2.0;
	ty = height/2.0;

	shw=height/2;
	shh=height/2;

	mhw = (width-height)/2;
	mhh = height/2;
 
	tList.add(new Transformation());

	float const1 = 1.0; // min and max for a and d
	float const2 = 4.0; // min and max for b and c

	a = new Slider(1.4*mhw, 0.05*mhh, -shw-mhw, -0.55*mhh, -const1, const1, color(220, 180, 180));
	b = new Slider(1.4*mhw, 0.05*mhh, -shw-mhw, -0.35*mhh, -const2, const2, color(220, 180, 180));
	c = new Slider(1.4*mhw, 0.05*mhh, -shw-mhw, -0.15*mhh, -const2, const2, color(220, 180, 180));
	d = new Slider(1.4*mhw, 0.05*mhh, -shw-mhw, 0.05*mhh, -const1, const1, color(220, 180, 180));
	e = new Slider(1.4*mhw, 0.05*mhh, -shw-mhw, 0.25*mhh, -1.0, 1.0, color(220, 180, 180));
	f = new Slider(1.4*mhw, 0.05*mhh, -shw-mhw, 0.45*mhh, -1.0, 1.0, color(220, 180, 180));
	weight = new Slider(1.4*mhw, 0.05*mhh, -shw-mhw, 0.65*mhh, 0.0, 1.0, color(220, 180, 180));

	sList.add(a);
	sList.add(b);
	sList.add(c);
	sList.add(d);
	sList.add(e);
	sList.add(f);
	sList.add(weight);
}

void draw() {


	translate(tx, ty);

	if(!simulationGoing){
		background(0, 0, 0);

	// Menu screen
		fill(220, 180, 180);

		// Menu screen text
		textSize(28);
		textAlign(CENTER);
		text("Transformation " + (tIndex+1), -shw-mhw, -0.75*mhh);

		textSize(16);
		text("A: " + tList.get(tIndex).a, -shw-mhw, -0.60*mhh);
		text("B: " + tList.get(tIndex).b, -shw-mhw, -0.40*mhh);
		text("C: " + tList.get(tIndex).c, -shw-mhw, -0.20*mhh);
		text("D: " + tList.get(tIndex).d, -shw-mhw, 0.00*mhh);
		text("E: " + tList.get(tIndex).e, -shw-mhw, 0.20*mhh);
		text("F: " + tList.get(tIndex).f, -shw-mhw, 0.40*mhh);
		text("Weight: " + tList.get(tIndex).weight, -shw-mhw, 0.60*mhh);
		textSize(10);
		text("Controls: SPACE - add a new transformation, BACKSPACE - delete a transformation,", -shw-mhw, 0.85*mhh); 
		text("LEFT/RIGHT - change transformation, D - toggle domain display, ENTER - start/stop simulation,", -shw-mhw, 0.885*mhh); 
		text("S - save the current frame (Pictures folder, works only on Windows), ESC - close the app", -shw-mhw, 0.92*mhh);
		text("Created by Ivan Vlahov, find me on YouTube!", -shw-mhw, 0.955*mhh);

		// Menu screen sliders
		a.setValue(tList.get(tIndex).a);
		b.setValue(tList.get(tIndex).b);
		c.setValue(tList.get(tIndex).c);
		d.setValue(tList.get(tIndex).d);
		e.setValue(tList.get(tIndex).e);
		f.setValue(tList.get(tIndex).f);
		weight.setValue(tList.get(tIndex).weight);

		// Sliders can only be updated if the simulation is not happening
		if(!simulationGoing) updateSliders();
		tList.get(tIndex).a = a.value;
		tList.get(tIndex).b = b.value;
		tList.get(tIndex).c = c.value;
		tList.get(tIndex).d = d.value;
		tList.get(tIndex).e = e.value;
		tList.get(tIndex).f = f.value;
		tList.get(tIndex).weight = weight.value;


		for(int i=0; i<sList.size(); i++){
			sList.get(i).displaySlider();
		}

	// Main square
		stroke(0,255,0);
		strokeWeight(3);
		noFill();
		beginShape();
		vertex(-1*shw, 1*shh-2);
		vertex(1*shw-2, 1*shh-2);
		vertex(1*shw-2, -1*shh);
		vertex(-1*shw, -1*shh);
		vertex(-1*shw, 1*shh);
		endShape();

		strokeWeight(1);
		line(-1*shw, 0, 1*shw, 0);
		line(0, -1*shh, 0, 1*shh);

	// Drawing domains of all transformations in the array list
		if(displayDomains){
			for(int i=0; i<tList.size(); i++){
				stroke(tList.get(i).tColor);
				strokeWeight(1);

				beginShape();
				vertex(shw*tList.get(i).transformX(-1, 1), shh*tList.get(i).transformY(-1, 1));
				vertex(shw*tList.get(i).transformX(1, 1), shh*tList.get(i).transformY(1, 1));
				vertex(shw*tList.get(i).transformX(1, -1), shh*tList.get(i).transformY(1, -1));
				vertex(shw*tList.get(i).transformX(-1, -1), shh*tList.get(i).transformY(-1, -1));
				vertex(shw*tList.get(i).transformX(-1, 1), shh*tList.get(i).transformY(-1, 1));
				endShape();
			}
		}
	}


	if(simulationGoing && !simulationStarted){

		for(int fr=0; fr<5; fr++){

			point(shw*simX, shh*simY);
			randVar = random(maxWeight);

			for(int i=0; i<tList.size(); i++){
				if(randVar > weightConds.get(i) && randVar < weightConds.get(i+1)){
					simNewX = tList.get(i).transformX(simX, simY);
					simNewY = tList.get(i).transformY(simX, simY);

					stroke(tList.get(i).tColor);
					break;
				}
			}

			simX = simNewX;
			simY = simNewY;

		}
	}

}

// Checks for clicks and updates sliders if the click (and drag) happened inside any of them
void updateSliders() {
	if(mousePressed){
		for(int i=0; i<sList.size(); i++){
			if(sList.get(i).clickInSlider(mouseX-tx, mouseY-ty)){
				if(mousePressed){
					float newValue;
					float leftX = sList.get(i).x-(sList.get(i).w)/2.0;
					float rightX = sList.get(i).x+(sList.get(i).w)/2.0;
		
					if(mouseX-tx < leftX) newValue = sList.get(i).min;
					if(mouseX-tx > rightX) newValue = sList.get(i).max;
		
					newValue = (mouseX-tx-leftX)/(rightX-leftX);
					sList.get(i).setValue(newValue*(sList.get(i).max-sList.get(i).min)+sList.get(i).min);
				}
			}
		}
	}
}


// Keyboard input handling functions

void keyPressed() {
	if(keysCanWork){
		keysCanWork = false;

		if(key == CODED && keyCode == LEFT && !simulationGoing){
			tIndex = (tIndex+tList.size()-1)%tList.size();
		}
		
		if(key == CODED && keyCode == RIGHT && !simulationGoing){
			tIndex = (tIndex+tList.size()+1)%tList.size();
		}

		if(key == ' ' && !simulationGoing){
			tList.add(new Transformation());
			tIndex = tList.size()-1;

		}

		if(key == BACKSPACE && !simulationGoing){
			if(tList.size()>1){
				tList.remove(tIndex);
				tIndex = (tIndex+tList.size()-1)%tList.size();
			}
		}

		if(key == 'd' || key == 'D'){
			displayDomains = !displayDomains;
		}

		if(key == ENTER){
			if(!simulationGoing){
				simulationStarted = false;
				simX = random(-1.0, 1.0);
				simY = random(-1.0, 1.0);

				for(int i=weightConds.size()-1; i>=0; i--) weightConds.remove(i);

				simulationGoing = true;
				weightConds.add(0.0);
				float sum=0.0;
				for(int i=0; i<tList.size(); i++){
					sum+=tList.get(i).weight;
					weightConds.add(new Float(sum));
				}

				maxWeight = weightConds.get(weightConds.size()-1);
				strokeWeight(3);
			
			}else{
				simulationGoing = false;
			}



		}

		if((key == 's' || key == 'S') && System.getProperty("os.name").contains("Windows")){
			saveFrame(saveDirectory + year() + "-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + ".png");
		}

		a.value = tList.get(tIndex).a;
		b.value = tList.get(tIndex).b;
		c.value = tList.get(tIndex).c;
		d.value = tList.get(tIndex).d;
		e.value = tList.get(tIndex).e;
		f.value = tList.get(tIndex).f;
		weight.value = tList.get(tIndex).weight;
	}
}

void keyReleased() {
	keysCanWork = true;
}
