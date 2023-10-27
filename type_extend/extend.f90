module people_m

    implicit none
    private
    integer, parameter :: max_name_len = 32
    type, public :: People
        character(len=max_name_len), private :: name
    contains
        procedure :: set_name
        procedure :: greet
    end type People

    type, public, extends(People) :: Student
        real, private :: GPA
    end type Student
contains
    subroutine set_name(this,name)
        class(People),intent(inout) :: this
        character(len=*), intent(in) :: name
        this%name = name
    end subroutine set_name

    subroutine greet(this)
        class(People), intent(in) :: this
        print '(A,".")',"Hello, my name is "//trim(this%name)
    end subroutine greet
end module people_m

program test
    use people_m
    implicit none
    type(Student) :: alice
    call alice%set_name("Alice")
    call alice%greet()
end program test
