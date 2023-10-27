! program array

!     implicit none
!     ! 1D integer array
!     integer, dimension(10) :: array1

!     ! An equivalent array declaration
!     integer :: array2(10)

!     ! 2D real array
!     real, dimension(10,10) :: array3

!     ! Custom lower and upper index  bounds
!     real :: array4(0:9)
!     real :: array5(-5:5)

! end program array

program string

    implicit none
    
    character(len=4) :: first_name
    character(len=5) :: last_name
    character(10) :: full_name

    first_name = 'John'
    last_name = 'Smith'

    full_name = first_name//' '//last_name

    print *, full_name
    

end program string

