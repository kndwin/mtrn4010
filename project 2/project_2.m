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
