function incircle()     
    %   Matlab script to input initial parameters for circle0 routine
    %   in main Map Window
    % turned into function by Celso G Reyes 2017
    
    error('replaced by circle_select_dlg');
    ZG=ZmapGlobal.Data; % used by get_zmap_globals

    %                                                R. Zuniga, 6/94
    
    report_this_filefun();
    %
    if isempty(ZG.newcat), ZG.newcat = ZG.primeCatalog; end   % verify whether to start with
    % original catalogue
    % make the interface for input
    %
    fig=figure('ToolBar','none');
    clf;
    cla;
    set(fig,'Name','Circle-Map Control Panel');
    %  set(gcf,'visible','off');
    set(gca,'visible','off');
    set(fig,'pos',[ 0.22  0.4 0.30 0.30])
    
    %
    freq_field1=uicontrol('Style','edit',...
        'Position',[.80 .70 .15 .10],...
        'Units','normalized','String',num2str(ZG.ni),...
        'callback',@callbackfun_001);
    
    freq_field2=uicontrol('Style','edit',...
        'Position',[.80 .55 .15 .10],...
        'Units','normalized','String',num2str(rad),...
        'callback',@callbackfun_002);
    
    freq_field3=uicontrol('Style','edit',...
        'Position',[.70 .40 .22 .10],...
        'Units','normalized','String',num2str(ya0,5),...
        'callback',@callbackfun_003);
    
    freq_field4=uicontrol('Style','edit',...
        'Position',[.70 .25 .22 .10],...
        'Units','normalized','String',num2str(xa0,6),...
        'callback',@callbackfun_004);
    
    close_button=uicontrol('Style','Pushbutton',...
        'Position',[.05 .85 .15 .1 ],...
        'Units','normalized','Callback',@(~,~)ZmapMessageCenter(),'String','Cancel');
    
    button1=uicontrol('Style','Pushbutton',...
        'Position',[.35 .15 .3 .1 ],...
        'Units','normalized',...
        'callback',@callbackfun_005,...
        'String','Center by Cursor');
    
    button2=uicontrol('Style','Pushbutton',...
        'Position',[.10 .05 .2 .1 ],...
        'Units','normalized',...
        'callback',@callbackfun_006,...
        'String','Fix Radius');
    
    button3=uicontrol('Style','Pushbutton',...
        'Position',[.70 .05 .3 .1 ],...
        'Units','normalized',...
        'callback',@callbackfun_007,...
        'String','ni Closest Events');
    
    txt5 = text(...
        'Position',[0. 0.75 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String','Number of events (ni):');
    
    txt4 = text(...
        'Position',[0. 0.58 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String','Radius (km):');
    
    txt3 = text(...
        'Position',[0. 0.41 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String','Latitude of center:');
    
    txt2 = text(...
        'Position',[0. 0.24 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String','Longitude of center:');
    
    set(gcf,'visible','on');
    
    
    
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.ni=str2double(mysrc.String);
    end
    
    function callbackfun_002(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        rad=str2double(mysrc.String);
    end
    
    function callbackfun_003(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ya0=str2double(mysrc.String);
        mysrc.String=num2str(ya0,6);
    end
    
    function callbackfun_004(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        xa0=str2double(mysrc.String);
        mysrc.String=num2str(xa0,6);
    end
    
    function callbackfun_005(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ic = 1;
        circle0;
    end
    
    function callbackfun_006(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZmapMessageCenter();
        ic = 2;
        circle0;
    end
    
    function callbackfun_007(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZmapMessageCenter();
        ic = 3;
        circle0;
    end
    function circle0() 
        %   "circle0"  selects events by :
        %   the Ni closest earthquakes to the center
        %   the maximum radius of a circle.
        %   the center point can be interactively selected or fixed by given
        %   coordinates (as given by incircle).
        %   Resets ZG.newcat and ZG.newt2.     Operates on the map window on  "primeCatalog".
        %                                                  R.Z. 6/94
        %
        % turned into function by Celso G Reyes 2017
        
        ZG=ZmapGlobal.Data; % used by get_zmap_globals
        
        report_this_filefun();

        delete(findobj('Tag','plos1'));
        new = a;
        figure(mess);
        clf
        set(gca,'visible','off')
        
        if ic == 1 | ic == 0
            te = text(0.01,0.90,'\newlinePlease use the LEFT mouse button or the cursor to \newlineselect the center point. The coordinates of the center \newlinewill be displayed on the control window.\newline \newlineOperates on the main subset of the catalogue. \newlineEvents selected form the new subset to operate on (ZG.newcat).');
            set(te,'FontSize',12);
            
            % Input center of circle with mouse
            %
            axes(h1)
            
            [xa0,ya0]  = ginput(1);
            
            stri1 = [ 'Circle: ' num2str(xa0,6) '; ' num2str(ya0,6)];
            stri = stri1;
            pause(0.1)
            set(gcf,'Pointer','arrow')
            plot(xa0,ya0,'+c');
            incircle
            
            
        elseif ic == 2
            figure(map);
            axes(h1)
            ZG.newt2 = ZG.primeCatalog.selectRadius(ya0, xa0, rad);
            %
            % plot events on map as 'x':
            
            set(gca,'NextPlot','add')
            plot(ZG.newt2.Longitude,ZG.newt2.Latitude,'xk','Tag','plos1');
            set(gcf,'Pointer','arrow')
            
            
            % Call program "timeplot to plot cumulative number
            %
            stri1 = [ 'Circle: ' num2str(xa0,6) '; ' num2str(ya0,6) '; R = ' num2str(rad) ' km'];
            stri = stri1;
            ZG.newt2.sort('Date');
            ZG.newcat = ZG.newt2;                   % resets ZG.newcat and ZG.newt2
            ctp=CumTimePlot(ZG.newt2);
            ctp.plot();
            
            ic = 1;
            
        elseif ic == 3
            figure(map);
            axes(h1)
            %  calculate distance for each earthquake from center point
            [ZG.newt2, max_km] = ZG.primeCatalog.selectClosestEvents(ya0, xa0, [], ni);
            messtext = ['Radius of selected Circle: ' num2str(max_km)  ' km' ];
            disp(messtext)
            
            
            % plot events on map as 'x':
            
            set(gca,'NextPlot','add')
            plot(ZG.newt2.Longitude,ZG.newt2.Latitude,'xk','Tag','plos1');
            set(gcf,'Pointer','arrow')
            
            ZG.newcat = ZG.newt2;                   % resets ZG.newcat
            
            % Call program "timeplot to plot cumulative number
            %
            stri1 = [ 'Circle: ' num2str(xa0,6) '; ' num2str(ya0,6)];
            stri = stri1;
            ctp=CumTimePlot(ZG.newt2);
            ctp.plot();
            
            ic = 1;
            
        end      % if ic
    end
    
end


