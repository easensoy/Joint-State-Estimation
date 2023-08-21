%% initial commands
clear all;close all;clc
%% Model 
s = tf('s'); % Laplace variable
sys_cont = 10/(s+1)/(s+2); % transfer function in continuous-time domain
Ts = 0.1; % sampling interval [s]
sys_disc = c2d(sys_cont,Ts); % discretised transfer function

num = sys_disc.num{1}; % get numerator of discretised transfer function
den = sys_disc.den{1}; % get denominator of discretised transfer function

% get parameters of discrete-time model
a1 = den(2);
a2 = den(3);
b1 = num(2);
b2 = num(3);
c1 = 1;
c2 = -1.8;
%% Simulation setup
N = 1000; % number of samples
time = (0:N-1)*Ts; % time vector
sigma2e = 1e-4; % variance of noise
e = randn(1,N)*sqrt(sigma2e); % noise vector

u = 10*(randn(1,N)-0.5);
y = zeros(1,N); % initialise output vector

% System matrices
A = [0 -a2;
     1 -a1]; 
B = [b2;b1];
C = [0;1];
G = [c1-a2;c2-a1];


% Simulation
x = zeros(2,N); % `true' state vector
for k=2:N
    x(:,k) = A*x(:,k-1)+B*u(k)+G*e(k-1);
    y(:,k) = C'*x(:,k)+e(k);
end
%%
fs=13; % font size 
figure;
plot(time,u,'LineWidth',2','Color',[.5 .5 .5]);hold on;
plot(time,y,'LineWidth',2','Color','red','LineStyle','--');hold on;
plot(time,x,'LineWidth',2','Color','green','LineStyle','--');hold on;
xlabel('Time [s]','FontSize',fs)
ylabel('Signals','FontSize',fs)


legend('input','output', 'states')


%%

% Initialisation of EKF for joint parameter and state estimation

Rv = sigma2e;    % measurement (output) noise 
Rw = sigma2e;    % process noise
Rw_par = eye(4)*0;
Rw=zeros(5);
Rw(1,1)=sigma2e;
Rw(2:5,2:5)=Rw_par;

% Initialisation of KF
x_hat = zeros(2,N); % estimate of state vector 
P = eye(6)*1e4;
theta_hat = zeros(4,N); % estimate of parameter vector
epsilon=zeros(1,N);
z_hat = zeros(6,N); % estimate of extended vector 
G=[zeros(1,5);eye(5)];

for k=2:N
    
    A = [0 -theta_hat(2,k-1);
         1 -theta_hat(1,k-1)]; 
    B = [theta_hat(4,k-1);theta_hat(3,k-1)];
    G(1:2,1) = [-theta_hat(2,k-1);-theta_hat(1,k-1)];
    
    % Prediction step
    x_hat(:,k)=A*x_hat(:,k-1)+B*u(k-1);
    z_hat(:,k)=[x_hat(:,k);theta_hat(:,k-1)];
    
    F=[0 -theta_hat(2,k-1) 0 -x_hat(2,k-1) 0 u(k-1);
       1 -theta_hat(1,k-1) -x_hat(2,k-1) 0 u(k-1) 0
       0 0 1 0 0 0
       0 0 0 1 0 0
       0 0 0 0 1 0
       0 0 0 0 0 1];
    
    P=F*P*F'+G*Rw*G';
    
    C=[0;1;0;0;0;0];
      
    % Correction step 
    L=P*C*inv(Rv+C'*P*C);
    z_hat(:,k)=z_hat(:,k)+L*(y(:,k)-C'*z_hat(:,k));
    x_hat(:,k)=z_hat(1:2,k);
    theta_hat(:,k)=z_hat(3:end,k);
    P=P-L*C'*P;
        
end



%% Plot results 
figure
plot(time,y,'LineWidth',2','Color',[.5 .5 .5]);
plot(time,x(1,:),'LineWidth',2','Color','blue','LineStyle','-');hold on;
plot(time,x_hat(1,:),'LineWidth',2','Color','red','LineStyle','--')
xlabel('Time [s]','FontSize',fs)
ylabel('States','FontSize',fs)
legend('true x_1','estimated x_1')

figure
plot(time,y,'LineWidth',2','Color',[.5 .5 .5]);
plot(time,x(2,:),'LineWidth',2','Color','blue','LineStyle','-');hold on;
plot(time,x_hat(2,:),'LineWidth',2','Color','red','LineStyle','--')
xlabel('Time [s]','FontSize',fs)
ylabel('States','FontSize',fs)
legend('true x_2','estimated x_2')

%% Parameter estimation
figure
start=50;
subplot(211)
plot(time(start:end),a1*ones(1,N-start+1),'LineWidth',2','Color','green');hold on
plot(time(start:end),theta_hat(1,(start:end)),'LineWidth',2','Color','blue')
ylabel('a_1')
xlabel('Time [s]')
legend('true','estimated')
axis tight

subplot(212)
plot(time(start:end),a2*ones(1,N-start+1),'LineWidth',2','Color','green');hold on
plot(time(start:end),theta_hat(2,(start:end)),'LineWidth',2','Color','blue')
ylabel('a_2')
xlabel('Time [s]')
legend('true','estimated')
axis tight


figure
start=50;
subplot(211)
plot(time(start:end),b1*ones(1,N-start+1),'LineWidth',2','Color','green');hold on
plot(time(start:end),theta_hat(3,(start:end)),'LineWidth',2','Color','blue')
ylabel('b_1')
xlabel('Time [s]')
legend('true','estimated')
axis tight

subplot(212)
plot(time(start:end),b2*ones(1,N-start+1),'LineWidth',2','Color','green');hold on
plot(time(start:end),theta_hat(4,(start:end)),'LineWidth',2','Color','blue')
ylabel('b_2')
xlabel('Time [s]')
legend('true','estimated')
axis tight

