% % question 1
% A = 100;    %angular acceleration
% B = 2;      %angular speed
% C = 1;      %volts
% 
% dt = 1/1000;
% duration = 7;     % Simulation horizon
% times = (0:dt:duration);
% N = length(times)-1;
% 
% x1(1) = pi/3;
% x2(1) = 0;
% 
% u = 10;
% 
% for i=1:N %iterations / Loop
%     
%     if (i > 1000 && i < 2000) %first condition
%         u = 10;
%     elseif (i > 3000 && i < 4000)
%         u = 20;
%     else
%         u = 0;
%     end
%             
%     x1(i+1) = x1(i) + dt*x2(i);
%     x2(i+1) = x2(i) + dt*[-A*sin(x1(i))-B*x2(i)+C*u];
% end
% 
% 
% subplot(2,1,1);
% plot(times,rad2deg(x1)) ; xlabel('time (s)'); ylabel('angle (deg)'); title('Angular position'); grid on;
% subplot(2,1,2);
% plot(times,rad2deg(x2)) ; xlabel('time (s)'); ylabel('angle velocity (deg/2)'); title('Angular velocity'); grid on;

% question 2

% A = [0.9    0.1     0.1;
%      0.1    0.9     0.3;
%      0     -0.3     0.9];   
%  
% B = [0; 
%      0; 
%      1];
% 
% x(1,:) = 0;
% x = zeros (3,1);
% u = 0;
% 
% for k=1:500 %iterations / Loop
%     
%     if (k  >= 10 && k <= 20) %first condition
%         u = 1;
%     elseif (k >= 21 && k <= 30)
%         u = 2;
%     else
%         u = 0;
%     end
%     
%     x(:,k+1) = A*x(:,k) + B*u; 
% end
% 
% subplot (1,1,1);
% plot3(x(1,:), x(2,:), x(3,:))

% problem 3

% mu = 1;
% x = [-5:0.1:5];
% 
% 
% var = 2;
% sigma = sqrt(var);
% pd1 = makedist('Normal','mu',mu,'sigma',sigma);
% y = pdf (pd1,x);
% plot(x,y); hold on;
% 
% var = 16;
% sigma = sqrt(var);
% pd2 = makedist('Normal','mu',mu,'sigma',sigma);
% y = pdf (pd2,x);
% plot(x,y);
% 
% var = 0.2;
% sigma = sqrt(var);
% pd3 = makedist('Normal','mu',mu,'sigma',sigma);
% y = pdf (pd3,x);
% plot(x,y); 
% 
% var = 0.01;
% sigma = sqrt(var);
% pd4 = makedist('Normal','mu',mu,'sigma',sigma);
% y = pdf (pd4,x);
% plot(x,y); 
% 
% var = 10000;
% sigma = sqrt(var);
% pd5 = makedist('Normal','mu',mu,'sigma',sigma);
% y = pdf (pd5,x);
% plot(x,y); 

% question 4

x = zeros(3,1);
u = [2;     %alpha
     3];    %v;
L = 2;

for k=1:500 %iterations / Loop
    
    if (k == 200)
        u(1,1) = -1*u(1,1);
    end

    x(1,k+1) = x(1,k) + 0.01*u(2,1)*cos(x(3,k));
    x(2,k+1) = x(2,k) + 0.01*u(2,1)*sin(x(3,k));
    x(3,k+1) = x(3,k) + 0.01*u(2,1)*tan(u(1,1)/L);
    %    x(:,k+1) = A*x(:,k) + B*u;
end
subplot (2,1,1); plot(x(1,:),x(2,:)); grid on;
subplot (2,1,2); plot(x(3,:)); grid on;
