function xscat = lc_xsec(catalog, width_km, pt1, varargin)
    % LC_XSEC create a cross section from a catalog
    % xscat = LC_XSEC(CATALOG, WIDTH_KM, PT1, PT2) where PT1 and PT2 are [lat, lon] pairs
    % ... = LC_XSEC(CATALOG, WIDTH_KM, PT1, LENGTH_KM, AZ)
    % ... = LC_XSEC(CATALOG, WIDTH_KM) choose with mouse [currently assumes main catalog]
    % 
    switch nargin
        case 2
             % LC_XSEC(CATALOG, WIDTH) choose with mouse
             [xscat, gcDist_km, zans] = plot_cross_section_from_mainmap;
        case 4
            % LC_XSEC(CATALOG, WIDTH_KM, PT1, PT2)
            xscat = ZmapXsectionCatalog(pt1, varargin{1}, width_km);
        case 5
            % LC_XSEC(CATALOG, WIDTH_KM, PT1, LENGTH, AZ)
            [pt2lat, pt2lon] = reckon(pt1(1),pt2(1),km2deg(varargin{1}), varargin{2});
            xscat = ZmapXsectionCatalog(pt1, [pt2lat pt2lon], width_km);
    end
    
end