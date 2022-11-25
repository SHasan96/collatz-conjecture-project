!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!           COLLATZ CONJECTURE PROJECT             !!!!!!!!!!!!!
!                                                                    !  
! A program to find collatz sequence length of ten smallest integers !
! in a given range and prints them in descending order of their      !
! respective sequence lengths and the integers themselves            !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

program collatz_conjecture 
  implicit none
  character(len=10), dimension(2)  :: args !< Array to store two cmd arguments
  ! A structure to contain a number with its collatz sequence length
  type Numpair
    integer (kind = 8) :: num      !< The integer
    integer (kind = 8) :: seq_len  !< Collatz sequence length of num
  end type Numpair
  
  integer (kind = 8)  :: a1, a2
  integer             :: stat        !< A variable for input checking
  
  ! Read the two command line arguments 
  call get_command_argument(1, args(1))
  call get_command_argument(2, args(2))
  ! Convert them into the required data types, and check errors while doing so
  read(args(1),*,iostat=stat)a1
  if (stat /= 0) then
      write (*, '(a, /, a )' ) "Invalid range and/or arguments!", "Exiting..."
      stop
  end if
  read(args(2),*, iostat=stat)a2
  if (stat /= 0) then
      write (*, '(a, /, a )' ) "Invalid range and/or arguments!", "Exiting..."
      stop
  end if
  ! If inputs are ok, call a subroutine for further checking
  call check_args(a1,a2) 
  call find_sequence_lengths_in_range(a1, a2)
 
contains

!> Funtion that checks if a number is even.
!@param num - an integer
function is_even(num) result(even)
  integer (kind = 8), intent(in) :: num
  logical :: even
  
  if (mod(num,2) == 0) then
    even = .true.
  else
    even = .false.
  end if
end function is_even

!> Funtion that finds the collatz sequence length of an integer
!@param num - an integer
function find_sequence_length(num) result(steps)
  integer (kind = 8), intent(in) :: num
  integer (kind = 8)             :: steps, m 
  
  steps = 0
  m = num
  do while (m /= 1)
    steps = steps + 1
    if (is_even(m)) then
      m = m / 2
    else
      m = 3*m + 1
    end if
  end do
end function find_sequence_length

!> Subroutine that finds sequence lengths of numbers in a given range (inclusive)
!@param n1 - integer at start of range
!@param n2 - integer at end of range
subroutine find_sequence_lengths_in_range(n1, n2)
  integer (kind = 8), intent(in) :: n1, n2
  integer (kind = 8)             :: num, i
  type(Numpair)                  :: apair
  type(Numpair), dimension(10)   :: numpairs !< An array of structures
  
  ! Initializes the array with all struct fields as -1
  ! This is a way of marking empty indices so that it is not filled with garbage
  ! values.
  do num = 1, 10
    apair%num = -1
    apair%seq_len = -1
    numpairs(num) = apair
  end do

  i = 0
  do num = n1, n2
    apair%num = num
    apair%seq_len = find_sequence_length(num)  
    i = i + 1
    call add_to_array(numpairs, apair, i)       
  end do
 
  print*, "Sorted based on sequence length"
  call sort(numpairs, .true.)
  call print_numbers_with_length(numpairs) 
  print*, "Sorted based on integer size"
  call sort(numpairs, .false.)
  call print_numbers_with_length(numpairs)
end subroutine find_sequence_lengths_in_range

!> Subroutine that prints the numbers with corresponding sequence lengths
!@param numpairs - the array of struct to be printed
!@param i - number of integers evaluated
subroutine print_numbers_with_length(numpairs)
 type(Numpair), dimension(10), intent(in)  :: numpairs 
 integer (kind =8)                         :: x

 do x = 1, 10 
   if (numpairs(x)%num == -1) then
     exit
   end if
   print*, numpairs(x)
 end do
end subroutine print_numbers_with_length

!> Subroutine that adds a Numpair struct into an array based
!  on some specific conditions
!@param arr - the array where an element is to added (or not)
!@param elem - element to be added in the array
!@param i - index of array 
subroutine add_to_array(arr, elem, i)
  type(Numpair), dimension(10), intent(inout) :: arr
  type(Numpair), intent(in)                   :: elem
  integer (kind = 8), intent(inout)           :: i                    
  integer (kind = 8)                          :: x
  logical                                     :: same_length_found 
  
  same_length_found = .false.
  ! Adding first element
  if (i == 1) then 
    arr(i) = elem
  ! Adding to partially filled array
  else if (i <= 10) then
    do x = 1, i 
      if (elem%seq_len == arr(x)%seq_len) then
        same_length_found = .true.
        i = i - 1 ! Since current index will remain empty
        exit
      end if
    end do

    if (.not. same_length_found) then
      arr(i) = elem
    end if

    if (i == 10) then
      call sort(arr, .true.)
    end if
  ! When array is full (i > 10)
  else 
    do x = 1, 10
      if (elem%seq_len == arr(x)%seq_len) then
        same_length_found = .true.
        exit
      end if
    end do

    if ((.not. same_length_found) .and. (elem%seq_len > arr(10)%seq_len)) then
      arr(10) = elem
      call sort(arr, .true.)
    end if
  end if     
end subroutine add_to_array

!> Subroutine that checks the two arguments.
!! Only valid arguments will allow continuation of the program.
!! @param n1 - first integer argument
!! @param n2 - second integer argument
subroutine check_args(n1, n2)
  integer (kind = 8), intent(inout) :: n1, n2
  integer (kind = 8)                :: temp  
  ! Check if arguments are valid.
  ! Reject same arguments because range becomes pointless
  ! Reject non-positive integers 
  if (n1 == n2 .or. n1 < 1 .or. n2 < 1) then
    write (*, '(a, /, a )' ) "Invalid range and/or arguments!", "Exiting..."
    stop
  end if
  ! Swap arguments if needed.
  if (n1 > n2) then
    temp = n1
    n1 = n2
    n2 = temp
  end if
end subroutine check_args
    
!> Function that returns the location of the maximum in the section
!! between start and finish.
!! @param arr - the array
!! @param start - starting index of the section
!! @param finish - ending index of the section
!! @param by_length - a boolean indicating if the sorting criterion is base on 
!!                    sequence length or not
!! @note This is needed for sorting.
!! Reference: "https://pages.mtu.edu/~shene/COURSES/cs201/NOTES/chap08/sorting.f90"
function  find_maximum(arr, start, finish, by_length) result(maxpos)
  type(Numpair), dimension(10), intent(in) :: arr
  integer, intent(in)                      :: start, finish
  logical, intent(in)                      :: by_length
  integer                                  :: location, i, maxpos
  double precision                         :: maximum

  if (by_length) then
    maximum  = arr(start)%seq_len
  else 
    maximum = arr(start)%num
  end if       
  location = start                        
  do i = start+1, finish
    ! For sorting by sequence length
    if (by_length) then               
      if (arr(i)%seq_len > maximum) then    
        maximum  = arr(i)%seq_len          
        location = i                        
      end if
    ! For sorting by integer size
    else
      if (arr(i)%num > maximum) then
        maximum = arr(i)%num
        location = i
      end if
    end if
  end do
  maxpos = location                      
end function  find_maximum

!> Subroutine that swaps the values of its two arguments.
!! The elements that are to be swapped are of the Numpair structure.
!! @param a - first element
!! @param b - second element
!! @note This is needed for sorting.
subroutine  swap(a, b)
  type(Numpair), intent(inout) :: a, b
  type(Numpair)                :: temp

  temp = a
  a = b
  b = temp
end subroutine  swap

!> Subroutine that receives an array and sorts it in descending order.
!! @param arr - an array of Numpair structures to be sorted
!! @param by_length - a boolean indicating if the sorting criterion is base on
!!                    sequence length or not
!! @note - size of array is fixed 
!! @note The sorting method used is selection sort.
!! Reference: "https://pages.mtu.edu/~shene/COURSES/cs201/NOTES/chap08/sorting.f90"
subroutine  sort(arr, by_length)
  type(Numpair), dimension(10), intent(inout) :: arr
  integer, parameter                          :: s = 10  !> Array size is fixed
  logical, intent(in)                         :: by_length
  integer                                     :: i, location
  
  do i = 1, s-1                                           ! Exclude the last
    location = find_maximum(arr, i, s, by_length)         ! Find maximum from this to last
    call swap(arr(i), arr(location))                      ! Swap this and the maximum
  end do
end subroutine sort

end program collatz_conjecture
