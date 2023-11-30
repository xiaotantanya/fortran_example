program main
    implicit none
    integer, allocatable,dimension(:,:,:) :: test_list
    if(.not. allocated(test_list)) then
        allocate(test_list(10,10,10))
    end if
    call process_list(test_list)
    print*, test_list
contains
    subroutine process_list(list)
        implicit none
        integer, allocatable, dimension(:,:,:),intent(inout) :: list
        integer :: i, j, k
        ! if(.not. allocated(list)) then
        !     allocate(list(10,10,10))
        ! end if
        do i = 1, 10
            do j = 1, 10
                do k = 1, 10
                    list(i, j, k) = i + j + k
                end do
            end do
        end do
    end subroutine process_list
end program main