! program FileIO
!     implicit none
!     integer :: unit_num
!     character(len=20) :: file_name = "example.txt"
!     integer :: iostatus

!     open(unit = unit_num, file = file_name, status="replace", action="write", iostat=iostatus)
!     if(iostatus /= 0) then
!         write(*, *) "can't open the file, ", file_name
!         stop
!     endif

!     write(unit_num, *) "Hello, Fortran !"
!     close(unit_num)
! end program FileIO

program FileIO
    implicit none
    integer :: unit_num
    character(len=20) :: file_name = "example.txt"
    character(len=100) :: dataLine
    integer :: iostatus

    open(unit=unit_num, file=file_name, status="old", action="read", iostat=iostatus)
    if(iostatus /= 0) then
        write(*,*) "can't open the file ", file_name
        stop
    endif

    do while(.true.)
        read(unit_num,'(A)',iostat=iostatus) dataLine
        if(iostatus /= 0) exit
        write(*, *) 'Read Data is: ', trim(dataLine)
    end do

    close(unit_num)

end program FileIO