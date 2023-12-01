program TrimExample
    implicit none
    character(len=20) :: original_string = "         Fortran String          "
    character(len=:), allocatable :: trimmed_string

    trimmed_string = trim(original_string)

    write(*, *) 'Origin String: ', original_string
    write(*, *) 'Trimmed String: ', trimmed_string

end program TrimExample