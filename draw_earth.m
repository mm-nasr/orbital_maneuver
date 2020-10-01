function draw_earth(axes_handle)
% [x,y,z] = sphere(30);
% I=imread('earthh.jpg');
% warp(x,y,z,I);
%% Textured 3D Earth example
%
% Ryan Gray
% 8 Sep 2004
% Revised 9 March 2006, 31 Jan 2006, 16 Oct 2013

%% Options

space_color = 'k';
npanels = 180;   % Number of globe panels around the equator deg/panel = 360/npanels
alpha   = 1; % globe transparency level, 1 = opaque, through 0 = invisible
%GMST0 = []; % Don't set up rotatable globe (ECEF)
GMST0 = 4.89496121282306; % Set up a rotatable globe at J2000.0

% Earth texture image
% Anything imread() will handle, but needs to be a 2:1 unprojected globe
% image.


% Mean spherical earth

erad    = 6371008.7714*(10^-3); % equatorial radius (kms)
prad    = 6371008.7714*(10^-3); % polar radius (kms)
erot    = 7.2921158553e-5; % earth rotation rate (radians/sec)

%% Create figure

% figure('Color', space_color);

hold on;

% Turn off the normal axes

% set(axes_handle, 'NextPlot','add', 'Visible','on','Color',space_color);
set(axes_handle, 'Visible','on','Color',space_color);

axis equal;
% axis off;

% Set initial view

view(0,30);
rotate3d on
axis vis3d;

%% Create wireframe globe

% Create a 3D meshgrid of the sphere points using the ellipsoid function

[x, y, z] = ellipsoid(0, 0, 0, erad, erad, prad, npanels);

globe = surf(axes_handle,x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1]);

if ~isempty(GMST0)
    hgx = hgtransform('Parent', axes_handle);
    set(hgx,'Matrix', makehgtform('zrotate',GMST0));
    set(globe,'Parent',hgx);
end

%% Texturemap the globe

% Load Earth image for texture map

cdata = imread('earthh.jpg');

% Set image as color data (cdata) property, and set face color to indicate
% a texturemap, which Matlab expects to be in cdata. Turn off the mesh edges.

set(globe, 'FaceColor', 'texturemap', 'CData', cdata, 'FaceAlpha', alpha, 'EdgeColor', 'none');
axis(axes_handle, 'off');
% 
% OPTIONS = odeset('RelTol',1e-9,'AbsTol',1e-12);
% tf1 = 10000;
% x1 = [6678,0,0,0,7.7258,0];
% [~,X] = ode45( @(t,xo) two_body(t,xo), [0,tf1],x1,OPTIONS);
% h= animatedline(axes_handle,'Color','r','linewidth',2,'marker','*');
% for i=1:size(X,1)
%    addpoints(h,X(i,1),X(i,2),X(i,3));
%    drawnow limitrate
%    rotate(globe,[0,0,1],5);
%    pause(0.05);
% end

