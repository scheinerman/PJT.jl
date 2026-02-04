include("decomposition.jl")
using SimplePosets, DrawSimplePosets, SimpleDrawing

"""
	make_poset(b::Int)

Create a `SimplePoset` from the `b`-bit words.
"""
function make_poset(b::Int)
	g = word_gen(b)
	P = SimplePoset{Word}()
	for v in g
		add!(P, v)
	end

	for v in g
		for w in g
			if v<w && compare(v, w)
				add!(P, v, w)
			end
		end
	end
	return P
end


"""
	make_xy(b::Int)

Create an embedding for the W_b poset. 
"""
function make_xy(b::Int)
	d = Dict{Word, Vector{Float64}}()
	R = [1 -1; 1 1]
	for w in word_gen(b)
		x = value(w)
		y = value(flip(w))
		vec = R * [x; y]
		d[w] = vec
	end
	return d
end

"""
	make_drawing(b::Int, labs::Bool = true)

Draw the word poset on `b`-bit words. 
"""
function make_drawing(b::Int, labs::Bool = true)
	P = make_poset(b)
	H = HasseDiagram(P)
	xy = make_xy(b)
	setxy!(H, xy)

	if labs
		set_vertex_size(H, 18)
		draw(H)
		draw_labels(H.G)
	else
		draw(H)
	end

	expand_canvas()
	finish()
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
			delete!(P, v)
		end
	end
	return result
end

"""
	covers(b::Int)

Find all pairs of words `v,w` in `W_b` such that `w` covers `v`.
"""
function covers(b::Int)
	P = make_poset(b)
	H = HasseDiagram(P)
	E = collect(H.G.E)
	return sort(E)
end

"""
	type_I(v::Word, w::Word)::Bool

Check if the change from `v` to `w` is type I, that is, 
one bit of `v` was changed from `0` to `1`.
"""
function type_I(v::Word, w::Word)::Bool
	if count_ones(v.val) ≥ count_ones(w.val)
		return false
	end
	if count_ones(w.val) != count_ones(v.val)+1
		return false
	end

	x = v ⊻ w
	if count_ones(x.val) != 1
		return false
	end
	return true
end

"""
	type_H(v::Word, w::Word)::Bool

See if `w` is derived from `w` from a type H transformation.
This means a substring of the form `01110` becomes `10001`
"""
function type_H(v::Word, w::Word)::Bool
	if !(v<w)
		return false
	end
	x = v ⊻ w
	if count_ones(x.val) == 1
		return false
	end
	#@show x
	b = v.bits

	x_digs = reverse(digits(x.val; base = 2, pad = b))
	#@show x_digs'

	locations = findall(x_digs .> 0)  # find all the 1s 
	frst = locations[1]    # first 1 in the xor
	lst = locations[end]   # last 1 in the xor

	v_digs = reverse(digits(v.val; base = 2, pad = b))
	#@show v_digs

	if v_digs[frst]==1 || v_digs[lst]==1
		return false 
	end

	for i=frst+1:lst-1 
		if v_digs[i] == 0
			return false 
		end
	end


	if lst ≤ frst+1
		return false
	end

	if all(x_digs[frst:lst] .== 1)
		return true
	end
	return false
end

"""
    has_type(v::Word, w::Word)::Bool

Return `true` if the transformation from `v` to `w` is either type I or H. 
"""
function has_type(v::Word, w::Word)::Bool
	return type_I(v,w) || type_H(v,w)
end
"""
	show_type(v::Word, w::Word)

Show the type of the transformation from `v` to `w`.
"""
function show_type(v::Word, w::Word)
	print(v, " → ", w, "\t")
	if type_I(v, w)
		print("Type I ")
	end
	if type_H(v, w)
		print("Type H")
	end
	println()
end


"""
	is_covered_by(v::Word, w::Word)::Bool

Return true `v` is covered by `w`.
"""
function is_covered_by(v::Word, w::Word)::Bool
	if !(v<w)
		return false
	end

	b = v.bits

	for x in word_gen(b)
		if v < x < w
			return false
		end
	end

	return true
end
