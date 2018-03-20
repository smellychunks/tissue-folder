/*
CONTROL CODE FOR ORIGAMI TISSUE FOLDER
NORTHEASTERN CAPSTONE PROJECT SPRING 2018
JOE FLAHERTY
*/

// Map of variables written to .h files by MATLAB
#include "map.h"

// Motor and shield connections
#include "motors.h"

// Digital pin number assignments 
#include "pins.h"

// Motion control functions
#include "motion.h"

// Status booleans
bool homed = false, done = false, error = false;

// INITIALIZATION ROUTINE
void setup() {    
    // Start Serial and Shield Communication
    Serial.begin(9600);
    Serial.println("--Origami Tissue Folder--");
    Serial.println("Initializing Pins");
    initializePins();
    digitalWrite(workingPin,HIGH);
    Serial.println("Initializing Motors");
    initializeMotors();
    
    //REPLACE WITH HOMING LATER
    x1.setCurrentPosition(x1z1_start[0]);
    z1.setCurrentPosition(x1z1_start[1]);
    x2.setCurrentPosition(x2z2_start[0]);
    z2.setCurrentPosition(x2z2_start[1]);
    
    Serial.println("Homing Motors");
    error = home();
    if (!error) {
        Serial.println("Startup Complete");
        Serial.print("Load Strips Now. "); 
        Serial.println("Press GO to Fold");
    }
}

// MAIN PROGRAM
void loop() {
    
    // Light Error LED for error or undocked carriages
    if (error || !docked(0,true)) {
        digitalWrite(errorPin,HIGH);
        digitalWrite(readyPin,LOW);
    }
    
    // Light Ready LED if folding was already performed
    else if (done){
        digitalWrite(readyPin,HIGH);   
    }
    
    // If Go buttton pressed, begin folding
    else if (digitalRead(goPin) == LOW){
        digitalWrite(readyPin,LOW);
        digitalWrite(workingPin,HIGH);
        Serial.println("Folding Started");
        error = fold();
        done = true;
        digitalWrite(workingPin,LOW);
    }
    
    // Otherwise, light Ready LED
    else {
        digitalWrite(readyPin,HIGH);
    }
}
