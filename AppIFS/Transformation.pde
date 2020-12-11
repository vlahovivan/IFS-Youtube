/*

Created by Ivan Vlahov
u/spiritcs

If you want to share anything made using this program,
please give me credit by linking my Youtube channel
and the video link below:

https://www.youtube.com/user/ivanvlahov922
https://youtu.be/km-ctEk8-lE

*/


public class Transformation{
	public float a;
	public float b;
	public float c;
	public float d;
	public float e;
	public float f;

	public color tColor;
	public float weight;

	// Default values
	Transformation(){
		this.a = 0.5;
		this.b = 0;
		this.c = 0;
		this.d = 0.5;
		this.e = 0;
		this.f = 0;
		this.tColor = color(random(100, 255), random(100, 255), random(100, 255));
		this.weight = 0.5;
	}

	void setValues(float a, float b, float c, float d, float e, float f){
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
		this.e = e;
		this.f = f;
	}

	void changeColor(color tColor){
		this.tColor = tColor;
	}

	float transformX(float x, float y){
		return a*x+b*y+e;
	}

	float transformY(float x, float y){
		return c*x+d*y+f;
	}
}
