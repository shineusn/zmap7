function maxzlta() 
    % maxzlta calculates the maximum z value for the LTA function. 
    % The parameter step (window) can be defined by the user.
    %
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun();
    
    winlen_days = ZG.compare_window_dur_v3 / ZG.bin_dur;
    
    [len, ncu] = size(cumuall);       % redefine ncu
    len = len -2;
    lta = 1:1:ncu-2;
    var1 = zeros(1,ncu);
    var2 = zeros(1,ncu);
    lta = zeros(1,ncu);
    maxlta = zeros(1,ncu);
    maxlta = maxlta -5;
    cu = [cumuall(1:ti-1,:) ; cumuall(ti+winlen_days+1:len,:)];
    mean1 = mean(cu(:,:));
    wai = waitbar(0,'Please wait...')
    set(wai,'Color',[0.8 0.8 0.8],'NumberTitle','off','Name','Percent done');
    for i = 1:ncu
        var1(i) = cov(cu(:,i));
    end     % for i
    
    for it = 1:step: len - winlen_days
        
        waitbar(it/len)
        
        mean2 = mean(cumuall(it:it+winlen_days,:));
        for i = 1:ncu
            var2(i) = cov(cumuall(it:it+winlen_days,i));
        end     % for i
        lta = (mean1 - mean2)./(sqrt(var1/it+var2/(len-it)));
        maxlta2 = [maxlta ;  lta ];
        maxlta = max(maxlta2);
        
    end    % for it
    
    
    valueMap = reshape(maxlta,length(gy),length(gx));
    
    close(wai)
    
    stri = [  'Maximum z  Map of   '  file1];
    stri2 = ['winlen_days = ' char(days(winlen)) ];
    in = 'lta';
    view_max(valueMap,gx,gy,stri,'');
    
    
end
