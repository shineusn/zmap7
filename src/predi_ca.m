function predi_ca() % autogenerated function wrapper
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun(mfilename('fullpath'));
    
    pt = 4;
    
    newt0 = ZG.newt2;
    
    
    lt =  ZG.newt2.Date >= t0b &  ZG.newt2.Date <teb-pt ;
    %lt =  ZG.newt2.Date >= 1981 &  ZG.newt2.Date < 1992 ;
    
    obs = ZG.newt2.subset(lt);
    
    lt =  ZG.newt2.Date >= teb-pt &  ZG.newt2.Date <= teb ;
    
    %lt =  ZG.newt2.Date >= 1995 &  ZG.newt2.Date <= 1999.9 ;
    pre = ZG.newt2.subset(lt);
    
    
    ZG.newt2 = obs;
    [Mc, Mc90, Mc95, magco, prf]=mcperc_ca3(obs.Magnitude);
    if isnan(Mc95) == 0
        magco = Mc95;
    elseif isnan(Mc90) == 0
        magco = Mc90;
    else
        [bv magco stan av pr] =  bvalca3(obs.Magnitude,1);
    end
    magco = magco+0;
    l = obs.Magnitude >= magco-0.05;
    nEvents=sum(l);
    
    %[bv magco0 stan av pr] =  bvalca3(obs.Magnitude(l),2);
    [bv4 stan4 ] = calc_bmemag(obs.Magnitude(l));
    av4 = log10(nEvents) + bv4*magco;
    af = log10(nEvents) + 0.85*magco;
    
    tdpre = max(obs.Date) - min(obs.Date);
    tr2 = [];
    
    for m = magco:0.1:7
        N = 10^(av4-bv4*m)/tdpre*pt;
        N2 = 10^(af-0.85*m)/tdpre*pt;   % this is with a fixed b =
        tr = (teb-t0b-pt)/(10^(av-bv*m));
        tr2 = [tr2 ; N  m N2];
    end
    
    pr = -diff(tr2(:,:),1);
    pr = [  NaN NaN NaN ; pr];
    
    % this i sthge observed
    l = pre(:,6) > magco;
    [px,xxv] = hist(pre(l,6),magco-0.05:0.1:7);
    
    ZG.newt2 = newt0;
    
    
    P = poisspdf(px',pr(:,1));
    Pk = poisspdf(px',pr(:,3));
    
    lP = log(P);
    l = isinf(lP);
    lP(l) = 0;
    
    lPk = log(Pk);
    l = isinf(lPk);
    lPk(l) = 0;
    
    
    %disp(['Log likelihood sum: local Tl model: ' num2str(sum(lP)) ' Kagan & Jackson model: ' num2str(sum(lPk)) ])
    %str2 = ['Log likelihood sum: local Tl model: ' num2str(sum(lP)) ];
    %str3 = ['Kagan & Jackson model: ' num2str(sum(lPk))  ];
    
    dP = sum(lP) - sum(lPk);
    
end
