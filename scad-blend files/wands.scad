$fn=50;

module wand(length, len_to_hole=-1) {
    actual_len = length+5;
    
    difference() {
        union() {
            translate([actual_len/2, 0, 2.5])
            cube([actual_len, 10, 5], true);
            
            cylinder(h=5, r=5);
            
            translate([actual_len, 0, 0])
            cylinder(h=5, r=5);
            
            if (len_to_hole >= 0) {
                translate([len_to_hole+5, 0, 0])
                difference() {
                    cylinder(h=11, r=2);
                    
                    translate([0, 0, 3])
                    cylinder(h=10, r=1);
                }
            }
        }
        
        translate([0, 0, 0])
        cylinder(h=10, r=3);
        
        translate([actual_len, 0, 0])
        cylinder(h=10, r=3);
    }
}

module full_leg_wand() {
    wand(length=132, len_to_hole=60);

    translate([0, 20, 0])
    wand(length=60);
}

module body_wand() {
    wand(length=134, len_to_hole=60);
    
    translate([0, 20, 0])
    wand(length=74);
}


full_leg_wand();

translate([0, 40, 0])
full_leg_wand();

translate([0, 80, 0])
body_wand();
