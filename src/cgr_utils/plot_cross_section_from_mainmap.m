function [c2, gcDist_km, zans] = plot_cross_section_from_mainmap
    %PLOT_CROSS_SECTION_FROM_MAINMAP create a cross-section from the map.
    %  [CatalogInCrossSection, distanceAlongStrike, optionsUsed] = PLOT_CROSS_SECTION_FROM_MAINMAP
    %
    % you can choose section width, start & end labels, and color.
    %
    % plots cross-section (great-circle curve) on map, along with boundary for selected events.
    % brings up new figure containing cross-section, with selected events plotted with depth, 
    % and histograms of events along sgtrike and with depth
    
    ZG=ZmapGlobal.Data;
    catalog=ZG.primeCatalog;
    
    % dialog box to choose cross-section
    zdlg=ZmapDialog();
    zdlg.AddEdit('slicewidth_km','Width of slice [km]',20,'distance from slice for which to select events. 1/2 distance in either direction');
    zdlg.AddEdit('startlabel','start label','A','start label for map');
    zdlg.AddEdit('endlabel','end label','A''','start label for map');
    zdlg.AddCheckbox('choosecolor','choose cross-section color [red]', false,{},...
                    'When checked, a color selection dialog will allow you to choose a different cross-section color');
    zdlg.AddPopup('chooser','Choose Points',{'choose start and end with mouse'},1,'no choice');
    zans=zdlg.Create('Name', 'slicer');
    C = [1 0 0]; % color for cross-section
    if zans.choosecolor
        C=uisetcolor(C,['Color for ' zans.startlabel '-' zans.endlabel]);
    end
    
    [lon, lat, xs_endpts] = get_endpoints(gca,C);
    
    % get waypoints along the great-circle curve
    [curvelats,curvelons]=gcwaypts(lat(1),lon(1),lat(2),lon(2),100);
    
    % plot great-circle path
    xs_line=plot(curvelons,curvelats,'--','LineWidth',1.5,'Color',C);
    
    % plot width polygon
    [plat,plon] = xsection_poly([lat(1),lon(1)], [lat(2) lon(2)], zans.slicewidth_km/2);
    xspoly=plot(plon,plat,'-.','Color',C);
    
    %label it: put labels offset and outside the great-circle line.
    hOffset=@(x,polarity) x+(1/75).*diff(xlim) * sign(lon(2)-lon(1)) * polarity;
    vOffset=@(x,polarity) x+(1/75).*diff(ylim) * sign(lat(2)-lat(1)) * polarity;
    slabel = text(hOffset(lon(1),-1),vOffset(lat(1),-1),zans.startlabel,'Color',C.*0.8, 'FontWeight','bold');
    elabel = text(hOffset(lon(2),1),vOffset(lat(2),1),zans.endlabel,'Color',C.*0.8, 'FontWeight','bold');

    % mask so that we can plot original quakes in original positions
    mask=polygon_filter(plon,plat,catalog.Longitude,catalog.Latitude,'inside');
    
    c2=ZmapXsectionCatalog(catalog, [lat(1),lon(1)],[lat(2),lon(2)], zans.slicewidth_km);
    
    %[c2,mindist,mask,gcDist_km]=project_on_gcpath([lat(1),lon(1)],[lat(2),lon(2)],catalog,zans.slicewidth_km/2,0.1);
    
    % PLOT X-SECTION IN NEW FIGURE
    f=create_cross_section_figure(zans, catalog, c2, mask);
    f.DeleteFcn = @(~,~)delete([xs_endpts,xs_line,slabel,elabel, xspoly]); % autodelete xsection when figure is closed
    ZG.newcat=c2;
end

function [lon, lat,h] = get_endpoints(ax,C)
    % returns lat, lon where each is [start,end] along with handle used to pick endpoints
    
    disp('click on start and end points for cross section');
    
    % pick first point
    [lon, lat] = ginput(1);
    set(gca,'NextPlot','add'); 
    h=plot(ax,lon,lat,'x','LineWidth',2,'MarkerSize',5,'Color',C);
    
    % pick second point
    [lon(2), lat(2)] = ginput(1);
    h.XData=lon; 
    h.YData=lat;
end

function f=create_cross_section_figure(zans,catalog, c2, mask)
        f=figure('Name',['cross-section ' zans.startlabel '-' zans.endlabel],...
            'Position',[40 60 1000 700]);
    disp('in create figure...');
    % plot events
    ax=subplot(3,3,9);
    plot3_events(ax, c2, catalog, mask);
    plot_events_along_strike(subplot(3,3,[1 5]),c2,zans)
    
    plot_events_along_strike_hist(subplot(3,3,[7 8]),zans, c2.dist_along_strike_km);
    plot_depth_profile(subplot(3,3,[3 6]), c2.Depth);
    create_my_menu(c2)
end

function plot_events_along_strike(ax,c2,zans)
    scatter(ax, c2.dist_along_strike_km, c2.Depth,mag2dotsize(c2.Magnitude),years(c2.Date-min(c2.Date)));
    ax.YDir='reverse';
    ax.XLim=[0 c2.curvelength_km];
    ax.XTickLabel{1}=zans.startlabel;
    if ax.XTick(end) ~= c2.curvelength_km
        ax.XTick(end+1)=c2.curvelength_km;
        ax.XTickLabel{end+1}=zans.endlabel;
    else
        ax.XTickLabel{end}=zans.endlabel;
    end
        
        
    grid(ax,'on');
    xlabel('Distance along strike [km]');
    ylabel('Depth');
    title(sprintf('Profile: %s to %s',zans.startlabel,zans.endlabel));
end

function plot3_events(ax,c2, catalog, mask, featurelist)
    % create a 3-d plot of this cross section, with overlaid map
    
    % plot relevant events (at depth)
    scatter3(ax,c2.Longitude,c2.Latitude,c2.Depth,mag2dotsize(c2.Magnitude),c2.dist_along_strike_km,'+')
    
    set(gca,'NextPlot','add')
    % plot all events as gray on surface
    plot(ax,catalog.Longitude,catalog.Latitude,'.','Color',[.75 .75 .75],'MarkerSize',1);
    scatter3(catalog.Longitude(mask),catalog.Latitude(mask),c2.Depth,3,c2.displacement_km)
    ax.ZDir='reverse'; % Depths are + down
    
    
    % add features
    if ~exist('featurelist','var')
        featurelist={'coastline','borders','faults','lakes'};
    end
    ZG=ZmapGlobal.Data;
    for n=1:numel(featurelist)
        copyobj(ZG.features(featurelist{n}),ax);
    end
    set(gca,'NextPlot','replace')
end

function h=plot_events_along_strike_hist(ax, zans, gcDist)
    h=histogram(ax,gcDist);
    h.Parent.XTickLabel{1}=zans.startlabel;
    h.Parent.XTickLabel{end}=zans.endlabel;
    ylabel('# events');
    xlabel('Distance along strike (km)');
end

function plot_depth_profile(ax,depths)
    subplot(3,3,[3 6])
    histogram(depths,'Orientation','horizontal');
    set(gca, 'YDir','reverse')
    xlabel('# events');
    ylabel('Distance Depth Profile (km)');
end



function create_my_menu(c2)
        add_menu_divider();
        options = uimenu('Label','Select');
        %uimenu(options,'Label','Select EQ inside Polygon ',MenuSelectedField(),@cb_select_eq_inside_poly);
        %uimenu(options,'Label','Refresh ',MenuSelectedField(),@cb_refresh2);
        
        options = uimenu('Label','Ztools');
        
        
        uimenu(options,'Label', 'differential b ',...
            MenuSelectedField(),@cb_diff_b);
        
        uimenu(options,'Label','Fractal Dimension',...
            MenuSelectedField(),@cb_fractaldim);
        
        uimenu(options,'Label','Mean Depth',...
            MenuSelectedField(),{@cb_meandepth,c2});
        
        uimenu(options,'Label','z-value grid',...
            MenuSelectedField(),@cb_zvaluegrid);
        
        uimenu(options,'Label','b and Mc grid ',...
            MenuSelectedField(),@cb_b_mc_grid);
        
        uimenu(options,'Label','Prob. forecast test',...
            MenuSelectedField(),@cb_probforecast_test);
        
        uimenu(options,'Label','beCubed',...
            MenuSelectedField(),@cb_becubed);
        
        uimenu(options,'Label','b diff (bootstrap)',...
            MenuSelectedField(),@cb_b_diff_boot);
        
        uimenu(options,'Label','Stress Variance',...
            MenuSelectedField(),@cb_stressvariance);
        
        
        uimenu(options,'Label','Time Plot ',...
            MenuSelectedField(),{@cb_timeplot, c2});
        
        uimenu(options,'Label',' X + topo ',...
            MenuSelectedField(),@cb_xplustopo);
        
        uimenu(options,'Label','Vert. Exaggeration',...
            MenuSelectedField(),@cb_vertexaggeration);
        
        uimenu(options,'Label','Rate change grid',...
            MenuSelectedField(),@cb_ratechangegrid);
        
        uimenu(options,'Label','Omori parameter grid',...
            MenuSelectedField(),@cb_omoriparamgrid); % formerly pcross
        
    end
    
    %% callback functions
    
    function cb_select_eq_inside_poly(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        h1 = gca;
        stri = 'Polygon';
        selectp;
    end
    
    
    function cb_diff_b(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        h1=gca;
        bcrossVt2();
    end
    
    function cb_fractaldim(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        Dcross();
    end
    
    function cb_meandepth(mysrc,myevt,mycat)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        meandepx(mycat, mycat.dist_along_strike_km);
    end
    
    function cb_zvaluegrid(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        magrcros();
    end
    
    function cb_b_mc_grid(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        sel = 'in';
        bcross(sel);
    end
    
    function cb_probforecast_test(mysrc,myevt)
        ZG=ZmapGlobal.Data;
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        rContainer.fXSWidth = ZG.xsec_defaults.WidthKm;
        rContainer.Lon1 = lon1;
        rContainer.Lat1 = lat1;
        rContainer.Lon2 = lon2;
        rContainer.Lat2 = lat2;
        pt_start(newa, xsec_fig(), 0, rContainer, name);
    end
    
    function cb_becubed(mysrc,myevt)

        ZG=ZmapGlobal.Data;
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        rContainer.fXSWidth = ZG.xsec_defaults.WidthKm;
        rContainer.Lon1 = lon1;
        rContainer.Lat1 = lat1;
        rContainer.Lon2 = lon2;
        rContainer.Lat2 = lat2;
        bc_start(newa, xsec_fig(), 0, rContainer);
    end
    
    function cb_b_diff_boot(mysrc,myevt)

        ZG=ZmapGlobal.Data;
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        rContainer.fXSWidth = ZG.xsec_defaults.WidthKm;
        rContainer.Lon1 = lon1;
        rContainer.Lat1 = lat1;
        rContainer.Lon2 = lon2;
        rContainer.Lat2 = lat2;
        st_start(newa, xsec_fig(), 0, rContainer);
    end
    
    function cb_stressvariance(mysrc,myevt)
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        cross_stress();
    end
    
    function cb_timeplot(mysrc,myevt, c2)
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        timcplo(c2);
    end
    
    function cb_xplustopo(mysrc,myevt)
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        xsectopo;
    end
    
    function cb_vertexaggeration(mysrc,myevt)
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        vert_exaggeration;
    end
    
    function cb_ratechangegrid(mysrc,myevt)
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        rc_cross_a2();
    end
    
    function cb_omoriparamgrid(mysrc,myevt)
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        calc_Omoricross();
    end
    
    function cb_refresh(mysrc,myevt)

        ZG=ZmapGlobal.Data;
        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        [xsecx xsecy,  inde] =mysect(tmp1,tmp2,ZG.primeCatalog.Depth,ZG.xsec_defaults.WidthKm,0,lat1,lon1,lat2,lon2);
    end
    
    function cb_refresh2(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        delete(uic2);
        delete(findobj(mapl,'Type','axes'));
        nlammap2;
    end
