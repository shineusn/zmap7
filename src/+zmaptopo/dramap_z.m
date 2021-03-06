function dramap_z(colback, valuemap)
    % drap a colormap of variance, S1 orientation onto topography
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun();
    
    j = colormap;
    % check if mapping toolbox and topo map exists

    if ~has_mapping_toolbox()
        return
    end
    
    if ~exist('tmap', 'var'); tmap = 0; end
    [xx, yy] = size(tmap);
    if xx*yy < 30
        errordlg('Please create a topomap first, using the options from the seismicty map window');
        return
    end
    
    def = {'1','1','5',num2str(min(valueMap(:)),4),num2str(max(valueMap(:)),4) };
    
    tit ='Topo map input parameters';
    prompt={ 'Longitude label spacing in degrees ',...
        'Latitude label spacing in degrees ',...
        'Topo data-aspect (steepness) ',...
        ' Minimum datavalue (cmin)',...
        ' maximum datavalue cmap',...
        
        };
    ni2 = inputdlg(prompt,tit,1,def);
    
    l = ni2{1}; dlo= str2double(l);
    l = ni2{2}; dla= str2double(l);
    l = ni2{3}; dda= str2double(l);
    l = ni2{4}; mic= str2double(l);
    l = ni2{5}; mac= str2double(l);
    
    % use this for setting water levels to one color
    %l = isnan(tmap);
    %tmap(l) = 1;
    
    ButtonName=questdlg('Set water to zero?', ...
        ' Question', ...
        'Yes','No','no');
    
    
    switch ButtonName
        case 'Yes'
            tmap(tmap< 0.1) = 0;
    end
    
    
    
    valueMap(valueMap < mic) = mic;
    valueMap(valueMap > mac) = mac;
    
    [lat,lon] = meshgrat(tmap,tmapleg);
    [X , Y]  = meshgrid(gx,gy);
    
    ren = interp2(X,Y,valueMap,lon,lat);
    
    mi = min(ren(:));
    l =  isnan(ren);
    ren(l) = mi-20;
    
    %start figure
    figure_w_normalized_uicontrolunits('pos',[50 100 800 600])
    
    set(gca,'NextPlot','add'); 
    axis off
    axesm('MapProjection','eqaconic','MapParallels',[],...
        'MapLatLimit',[s4 s3],'MapLonLimit',[s2 s1])
    
    meshm(ren,tmapleg,size(tmap),tmap);
    
    daspectm('m',dda);
    tightmap
    view([0 90])
    camlight; lighting phong
    set(gca,'projection','perspective');
    
    j = [ [ 0.9 0.9 0.9 ] ; j];
    caxis([ mic*0.99 mac*1.01 ]);
    
    colormap(j); brighten(0.1);
    axis off;
    
    if ~exist('colback', 'var'); colback = 1; end
    
    if colback == 2  % black background
        fg='w';
        bg='k';
    else % white background
        fg='k';
        bg='w';
    end
    set(gcf,'color',bg)
    setm(gca,'ffacecolor',bg)
    setm(gca,'fedgecolor',fg,'flinewidth',3);
    
    % change the labels if needed
    setm(gca,'mlabellocation',dlo)
    setm(gca,'meridianlabel','on')
    setm(gca,'plabellocation',dla)
    setm(gca,'parallellabel','on')
    setm(gca,'Fontcolor',fg,'Fontweight','bold','FontSize',12,'Labelunits','dm')
    
    h5 = colorbar;
    set(h5,'position',[0.8 0.35 0.01 0.3],'TickDir','out','Ycolor',fg,'Xcolor',fg,...
        'Fontweight','bold','FontSize',12);
    set(gcf,'Inverthardcopy','off');
end
