function [bv, magco, std_backg, av, me,  rt] = bvalcalc(mycat)
    % bvalcalc calculates b-values and more from a catalog
    %  [bv, magco, std_backg, av, me, ~, rt] = bvalcalc(catalog)
    
    global les
    %global n
    
    report_this_filefun();
    
    maxmag = max(mycat.Magnitude);
    dm1 = 0.1;
    mima = min(mycat.Magnitude);
    if mima > 0 ; mima = 0 ; end
    
    % number of mag units
    nmagu = (maxmag*10)+1;
    
    [bval,xt2] = hist(mycat.Magnitude,(mima:dm1:maxmag));
    bvalsum = cumsum(bval);                        % N for M <=
    bvalsum3 = cumsum(bval(end:-1:1));    % N for M >= (counted backwards)
    magsteps_desc = (maxmag:-dm1:mima);
    
    %backg_be = log10(bvalsum);
    backg_ab = log10(bvalsum3);
    difb = [0 diff(bvalsum3) ];
    %
    i = find(difb == max(difb));
    i = max(i);
    %i = length(magsteps_desc)-10*min(mycat.Magnitude);
    i2 = round(i/3);
    i = i ;
    magco = max(magsteps_desc(i));

    M1b = [magsteps_desc(i) bvalsum3(i)];
    M2b =  [magsteps_desc(i2) bvalsum3(i2)];
    
    l = mycat.Magnitude >= M1b(1) & mycat.Magnitude <= M2b(1);
    so = log10(bval(10*M1b(1)+2)) - log10(bval(10*M2b(1)));
    me= so/( M2b(1)-0.2- M1b(1));
    %mer = dm1;
    
    
    ll = magsteps_desc >= M1b(1) & magsteps_desc <= M2b(1);
    x = magsteps_desc(ll);
    y = backg_ab(ll);
    [p,s] = polyfit2(x,y,1);                   % fit a line to background
    f = polyval(p,x);
    f = 10.^f;
    rt = mycat.DateSpan() / (10.^(polyval(p,7.0)));
    r = corrcoef(x,y);
    r = r(1,2);
    std_backg = std(y - polyval(p,x));      % standard deviation of fit
    
    %n = length(x);
    l = mycat.Magnitude >= M1b(1) & mycat.Magnitude <= M2b(1);
    les = (mean(mycat.Magnitude(l)) - M1b(1))/dm1;
    
    
    av=p(1,2);
    p=-p(1,1);
    bv=fix(100*p)/100;
    std_backg=fix(100*std_backg)/100;
    tt2=num2str(std_backg);
    tt1=num2str(p);
end
