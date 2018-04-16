/*
CONTROL CODE FOR ORIGAMI TISSUE FOLDER
NORTHEASTERN CAPSTONE PROJECT SPRING 2018
JOE FLAHERTY
*/
void(* resetFunc) (void) = 0;
// Map of variables written to .h files by MATLAB
#include "map.h"

// Motor and shield connections
#include "motors.h"

// Digital pin number assignments 
#include "pins.h"

// Motion control functions
#include "motion.h"

// Status booleans
bool homed = false, done = false;
int inByte;
int dt = 100;

// INITIALIZATION ROUTINE
void setup() {    
    // Start Serial and Shield Communication
    Serial.begin(9600);
    Serial.println("--Origami Tissue Folder--");
    Serial.println("Initializing Pins");
    initializePins();
    Serial.println("Initializing Motors");
    initializeMotors();
    Serial.println("Startup Complete.");
    Serial.println("Do not load strips until motors are homed.");
    Serial.println("Press 'h' to home motors.");
    Serial.println("Press 'c' to check limit switches.");
    Serial.println("Press 'm' to for manual control.");
}

// MAIN PROGRAM
void loop() {
    
    if (Serial.available() > 0)
    {
        inByte = Serial.read();
        switch (inByte) {
            // Home
            case 'h': {
                if (done) {
                    Serial.println("Remove strips then press 'x' to reset");
                    break;
                }
                Serial.println("Homing Motors");
                delay(dt);
                homed = home();
                Serial.println("Load strips then press 'f' to fold.");
                break;
            }
            // Fold
            case 'f': {
                homed = true; //REMOVE THIS
                if (!homed) {
                    Serial.println("Press 'h' home motors. Don't load strips yet.");
                    break;
                }
                Serial.println("Folding Strips");
                delay(dt);
                done = fold();
                if (!done) {
                    Serial.println("Error during folding. AUTO RESET.");
                    resetFunc();
                }
                Serial.println("Done folding. Remove strips then press 'x' to reset.");
                break;
            }
            // RESET (KILL SWITCH)
            case 'x': {
                Serial.println("USER RESET");
                delay(dt);
                resetFunc();
                break;
            }
            // Check Limit Switches
            case 'c': {
                Serial.println("Limit Switches");
                Serial.print("X1L\t");
                Serial.println(digitalRead(X1L));
                Serial.print("X1R\t");
                Serial.println(digitalRead(X1R));
                Serial.print("X2L\t");
                Serial.println(digitalRead(X2L));
                Serial.print("X2R\t");
                Serial.println(digitalRead(X2R));
                Serial.print("Z1B\t");
                Serial.println(digitalRead(Z1B));
                Serial.print("Z1T\t");
                Serial.println(digitalRead(Z1T));
                Serial.print("Z2B\t");
                Serial.println(digitalRead(Z2B));
                Serial.print("Z2T\t");
                Serial.println(digitalRead(Z2T));
                delay(dt);
                break;
            }
            // Manual
            case 'm': {
                Serial.println("Manual Activated");
                delay(dt);
                manual();
                homed = false;
                Serial.println("Motors must be homed again.");
            }
            default: {} break;
        }
    }
}
