function randomcat() % autogenerated function wrapper
%
% Input window for the random catalogue parameters. Called from
% startfd.m.%
%
%disp('fractal/codes/randomcat.m');
%
%
% Creates the input window
%
 % turned into function by Celso G Reyes 2017
 
ZG=ZmapGlobal.Data; % used by get_zmap_globals
figure_w_normalized_uicontrolunits('Units','pixel','pos',[300 100 350 500 ],'Name','Parameters','visible','off',...
    'NumberTitle','off','Color',color_fbg,'NextPlot','new');
axis off;

input1 = uicontrol('Style','edit','Position',[.70 .91 .22 .04],...
    'Units','normalized','String',num2str(numran),...
    'callback',@callbackfun_001);

input2 = uicontrol('Style','popupmenu','Position',[.57 .80 .40 .06],...
    'Units','normalized','String','Random in a box|Sier. Gasket 2D|Sier. Gasket 3D|Real with normal error',...
    'Value',1,'callback',@callbackfun_002);

input3 = uicontrol('Style','edit','Position',[.70 .53 .22 .04],...
    'Units','normalized','String',num2str(long1),'enable','on',...
    'callback',@callbackfun_003);

input4 = uicontrol('Style','edit','Position',[.70 .46 .22 .04],...
    'Units','normalized','String',num2str(long2),'enable','on',...
    'callback',@callbackfun_004);

input5 = uicontrol('Style','edit','Position',[.70 .39 .22 .04],...
    'Units','normalized','String',num2str(lati1),'enable','on',...
    'callback',@callbackfun_005);

input6 = uicontrol('Style','edit','Position',[.70 .32 .22 .04],...
    'Units','normalized','String',num2str(lati2),'enable','on',...
    'callback',@callbackfun_006);

input7 = uicontrol('Style','edit','Position',[.70 .25 .22 .04],...
    'Units','normalized','String',num2str(dept1),'enable','on',...
    'callback',@callbackfun_007);

input8 = uicontrol('Style','edit','Position',[.70 .18 .22 .04],...
    'Units','normalized','String',num2str(dept2),'enable','on',...
    'callback',@callbackfun_008);

input9 = uicontrol('Style','edit','Position',[.74 .75 .18 .04],...
    'Units','normalized','String',num2str(stdx),'enable','off',...
    'callback',@callbackfun_009);

input10 = uicontrol('Style','edit','Position',[.74 .69 .18 .04],...
    'Units','normalized','String',num2str(stdy),'enable','off',...
    'callback',@callbackfun_010);

input11 = uicontrol('Style','edit','Position',[.74 .63 .18 .04],...
    'Units','normalized','String',num2str(stdz),'enable','off',...
    'callback',@callbackfun_011);



tx1 = text('Position',[0 1.01 0 ], ...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Number of random events: ');

tx2 = text('Position',[0 .89 0 ], ...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Distribution: ');

tx3 = text('Position',[0 .53 0 ], ...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Longitude 1 [deg]: ');

tx4 = text('Position',[0 .445 0 ], ...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Longitude 2 [deg]: ');

tx5 = text('Position',[0 .36 0 ], ...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Latitude 1 [deg]: ');

tx6 = text('Position',[0 .275 0 ], ...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Latitude 2 [deg]: ');

tx7 = text('Position',[0 .19 0 ], ...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Minimum depth [km]: ');

tx8 = text('Position',[0 .105 0 ], ...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Maximum depth [km]: ');

tx9 = text('Position',[0 .81 0 ],'color', 'w',...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Std. deviation in longitude [km]: ');

tx10 = text('Position',[0 .74 0 ],'color', 'w',...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Std. deviation in latitude [km]: ');

tx11 = text('Position',[0 .66 0 ],'color', 'w',...
    'FontSize',ZmapGlobal.Data.fontsz.m , 'FontWeight','bold' , 'String',' Std. deviation in depth [km]: ');




close_button=uicontrol('Style','Pushbutton',...
    'Position',[.60 .02 .20 .07 ],...
    'Units','normalized','callback',@callbackfun_012,'String','Cancel');

go_button=uicontrol('Style','Pushbutton',...
    'Position',[.20 .02 .20 .07 ],...
    'Units','normalized',...
    'callback',@callbackfun_013,...
    'String','Go');



set(gcf,'visible','on');
watchoff;

function callbackfun_001(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  numran=str2double(input1.String);
   input1.String=num2str(numran);
end
 
function callbackfun_002(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  distr=(get(input2,'Value'));
   input2.Value=distr;
   actdistr;
end
 
function callbackfun_003(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  long1=str2double(input3.String);
   input3.String=num2str(long1);
end
 
function callbackfun_004(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  long2=str2double(input4.String);
   input4.String=num2str(long2);
end
 
function callbackfun_005(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  lati1=str2double(input5.String);
   input5.String=num2str(lati1);
end
 
function callbackfun_006(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  lati2=str2double(input6.String);
   input6.String=num2str(lati2);
end
 
function callbackfun_007(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  dept1=str2double(input7.String);
   input7.String=num2str(dept1);
end
 
function callbackfun_008(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  dept2=str2double(input8.String);
   input8.String=num2str(dept2);
end
 
function callbackfun_009(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  stdx=str2double(input9.String);
   input9.String=num2str(stdx);
end
 
function callbackfun_010(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  stdy=str2double(input10.String);
   input10.String=num2str(stdy);
end
 
function callbackfun_011(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  stdz=str2double(input11.String);
   input11.String=num2str(stdz);
end
 
function callbackfun_012(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  close;
  ZmapMessageCenter.set_info(' ',' ');
  
end
 
function callbackfun_013(mysrc,myevt)

  callback_tracker(mysrc,myevt,mfilename('fullpath'));
  close;
  
   if distr == [6];
   rndsph = 'distr3a';
   dorand;
   else dorand;
   end;
end
 
end
