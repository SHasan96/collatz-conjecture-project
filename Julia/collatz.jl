#!/usr2/local/julia-1.8.2/bin/julia
#######################################################################
#  A program to find collatz sequence length of ten smallest integers #
#  in a given range and prints them in descending order of their      #
#  respective sequence lengths and the integers themselves            #
#######################################################################

# A global struct
struct Numpair
   num::Int64     # An integer
   seqlen::Int64  # Collatz sequence length of the integer
end
   
"""
Verifies the arguments and quits if they are invalid.
Passes them on to the next function if they are valid.
# Arguments
- 'n1::Integer`: first argument
- `n2::Integer`:  second argument
"""
function check_args_and_continue(n1, n2)
   # Reject same arguments and those less than 1
   if n1 == n2 ||  n1 < 1 ||  n2 < 1 
      println("Invalid range and/or arguments!\nExiting...")
      return
   end
   # Swap arguments if needed before passing them on
   if n1 > n2 
      tmp = n1
      n1 = n2
      n2 = tmp
   end
   find_sequence_lengths_in_range(n1, n2)
end

"""
Finds the length of the collatz sequence
# Arguments
- `num::Integer`: the number for which the collatz sequence length
                  is calculated
# Returns 
- `steps::Integer`: the length of sequence
"""
function find_sequence_length(num)
   m = num
   steps::Int64 = 0
   while m != 1
      steps += 1
      if m%2 == 0
         m = m / 2
      else
         m = 3*m + 1
      end
   end
   return steps
end       
   
"""
Finds sequence lengths of numbers in a given range (inclusive)
# Arguments
- `n1::Integer`: start of range
- `n2::Integer`: end of range
"""
function find_sequence_lengths_in_range(n1, n2)  
   numpairs = Array{Numpair}(undef, 0) # Declare an empty vector of Numpair structs       
   for num = n1:n2 
      apair = Numpair(num, find_sequence_length(num))
      add_to_array(numpairs, apair)       
   end 
   println("Sorted based on sequence length") 
   sort!(numpairs, by = x -> x.seqlen, rev=true)     
   print_numbers_with_lengths(numpairs)
   println("Sorted based on integer size")
   sort!(numpairs, by = x -> x.num, rev=true)
   print_numbers_with_lengths(numpairs)
   return nothing
end
         
"""
Adds a Numpair struct into an array based on some specific conditions.
# Arguments
- `arr::Array{Numpair}`: the array where an element is to added (or not)
- `elem::Numpair`:  element to be added in the array
# Note
  Vector in Julia are just 1-D arrays, arrays in Julia are always dynamic.
"""
function add_to_array(arr, elem)
   samelen = false
   # Adding first element
   if length(arr) == 0
      push!(arr, elem)
      # Adding until array has 10 elements
   elseif length(arr) < 10 
      for x in arr 
         if elem.seqlen == x.seqlen
            samelen = true
            break
         end 
      end
      if !samelen 
         push!(arr, elem)
      end 
      if length(arr) == 10
         sort!(arr, by = x -> x.seqlen, rev=true)
      end
   # When array is filled with 10 elements
   else 
      for x in arr
         if elem.seqlen == x.seqlen 
            samelen = true
            break
         end
      end
      if !samelen && elem.seqlen > arr[10].seqlen
         arr[10] = elem
         sort!(arr, by = x -> x.seqlen, rev=true)
      end        
   end
   return nothing
end
   
"""
Print the array elements according to the requirements
# Arguments
- `arr::Array{Numpair}`: the array to be printed
"""
function print_numbers_with_lengths(arr)
   for x in arr
      println(lpad(x.num,21," "), lpad(x.seqlen,21," "))
   end
   return nothing
end
   
### Main starts here

try   
   # Read command line arguments
   a1 = parse(Int64, ARGS[1])
   a2 = parse(Int64, ARGS[2])
   check_args_and_continue(a1, a2)
catch e
   println("Invalid range and/or arguments!\nExiting...")
end

exit()
