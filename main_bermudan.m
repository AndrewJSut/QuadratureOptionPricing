function main_bermudan()
close all; clc;
curdir = fileparts(mfilename('fullpath'));
addpath(curdir);

% Make figure windows consistent
set(0,'DefaultFigureWindowStyle','normal');
set(0,'DefaultFigurePosition',[200 150 880 520]);

fprintf('=== Bermudan Option Runner ===\n');
fprintf('Start time: %s\n\n', datestr(now));

%% Shared parameters 
% Core GBM params (edit if needed)
S0    = 50;
r     = 0.05;
q     = 0.02;
sigma = 0.30;

% Strikes / maturities commonly used in your scripts
K_main      = 50;          % main strike used in tables/plots
K_compare   = 45;          % second strike for convergence plots
T_short     = 60/365;      % 60-day option
T_long      = 365/365;     % 365-day option
n_short     = 60;          % daily stepping (60 days)
n_long      = 365;         % daily stepping (365 days)

% Grid sizes
m_default   = 401;                   % single-run demo
m_list_plot = 101:2:401;             % odd sizes to center S0
m_vec_table = [201 301 401 501 601 701 801];  % table rows

% Push variables to BASE so the .mlx files can read them
vars = {'S0','r','q','sigma','K_main','K_compare','T_short','T_long','n_short','n_long', ...
        'm_default','m_list_plot','m_vec_table'};
for i = 1:numel(vars)
    assignin('base', vars{i}, eval(vars{i}));
end

%%  Files to run:
bermFiles = { ...
 'Bermudan_Naive_Smoothing.mlx', ...
 'BermudanPut_ImprovementOne.mlx', ...
 'BermudanPut_ImprovementTwo.mlx', ...
 'BermudanPut_ImprovementThree.mlx'};

    function runInBaseSafe(fname)
        fpath = fullfile(curdir, fname);
        fprintf('>> Running %s ...\n', fname);
        try
            if exist(fpath,'file') ~= 2
                error('FileNotFound: %s', fpath);
            end
            % Prefer Live Editor executor when available
            if exist('matlab.internal.liveeditor.execute','file') == 2 && endsWith(fname,'.mlx','IgnoreCase',true)
                evalin('base', sprintf('matlab.internal.liveeditor.execute(''%s'');', fpath));
            else
                % Fallback works in many releases
                evalin('base', sprintf('run(''%s'')', fpath));
            end
            fprintf('OK: %s completed.\n\n', fname);
        catch ME
            fprintf('ERROR running %s\nIdentifier: %s\nMessage: %s\n\n', ...
                    fname, ME.identifier, ME.message);
        end
    end

%% Run all Bermudan scripts 
fprintf('--- Running Bermudan Option Scripts ---\n\n');
for k = 1:numel(bermFiles)
    runInBaseSafe(bermFiles{k});
end

fprintf('All Bermudan scripts executed. End time: %s\n', datestr(now));

end