function mtrn4010_project01(file)
    global BUTTON;
    BUTTON.pause=0;
    BUTTON.end_now=0;
    clc(); close all;
    if ~exist('file','var'), file ='Laser__2.mat'; end
    load(file); figure(1) ; clf();
    
    guiHandles.Dots = plot(0,0,'b.',0,0,'r*',0,0,'gx'); 
    axis([-10,10,0,20]); xlabel('x (meters)'); ylabel('y (meters)'); 
    zoom on; grid on;     
    guiHandles.Title = title('');

    uicontrol('Style','pushbutton','String','pause/cont.','Position',[10,1,80,20],'Callback',{@myCallBackA,1});
    uicontrol('Style','pushbutton','String','end now','Position',[90,1,80,20],'Callback',{@myCallBackA,2});
    
    isLoop = 1;
    i = 1;
    while isLoop > 0 % while true
        if BUTTON.pause
            pause(0.2); continue;
        end
        scan_i = dataL.Scans(:,i);
        ProcessScan(scan_i,guiHandles);
        s=sprintf('Scan #[%d]/[%d]\r',i,dataL.N);
        title(s); pause(0.01) % wait for ~10ms (10 hz)
        i=i+1;
        if i > dataL.N
            isLoop = 0;
        elseif BUTTON.end_now == 1
            isLoop = 0;
        end
    end
    disp('done!');
    return;
end

function ProcessScan(scan, gui)
    % grabbing useful info
    mask1FFF = uint16(2^13-1);                      % 0-12 bits are range
    maskE000 = bitshift(uint16(7),13);              % 13-16 are intensity
    intensities = bitand(scan,maskE000);            % bitand operate to get intensity
    ranges = single(bitand(scan,mask1FFF))*0.01;    % bitand operate + typecast to single to get range in meters (with float type)
    angles  = [0:360]'*0.5* pi/180;                 % associated angle, for each individual range in a scan
    X = cos(angles).*ranges;                        % convert to cartisian
    Y = sin(angles).*ranges;
    R = [];                                         % reflective points
    count = 0;    
    for i=1:1:361
        if intensities(i)>0
            count = count + 1; R(count,1) = X(i); R(count,2) = Y(i);
        end
    end
    
    set(gui.Dots(1),'xdata',X,'ydata',Y);
    if count > 0
        set(gui.Dots(2),'xdata',R(:,1),'ydata',R(:,2));
    end
    tic;
    OOIs = extractOOIs(intensities, X, Y); 
    toc;
    plotOOIs(OOIs, gui);  
return;
end

function r = extractOOIs(intensities, X, Y)
    cluster_points = 0;
    cluster = 0;
    cluster_color = 0;
    
    r.N = 0;
    r.Centers = [];
    r.Sizes   = [];
    r.Colors = [];

    for i = 2:361
        dist(i-1) = sqrt((X(i-1)-X(i))^2 + (Y(i-1)-Y(i))^2);  % distance between the pre-successor and itself
        if intensities(i-1)~=0
            cluster_color = 1;
        end     
        cluster_points = cluster_points + 1; % find clusters in the map  
        if dist(i-1) > 0.2
            diameter = sqrt((X(i-cluster_points)-X(i-1))^2 + (Y(i-cluster_points)-Y(i-1))^2); % then determain whether the cluster is our OOI
            if (diameter>=0.05) && (diameter<=0.2) % it's our OOI
                cluster = cluster + 1;
                r(cluster).Centers = [mean(X((i-cluster_points):i-1)), mean(Y((i-cluster_points):i-1))];
                r(cluster).Sizes = diameter;
                r(cluster).Colors = cluster_color;
            end
            cluster_points = 0; % reset after the end of search cur_cluster
            cluster_color = 0;
        end  
    end
    r(1).N = cluster;
return;
end
    
function plotOOIs(OOIs,gui)
    if OOIs(1).N < 1 
        return; 
    end
    center = 0;
    count = 0;
    for i = 1:OOIs(1).N
        if OOIs(i).Colors == 1
            count = count + 1;
            center(count,1) = OOIs(i).Centers(1,1);
            center(count,2) = OOIs(i).Centers(1,2);
        end
    end
    
    if count == 1
        set(gui.Dots(3),'xdata',center(1,1),'ydata',center(1,2));
    elseif count > 1
        set(gui.Dots(3),'xdata',center(:,1),'ydata',center(:,2));
    end
    
return;
end

function myCallBackA(~,~,x)   
    global BUTTON;       
    if (x==1)
       BUTTON.pause = ~BUTTON.pause; %Switch ON->OFF->ON -> and so on.
       return;
    end
    if (x==2)
        disp('you pressed "END NOW"');
        BUTTON.end_now = 1;
        return;
    end
    return;    
end
