function ctimeplot() 
    % ctimeplot plots the events select by "circle" or by other selection button as a cummultive number versus time plot in window 2.
    % Time of events with a Magnitude greater than ZG.CatalogOpts.BigEvents.MinMag will
    % be shown on the curve.  Operates on ZG.newt2, resets  b  to ZG.newt2,
    %     ZG.newcat is reset to:
    %                       - "primeCatalog" if either "Back" button or "Close" button is         %                          pressed.
    %                       - ZG.newt2 if "Save as Newcat" button is pressed.
    %
    % turned into function by Celso G Reyes 2017
    %
    % Probably replaced by CumTimePlot
    
    ZG=ZmapGlobal.Data;
    ZmapMessageCenter.set_info(' ','Plotting cumulative number plot...');
    
    report_this_filefun();
    
    myFigName='Cumulative Number';
    myFigFinder=@() findobj('Type','Figure','-and','Name',myFigName);
    
    % This is the info window text
    %
    ttlStr='The Cumulative Number Window                  ';
    hlpStr1= ...
        ['                                                     '
        ' This window displays the seismicity in the sel-     '
        ' ected area as a cumulative number plot.             '
        ' Options from the Tools menu:                        '
        ' Cuts in magnitude and  depth: Opens input para-     '
        '    meter window                                     '
        ' Decluster the catalog: Will ask for declustering    '
        '     input parameter and decluster the catalog.      '
        ' AS(t): Evaluates significance of seismicity rate    '
        '      changes using the AS(t) function. See the      '
        '      Users Guide for details                        '
        ' LTA(t), Rubberband: dito                            '
        ' Overlay another curve (hold): Allows you to plot    '
        '       one or several more curves in the same plot.  '
        '       select "Overlay..." and then selext a new     '
        '       subset of data in the map window              '
        ' Compare two rates: start a comparison and moddeling '
        '       of two seismicity rates based on the assumption'
        '       of a constant b-value. Will calculate         '
        '       Magnitude Signature. Will ask you for four    '
        '       times.                                        '
        '                                                     '];
    hlpStr2= ...
        ['                                                      '
        ' b-value estimation:    just that                     '
        ' p-value plot: Lets you estimate the p-value of an    '
        ' aftershock sequence.                                 '
        ' Save cumulative number cure: Will save the curve in  '
        '        an ASCII file                                 '
        '                                                      '
        ' The "Keep as ZG.newcat" button in  lower right corner'
        ' will make the currently selected subset of eartquakes'
        ' in space, magnitude and depth the current one. This  '
        ' will also redraw the Map window!                     '
        '                                                      '
        ' The "Back" button will plot the original cumulative  '
        ' number curve without statistics again.               '
        '                                                      '];
    
    global  pplot tmp1 tmp2 tmp3 tmp4 difp loopcheck Info_p
    global cplot mess statime maxde minde
    global maxma2 minma2
    ZG=ZmapGlobal.Data;
    
    cum = myFigFinder();
    
    % Set up the Cumulative Number window
    
    if isempty(cum)
        cum = figure_w_normalized_uicontrolunits( ...
            'Name',myFigName,...
            'NumberTitle','off', ...
            'NextPlot','replace', ...
            'backingstore','on',...
            'Visible','off', ...
            'Tag','cum',...
            'Position',position_in_current_monitor(ZG.map_len(1)-100, ZG.map_len(2)-20));
        
        winlen_days = days(ZG.compare_window_dur/ZG.bin_dur);
        create_my_menu();
        
        
        uicontrol('Units','normal',...
            'Position',[.0  .85 .08 .06],'String','Info ',...
            'callback',@cb_info)
        
        uicontrol('Units','normal',...
            'Position',[.0  .75 .08 .06],'String','Close ',...
            'callback',@cb_close)
        
        uicontrol('Units','normal',...
            'Position',[.0  .93 .08 .06],'String','Print ',...
            'callback',@cb_print)
        
        
        uicontrol('Units','normal','Position',[.9 .10 .1 .05],'String','Back', 'callback',@cb_back)
        
        uicontrol('Units','normal','Position',[.65 .01 .3 .07],'String','Keep as ZG.newcat', 'callback',@cb_keepas_newcat)
        
        
    end
    figure(cum);
    ht=gca;
    if ZmapGlobal.Data.hold_state
        cumu = 0:1:(tdiff/days(ZG.bin_dur))+2;
        cumu2 = 0:1:(tdiff/days(ZG.bin_dur))-1;
        cumu = cumu * 0;
        cumu2 = cumu2 * 0;
        n = ZG.newt2.Count;
        [cumu, xt] = hist(ZG.newt2.Date,(t0b:days(ZG.bin_dur):teb));
        cumu2 = cumsum(cumu);
        
        set(gca,'NextPlot','add')
        axes(ht)
        plot(xt,cumu2,'r','LineWidth',2.5,'Tag','tiplo2');
        
        ZG.hold_state=false
        return
    end
    
    figure(cum);
    delete(findobj(cum,'Type','axes'));
    reset(gca)
    %delete(sicum)
    cla
    watchon;
    
    set(gca,'visible','off','FontSize',ZmapGlobal.Data.fontsz.m,'FontWeight','bold',...
        'FontWeight','bold','LineWidth',1.5,...
        'Box','on','SortMethod','childorder')
    
    if isempty(ZG.newcat), 
        ZG.newcat =ZG.primeCatalog;
    end
    
    % select big events ( > ZG.CatalogOpts.BigEvents.MinMag)
    %
    l = ZG.newt2.Magnitude > ZG.CatalogOpts.BigEvents.MinMag;
    big = ZG.newt2.subset(l);
    %big=[];
    %calculate start -end time of overall catalog
    %R
    statime=[];
    par2 = ZG.bin_dur;
    [t0b, teb] = ZG.primeCatalog.DateRange() ;
    n = ZG.newt2.Count;
    ttdif=days(teb - t0b);
    if ttdif>10                 %select bin length respective to time in catalog
        ZG.bin_dur = days(ceil(ttdif/300));
    elseif ttdif<=10  &&  ttdif>1
        ZG.bin_dur = days(0.1);
    elseif ttdif<=1
        ZG.bin_dur = days(0.01);
    end
    
    
    if ZG.bin_dur>=1
        tdiff = round((teb-t0b)/ZG.bin_dur);
        %tdiff = round(teb - t0b);
    else
        tdiff = (teb-t0b)/days(ZG.bin_dur);
    end
    
    % calculate cumulative number versus time and bin it
    %
    n = ZG.newt2.Count;
    if ZG.bin_dur >=1
        [cumu, xt] = histcounts(ZG.newt2.Date, 'BinWidth',ZG.bin_dur); % was hist
    else
        [cumu, xt] = hist((ZG.newt2.Date-ZG.newt2.Date(1)+days(ZG.bin_dur))*365,(0:ZG.bin_dur:(tdiff+2*ZG.bin_dur)));
    end
    delt=days(ZG.bin_dur)/2;
    xt = xt(1:end-1) + delt; % convert from bin edges to bin centers
    cumu2=cumsum(cumu);
    % plot time series
    %
    %orient tall
    set(gcf,'PaperPosition',[0.5 0.5 6.5 9.5])
    rect = [0.25,  0.18, 0.60, 0.70];
    axes('position',rect)
    set(gca,'NextPlot','add')
    
    set(gca,'visible','off')
    plot(xt,cumu2,'b','LineWidth',2.5,'Tag','tiplo2');
    
    
    % plot big events on curve
    %
    if ZG.bin_dur>=1
        if ~isempty(big)
            if ceil(big.Date -t0b) > 0
                f = cumu2(ceil((big.Date -t0b)/ZG.bin_dur));
                bigplo = plot(big.Date,f,'xr');
                set(bigplo,'MarkerSize',10,'LineWidth',2.5)
                stri4 = [];
                for i = 1:big.Count
                    s = sprintf('  M=%3.1f',big.Magnitude(i));
                    stri4 = [stri4 ; s];
                end   % for i
                
                te1 = text(big.Date,f,stri4);
                set(te1,'FontWeight','bold','Color','m','FontSize',ZmapGlobal.Data.fontsz.s)
            end
            
            %option to plot the location of big events in the map
            %
            % figure(map);
            % plog = plot(big(:,1),big(:,2),'or');
            %set(plog,'MarkerSize',ms10,'LineWidth',2.0)
            %figure(cum);
            
        end
    end %if big
    
    if exist('stri', 'var')
        v = axis;
        %if ZG.bin_dur>=1
        % axis([ v(1) ceil(teb) v(3) v(4)+0.05*v(4)]);
        %end
        tea = text(v(1)+0.5,v(4)*0.9,stri) ;
        set(tea,'FontSize',ZmapGlobal.Data.fontsz.m,'Color','k','FontWeight','bold')
    end %% if stri
    
    strib = [ZG.newt2.Name];
    
    title(strib,'FontWeight','bold',...
        'FontSize',ZmapGlobal.Data.fontsz.l,...
        'Color','k','interpreter','none')
    
    grid
    if ZG.bin_dur>=1
        xlabel('Time in years ','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
    else
        statime=ZG.newt2.Date(1)-days(ZG.bin_dur);
        xlabel(['Time in days relative to ',num2str(statime)],'FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
    end
    ylabel('Cumulative Number ','FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m)
    ht = gca;
    % set(gca,'Color',color_bg);
    
    %clear strib stri4 s l f bigplo plog tea v
    % Make the figure visible
    %
    set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.m,'FontWeight','bold',...
        'FontWeight','bold','LineWidth',1.5,...
        'Box','on')
    figure(cum);
    %sicum = signatur('ZMAP','',[0.65 0.98 .04]);
    %set(sicum,'Color','b')
    axes(ht);
    set(cum,'Visible','on');
    watchoff(cum)
    watchoff(map)
    ZG.bin_dur = par2; assert(isa(par2,'datetime'));
    
    
    
    %% ui functions
    function create_my_menu()
        add_menu_divider();
        options = uimenu('Label','Tools ');
        
        uimenu(options,'Label','Cuts in magnitude and depth',MenuSelectedField(),@cb_cut_mag_depth)
        uimenu (options,'Label','Decluster the catalog',MenuSelectedField(),@(~,~)ResenbergDeclusterClass(catalog));
        uimenu(options,'Label','AS(t)function',MenuSelectedField(),@(~,~)newsta('ast',ZG.newt2));
        uimenu(options,'Label','Rubberband function',MenuSelectedField(),@(~,~)newsta('rub',ZG.newt2));
        uimenu(options,'Label','LTA(t) function ',MenuSelectedField(),@(~,~)newsta('lta',ZG.newt2));
        uimenu(options,'Label','Overlay another curve (hold)',MenuSelectedField(),@cb_overlayanothercurve)
        uimenu(options,'Label','Compare two rates ( No fit)',MenuSelectedField(),@(~,~)dispma3())
        
        op4 = uimenu(options,'Label','b-value estimation');
        uimenu(op4,'Label','manual',MenuSelectedField(),@(~,~)bfitnew(ZG.newt2))
        uimenu(op4,'Label','automatic',MenuSelectedField(),@(~,~)bdiff(ZG.newt2))
        uimenu(op4,'Label','b with depth',MenuSelectedField(),@(~,~)bwithde(ZG.newt2))
        uimenu(op4,'Label','b with time',MenuSelectedField(),@(~,~)bwithti(ZG.newt2))
        
        op5 = uimenu(options,'Label','p-value estimation');
        uimenu(op5,'Label','manual',MenuSelectedField(),@cb_man_pval_estimation)
        uimenu(op5,'Label','automatic',MenuSelectedField(),@cb_auto_pval_estimation)
        uimenu(options,'Label','get coordinates with Cursor',MenuSelectedField(),@cb_getcoord_with_cursor)
        uimenu(options,'Label','Cumlative Moment Release ',MenuSelectedField(),@cb_cum_moment_release)
        uimenu(options,'Label','Time Selection',MenuSelectedField(),@cb_time_selection);
        %uimenu(options,'Label',' Magnitude signature',MenuSelectedField(),@cb_mag_signature)
        uimenu(options,'Label','Save cumulative number curve',MenuSelectedField(),@cb_save_cumnumcurve)
        calSave =...
            [ 'ZmapMessageCenter.set_info(''Save Data'',''  '');',...
            '[file1,path1] = uigetfile(fullfile(ZmapGlobal.Data.Directories.output, ''*.dat''), ''Earthquake Datafile'');',...
            'out=[xt;cumu2]'';',...
            ' sapa = [''save '' path1 file1 '' out  -ascii''];',...
            'eval(sapa) ; '];
        
    end
    
    %% callback functions
    
    function cb_cut_mag_depth(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG=ZmapGlobal.Data;
        cf=@()ZG.newt2;
        [ZG.newt2,ZG.maepi,ZG.CatalogOpts.BigEvents.MinMag]=catalog_overview(ZmapCatalogView(cf),ZG.CatalogOpts.BigEvents.MinMag);
    end
    
    function cb_overlayanothercurve(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG=ZmapGlobal.Data;
        ZG.hold_state=true;
    end
    
    function cb_man_pval_estimation(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.ttcat = ZG.newt2;
        clpval(1);
    end
    
    function cb_auto_pval_estimation(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.ttcat =ZG.newt2;
        clpval(3);
    end
    
    function cb_getcoord_with_cursor(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        gi = ginput(1);
        plot(gi(1),gi(2),'+');
    end
    
    function cb_cum_moment_release(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        morel;
    end
    
    function cb_time_selection(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        timeselect(4);
        ctimeplot;
    end
    
    function cb_mag_signature(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        dispma0;
    end
    
    function cb_save_cumnumcurve(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        eval(calSave);
    end
    
    function cb_info(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        zmaphelp(ttlStr,hlpStr1,hlpStr2);
    end
    
    function cb_close(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.newcat=a;
        f1=gcf;
        f2=gpf;
        close(f1);
        if f1~=f2
            figure(f2);
        end
    end
    
    function cb_print(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        myprint;
    end
    
    function cb_back(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.newcat = ZG.newcat;
        ZG.newt2 = ZG.newcat;
        stri = [' '];
        stri1 = [' '];
        ctimeplot;
    end
    
    function cb_keepas_newcat(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.newcat = ZG.newt2 ;
        replaceMainCatalog(ZG.newt2);
        csubcata;
    end
    
end
