subroutine my_fortran_function(tt)
   use iso_c_binding
   implicit none

   integer(kind=c_int), dimension(10) :: tt

   ! 修改一些数据
   tt(1) = 3
   ! 在这里进行一些操作，例如打印数据
   write(*,*) tt

  end subroutine my_fortran_function
  