program create_type

    implicit none
    type :: t_pair
        integer :: i = 1
        real :: x = 0.5
        
    end type 

    ! Declare
    type(t_pair) :: pair
    ! Initialize
    pair%i = 1
    pair%x = 0.5

    pair = t_pair(1,0.5)
    pair = t_pair(i=1,x=0.5)
    pair = t_pair(x=0.5,i=1)

    pair = t_pair()
    pair = t_pair(i=2)
    pair = t_pair(x=2.7)
    
end program create_type
