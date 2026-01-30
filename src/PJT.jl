module PJT

export Word


export flip, longest_monotone, value

export word_gen, flip_word_gen
export max_chain, max_antichain, height, width
export recursive_chain, palindromes, middle


export conj_a, conj_c

"""
	Word(b::Int, v::Int = 0)

Create a binary word with `b` bits whose value is `v`.
"""
struct Word
	bits::Int           # number of bits    
	val::Int            # value 
	str::String         # string representation

	function Word(b::Int, v::Int = 0)
		if v < 0 || v >= 2^b
			error("Invalid value $v for a $b-bit Word")
		end
		s = binary_string(v, b)
		new(b, v, s)
	end
end


value(w::Word) = w.val

import Base.Multimedia.display
display(w::Word) = println(w.str)

import Base.show
show(io::IO, w::Word) = print(io, w.str)

"""
	flip(w::Word)

Reverse the digits of `w`.
"""
function flip(w::Word)::Word
	Word(w.bits, _flip(w.val, w.bits))
end


import Base.isless
isless(v::Word, w::Word) = v.val < w.val



function _flip(n::Int, b::Int)::Int
	digs = _int2bin(n, b)
	digs = reverse(digs)
	return _bin2int(digs)
end

"""
	_int2bin(n::Int, w::Int)::Vector{Int}

Convert an integer `n` into a `w`-bit vector of its bits. 
"""
function _int2bin(n::Int, w::Int)::Vector{Int}
	if n<0
		error("Not valid for negative numbers")
	end
	digs = digits(n, base = 2)
	nd = length(digs)
	if nd > w
		error("$n is too large to fit in $w bits")
	end

	pad = zeros(Int, w-nd)
	return [digs; pad]
end

"""
	_bin2int(digs::Vector{Int})::Int

Convert a vector of bits back to an integer. 
"""
function _bin2int(digs::Vector{Int})::Int
	nd = length(digs)
	return sum(digs[k] * 2^(k-1) for k ∈ 1:nd)
end



"""
	longest_monotone(words::Vector{T}) where T <: Union{Number, Word}

Given a list of words, `words`, return the longest increasing [nondecreasing]
and longest decreasing [nonincreasing] subsequences.
"""
function longest_monotone(words::Vector{T}) where T <: Union{Number, Word}
	n = length(words)
	if n < 2
		return words, words
	end

	d = Dict{Int, Tuple{Int, Int}}()

	d[n] = (1, 1)

	for k ∈ (n-1):-1:1
		x = y = 1    # new pair for d[k]
		val = words[k]
		for i ∈ (k+1):n
			if val ≥ words[i]
				x = max(d[i][1]+1, x)
			end
			if val ≤ words[i]
				y = max(d[i][2]+1, y)
			end
		end
		d[k] = x, y
	end

	up = [d[k][1] for k ∈ 1:n]
	dn = [d[k][2] for k ∈ 1:n]

	up_ind = get_decreasing_indices(up)
	# @show up_ind
	dn_ind = get_decreasing_indices(dn)

	return words[up_ind], words[dn_ind]
end

function get_decreasing_indices(vec::Vector{Int})
	nv = length(vec)
	result = Int[]
	m = maximum(vec)
	last = 0

	for k ∈ m:-1:1
		candidates = [j for j ∈ (last+1):nv if vec[j] == k]
		last = candidates[1]
		append!(result, last)
	end
	return result
end


"""
	word_gen(b::Int)

Create a list of all `b`-bit words from 0000 to 1111.
"""
function word_gen(b::Int)
	(Word(b, k) for k ∈ 0:(2^b-1))
end

"""
	flip_word_gen(b::Int)

Create a list of all `b`-bit words from 0000 to 1111 after flipping.
"""
function flip_word_gen(b::Int)
	(flip(w) for w in word_gen(b))
end

"""
	flip_list(b::Int)

Return the flip of the numbers `0` through `2^b-1`.
"""
function flip_list(b::Int)::Vector{Int}
	return [flip(x, b) for x in collect(0:(2^b-1))]
end

"""
	binary_string(n::Int, b::Int)::String

Write `n` as a binary string with `b` bits. 
"""
function binary_string(n::Int, b::Int)::String
	if n<0
		error("Input must be nonnegative.")
	end
	digs = digits(n, base = 2)
	nd = length(digs)
	if nd > b
		error("$n too big to fit in $b bits.")
	end
	pad = zeros(Int, b-nd)
	digs = [digs; pad]
	digs = reverse(digs)

	result = ""
	for d in digs
		result *= string(d)
	end
	return result
end

"""
	max_chain(b::Int)

Create a longest increasing sequence of flipped words with `b` bits. 
"""
function max_chain(b::Int)
	list = collect(flip_word_gen(b))
	longest_monotone(list)[2]
end

"""
	max_antichain(b::Int)

Create a longest decreasing sequence of flipped words with `b` bits. 
"""
function max_antichain(b::Int)
	list = collect(flip_word_gen(b))
	longest_monotone(list)[1]
end


height(b::Int) = length(max_chain(b))
width(b::Int) = length(max_antichain(b))

"""
	recursive_chain(b::Int)

Create a (persumably maximum) chain for `b`-bit words by recursion.
"""
function recursive_chain(b::Int)
	if b ≤ 0
		error("Number of bits must be positive")
	end

	if b==1
		return [Word(1, 0), Word(1, 1)]
	end

	if b==2
		return [Word(2, 0), Word(2, 1), Word(2, 3)]
	end

	base_list = recursive_chain(b-2)

	front = [Word(b, 2*value(w)) for w in base_list]
	back = [Word(b, 2*value(w) + 2^(b-1) + 1) for w in base_list]
	return [front; back]

end


"""
	palindromes(b::Int)

Return the list of `b`-bit palindromes. This will be a chain.
"""
function palindromes(b::Int)
	[w for w in word_gen(b) if w == flip(w)]
end



"""
	conj_c(b::Int)

Return the conjectured height for `b` bits.
"""
function conj_c(b::Int)
	if mod(b, 2)==0
		return 3 * 2^(b÷2 - 1)
	else
		x = (b+1) ÷ 2
		return 2^x
	end
end

"""
	conj_a(b::Int)

Return the conjectured width for `b` bits.
"""
conj_a(b::Int) = conj_c(b)-1


"""
	middle(list::Vector{T}) where T

Return the middle element of an odd-length list.
"""
function middle(list::Vector{T}) where T
	n = length(list)
	if mod(n, 2) == 0
		error("No middle element of an even-length list")
	end

	i = (n+1)÷2
	return list[i]
end

end # end module PJT
