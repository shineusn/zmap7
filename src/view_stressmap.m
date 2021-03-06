function view_stressmap(bvg) 
% view_stressmap
    % Author: S. Wiemer
    % updated: 19.05.2005, j.woessner@sed.ethz.ch
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun();
    
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
    
    valueMap=reshape(normlap2,length(yvect),length(xvect));
    s11 = valueMap;
    
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
    
    %old1 = valueMap;
    
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
    set(gca,'NextPlot','add')
    n = 0;
    l0 = []; l1 = []; l2 = []; l3 = []; l4 = []; l5 = [];
    
    ste = sor(l_notnormal,:);
    for i = 1:3:length(px)-1
        n = n+1;j = jet;
        col = floor(ste(n,SA*2-1)/60*62)+1;
        if col > 64 ; col = 64; end
        pl = plot(px(i:i+1),py(i:i+1),'k','Linewidth',1,'Markersize',1,'color',[ 0 0 0  ] );
        set(gca,'NextPlot','add')
        
        dx = px(i)-px(i+1);
        dy = py(i) - py(i+1);
        pl2 = plot(px(i),py(i),'ko','Markersize',0.1,'Linewidth',0.5,'color',[0 0 0] );
        l0 = pl2;
        pl3 = plot([px(i) px(i)+dx],[py(i) py(i)+dy],'k','Linewidth',1,'color',[0 0 0] );
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
        pl_n = plot(px_n(i:i+1),py_n(i:i+1),'k','Linewidth',1,'Markersize',1,'color',[ 0 0 0  ] );
        set(gca,'NextPlot','add')
        dx = px_n(i)- px_n(i+1);
        dy = py_n(i) - py_n(i+1);
        pl2_n = plot(px_n(i),py_n(i),'ko','Markersize',0.1,'Linewidth',0.5,'color',[0 0 0] );
        l0 = pl2;
        pl3_n = plot([px_n(i) px_n(i)+dx_n],[py_n(i) py_n(i)+dy_n],'k','Linewidth',1,'color',[0 0 0] );
        
        if ste(n,1) > 52  &&                 ste(n,5) < 35 ;                 set([pl_n pl3_n],'color','r'); set(pl2_n,'color','r'); l1 = pl_n;
        end
    end
    
    if isempty(l1); pl2 = plot(px,py,'kx','Linewidth',1,'color','r'); l1 = pl2; set(l1,'visible','off'); end
    if isempty(l2); pl2 = plot(px,py,'kx','Linewidth',1,'color','m'); l2 = pl2; set(l2,'visible','off'); end
    if isempty(l3); pl2 = plot(px,py,'kx','Linewidth',1,'color',[0.2 0.8 0.2] ); l3 = pl2; set(l3,'visible','off'); end
    if isempty(l4); pl2 = plot(px,py,'kx','Linewidth',1,'color','c' ); l4 = pl2; set(l4,'visible','off'); end
    if isempty(l5); pl2 = plot(px,py,'kx','Linewidth',1,'color','b' ); l5 = pl2; set(l5,'visible','off'); end
    if isempty(l0); l0 = plot(px,py,'kx','Linewidth',1,'color',[0 0 0 ] );  set(l0,'visible','off'); end
    
    try
        legend([l1 l2 l3 l4 l5 l0],'NF','NS','SS','TS','TF','U');
    catch
        disp('Legend could not be drawn')
    end
    
    % Figure settings
    set(gca,'NextPlot','add')
    axis('equal')
    zmap_update_displays();
    set(gca,'aspectratio',[0.827 1])
    axis([ s2 s1 s4 s3])
    title([name ';  '   num2str(t0b) ' to ' num2str(teb) ],'FontSize',ZmapGlobal.Data.fontsz.s,...
        'Color','k','FontWeight','normal');
    mygca = gca;
    xlabel('Longitude ','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.s)
    ylabel('Latitude ','FontWeight','normal','FontSize',ZmapGlobal.Data.fontsz.s)
    set(gca,'visible','on','FontSize',ZmapGlobal.Data.fontsz.s,'FontWeight','normal',...
        'FontWeight','normal','LineWidth',1,...
        'Box','on','TickDir','out','Ticklength',[0.01 0.01])
    
    
    
    watchoff;
    
    % View the variance map
    valueMap = r;ZG.shading_style = 'interp';
    view_varmap([],valueMap);
    
end
