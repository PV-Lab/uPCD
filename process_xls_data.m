%{
MIT License

Copyright (c) [2016] [Mallory Ann Jensen, jensenma@alum.mit.edu]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
%}

function process_xls_data(dirname,saveName)
% dirname = 'C:\Users\Mallory\Documents\Thesis\FCA TIDLS measurements\FZ track SRV';

[fileList,fileListShort] = getAllFiles(dirname); 
%should be in order - 18,196,A - bottom,center,left,right,top

[m,n] = size(fileList); 
dataSave = cell(m,n);

for i = 1:m
    %For the NEW spreadsheet format
    data = xlsread(fileList{i},'RawData','E4:G124');
    lifetime = data(:,1); %seconds
    deltan = data(:,3); %cm^-3
    dataSave{i} = [deltan,lifetime];
    
    %For the OLD spreadsheet
%     data = xlsread(fileList{i},'Calc','L15:S131');
%     lifetime = data(:,1); %seconds
%     deltan = data(:,8); %cm^-3
%     dataSave{i} = [deltan,lifetime];
    
    figure;
    loglog(deltan,lifetime,'.');
    xlabel('Excess carrier density (cm^-^3)','FontSize',20);
    ylabel('Lifetime (seconds)','FontSize',20);
    title(fileListShort{i},'FontSize',20);
end

%save('all_XLS_data.mat','fileListShort','dataSave');
save(saveName,'fileListShort','dataSave');