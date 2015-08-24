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