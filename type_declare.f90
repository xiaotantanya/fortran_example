module m_matrix

    implicit none
    private

    type, public :: t_matrix(rows, cols, k)
        integer, len :: rows, cols
        integer, kind :: k = kind(0.0)
        real(kind=k), dimension(rows,cols) :: values
    end type

end module m_matrix

program test_matrix
    use m_matrix
    implicit none
    
    type(t_matrix(rows=5, cols=5)) :: m
    print *, m%k

end program test_matrix
