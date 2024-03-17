subroutine my_fortran_function(s)
    implicit none
    type :: my_type
       integer :: nrows
       integer :: ncols
       real, allocatable :: data(:,:)
    end type my_type
  
    type(my_type), intent(inout) :: s
  
    ! 在这里进行一些操作，例如打印数据
    print *, "Number of rows:", s%nrows
    print *, "Number of columns:", s%ncols
  
    ! 释放内存
    deallocate(s%data)
  end subroutine my_fortran_function
  