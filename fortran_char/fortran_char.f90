! program fortran_char

!     implicit none
!     character(len=20) :: name
!     name = "Tan wen"
!     print *, name
! end program fortran_char

! program hello

!     implicit none
!     character(len=15) :: surname,firstname
!     character(len=6) :: title
!     character(len=25) :: greetings

!     title = 'Mr.'
!     firstname = "Rowan"
!     surname = "atkinson"
!     greetings = "a big hello from Mr. Beans"

!     print *, "here is",title,firstname,surname
!     print *, greetings

! end program hello

program hello

    implicit none
    character(len=15) :: surname, firstname
    character(len=6) :: title
    character(len=40) :: name
    character(len=25) :: greetings

    title = 'Mr.'
    firstname = 'Rowan'
    surname = 'Atkinson'

    name = title//firstname//surname
    greetings = 'A big hello from Mr. Beans'

    print *, "here is ",name
    print *, greetings

end program hello

