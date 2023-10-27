!five parameter type:integer,real,complex,character,logical
!declare way:<variable_type> :: <variable_name>
program variables

    implicit none
    integer :: amount
    real :: pi
    complex :: frequency
    character :: initial
    logical :: isOkay

    amount = 10
    pi = 3.1415927
    frequency = (1.0,-0.5)
    initial = 'A'
    isOkay = .false.

    print *, 'the value of amount(integer) is: ', amount
    print *, 'the value of pi(real) is: ', pi
    print *, 'the value of frequency(complex) is: ', frequency
    print *, 'the value of initial(character) is: ', initial
    print *, 'the value of isOkay(logical) is: ', isOkay
    

end program variables
