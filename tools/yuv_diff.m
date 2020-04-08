%------------------------------------------------------------------------------
%
%  Filename      : show_diff
%  Author        : Huang Lei Lei
%  Created       : 2019-04-12
%  Description   : show diff with matlab (wrapper)
%
%-------------------------------------------------------------------------------
%
%  Modified      : 2019-04-17 by HLL
%  Description   : maintained
%
%-------------------------------------------------------------------------------

%***PARAMETER *****************************************************************
CMP_TAR= 0;    % 0 decoded yuv vs dumped yuv (both from f265)
% 1 for decoded yuv in compare directory
% 2 for decoded yuv vs original yuv


%***MAIN BODY *****************************************************************

NAME_SES     = 'sessionTest';
NAME_SEQ     = 'Cactus';
DATA_Q_P     = '27';
SIZE_FRA_X   = 1920;
SIZE_FRA_Y   = 1080;
NUMB_FRA     = inf;
DATA_THR_DIF = 0;
INDX_SHOW    = "A";
show_diff_core(['../', NAME_SES, '/dump/', NAME_SEQ, '_', DATA_Q_P, '/', 'f265.tmp.yuv']    ...
    ,          ['../', NAME_SES, '/dump/', NAME_SEQ, '_', DATA_Q_P, '/',     'f265.yuv']    ...
    ,          SIZE_FRA_X                                                                   ...
    ,          SIZE_FRA_Y                                                                   ...
    ,          NUMB_FRA                                                                     ...
    ,          DATA_THR_DIF                                                                 ...
    ,          'B'                                                                          ...
);
