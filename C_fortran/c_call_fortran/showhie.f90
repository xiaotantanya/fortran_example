        SUBROUTINE SHOWHIE(HELLO,LENGTH,E,T)  
        CHARACTER*(*) HELLO  
        INTEGER LENGTH  
        REAL E  
        TYPE TEST  
            INTEGER N  
            REAL M  
        END TYPE  
        TYPE (TEST) :: T  
        WRITE(*,100) HELLO(1:LENGTH),LENGTH,E,T%N,T%M  
100       FORMAT(3X,A,2X,I3,4X,F7.5,2X,I3,2X,F7.5)  
        RETURN  
        END SUBROUTINE SHOWHIE