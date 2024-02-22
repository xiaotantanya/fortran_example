program mpi_vtk_example
    use mpi
    implicit none
  
    integer, parameter :: num_procs = 4
    integer :: my_rank, ierr, file_handle
  
    integer, parameter :: nx = 10, ny = 10, nz = 10
    real(kind=8), dimension(nx, ny, nz) :: data
  
    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, my_rank, ierr)
  
    ! Generate some example data
    data = generate_data(my_rank, nx, ny, nz)
  
    ! All processes open the file collectively
    call MPI_FILE_OPEN(MPI_COMM_WORLD, "output.vtk", MPI_MODE_WRONLY + MPI_MODE_CREATE, MPI_INFO_NULL, file_handle, ierr)
  
    ! All processes write their data using collective I/O
    call write_vtk_data(file_handle, data, nx, ny, nz)
  
    ! All processes close the file
    call MPI_FILE_CLOSE(file_handle, ierr)
  
    call MPI_FINALIZE(ierr)
  
  contains
  
    subroutine write_vtk_data(file_handle, data, nx, ny, nz)
      integer, intent(in) :: file_handle, nx, ny, nz
      real(kind=8), dimension(nx, ny, nz), intent(in) :: data
  
      integer :: i, j, k
      real(kind=4) :: scalar_value
  
      ! Set the file view
      call MPI_FILE_SET_VIEW(file_handle, 0, MPI_REAL8, MPI_REAL8, "native", MPI_INFO_NULL, ierr)
  
      ! Set the file position
      call MPI_FILE_SET_SIZE(file_handle, 0, ierr)
  
      ! Each process writes its data to the file using collective I/O
      do k = 1, nz
        do j = 1, ny
          do i = 1, nx
            scalar_value = data(i, j, k)
            call MPI_FILE_WRITE(file_handle, scalar_value, 1, MPI_REAL8, MPI_STATUS_IGNORE, ierr)
          end do
        end do
      end do
    end subroutine write_vtk_data
  
    function generate_data(rank, nx, ny, nz) result(data)
      integer, intent(in) :: rank, nx, ny, nz
      real(kind=8), dimension(nx, ny, nz) :: data
  
      integer :: i, j, k
  
      ! Generate some example data (a simple scalar field)
      do k = 1, nz
        do j = 1, ny
          do i = 1, nx
            data(i, j, k) = real(i + j + k + rank, kind=8)
          end do
        end do
      end do
    end function generate_data
  
  end program mpi_vtk_example
  