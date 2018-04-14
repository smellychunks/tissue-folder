// MOTOR LIMIT SWITCH PINS
const int X1L = 22;
const int X1R = 25;
const int X2L = 26;
const int X2R = 29;
const int Z1B = 30;
const int Z1T = 33;
const int Z2B = 34;
const int Z2T = 37;

void initializePins(){
    // MOTOR LIMIT SWITCH PINS
    pinMode(X1L,INPUT);
    pinMode(X1R,INPUT);
    pinMode(X2L,INPUT);
    pinMode(X2R,INPUT);
    pinMode(Z1B,INPUT);
    pinMode(Z1T,INPUT);
    pinMode(Z2B,INPUT);
    pinMode(Z2T,INPUT);
}