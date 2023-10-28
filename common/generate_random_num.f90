module generate_random_number

    implicit none
    private
    public x_dim, y_dim, z_dim, random_number_vector, generate_number
    integer :: x_dim
    integer :: y_dim
    integer :: z_dim
    real, allocatable,dimension(:,:,:) :: random_number_vector
contains
    subroutine generate_number(x_dim,y_dim,z_dim,random_number_vector)
        ! argument type, intent(inout) :: generate_number
        integer, intent(in) :: x_dim, y_dim, z_dim
        real, allocatable, dimension(:,:,:) :: random_number_vector
        integer :: i, j, k
        allocate(random_number_vector(x_dim,y_dim,z_dim))
        do i = 1, x_dim
            do j = 1, y_dim
                do k = 1, z_dim
                    call random_number(random_number_vector(i,j,k))
                end do
            end do
        end do 
    end subroutine generate_number
end module generate_random_number

program test
    use generate_random_number
    implicit none
    x_dim = 2
    y_dim = 9
    z_dim = 5
    call generate_number(x_dim,y_dim,z_dim,random_number_vector)
    print *, random_number_vector
end program test


