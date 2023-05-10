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