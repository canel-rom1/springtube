/****************************************************/
/* Project name: springTube                         */
/* File: springTubes.scad                           */
/* Version: v1.2                                    */
/* Create by: Rom1 <rom1@canel.ch>                  */
/*            CANEL - https://www.canel.ch          */
/* Date: 01 mai 2017                                */
/* License: GNU GENERAL PUBLIC LICENSE v3           */
/* Programme: openscad                              */
/* Description: Test's tube support like spring     */
/****************************************************/


/*************/
/* Variables */
/*************/

thinkness = 2;                              // Thinkness

numbres_tubes = 1;                          // Numbers of test tubes
tube_diameter = 15.5;                       // Diameter test tube
spring_space = 22;                          // Space between the spring
base_length = 80;                           // Base's length
spring_width = tube_diameter + 2*thinkness; // Spring's length
numbers_coils = 4;                          // Numbers of spring coils
width = spring_width + 6;                   // Width


/***********/
/* Modules */
/***********/

module halfCircle(dia = 20, tn = 2, orient = 0) {
	translate([0, (dia + tn)/2, 0])
	difference(){
		circle(d = dia + tn);
		circle(d = dia - tn);
		rotate([0, 0, orient]) translate([0, -(dia + tn)/2]) square([(spring_space + tn)/2, spring_space + tn]);
	}
}

module halfLoop(orient = "left", end = "no"){
	module piece(){
		halfCircle(spring_space, thinkness);
		translate([0, spring_space]) square([spring_width, thinkness]);
		if(end == "yes"){
			translate([spring_width, spring_space]) square([spring_space/2, thinkness]);
		}
	}
	if(orient == "left") {
		piece();
	}
	if(orient == "right"){
		mirror([1, 0, 0]) piece();
	}
}

module loop(orient = "left", end = "no"){
	module piece(orient = "left"){
		halfLoop();
		translate([spring_width, spring_space]) mirror([1, 0, 0]) halfLoop();
		if(end == "yes"){
			translate([-spring_space/2, 2*spring_space]) square([spring_space/2, thinkness]);
		}
	}
	if(orient == "left"){
		piece();
	}
	if(orient == "right"){
		mirror([1, 0, 0]) piece();
	}
}

module form3d(height){
	linear_extrude(height) {
        if(numbres_tubes > 1){
            square([base_length, thinkness]);    // Base
        }else{
            square([spring_width + spring_space/2, thinkness]);
        }

		if(numbers_coils % 2 == 0){
			if(numbers_coils == 2){
                translate([0, (numbers_coils - 2)*spring_space]) loop("left", end = "yes");
                if(numbres_tubes >=1){
                    translate([base_length, (numbers_coils - 2)*spring_space]) loop("right", end = "yes");
                }
			}else{
				for(i = [0:numbers_coils/2-1]){
                    translate([0, i*2*spring_space]) loop("left");
                    if(numbres_tubes > 1){
                        translate([base_length, i*2*spring_space]) loop("right");
                    }
				}
                translate([0, (numbers_coils - 2)*spring_space]) loop("left", end = "yes");
                if(numbres_tubes > 1){
                    translate([base_length, (numbers_coils - 2)*spring_space]) loop("right", end = "yes");
                }
			}
		}else{
			if(numbers_coils == 1){
                translate([0, (numbers_coils - 1)*spring_space]) halfLoop("left", end = "yes");
                if(numbres_tubes > 1){
                    translate([base_length, (numbers_coils - 1)*spring_space]) halfLoop("right", end = "yes");
                }

			}else{
				for(i = [0:numbers_coils/2-1]){
					translate([0, 2*i*spring_space]) loop("left");
                    if(numbres_tubes > 1){
                        translate([base_length, 2*i*spring_space]) loop("right");
                    }
				}
					translate([0, (numbers_coils - 1)*spring_space]) halfLoop("left", end = "yes");
                    if(numbres_tubes > 1){
                        translate([base_length, (numbers_coils - 1)*spring_space]) halfLoop("right", end = "yes");
                    }
			}
		}
	}
}


/********/
/* Main */
/********/

difference(){
	form3d(width);
	translate([spring_space/2, thinkness, width/2]) rotate([270, 0, 0]) cylinder(d = tube_diameter, h = numbers_coils*spring_space+thinkness);
    if(numbres_tubes > 1){
        translate([base_length - spring_space/2, thinkness, width/2]) rotate([270, 0, 0])
            cylinder(d = tube_diameter, h = numbers_coils*spring_space+thinkness);
    }
}


// vim: ft=openscad tw=100 et ts=4 sw=4
