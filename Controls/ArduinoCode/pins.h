// MOTOR LIMIT SWITCH PINS
const int X1L = 2;
const int X1R = 2;
const int X2L = 2;
const int X2R = 2;
const int Z1B = 2;
const int Z1T = 2;
const int Z2B = 2;
const int Z2T = 2;

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