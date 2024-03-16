program test_call_array
    implicit none
    integer, allocatable, dimension(:,:) :: allocated_array
    integer, allocatable, dimension(:,:) :: not_allocated_array
    if(.not. allocated(allocated_array)) then
        allocate(allocated_array(3,4))
        allocated_array = 0
    end if
    not_allocated_array = allocated_array
    write(*,*) not_allocated_array
    write(*,*) size(not_allocated_array, 1)
end program test_call_array