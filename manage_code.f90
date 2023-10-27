program call_sub

    implicit none
    real :: mat(10,20)
    real :: v(9)
    real :: vector_norm
    mat(:,:) = 0.0
    
    v(:) = 9
    print *, 'Vector norm = ', vector_norm(9,v)

    call print_matrix(10,20,mat)

end program call_sub

subroutine print_matrix(n,m,A)
    implicit none
    integer, intent(in) :: n
    integer, intent(in) :: m
    real, intent(in) :: A(n, m)

    integer :: i
    do i = 1, n
        print *, A(i,1:m)
    end do

end subroutine print_matrix

! L2 Norm of a vector
function vector_norm(n,vec) result(norm)
    implicit none
    integer, intent(in) :: n
    real, intent(in) :: vec(n)
    real :: norm
    
    norm = sqrt(sum(vec**2))
    
end function vector_norm
