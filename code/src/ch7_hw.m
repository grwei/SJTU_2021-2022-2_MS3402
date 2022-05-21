%% ch7_hw.m
% Description: MATLAB code for Homework 6 (Chapter 7) (MS3402, 2022 Spring)
% Author: Guorui Wei (危国锐) (313017602@qq.com; weiguorui@sjtu.edu.cn)
% Student ID: 516021910080
% Created: 2022-05-01
% Last modified: 2022-05-01
% References: [1] Hartmann, D. L. (2016). Chapter 7 - The Ocean General Circulation and Climate. In D. L. Hartmann (Ed.), Global Physical Climatology (Second Edition) (pp. 195-232). Elsevier. https://doi.org/10.1016/B978-0-12-328531-7.00007-4 

%% Initialize project

clc; clear; close all
init_env();

%% Problem 7 of [1,p.232]

% params

A = .2;             % [N/m^2]
L = 1500e3;         % [m]
rho_0 = 1025;       % [kg/m^3]
Omega = 7.292e-5;   % [rad/s] angular velocity of the Earth = 2*pi/(23*3600+56*60)
lat = pi/6;         % [rad E]
R_E = 6371e3;       % [m] radius of the Earth
W = 5000e3;         % [m] the ocean basin width

%
f_0 = 2*Omega*sin(lat);                  % [rad/s] Coriolis parameter
beta_0 = 2*Omega*cos(lat)/R_E;           % [rad/m/s]
tau_x = @(y) A*cos(pi*y/L);              % [N/m^2] wind stress
w_E = @(y) A*pi/rho_0/f_0/L*sin(pi*y/L); % the vertical velocity at the bottom of the Ekman layer
V_I = @(y) A/rho_0/f_0*cos(pi*y/L) + A*pi/rho_0/beta_0/L*sin(pi*y/L); % [m^3/m/s] the integrated meridional transport (volume)
M_y = W*A/f_0; % [kg/s] the water mass flux at y = 0 associated with the interior flow
fprintf("M_y = %.3d (kg/s)\n",M_y);

%% solve

y = linspace(-L,L,2^13);
val_w_E = w_E(y)*1e6; % [um/s]
val_V_I = V_I(y);
[w_E_max,ind_w_E_max] = max(val_w_E);
[w_E_min,ind_w_E_min] = min(val_w_E);
[V_I_max,ind_V_I_max] = max(val_V_I);
[V_I_min,ind_V_I_min] = min(val_V_I);

%% plot
t_fig = figure("Name","Fig.1 Ch7 Q7");
t_TCL = tiledlayout(1,2,"TileSpacing","tight","Padding","tight");

%%% Fig.1(a) w_E
t_Axes_tau_x = nexttile(t_TCL,1);
t_plot_tau_x = plot(t_Axes_tau_x,tau_x(y),y/1000,'-',"color",'#0072BD',"DisplayName",'$\tau_x$','LineWidth',1);
set(t_Axes_tau_x,"YDir",'normal',"TickLabelInterpreter",'latex',"FontSize",10,'Box','off','XColor','#0072BD','YColor','#0072BD');
%
t_Axes_w_E = axes(t_TCL);
t_Axes_w_E.Layout.Tile = 1;
t_plot_w_E = plot(t_Axes_w_E,val_w_E,y/1000,'-','Color','#D95319',"DisplayName",'$w_{\rm{E}}$','LineWidth',1);
hold on
t_plot_w_E_min = plot(t_Axes_w_E,w_E_min,y(ind_w_E_min)/1000,'o',"DisplayName",sprintf("$w_{\\rm{E}}(y = %.0f) = \\rm{%.1f}$",y(ind_w_E_min)/1000,w_E_min));
t_plot_w_E_max = plot(t_Axes_w_E,w_E_max,y(ind_w_E_max)/1000,'^',"DisplayName",sprintf("$w_{\\rm{E}}(y = %.0f) = \\rm{%.1f}$",y(ind_w_E_max)/1000,w_E_max));
hold off
set(t_Axes_w_E,'YDir','normal','FontSize',10,'TickLabelInterpreter','latex','XAxisLocation','top','YAxisLocation','right','YTickLabel',{},'Box','off','Color','none','XColor','#D95319','YColor','#D95319','YLimitMethod','tight')
xlabel(t_Axes_w_E,"$w_{\rm{E}}$ $(\rm{\mu m}/\rm{s})$","FontSize",10,Interpreter="latex")
%
linkaxes([t_Axes_w_E,t_Axes_tau_x],'y');
legend([t_plot_w_E,t_plot_tau_x,t_plot_w_E_min,t_plot_w_E_max],"Location",'southeast','Interpreter','latex',"Box","off");

%%% Fig.1(b) V_I
%
t_Axes_tau_x = nexttile(t_TCL,2);
t_plot_tau_x = plot(t_Axes_tau_x,tau_x(y),y/1000,'-',"color",'#0072BD',"DisplayName",'$\tau_x$','LineWidth',1);
set(t_Axes_tau_x,"YDir",'normal','YTickLabel',{},"TickLabelInterpreter",'latex',"FontSize",10,'Box','off','XColor','#0072BD','YColor','#0072BD');
%
t_Axes_V_I = axes(t_TCL);
t_Axes_V_I.Layout.Tile = 2;
t_plot_V_I = plot(t_Axes_V_I,val_V_I,y/1000,'-','Color','#D95319',"DisplayName",'$V_{\rm{I}}$','LineWidth',1);
hold on
t_plot_V_I_min = plot(t_Axes_V_I,V_I_min,y(ind_V_I_min)/1000,'o',"DisplayName",sprintf("$V_{\\rm{I}}(y = %.0f) = \\rm{%.1f}$",y(ind_V_I_min)/1000,V_I_min));
t_plot_V_I_max = plot(t_Axes_V_I,V_I_max,y(ind_V_I_max)/1000,'^',"DisplayName",sprintf("$V_{\\rm{I}}(y = %.0f) = \\rm{%.1f}$",y(ind_V_I_max)/1000,V_I_max));
hold off
set(t_Axes_V_I,'YDir','normal','FontSize',10,'TickLabelInterpreter','latex','XAxisLocation','top','YAxisLocation','right','YTickLabel',{},'Box','off','Color','none','XColor','#D95319','YColor','#D95319','YLimitMethod','tight')
xlabel(t_Axes_V_I,"$V_{\rm{I}}$ $(\rm{m}^3 / (\rm{m} \cdot \rm{s}))$","FontSize",10,Interpreter="latex")
%
linkaxes([t_Axes_V_I,t_Axes_tau_x],'y');
legend([t_plot_V_I,t_plot_tau_x,t_plot_V_I_min,t_plot_V_I_max],"Location",'southeast','Interpreter','latex',"Box","off");

%%%
xlabel(t_TCL,"$\tau_x$ $(\rm{N}/\rm{m}^2)$","FontSize",10,Interpreter="latex")
ylabel(t_TCL,"$y$ (km)","FontSize",10,Interpreter="latex")
[t_title_t,t_title_s] = title(t_TCL,"\bf 2022 Spring MS3402 Hw6 (Chapter 7) Pblm 7","Guorui Wei 516021910080","Interpreter",'latex');
set(t_title_s,'FontSize',8)
%
exportgraphics(t_TCL,"..\\doc\\fig\\ch7_P7.emf",'Resolution',800,'ContentType','auto','BackgroundColor','none','Colorspace','rgb')
exportgraphics(t_TCL,"..\\doc\\fig\\ch7_P7.png",'Resolution',800,'ContentType','auto','BackgroundColor','none','Colorspace','rgb')

%% local functions

%% Initialize environment
function [] = init_env()
    % set up project directory
    if ~isfolder("../doc/fig/")
        mkdir ../doc/fig/
    end
    % configure searching path
    mfile_fullpath = mfilename('fullpath'); % the full path and name of the file in which the call occurs, not including the filename extension.
    mfile_fullpath_without_fname = mfile_fullpath(1:end-strlength(mfilename));
    addpath(genpath(mfile_fullpath_without_fname + "../data"), ...
            genpath(mfile_fullpath_without_fname + "../inc")); % adds the specified folders to the top of the search path for the current MATLAB® session.
end
