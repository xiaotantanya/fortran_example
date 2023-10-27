! program foo
!     implicit none
!     integer :: nbofchildrenperwoman, nbofchildren, nbofwomen
!     nbofwomen = 10
!     nbofchildrenperwoman = 2
!     nbofchildren = nbofwomen * nbofchildrenperwoman
!     print*, "number of children:", nbofchildrem
! end program

! subroutine foo()
! implicit none
!     integer :: c
!     c = 0
!     c = c+1
!     print*, c
! end subroutine

! program main
! implicit none
!     integer :: i

!     do i = 1, 5
!         call foo()
!     end do
! end program

program foo
implicit none
    integer, parameter :: dp = kind(0d0)
    real(kind=dp), parameter :: x = 9.3_dp
    print*, precision(x), x
end program