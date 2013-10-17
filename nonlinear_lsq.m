function [a error covariance]=nonlinear_lsq(func,initial_values,x_data, y_data, ...
                         No_Iterations,damping)

% Nonlinear least square program modified from Paul Davis' program mylsq.m.
%
% Syntaxis.
%   out = nonlinear_lsq(@func, initial_values, data, No_iteractions,
%                       damping).
%
%   out:                Best fitting parameters.
%   func:               Matlab function of the form:
%                                    [x y] = func(parameters)
%   x_data:             Observed data - x-axis.
%   y_data:             Observed data - y_axis.   
%   No_iterations:      Number of iterations.
%   Damping:            Damping factor (optional - defaul 1e-11).
%
%                    ladominguez@ucla.edu

if nargin <= 5
    damping=1e-11;
end

TOL = 0.02;             % 2% Tolerance
a   = initial_values;
N   = numel (y_data);   % Number of data poins
M   = numel (a);        % Number of parameters

for k=1:No_Iterations,
    %% Deriviti
    dela=a(k,:)/100000;
    for j=1:M
        a(k,j)         = a(k,j)+dela(j);
        [x E1 E2 E3] = func(a(k,:));
        y_model2     = [ppval(spline(x,E1),x_data), ...
                        ppval(spline(x,E2),x_data), ...
                        ppval(spline(x,E3),x_data)];
        y_model2     = log10(y_model2);
        a(k,j)         = a(k,j)-2*dela(j);
        [x E1 E2 E3] = func(a(k,:));        
        y_model1     = [ppval(spline(x,E1),x_data), ...
                        ppval(spline(x,E2),x_data), ...
                        ppval(spline(x,E3),x_data)];
        y_model1     = log10(y_model1);
        a(k,j)         = a(k,j)+dela(j);
        am(1:N,j)    = [(y_model2 - y_model1)/(2*dela(j))]';
    end
    
    %% Deriviti
    del = y_data - y_model1;
    
    %damping
    vect   = ones(1,M);
    damp   = damping*diag(vect,0);
    
    % Find changes to a to improve fit
    da     = inv(am'*am+damp)*am'*del';
    
    % update a
    a(k+1,:)      = a(k,:)+real(da'); 
            
    % Evaluate function at new a values    
    [x E1 E2 E3] = func(a(k+1,:));
    if isnan(x)
        a = a.*NaN; 
        break
    end
    y_model1     = [ppval(spline(x,E1),x_data), ...
                    ppval(spline(x,E2),x_data), ...
                    ppval(spline(x,E3),x_data)];
    y_model1     = log10(y_model1);
    del          = y_data-y_model1;
    ssq          = sum(del.*del);
    
    % Check convergence
    if max(abs(a(k+1,:)-a(k,:))./a(k,:)) < TOL
        %disp(['Stopped at Iterarion - ' num2str(k)]);
        break
    end

end

% From errors.m by Paul Davis
error = zeros(size(initial_values)); % DRLA. WARNING. SETS ERRORS TO ZERO.
% vect  = ones(1,M)*ssq/(N-M);
% cov   = diag(vect);
% vmod  = inv(am'*am)*cov;
% error = sqrt(diag(vmod));
% covariance = vmod(2,2);



% Former documentation from the original program.
% Subroutines needed are deriviti.m errors.m
% put function in func.m  unknowns in vector a,
% data in vector y , and in function output in vector f
% all vectors should be row vectors.
% set the least squares damping factor to be fact=1e-11;
% however for unstable problems fact=1e-4 may damp them down
% sets up derivitive matrix for lsq inversion