

% Basic BS for testing against Quadrature Convergence
function put_price = BlackScholes(S, K, r, q, h, sigma)

    d1  = (log(S./K) + (r - q + 0.5*sigma^2)*h) / (sigma*sqrt(h));

    d2  = d1 - sigma*sqrt(h);

    Nd1 = 0.5*(1 + erf(d1/sqrt(2)));

    Nd2 = 0.5*(1 + erf(d2/sqrt(2)));

    put_price = K*exp(-r*h).*(1 - Nd2) - S.*exp(-q*h).*(1 - Nd1); 

end

