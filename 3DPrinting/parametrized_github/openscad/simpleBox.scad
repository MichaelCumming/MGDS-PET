// Parameterized Simple Enclosure Box
// 2014-07-07
// Michael Cumming

$fn = 60;

_innerWidth = 15; //'x' dim = inner cavity height
_innerDepth = 15; //'y' dim = inner cavity height
_innerHeight = 8; //'z' dim = inner cavity height

_wallThickness = 1.25;
_lipGap = 0.25; //gap between inner and outer gap

outerWidth = _innerWidth + (_wallThickness*2);
outerDepth = _innerDepth + (_wallThickness*2);
outerHeight = _innerHeight + (_wallThickness*2);
lipThickness = (_wallThickness-_lipGap)/2;

//--------------------------------------
module outerCubeHalf() {
	cube([outerWidth, outerWidth, outerHeight/2], center = false);
}
module innerCubeHalf() {
	cube([_innerWidth, _innerDepth, _innerHeight/2], center = false);
}

module halfBox() {
	difference() {
		outerCubeHalf();
		translate([_wallThickness, _wallThickness, 0]) innerCubeHalf();
	}
}

module outsideLip() {
	difference() {
		translate([0, 0, -lipThickness])
		cube([outerWidth, outerDepth, lipThickness], center = false);
		//inner cutout
		translate([lipThickness, lipThickness, -lipThickness])
		cube([
			outerWidth-(lipThickness*2), 
			outerDepth-(lipThickness*2), 
			lipThickness], 
			center = false);
	}
}

module insideLip() {
	difference() {
		translate([lipThickness+_lipGap, lipThickness+_lipGap, -lipThickness])
		cube([
		_innerWidth+(lipThickness*2), 
		_innerDepth+(lipThickness*2), 
		lipThickness], 
		center = false);
		//inner cutout
		translate([_wallThickness, _wallThickness, -lipThickness])
		cube([_innerWidth, _innerDepth, lipThickness], center = false);
	}	
}

module topBox() {
	union() {
		halfBox();
		outsideLip();	
	}
}

module bottomBox() {
	union() {
		halfBox();
		insideLip();	
	}
}

translate([outerWidth*2, 0, 0]) topBox();
bottomBox();
//insideLip();
