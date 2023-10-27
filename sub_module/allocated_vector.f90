program allocate_temp

    implicit none
    real(dp),allocatable :: temp(:)
    ! allocate(temp(10), stat=err)
    ! if (err /= 0) print *, "temp(10): Allocation request denied"
    call foo(temp)
    if (allocated(temp(10))) deallocate(temp(10), stat=err)
    ! if (err /= 0) print *, "temp(10): Deallocation request denied"

end program allocate_temp


subroutine foo(lam)
    real(dp),allocatable,intent(out) :: lam(:)
    allocate(lam(5))
end subroutine foo
