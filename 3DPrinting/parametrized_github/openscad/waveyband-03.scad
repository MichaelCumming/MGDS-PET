$fn = 60;
outerRad = 4.0;
innerRad = 3.5;
height = 15.0;

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

//
module c2() {
	translate([outerRad+innerRad, 0, 0]) rotate(a=180) c1();
}

module oneLink() {
	union() {
		c1();
		c2();
	}
}
oneLink();



