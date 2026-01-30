
"""
    build_poset(w::Int)

Create Paul's posets on [1, 2^w).
"""
function build_poset(w::Int)
	N = 2^w-1
	P = Poset(N)

	Rlist = [(x, y) for x in 1:N for y in 1:N if x!=y && compare(x, y, w)]

	Posets.add_relations!(P, Rlist)
	return P
end


"""
	width_table(wmax::Int=10)

Print a table of Paul's posets with bit window `w` and the width thereof.
"""
function width_table(wmax::Int = 10)
	for w ∈ 1:wmax
		P = build_poset(w)
		println(w, "\t", width(P), "\t", Set(max_antichain(P)))
	end
end




"""
	height_table(wmax::Int=10)

Print a table of Paul's posets with bit window `w` and the height thereof.
"""
function height_table(wmax::Int = 10)
	for w ∈ 1:wmax
		P = build_poset(w)
		S = max_chain(P)
		S = Set(S) ∪ Set(0)
		println(w, "\t", length(S), "\t", S)
	end
end
