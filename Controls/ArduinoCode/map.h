// Map header (.h) files to global variables
// Header files are written in CSV format by MATLAB

const uint8_t speed_limit [] = {
    #include "speed_limit.h"
}; 

const uint16_t x1z1_start [] = {
    #include "x1z1_start.h"
}; 

const uint16_t x2z2_start [] = {
    #include "x2z2_start.h"
};

const uint16_t pump_settings [] = {
    #include "pump_settings.h"
};
const uint16_t pump_speed = pump_settings[0];
const uint16_t pump_time = pump_settings[1];
const uint16_t arm_rest = pump_settings[2];
const uint16_t arm_active = pump_settings[3];

// Data for Z Top Homing
const uint16_t z_specs[] = {
    #include "z_specs.h"
};
const uint16_t z_ceiling = z_specs[0];

const uint16_t x1_pre [] = {
    #include "x1_pre.h"
}; 

const uint16_t x2_pre [] = {
    #include "x2_pre.h"
}; 

const uint16_t z1_pre [] = {
    #include "z1_pre.h"
}; 

const uint16_t z2_pre [] = {
    #include "z2_pre.h"
}; 

const uint16_t x1_post [] = {
    #include "x1_post.h"
}; 

const uint16_t x2_post [] = {
    #include "x2_post.h"
}; 

const uint16_t z1_post [] = {
    #include "z1_post.h"
}; 

const uint16_t z2_post [] = {
    #include "z2_post.h"
}; 

const uint16_t x1_dock [] = {
    #include "x1_dock.h"
}; 

const uint16_t x2_dock [] = {
    #include "x2_dock.h"
}; 

const uint16_t z1_dock [] = {
    #include "z1_dock.h"
}; 

const uint16_t z2_dock [] = {
    #include "z2_dock.h"
}; 