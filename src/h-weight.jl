function middle(a,b)
    return sum(2^k for k=b+1:a-1)
end

function formula(a,b)
    return 2^a-2^(b+1)
end