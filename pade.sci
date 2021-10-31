function pade = pade(td,n)
    for j=1:n 
        num(j) = ( factorial(2*n-j) * factorial(n) * (-td*s)^j ) / ( factorial(2*n) * factorial(j) * factorial(n-j) )
        den(j) = ( factorial(2*n-j) * factorial(n) * ( td*s)^j ) / ( factorial(2*n) * factorial(j) * factorial(n-j) )
    end
    pade = (1+sum(num))/(1+sum(den))
endfunction 
