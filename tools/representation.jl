using PJT, SimplePosets, SimplePosetAlgorithms

"""
    represent(P::SimplePoset)::Dict

Given a poset `P`, construct a mapping `d` from `P` to `Word`s 
so that `x < y` in `P` iff `d[x] < d[y]` as words in Paul's order.
"""
function represent(P::SimplePoset)::Dict

	R = realizer(P, 2)
	L1 = R[:, 1] 
	L2 = R[:, 2]

	elist = elements(P)
	nels = length(elist)
	b = Int(ceil(log(2, nels)))
	@show b
	T = eltype(P)
	pos1 = Dict{T, Int}() # position of x in linear extension 1
	pos2 = Dict{T, Int}() # position of x in linear extension 2

    for x in elist 
        pos1[x] = _find_location(x,L1)-1
        pos2[x] = _find_location(x,L2)-1
    end

    rep = Dict{T,Word}() 

    for x in elist
        w1 = Word(b, pos1[x])
        w2 = Word(b, pos2[x])
        w2 = flip(w2)

        v = value(w1)*2^b + value(w2)

        rep[x] = Word(2b, v)


    end
	return rep
end


"""
	_find_location(a, list)

Find the index `i` such that `list[i] == a`
"""
function _find_location(a, list)
	findfirst(list .== a)
end

function rep2poset(d::Dict{T,Word}) where T 
    els = collect(keys(d))

    P = SimplePoset{T}()
    for e in els 
        add!(P,e)
    end

    for x in els 
        for y in els
            
            if d[x] < d[y]
                add!(P,x,y)
            end
        end
    end


    return P
end