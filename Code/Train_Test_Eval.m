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
