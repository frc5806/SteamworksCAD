res = 80;

ball_diameter = 5;

wheel_or = 2;
compression = 0.125;
hood_ir = wheel_or - compression + ball_diameter; // Ball diameter
hood_thickness = 0.0625; // Assuming steel for now
hood_or = hood_ir + hood_thickness;

ball_channel_gap = 0.125;
divider_width = 0.125;

hood_width = 2 * (ball_diameter + ball_channel_gap) + 3 * divider_width;

add_trans = 1.5;
hood_length = hood_or + add_trans; //Ensures covers all.

hood_angle = 80;

flywheel_rad = 5;
flywheel_thickness=0.5;

module hood() {
	union() {
	    translate([0,-hood_width/2,hood_or]) rotate([-90])
	    linear_extrude(height = hood_width) intersection() {
	        difference() {
	            circle(hood_or, $fn=res);
	            circle(hood_ir, $fn=res);
	        }
	        rotate([0,0,90-hood_angle]) square([hood_or, hood_or]);
	        square([hood_or, hood_or]);
	    }
		translate([(-add_trans)/2,0])
		linear_extrude(height=hood_thickness)
		square([add_trans,hood_width],center=true);
	}
}

module divider(rad) {
	hex_bearing_or = 1.125/2;

	translate([0,0,hood_ir]) rotate([90,90,0]) translate([0,0,-divider_width/2])
	linear_extrude(height=divider_width) difference() {
		union() {
			union() {
				intersection() {
					circle(hood_ir, $fn=res);
					square([hood_ir, hood_ir]);
					rotate([0,0,hood_angle-90]) square([hood_ir, hood_ir]);
				}
				theta = acos(add_trans/hood_ir);
				polygon([[0,0],[cos(hood_angle)*hood_ir,sin(hood_angle)*hood_ir],[-add_trans*sin(theta), add_trans*cos(theta)]]);
			}
			translate([0,hood_or-hood_length]) square([hood_ir, add_trans]);
			intersection() {
				circle(add_trans, $fn=res);
			}
		}
		circle(hex_bearing_or, $fn=res);
	}
}

module wheel() {
	rotate([90,0]) translate([0,0,-0.5]) linear_extrude(height=1) difference() {
		circle(wheel_or, $fn=res);
		circle(0.5/sqrt(3), $fn=6);
	}
}

module flywheel() {
	translate()
	linear_extrude(height=flywheel_thickness) difference() {
		circle(flywheel_rad, $fn=res);
		for(i=[1:6]) rotate([0,0,60*i])
	}
}

flywheel();

module hex_axle(diameter, length) {
    cylinder(length, diameter/sqrt(3), diameter/sqrt(3), $fn=6);
}

module shooter() {

	hood();

	translate([0,(divider_width+ball_diameter+ball_channel_gap)/2,hood_ir]) wheel();
	translate([0,-(divider_width+ball_diameter+ball_channel_gap)/2,hood_ir]) wheel();

	divider();
	translate([0,(hood_width-divider_width)/2]) divider();
	translate([0,-(hood_width-divider_width)/2]) divider();
    
}

//shooter();