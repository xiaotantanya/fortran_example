# 1 "/home/tanwen/study/fortran_study/mpi_fortran/library/mpi.f90"
module mod_base_mpi
! use mod_base_double_precision
  implicit none
  include "mpif.h"
  integer ierr
  integer rank, process
contains
  subroutine mpi_setup(rank_out, process_out)
    implicit none
    integer, intent(out) :: rank_out, process_out
    logical init_flag

    call MPI_INITIALIZED(init_flag, ierr)
    if (.not. init_flag) call MPI_INIT(ierr)
    call MPI_Barrier(MPI_COMM_WORLD, ierr)
    call mpi_comm_rank(mpi_comm_world, rank, ierr)
    call mpi_comm_size(mpi_comm_world, process, ierr)
    rank_out = rank
    process_out = process
  end subroutine

  subroutine mpi_exit(out)
    implicit none
    integer, intent(in), optional :: out
    logical ::  initialized

    call MPI_Initialized(initialized, ierr)
    if (initialized) then
      call MPI_Barrier(MPI_COMM_WORLD, ierr)
      call MPI_Finalize(ierr)
    end if
    if (present(out)) then
! stop out ! the aci ifort version does not support non constant value yet
      select case (out)
      case (0)
        stop 0
      case (1)
        stop 1
      case default
        stop 1
      end select
    else
      stop 0
    end if
  end subroutine
end module
