function Xhat=gaussmap(Y,D)
%GAUSSMAP Gaussian MAP estimation. 
%   Xhat = GAUSSMAP(Y,D) returns the maximum a posteriori estimate Xhat for
%   a scalar X based on realization-vector Y. 

%   Copyright (c) 2017 by Robert M. Nickel
%   $Revision: 1.0 $
%   $Date: 02-Nov-2017 $

%   File History/Comments:
%   created   02-Nov-2017 22:42:48
%             on MATLAB 9.2.0.556344 (R2017a) for MACI64
%   modified  (N/A)

a=D(1,1); b=D(2:end,1); Xhat=-(1/a)*b.'*Y;