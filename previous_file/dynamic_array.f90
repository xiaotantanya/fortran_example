! program allocatable

!     implicit none
!     integer, allocatable :: array1(:)
!     integer, allocatable :: array2(:,:)

!     allocate(array1(10))
!     allocate(array2(10,10))

!     ! ...

!     deallocate(array1)
!     deallocate(array2)

! end program allocatable

program allocatable_string
    implicit none

    character(:), allocatable :: first_name
    character(:), allocatable :: last_name

    allocate(character(4) :: first_name)
    first_name = 'John'
    last_name = 'Smith'
    print *, first_name//' '//last_name

end program allocatable_string