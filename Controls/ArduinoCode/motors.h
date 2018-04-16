// Accel & Multi Stepper Allow for Synchronous Control
#include <Wire.h>
#include <AccelStepper.h>
#include <Adafruit_MotorShield.h>
#include <MultiStepper.h>
#include <Servo.h>

// Initialize Shields
Adafruit_MotorShield MS1(0x62); // Default address, no jumpers
Adafruit_MotorShield MS2(0x61); // Rightmost jumper closed
Adafruit_MotorShield MS3(0x60); // Second from right jumper

// Carriage 1 Steppers
Adafruit_StepperMotor *x1s = MS1.getStepper(200, 1);
Adafruit_StepperMotor *z1s = MS1.getStepper(200, 2);

// Carriage 2 Steppers
Adafruit_StepperMotor *x2s = MS2.getStepper(200, 1);
Adafruit_StepperMotor *z2s = MS2.getStepper(200, 2);

// Water Pump (Shield 3)
Adafruit_DCMotor *pump = MS3.getMotor(1);

// Arm for water tube
Servo arm;

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

// Now we'll wrap the steppers in an AccelStepper object
AccelStepper x1(forwardstep1, backwardstep1);
//AccelStepper z1(forwardstep2, backwardstep2);
AccelStepper z1(backwardstep2, forwardstep2);
//AccelStepper x2(forwardstep3, backwardstep3);
AccelStepper x2(backwardstep3, forwardstep3);
//AccelStepper z2(forwardstep4, backwardstep4);
AccelStepper z2(backwardstep4, forwardstep4);

// Initialize MultiStepper objects for synchronization
MultiStepper x1z1;
MultiStepper x2z2;

void initializeMotors() {
    //Connect to Shields
    MS1.begin();
    MS2.begin();
    MS3.begin();
    
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
    
    // Set Pump Run Speed
    pump->setSpeed(pump_speed);
    pump->run(FORWARD);
    pump->run(RELEASE);
    
    // Set Arm to Rest Position
    arm.attach(9);
    arm.write(arm_rest);
}