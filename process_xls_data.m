function process_xls_data(dirname,saveName)
% dirname = 'C:\Users\Mallory\Documents\Thesis\FCA TIDLS measurements\FZ track SRV';

[fileList,fileListShort] = getAllFiles(dirname); 
%should be in order - 18,196,A - bottom,center,left,right,top

[m,n] = size(fileList); 
dataSave = cell(m,n);

for i = 1:m
    %For the NEW spreadsheet format
%     data = xlsread(fileList{i},'RawData','E4:G124');
%     lifetime = data(:,1); %seconds
%     deltan = data(:,3); %cm^-3
%     dataSave{i} = [deltan,lifetime];
%     
%     %For the OLD spreadsheet
    data = xlsread(fileList{i},'Calc','L15:S131');
    lifetime = data(:,1); %seconds
    deltan = data(:,8); %cm^-3
    dataSave{i} = [deltan,lifetime];
%     
    figure;
    loglog(deltan,lifetime,'.');
    xlabel('Excess carrier density (cm^-^3)','FontSize',20);
    ylabel('Lifetime (seconds)','FontSize',20);
    title(fileListShort{i},'FontSize',20);
end

%save('all_XLS_data.mat','fileListShort','dataSave');
save(saveName,'fileListShort','dataSave');