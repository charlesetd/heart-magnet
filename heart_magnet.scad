/* [Part] */

// Select the part to render
part = "back"; // [back:Back,face:Face]

/* [Heart Options] */

// Overall size of the heart
heart_size = 30; // [20:1:100]

// How stretched should the heart be
heart_stretch = 1.2; // [1:0.05:1.5]

/* [Text Options] */

// The thickness of the outline around the heart face
outline_thickness = 1; // [1:0.5:3]

// How far does the text and outline stick out from the heart
face_deboss = 1.5; // [0.5:0.5:3]

// The scale of the text relative to the heart
text_scale = 0.3; // [0.1:0.05:0.3]

// The text written on the heart
text = "LOVE";

// The font of the text
text_font = "Segoe Script";

/* [Magnets] */

// The diameter of the magnets in mm
magnet_diameter = 7; // [1:0.5:10]

// The thickness of the magnets
magnet_thickness = 1.5; // [0.5:0.5:3]

/* [Advanced] */

// The thickness of the back plate
back_plate_thickness = 1.5; // [1:0.5:3]

// The thickness of the face plate
face_plate_thickness = 1.5; // [1:0.5:3]

// The allowance for the back and face plates to fit together
allowance = 0.2;

/* [Hidden] */

// How many segments rounded objects are rendered with
$fn = 100;

// How far unions and differences should overlap to prevent thin walls
fudge_factor = 0.02;

// Color of the part
heart_color = [0.9, 0.2, 0.2];

build_part();

// Creates the selected part
module build_part() {
  if (part == "assembly") {
    magnet_assembly();
  } else if (part == "back") {
    magnet_back_plate();
  } else if (part == "face") {
    magnet_face_plate();
  } else {
    assert(false, str("The part \"", part, "\" is not a valid selection."));
  }
}

// Creates the back plate
module magnet_back_plate() {
  total_thickness = back_plate_thickness + magnet_thickness + face_plate_thickness + face_deboss;
  face_size = heart_size - outline_thickness * 2;
  
  color(heart_color) {
    difference() {
      // Back
      linear_extrude(height = total_thickness, slices = 1, convexity = 6) {
        heart(size = heart_size, stretch = heart_stretch);
      }
      
      // Walls
      translate([0, 0, back_plate_thickness + magnet_thickness + fudge_factor]) {
        linear_extrude(height = face_plate_thickness + face_deboss) {
          heart(size = face_size, stretch = heart_stretch);
        }
      }
      
      // Magnet Holes
      for(x = [-heart_size/2:heart_size:heart_size/2]) {
        translate([x, heart_size / 3, magnet_thickness * 2]) {
          cylinder(d = magnet_diameter, h = magnet_thickness * 2, center = true);
        }
      }
    }
  }
}

// Creates the face plate
module magnet_face_plate() {
  total_thickness = face_plate_thickness + face_deboss;
  
  color(heart_color) {
    union() {
      linear_extrude(height = face_plate_thickness) {
        heart(size = heart_size - outline_thickness * 2 - allowance, stretch = heart_stretch);
      }

      translate([0, heart_size / 3]) {
        linear_extrude(height = total_thickness, slices = 1) {
          text(text = text, size = heart_size * text_scale, font = text_font, valign = "center", halign = "center");
        }
      }
    }
  }
}

// Creates a heart profile
module heart(size, stretch) {
  scale([1, stretch]) {
    rotate([0, 0, 45]) {
      union() {
        square(size, center = true);
        
        translate([size / 2, 0, 0]) {
          circle(size / 2);
        }
        
        translate([0, size / 2, 0]) {
          circle(size / 2);
        }
      }
    }
  }
}
