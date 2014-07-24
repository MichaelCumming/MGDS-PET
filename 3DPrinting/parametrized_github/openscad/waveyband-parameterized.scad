// Parameterized Wavey Band
// 2014-07-04
// Michael Cumming

$fn = 60;

_numberDivs = 18; //around a 360 circle =>24
_innerBandRad = 30; //radius of whole band
_bandHeight = 15.0; //_bandHeight of band
_wallThickness = 0.5;
_outerSmallRad = 5.5; //outer radius of small circles =>4
_gapBetweenHousings = 0.5;

//calculated values:
divAngle = 360/_numberDivs;
innerRad = _outerSmallRad-_wallThickness; //inner radius of small circles
ang_A = (divAngle)/2; //angle between inner and outer cirs
circSeparation = (_outerSmallRad*2)-_wallThickness; //=>7.5
centerLineRad = (_outerSmallRad+innerRad)/2; //centerline of circles
innerCirCenter = _innerBandRad+_outerSmallRad; //=>34
//echo("innerCirCenter: ", innerCirCenter);

//for housings that slot into curves
outerSmallRad_reduced = _outerSmallRad-_wallThickness-_gapBetweenHousings;
//echo("outerSmallRad_reduced: ", outerSmallRad_reduced);
outerSmallRad_expanded = _outerSmallRad+_gapBetweenHousings+_wallThickness;
outersmallRad_expCutout = _outerSmallRad+_gapBetweenHousings; // for outer housing circles
//echo("outersmallRad_expCutout(C): ", outersmallRad_expCutout);
//outerSmallRad_reduced = // for inner housing circles

halfBandHeight = _bandHeight/2;
//echo("halfBandHeight: ", halfBandHeight);

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
//echo("outerCirCenter: ", outerCirCenter);

averageCirCenter = (innerCirCenter+outerCirCenter)/2;
//echo("averageCirCenter: ", averageCirCenter);

outerHousingRad = outerCirCenter+(_outerSmallRad*2.5);
//echo("outerHousingRad: ", outerHousingRad);

ang_Ai = atan2(c1, a1); //same as 'ang_A'
//echo("ang_Ai: ", ang_Ai);

ang_B = atan2(c1, a2);
//echo("ang_B: ", ang_B);
c2 = sin(ang_B)*outersmallRad_expCutout; //dist between housing inflection point
//echo("c2: ", c2);
a2x = cos(ang_B)*outersmallRad_expCutout; //dist along x axis to inflection point
//echo("a2x: ", a2x);
a1x = outerCirCenter-a2x; //dist along x axis to inflection point
//echo("a1x: ", a1x);
//echo("a1x+a2x: ", a1x+a2x);
inflAng = atan2(c2, a1x); 
//echo("inflAng: ", inflAng);
inflRad = c2/sin(inflAng);
//echo("inflRad: ", inflRad);

ir2 = pow(inflRad, 2); //pythagorean: to check
//echo("ir2: ", ir2);
p2 = pow(c2,2) + pow(a1x,2); //to check
//echo("p2: ", p2);

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
//OLD: the triangle that cuts from the circle
//(not a great idea to cut triangles from circles)
module triangle(pieSide, pieAngle, startAngle) {
	center = [0,0];
	topEdge = [cos(pieAngle)*pieSide, sin(pieAngle)*pieSide];
	bottomEdge = [pieSide, 0];

	rotate(a=startAngle)
	polygon(points = [ center, bottomEdge, topEdge ], convexity=10);
}

//*******************************vvvvvvv
//wall- forms side of housing; 'far side' of start angle
//sample: startSideWall(0, outerHousingRad);
module startSideWall(startAngle, diameter) {
	rotate(a=startAngle)
	cube([diameter, _wallThickness, _bandHeight]);
}

//wall- forms side of housing; 'near side' of end angle
//sample: endSideWall(45, outerHousingRad);
module endSideWall(endAngle, diameter) {
	rotate(a=endAngle)
	translate([0, -_wallThickness, 0])
	cube([diameter, _wallThickness, _bandHeight]);
}

module outerHousingWall(diameter) {
	difference() {
		cylinder(r=diameter, h=_bandHeight);
		cylinder(r=diameter-_wallThickness, h=_bandHeight);
	}
}

//maskingShape(0, 45, _innerBandRad, outerHousingRad, -_wallthickness);
//generalized pie-shaped masking shape: to be taken away from other shapes
//sample: maskingShape(0, 45, _innerBandRad, outerHousingRad);
module maskingShape(startAngle, endAngle, innerDiameter, outerDiameter, z) {
	h = _bandHeight*2;
	translate([0, 0, z])
	union() {
		cylinder(r=innerDiameter, h);	
		halfCylinder(180+startAngle, outerDiameter*1.25); 
		halfCylinder(endAngle, outerDiameter*1.25);
		difference() {
			cylinder(r=outerDiameter*1.25, h);
			cylinder(r=outerDiameter, h);
		}
	}
}

//test for creating a half-cylinder: used in masking
//sample: halfCylinder(45, outerHousingRad);
module halfCylinder(startAngle, diameter) {
	//h=_bandHeight+(_wallThickness*2);
	h = _bandHeight*2;
	rotate(a=startAngle) //rotate the whole thing
	difference() {
		cylinder(r=diameter, h);
		translate([-diameter, -diameter*2, 0]) //move cube to the underside
		cube([diameter*2, diameter*2, h]); //the cube that takes away
	}
}

//improved version of housing for waveyband
module housingNew(numLinks) {
	startAngle = -divAngle;
	endAngle = divAngle*(numLinks-1);
	innerRad = _innerBandRad+_wallThickness+_gapBetweenHousings;
	difference() {
		union() {
			rotate (a=-divAngle/2)
			//side(-_wallThickness); //side housing
			multiLinkInsert(numLinks); //the links
			endSideWall(endAngle, outerHousingRad); //the radial wall on top
			startSideWall(startAngle, outerHousingRad); //the radial wall below
			outerHousingWall(outerHousingRad); //the outside shell
			//multiLinkSide(numLinks, _bandHeight-_wallThickness); //top side
			multiLinkSide(numLinks, 0); //bottom side			
		}
		union() {
			maskingShape(startAngle, endAngle, innerRad, outerHousingRad, -1);	
		}
	}
}

//housingNew(1);


//*******************************^^^^^^^^^^^^^

//**********sidesForHousing vvvvvvvvvvvvvvvv
module multiLinkSide(numLinks, z) {
	difference() {
		union() {
			for (i = [0 : numLinks-1]) {
				rotate(a=divAngle*i)
				addCircleInner(z, 0);
				addCircleInner(z, -divAngle);
			}
			sideBand(z);
		}
		for (i = [0 : numLinks-1]) {
			rotate(a=divAngle*i)
			subCircleOuter(z, -divAngle/2);
		}
	}
}

//latest: simplest one side only
module sideBand(z) {
	translate([0, 0, z])
	difference() {
		cylinder(r=outerHousingRad, h=_wallThickness); //outer radius
		cylinder(r=inflRad, h=_wallThickness); //take away inner radius
	}
}

module addCircleInner(z, ang) {
	rotate(a=ang)
	translate([innerCirCenter, 0, z])
	cylinder(r=outerSmallRad_reduced, h=_wallThickness);

}

module subCircleOuter(z, ang) {
	rotate(a=ang)
	translate([outerCirCenter, 0, z])
	cylinder(r=outersmallRad_expCutout, h=_wallThickness);
}

//**********sidesForHousing^^^^^^^^^^^^^^^^^

//mirrored along x-axis
//sample: circleWithPieMissing(divAngle*2, outerHousingRad);
module circleWithPieMissing(pieAngle, circleRadius) {
	linear_extrude(height=_bandHeight, center=false, convexity=10, twist=0)
	difference() {
		circle(circleRadius);
		translate([-_wallThickness, 0, 0])
		triangle(outerHousingRad*2, pieAngle, -pieAngle/2);
	}
}

//an arc of thickness=_wallThickness with a triangle cut from it
module arcShell(cutoutAngle, outerRadius, startAngle) {
	rotate(a=-cutoutAngle/2) {
		linear_extrude(height=_bandHeight, center=false, convexity=10, twist=0)
		difference() {
			difference() {
				circle(outerRadius);
				circle(outerRadius-_wallThickness);
			}
			triangle(outerRadius*4, cutoutAngle, startAngle);
		}
	}
}

module innerArc(outerRadius) {
	rotate(a=ang_A)
	translate([innerCirCenter, 0, 0]) 
	rotate(a=180) 
	arcShell((ang_C1+ang_C2)*2, outerRadius, 0);
}

module outerArc(outerRadius) {
	translate([a1+a2, 0, 0])
	arcShell(ang_Bx*2, outerRadius, 0);
}

//for making holes in the sides of a housing
module outerArcCutout(outerRadius) {
	translate([a1+a2, 0, 0])
	arcShell(ang_Bx*2, outerRadius, 0);
}

//one link for wavey bracelet
module oneLinkBracelet() {
	union() {
		innerArc(_outerSmallRad);
		outerArc(_outerSmallRad);
		rotate(a=-divAngle) innerArc(_outerSmallRad);
	}
}


//shape to create a hole channel through the middle of the band
module torus(smallRadius, largeRadius) {
	rotate_extrude(convexity = 10, $fn = 100)
	translate([largeRadius, 0, 0])
	circle(r=smallRadius, $fn = 100);
}

//shape to create a hole channel through the middle of the band
module channel(smallRadius, largeRadius) {
	rotate_extrude(convexity = 10, $fn = 100)
	translate([largeRadius-smallRadius, 0, 0]) //note difference to torus
	square(smallRadius*2, $fn = 100); //radius = half side of square
}

module bandTorus(smallRadius, centerlineRadius) {
	translate([0, 0, halfBandHeight]) 
	torus(smallRadius, centerlineRadius);
	//normally: centerlineRadius=averageCirCenter
	//others: centerlineRadius=innerCirCenter
}

module bandChannel(smallRadius, centerlineRadius) {
	translate([0, 0, halfBandHeight-smallRadius]) 
	channel(smallRadius, centerlineRadius);
	//normally: centerlineRadius=averageCirCenter
	//others: centerlineRadius=innerCirCenter
}

//testing. works 2014-07-14
//bandTorus(1, innerCirCenter);
//bandChannel(1, innerCirCenter);

module oneLinkHousing() {
	union() {
		innerArc(outerSmallRad_reduced);
		outerArc(outerSmallRad_expanded);
		rotate(a=-divAngle) innerArc(outerSmallRad_reduced);
	}
}

//cuts the holes in the sides of a housing
module oneLinkHousingCutout() { 
	union() {
		innerArc(outerSmallRad_reduced);
		outerArc(outerSmallRad_expanded);
		rotate(a=-divAngle) innerArc(outerSmallRad_reduced);
	}
}

//produces the wavey bits that fit into a wavey band
module multiLinkInsert(numLinks) {
	//triangle(outerHousingRad, divAngle*numLinks)
	//arcShell(270, outerHousingRad);
	//arcShell((divAngle)*numLinks, outerHousingRad);
	for (i = [0 : numLinks-1]) {
		rotate(a=divAngle*i)
		oneLinkHousing();
	}
}

//make a bracelet
module oneBand() {
	//for (i = [0 : 2]) {
	for (i = [0 : _numberDivs]) {
		rotate(a=divAngle*i)
		oneLinkBracelet();
	}
}

//band minus the torus channel
module bandMinusTorus(holeRadius, centerlineRadius) {
	difference() {
		//oneBand();
		oneLinkHousing();
		bandTorus(holeRadius, centerlineRadius);
		//bandChannel(radius);
	}
}

//band minus the torus channel
module bandMinusChannel(holeRadius, centerlineRadius) {
	difference() {
		union() {
			//oneBand();
			//oneLinkHousing();
			housingNew(3);
		}
		//bandTorus();
		bandChannel(holeRadius, centerlineRadius);
	}
}

//housing(2);
//oneBand();

//housingNew(1);
bandMinusChannel(1.5, averageCirCenter);
//bandMinusTorus();
//oneLinkHousing();
//oneLinkBracelet();
//oneBand();
