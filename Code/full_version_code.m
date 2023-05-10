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

%% Subject Loading
for load_sub = 1:52
    new_basename = sprintf('feat_out_sub%d',load_sub);
    load(new_basename)
end

%% Data labeling code
n_t = 14000;    % Total time(s) for a single subject
LabelsIN=zeros(n_t,1);
for n_l = 3:7:n_t 
    LabelsIN(n_l:n_l+2,:)=1;
end

%% Feature Selection
% Normalization of the data -1  to 1
n_sub = [feat_out_sub5; feat_out_sub8; feat_out_sub21; feat_out_sub23;.....
    feat_out_sub31; feat_out_sub35; feat_out_sub39];
n_sub = double(n_sub);
data_norm = normalize(n_sub,'range',[-1 1]);
DataIN=data_norm;
Label = LabelsIN(1:4900,1);
% 
% % MRMR feature ranking
% num_feat = 1088;
% Ranked_features = mrmr_rank(DataIN,Label,num_feat);
% or
% Ranked_features = fscmrmr(DataIN,Label);
% % Fisher's feature ranking
% Ranked_features = fisher_feature_rank(DataIN',Label');
% Ranked_features = Ranked_features';
% % Correlated Feature Selection (CFS)
% Ranked_features = corrSel(DataIN,Label);
% % Recursive feature elimination (RFE)
% Ranked_features = corrSel(DataIN,Label);
% % Pearson Correlation Coefficient (PCC)
% k = 1088; % Number of features to be ranked
% Ranked_features = jPCC(DataIN,Label,k);
% F-score Feature Selection (FS)
k = 1088; % Number of features to be ranked
Ranked_features = jFS(DataIN,Label,k);
% % Infinite Feature Selection (InFS)
% Ranked_features = InfFS_S(DataIN,Label);
% % Chi-Square Feature Selection (CSFS)
% Ranked_features = fscchi2(DataIN,Label);

% Forward feature selection (FFS)
final_feat = forward_feat_Sel(DataIN,Ranked_features,Label)

%% Configure data for Training and Testing
% 20 Subjects feature selection
S20S_MI_left = [feat_out_sub1; feat_out_sub3; feat_out_sub4;........
    feat_out_sub6; feat_out_sub9; feat_out_sub10; feat_out_sub14;.....
    feat_out_sub15; feat_out_sub25; feat_out_sub26; feat_out_sub28;.....
    feat_out_sub36; feat_out_sub41; feat_out_sub43; feat_out_sub44;.....
    feat_out_sub46; feat_out_sub48; feat_out_sub49; feat_out_sub50;.....
    feat_out_sub52feat_out_sub];
S20S_MI_left = double(S20S_MI_left);

% Normalization of the data -1  to 1
normalized_data = normalize(S20S_MI_left,'range',[-1 1]);

for rd_col = 1:size(final_feat,2)
    rdcv = final_feat(1,rd_col);
    final_features_l(:,rd_col) = normalized_data(:,rdcv);
end
rft_data = [LabelsIN final_features_l];

% Selected features picking from the main data
t_sub = 20; % Total number of Subjects
time = 700;
for sub_cell = 1:t_sub
    each_sub = rft_data(time*(sub_cell-1)+1:sub_cell*time,:);
    ALL_subj{sub_cell} = each_sub;
end

%% Train, Test & Rating of data
for index = 1:t_sub
    subj = 1:t_sub;
    subj(index)=[];
    train_data = ALL_subj(subj);
    for tata=1:t_sub-1
        poke = tata-1;
        training_data(time*poke+1:time*tata,:) = train_data{1,tata}(:,1:end);
    end
    % actual label
    feature_label = LabelsIN(1:700,1);
    test_label = feature_label;
    test_data = ALL_subj(index);
    test_data = test_data{:}(:,2:end);
    %Train
    train_model = trainClassifier_KNN(training_data);
    %Predicted label
    ylabel = train_model.predictFcn(test_data);
    % Performance
    rating(index,:) = Evaluate(test_label,ylabel)
end
