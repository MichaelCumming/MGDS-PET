$fn = 60;

numberDivs = 24; //around a 360 circle
innerBandRad = 30; //radius of whole band
height = 15.0; //height of band
wallThickness = 0.5;
outerRad = 4.0; //radius of small circles

innerRad = outerRad-wallThickness;
ang_A = (360/numberDivs)/2; //angle between inner and outer cirs

circSeparation = (outerRad*2)-wallThickness;
centerLineRad = (outerRad+innerRad)/2; //centerline of circles
innerCirCenter = innerBandRad+outerRad; //=>34

//trig -----------------
a1 = cos(ang_A)*innerCirCenter;//inner portion of outerCirCenter
echo("a1: ", a1);
c1 = sin(ang_A)*innerCirCenter;//dist between 1st and 2nd arcs
//echo("c1: ", c1);
//pythagorean:
a2 = sqrt(pow(circSeparation, 2) - pow(c1, 2)); //outer portion of outerCirCenter
//a2 = sqrt(a22);
echo("a2: ", a2);
outerCirCenter = a1+a2;
//echo("outerCirCenter: ", outerCirCenter);g_2

ang_Ai = atan2(c1, a1); //same as 'ang_A'
echo("ang_Ai: ", ang_Ai);

ang_B = atan2(c1, a2);
echo("ang_B: ", ang_B);

ang_Bx = 180-ang_B;
echo("ang_Bx: ", ang_Bx);

ang_Bpie = ang_Bx*2;
echo("ang_Bpie: ", ang_Bpie);

ang_C1 = 90-ang_B;
echo("ang_C1: ", ang_C1);

ang_C2 = 180-(ang_A + ang_B + ang_C1);
echo("ang_C2: ", ang_C2);

ang_Cx = ang_C1 + ang_C2;
echo("ang_Cx: ", ang_Cx);

ang_Cpie = ang_Cx*2;
echo("ang_Cpie: ", ang_Cpie);

angX = ang_Bx-ang_Cx;
echo("angX: ", angX);

//----------------------

module baseCir() {
	cylinder(r=centerLineRad, h=height);
}

//baseCir();

module twoCircs() {
	translate ([0, innerCirCenter, 0]) baseCir();
	rotate(a=ang_A) translate ([0, outerCirCenter, 0]) baseCir();
}

twoCircs();









//---------------------------------------
// 3/4 cylinder
module c1() {
	difference() {
		cylinder(r=outerRad, h=height);
		union() { 
			cylinder(r=innerRad, h=height);
			cube(size=[outerRad, outerRad, height]); 
		}
	}
}

//2nd circle 
module c2() {
	translate([outerRad+innerRad, 0, 0]) rotate(a=180) c1();
}

module oneLink_old() {
	union() {
		c1();
		c2();
	}
}
//oneLink();



