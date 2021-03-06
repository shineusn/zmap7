function clcircle(var1)
    % clcircle.m                              A.Allmann
    %   Matlab input window for circle options
    %   in main Cluster Menu
    %
    %Last modification 6/95
    global mess clu rad ni newt2 newclcat equi backequi bgevent backbgeven
    global original clust h5 xa0 ya0 backcat
    global freq_field1 freq_field2 freq_field3 freq_field4
    global button1 button2 button3 st1 go_button
   global  sys minmag par1 ccum file1
    global clclose_button
    ni=10;rad=100;xa0=[];ya0=[];       %default values
    % make the interface for input
    %
    figure_w_normalized_uicontrolunits(mess)
    clf;
    cla;
    set(gcf,'Name','Circle-Map Control Panel');
    %  set(gcf,'visible','off');
    set(gca,'visible','off');
    set(gcf,'pos',[ 0.02  0.9 0.35 0.35])

    %
    freq_field1=uicontrol('Style','edit',...
        'Position',[.80 .70 .15 .10],...
        'Units','normalized','String',num2str(ni),...
        'Callback','ni=str2double(get(freq_field1,''String'')); set(freq_field1,''String'',num2str(ni));');

    freq_field2=uicontrol('Style','edit',...
        'Position',[.80 .55 .15 .10],...
        'Units','normalized','String',num2str(rad),...
        'Callback','rad=str2double(get(freq_field2,''String'')); set(freq_field2,''String'',num2str(rad));');

    freq_field3=uicontrol('Style','edit',...
        'Position',[.80 .40 .15 .10],...
        'Units','normalized','String',num2str(ya0),...
        'Callback','ya0=str2double(get(freq_field3,''String'')); set(freq_field3,''String'',num2str(ya0));');

    freq_field4=uicontrol('Style','edit',...
        'Position',[.80 .25 .15 .10],...
        'Units','normalized','String',num2str(xa0),...
        'Callback','xa0=str2double(get(freq_field4,''String'')); set(freq_field4,''String'',num2str(xa0));');

    if var1==1         %call from Cluster Menu
        st1=['if get(button1,''value'')==1,clcirc(1);else,clcirc(2);end;']; % st1 is global
    elseif var1==2       %call from Cluster
        st1=['if get(button1,''value'')==1,clcirc(7);else,clcirc(8);end;']; % st1 is global
    end
    go_button=uicontrol('Style','Pushbutton',...
        'Position',[.35 .85 .15 .1 ],...
        'Units','normalized','Callback',st1,'String',' Go '); % st1 is global

    clclose_button=uicontrol('Style','Pushbutton',...
        'Position',[.05 .85 .15 .1 ],...
        'Units','normalized','Callback', 'welcome;clear clclose_button;',...
        'String','Cancel');

    button1=uicontrol('Style','check',...
        'Position',[.32 .13 .32 .09 ],...
        'Units','normalized',...
        'String','Center by Cursor');

    button2=uicontrol('Style','check',...
        'Position',[.03 .13 .25 .09 ],...
        'Units','normalized',...
        'String','Fix Radius');

    button3=uicontrol('Style','check',...
        'Position',[.68 .13 .32 .09 ],...
        'Units','normalized',...
        'String','ni Closest Events');

    txt5 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0. 0.75 0 ],...
        'Rotation',0 ,...
        'FontSize',12 ,...
        'String','Number of events (ni):');

    txt4 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0. 0.58 0 ],...
        'Rotation',0 ,...
        'FontSize',12 ,...
        'String','Radius (km):');

    txt3 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0. 0.41 0 ],...
        'Rotation',0 ,...
        'FontSize',12 ,...
        'String','Latitude of center:');

    txt2 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0. 0.24 0 ],...
        'Rotation',0 ,...
        'FontSize',12 ,...
        'String','Longitude of center:');

    set(gcf,'visible','on');


