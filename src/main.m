close all;
clear;
clc;

coords_auburn_al = [32.60528971347516, -85.48672403168588 212];
coords_chesapeake_va = [36.76863076642226, -76.28744597650036 0];
coords_corpus_christi_tx = [27.795125685587532, -97.40576355243675 1];

% UTC time
time = [ ...
	2004, ... % year
	   7, ... % month
	  16, ... % day
	  17, ... % hour
	  00, ... % minute
];

% https://www.sidc.be/SILSO/datafiles#total
sunspot_table = readtable("./res/sunspot_number.csv");
sunspot_table.Properties.VariableNames = ["year", "month", "year_fraction", "sunspot_number", "std_dev", "n_obs", "is_definitive"];

sunspot_number = sunspot_table(sunspot_table.year == 2004 & sunspot_table.month == 07, :).sunspot_number;

origin = coords_auburn_al;
terminus = coords_chesapeake_va;

height_start = 90;
height_end = 650;

N_latitude = 20;
N_longitude = 20;
N_height = 5;
iono_grid_params = [ ...
		min([origin(1) terminus(1)]); ...
		abs(origin(1) - terminus(1))/N_latitude; ...
		N_latitude; ...
		min([origin(2) terminus(2)]); ...
		abs(origin(2) - terminus(2))/N_longitude; ...
		N_longitude; ...
		height_start; ...
		(height_start - height_end)/N_height; ...
		N_height
];

[iono_pf_grid, iono_pf_grid_5, collision_freq, Bx, By, Bz] = gen_iono_grid_3d(...
		time, sunspot_number, iono_grid_params, iono_grid_params, 1);

% calculate bearing
% https://www.movable-type.co.uk/scripts/latlong.html
% need elevation angle and bearing angle
origin_rad = deg2rad(origin);
terminus_rad = deg2rad(terminus);
dist = terminus_rad - origin_rad;
R = 6371e3;
x = R*cos(dist(1))*cos(dist(2));
y = R*cos(dist(1)*sin(dist(2)));
z = R*sin(dist(1));
d = sqrt(x^2 + y^2 + z^2);
az = atan2(sin(dist(2))*cos(terminus(1)), cos(origin(1))*sin(terminus(1)) - sin(origin(1))*cos(terminus(1))*cos(dist(2)));
% assume isosceles triangle

elevs = 20:0.1:70;
bearing = az + -10:0.1:10;
freq = (1:1:20)*1e6;

[ray_data, ray_path_data, ray_state_vec] = raytrace_3d(...
        origin(1), origin(2), origin(3), 1:0.1:90)

disp("done");
