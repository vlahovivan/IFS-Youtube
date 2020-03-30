/*

Created by Ivan Vlahov
u/spiritcs

If you want to share anything made using this program,
please give me credit by linking my Youtube channel
and the video link below:

https://www.youtube.com/user/ivanvlahov922
https://youtu.be/km-ctEk8-lE

*/


public class Slider{
	public float w;
	public float h;
	public float x;
	public float y;
	public float value;
	public float min;
	public float max;
	public color bottomColor;
	public color topColor;

	Slider(float w, float h, float x, float y, float min, float max, color bottomColor){
		this.w = w;
		this.h = h;
		this.x = x;
		this.y = y;
		this.min = min;
		this.max = max;
		this.bottomColor = bottomColor;

		this.topColor = color(0.6*red(bottomColor), 0.6*green(bottomColor), 0.6*blue(bottomColor));
		this.value = (min+max)/2.0;
	}

	void setValue(float value){
		this.value = value;
	}

// Displays the slider, (x, y) is the CENTER point of the slider!!!
	void displaySlider(){
		noStroke();
		fill(this.bottomColor);
		rect(x-w/2.0, y-h/2.0, w, h);
		fill(this.topColor);
		rect(x-w/2.0, y-h/2.0, w*(value-min)/(max-min), h);
	}

// Returns true if the click was inside the slider
	boolean clickInSlider(float mx, float my){
		return (mx > this.x-this.w/2.0) && (mx < this.x+this.w/2.0) && (my > this.y-this.h/2.0) && (my < this.y+this.h/2.0);
	}

}
