subroutine sub(val)
    ! argument type, intent(inout) :: sub(var)
    integer, optional :: val
    integer :: aval

    if(present(val)) then
        aval = val
    else
        aval = -1
    end if

    write(*,*) 'aval is', aval

end subroutine sub

program test_func

    implicit none
    interface 
        subroutine sub(val)
            integer, optional :: val
        end subroutine sub
    end interface ! 
    integer :: val
    val = 1
    call sub(val)
    call sub()

end program test_func

! program main

!     implicit none
!     interface 
!         subroutine sub(val)
!             integer, optional :: val
!         end subroutine sub
!     end interface ! 
!     call sub(5)
!     call sub()

! end program main

! subroutine sub(val)
!     implicit none
!     integer, optional :: val
!     integer :: aval

!     if(present(val)) then
!         aval = val
!     else
!         aval = -1
!     end if

!     write(*,*) 'aval is ',aval
! end subroutine sub