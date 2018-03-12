// Move axis motors to target point
// (still need to add limit switches)
bool move(uint16_t xt, uint16_t zt, uint8_t axis) { 
    
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
    if (axis == 1){
        x = & x1;
        z = & z1;
        xz = & x1z1;
    } else {
        x = & x2;
        z = & z2;
        xz = & x2z2;
    }
        
    // Turn on motors
    x->enableOutputs();
    z->enableOutputs();
    
    // Set targets and run
    xz->moveTo(targets);
    bool forward = x->distanceToGo() > 0;
    while(xz->run());
    
    // Turn off motors
    x->disableOutputs();
    z->disableOutputs();
    
    return false;
}

bool home(){
    return false;
}

// Checks limit switches to see if carriages
// are in ready position (end of rails)
bool xlim(int carriage){
    bool c1 = digitalRead(X1L) == HIGH || digitalRead(X1R) == HIGH;
    bool c2 = digitalRead(X2L) == HIGH || digitalRead(X2R) == HIGH;
    return true;
    switch(carriage){
        case 0: return c1 && c2; // both carriages
        case 1: return c1; // carriage 1
        case 2: return c2; // carriage 2
    }
}

bool zlim(int carriage){
    bool c1 = digitalRead(Z1B) == HIGH || digitalRead(Z1T) == HIGH;
    bool c2 = digitalRead(Z2B) == HIGH || digitalRead(Z2T) == HIGH;
    switch(carriage){
        case 0: return c1 && c2; // both carriages
        case 1: return c1; // carriage 1
        case 2: return c2; // carriage 2
    }
}
// Activates water pump for stack
void squirt(){
    
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
    
    // Move motors... for each fold, for each axis
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
            // Perform moves (3 Lines)
            err = move(x_pre,z_pre,j);
            if (err) return true;
            err = move(x_post,z_post,j);
            if (err) return true;
            err = move(x_dock,z_dock,j);
            if (err) return true;
            
            // Squirt Water onto stack
            Serial.println("Wetting the stack");
            squirt();
            
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