program WriteExample
    implicit none
    real :: x = 3.14
    integer :: y = 42
    character(len=10) :: text = "Fortran"

    write(*,*) "Real number x: ", x
    write(*,*) "Integer number y: ", y
    write(*,*) "Text: ", trim(text)

    open(unit=10,file='output.txt', status='replace', action='write')
    write(10, *) 'Real number x: ', x
    write(10, *) 'Integer number y: ', y
    write(10, *) 'Text: ', trim(text)
    close(10)

    write(*, '(A)') 'Fortran'
    write(*, '(I4)') 42
    write(*, '(F8.2)') 3.14159
    write(*, '(E10.3)') 12345.678
    write(*, '(L1)') .true.
end program WriteExample