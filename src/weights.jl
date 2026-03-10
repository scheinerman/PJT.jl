function _odd_weights(n::Int)
    k = n ÷ 2
    rhs = [2^(j-1) for j=1:k]
    return vcat(reverse(rhs),[1], rhs)
end

function _even_weights(n::Int)
    k = n÷2 - 1
    rhs = [ (3//2)*2^j for j=0:k-1]
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

"""
    weight(w::Word)

Returns the weight of the word `w` using Evan's weighting.
"""
function weight(w::Word)
    b = w.bits
    w_vec = _int2bin(value(w), b)
    w_vec' * weight_vector(b)
end