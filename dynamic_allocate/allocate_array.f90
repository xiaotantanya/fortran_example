program test

    implicit none
    integer,allocatable :: temp(:)
    real(kind=4),allocatable :: lam(:)
    ! allocate(temp(10))
    ! call show_arr(temp)
    ! call foo(lam)
    ! print *,lam
    ! print *, temp

    allocate(temp(10))
    if(allocated(temp)) deallocate(temp)
    allocate(temp(4))
    print *, temp
contains
    subroutine show_arr(arr)
        integer, allocatable, intent(out) :: arr(:)
        allocate(temp(10))
        if(allocated(arr)) then
            print *, arr
        end if
        
    end subroutine show_arr

    subroutine foo(lam)
        ! argument type, intent(inout) :: foo
        real(kind=4),allocatable,intent(out) :: lam(:)
        allocate(lam(5))
        
    end subroutine foo
end program test
