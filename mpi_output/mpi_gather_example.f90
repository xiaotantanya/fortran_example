program MPI_Gather_Example
    use mpi
    implicit none
    
    integer, parameter :: N = 5
    integer, parameter :: Num_Procs = 4

    integer :: my_rank, ierr
    real(8), dimension(N) :: local_array
    real(8), dimension(N*Num_Procs) :: gathered_array

    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, my_rank, ierr)

    local_array = my_rank + 1.0
    call MPI_GATHER(local_array, N, MPI_DOUBLE_PRECISION, gathered_array, &
                    N, MPI_DOUBLE_PRECISION, 0, MPI_COMM_WORLD, ierr)
    if(my_rank .eq. 1) then
        print*, "array is: "
        print*, gathered_array
    end if

    call MPI_FINALIZE(ierr)

end program MPI_Gather_Example