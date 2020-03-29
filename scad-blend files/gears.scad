$fn = 50;

pi = 3.14159;
rad = 57.29578;
clearance = 0.05;

function grad(pressure_angle) = pressure_angle*rad;

function radian(pressure_angle) = pressure_angle/rad;

function polar_to_cartesian(polvect) = [
    polvect[0]*cos(polvect[1]),  
    polvect[0]*sin(polvect[1])
];

function sphere_to_cartesian(vect) = [
    vect[0]*sin(vect[1])*cos(vect[2]),  
    vect[0]*sin(vect[1])*sin(vect[2]),
    vect[0]*cos(vect[1])
];

function ev(r, rho) = [
    r/cos(rho),
    grad(tan(rho)-radian(rho))
];


module spur_gear(modul, tooth_number, width, bore, pressure_angle = 20, helix_angle = 0, optimized = true) {

    // Dimension Calculations  
    d = modul * tooth_number;                                       // Pitch Circle Diameter
    r = d / 2;                                                      // Pitch Circle Radius
    alpha_spur = atan(tan(pressure_angle)/cos(helix_angle));        // Helix Angle in Transverse Section
    db = d * cos(alpha_spur);                                       // Base Circle Diameter
    rb = db / 2;                                                    // Base Circle Radius
    da = (modul <1)? d + modul * 2.2 : d + modul * 2;               // Tip Diameter according to DIN 58400 or DIN 867
    ra = da / 2;                                                    // Tip Circle Radius
    c =  (tooth_number < 3) ? 0 : modul/6;                          // Tip Clearance
    df = d - 2 * (modul + c);                                       // Root Circle Diameter
    rf = df / 2;                                                    // Root Radius
    rho_ra = acos(rb/ra);                                           // Maximum Rolling Angle;
                                                                    // Involute begins on the Base Circle and ends at the Tip Circle
    rho_r = acos(rb/r);                                             // Rolling Angle at Pitch Circle;
                                                                    // Involute begins on the Base Circle and ends at the Tip Circle
    phi_r = grad(tan(rho_r)-radian(rho_r));                         // Angle to Point of Involute on Pitch Circle
    gamma = rad*width/(r*tan(90-helix_angle));                      // Torsion Angle for Extrusion
    step = rho_ra/16;                                               // Involute is divided into 16 pieces
    tau = 360/tooth_number;                                         // Pitch Angle
    
    r_hole = (2*rf - bore)/8;                                       // Radius of Holes for Material-/Weight-Saving
    rm = bore/2+2*r_hole;                                           // Distance of the Axes of the Holes from the Main Axis
    z_hole = floor(2*pi*rm/(3*r_hole));                             // Number of Holes for Material-/Weight-Saving
    
    optimized = (optimized && r >= width*1.5 && d > 2*bore);        // is Optimization useful?

    // Drawing
    union(){
        rotate([0,0,-phi_r-90*(1-clearance)/tooth_number]){             // Center Tooth on X-Axis;
                                                                        // Makes Alignment with other Gears easier

            linear_extrude(height = width, twist = gamma){
                difference(){
                    union(){
                        tooth_width = (180*(1-clearance))/tooth_number+2*phi_r;
                        circle(rf);                                     // Root Circle 
                        for (rot = [0:tau:360]){
                            rotate (rot){                               // Copy and Rotate "Number of Teeth"
                                polygon(concat(                         // Tooth
                                    [[0,0]],                            // Tooth Segment starts and ends at Origin
                                    [for (rho = [0:step:rho_ra])     // From zero Degrees (Base Circle)
                                                                        // To Maximum Involute Angle (Tip Circle)
                                        polar_to_cartesian(ev(rb,rho))],       // First Involute Flank

                                    [polar_to_cartesian(ev(rb,rho_ra))],       // Point of Involute on Tip Circle

                                    [for (rho = [rho_ra:-step:0])    // of Maximum Involute Angle (Tip Circle)
                                                                        // to zero Degrees (Base Circle)
                                        polar_to_cartesian([ev(rb,rho)[0], tooth_width-ev(rb,rho)[1]])]
                                                                        // Second Involute Flank
                                                                        // (180*(1-clearance)) instead of 180 Degrees,
                                                                        // to allow clearance of the Flanks
                                    )
                                );
                            }
                        }
                    }           
                    circle(r = rm+r_hole*1.49);                         // "bore"
                }
            }
        }
        // with Material Savings
        if (optimized) {
            linear_extrude(height = width){
                difference(){
                        circle(r = (bore+r_hole)/2);
                        circle(r = bore/2);                          // bore
                    }
                }
            linear_extrude(height = (width-r_hole/2 < width*2/3) ? width*2/3 : width-r_hole/2){
                difference(){
                    circle(r=rm+r_hole*1.51);
                    union(){
                        circle(r=(bore+r_hole)/2);
                        for (i = [0:1:z_hole]){
                            translate(sphere_to_cartesian([rm,90,i*360/z_hole]))
                                circle(r = r_hole);
                        }
                    }
                }
            }
        }
        // without Material Savings
        else {
            linear_extrude(height = width){
                difference(){
                    circle(r = rm+r_hole*1.51);
                    circle(r = bore/2);
                }
            }
        }
    }
}

module leg_gear() {
    union() {
        spur_gear (1, 62, 10, 6, 20, 0, true);
        
        translate([-24, 0, 0]) {
            difference() {
                union() {
                    cylinder(h=15, r=2);
                    cylinder(h=10, r=4);
                }
                
                translate([0, 0, 7])
                cylinder(h=10, r=1);
            }
        }
    }
}


module rotating_gear() {
    union() {
        translate([0,0,27])
        rotate([0,180,0])
        spur_gear(1, 62, 10, 0, 20, 0, true);
        
        translate([0,0,39])
        spur_gear(1, 62, 10, 0, 20, 0, true);
        
        translate([0,0,16])
        cylinder(h=34, r=8);
        difference() {
            cylinder(h=66, r=4);
            
            union(){
            translate([0, 5, 61])
            rotate([90, 0, 0])
            cylinder(h=10, r=1.5);
            
            translate([0, 5, 5])
            rotate([90, 0, 0])
            cylinder(h=10, r=1.5);
            }
        }
    }
}

module rotater(length) {
    difference() {
        translate([0, 0, 3])
        union() {
            translate([length/2-6, 0, 3])
            cube([length-14, 14, 6], true);
                        
            translate([0, 0, -3])
            cylinder(h=9, r=7);
            
            translate([length-14, 0, 0])
            cylinder(h=6, r=7);
            
            translate([length-14, 0, 0])
            cylinder(h=16, r=4);
        }
        
        translate([0, 8, 6])
        rotate([90, 0, 0])
        cylinder(h=16, r=1.5);
        
        cylinder(h=10, r=4.5);
    }
}
module body_gear() {
    union() {
        rotate([0, 0, 30])
        spur_gear (1, 31, 10, 6, 20, 0, true);
                
        translate([8, 0, 0]) {
            difference() {
                union() {
                    cylinder(h=20, r=2);
                    cylinder(h=13, r=4);
                }

                translate([0, 0, 12])
                cylinder(h=10, r=1);
            }
        }
    }
}

module connector_gear() {
    spur_gear (1, 31, 10, 6, 20, 0, true);
}

translate([170, 90, 0])
body_gear();

translate([120, 90, 0])
connector_gear();

translate([70, 90, 0])
connector_gear();

translate([70, 50, 0])
rotater(50);

translate([130, 50, 0])
rotater(50);

translate([90, 0, 0])
rotating_gear();

translate([160, 0, 0])
leg_gear();

translate([230, 0, 0])
leg_gear();