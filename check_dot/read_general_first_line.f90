! program extract_strings
!     implicit none
    
!     character(100) :: filename
!     character(100) :: line
!     character(100), dimension(:), allocatable :: name_list
!     integer, dimension(:), allocatable :: data_len_list
    
!     ! Prompt user for input file name
!     print*, "Enter the filename: "
!     read(*, '(A100)') filename
    
!     ! Open the file
!     open(unit=10, file=trim(filename), status='old', action='read')
    
!     ! Initialize variables
!     allocate(name_list(0))
!     allocate(data_len_list(0))
    
!     ! Read file line by line
!     do
!         read(10, '(A)', iostat=ios) line
!         if (ios /= 0) exit ! Exit loop when end of file is reached
        
!         call process_line(line, name_list, data_len_list)
!     end do
    
!     ! Close the file
!     close(10)
    
!     ! Print the extracted strings and their respective comma counts
!     print*, "Extracted Strings:"
!     do i = 1, size(name_list)
!         print*, trim(name_list(i)), ", Number of Commas:", data_len_list(i)
!     end do
    
!     ! Deallocate memory
!     deallocate(name_list)
!     deallocate(data_len_list)
    
! contains

!     subroutine process_line(line, name_list, data_len_list)
!         character(100), intent(in) :: line
!         character(100), dimension(:), allocatable, intent(inout) :: name_list
!         integer, dimension(:), allocatable, intent(inout) :: data_len_list
!         character(100) :: substr
!         integer :: i, len, comma_count
        
!         len = len_trim(line)
!         comma_count = 0
        
!         ! Loop through the line to extract substrings and count commas
!         do i = 1, len
!             if (line(i:i) == ',') then
!                 if (len_trim(substr) > 0) then
!                     ! Store the extracted substring
!                     allocate(character(len_trim(substr)) :: name_list(size(name_list) + 1))
!                     name_list(size(name_list)) = trim(substr)
                    
!                     ! Store the number of commas after the substring
!                     allocate(integer :: data_len_list(size(data_len_list) + 1))
!                     data_len_list(size(data_len_list)) = comma_count
                    
!                     substr = '' ! Reset substring for the next segment
!                 endif
!                 comma_count = comma_count + 1
!             else
!                 substr = trim(adjustl(substr) // line(i:i))
!             end if
!         end do
        
!         ! Process the last substring if not empty
!         if (len_trim(substr) > 0) then
!             allocate(character(len_trim(substr)) :: name_list(size(name_list) + 1))
!             name_list(size(name_list)) = trim(substr)
            
!             allocate(integer :: data_len_list(size(data_len_list) + 1))
!             data_len_list(size(data_len_list)) = comma_count
!         endif
        
!     end subroutine process_line

! end program extract_strings

program read_general_first_line
    implicit none
    character(len = 256) :: first_line
    integer :: i, j
    integer,dimension(:), allocatable :: start_index, end_index
    integer :: name_num, name_order
    character(len=32),dimension(:),allocatable :: name_list
    integer, dimension(:), allocatable :: data_len_list
    character(len=32) :: FMT

    name_num = 0
    name_order = 1

    first_line = 'timestep, eposhom_v, , , , , sigappl_v, , ,'
    do i = 1, len_trim(first_line)
        if(first_line(i:i) /= ' ' .and. first_line(i:i) /= ',') then
            if(i == 1) then
                name_num = 1
            else if(first_line(i-1:i-1) == ' ' .or. first_line(i-1:i-1) == ',') then
                name_num = name_num + 1
            else
                cycle
            end if
        end if
    end do
    if(.not. allocated(name_list)) then
        allocate(name_list(name_num))
    end if
    if(.not. allocated(data_len_list)) then
        allocate(data_len_list(name_num))
    end if
    if(.not. allocated(start_index)) then
        allocate(start_index(name_num))
    end if
    if(.not. allocated(end_index)) then
        allocate(end_index(name_num))
    end if

    name_list(:) = ''
    data_len_list = 0
    start_index = 0
    end_index = 0

    ! write(*,*) name_num
    do i = 1, len_trim(first_line)
        ! Check if the current character is the first character
        if(first_line(i:i) /= ' ' .and. first_line(i:i) /= ',') then
            if(i == 1) then
                write(*,*) "i: ", i
                write(*,*) "name_order: ", name_order
                start_index(name_order) = i
                name_order = name_order + 1
            else if(first_line(i-1:i-1) == ' ' .or. first_line(i-1:i-1) == ',') then
                write(*,*) "i: ", i
                write(*,*) "name_order: ", name_order
                start_index(name_order) = i
                name_order = name_order + 1
            end if
        ! Check if the current character is the last character
            if(i == len_trim(first_line)) then
                end_index(name_num) = i
            else if(first_line(i+1:i+1) == ' ' .or. first_line(i+1:i+1) == ',') then
                end_index(name_order-1) = i
            end if
        end if      
    end do
    
    do i = 1, name_num
        ! Extract name list from first line
        name_list(i) = first_line(start_index(i):end_index(i))
        ! Extract name attribute length
        if(i /= name_num) then
            ! write(*,*) "end_index(i), start_index(i+1): ", end_index(i), start_index(i+1)
            do j = end_index(i), start_index(i+1)
                if(first_line(j:j) == ',') then
                    data_len_list(i) = data_len_list(i) + 1
                end if
            end do
        else
            do j = end_index(i), len_trim(first_line)
                if(first_line(j:j) == ',') then
                    data_len_list(i) = data_len_list(i) + 1
                end if
            end do
            if(data_len_list(i) == 0) then
                data_len_list(i) = 1
            end if
        end if     
    end do
2500    format('(A16',',', i0, '(i3, 1x)',')')
2600    format('(A16',',', i0, '(A16, 1x)',')')
    write(FMT, 2500) name_num
    ! write(*,*) "FMT: ", FMT
    write(*,FMT) "start_index: ", start_index
    write(*,FMT) "end_index: ", end_index
    write(*,FMT) "data_len_list: ", data_len_list
    write(FMT, 2600) name_num
    write(*,FMT) "name_list: ", name_list

end program read_general_first_line