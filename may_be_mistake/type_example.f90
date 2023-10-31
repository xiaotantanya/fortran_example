program test_type

    implicit none
    type :: People
        integer :: age = 1
        integer :: weight = 2
    end type 

    type(People) :: people1
    print*, people1%age
    print*, people1%weight
    people1%age = 18
    people1%weight = 50
end program test_type
