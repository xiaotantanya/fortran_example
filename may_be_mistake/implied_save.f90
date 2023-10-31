subroutine foo()
    ! argument type, intent(inout) :: foo
    integer :: c = 0
    c = c + 1
    print*, c
end subroutine foo

program main

    implicit none
    integer :: i

    do i = 1, 5
        call foo()
    end do
end program main
