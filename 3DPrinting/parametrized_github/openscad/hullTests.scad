// Meander Band
// 2014-07-15
// Michael Cumming

$fn = 100;

//linear_extrude(height=25.4, center=true, convexity=10, twist=35)
//hull() {
//difference() {
//	square(10, center=true);
//	square(9.75, center=true);
//}
//}

module h1() {
	hull() {
		translate([0,4,16]) cylinder(r=2, h=.25);
		translate([0,3,12]) cylinder(r=5, h=.25);
		translate([0,2,8]) cylinder(r=6, h=.25);
		translate([0,1,4]) cylinder(r=5.8, h=.25);
		cylinder(r=2, h=.25);
	}
}

module h2() {
	hull() {
		rotate(a=75)
		translate([0, 2, 24])
		cube([5, 4, .25]);
		cube([5, 4, .25]);
	
	}
}

//propeller shape
module h3() {
	hull() {
		for (i = [1 : 12]) {
			rotate(a=4*i) 
			scale([1,1*i,1]) translate([0,0,i*1.1]) 
			cylinder(r=6, h=0.1);
		}
	}
}

_sliceThickness = .01;

module canoeSlice() {
	scale([1, 1, 0.65]) //squish into a canoe shape
	rotate(a=90, v=[0, 1, 0])
	difference() {
		cylinder(r=6, h=_sliceThickness);
		halfCylinder(90, 8); //take off top half
	}
}

module canoeRib() {
	difference() {
		canoeSlice();
		translate([-_sliceThickness,0,0]) 
		scale([6, 0.96, 0.95]) canoeSlice();
	}
}

//test for creating a half-cylinder: used in masking
//sample: halfCylinder(45, outerHousingRad);
module halfCylinder(startAngle, diameter) {
	//h=_bandHeight+(_wallThickness*2);
	h = 0.2;
	rotate(a=startAngle) //rotate the whole thing
	difference() {
		cylinder(r=diameter, h);
		translate([-diameter, -diameter*2, 0]) //move cube to the underside
		cube([diameter*2, diameter*2, h]); //the cube that takes away
	}
}

//hulls doesn't do much; linear extrude doesn't work on 3D items
module canoe01() {
	canoeRib();
	scale([]) translate([5,0,0]) canoeRib();
}

//canoe01();

//A difference approach: using flattened sphere to make canoes
module hemisphere(radius) {
	difference() {
		sphere(radius, center=true);
		translate([-radius, -radius, 0]) cube(radius*2);
	}
}

module canoeSolid(length) {
	scale([0.2, 1, 0.2]) hemisphere(length);

}

module canoeHollowHull(length) {
	difference() {
		canoeSolid(length);
		scale([1, 0.96, 0.95]) canoeSolid(length);
	}
}

canoeHollowHull(60);


