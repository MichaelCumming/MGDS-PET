$fn = 100;
outerRad = 4.0;
innerRad = 3.5;

module cir() {
	difference() {
		circle(r=outerRad, center=true);
		circle(r=innerRad, center=true);
	}
}

module sq() {
	rotate(a=90) {
		translate([-4, -4, 0]) square(4);
	}
}

//module transInnerCir() {
//	translate([34, 0, 0]) cir();
//}

//module innerBand() {
//	for (i = [0:24]) {
//		rotate(a=i*15, v=[0, 0, 1]) transInnerCir();
//	}
//}

module threeQuarters() {
	difference() {
		cir();
		sq();
	}
}

threeQuarters();
rotate(a=-45, [0, 0, 0]) {
translate([7.5, 0, 0]) { 
	threeQuarters();
}
}

