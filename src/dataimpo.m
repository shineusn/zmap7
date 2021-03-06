function dataimpo(in,in2) 
    % read hypoellipse and other formated  data into a matrix a that can be used in zmap
    %
    % Stefan Wiemer; 6/95
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun();
    myFigName='Data Import';
    
    
    report_this_filefun();
    % This is the info window text
    %
    ZG.bin_dur = days(28);
    ZG.CatalogOpts.BigEvents.MinMag = 6;
    titstr='The Data Input Window                        ';
    hlpStr= ...
        ['                                                '
        ' Allows you to Import data into zmap. At this   '
        ' You can either Import the data as ASCII colums '
        ' separated by blanks or as hypoellipse.         '
        ' To load an ASCII file seperated by blanks      '
        ' switch the popup Menu FORMAT to ASCII COLUMNS. '];
    
    
    % add a new label to the list
    importChoice=[' Choose a data format | Ascii columns | Read formatted (Hypo 88 char - NCEDC format) | Read formatted (Hypo 36 char - AEIC Format)| Read formatted (your format) |  Hypoellipse (string conversion) | JMA Format '];
    
    if in == 'initf'
        % add a new option for your own data file format like that
        if in2 == 5
            da = 'eq';close; inda =1;yourload(da,inda); return
        end
        
        if in2 == 4
            da = 'eq';close; inda =1;myload36(da,inda); return
        end
        if in2 == 3
            da = 'eq';close; inda =1;myload88(da,inda); return
        end
        if in2 == 7
            in='initf';inda=1;mylojma(in,inda); return
        end
        if in2 == 6
            in='initf';
            loadhypo('hypo_de'); return
        end
        if in2 == 2
            close; loadasci('earthquakes'); return
        end
        
    end
    
    % set up the figure
    lohy=findobj('Type','Figure','-and','Name',myFigName);
    
    
    % Set up the window Enviroment
    %
    if isempty(lohy)
        
        lohy = figure(...
            'Units','centimeter','pos',[0 3 18 6],...
            'Name',myFigName,...
            'visible','on',...
            'NumberTitle','off',...
            'Menu','none',...
            'NextPlot','add');
        axis off
    end  % if figure exist
    
    figure(lohy)
    clf
    
    uicontrol('BackGroundColor',[0.9 0.9 0.9],'Style','Frame',...
        'Units','centimeter',...
        'Position',[0.6 0.5   17  4.5]);
    
    uicontrol('Style','text',...
        'Units','centimeter','Position',[1 3.0   3  0.8],...
        'String','Format:');
    
    labelPos = [5 3.0 11 0.8];
    hImportChoice=uicontrol(...
        'Style','popup',...
        'Units','centimeter',...
        'Position',labelPos,...
        'String',importChoice,...
        'callback',@callbackfun_001);
    
    
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        in2=hImportChoice.Value;
        dataimpo('initf',in2);
    end
    
end
