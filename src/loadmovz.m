function loadmovz() 
    
    report_this_filefun();
    
    [file1,path1] = uigetfile(['*.mat'],'Moviefile');
    
    
    if length(path1) > 1
        load([path1 file1])
        showmovi
    else
        ZmapMessageCenter();
    end   % if exist
    
    
end
