! subroutine test()
!     implicit none
!     real, allocatable, dimension(:) :: array
!     allocate(array(100))

! end subroutine test

! program main

!     implicit none
!     call test()

! end program main

! program test

!     implicit none
!     integer, pointer :: p1
!     ! real, pointer, dimension(:) :: pra
!     ! real, pointer, dimension(:) :: pra2

!     ! allocate(p1)
!     integer, target :: t1
!     p1=>t1
!     t1 = 1
    
!     print *, p1

!     ! deallocate(p1)

! end program test

program pointer_example

    implicit none
    integer, target :: a
    integer, pointer :: p

    a = 10
    p => a

    print *, "Value of a: ", a
    print *, "Value of p: ", p

    a = 20

    print *, "Value of a after modification: ", a
    print *, "Value of p after modification: ", p

end program pointer_example
