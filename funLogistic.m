function y = funLogistic(b,t)
         y = b(1)./(1 + b(3)*exp(-b(2)*t));
    end