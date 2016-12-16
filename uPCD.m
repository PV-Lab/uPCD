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

%Parse through a 1D vector of a uPCD map to produce a 2D matrix of
%lifetimes/values at x,y positions. Input should be the data without
%headers read directly from an exported file in .xlsx format. Take a look
%in the file and specify what the step between pixels is for the x and y
%coordinates (first column, second column, respectively). This should
%change as you change the resolution of the scan. 

function [reshaped] = uPCD(data,xstep,ystep)

x = data(:,1);
y = data(:,2);
z = data(:,3); %value at that pixel, either lifetime or injection level typ

max_x = max(x);
min_x = min(x);
pixels_x = (max_x-min_x+1)/xstep;

max_y = max(y);
min_y = min(y);
pixels_y = (max_y-min_y+1)/ystep;

%Make a matrix of zeros that we will fill in while parsing through the
%actual data
reshaped = zeros(round(pixels_y),round(pixels_x));

for i = 1:length(z)
    
    x_value = ((x(i)-min_x)/xstep)+1; %The minimum x value is indexed as x = 1
    y_value = ((y(i)-min_y)/ystep)+1; %the minimum y value is indexed as y = 1 (so the image will be vertically flipped)
    
    reshaped(round(y_value),round(x_value)) = z(i);
    
end

%correct the matrix so that it's not longer vertically flipped
reshaped = flipud(reshaped);

end
    


