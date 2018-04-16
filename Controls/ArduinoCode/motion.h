// Checks limit switches to see if carriages
// are in ready position (end of rails)
int docked(int carriage, bool x){
/*
returns... 
0 if undocked
-1 if docked left/bottom
1 if docked right/top
-2 if docked at both ends (error!)
*/
    // Check X Axis Switches
    bool A, B, a1, b1, a2, b2;
    if (x){
        a1 = digitalRead(X1L);// == HIGH;
        b1 =  digitalRead(X1R);// == HIGH;
        a2 = digitalRead(X2L);// == HIGH;
        b2 = digitalRead(X2R);// == HIGH;
    } 
    // Check Z Axis Switches
    else {
        a1 = digitalRead(Z1B);// == HIGH;
        b1 = digitalRead(Z1T);// == HIGH;
        a2 = digitalRead(Z2B);// == HIGH;
        b2 = digitalRead(Z2T);// == HIGH;
    }
    // Logic for requested carriage
    switch (carriage) {
        // both
        case 0: {
            A = a1 && a2;
            B = b1 && b2;
        }
        // carriage 1
        case 1: {
            A = a1;
            B = b1;
        }
        // carriage 2
        case 2: {
            A = a2;
            B = b2;
        }      
        Serial.print("A ");
        Serial.println(A);
        Serial.print("B ");
        Serial.println(B); 
    }
    // undocked
    if (!(A && B)) {
        return 0;
    }
    // left/bottom dock
    if (A && !B) {
        return -1;
    }
    // right/top dock
    if (!A && B) {
        return 1;
    }
    // docked at both ends (error!)
    else {
        Serial.println("Opposing limit switches both active!");
        return -2;
    }
}

// Returns true when the motor should stop
bool limit( bool car1, bool x, bool fwd){
    /* Function inputs:
    car1: carriage 1 or carriage 2
    x: x axis or z axis
    fwd: moving forward or backward
    */
    Serial.print("car1: ");
    Serial.println(car1);
    int carA, carB;
    if (car1) {
        carA = 1;
        carB = 2;
    } else {
        carA = 2;
        carB = 1;
    }
    // <0 if left/bottom switch hit
    // >0 if right/top switch hit
    Serial.println("checking thisCar dock...");
    int thisCar = docked(carA,x);
    Serial.print("thisCar result ");
    Serial.println(thisCar);
    // False if other carriage is docked in X
    Serial.println("checking otherCar dock...");
    bool otherCar = !docked(carB,true);// WAS ! before
    Serial.print("otherCar result ");
    Serial.println(otherCar);
    Serial.print("otherCar int value ");
    Serial.println(!docked(!carB,true));
    // Returns based on forward or reverse motion
    if (fwd) return thisCar>0 || otherCar;
    else return thisCar<0 || otherCar;
}

// Move axis motors to target point
// (still need to add limit switches)
bool move(int xt, int zt, uint8_t carriage, bool relative) { 
    
    // True until motors have moved (for limit switches)
    bool car1 = carriage == 1;
    bool xcheck, zcheck;
    // Print move targets to console
    Serial.print("Moving to X to ");
    Serial.print(xt);
    Serial.print(" and Z to ");
    Serial.println(zt);
    
    // Initialize move targets as long array
    long targets[2];
    targets[0] = xt;
    targets[1] = zt;
    
    // Initialize pointers to motor control objects
    AccelStepper* x;
    AccelStepper* z;
    MultiStepper* xz;
    
    // Assign pointers based on axis
    if (car1){
        x = & x1;
        z = & z1;
        xz = & x1z1;
    } else {
        x = & x2;
        z = & z2;
        xz = & x2z2;
    }
    
    // Set targets and run
    if (relative) {
        x->setCurrentPosition(600);
        z->setCurrentPosition(600);
        targets[0] += x->currentPosition();
        targets[1] += z->currentPosition();
        //x->move(targets[0]);
        //z->move(targets[1]);
    }
    xz->moveTo(targets);
    
    // Initialize limit switch variables
    bool fwd = x->distanceToGo() >= 0;
    bool up = z->distanceToGo() >= 0;
    
    // Check limit switches before move
    Serial.println("Checking X");
    xcheck = limit(car1,true,fwd);
    Serial.println("Checking Z");
    zcheck = limit(car1,false,up);
    if (xcheck || zcheck){
        Serial.println("Move cancelled due to limit switch!");
        Serial.print("xcheck result ");
        Serial.println(xcheck);
        Serial.print("zcheck result ");
        Serial.println(zcheck);
        return true;
    }
    
    // Move while checking limit switches
 
    while(xz->run()) {
        
        xcheck = limit(car1,true,fwd);
        zcheck = limit(car1,false,up);
        if (xcheck || zcheck){
            // Home x motor on either limit switch
            if (xcheck) {
                x->setCurrentPosition(xt);
                // Z motor will continue until its target
            }
            // Home z motor on bottom limit switch only
            if (zcheck) {
                if (up) {
                    Serial.println("Z ceiling crash!");
                    return true; // throws error
                } else {
                    z->setCurrentPosition(0);
                }
            }
            break;
        } 
    }

    return false;
}

// Runs water pump (pumpTime in milliseconds)
void squirt(int pumpTime, bool fwd){ 
    if (fwd) {
        // Move arm down and wait until move is done
        arm.write(arm_active);
        while(arm.read()!= arm_active);
        //pump
        pump->run(FORWARD);
    } 
    else pump->run(BACKWARD);
    delay(pumpTime);
    pump->run(RELEASE);
    // no need to wait-- carriages move slow enough
    arm.write(arm_rest);
}

// Homes motors on limit switches and moves to starting position
bool home(){
    // X Axes must be homed manually (to avoid crashes)
    
    int LONG_MAX = 2147483647;
    if ( docked(0,true) == -1 ) {
        x1.setCurrentPosition(0);
        x2.setCurrentPosition(0);
    }
    else {
        Serial.println("ERROR: Carriages must be docked manually to -X limits.");
        return false;
    }
    if ( docked(1,false) > -1 ) {
        //z1.setCurrentPosition(LONG_MAX);
        //move(0,0,1,false);
        z1.setCurrentPosition(0);
        move(0,LONG_MAX,1,false);
        z1.setCurrentPosition(z_ceiling);
    }
    if ( docked(2,false) > -1 ) {
        //z2.setCurrentPosition(LONG_MAX);
        //move(0,0,2,false);
        z2.setCurrentPosition(0);
        move(0,LONG_MAX,2,false);
        z2.setCurrentPosition(z_ceiling);
    }
    
    // Move to starting positions
    move(x1z1_start[0],x1z1_start[1],1,false);
    move(x2z2_start[0],x2z2_start[1],2,false);
    return true;
}

// Controls folding motion
bool fold(){
    bool err = false;
    long starttime = millis();
    // Number of Folds (and loop executions)
    int n = sizeof(x1_pre)/sizeof(x1_pre[0]);
    
    // Initialize move targets
    uint16_t x_pre;
    uint16_t z_pre;
    uint16_t x_post;
    uint16_t z_post;
    uint16_t x_dock;
    uint16_t z_dock;
    
    // Move motors... for each fold (i), for each carriage (j)
    for (int i = 0; i<n-1; i++){
        Serial.print("\n----------------------------\n\n");
        for (int j = 1; j<=2; j++){
            
            // Print info to console
            Serial.print("X");
            Serial.print(j);
            Serial.print(" Axis Fold ");
            Serial.print(i+1);
            Serial.print(" of ");
            Serial.println(n);
            // Assign Targets for each move & motor
            if (j == 1){
                x_pre = x1_pre[i];
                z_pre = z1_pre[i];
                x_post = x1_post[i];
                z_post = z1_post[i];
                x_dock = x1_dock[i];
                z_dock = z1_dock[i];
            } else {
                x_pre = x2_pre[i];
                z_pre = z2_pre[i];
                x_post = x2_post[i];
                z_post = z2_post[i];
                x_dock = x2_dock[i];
                z_dock = z2_dock[i];
            }
            // Perform moves (3 Line segments)
            err = move(x_pre,z_pre,j,false);
            if (err) return true;
            err = move(x_post,z_post,j,false);
            if (err) return true;
            err = move(x_dock,z_dock,j,false);
            if (err) return true;
            
            // Squirt Water onto stack
            Serial.println("Wetting the stack");
            squirt(pump_time,true);
            
            // Report elapsed folding time
            Serial.print("Elapsed Time: ");
            Serial.print((millis()-starttime)/1000);
            Serial.println(" seconds\n");
        }
        delay(10);
    }
    
    // Quit if done folding (press RESET to repeat)    
    Serial.println("\n------------Done------------\n");
    delay(100);
    return(err);
}

// Control motors via keyboard over serial
void manual()
{
    int inByte;
    int dt = 100;
    int manStep = 100;
    int manPump = 1000;
    while (true) {
        inByte = Serial.read();
        switch (inByte) {
            // Carriage 1
            case 's': {
                Serial.println("Z1 Down");
                move(0,-manStep,1,true);
                delay(dt);
                break;
            }
            case 'w': {
                Serial.println("Z1 Up");
                move(0,manStep,1,true);
                delay(dt);
                break;
            }
            case 'a': {
                Serial.println("X1 Left");
                move(-manStep,0,1,true);
                delay(dt);
                break;
            }
            case 'd': {
                Serial.println("X1 Right");
                move(manStep,0,1,true);
                delay(dt);
                break;
            }
            // Carriage 2
            case 'S': {
                Serial.println("Z2 Down");
                move(0,-manStep,2,true);
                delay(dt);
                break;
            }
            case 'W': {
                Serial.println("Z2 Up");
                move(0,manStep,2,true);
                delay(dt);
                break;
            }
            case 'A': {
                Serial.println("X2 Left");
                move(-manStep,0,2,true);
                delay(dt);
                break;
            }
            case 'D': {
                Serial.println("X2 Right");
                move(manStep,0,2,true);
                delay(dt);
                break;
            }
            // Pump
            case 'e': {
                Serial.println("Pump Forward");
                squirt(manPump,true);
                delay(dt);
                break;
            }
            case 'q': {
                Serial.println("Pump Reverse");
                squirt(manPump,false);
                delay(dt);
                break;
            }
            // Reset
            case 'x': {
                Serial.println("USER RESET");
                delay(dt);
                resetFunc();
                break;
            }
            // Exit
            case 'm': {
                Serial.println("Manual Deactivated");
                return;
            }
            default: {} break;
        }
    }    
}