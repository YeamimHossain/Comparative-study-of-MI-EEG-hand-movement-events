%--------------------> Feature Extraction <-----------------------
% Function for the extraction of Time domain and frequency domain features
% from eeg/ecg/emg etc. dataset
% Author: Muhammad Yeamim Hossain
%
% Description:
% data = Data for feature extraction
% T = ToTal time in seconds
% e = Number of electrodes
% fs = Sampling frequency of the signal
%
% Syntax:
% feat_out = feat_extract(data,T,e,fs)
% Example:
% test_data = rand(6,10)
% T = 6; e = 2; fs=5;
% output = feat_extract(test_data,T,e,fs)


function [feat_out] = feat_extract(data,T,e,fs)
    n_feat = 25;    % Number of features
    for row = 1:T
        for col = 1:e
            fit = col-1;
            % Mean
            feat_out(row,1+n_feat*fit) = mean(data(row,fit*fs+1:col*fs));
            % Median
            feat_out(row,2+n_feat*fit) = median(data(row,fit*fs+1:col*fs));
            % Mean Absolute Deviation
            feat_out(row,3+n_feat*fit) = mad(data(row,fit*fs+1:col*fs));
            % Standard Deviation
            feat_out(row,4+n_feat*fit) = std(data(row,fit*fs+1:col*fs));
            % Quantile 25
            feat_out(row,5+n_feat*fit) = quantile(data(row,fit*fs+1:col*fs),0.25);
            % Quantile 75
            feat_out(row,6+n_feat*fit) = quantile(data(row,fit*fs+1:col*fs),0.75);
            % Interquartile Range
            feat_out(row,7+n_feat*fit) = iqr(data(row,fit*fs+1:col*fs));
            % Peak
            feat_out(row,8+n_feat*fit) = max(abs(data(row,fit*fs+1:col*fs)));
            % RMS
            feat_out(row,9+n_feat*fit) = rms(data(row,fit*fs+1:col*fs));
            % Skewness
            feat_out(row,10+n_feat*fit) = skewness(data(row,fit*fs+1:col*fs));
            % Kurtosis
            feat_out(row,11+n_feat*fit) = kurtosis(data(row,fit*fs+1:col*fs));
            % Crest Factor
            feat_out(row,12+n_feat*fit) = peak2rms(abs(data(row,fit*fs+1:col*fs)));
            % Clearance Factor
            feat_out(row,13+n_feat*fit) = max(abs(data(row,fit*fs+1:col*fs)))/.....
                (sum(sqrt(abs(data(row,fit*fs+1:col*fs))))/length((data(row,fit*fs+1:col*fs)))^2);
            % Shape Factor
            feat_out(row,14+n_feat*fit) = (sqrt(sum((data(row,fit*fs+1:col*fs)).^2)/......
                length(data(row,fit*fs+1:col*fs))))/..........
                (sum(abs(data(row,fit*fs+1:col*fs)))/length(data(row,fit*fs+1:col*fs)));
            % Impulse Factor
            feat_out(row,15+n_feat*fit) = max(abs(data(row,fit*fs+1:col*fs)))/........
                (sum(abs(data(row,fit*fs+1:col*fs)))/length(data(row,fit*fs+1:col*fs)));
            % Peak to Peak
            feat_out(row,16+n_feat*fit) = peak2peak(data(row,fit*fs+1:col*fs));
            % SNR
            feat_out(row,17+n_feat*fit) = snr(data(row,fit*fs+1:col*fs));
            % Signal Energy
            feat_out(row,18+n_feat*fit) = sum(abs(data(row,fit*fs+1:col*fs).^2));
            % Root Sum of Square level(RSSQ)
            feat_out(row,19+n_feat*fit) = rssq(data(row,fit*fs+1:col*fs));
            % Band Power
            feat_out(row,20+n_feat*fit) = bandpower(data(row,fit*fs+1:col*fs));
            % Occupied Bandwidth
            feat_out(row,21+n_feat*fit) = obw(data(row,fit*fs+1:col*fs),fs);
            % Total Harmonic Distortion
            feat_out(row,22+n_feat*fit) = thd(data(row,fit*fs+1:col*fs));
            % Signal to noise and distortion ratio
            feat_out(row,23+n_feat*fit) = sinad(data(row,fit*fs+1:col*fs));
            % Spurious free dynamic range
            feat_out(row,24+n_feat*fit) = sfdr(data(row,fit*fs+1:col*fs));
            % Power of Signal
            feat_out(row,25+n_feat*fit) = nanmean(abs(data(row,fit*fs+1:col*fs)).^2);
        end
    end
end
