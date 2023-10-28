program ftest1

    implicit none
    real x, y
    x = 4.0
    y = 3.0*square(x+1.0) + 50.5
    print *, x, y
contains
    function square(y)
        implicit none
        real ::  square, y
        square = y * y
    end function square
end program ftest1
