program mpi_initialized_example
    use mpi
    implicit none
    
    integer :: ierr
    logical :: is_initialized

    call mpi_init(ierr)
    call mpi_initialized(is_initialized,ierr)

    if(is_initialized .eqv. .true.) then
        print *, "mpi initialized"
    else
        print *, "mpi isn't initialized"
    end if

    call mpi_finalize(ierr)

end program mpi_initialized_example
