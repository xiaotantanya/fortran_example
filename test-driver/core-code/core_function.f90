module mod_core_func
    implicit none
    
contains
    subroutine add(num1,  num2, sum)
        integer, intent(in) :: num1
        integer, intent(in) :: num2
        integer, intent(out) :: sum
        sum = num1 + num2
    end subroutine add
end module mod_core_func