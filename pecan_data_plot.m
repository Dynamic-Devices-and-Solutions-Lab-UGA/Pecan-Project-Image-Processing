%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Plots data output from data structure - produces rough plots which are to
% be monitored and then sent out for plotting in TikZ
%
%
% Author: Dani Agramonte
% Last Updated: 05.06.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load(['C:\Users\Dani\Documents\Pecan-Project-Image-Processing\'...
    'Pecan_Data_Master\pecan_data_struct.mat'])

figure
for m = 1:2
    if m == 1
        y(m) = 426.18;
    else
        y(m) = 655.33;
    end
    
    for i = 1:9
        x(i) = pecan_data_struct(9*(m-1)+i).metadata.Height;

        num = 0;
        den = 0;
        for j = 1:length(pecan_data_struct(i).test)
            result = char(pecan_data_struct(i).test(j).result);
            switch result 
                case 'Successful Crack'
                    for k = 1:2
                        if pecan_data_struct(i).test(j).post_crack_data.half(k).perc<200
                            num = num+pecan_data_struct(i).test(j).post_crack_data.half(k).perc;
                            disp(pecan_data_struct(i).test(j).post_crack_data.half(k).perc)
                            den = den+1;
                            scatter3(x(i),y(m),pecan_data_struct(i).test(j).post_crack_data.half(k).perc)
                            hold on
                        end
                    end
                case 'Unsuccessful Crack'
                    den = den+1;
                        scatter3(x(i),y(m),0)
                        hold on
                case 'Diseased Pecan'
                    continue
            end
            avg(i) = num/den;
        end
    end
end

z(1:2,1:9) = [avg(1:9);avg(10:18)];
x(1:2,1:9) = [x(1:9);x(1:9)];
y(1,1:9) = 426.18*ones(1,9);
y(2,1:9) = 655.33*ones(1,9);