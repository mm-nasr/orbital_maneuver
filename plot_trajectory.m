function plot_trajectory(Position,axes_handle,varargin)
%   This function is responsible solely for plotting the trajectory of the
%   orbit obtained
%   It requires the position vector to be drawn, the axes handle of axes it
%   will plot on, and accepts extra inputs such as the color and width of
%   the line as well as the marker. 
%   varargin = {'color','linewidth','marker'}

%   Checking line 
if length(varargin) >= 3
    color = varargin{1};
    linewidth = varargin{2};
    marker = varargin{3};
elseif length(varargin) == 2
    color = varargin{1};
    linewidth = varargin{2};
    marker = 'h';
elseif length(varargin) == 1
    color = varargin{1};
    linewidth = 2;
    marker = 'h';
else
    color = 'g';
    linewidth = 5;
    marker = 'h';
end
% draw_earth(axes_handle);
%   Make sure not to delete what is on the plot
hold on;
if size(Position,2) == 3
    X = Position;
elseif size(Position,1) == 3
    X = Position';
else
    error('The Position vector provided must be 3 dimensional!\n')
end

h= animatedline(axes_handle,'Color',color,'linewidth',linewidth,'marker',marker);
for i=1:size(X,1)
   addpoints(h,X(i,1),X(i,2),X(i,3));
   drawnow limitrate
   pause(0.02);
%    rotate(globe,[0,0,1],5);
%    pause(0.05);
end
