function mtrn4010_project01(file)
    % grab data file
    clc(); close all;   %clean the terminal log + close all open simulations
    if ~exist('file','var'), file ='Laser__2.mat'; end; load(file); %find the file
    % initailise handles
    figure(1) ; clf(); 
    guiHandles.Dots = plot(0,0,'b.',0,0,'r*',0,0,'g+'); 
    axis([-10,10,0,20]); xlabel('x (meters)'); ylabel('y (meters)'); zoom on; grid on;     
    guiHandles.Title = title('');

    %start loop
%    for i=1:1:dataL.N                        % in this example, I skip some of them..
    for i=1:1:1                        % in this example, I skip some of them..
        t = double(dataL.times(i)-dataL.times(1))/10000;
        scan_i = dataL.Scans(:,i);
        ProcessScan(scan_i,t,guiHandles);

        s=sprintf('Scan #[%d]/[%d]\r',i,dataL.N);
        title(s);
        pause(0.01) ;                   % wait for ~10ms
    end
    disp('done!');
    return;
end

function ProcessScan(scan, t, gui)
    % grabbing useful info
    mask1FFF = uint16(2^13-1);                      % 0-12 bits are range
    maskE000 = bitshift(uint16(7),13);              % 13-16 are intensity
    intensities = bitand(scan,maskE000);            % bitand operate to get intensity
    ranges = single(bitand(scan,mask1FFF))*0.01;    % bitand operate + typecast to single to get range in meters (with float type)
    angles  = [0:360]'*0.5* pi/180;                 % associated angle, for each individual range in a scan
    % convert to cartisian
    X = cos(angles).*ranges;                        % find the low reflective points
    Y = sin(angles).*ranges;   
    R = [];
    count = 0;
    for i=1:1:361
        if intensities(i) > 0
            count = count + 1;
            R(1,count) = X(i);
            R(2,count) = Y(i);
        else
        end
    end
    R
    set(gui.Dots(1),'xdata',X,'ydata',Y);
    set(gui.Dots(2),'xdata',R(1,:),'ydata',R(2,:));
    % extract OOI's 
    OOIs = extractOOIs(ranges,intensities, X, Y); 
    plotOOIs(OOIs, X, Y, gui);
return;
end

function r = extractOOIs(range, i, X, Y)
    r.N = 0;
    r.S  = [];
    r.C = [];
    % your part....
    distanceBetweenPoints = zeros(360,1);
    for i=1:1:360
        distanceBetweenPoints(i) = sqrt((X(i+1)-X(i))^2 + (Y(i+1)-Y(i))^2);       
    end
    distanceBetweenPoints(361) = 0;
    distanceBetweenPoints
    for i=1:1:361
        if distanceBetweenPoints(i) < 0.08
            r.N = r.N + 1;
            r.C(1,r.N) = X(i);
            r.C(2,r.N) = Y(i);
        else
        end
    end
    
    
    distanceBetweenPoints
    r.N 
%     
    subplot(2,1,1);
    plot (distanceBetweenPoints); grid on;
    subplot(2,1,2);
    plot(X,Y,'b.',r.C(1,:),r.C(2,:),'r+')

%     r.N
%     t.xb = nonzeros(r.xb);
%     t.yb = nonzeros(r.yb);
%     t.xe = nonzeros(r.xe);
%     t.ye = nonzeros(r.ye);
%     t.xc = (t.xb+t.xe)/2;
%     t.yc = (t.yb+t.ye)/2;
     
%   subplot(2,1,2);
%   plot(angles, range);
%   subplot(2,1,1);
%   plot(X,Y,'b.',r.xb,r.yb,'r+',r.xe, r.ye,'g+', r.centrex, r.centrey, 'ko');
%     plot(X,Y,'b.',r.C(1,:),r.C(2,:),'r+')
%     t.xe, t.ye,'g+', t.xc, t.yc, 'ko');
%     axis([-10,10,0,10]); grid on;
        
return;
end
    
function plotOOIs(OOIs, X, Y, gui)
    % if OOIs.N<1, return ; end;
    % your part....
    Xc = zeros(361,1);
    Yc = zeros(361,1); 
%    set(gui.Dots(3),'xdata',Xc,'ydata',Yc); 
return;
end