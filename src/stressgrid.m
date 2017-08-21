function bvg = stressgrid() % autogenerated function wrapper
    % stressgrid create a grid (interactively), calculate stress tensor using Michaels or Gephards code
    %
    % Incoming data:
    % Columns 10-12 of newa must be
    % 10: dip direction (East of North
    % 11: dip
    % 12: rake (Kanamori convention)
    %
    % Output:
    % Matrix: bvg
    % original: Stefan Wiemer 1/95
    %
    % last update: J. Woessner, 15.02.2005
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    report_this_filefun(mfilename('fullpath'));
    fs=filesep;
    
    % get the grid parameter
    % initial values
    %
    
    if size(a(1,:)) < 12
        errordlg('You need 12 columns of input data (i.e., fault plane solutions) to calculate a stress tensor!');
        return
    end
    
    dx = 0.1;
    dy = 0.1 ;
    ni = 50;
    Nmin = 0;
    stan2 = nan;
    stan = nan;
    prf = nan;
    av = nan;
    
    % make the interface
    %
    figure_w_normalized_uicontrolunits(...
        'Name','Grid Input Parameter',...
        'NumberTitle','off', ...
        'NextPlot','new', ...
        'units','points',...
        'Visible','on', ...
        'Position',[ 100 100 650 250]);
    axis off
    labelList2=[' Michaels Method | sorry, no other options'];
    labelPos = [0.2 0.8  0.6  0.08];
    hndl2=uicontrol(...
        'Style','popup',...
        'Position',labelPos,...
        'Units','normalized',...
        'String',labelList2,...
        'callback',@callbackfun_001);
    
    set(hndl2,'value',1);
    
    
    % creates a dialog box to input grid parameters
    %
    
    
    freq_field=uicontrol('Style','edit',...
        'Position',[.30 .60 .12 .08],...
        'Units','normalized','String',num2str(ni),...
        'callback',@callbackfun_002);
    
    
    freq_field0=uicontrol('Style','edit',...
        'Position',[.30 .50 .12 .08],...
        'Units','normalized','String',num2str(ra),...
        'callback',@callbackfun_003);
    
    freq_field2=uicontrol('Style','edit',...
        'Position',[.30 .40 .12 .08],...
        'Units','normalized','String',num2str(dx),...
        'callback',@callbackfun_004);
    
    freq_field3=uicontrol('Style','edit',...
        'Position',[.30 .30 .12 .080],...
        'Units','normalized','String',num2str(dy),...
        'callback',@callbackfun_005);
    
    tgl1 = uicontrol('Style','radiobutton',...
        'string','Number of Events:',...
        'Position',[.05 .60 .2 .0800], 'callback',@callbackfun_006,...
        'Units','normalized');
    
    set(tgl1,'value',1);
    
    tgl2 =  uicontrol('Style','radiobutton',...
        'string','OR: Constant Radius',...
        'Position',[.05 .50 .2 .080], 'callback',@callbackfun_007,...
        'Units','normalized');
    
    create_grid =  uicontrol('Style','radiobutton',...
        'string','Calculate a new grid', 'callback',@callbackfun_008,'Position',[.55 .55 .2 .080],...
        'Units','normalized');
    
    set(create_grid,'value',1);
    
    prev_grid =  uicontrol('Style','radiobutton',...
        'string','Reuse the previous grid', 'callback',@callbackfun_009,'Position',[.55 .45 .2 .080],...
        'Units','normalized');
    
    
    load_grid =  uicontrol('Style','radiobutton',...
        'string','Load a previously saved grid', 'callback',@callbackfun_010,'Position',[.55 .35 .2 .080],...
        'Units','normalized');
    
    save_grid =  uicontrol('Style','checkbox',...
        'string','Save selected grid to file',...
        'Position',[.55 .22 .2 .080],...
        'Units','normalized');
    
    freq_field4 = uicontrol('Style','edit',...
        'Position',[.30 .20 .12 .080],...
        'Units','normalized','String',num2str(Nmin),...
        'callback',@callbackfun_011);
    
    
    close_button=uicontrol('Style','Pushbutton',...
        'Position',[.60 .05 .15 .12 ],...
        'Units','normalized','callback',@callbackfun_012,'String','Cancel');
    
    go_button1=uicontrol('Style','Pushbutton',...
        'Position',[.20 .05 .15 .12 ],...
        'Units','normalized',...
        'callback',@callbackfun_013,...
        'String','Go');
    
    txt3 = text(...
        'Position',[0.30 0.75 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.l ,...
        'FontWeight','bold',...
        'String',' Grid Parameter');
    txt5 = text(...
        'Position',[-0.1 0.4 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String','Spacing in x (dx) in deg:');
    
    txt6 = text(...
        'Position',[-0.1 0.3 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String','Spacing in y (dy) in deg:');
    
    txt7 = text(...
        'Position',[-0.1 0.18 0 ],...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'FontWeight','bold',...
        'String','Min. no. of evts. (const R):');
    
    
    
    
    set(gcf,'visible','on');
    watchoff
    
    function my_calculate()
        % get the grid-size interactively and
        % calculate the b-value in the grid by sorting
        % thge seimicity and selectiong the ni neighbors
        % to each grid point
        
        % get new grid if needed
        if load_grid == 1
            [file1,path1] = uigetfile(['*.mat'],'previously saved grid');
            if length(path1) > 1
                think
                load([path1 file1])
                plot(newgri(:,1),newgri(:,2),'k+')
            end
        elseif load_grid ==0  &&  prev_grid == 0
            selgp
            if length(gx) < 4  ||  length(gy) < 4
                errordlg('Selection too small! (Dx and Dy are in degreees! ');
                return
            end
        end
        
        if save_grid == 1
            grid_save =...
                [ 'zmap_message_center.set_info(''Saving Grid'',''  '');think;',...
                '[file1,path1] = uiputfile(fullfile(ZmapGlobal.Data.data_dir,''*.mat''), ''Grid File Name?'') ;',...
                ' gs = [''save '' path1 file1 '' newgri dx dy gx gy xvect yvect tmpgri ll''];',...
                ' if length(file1) > 1, eval(gs),end , done']; eval(grid_save)
        end
        
        
        itotal = length(newgri(:,1));
        
        zmap_message_center.set_info(' ','Running... ');think
        %  make grid, calculate start- endtime etc.  ...
        %
        t0b = min(ZG.a.Date)  ;
        n = ZG.a.Count;
        teb = max(ZG.a.Date) ;
        tdiff = round((teb-t0b)/ZG.bin_days);
        loc = zeros(3, length(gx)*length(gy));
        
        % loop over  all points
        %
        i2 = 0.;
        i1 = 0.;
        bvg = [];
        allcount = 0.;
        wai = waitbar(0,' Please Wait ...  ');
        set(wai,'NumberTitle','off','Name','stress map grid - percent done');;
        drawnow
        %
        % create bvg
        bvg = nan(length(newgri),9);
        
        
        hodis = fullfile(ZG.hodi, 'external');
        cd(hodis);
        
        % loop over all points
        for i= 1:length(newgri(:,1))
            x = newgri(i,1);y = newgri(i,2);
            allcount = allcount + 1.;
            i2 = i2+1;
            
            % calculate distance from center point and sort wrt distance
            l=ZG.a.epicentralDistanceTo(x,y);
            [s,is] = sort(l);
            b = a(is(:,1),:) ;       % re-orders matrix to agree row-wise
            
            if tgl1 == 0   % take point within r
                l3 = l <= ra;
                b = ZG.a.subset(l3);      % new data per grid point (b) is sorted in distance
                rd = ra;
            else
                % take first ni points
                b = b(1:ni,:);      % new data per grid point (b) is sorted in distance
                l2 = sort(l); rd = l2(ni);
                
            end
            
            
            %estimate the completeness and b-value
            ZG.newt2 = b;
            if length(b) >= Nmin  % enough events?
                % Take the focal mechanism from actual catalog
                % tmpi-input: [dip direction (East of North), dip , rake (Kanamori)]
                tmpi = [ZG.newt2(:,10:12)];
                
                % Create file for inversion
                fid = fopen('data2','w');
                str = ['Inversion data'];str = str';
                fprintf(fid,'%s  \n',str');
                fprintf(fid,'%7.3f  %7.3f  %7.3f\n',tmpi');
                fclose(fid);
                
                % slick calculates the best solution for the stress tensor according to
                % Michael(1987): creates data2.oput
                switch computer
                    case 'GLNX86'
                        unix(['".' fs 'slick_linux" data2 ']);
                    case 'MAC'
                        unix(['".' fs 'slick_macppc" data2 ']);
                    case 'MACI'
                        unix(['".' fs 'slick_maci" data2 ']);
                    case 'MACI64'
                        unix(['".' fs 'slick_maci64" data2 ']);
                    otherwise
                        dos(['".' fs 'slick.exe" data2 ']);
                end
                %unix([ZG.hodi fs 'external/slick data2 ']);
                % Get data from data2.oput
                sFilename = ['data2.oput'];
                [fBeta, fStdBeta, fTauFit, fAvgTau, fStdTau] = import_slickoput(sFilename);
                
                % Delete existing data2.slboot
                
                sData2 = fullfile(ZG.hodi, 'external', 'data2.slboot');
                
                delete(sData2);
                
                % Stress tensor inversion
                switch computer
                    case 'GLNX86'
                        unix(['"' ZG.hodi fs 'external/slfast_linux" data2 ']);
                    case 'MAC'
                        unix(['"' ZG.hodi fs 'external/slfast_macpcc" data2 ']);
                    case 'MACI'
                        unix(['"' ZG.hodi fs 'external/slfast_maci" data2 ']);
                    case 'MACI64'
                        unix(['"' ZG.hodi fs 'external/slfast_maci64" data2 ']);
                    otherwise
                        dos(['"' ZG.hodi fs 'external' fs 'slfast.exe" data2 ']);
                end
                %unix([ZG.hodi fs 'external/slfast data2 ']);
                sGetFile = fullfile(ZG.hodi, 'external', 'data2.slboot');
                load(sGetFile); % Creates variable data2 in workspace
                % Description of data2
                % Line 1: Variance S11 S12 S13 S22 S23 S33 => Variance and components of
                % stress tensor (S = sigma)
                % Line 2: Phi S1t S1p S2t S2p S3t S3p
                % Phi is relative size S3/S1, t=trend, p=plunge (other description)
                d0 = data2;
                
                bv2 = nan;
                % Result matrix
                % S1Trend S1Plunge S2Trend S2Plunge S3Trend S3Plunge Variance Radius b-value
                bvg(allcount,:) = [d0(2,2:7) d0(1,1) rd bv2];
            end % if Nmin
            waitbar(allcount/itotal)
        end  % for newgr
        close(wai)
        watchoff
        view_stressmap(bvg)
    end
    
    
    
    function callbackfun_001(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.inb2=hndl2.Value;
    end
    
    function callbackfun_002(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        update_editfield_value(mysrc);
        ni=mysrc.Value;
        tgl2.Value=0;
        tgl1.Value=1;
    end
    
    function callbackfun_003(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        update_editfield_value(mysrc);
        ra=mysrc.Value;
        tgl2.Value=1;
        tgl1.Value=0;
    end
    
    function callbackfun_004(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        update_editfield_value(mysrc);
        dx=mysrc.Value;
    end
    
    function callbackfun_005(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        update_editfield_value(mysrc);
        dy=mysrc.Value;
    end
    
    function callbackfun_006(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        tgl2.Value=0;
    end
    
    function callbackfun_007(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        tgl1.Value=0;
    end
    
    function callbackfun_008(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        load_grid.Value=0;
        prev_grid.Value=0;
    end
    
    function callbackfun_009(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        load_grid.Value=0;
        create_grid.Value=0;
    end
    
    function callbackfun_010(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        prev_grid.Value=0;
        create_grid.Value=0;
    end
    
    function callbackfun_011(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        update_editfield_value(mysrc);
        Nmin=mysrc.Value;
    end
    
    function callbackfun_012(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        close;
        done;
    end
    
    function callbackfun_013(mysrc,myevt)
        % automatically created callback function from text
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.inb1=hndl2.Value;
        tgl1=tgl1.Value;
        tgl2=tgl2.Value;
        prev_grid=prev_grid.Value;
        create_grid=create_grid.Value;
        load_grid=load_grid.Value;
        save_grid=save_grid.Value;
        close;
        my_calculate();
    end
    
end


function view_stressmap(bvg) % autogenerated function wrapper
    % view_stressmap
    % pulled into function due to its tight bonding from an m file
    % Author: S. Wiemer
    % last update: 19.05.2005, j.woessner@sed.ethz.ch
    % turned into function by Celso G Reyes 2017
    ZG=ZmapGlobal.Data;
    SA = 1;
    SA2 = 3;
    % Matrix bvg contains:
    % bvg : [S1Trend S1Plunge S2Trend S2Plunge S3Trend S3Plunge Variance Radius b-value]
    % ste : [S1Plunge S1Trend+180 S2Plunge S2Trend+180 S3Plunge S3Trend+180 Variance];
    ste = [bvg(:,2) bvg(:,1)+180  bvg(:,4) bvg(:,3)+180 bvg(:,6) bvg(:,5)+180 bvg(:,7) ];
    sor = ste;
    ste2 = s;
    % sor : [S1Plunge S1Trend+270 S2Plunge S2Trend+180 S3Plunge S3Trend+180 Variance];
    sor(:,SA*2) = sor(:,SA*2)+90;
    
    % Create matrices
    normlap2=NaN(length(tmpgri(:,1)),1);
    
    re3=reshape(normlap2,length(yvect),length(xvect));
    s11 = re3;
    
    normlap2(ll)= bvg(:,8);
    rama=reshape(normlap2,length(yvect),length(xvect));
    
    normlap2(ll)= bvg(:,7);
    r=reshape(normlap2,length(yvect),length(xvect));
    
    normlap2(ll)= bvg(:,1);
    s11=reshape(normlap2,length(yvect),length(xvect));
    
    normlap2(ll)= bvg(:,4);
    s31=reshape(normlap2,length(yvect),length(xvect));
    
    normlap2(ll)= bvg(:,2);
    s12=reshape(normlap2,length(yvect),length(xvect));
    
    %old1 = re3;
    
    % Create figure
    figure_w_normalized_uicontrolunits('visible','off')
    l_normal =  ste(:,1) > 52 &   ste(:,5) < 35 ;
    l_notnormal = l_normal < 1;
    
    plq = quiver(newgri(l_notnormal,1),newgri(l_notnormal,2),-cos(sor(l_notnormal,SA*2)*pi/180),sin(sor(l_notnormal,SA*2)*pi/180),0.6,'.');
    set(plq,'LineWidth',0.5,'Color','k')
    px = get(plq,'Xdata');
    py = get(plq,'Ydata');
    
    close
    
    
    figure_w_normalized_uicontrolunits('visible','off')
    
    plq_n = quiver(newgri(l_normal,1),newgri(l_normal,2),-cos(sor(l_normal,SA2*2)*pi/180),sin(sor(l_normal,SA2*2)*pi/180),0.6,'.');
    set(plq_n,'LineWidth',0.5,'Color','r')
    
    drawnow
    px_n = get(plq_n,'Xdata');
    py_n = get(plq_n,'Ydata');
    close
    
    figure_w_normalized_uicontrolunits('Name','Faulting style map','pos',[100 100 860 600])
    watchon;
    %whitebg(gcf);
    set(gcf,'color','w');
    axes('pos',[0.12 0.12 0.8 0.8]);
    hold on
    n = 0;
    l0 = []; l1 = []; l2 = []; l3 = []; l4 = []; l5 = [];
    
    ste = sor(l_notnormal,:);
    for i = 1:3:length(px)-1
        n = n+1;j = jet;
        col = floor(ste(n,SA*2-1)/60*62)+1;
        if col > 64 ; col = 64; end
        pl = plot(px(i:i+1),py(i:i+1),'k','Linewidth',1.,'Markersize',1,'color',[ 0 0 0  ] );
        hold on
        
        dx = px(i)-px(i+1);
        dy = py(i) - py(i+1);
        pl2 = plot(px(i),py(i),'ko','Markersize',0.1,'Linewidth',0.5,'color',[0 0 0] );
        l0 = pl2;
        pl3 = plot([px(i) px(i)+dx],[py(i) py(i)+dy],'k','Linewidth',1.,'color',[0 0 0] );
        % Select faulting style according to Zoback(1992)
        if ste(n,1) < 40  && ste(n,3) > 45  && ste(n,5) < 20 ; set([pl pl3],'color',[0.2 0.8 0.2]); set(pl2,'color',[0.2 0.8 0.2]); l3 = pl; end
        if ste(n,1) < 20  && ste(n,3) > 45  && ste(n,5) < 40 ;  set([pl pl3],'color',[0.2 0.8 0.2]); set(pl2,'color',[0.2 0.8 0.2]);l3 = pl; end
        if ste(n,1) > 40  &&                 ste(n,1) < 52  && ste(n,5) < 20 ;  set([pl pl3],'color','m'); set(pl2,'color','m'); l2 = pl; end
        if ste(n,1) < 20  &&                 ste(n,5) > 40  &&  ste(n,5) <  52 ; set([pl pl3],'color','c'); set(pl2,'color','c');l4 = pl; end
        if ste(n,1) < 37  && ste(n,5) > 47  ; set([pl pl3],'color','b'); set(pl2,'color','b');l5 = pl;  end
        
    end
    %drawnow
    ste = sor(l_normal,:);
    n = 0;
    
    for i = 1:3:length(px_n)-1
        n = n+1;j = jet;
        col = floor(ste(n,SA*2-1)/60*62)+1;
        if col > 64 ; col = 64; end
        dx_n = px_n(i)-px_n(i+1);
        dy_n= py_n(i) - py_n(i+1);
        pl_n = plot(px_n(i:i+1),py_n(i:i+1),'k','Linewidth',1.,'Markersize',1,'color',[ 0 0 0  ] );
        hold on
        dx = px_n(i)- px_n(i+1);
        dy = py_n(i) - py_n(i+1);
        pl2_n = plot(px_n(i),py_n(i),'ko','Markersize',0.1,'Linewidth',0.5,'color',[0 0 0] );
        l0 = pl2;
        pl3_n = plot([px_n(i) px_n(i)+dx_n],[py_n(i) py_n(i)+dy_n],'k','Linewidth',1.,'color',[0 0 0] );
        
        if ste(n,1) > 52  &&                 ste(n,5) < 35 ;                 set([pl_n pl3_n],'color','r'); set(pl2_n,'color','r'); l1 = pl_n;
        end
    end
    
    if isempty(l1); pl2 = plot(px,py,'kx','Linewidth',1.,'color','r'); l1 = pl2; set(l1,'visible','off'); end
    if isempty(l2); pl2 = plot(px,py,'kx','Linewidth',1.,'color','m'); l2 = pl2; set(l2,'visible','off'); end
    if isempty(l3); pl2 = plot(px,py,'kx','Linewidth',1.,'color',[0.2 0.8 0.2] ); l3 = pl2; set(l3,'visible','off'); end
    if isempty(l4); pl2 = plot(px,py,'kx','Linewidth',1.,'color','c' ); l4 = pl2; set(l4,'visible','off'); end
    if isempty(l5); pl2 = plot(px,py,'kx','Linewidth',1.,'color','b' ); l5 = pl2; set(l5,'visible','off'); end
    if isempty(l0); l0 = plot(px,py,'kx','Linewidth',1.,'color',[0 0 0 ] );  set(l0,'visible','off'); end
    
    try
        legend([l1 l2 l3 l4 l5 l0],'NF','NS','SS','TS','TF','U');
    catch
        disp('Legend could not be drawn')
    end
    
    % Figure settings
    hold on
    axis('equal')
    update(mainmap())
    set(gca,'aspectratio',[0.827 1])
    axis([ s2 s1 s4 s3])
    title([name ';  '   num2str(t0b) ' to ' num2str(teb) ],'FontSize',ZmapGlobal.Data.fontsz.s,...
        'Color','k','FontWeight','normal');
    mygca = gca;
    xlabel('Longitude ','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.s)
    ylabel('Latitude ','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.s)
    set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.s,'FontWeight','normal',...
        'FontWeight','normal','LineWidth',1.,...
        'Box','on','TickDir','out','Ticklength',[0.01 0.01])
    
    watchoff;
    
    % View the variance map
    re3 = r;sha = 'in';
    view_varmap([],re3);
    
end