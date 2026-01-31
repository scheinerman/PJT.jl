# PJT

Code for Paul Tanenbaum's poset problem. Additional methods in the `tools` folder. 


## Definitions

Let `b` be a positive integer. 
Form the sequence of all `b`-bit binary words from `00...0` to `11...1`, and then flip each word; that is, replace each word by its bit reversal. Consider these words as binary numbers.

* A *chain* is a subsequence of this list where the terms are in increasing order. 
* An *antichain* is a subsequence of this list where the terms are in decreasing order. 

Let $c(b)$ be the length of a longest chain and $a(b)$ be the length of a longest antichain. 

## The Problem

Prove the following:

**Conjecture 1**. If $b$ is even, $c(b)=3\cdot 2^{b/2-1}$, and if $b$ is odd, $c(b)=2^{(b+1)/2}$.

**Conjecture 2**. $a(b) = c(b)-1$. 

## The Code

### `Word` type

This module defines the `Word` type that represents a `b`-bit binary word. Construct a word using `Word(b,v)` where `b` is the number of bits and `v` is an integer between $0$ and $2^b-1$. 
```
jjulia> using PJT

julia> Word(6,11)
001011
```

### Maximum chain and maximum antichain creation

#### Guaranteed constructors
The functions `max_chain` and `max_antichain` create are guaranteed maximum length chain and antichain, respectively, for a given number of bits:
```
julia> max_chain(4)
6-element Vector{Word}:
 0000
 0100
 0110
 1001
 1101
 1111

julia> max_antichain(4)
5-element Vector{Word}:
 1100
 1010
 0110
 0101
 0011
```

#### Other constructors
The function `recursive_chain` creates a chain using recursion. The lengths of these chains agree with Conjecture 1, given a provable lower bound to $c(b)$. 
```
julia> recursive_chain(5)
8-element Vector{Word}:
 00000
 00100
 01010
 01110
 10001
 10101
 11011
 11111
```

The function `palindromes` creates a list of all `b`-bit palindromes in ascending order. When the number of bits is odd, this gives a chain whose length agrees with Conjecture 1; indeed, the output is the same as `recursive_chain`. For even `b` it comes up short.
```
julia> palindromes(6)      # Maximum chain of 6-bit words has length 12, not 8
8-element Vector{Word}:
 000000
 001100
 010010
 011110
 100001
 101101
 110011
 111111
```

### Other functions

* For a word `w`, `value(w)` returns the integer represented by this word. For example, if `w` is the 7-bit word `0001101`, then `value(w)` returns `13`.
* For a word `w`, `flip(w)` returns the reversal of `w`. For example, if `w` is the 7-bit word `0001101`, then `flip(w)` returns `1011000`.
* `height(b)` returns the length of a maximum chain of `b`-bit words.
* `width(b)` returns the length of a maximum antichain of `b`-bit words. 
* `word_gen(b)` returns a generator all `b`-bit words in numerical order.
* `flip_word_gen(b)` returns a generator of all `b`-bit words after having been flipped.
* `longest_monotone(list)` returns a pair of sublists of `list`: a longest decreasing sublist and a longest increasing sublist. 
* `is_chain(list)` determines if `list` is a chain (ascending list of `Word`s).
* `is_antichain(list)` determines if `list` is an antichain (descending list of `Word`s).
* `~w` forms a bitwise complement of `x` (swap 0s and 1s).

### More other functions

* `conj_c(b)` returns the conjectured length of a maximum chain for `b`-bit words.
* `conj_a(b)` returns the conjectured length of a maximum antichain for `b`-bit words.


## Observations about antichains

### Middle elements

The function `middle(list)` gives the middle entry in an odd-length list. Why? The antichains are conjectured to have odd length (except $b=2$), so it's interesting to look at the middle element. 
```julia
julia> for b=3:10; anti = max_antichain(b); println(middle(anti)); end
010
0110
01010
011110
0101010
01111110
010101010
0111111110
```
It appears that when `b` is odd, the middle element is of the form `010101...010` and when `b` is even the middle element is of the form `0111...110`. 


### Symmetry
The antichains found by this code have a particularly nice symmetry. Given the antichain, then reversing the list and flipping its entries returns the original list. This suggests that the maximum antichains are closed under flipping. 
```
julia> anti = max_antichain(6)
11-element Vector{Word}:
 111000
 110100
 101100
 101010
 100110
 011110
 011001
 010101
 001101
 001011
 000111

julia> flip.(reverse(anti))
11-element Vector{Word}:
 111000
 110100
 101100
 101010
 100110
 011110
 011001
 010101
 001101
 001011
 000111

julia> ans == anti
true
```