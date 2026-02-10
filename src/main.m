close all;
clear;
clc;

coords_auburn_al = [32.60528971347516, -85.48672403168588];
coords_chesapeake_va = [36.76863076642226, -76.28744597650036];
coords_corpus_christi_tx = [27.795125685587532, -97.40576355243675];

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
		
disp("done");
