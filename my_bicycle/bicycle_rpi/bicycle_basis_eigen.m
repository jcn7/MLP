function phi = mcar_basis_eigen( cState, cAction, cExtraParam)
  
global pBasis pBasisSub pEigenVals pGraph pOpts pNNInfo pPoints pPointsSub pNumberOfActions pActiveIdxs;

pNumberOfActions = 5;

if nargin==0,
    phi = pNumberOfActions*size(pBasis,1);
    return;
end;

if nargin==3,
    if strcmpi( cExtraParam.Action, 'Initialize'),
        pBasis      = cExtraParam.Basis;
        pEigenVals  = cExtraParam.EigenVals;
        for lk = 1:pNumberOfActions
            pActiveIdxs{lk} = 1:size(pBasis,1);        
        end;
        pGraph      = cExtraParam.Graph;
        pOpts       = cExtraParam.Opts;
        pNNInfo     = struct('Atria',cExtraParam.NNInfo.Atria,'Delta',pOpts.Delta,'kNN',pOpts.kNN);
        pPoints     = cExtraParam.Points; 
        pPointsSub  = cExtraParam.PointsSub;
        pBasisSub   = cExtraParam.BasisSub;
    elseif strcmpi( cExtraParam.Action, 'Restrict'),
        % Save the new active indices
        pActiveIdxs = cExtraParam.Idxs;
        % If some coefficients are provided, return the coefficients on the new basis
        if isfield(cExtraParam,'Coeffs'),
            lN = size(pBasis,1);
            phi = zeros(pNumberOfActions*lN,1);
            for lk = 1:pNumberOfActions,
                phi( (lk-1)*lN+pActiveIdxs(lk,:) ) = cExtraParam.Coeffs(lk,:);
            end;
        end;
    elseif strcmpi( cExtraParam.Action, 'SetOptions'),        
        % Set the options
        if isfield(cExtraParam,'NormalizationType'),
            lOpts.NormalizationType = cExtraParam.NormalizationType;
        else
            lOpts.NormalizationType = 'ave';
        end;
        
        if isfield(cExtraParam,'BlockSize'),

            lOpts.BlockSize = cExtraParam.BlockSize;

        end;

        if isfield(cExtraParam,'Type'),
            lOpts.Type = cExtraParam.Type;
        else
            lOpts.Type = 'nn';
        end;        
        if isfield(cExtraParam,'kNN'),
            lOpts.kNN = cExtraParam.kNN;
        else
            lOpts.kNN = 30;
        end;
        if isfield(cExtraParam,'kNNdelta'),
            lOpts.kNNdelta = cExtraParam.kNNdelta;
        else
            lOpts.kNNdelta = 10;
        end;
        if isfield(cExtraParam,'Delta'),
            lOpts.Delta = cExtraParam.Delta;
        else
            lOpts.Delta = 1;
        end;
        if isfield(cExtraParam,'DownsampleDelta'),
            lOpts.DownsampleDelta = cExtraParam.DownsampleDelta;
        else
            lOpts.DownsampleDelta = lOpts.Delta/9;
        end;
        if isfield(cExtraParam,'NNsymm'),
            lOpts.NNsymm = cExtraParam.NNsymm;
        else
            lOpts.NNsymm = 'ave';
        end;
        if isfield(cExtraParam,'MaxEigenVals'),
            lOpts.MaxEigenVals = cExtraParam.MaxEigenVals;
        else
            lOpts.MaxEigenVals = 20;
        end;
        if isfield(cExtraParam,'Rescaling'),
            lOpts.Rescaling = cExtraParam.Rescaling;
        else
            lOpts.Rescaling = [1,1,1,1,1,1,0,0,0,0,0];  % only consider first 6 state variables
        end;
        
        pOpts = lOpts;
        phi = lOpts;                     
    end;
    
%    save pEigenVecs pBasis pBasisSub pEigenVals pGraph pOpts pNNInfo pPoints pPointsSub pActiveIdxs % for debugging purposes only
    
    return;
end;

try
    % Call the function to evaluate the basis functions at the states and actions requested
    phi = rpi_basis_evaluate( cState, cAction, pBasis, pBasisSub, pPointsSub, pOpts, pNNInfo, pNumberOfActions, pActiveIdxs);
catch
    fprintf('Warning: error in bicycle_basis_eigen.\n');
    phi = [];
end;
    
return;