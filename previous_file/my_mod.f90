module my_mod

    implicit none
    
    private
    public public_var, print_matrix

    real, parameter :: public_var = 2
    integer :: private_var

contains
    subroutine print_matrix(A)
        real, intent(in) :: A(:,:)

        integer :: i

        do i = 1, size(A,1)
            print *, A(i,:)
        end do

    end subroutine print_matrix

end module my_mod



