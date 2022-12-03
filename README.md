# CSC 330 - Project 3
# COLLATZ CONJECTURE PROJECT

In this project we display the ten smallest positive integers (provided there are ten or more) with the longest Collatz sequence lengths in a given range. If we get
integers with the same sequence length we only keep the smallest integer.


## The program flow

The program starts by taking two integer arguments from the command line. These integers will be the start and end values for our range (inclusive). 

All non-integer arguments will be immediately rejected. Integers less than 1 (because the Collatz sequence length can only be determined for positive integers)  or 
same arguments (which cannot be evaluated into a valid range) will also be checked and rejected.  
More checks for the correct number of arguments could be implemented but it is assumed that the user will only test with valid numbers. The arguments will be swapped if necessary so that the iterations in the program start from the smaller integer and go upto the larger one (included).

Once the integers are valid we use a loop starting from the smaller to the larger integer. We determine the Collatz sequence length of the each number and add it
to a data structure. Any newer and bigger integer with the same sequence length that we encounter is not added. Once the data structure has 10 elements, it is sorted
in descending order of the sequence length. A newer integer is only added if its corresponding sequence length is larger than the smallest sequence length currently
present in the data structure.  

Once we are done going through all the integers in the specified range, the ten (or less) smallest integers are printed out along with their corresponding 
sequence lengths sorted by descending order of sequence length first and then by descending order of the integers themselves (as shown in the sample output 
provided by the instructor). Sorting was carried out based on the data structure and programming language used. 

### Data structures used

For Fortran, Julia, and Rust arrays/vectors of structs were used. The structs contained the two fields -- integer, and Collatz sequence length of the integer.

For Lisp two arrays were maintained in parallel, one held the integers and the other held their sequence lengths in the same corresponding index. 

A  map was used for Golang to store the integers and their sequence lengths as key-value pairs. The sequnece length was the key. This is feasible because
we never store two integers with the same sequence length, (since we only keep the smallest). 

All the data structures used were always maintained at size 10 (i.e., we never have more than 10 elements in them). Further elements are added after another 
element is removed. In other words, the integer with the lowest sequence length will be removed if a newer integer with a larger sequence length is found. 
This is the new element which is added to the tenth slot of our data structure. Whenever an element is replaced we resort the data structure before proceeding.
Maintaining a small data structure (with only 10 elements) makes sorting efficient.

### Recursion

Each folder holds the source code file for that respective language and also a subfolder called "recursed". In this subfolder we basically have the same 
program but the function to find the sequence length of an integer is now recursive. So, the only change is this one function.

## Compilation and execution instructions

The names of all source code files were "collatz" (for both the iterative and recursive programs) plus the appropriate file extension.

We are taking command line arguments. The format is: <br>

"`<filename>` `x` `y`" where x and y are integers such that x and y are greater than 0 and x is not equal y.


In the follwing instructions we will use x = 50 and y = 100 (as examples like the sample output provided) to run the programs.  

Listed in order in which they appear in the repo we have the following.


### Fortran
To compile:
```
gfortran collatz.f95
```
An executable called "a.out" is created.<br>
To run:
```
./a.out 50 100
```

### Go
To compile and execute:
```
go run collatz.go 50 100
```

### Julia 
We are running this as a script.
On the very top of our program we add the line:
```
#!/usr2/local/julia-1.8.2/bin/julia
```
We then make the file executable for the user by:
```
chmod u+x collatz.jl
```
To run:
```
./collatz.jl 50 100
```

### Lisp
We are running this as a script.
On the very top of our program we add the line:
```
#!/usr/bin/sbcl --script
```
We then make the file executable for the user by:
```
chmod u+x collatz.lisp
```
To run:
```
./collatz.lisp 50 100
```

### Rust
To compile:
```
rustc collatz.rs 
```
An executable with the name "collatz" is created.<br>
To run:
```
./collatz 50 100
```

## References:
For tutorial sources such as tutorialspoint, w3schools, youtube, geeks-for-geeks, etc. were used.
Some code snippets were used from rossettacode.org, particularly the function to determine if a number is happy.
Some code ideas were taken from stackoverflow, etc, and changed to fit the program.
Code used directly or indirectly from sources were commented with a "Reference:" header.
A lot of code from the Happy Number project was reused directly or with modifications.

