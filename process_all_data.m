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

%%Load the data
clear all; close all; 
dirname_QSSPC = 'C:\Users\Mallory\Documents\QSSPC v uPCD study\Chromium - uPCD + Sinton\Chromium sample\QSSPC';
process_xls_data(dirname_QSSPC);
dirname_uPCD = 'C:\Users\Mallory\Documents\QSSPC v uPCD study\Chromium - uPCD + Sinton\Chromium sample\uPCD';
process_uPCD(dirname_uPCD);

%% Process Sinton data
clear all; close all; 
load('all_XLS_data.mat'); 
fileListQSS = fileListShort; 
dataQSS = dataSave; 
load('all_uPCD_data.mat');
datauPCD = dataSave;

%Desired radius of area to sample to compare to QSSPC
spatial_radius = 20; %mm

%indices in filelist for high and low injection lifetime maps
indexHigh = [1];
indexLow = [3];

%indices in filelist for high and low injection INJECTION maps
index_n_High = [2];
index_n_Low = [4];

%Make a variable to save the average values. The first column will contain
%the linear averages, the second column will contain the harmonic averages.
save_averages = zeros(4,2); 

for i = 1:length(fileListQSS)
    
    lifetime = figure;
    
    %Plot Sinton data
    data = dataQSS{i};
    deltan = data(:,1); 
    tau = data(:,2); 
    h(1) = semilogx(deltan,tau.*1e6,'.','MarkerSize',5);
    hold all; 
    
    %Select an area on the lifetime maps assumed they were undisturbed
    %spatially between measurements
    uPCDHIGH = datauPCD{indexHigh(i)};
    figure; 
    imagesc(uPCDHIGH,[0 10]); 
    axis('image'); 
    colormap('gray');
    colorbar;
    title(fileListShort{indexHigh(i)});
    disp('Click the center of the circle'); 
    [x,y] = ginput(1); 
    
    %Grab the high intensity uPCD lifetime data
    step_now = steps{indexHigh(i)};
    [m,n] = size(uPCDHIGH); 
    if step_now(1)==step_now(2)
        radius = spatial_radius/step_now(1); 
    else
        disp('Error with step size - x and y are different'); 
    end
    
    for j = 1:m
        for k = 1:n
            if abs(sqrt(abs(j-y)^2+abs(k-x)^2))>radius
                uPCDHIGH(j,k) = NaN;
            end
        end
    end
    figure;
    imagesc(uPCDHIGH,[0 10]); 
    axis('image'); 
    colormap('gray');
    colorbar;
    title([fileListShort{indexHigh(i)} ' after crop']);
    
    %Get the averages
    [linear,M_p] = tau_averages(uPCDHIGH);
    save_averages(1,1) = linear;
    save_averages(1,2) = M_p; 
    
    figure(lifetime); 
    hold all; 
    h(2) = semilogx([5e13 1e17],[save_averages(1,2) save_averages(1,2)],'--','LineWidth',2); 
    
    %Grab the low intensity uPCD lifetime data
    uPCDLOW = datauPCD{indexLow(i)};
    figure; 
    imagesc(uPCDLOW,[0 10]); 
    axis('image'); 
    colormap('gray');
    colorbar;
    title(fileListShort{indexLow(i)});
    
    for j = 1:m
        for k = 1:n
            if abs(sqrt(abs(j-y)^2+abs(k-x)^2))>radius
                uPCDLOW(j,k) = NaN;
            end
        end
    end
    figure;
    imagesc(uPCDLOW,[0 10]); 
    axis('image'); 
    colormap('gray');
    colorbar;
    title([fileListShort{indexLow(i)} ' after crop']);
    
    %Get the averages
    [linear,M_p] = tau_averages(uPCDLOW);
    save_averages(2,1) = linear;
    save_averages(2,2) = M_p; 
    
    figure(lifetime); 
    hold all; 
    h(3) = semilogx([5e13 1e17],[save_averages(2,2) save_averages(2,2)],'--','LineWidth',2); 
    
    %Now grab the injection estimates and plot them as well
    %high intensity
    uPCD_n_HIGH = datauPCD{index_n_High(i)};
    figure; 
    imagesc(uPCD_n_HIGH,[1e13 1e15]); 
    axis('image'); 
    colormap('gray');
    colorbar;
    title(fileListShort{index_n_High(i)});
    
    for j = 1:m
        for k = 1:n
            if abs(sqrt(abs(j-y)^2+abs(k-x)^2))>radius
                uPCD_n_HIGH(j,k) = NaN;
            end
        end
    end
    figure;
    imagesc(uPCD_n_HIGH,[1e13 1e15]); 
    axis('image'); 
    colormap('gray');
    colorbar;
    title([fileListShort{indexLow(i)} ' after crop']);
    
    %Get the averages
    [linear,M_p] = tau_averages(uPCD_n_HIGH);
    save_averages(3,1) = linear;
    save_averages(3,2) = M_p; 
    
    figure(lifetime); 
    hold all; 
    h(4) = semilogx([save_averages(3,2) save_averages(3,2)],[0 50],'--','LineWidth',2); 
    
    %low intensity
    uPCD_n_LOW = datauPCD{index_n_Low(i)};
    figure; 
    imagesc(uPCD_n_LOW,[1e13 1e15]); 
    axis('image'); 
    colormap('gray');
    colorbar;
    title(fileListShort{index_n_Low(i)});
    
    for j = 1:m
        for k = 1:n
            if abs(sqrt(abs(j-y)^2+abs(k-x)^2))>radius
                uPCD_n_LOW(j,k) = NaN;
            end
        end
    end
    figure;
    imagesc(uPCD_n_LOW,[1e13 1e15]); 
    axis('image'); 
    colormap('gray');
    colorbar;
    title([fileListShort{indexLow(i)} ' after crop']);
    
    %Get the averages
    [linear,M_p] = tau_averages(uPCD_n_LOW);
    save_averages(4,1) = linear;
    save_averages(4,2) = M_p; 
    
    figure(lifetime); 
    hold all; 
    h(5) = semilogx([save_averages(4,2) save_averages(4,2)],[0 50],'--','LineWidth',2); 
    
    xlabel('Excess carrier density (cm^-^3)','FontSize',30);
    ylabel('Lifetime (\mus)','FontSize',30);
    axis([5e13 1e17 0 50]);
    legend('QSS','uPCD HIGH','uPCD LOW','uPCD \Deltan HIGH','uPCD \Deltan LOW');
    
    
end




