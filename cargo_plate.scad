$fa = 0.5; // default minimum facet angle is now 0.5
$fs = 0.5; // default minimum facet size is now 0.5 

wall_thickness = 2.5;
wall_height = 5;

plate_width = 31;
plate_height = 68;

plate_thickness = 3;

hole_cutout_width = 5;
hole_cutout_camera = 4;

recession = 1.5;

camera_length = 22;
camera_width = 10.5;
camera_height = 14.0;
camera_wall = 2;

rubber_hole_inside = 4.5;
rubber_hole_thickness = 2.5;

chip_width = 21;
chip_height = 36;

chip_offset = 9;
camera_cutout_offset = 50;

rubber_offset = 28; // center of hole

t_width=6;
t_height=5;
t_cross=2;

module t() {
    translate([0,t_height-t_cross,0]) cube([t_width,t_cross,plate_thickness]);
    translate([(t_width-t_cross)/2,0,0]) cube([t_cross,t_height-t_cross,plate_thickness]);
}

module rubber_hole(solid=false) {
    
    height = solid ? plate_thickness+2 : plate_thickness;
    z = solid ? -1 : 0;
    difference() {
        translate([0,0,z]) cylinder(h=height, r=(rubber_hole_inside/2)+rubber_hole_thickness);
        if (!solid) {
        translate([0,0,-1]) 
            cylinder(h=plate_thickness+2, r=rubber_hole_inside/2);
        }
    }
}

module cc() {
    translate([0,1,0]) rotate([90,0,0]) 
        cylinder(h=camera_wall+2, r=hole_cutout_camera/2, center=true, $fn=6);
}
cc();

difference() {
    space_y = (camera_height - 2 * hole_cutout_camera)/3;
    space_x = (camera_length - 2 * hole_cutout_camera)/3;
    
    union() {
        cube([plate_width, plate_height, plate_thickness]);
        difference() {
            translate([(plate_width-camera_length)/2, camera_cutout_offset-camera_wall, plate_thickness]) 
                cube([camera_length, camera_wall, camera_height]);
            translate([(plate_width)/2, camera_cutout_offset-camera_wall, space_y+hole_cutout_camera/2+plate_thickness])
                cc();
            translate([(plate_width)/2, camera_cutout_offset-camera_wall, 2*space_y+1.5*hole_cutout_camera+plate_thickness])
                cc();
            
            translate([(plate_width)/2-(space_x+hole_cutout_camera/2), camera_cutout_offset-camera_wall, space_y+hole_cutout_camera/2+plate_thickness])
                cc();
            translate([(plate_width)/2-(space_x+hole_cutout_camera/2), camera_cutout_offset-camera_wall, 2*space_y+1.5*hole_cutout_camera+plate_thickness])
                cc();

            translate([(plate_width)/2+(space_x+hole_cutout_camera/2), camera_cutout_offset-camera_wall, space_y+hole_cutout_camera/2+plate_thickness])
                cc();
            translate([(plate_width)/2+(space_x+hole_cutout_camera/2), camera_cutout_offset-camera_wall, 2*space_y+1.5*hole_cutout_camera+plate_thickness])
                cc();

        }
    }
    
    translate([(plate_width-camera_length)/2, camera_cutout_offset, plate_thickness-recession]) 
        cube([camera_length, camera_width, recession+1]);
    translate([(plate_width-chip_width)/2, chip_offset, plate_thickness-recession]) 
        cube([chip_width,chip_height,recession+1]);
    translate([0,rubber_hole_inside/2+rubber_hole_thickness,0]) 
        rubber_hole(true);
    translate([plate_width,rubber_hole_inside/2+rubber_hole_thickness])         
        rubber_hole(true);
    translate([0, rubber_offset, 0])         
        rubber_hole(true);
    translate([0,plate_height-(rubber_hole_inside/2+rubber_hole_thickness),0]) 
        rubber_hole(true);
    translate([plate_width,plate_height-(rubber_hole_inside/2+rubber_hole_thickness),0])         
        rubber_hole(true);


}
translate([0,rubber_hole_inside/2+rubber_hole_thickness,0]) rubber_hole();
translate([plate_width,rubber_hole_inside/2+rubber_hole_thickness]) rubber_hole();
translate([0, rubber_offset, 0]) rubber_hole(false);
translate([0,plate_height-(rubber_hole_inside/2+rubber_hole_thickness),0]) 
    rubber_hole(false);
translate([plate_width,plate_height-(rubber_hole_inside/2+rubber_hole_thickness),0]) 
    rubber_hole(false);
translate([plate_width, rubber_offset+t_width/2, 0]) rotate([0,0,-90]) t();

