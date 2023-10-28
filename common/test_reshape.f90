program test_reshape

    implicit none
    integer :: simple_dimension(60,128,128)
    integer :: muti_dimension(60,128,128)

    simple_dimension = 0
    muti_dimension = 1
    simple_dimension = simple_dimension - muti_dimension
    print *, sum(abs(simple_dimension))

end program test_reshape
