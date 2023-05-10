clearvars -except data_test
load('s01_data.mat')
for i = 1:7
    j = i-1;
%     k = i-2;
   fig_data(1,j*512+1:512*i) = data_test(i,1:512);
end
fig_data = fig_data*1e-6;

% Data labeling code
n_t = 7;    % Total time(s) for a single subject
LabelsIN=zeros(n_t,1);
for n_l = 3:7:n_t
    LabelsIN(n_l:n_l+2,:)=1;
end

LabelsIN = LabelsIN(1:7,:)';
label = [];
for lchk = 1:1:length(LabelsIN)
   if  LabelsIN(lchk) == 1
       se = ones(1,512);
   elseif LabelsIN(lchk) == 0
       se = zeros(1,512);
   end
   label = [label se];
end
subplot(2,1,1)
plot(fig_data,'r')
axis([0 3584 -0.040 -0.020])
xlabel('No. of sample')
ylabel('Amplitude (V)')
title('MI & non-MI related EEG data')
grid on
subplot(2,1,2)
plot(label,'b','Linewidth',1)
axis([0 3584 -0.5 1.5])
xlabel('No. of sample')
ylabel('Class (0 or 1)')
title('Label of the corresponding EEG data')
grid on