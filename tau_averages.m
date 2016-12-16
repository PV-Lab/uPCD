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

function [linear,M_p] = tau_averages(tau)

        linear = nanmean(nanmean(tau));

        [t,tt] = size(tau);
        count = 1;
        tau_hold = zeros(10,1);
        for k = 1:t
            for l = 1:tt
                if isnan(tau(k,l))==1
                    tau_hold = tau_hold;
                elseif tau(k,l)<0
                    tau_hold = tau_hold;
                else
                    tau_hold(count,1) = tau(k,l);
                    count = count+1;
                end
            end
        end

        %Optimum p-value for predicted efficiency from lifetime without knowledge
        %of cell fab process (Hannes Wagner, 2013, JAP). 
        p = -0.835; 
        M_p_hold = 0;
        count = 0;

        for k = 1:length(tau_hold);
            if tau_hold(k)==0
                M_p_hold = M_p_hold;
            else
                M_p_hold = M_p_hold+(tau_hold(k)^p);
                count = count+1;
            end
        end

        M_p = (M_p_hold/count)^(1/p);

end