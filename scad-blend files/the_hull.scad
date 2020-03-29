module cheholmini(){
    difference(){
        union(){
            cube([12.2, 0.3, 7.7]);
            translate([0, 0, 7.6])
            cube([2.4, 0.3, 6.881]);
        }
        translate([-1, -0.1, 7.7])
        rotate(a=4.21673048, v=[0,1,0])
        cube([1, 0.5, 7]);

        translate([2.4, -0.1, 7.7])
        rotate(a=-4.21673048, v=[0,1,0])
        cube([1, 0.5, 7]);
        
        translate([4.2 ,-0.1, 2.7])
        cube([7, 0.5, 3.5]);
        
        
    }
}
module s(){
    translate([0,10,0])
    rotate(a=90, v=[1,0,0])
    rotate(a=90, v=[0,0,1])
    cylinder(10, 2, 2, $fn=3);
    translate([-0.8,0,0])
    cube([1.6, 10, 5]);
}
module Chehol(){
    difference(){
        resize([260, 5, 330])
        cheholmini();

        translate([117, -1, 40])
        rotate(a=-90, v=[1,0,0])
        cylinder(7, 2, 2, $fn=99);

        translate([181, -1, 40])
        rotate(a=-90, v=[1,0,0])
        cylinder(7, 2, 2, $fn=99);

        translate([107, -1, 156])
        rotate(a=-90, v=[1,0,0])
        cylinder(7, 2, 2, $fn=99);

        translate([68, -1, 78])
        rotate(a=-90, v=[1,0,0])
        cylinder(7, 4.5, 4.5, $fn=99);

        translate([47, -1, 120])
        rotate(a=-90, v=[1,0,0])
        cylinder(7, 2, 2, $fn=99);

        translate([36, -1, 149])
        rotate(a=-90, v=[1,0,0])
        cylinder(7, 2, 2, $fn=99);

        translate([25, -1, 178])
        rotate(a=-90, v=[1,0,0])
        cylinder(7, 2, 2, $fn=99);

        translate([25, -1, 318])
        rotate(a=-90, v=[1,0,0])
        cylinder(7, 2, 2, $fn=99);
    }
}
module s2(){
    difference(){
        translate([0,-10, -10])
        resize([20, 70, 40])
        s();
        translate([-15, -0.1, 0])
        cube([30, 5.2, 40]);
        translate([-15, 44.9, 0])
        cube([30, 5.2, 40]);
    }
}

module s3(){
    difference(){
        translate([0,-10, -10])
        cube([10, 70, 40]);
        translate([-15, -0.1, 0])
        cube([30, 5.2, 40]);
        translate([-15, 44.9, 0])
        cube([30, 5.2, 40]);
    }
}
module s4(){

    difference(){
        union(){
            cylinder(6, 8, 8, $fn=99);
            cylinder(17, 2, 2, $fn=50);
        }
        translate([0,0,1.1])
        cylinder(11.1, 1.1, 1.1, $fn=50);
    }
}
translate([0,0,5])
rotate(a=-90, v=[1,0,0])
Chehol();
translate([0,-10,5])
rotate(a=180, v=[1,0,0])
difference(){
    translate([0,0,5])
    rotate(a=-90, v=[1,0,0])
    Chehol();
    
    translate([181, 40, -1])
    cylinder(7, 2.1, 2.1, $fn=99);

    translate([25, 318, -1])
    cylinder(7, 2.1, 2.1, $fn=99);

    translate([107, 156, -1])
    cylinder(7, 2.1, 2.1, $fn=99);   
}

translate([80, 200, 16])
s2();

translate([110, 200, 16])
s2();

translate([140, 200, 16])
s2();

translate([170, 200, 10])
rotate(a=90, v=[0,1,0])
s3();

translate([220, 200, 10])
rotate(a=90, v=[0,1,0])
s3();

translate([117, 40, 0])
s4();

translate([117, -50, 0])
s4();

translate([47, 120, 0])
s4();

translate([36, 149, 0])
s4();

translate([25, 178, 0])
s4();

translate([181, 40, 0])
cylinder(48, 2, 2, $fn=99);

translate([25, 318, 0])
cylinder(48, 2, 2, $fn=99);

translate([107, 156, 0])
cylinder(47, 2, 2, $fn=99);
