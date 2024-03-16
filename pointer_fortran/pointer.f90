program point_example

    implicit none
    integer, pointer :: p1
    integer, target :: i1, i2
    nullify(p1)
    i1 = 1 
    i2 = 2
    p1=>i1
    write(*,*) p1
    i1 = 3
    write(*,*) p1

end program point_example
