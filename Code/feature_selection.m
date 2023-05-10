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
final_feat = ffs(DataIN,Ranked_features,Label)