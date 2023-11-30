program mpi_array_write_example
  use mpi
  implicit none

  integer, parameter :: nprocs = 4
  integer :: rank, ierr
  integer :: filehandle
  character(80) :: filename = 'data.txt'
  integer, parameter :: nrows = 1000  ! 行数
  integer, parameter :: ncols = 1000  ! 列数
  real(8), dimension(nrows, ncols) :: large_array
  integer :: i, j
  integer, dimension(2) :: array_size
  integer, dimension(2) :: start, count
  character(80) :: line
  integer :: status

  ! 初始化大数组（示例中使用了随机数据）
  do i = 1, nrows
    do j = 1, ncols
      large_array(i, j) = dble(i + j)
    end do
  end do
  
  call MPI_Init(ierr)
  call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
  
  ! 打开文件
  call MPI_File_open(MPI_COMM_WORLD, filename, MPI_MODE_WRONLY + MPI_MODE_CREATE, &
                     MPI_INFO_NULL, filehandle, ierr)
  
  ! 配置要写入的数组部分
  array_size = [nrows, ncols]
  start = [1, 1]
  count = [nrows, ncols]

  ! 写入数据（以文本格式）
  do i = 1, nrows
    line = ''
    do j = 1, ncols
      write(line, '(F10.4, A)') large_array(i, j), ' '
    end do
    ! 移除末尾多余的空格
    line = trim(line)
    ! 写入一行
    call MPI_File_write(filehandle, trim(line), len_trim(line), MPI_CHARACTER, status, ierr)
  end do

  ! 关闭文件
  call MPI_File_close(filehandle, ierr)

  call MPI_Finalize(ierr)
end program mpi_array_write_example
