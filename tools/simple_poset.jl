include("decomposition.jl")
using SimplePosets, SimplePosetAlgorithms, DrawSimplePosets

"""
    make_simple_poset(b::Int)

Create a `SimplePoset` from the `b`-bit words.
"""
function make_simple_poset(b::Int)
    g = word_gen(b)
    P = SimplePoset{Word}()
    for v in g 
        add!(P,v)
    end

    for v in g 
        for w in g 
            if v<w && compare(v,w)
                add!(P,v,w)
            end
        end
    end
    return P
end


"""
    rank_decomposition(b::Int)

Return a decomposition of the `b`-bit word poset by layers from the bottom up.
"""
function rank_decomposition(b::Int)
    P = make_simple_poset(b)
    result = Vector{Vector{Word}}()
    while length(P.D.V) > 0
        bottoms = minimals(P)
        push!(result, bottoms)
        for v in bottoms
            delete!(P,v)
        end
    end
    return result
end