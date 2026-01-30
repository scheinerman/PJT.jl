module PJT


export bin2int, int2bin, flip, compare, longest_monotone, flip_list, binary_string
export height, width, height_display, width_display, overall, conj_c


"""
	int2bin(n::Int, w::Int)::Vector{Int}

Convert an integer `n` into a `w`-bit vector of its bits. 
"""
function int2bin(n::Int, w::Int)::Vector{Int}
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
	bin2int(digs::Vector{Int})::Int

Convert a vector of bits back to an integer. 
"""
function bin2int(digs::Vector{Int})::Int
	nd = length(digs)
	return sum(digs[k] * 2^(k-1) for k ∈ 1:nd)
end

"""
	flip(n::Int, b::Int)

Use a `b`-bit representation of `n`, reverse its digits, and return the result.
"""
function flip(n::Int, b::Int)
	digs = int2bin(n, b)
	digs = reverse(digs)
	return bin2int(digs)
end

"""
	compare(a::Int, b::Int, wid::Int)::Bool

Return `true` is `a ⪯ b` is PJT's order on the natural numbers.
"""
function compare(a::Int, b::Int, wid::Int)::Bool
	if a==b
		return true
	end

	if a > b
		return false
	end

	aa = flip(a, wid)
	bb = flip(b, wid)

	return aa <= bb
end


"""
	longest_monotone(nums::Vector{T}) where T <: Number

Given a list of numbers, `nums`, return the longest increasing [nondecreasing]
and longest decreasing [nonincreasing] subsequences.
"""
function longest_monotone(nums::Vector{T}) where T <: Number
	n = length(nums)
	if n < 2
		return nums, nums
	end

	d = Dict{Int, Tuple{Int, Int}}()

	d[n] = (1, 1)

	for k ∈ (n-1):-1:1
		x = y = 1    # new pair for d[k]
		val = nums[k]
		for i ∈ (k+1):n
			if val ≥ nums[i]
				x = max(d[i][1]+1, x)
			end
			if val ≤ nums[i]
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

	return nums[up_ind], nums[dn_ind]
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

function height(b::Int)
	a = flip_list(b)
	m = longest_monotone(a)
	return m[2]
end


function width(b::Int)
	a = flip_list(b)
	m = longest_monotone(a)
	return m[1]
end

function height_display(b::Int)
	h = height(b)
	println("B_$b has height $(length(h))")

	for x in h
		bits = binary_string(x, b)
		println(bits, "\t", reverse(bits))
	end
end


function width_display(b::Int)
	w = width(b)
	println("B_$b has width $(length(w))")

	for x in w
		bits = binary_string(x, b)
		println(bits, "\t", reverse(bits))
	end
end


function overall(bmax::Int = 15)
	println("b\t2^b\tw\th")
	println("-"^30)

	for b ∈ 1:bmax
		bb = 2^b
		w = length(width(b))
		h = length(height(b))
		println("$b\t$bb\t$w\t$h")
	end
end

function conj_c(b::Int)
	if mod(b, 2)==0
		return 3 * 2^(b÷2 - 1)
	else
		x = (b+1) ÷ 2
		return 2^x
	end
end

end # end module PJT
