
function evan_conjecture(b::Int)
    for v in word_gen(b)
        for w in word_gen(b)
            if is_covered_by(v,w) && !has_type(v,w)
                println("$v is covered by $w, but not type")
            end

            if v<w && !is_covered_by(v,w) && has_type(v,w)
                print("$v is not covered by $w, but they have a typed transformation\t")
                show_type(v,w)
            end

        end
    end
end



function max_chain_transforms(b::Int)
    cc = max_chain(b)
    
    show_transformations(cc)
end



function show_transformations(cc::Vector{Word})
   ncc = length(cc)

    for i=1:ncc-1
        v = cc[i]
        w = cc[i+1]
        show_type(v,w)
    end
end