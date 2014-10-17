%% Visualise data
% Michal Podhradsky, 2014
% Optionally for nicer saved plots use:
% export_fig test.png -m2.5 -transparent
clear all;
close all;
clc;

%% Load 
load('endurance-ev-remy-200V.mat')

%% Power calculations
pw = power*0.735; % motor power in kW
%pw = pw*1000; % motor power in W

motor_eff = 0.9; % 90% efficiency
Pme = pw/motor_eff;

Pb = Pme + 2; % in kW

Vdc = 177; % V nominal
Ib = Pb / Vdc * 1000;

%% Integrate current
totalcur = 0;
for k=2:length(elapsedTime)
    dT = elapsedTime(k) - elapsedTime(k-1);
    if throttlePosition(k) > 10
        totalcur = totalcur + Ib(k)*dT;
    end
end

%% Plot
figure;
plot(elapsedTime, pw, 'r-','LineWidth',3);
grid on;
hold on
plot(elapsedTime, Pme, 'b-','LineWidth',3);
plot(elapsedTime, Pb, 'g-','LineWidth',3);
xlabel('Simulation time[s]')
ylabel('power [kW]')
legend('motor mechanical power[kW]','motor electrical power [kW]','battery power[%]','Location','SouthEast')

figure;
plot(elapsedTime, Ib, 'r-','LineWidth',3);
grid on;
hold on
xlabel('Simulation time[s]')
ylabel('Battery current [A]')
legend('Battery DC current [A]','Location','SouthEast')  

totalcur
avg_cur = totalcur/elapsedTime(end)
capacity = 32; % Ah
endurance = capacity / avg_cur * 60 % min