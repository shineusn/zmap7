function loadgrid() 
    
    report_this_filefun();
    
    cupa = pwd;
    try
        delete(pd);
    catch ME
        error_handler(ME, @do_nothing);
    end
    
    [file1,path1] = uigetfile(['*.mat'],'Gridfile');
    
    if length(path1) > 1
        
        load([path1 file1])
        
        figure(map);
        d =  [min(gx) min(gy) ; min(gx) max(gy) ; max(gx) max(gy) ; max(gx) min(gy); min(gx) min(gy)];
        
        storedcat=a;
        zmap_update_displays();
        pl = plot(newgri(:,1),newgri(:,2),'+k');
        set(pl,'MarkerSize',8,'LineWidth',1)
        
        %pd = plot(d(:,1),d(:,2),'r-')
        zmapmenu
    else
        return
    end
    
end
