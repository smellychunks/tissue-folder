// Accel & Multi Stepper Allow for Synchronous Control
#include <Wire.h>
#include <AccelStepper.h>
#include <Adafruit_MotorShield.h>
#include <MultiStepper.h>

// Initialize Shields
Adafruit_MotorShield AFMSbot(0x61); // Rightmost jumper closed
Adafruit_MotorShield AFMStop(0x60); // Default address, no jumpers

// Connect two steppers with 200 steps per revolution (1.8 degree)
// to the top shield
Adafruit_StepperMotor *x1s = AFMStop.getStepper(200, 1);
Adafruit_StepperMotor *z1s = AFMStop.getStepper(200, 2);

// Connect one stepper with 200 steps per revolution (1.8 degree)
// to the bottom shield
Adafruit_StepperMotor *x2s = AFMSbot.getStepper(200, 1);
Adafruit_StepperMotor *z2s = AFMSbot.getStepper(200, 2);

// you can change these to DOUBLE or INTERLEAVE or MICROSTEP!
// wrappers for the first motor!
void forwardstep1() {  
  x1s->onestep(FORWARD, SINGLE);
}
void backwardstep1() {  
  x1s->onestep(BACKWARD, SINGLE);
}
// wrappers for the second motor!
void forwardstep2() {  
  z1s->onestep(FORWARD, SINGLE);
}
void backwardstep2() {  
  z1s->onestep(BACKWARD, SINGLE);
}

// wrappers for the third motor!
void forwardstep3() {  
  x2s->onestep(FORWARD, SINGLE);
}
void backwardstep3() {  
  x2s->onestep(BACKWARD, SINGLE);
}
// wrappers for the fourth motor!
void forwardstep4() {  
  z2s->onestep(FORWARD, SINGLE);
}
void backwardstep4() {  
  z2s->onestep(BACKWARD, SINGLE);
}

// Now we'll wrap the 3 steppers in an AccelStepper object
AccelStepper x1(forwardstep1, backwardstep1);
AccelStepper z1(forwardstep2, backwardstep2);
AccelStepper x2(forwardstep3, backwardstep3);
AccelStepper z2(forwardstep4, backwardstep4);

// Initialize MultiStepper objects for synchronization
MultiStepper x1z1;
MultiStepper x2z2;

void initializeMotors() {
    //Connect to Shields
    AFMSbot.begin(); // Start the bottom shield
    AFMStop.begin(); // Start the top shield
    
    // Give motors to MultiStepper to manage
    x1z1.addStepper(x1);
    x1z1.addStepper(z1);   
    x2z2.addStepper(x2);
    x2z2.addStepper(z2);

    // Configure each stepper
    x1.setMaxSpeed(speed_limit[0]);
    x2.setMaxSpeed(speed_limit[0]);
    z1.setMaxSpeed(speed_limit[1]);
    z2.setMaxSpeed(speed_limit[1]);
}