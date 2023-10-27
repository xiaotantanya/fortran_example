program test_check

    implicit none
    real :: angle
    integer :: i
    integer :: j

    angle = 89

    if(angle < 90.0) then
        print *, 'Angle is acute'
    end if

    if(angle < 90.0) then
        print *, 'Angle is acute'
    else
        print *, 'Angle is obtuse'
    end if

    if(angle < 90.0) then
        print *, 'Angle is acute'
    else if(angle < 180.0) then
        print *, 'Angle is obtuse'
    else
        print *, 'Angle is reflex'
    end if



    do i = 1, 10, 2
        print *, i
    end do

    i = 1
    do while(i < 11)
        print *, i
        i = i + 1
    end do

    do i = 1, 100
        if(i > 10) then
            exit
        end if
        print *, i
    end do

    do i = 1, 10
        if(mod(i,2) == 0) then
            cycle
        end if
        print *, i
    end do

    outer_loop : do i = 1, 10
        inner_loop : do j = 1, 10
            if((j+i) > 10) then
                cycle outer_loop
            end if
            print *, 'I=', i, 'J=', j, 'Sum=', j + i
        end do inner_loop
    end do outer_loop

end program test_check
