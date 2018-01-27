Make seperate entities for PWM contoller and an I2C slave and used both them to waork as a I2C slave PWM controller.
Once the I2C register address is sent and verified, the PWM data can be sent and can be changed for that register. We can stop using that I2C register and switch to other using stop bit. 
