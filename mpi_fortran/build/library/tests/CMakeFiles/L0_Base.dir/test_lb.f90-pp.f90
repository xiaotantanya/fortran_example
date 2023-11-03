# 1 "/home/tanwen/study/fortran_study/mpi_fortran/library/tests/test_lb.f90"
program test_lb

    implicit none
    include "mpif.h"
    integer sublength, types(3), disp(3), blockLengths(3)
    integer entryType
    integer ierr
    integer process, rank
    integer entrylength
    call mpi_init(ierr)
    call mpi_comm_rank(mpi_comm_world, rank, ierr)
    call mpi_comm_size(mpi_comm_world, process, ierr)
    entrylength = 36
    types(1) = MPI_LB
    types(2) = MPI_Character
    types(3) = MPI_UB

    blockLengths(1) = 1
    blockLengths(2) = entrylength
    blockLengths(3) = 1

    disp(1) = 0
    disp(2) = 0
    disp(3) = entrylength

    call MPI_type_struct(3, blockLengths, disp, types, entryType, ierr)
    call MPI_Type_Commit(entryType, ierr)
    print *, "test"
    call mpi_finalize(ierr)
end program test_lb
