function h=xplot(x,y,c,varargin)
%XPLOT Preformatted plotting of a single line object. 
%   H = XPLOT(X,Y) plots a line segment with its 'XData' in X and its 
%   'YData' in Y into the current axis system and applies some default
%   formatting of the line and the axis system. Output argument H contains
%   the graphics handle to the resulting line object.


if nargin<2; y=x(:); x=1:length(x); end
if nargin<3; c='1'; end

% make sure both data sets are vectors of the same length
x=x(:); y=y(:); y=y(1:length(x));
h=plot(x,y);

% format the plot dimensions
Ymin=min(y); Ymax=max(y); Dy=Ymax-Ymin; if Dy<eps; Dy=1; end
Xmin=min(x); Xmax=max(x); Dx=Xmax-Xmin; if Dx<eps; Dx=1; else; Dx=0; end
axis([ Xmin-0.1*Dx Xmax+0.1*Dx Ymin-0.1*Dy Ymax+0.1*Dy ]);
grid on;

set(h,'LineWidth',2);

% check for a color code
[RGB,EC]=colorcode(c); if EC;
    % the string is not a valid color code
    varargin={c,varargin{:}};
else
    % use the color in the string for the line segment
    set(h,'Color',RGB);
end

% check for other formatting arguments
if ~isempty(varargin); set(h,varargin{:}); end

if nargout<1; clear h; end
