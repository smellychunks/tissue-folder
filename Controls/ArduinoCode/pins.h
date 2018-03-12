// STATUS PINS
const int goPin = 23;//26;
const int readyPin = 22;//28;
const int workingPin = 13;//29;
const int errorPin = 13;//30;

// MOTOR LIMIT SWITCH PINS
const int X1L = 2;
const int X1R = 2;
const int X2L = 2;
const int X2R = 2;
const int Z1B = 2;
const int Z1T = 2;
const int Z2B = 2;
const int Z2T = 2;

// MOTOR LIGHT PINS
const int X1_L = 13;//31;
const int X1_R = 13;//32;
const int X1_ON = 13;//33;
const int X2_L = 13;//34;
const int X2_R = 13;//35;
const int X2_ON = 13;//36;
const int Z1_B = 13;//37;
const int Z1_T = 13;//38;
const int Z1_ON = 13;//39;
const int Z2_B = 13;//40;
const int Z2_T = 13;//41;
const int Z2_ON = 13;//42;
const int P_ON = 13;//43;

void initializePins(){
    // Button pins (RESET IS HANDLED BY BOARD)
    pinMode(goPin, INPUT);

    // Status LED Pins
    pinMode(readyPin, OUTPUT);
    pinMode(workingPin, OUTPUT);
    pinMode(errorPin, OUTPUT);

    // Motor LED Pins
    pinMode(X1_L, OUTPUT);
    pinMode(X1_R, OUTPUT);
    pinMode(X1_ON, OUTPUT);
    pinMode(X2_L, OUTPUT);
    pinMode(X2_R, OUTPUT);
    pinMode(X2_ON, OUTPUT);
    pinMode(Z1_B, OUTPUT);
    pinMode(Z1_T, OUTPUT);
    pinMode(Z1_ON, OUTPUT);
    pinMode(Z2_B, OUTPUT);
    pinMode(Z2_T, OUTPUT);
    pinMode(Z2_ON, OUTPUT);
    pinMode(P_ON, OUTPUT);
}