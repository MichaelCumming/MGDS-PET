// Meander Band
// 2014-07-15
// Michael Cumming

$fn = 60;

//input parameters:
_numberDivs = 28; //around a 360 circle =>24
_innerBandRad = 30; //inner radius of band =>30
_outerBandRad = 38; //outer radius of band =>38
_bandHeight = 15; //_bandHeight of band =>15
_wallThickness = 0.5; //=> 0.5
_gapDim = 1.5; //gap between both inner and outer surfaces => 1.5
_gapBetweenHousings = 0.5;
_channelRad = 1; //half of side of channel

//calculated values:
divAngle = 360/_numberDivs;
halfDivAngle = divAngle/2;
innerGapAngle = asin((_gapDim/2)/_innerBandRad)*2; //angle between arcs
////echo("innerGapAngle: ", innerGapAngle);
outerGapAngle = asin((_gapDim/2)/_outerBandRad)*2; //angle between arcs
////echo("outerGapAngle: ", outerGapAngle);
centerLineInnerRad = _innerBandRad-(_wallThickness/2);
centerLineOuterRad = _outerBandRad-(_wallThickness/2);
centerlineRad = (_innerBandRad-_wallThickness+_outerBandRad)/2; //centerline
halfBandHeight = _bandHeight/2;

//trig: see MC's diagram for key; use centerline dims
//angles
A = innerGapAngle/2;
////echo("A: ", A);
B = halfDivAngle-(outerGapAngle/2); //==outerShellAngle/2
//echo("B: ", B);
//sides
a = centerLineInnerRad;
//echo("a: ", a);
b = centerLineOuterRad;
//echo("b: ", b);
ax1 = cos(A)*a;
//echo("ax1: ", ax1);
ay1 = sin(A)*a;
//echo("ay1: ", ay1);

bx1 = cos(B)*b;
//echo("bx1: ", bx1);
by1 = sin(B)*b;
//echo("by1: ", by1);
ax2 = bx1-ax1;
//echo("ax2: ", ax2);
ay2 = by1-ay1;
//echo("ay2: ", ay2);
C = atan2(ay2, ax2);
//echo("C: ", C);
c = sqrt(pow(ax2, 2) + pow(ay2, 2));
//echo("c: ", c);
cSide = ay2/sin(C); //checking
//echo("cSide: ", cSide);
bSide = sqrt(pow(by1, 2) + pow(bx1, 2)); //checking
//echo("bSide: ", bSide);
ay3 = (_wallThickness/2)/cos(C);
//echo("ay3: ", ay3);


innerShellAngle = divAngle-innerGapAngle;
////echo("innerShellAngle: ", innerShellAngle);
outerShellAngle = divAngle-outerGapAngle;
////echo("outerShellAngle: ", outerShellAngle);

//2D triangle constructed as a polygon
module triangle(pieSide, pieAngle, startAngle) {
	center = [0,0];
	topEdge = [cos(pieAngle)*pieSide, sin(pieAngle)*pieSide];
	bottomEdge = [pieSide, 0];

	rotate(a=startAngle)
	polygon(points = [ center, bottomEdge, topEdge ], convexity=10);
}


//an arc shell that intersects with a triangle
module arcShell(outerRadius, cutoutAngle, startAngle) {
	rotate(a=-cutoutAngle/2) {
		linear_extrude(height=_bandHeight, center=false, convexity=10, twist=0)
		intersection() {
			difference() {
				circle(outerRadius);
				circle(outerRadius-_wallThickness);
			}
			triangle(outerRadius*4, cutoutAngle, startAngle);
		}
	}
}

module outerArcShell() {
	arcShell(_outerBandRad, outerShellAngle, 0);
}

module innerArcShell() {
	rotate(a=halfDivAngle)
	arcShell(_innerBandRad, innerShellAngle, 0);
} 

//wall- forms side of housing; 'far side' of start angle
//sample: startSideWall(0, outerHousingRad);
module straightWall() {
	translate([ax1, ay1-ay3, 0])
	rotate(a=C)
	cube([c, _wallThickness, _bandHeight]);
}

//cube([_wallThickness, by1, _bandHeight]);
//cylindrical 'joints' where the arcs meet
//makes rounded corners
module joints() {	
	rotate(a=innerGapAngle/2)
	translate([centerLineInnerRad, 0, 0])
	cylinder(r=_wallThickness/2, h=_bandHeight);

	rotate(a=innerShellAngle+(innerGapAngle/2))
	translate([centerLineInnerRad, 0, 0])
	cylinder(r=_wallThickness/2, h=_bandHeight);
	
	rotate(a=halfDivAngle-(outerGapAngle/2))
	translate([centerLineOuterRad, 0, 0])
	cylinder(r=_wallThickness/2, h=_bandHeight);

	rotate(a=-(halfDivAngle-(outerGapAngle/2)))
	translate([centerLineOuterRad, 0, 0])
	cylinder(r=_wallThickness/2, h=_bandHeight);
}

module oneLink() {
	outerArcShell();
	innerArcShell();
	joints();
	straightWall();
	mirror([0, 1, 0]) straightWall(); //mirror image
}

//oneLink();
//make a bracelet
module oneBand() {
	//for (i = [0 : 2]) {
	for (i = [0 : _numberDivs]) {
		rotate(a=divAngle*i)
		oneLink();
	}
}

//shape to create a hole channel through the middle of the band
module channel() {
	translate([0, 0, halfBandHeight-_channelRad])
	rotate_extrude(convexity = 10, $fn = 100)
	translate([centerlineRad-_channelRad, 0, 0])
	square(_channelRad*2, $fn = 100); //radius = half side of square
}

//band minus a channel
module bandMinusChannel() {
	difference() {
		union() {
			oneBand();
			//oneLink();
		}
		channel();
	}
}

//oneLink();
//oneBand();
bandMinusChannel();


