module m_shapes
    implicit none
    private
    public t_square

    type :: t_square
    real :: side
    contains
        procedure :: area
    end type

contains
    ! real function area(self) result(res)
    !     class(t_square), intent(in) :: self
    !     res = self%side**2
    ! end function
    subroutine area(self,x)
        class(t_square), intent(in) :: self
        real, intent(out) :: x
        x = self%side**2
    end subroutine area

end module m_shapes


program mod_example
    use m_shapes
    implicit none
    ! type :: t_example
    !     integer, private :: i = 0
    !     integer, protected :: i

    !     real, allocatable, dimension(:) :: x
    !     real, allocatable, dimension :: x(:)
    ! end type
    type(t_square) :: sq
    real :: x, side

    side = 0.5
    sq%side = side

    ! x = sq%area()
    call sq%area(x)
    print *, x
end program mod_example
