using PJT
using Plots, SimpleDrawing

"""
    weight_sort(b::Int)

Compute the weights of all `b`-bit words and put words with the same 
length into the same slot in a dictionary that is returned. 
"""
function weight_sort(b::Int)
    d = Dict{Real, Set{Word}}()

    for x = 0:2^b-1
        v = Word(b,x)
        wt = weight(v)
        if !haskey(d, wt)
            d[wt] = Set{Word}()
        end
        push!(d[wt],v)
    end
    return d
end

"""
    weight_sort_dict(b::Int)

Give a report that shows for each possible word weight, the
number of words with that weight.
"""
function weight_sort_dict(b::Int)
    d = weight_sort(b)
    nd = Dict{Real, Real}()

    for wt in keys(d)
        nd[Float64(wt)] = length(d[wt]) 
    end

    @show height(b)
    max_count = maximum(values(nd))
    @show max_count

    tops = [k for k in keys(nd) if nd[k]==max_count]
    @show tops

    return nd
end

"""
    plot_weight_counts(b::Int)

Give a histogram of word weights for `b`-bit words.
"""
function plot_weight_counts(b::Int)
    d = weight_sort_dict(b)
    x = sort(collect(keys(d)))
    y = [d[j] for j in x]
    bar(x,y, legend=false, color=:lightgray)
    title!("Weight distribution for $b-bit words")
    xlabel!("Weight")
    ylabel!("Count")

end