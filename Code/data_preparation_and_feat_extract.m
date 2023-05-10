% Clean all to make a fresh start
clc; clear all; close all;

% Make a folder where the data will be saved
folder = 'F:\Projects\Comp_Study_MI_EEG\MI EEG feature data\';
mkdir(folder);

% Load subjects one by one to extract the features from it
all_sub = 52;     % Total number of subjects
basename = 's'; % File name in the directory excluding the number from letters

for sub = 1:all_sub
    filename = [basename,num2str(sub)];
    load(filename);

    % Subject data processing
    test=eeg.imagery_left;

    T = 700;    % Total time 
    e = 64;     % Total number of electrodes
    fs = 512;   % Sampling frequency

    % Data framing of all electrodes
    for initial = 1:e
        control = initial-1;
        row = test(initial,1:end);
        resize = reshape(row,[fs,T]);
        all_electrodes(:,fs*control+1:fs*initial)=resize';
    end
    
    data_test = double(all_electrodes);

    % Feature Extraction
    feat_out = feat_extract(data_test,T,e,fs);
    
    % Save feature extracted data in a new folder
    new_basename = sprintf('feat_out_sub%d',sub);
    s.(new_basename) = feat_out;
    save([folder new_basename],'-struct','s');
end
