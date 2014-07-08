// Fully Parameterized Wavey Band
// 2014-07-04
// Michael Cumming

$fn = 60;

_numberDivs = 24; //around a 360 circle
_innerBandRad = 30; //radius of whole band
_bandHeight = 15.0; //_bandHeight of band
_wallThickness = 0.5;
_outerSmallRad = 4.0; //outer radius of small circles

//calculated values:
innerRad = _outerSmallRad-_wallThickness; //inner radius of small circles
ang_A = (360/_numberDivs)/2; //angle between inner and outer cirs
circSeparation = (_outerSmallRad*2)-_wallThickness;
centerLineRad = (_outerSmallRad+innerRad)/2; //centerline of circles
innerCirCenter = _innerBandRad+_outerSmallRad; //=>34
echo("innerCirCenter: ", innerCirCenter);
halfBandHeight = _bandHeight/2;
echo("halfBandHeight: ", halfBandHeight);

//trig -----------------
a1 = cos(ang_A)*innerCirCenter;//inner portion of outerCirCenter
//echo("a1: ", a1);
c1 = sin(ang_A)*innerCirCenter;//dist between 1st and 2nd arcs
////echo("c1: ", c1);
//pythagorean:
a2 = sqrt(pow(circSeparation, 2) - pow(c1, 2)); //outer portion of outerCirCenter
//a2 = sqrt(a22);
//echo("a2: ", a2);
outerCirCenter = a1+a2;
echo("outerCirCenter: ", outerCirCenter);

averageCirCenter = (innerCirCenter+outerCirCenter)/2;
echo("averageCirCenter: ", averageCirCenter);

ang_Ai = atan2(c1, a1); //same as 'ang_A'
//echo("ang_Ai: ", ang_Ai);

ang_B = atan2(c1, a2);
//echo("ang_B: ", ang_B);

ang_Bx = 180-ang_B;
//echo("ang_Bx: ", ang_Bx);

ang_Bpie = ang_Bx*2;
//echo("ang_Bpie: ", ang_Bpie);

ang_C1 = 90-ang_B;
//echo("ang_C1: ", ang_C1);

ang_C2 = 180-(ang_A + ang_B + ang_C1);
//echo("ang_C2: ", ang_C2);

ang_Cx = ang_C1 + ang_C2;
//echo("ang_Cx: ", ang_Cx);

ang_Cpie = ang_Cx*2;
//echo("ang_Cpie: ", ang_Cpie);

angX = ang_Bx-ang_Cx;
//echo("angX: ", angX);


//-------------------------------------------------
//the triangle that cuts from the circle
module triangle(pieDiameter, pieAngle) {
	center = [0,0];
	topEdge = [cos(pieAngle)*pieDiameter, sin(pieAngle)*pieDiameter];
	bottomEdge = [pieDiameter, 0];
	polygon(points = [ center, bottomEdge, topEdge ], convexity=10);
}

//the circle with a triangle cut from it
module arcShell(pieAngle) {
	rotate(a=-pieAngle/2) {
		linear_extrude(height=_bandHeight, center=false, convexity=10, twist=0)
		difference() {
			difference() {
				circle(_outerSmallRad);
				circle(_outerSmallRad-_wallThickness);
			}
			triangle(_innerBandRad, pieAngle);
		}
	}
}

module innerArc() {
	rotate(a=ang_A)
	translate([innerCirCenter, 0, 0]) 
	rotate(a=180) 
	arcShell((ang_C1+ang_C2)*2);
}

module outerArc() {
	translate([a1+a2, 0, 0])
	arcShell(ang_Bx*2);
}

module oneBand() {
	for (i = [0 : 2]) {
	//for (i = [0 : 360/_numberDivs]) {
		rotate(a=360/_numberDivs*i)
		union() {
			innerArc();
			outerArc();
		}
	}
}

module torus() {
	rotate_extrude(convexity = 10, $fn = 100)
	translate([averageCirCenter, 0, 0])
	circle(r =1.5, $fn = 100);
}

difference() {
	oneBand();
	translate([0, 0, halfBandHeight]) torus();
}
