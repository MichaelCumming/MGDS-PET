$fn = 100;
outerRad = 4.0;
innerRad = 3.5;

module cir() {
	difference() {
		circle(r=outerRad, center=true);
		circle(r=innerRad, center=true);
	}
}

module transInnerCir() {
	translate([34, 0, 0]) cir();
}

//module innerBand() {
//	for (i = [0:24]) {
//		rotate(a=i*15, v=[0, 0, 1]) transInnerCir();
//	}
//}

transInnerCir();

