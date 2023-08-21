# Joint-State-Estimation

## Figure 1
The colors in Figure 1 represent the different signals in the system. The gray signal represents the input, the red signal represents the output, and the green signal represents the states.

The input signal is the random signal that is applied to the system. 

The output signal is the filtered version of the input signal that is produced by the system.

The states are the real numbers that describe the state of the system such as position and velocity.

![figure1](https://github.com/easensoy/Joint-State-Estimation/assets/76905667/b0899060-c398-4ce5-ae16-b8d625dd55af)

Time [s] : This is the horizontal axis and it represents the time.

Signals : This is the vertical axis and it represents the signals. The three signals shown in the figure are the input, output, and states of the system.

## Figure 2 
Figure 2 shows the true and estimated parameters of the system. The blue line represents the true parameters, and the red line represents the estimated parameters. They represent the true and estimated values of the first state variable of the system over time.

![figure2](https://github.com/easensoy/Joint-State-Estimation/assets/76905667/a4cae220-34ad-4da2-a269-e49683ae6606)

The true x1 is the actual value of the first state variable that results from the system's dynamics, while the estimated x1 is obtained using the Extended Kalman Filter (EKF) to estimate the state variable based on the available measurements.

## Figure 3

Figure 3 represents the true and estimated values of the second state variable of the system over time. The second state variable is the velocity of the system.

![figure3](https://github.com/easensoy/Joint-State-Estimation/assets/76905667/d119f5c8-fad8-4604-9eae-16206aa5e176)

The true x2 is the actual value of the velocity, and the estimated x2 is the value of the velocity that is estimated by the EKF. As you can see, the EKF is able to estimate the velocity very well.

## Figure 4

In Figure 4, the true and estimated values for a1 and a2 represent the true and estimated parameter values of the system's state-space representation over time.

True a1 and a2 (Green Lines):
The true values of a1 and a2 are the actual parameter values of the system's state-space representation. These parameters influence the behavior of the system and are used in defining the system matrices A, B, and G. In your code, these values are derived from the original continuous-time transfer function and are constants. The green lines in Figure 4 show how the true parameter values remain constant over time.


![figure4](https://github.com/easensoy/Joint-State-Estimation/assets/76905667/d62cc7e6-75fb-4ef2-81f1-59deeb1354b9)

Estimated a1 and a2 (Blue Lines):
The estimated values of a1 and a2 are obtained using the Extended Kalman Filter (EKF) to estimate the parameter values based on the available measurements (output measurements in this case) and the model's internal dynamics. The EKF continuously updates the estimates of these parameters over time to match the observed behavior of the system. The blue lines in Figure 4 show how the estimated parameter values change over time as estimated by the EKF.

## Figure 5 

Extended Kalman Filter (EKF) implementation for joint parameter and state estimation of a dynamic system. 

Figure 5 is used to display the true and estimated values of the parameters b1 and b2 of the system over time. These parameters are associated with the input signal u and influence how the input affects the system's state dynamics and output response.

Top Subplot:
The top subplot shows the true value of b1 (represented as a constant green line) and the estimated value of b1 (represented as a blue line) over time. The true value of b1 is a constant value that was assigned earlier in the code. The estimated value of b1 is obtained through the Extended Kalman Filter estimation process, which uses the available measurements and the system's model to continuously update the estimate of b1 over time.

![figure5](https://github.com/easensoy/Joint-State-Estimation/assets/76905667/8da22132-7b5f-478d-9540-3b2ef637c5a0)

Bottom Subplot:
The bottom subplot shows the true value of b2 (represented as a constant green line) and the estimated value of b2 (represented as a blue line) over time. Similar to b1, the true value of b2 is constant, and the estimated value of b2 is continuously updated by the EKF based on measurements and model dynamics.
