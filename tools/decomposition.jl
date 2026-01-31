using PJT, SimpleGraphs, SimpleGraphAlgorithms

"""
	compare(v::Word, w::Word)

Return `true` if `v` and `w` are comparable in the PJT poset.
"""
function compare(v::Word, w::Word)
	lt = (v<w) && (flip(v) < flip(w))
	gt = (v>w) && (flip(v) > flip(w))
	return lt || gt
end

"""
	comp_graph(b::Int)

Create the comparability graph whose vertices are all `b`-bit words. 
"""
function comp_graph(b::Int)
	g = word_gen(b)
	G = UG{Word}()

	for v in g
		add!(G, v)
	end

	for v in g
		for w in g
			if compare(v, w)
				add!(G, v, w)
			end
		end
	end
	return G
end


"""
    chain_decomposition(b::Int)

Return an minimum chain decomposition of the poset of `b`-bit words.
"""
function chain_decomposition(b::Int)
	G = complement(comp_graph(b))
	k = max_clique(G)
	χ = length(k)
	f = vertex_color(G, χ)
	chains = [Set{Word}() for _ ∈ 1:χ]

    for v in G.V 
        c = f[v]
        push!(chains[c],v)
    end

    return [sort(collect(s)) for s in chains]
end


"""
    antichain_decomposition(b::Int)

Return an minimum antichain decomposition of the poset of `b`-bit words.
"""
function antichain_decomposition(b::Int)
	G = comp_graph(b)
	k = max_clique(G)
	χ = length(k)
	f = vertex_color(G, χ)
	antichains = [Set{Word}() for _ ∈ 1:χ]

    for v in G.V 
        c = f[v]
        push!(antichains[c],v)
    end

    return [sort(collect(s)) for s in antichains]
end