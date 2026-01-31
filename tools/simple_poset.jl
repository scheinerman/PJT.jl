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