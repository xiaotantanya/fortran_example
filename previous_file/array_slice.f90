program array_slice

    implicit none
    integer :: i
    integer :: array1(10)
    integer :: array2(10,20)

    array1 = [1,2,3,4,5,6,7,8,9,10]
    array1 = [(i, i= 1, 10)]
    array1(:) = 0
    array1(1:5) = 1
    array1(6:) = 1

    print *, array1(1:10:2)
    print *, array2(:,1)
    print *, array1(10:1:-1)

end program array_slice

