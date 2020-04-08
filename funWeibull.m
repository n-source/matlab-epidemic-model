 function out = funWeibull(param,time)
        out = param(1)*param(2)*param(3)*exp(-param(2)*time)./(1 + param(3)*exp(-param(2)*time)).^2;
    end