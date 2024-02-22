program ParallelWriteArrayWithTime
    use mpi
  
    implicit none
  
    integer, parameter :: nx = 4
    integer, parameter :: ny = 3
    integer, parameter :: nz = 2
    integer, parameter :: nw = 5
  
    integer :: rank, ierr
    integer(kind=MPI_OFFSET_KIND) :: offset
    integer :: outFile
    integer :: num_procs
    real(kind=8), dimension(nx, ny, nz, nw) :: dataArray
    real(kind=8), dimension(nx, ny, nz, 1) :: localData
    real(kind=8), dimension(nx, ny, nz, 10) :: buffer
    real(kind=8) :: startTime, endTime
    integer :: w

  
    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, num_procs, ierr)
  
    ! 初始化数组
    dataArray = 0.0
  
    ! 计算每个进程写入的元素位置
    offset = rank * sizeof(dataArray(1,1,1,1))
  
    ! 打开文件
    call MPI_File_Open(MPI_COMM_WORLD, "output.dat", MPI_MODE_WRONLY, MPI_INFO_NULL, outFile, ierr)
  
    ! 初始化缓存
    buffer(:, :, :, rank) = dataArray(:, :, :, rank)
  
    ! 记录开始时间
    startTime = MPI_Wtime()
  
    ! 遍历数组
    do w = 1, nw
      localData(:, :, :, 1) = dataArray(:, :, :, w)
  
      ! 更新缓存
      buffer(:, :, :, rank) = localData(:, :, :, 1)
  
      ! 所有进程都在这里同步，确保缓存被完全更新
      call MPI_Barrier(MPI_COMM_WORLD, ierr)
  
      ! 仅有一个进程写入文件
      if (rank == 0) then
        ! 设置文件位置
        call MPI_File_Seek(outFile, offset, MPI_SEEK_SET, ierr)
  
        ! 并行写入缓存数据
        call MPI_File_Write(outFile, buffer, nx * ny * nz * num_procs, MPI_REAL8, MPI_STATUS_IGNORE, ierr)
      end if
  
      ! 所有进程都在这里同步，确保文件写入完成
      call MPI_Barrier(MPI_COMM_WORLD, ierr)
  
      ! 更新偏移量
      offset = offset + num_procs * sizeof(dataArray(1,1,1,1))
    end do
  
    ! 记录结束时间
    endTime = MPI_Wtime()
  
    ! 输出程序运行时间
    if (rank == 0) then
      print *, "Total time: ", endTime - startTime, " seconds."
    end if
  
    ! 关闭文件
    call MPI_File_Close(outFile, ierr)
  
    call MPI_Finalize(ierr)
  end program ParallelWriteArrayWithTime
  