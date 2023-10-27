program concurrent_do

    implicit none
    real, parameter :: pi = 3.1415926
    integer, parameter :: n = 1000
    real :: result_sin(n)
    integer :: i

    do concurrent (i = 1:n)
        result_sin(i) = sin(i * pi/4.)
    end do

    print *, result_sin

end program concurrent_do
