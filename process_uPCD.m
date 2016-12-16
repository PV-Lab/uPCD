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