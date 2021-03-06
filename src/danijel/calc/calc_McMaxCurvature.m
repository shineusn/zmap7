function [fMc] = calc_McMaxCurvature(magnitudes)
    % magnitude of completeness at the point of maximum curvature of the frequency magnitude distribution
    %  [fMc] = calc_McMaxCurvature(magnitudes);
    %
    % Input parameter:
    %   mCatalog        Earthquake catalog magnitudes
    %
    % Output parameter:
    %   fMc             Magnitude of completeness, NaN if not computable
    %
    %  assumes magnitude bin size of 0.1
    % Danijel Schorlemmer 2001
    % Modified by CGReyes 2017
    
    % report_this_filefun();
    
    try
        % Get maximum and minimum magnitudes of the catalog
        fMaxMagnitude = max(magnitudes);
        fMinMagnitude = min(magnitudes);
        if fMinMagnitude > 0
            fMinMagnitude = 0;
        end
        
        
        % Create a histogram over magnitudes
        %[vHist, vMagBins] = hist(mCatalog.Magnitude, (fMinMagnitude:0.1:fMaxMagnitude));
        vMagCenters = fMinMagnitude : 0.1 : fMaxMagnitude;
        vMagEdges = fMinMagnitude-0.05 : 0.1 : fMaxMagnitude+0.05;
        [vHist, ~] = histcounts(magnitudes, vMagEdges);
        
        % Get the points with highest number of events -> maximum curvature
        fMc = vMagCenters(find(vHist == max(vHist), 1, 'last' ));
        if isempty(fMc)
            fMc = nan;
        end
    catch
        fMc = nan;
    end
end
    
    
    
