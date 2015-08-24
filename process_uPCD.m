function process_uPCD(dirname)

% dirname = 'C:\Users\Mallory\Documents\Thesis\FCA TIDLS measurements\FZ track SRV';

[fileList,fileListShort] = getAllFiles(dirname); 
%should be in order - 18,196,A - bottom,center,left,right,top

[m,n] = size(fileList); 
dataSave = cell(m,n);
steps = cell(m,n); 

for i = 1:m
    data = xlsread(fileList{i});
    stepx = abs(data(:,1)-data(1,1));
    stepx = stepx(find(stepx>0));
    index = find(stepx==min(stepx));
    stepx = stepx(index(1)); 

    stepy = abs(data(:,2)-data(1,2)); 
    stepy = stepy(find(stepy>0));
    index = find(stepy==min(stepy)); 
    stepy = abs(stepy(index(1))); 
    
    [reshaped] = uPCD(data,stepx,stepy);
    dataSave{i} = reshaped; 
    steps{i} = [stepx stepy];
    
    figure; 
    imagesc(reshaped); 
    axis('image'); 
    colormap('gray');
    colorbar;
end

save('all_uPCD_data.mat','fileListShort','dataSave','steps');