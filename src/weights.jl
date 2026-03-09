function _odd_weights(n::Int)
    k = n ÷ 2
    rhs = [2^(j-1) for j=1:k]
    return vcat(reverse(rhs),[1], rhs)
end

function _even_weights(n::Int)
    k = n÷2 - 1
    rhs = [ (3//2)*2^j for j=0:k]
    return vcat(reverse(rhs),[1;1], rhs)
end


"""
    weight_vector(b::Int)

Return the weight vector for `b`-bit words.
"""
function weight_vector(b::Int)
    if mod(b,2)==0
        return _even_weights(b)
    end
    return _odd_weights(b)
end