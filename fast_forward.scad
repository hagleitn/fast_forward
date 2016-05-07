$fa = 0.5; // default minimum facet angle is now 0.5
$fs = 0.5; // default minimum facet size is now 0.5 
tilt = 15;
motor_height = 20;
motor_width = 8.5;
motor_radius = motor_width/2;
wall_thickness = 2.5;
wall_height = 5;
motor_distance=80;

module motor_mount(h,r,d,a,solid=false) {
    
    h2 = solid ? h+2 : h;

    difference() {
        {
            rotate([a,0,0])
            difference() {
                cylinder(h=4*h2,r=r, center=true);
                if (!solid) cylinder(h=4*h2+2,r=d, center=true);
            }
        }
        translate([0,0,h2+r+h2/2]) cube(size=2*(r+h2), center=true);
        translate([0,0,-(h2+r+h2/2)]) cube(size=2*(r+h2), center=true);
    }
}

module motor_mount_actual(solid=false) {
    motor_mount(wall_height,motor_radius+wall_thickness,motor_radius,tilt,solid);
}

module strut(h,w,l,a=0) {
    scale_outer_x = 0.3;
    // l*scale_outer - l*scale_inner = 2*w
    scale_inner_x = 2*w/l - scale_outer_x;
    
    scale_outer_y = 1;
    scale_inner_y = 2*w/l - scale_outer_y;
    difference() {
        scale([scale_outer_x, scale_outer_y, 1]) cylinder(h=h, r=l/2);
        scale([scale_inner_x, scale_inner_y, 1.1]) 
            translate([0,0,-1]) cylinder(h=h+2, r=l/2);
        translate([0,-motor_distance/2, wall_height/2]) 
            rotate([0,0,a]) 
                motor_mount_actual(solid=true);
        translate([0,+motor_distance/2, wall_height/2]) 
            rotate([0,0,a]) 
                motor_mount_actual(solid=true);
        translate([0,-motor_distance/2,-1]) cube(motor_distance);
    }
}

module frame()
{
    translate([motor_distance/2,0,0]) strut(wall_height, wall_thickness, motor_distance);
    translate([-motor_distance/2,0,wall_height]) 
        rotate([0,180,0]) 
            strut(wall_height, wall_thickness, motor_distance, 180);
    translate([0,motor_distance/2,0]) 
        rotate([0,0,90]) 
            strut(wall_height, wall_thickness, motor_distance, -90);
    
    translate([motor_distance/2, motor_distance/2, wall_height/2]) 
        motor_mount_actual();
    translate([-motor_distance/2, motor_distance/2, wall_height/2]) 
        motor_mount_actual();
    translate([motor_distance/2, -motor_distance/2, wall_height/2]) 
        motor_mount_actual();
    translate([-motor_distance/2, -motor_distance/2, wall_height/2]) 
        motor_mount_actual();
}

module stand(h,w,l,s) {
    scale_outer_x = 2*s/l;
    // l*scale_outer - l*scale_inner = 2*w
    scale_inner_x = 2*w/l - scale_outer_x;
    
    scale_outer_y = 0.91;
    scale_inner_y = 2*w/l - scale_outer_y;
    
    difference() {
        translate([0,-l/2+motor_width-1,s])
        rotate([0,-90,90])
        difference() {
            scale([scale_outer_x, scale_outer_y, 1]) cylinder(h=h, r=l/2);
            scale([scale_inner_x, scale_inner_y, 1.1]) 
                translate([0,0,-1]) cylinder(h=h+2, r=l/2);
            translate([0,-motor_distance/2,-1]) cube(motor_distance);
        }
        translate([0,0,sin(tilt)*(motor_distance/2)])
            rotate([-tilt,0,0])
                frame();
        rotate([-tilt,0,0]) 
            translate([0,0,motor_distance+sin(tilt)*(motor_distance/2)+wall_height-0.4])
                cube(2*motor_distance, center=true);
    }
}

s = (sin(tilt)*(motor_distance/2))*2+wall_height;
translate([-s/2,-motor_distance/2,s+2*wall_height-0.5])
    rotate([90,0,90])
        stand(wall_thickness, wall_height, motor_distance, s);

//translate([0,0,sin(tilt)*(motor_distance/2)])
//    rotate([-tilt,0,0])
frame();