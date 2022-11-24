///////////////////////////////////////////////////////////////////////
/////////          COLLATZ CONJECTURE PROJECT             /////////////
//                                                                    /  
// A program to find collatz sequence length of ten smallest integers /
// in a given range and prints them in descending order of their      /
// respective sequence lengths and the integers themselves            /
///////////////////////////////////////////////////////////////////////
use std::env;
use std::process::exit;
// A global struct
    #[derive(Copy, Clone)]
    struct Numpair {
       num: i64,     // An integer
       seqlen: i64   // Collatz sequence length of the integer
     }
 
fn main() {
    // Get arguments from command line
    let args: Vec<_> = env::args().collect();
    let mut a1: i64 = args[1].to_string().parse::<i64>().unwrap_or(0);
    let mut a2: i64 = args[2].to_string().parse::<i64>().unwrap_or(0);  
    // Initialize an array of structs (size 10) with all structs with their fields set to zero 
    let mut numpairs: [Numpair; 10] = [Numpair{num: 0, seqlen: 0}; 10];
    
    check_args(&mut a1, &mut a2);
    find_sequence_lengths_in_range(a1, a2, &mut numpairs);
}  

/*
  Verifies the arguments and quits if they are invalid
  @param n1 - first integer argument
  @param n2 - second integer argument
*/
fn check_args(n1: &mut i64, n2: &mut i64) {
   // Reject same arguments and those less than 1
   if *n1 == *n2 ||  *n1 < 1 || *n2 < 1 {
      println!("Invalid range and/or arguments!\nExiting...");
      exit(1);
   }
   // Swap arguments if needed.
   if *n1 > *n2 {
      let tmp = *n1;
      *n1 = *n2;
      *n2 = tmp;
   }
}

/*
  Finds the length of the collatz sequence
  @param num - an integer
  @return steps - the length of sequence
*/
fn find_sequence_length(num :i64) -> i64 {
   let (mut steps, mut m): (i64, i64) = (0, num);
   
   while m != 1 {
      steps += 1;
      if m%2 == 0 {
         m = m / 2;
      } else {
         m = 3*m + 1;
      }
   }
   return steps; 
}

/*
  Finds sequence lengths of numbers in a given range (inclusive)
  @param n1 - integer at start of range
  @param n2 - integer at end of range
  @paran arr - a mutable reference to our array 
  @note This reference to the array will be passed onto the another
  function but it needed to be passed here first to remain in scope
*/
fn find_sequence_lengths_in_range(n1: i64, n2: i64, arr: &mut[Numpair]) {
   let mut apair: Numpair = Numpair{num: 0, seqlen: 0};
   let mut i = 0; // For keeping count of iterations
     
   for n in n1..n2+1 {
      apair.num = n; 
      apair.seqlen = find_sequence_length(n);
      i += 1;
      add_to_array(arr, apair, &mut i);       
   }
   
   println!("Sorted based on sequence length");
   arr.sort_by_key(|x| x.seqlen);
   arr.reverse();
   print_numbers_with_length(arr);
   println!("Sorted based on integer size"); 
   arr.sort_by_key(|x| x.num);
   arr.reverse();
   print_numbers_with_length(arr);    
}

/*
  Adds a Numpair struct into an array based on some specific conditions.
  @param arr - the array where an element is to added (or not)
  @param elem - element to be added in the array
  @param i - index of array 
*/
fn add_to_array(arr: &mut[Numpair], elem: Numpair, i: &mut i64) {
   let mut same_len = false;
   if *i == 1 { // Adding first element
      arr[0] = elem;
   } else if *i <= 10 { // Adding to partially filled array
      for x in 0..*i {  // Recall that the ending value is exclusive
         if elem.seqlen == arr[x as usize].seqlen {
            same_len = true;
            *i -= 1; // Since current index will remain empty
            break; 
         }        
      }
      if !same_len {
         arr[*i as usize - 1] = elem;
      }
      if *i == 10 {
         arr.sort_by_key(|x| x.seqlen);
         arr.reverse();
      } 
   } else { // When array is full
      for x in 0..10 {  // Recall that the ending value is exclusive
         if elem.seqlen == arr[x as usize].seqlen {
            same_len = true;
            break;
         }
      }
      if !same_len && elem.seqlen > arr[9].seqlen {
         arr[9] = elem; 
         arr.sort_by_key(|x| x.seqlen);
         arr.reverse();
      }
   }    
}

/*
  Print the array elements according to the requirements
  @param arr - the array to be printed
*/
fn print_numbers_with_length(arr: &mut[Numpair]) {
   for i in 0..10 {
      if arr[i as usize].num == 0 {
         break;
      }
      println!("{0:>21} {1:>20}", arr[i as usize].num, arr[i as usize].seqlen);
   }
} 
