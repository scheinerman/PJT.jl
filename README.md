# PJT

Code for Paul Tanenbaum's poset problem.


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
