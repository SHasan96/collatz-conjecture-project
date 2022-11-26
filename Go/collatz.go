package main

import (
  "fmt"
  "sort"
  "os"
  "strconv"
  "strings"
  "errors"
)

func main() {
  getArgs(); // This is the function that starts and runs the whole thing.
}


// Gets user inputs for the two arguments (from the command line) and proceed.
// Rejects any non-integer input immediately.
// Proceeds to the next function if arguments are integers.
func getArgs() {
  args := os.Args
  err := errors.New("Invalid range and/or arguments!\nExiting...")
  s1 := args[1]
  s1 = strings.TrimSuffix(s1, "\n")
  a1, err1 := strconv.Atoi(s1)
  if err1 != nil {
    fmt.Println(err)
    return
  }
  s2 := args[2]
  s2 = strings.TrimSuffix(s2, "\n")
  a2, err2 := strconv.Atoi(s2)
  if err2 != nil {
    fmt.Println(err)
    return
  }
  n1 := int64(a1)
  n2 := int64(a2)
  checkArgs(n1, n2)
} 

// Finds and returns the collatz sequence length of an integer.
func getSequenceLength(num int64) int64 {
  var steps int64 = 0
  m := num
  for m != 1 {
    steps += 1
      if m%2 == 0 {
        m /= 2
      } else {
        m = 3*m + 1
      }      
  }
  return steps
}

// Checks arguments before passing them onto the next function.
func checkArgs(n1 int64, n2 int64) {
  err := errors.New("Invalid range and/or arguments!\nExiting...")
  if n2==n1 || n2<1 || n1<1 {
    fmt.Println(err)
    return
  }
  if n2<n1 {
    tmp := n1
    n1 = n2
    n2 = tmp
  }
  findSequenceLengthsInRange(n1, n2)
}

// Finds and store atmost 10 integers and their corresponding collatz sequence lengths
// within a given range (inclusive).
func findSequenceLengthsInRange(n1 int64, n2 int64) {
  // Using a map to store integers with their sequence lengths as key-value pairs
  // The sequence lengths will be used as the key for easier comparisons.
  // This is fine because we are rejecting larger integers with the same sequence length.
  numMap := make(map[int64]int64)
  for num := n1; num <= n2; num++ {
    // Adding the first entry
    if len(numMap) == 0 {                              
      numMap[getSequenceLength(num)] = num
    // Adding another entry if the same sequence length does not exist
    } else if len(numMap) < 10 {
      if _, ok := numMap[getSequenceLength(num)]; !ok {
        numMap[getSequenceLength(num)] = num 
      }
    // Map is maintained at a maximum size of 10
    // Updating entries with ones having greater but different sequence lengths
    } else {

      var seqlens []int64
      for k := range numMap {
        seqlens = append(seqlens, k)
      }
      sort.Slice(seqlens, func(i, j int) bool {
        return seqlens[i] > seqlens[j]
      })

      if _, ok := numMap[getSequenceLength(num)]; !ok {
        if getSequenceLength(num) > seqlens[9] {
	  delete(numMap, seqlens[9])
	  numMap[getSequenceLength(num)] = num 
        }
      }
    }
  }
  printNumbersWithLengths(numMap)
}

// Prints the stored integers along with their collatz sequence lengths in specific orders
func printNumbersWithLengths(numpairs map[int64]int64) {
  // Recall that the keys were the sequence lengths.
  // The integers were the values.
  var keys []int64
  for k := range numpairs {
    keys = append(keys, k)
  }

  sort.Slice(keys, func(i, j int) bool {
    return keys[i] > keys[j]
  })
  fmt.Println("Sorted based on sequence length")
  for _, elem := range keys {
    fmt.Printf("%21d%21d\n", numpairs[elem], elem)
  }
  
  sort.SliceStable(keys, func(i, j int) bool {
    return numpairs[keys[i]] > numpairs[keys[j]]
  }) 
  fmt.Println("Sorted based on integer size")
  for _, elem := range keys {
    fmt.Printf("%21d%21d\n", numpairs[elem], elem)
  }  
}
