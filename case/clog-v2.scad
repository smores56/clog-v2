hole_locations = [
    [48, -0.2],
    [11.9, -44.4],
    [86.1, -2.1],
    [93.4, -53.5],
];

pcb_thickness = 1.6;
component_thickness = 2;
case_thickness = 1.5;
total_thickness = pcb_thickness +
    component_thickness + case_thickness;

heat_insert_radius = 1.5;
strut_radius = 3;

accuracy = 100;

right_side = false;

module pcb() {
    translate([-100, -150, 0])
    import("clog-v2.svg", $fn=accuracy);
}

module pcb_ghost() {
    %
    translate([0, 0, case_thickness + component_thickness])
    linear_extrude(pcb_thickness)
    pcb();
}

module pcb_cutout() {
    translate([0, 0, case_thickness + component_thickness])
    linear_extrude(pcb_thickness + 0.1)
    offset(1.5, $fn=accuracy)
    pcb();
}

module component_cutout() {
    translate([0, 0, case_thickness])
    linear_extrude(component_thickness + pcb_thickness + 0.1)
    offset(-1, $fn=accuracy)
    pcb();
}

module case_body() {
    linear_extrude(total_thickness)
    offset(4, $fn=accuracy)
    pcb();
}

module heat_insert_holes() {
    for (location = hole_locations) {
        translate([location[0], location[1], case_thickness + component_thickness - 3])
        linear_extrude(10)
        circle(heat_insert_radius, $fn=accuracy);
    }
}

module heat_insert_struts() {
    for (location = hole_locations) {
        translate([location[0], location[1], case_thickness - 0.1])
        linear_extrude(component_thickness)
        circle(strut_radius, $fn=accuracy);
    }
}

module power_switch_cutout() {
    translate([5, -55, case_thickness + component_thickness + 2.5])
    rotate([0, 0, -32])
    cube([12, 6, 5], center=true);
}

module full_case() {
    difference() {
        union() {
            difference() {
                case_body();
                pcb_cutout();
                component_cutout();
                power_switch_cutout();
            };
            heat_insert_struts();
        };
        heat_insert_holes();
        pcb_ghost();
    };
}

if (right_side) {
    translate([110, 0, 0])
    mirror([1, 0, 0])
    full_case();
} else {
    full_case();
};

