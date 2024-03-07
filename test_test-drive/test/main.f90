program tester
  use, intrinsic :: iso_fortran_env, only : error_unit
  use testdrive, only : run_testsuite, new_testsuite, testsuite_type, &
      & select_suite, run_selected, get_argument
  use test_suite1, only : collect_suite1
  use test_suite2, only : collect_suite2
  ! use mpi
  implicit none
  integer :: ierr, rank, size_t, i
  integer, parameter :: array_size = 10
  integer, dimension(array_size) :: sendbuf, recvbuf
  integer :: tag = 123
  integer :: stat, is
  type(testsuite_type), allocatable :: testsuites(:)
  character(len=*), parameter :: fmt = '("#", *(1x, a))'
  character(len=:), allocatable :: suite_name, test_name

  ! call MPI_Init(ierr)
  ! call MPI_Comm_size(MPI_COMM_WORLD, size_t, ierr)
  ! call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

  stat = 0

  testsuites = [ &
    new_testsuite("suite1", collect_suite1), &
    new_testsuite("suite2", collect_suite2) &
    ]
  ! The first command-line argument passed into main is the name of the suite, 
  ! while the second command-line argument is the name of the tests within the suite.
  ! for example, suite_name can be "mupro_output_3D_suite",
  ! test_name can be "valid" or "invalid"
  call get_argument(1, suite_name)
  call get_argument(2, test_name)

  if(allocated(suite_name)) then
    is = select_suite(testsuites, suite_name)
    if(is>0 .and. is<=size(testsuites)) then
      if(allocated(test_name)) then
        write(error_unit, fmt) "Suite:", testsuites(is)%name
        call run_selected(testsuites(is)%collect, test_name, error_unit, stat)
        if(stat<0) then
          error stop 1
        end if
      else
        write(error_unit, fmt) "Testing:", testsuites(is)%name
        call run_testsuite(testsuites(is)%collect,error_unit,stat)
      end if
    else
      write(error_unit, fmt) "Available testsuites"
      do is = 1, size(testsuites)
        write(error_unit, fmt) "-", testsuites(is)%name
      end do
      error stop 1
    end if
  else
    do is = 1, size(testsuites)
      write(error_unit, fmt) "Testing:", testsuites(is)%name
      call run_testsuite(testsuites(is)%collect, error_unit, stat)
    end do
  end if

  if (stat > 0) then
    write(error_unit, '(i0, 1x, a)') stat, "test(s) failed!"
    error stop 1
  end if

end program tester