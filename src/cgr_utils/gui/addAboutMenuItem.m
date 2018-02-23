function addAboutMenuItem()
    % ADDABOUTMENUITEM add about menu to Help menu
    hAbout = findall(gcf,'Label','About ZMAP');
    if ~isempty(hAbout)
        delete(hAbout);
        hAbout=[];
    end
    hAbout2 = findall(gcf,'Label','Report a ZMAP Issue');
    if ~isempty(hAbout2)
        delete(hAbout2);
    end
    if isempty(hAbout)
        mainhelp=findall(gcf,'Tag','figMenuHelp');
        if isempty(mainhelp) 
            mainhelp=findobj(gcf,'Label','Help');
            if isempty(mainhelp)
                mainhelp=uimenu(gcf,'Label','Help');
            end
        end
        uimenu(mainhelp,'Label','Report a ZMAP Issue','Separator','on','Callback',@(~,~)reportIssue);
        uimenu(mainhelp,'Label','About ZMAP','Separator','on','Callback',@(~,~)aboutZmapDialog);
    end
end

function reportIssue()
        h=helpdlg('Please enter an issue in the Github project main page');
        uiwait(h);
    if datetime < datetime(2018,6,30)
        web('https://gitlab.seismo.ethz.ch/reyesc/zmap/issues','-browser')
    else
        errordlg('Need to determine where to report issues');
    end
end

function aboutZmapDialog()
    
    citationText = ['Wiemer, S., 2001. ', ...
        'A software package to analyze seismicity: ZMAP. ',...
        'Seismological Research Letters, 72(3), pp.373-382.'];
    
    citationDOI = 'https://doi.org/10.1785/gssrl.72.3.373';
    
    copyrightMessage = sprintf('%s %s SED at ETH',char(169),'1993 - 2018');
    
    contributors = fileread('ZmapContributorList.txt');
    H = 400; W = 600;
    B1 = 10;
    fig=figure('MenuBar','none','NumberTitle','off','Name','About Zmap','Units','pixels');
    fig.Position([3 4])=[W H];
    
    ZG=ZmapGlobal.Data;
    
    % show zmap version
    uicontrol(fig,'Style','Text',...
        'Units','pixels','Position',[B1 H-60 W-2*B1 45 ],...
        'FontSize',24,'FontWeight','bold',...
        'String',['ZMAP Version ',ZG.zmap_version]);
    
    
    uicontrol(fig,'Style','Text',...
        'Units','pixels','Position',[B1 H-70 W-2*B1 20 ],...
        'FontSize',14,...
        'String',copyrightMessage);
    
    uicontrol(fig,'Style','Text',...
        'Units','pixels','Position',[B1 285 250 20 ],...
        'FontSize',12,...
        'String',sprintf('Minimum MATLAB vers : %s - R%s',ZG.min_matlab_version, ZG.min_matlab_release));
    
    %citation
    h=uipanel(fig,'Units','pixels','position',[10 179 265 70],'Tag','citation')
    h.Title='CITATION';
    % clicking on it will copy
    %h.ButtonDownFcn=@(~,~)clipboard('copy',citationText);
    t=uicontrol(h,'Style','Text','Units','Pixels','Position',[1 1 265 50])
    t.String=citationText;
    
    c = uicontextmenu;
    uimenu(c,'Label','view original document','Callback',@(~,~)web('https://doi.org/10.1785/gssrl.72.3.373','-browser'));
    uimenu(c,'Label','copy to clipboard','Callback',@(~,~)clipboard('copy',[citationText '. doi: ' citationDOI]));
    h.UIContextMenu=c;
    t.UIContextMenu=c;
    t.TooltipString = ['<html><b>' strrep(citationText, '. ' , '.<br>') '</b><br><br>Left-click for copy options'];
    
    % contributors
    uicontrol(fig,'Style','Text',...
        'Units','pixels','Position',[280  300 310 14],...
        'FontWeight','bold',...
        'String','ZMAP Authors and Contributors');
    uicontrol(fig,'Style','listbox','Position',[280  178 309 118],...
        'String', contributors,'Tag','Contributors' );
    
    % show the SED logo, which will bring user to the main SED webpage
    upan = uipanel(fig,'Units','pixels','Position',[B1 50 W-2*B1 120],'BackgroundColor','w');
    rgb=imread('resources/logos/SED_ETH_Lang_2014_RGB.jpg');
    ax=axes(upan,'units','pixels','Position',[5 5 upan.Position(3:4)-10]);
    im=image(ax,rgb);
    axis(ax,'equal')
    ax.Visible='off';
    im.ButtonDownFcn=@(~,~)web('www.seismo.ethz.ch','-browser');
    
    % add a close button
    p=fig.Position;
    p(1)=p(3)/2 - 30;
    p(3)=60;
    p(4)=30;
    p(2)=B1;
    uicontrol(fig,'Style','pushbutton','String','Close',...
        'Units','pixels','Position',p,'Callback',@(~,~)close(fig));
    
    % uiwait(fig);
end
