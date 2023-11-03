! program mpi_struct_example
!     use mpi
!     implicit none
    
!     integer, parameter :: n = 3
!     integer :: ierr, rank
!     integer(kind=mpi_address_kind) :: displacements(n)
!     integer :: blocklengths(n)
!     integer(kind=MPI_Datatype) :: types(n)
!     integer(kind=MPI_Datatype) :: mystruct_type
!     type :: MyStruct
!         integer :: value1
!         double precision :: value2
!     end type MyStruct

!     type(MyStruct) :: send_data
!     type(MyStruct) :: recv_data

!     call mpi_init(ierr)
!     call mpi_comm_rank(mpi_comm_world,rank,ierr)

!     blocklengths = [1, 1, 1]
!     types = [MPI_INTEGER, MPI_DOUBLE_PRECISION, MPI_UB]
!     call mpi_get_address(send_data,displacements(1),ierr)
!     call mpi_get_address(send_data%value2,displacements(2), ierr)
!     call mpi_get_address(send_data, displacements(3), ierr)
!     displacements = displacements - displacements(1)

!     call mpi_type_struct(n,blocklengths,displacements,types,mystruct_type,ierr)
!     call mpi_type_commit(mystruct_type, ierr)

!     if (rank == 0) then
!         send_data%value1 = 42
!         send_data%value2 = 3.14
!     end if

!     call mpi_bcast(recv_data, 1, mystruct_type, 0, mpi_comm_world, ierr)

!     if(rank == 1) then
!         print *, 'Received data: value1=', recv_data%value1, ',value2=', recv_data%value2
!     end if

!     call mpi_type_free(mystruct_type,ierr)
!     call mpi_finalize(ierr)

! end program mpi_struct_example

! program mpi_datatype_example
!     use mpi
!     implicit none
    
!     integer :: ierr, rank, value
!     integer :: data_type ! 正确声明 MPI 数据类型

!     call mpi_init(ierr)
!     call mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)

!     ! 在这个示例中，我们使用 MPI_DOUBLE_PRECISION 作为 MPI 数据类型
!     data_type = MPI_DOUBLE_PRECISION

!     if (rank == 0) then
!         ! 发送一个双精度浮点数
!         value = 42
!         call mpi_send(value, 1, data_type, 1, 0, MPI_COMM_WORLD, ierr)
!     else if (rank == 1) then
!         ! 接收双精度浮点数
!         call mpi_recv(value, 1, data_type, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
!         print *, '进程 1 收到数据:', value
!     end if

!     call mpi_finalize(ierr)
! end program mpi_datatype_example
