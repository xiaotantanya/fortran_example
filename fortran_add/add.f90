module add_

    implicit none
    private
    public a,b,c,add_integer
        integer :: a
        integer :: b
        integer :: c
    contains
        subroutine add_integer(a,b,c)
            integer,intent(in) :: a
            integer,intent(in) :: b
            integer,intent(out) :: c
            c = a + b
        end subroutine add_integer

end module add_

program add_example
    use add_
    implicit none
    a = 2
    b = 3
    c = 3
    call add_integer(a,b,c)
    print *, c

end program add_example

