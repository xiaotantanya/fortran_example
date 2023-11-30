module test_out
    use, intrinsic :: ISO_Fortran_env
    implicit none
    private
    public :: outputxN_P
    integer, parameter::idp = int64
    integer, parameter::isp = int32
    integer, parameter::rsp = real32
    integer, parameter::rdp = real64
    integer, parameter::cdp = real64
    integer, parameter::Rn3 = 60
    integer, parameter::Rn2 = 128
    integer, parameter::Rn1 = 128
    integer :: ierr, ierr1, ierr2
    integer :: rank, process
    logical :: init_flag
contains

    subroutine outputxN_P(inFilename, kt, inArr1, inArr2, inArr3, &
                          inArr4, inArr5, inArr6, inArr7, inArr8, &
                          inArr9, inArrA, inArrB, inArrC)

        !Outputs a 3-vector of float values using parallel direct I/O
        !The argument 'inFilename' must be exactly 8 characters long
        !...trailing blanks are OK.

        ! use mod_interfaces,only:check_array_size
        ! use simSize
        ! use mpi_inout
        ! use mod_fftw_mpi

        implicit none
        include 'mpif.h'
        integer(kind=idp) :: kt
        character(len=8), intent(in) :: inFilename
        real(kind=rdp), dimension(:, :, :), intent(in) :: inArr1
        real(kind=rdp), optional, dimension(:, :, :), intent(in) :: inArr2, inArr3
        real(kind=rdp), optional, dimension(:, :, :), intent(in) :: inArr4, inArr5, inArr6
        real(kind=rdp), optional, dimension(:, :, :), intent(in) :: inArr7, inArr8, inArr9
        real(kind=rdp), optional, dimension(:, :, :), intent(in) :: inArrA, inArrB, inArrC

        character(len=8) fileindex, outFilename
        character(len=17) filename
        character(len=21) filenamepgm

        integer i, j, k, ispace, ix, n, jy, errorInt
        integer outfile, outfile_hold,  ierr2
        integer(kind=idp) :: istatus
        character(len=100) buffer
        character(len=entryLen*1 + 3*intLen + 2) buffer1
        character(len=entryLen*2 + 3*intLen + 2) buffer2
        character(len=entryLen*3 + 3*intLen + 2) buffer3
        character(len=entryLen*4 + 3*intLen + 2) buffer4
        character(len=entryLen*5 + 3*intLen + 2) buffer5
        character(len=entryLen*6 + 3*intLen + 2) buffer6
        character(len=entryLen*7 + 3*intLen + 2) buffer7
        character(len=entryLen*8 + 3*intLen + 2) buffer8
        character(len=entryLen*9 + 3*intLen + 2) buffer9
        character(len=entryLen*10 + 3*intLen + 2) bufferA
        character(len=entryLen*11 + 3*intLen + 2) bufferB
        character(len=entryLen*12 + 3*intLen + 2) bufferC

        integer sublength, types(3), disp(3), blockLengths(3)
        integer blockdisp, headerdisp, entrylength
        character printForm(1), dec(2)
        integer jlimit, Rn1t, Rn2t, Rn3t

        integer headerlines, entryType
        integer(kind=idp) currentdisp
        character(len=35) FMT, FMT2

        ! Determine the number of arrays that have been passed to the solver routine.
        if (present(inArrC)) then; n = 12
        elseif (present(inArrB)) then; n = 11
        elseif (present(inArrA)) then; n = 10
        elseif (present(inArr9)) then; n = 9
        elseif (present(inArr8)) then; n = 8
        elseif (present(inArr7)) then; n = 7
        elseif (present(inArr6)) then; n = 6
        elseif (present(inArr5)) then; n = 5
        elseif (present(inArr4)) then; n = 4
        elseif (present(inArr3)) then; n = 3
        elseif (present(inArr2)) then; n = 2
        else; n = 1
        end if

        ! call error handling subroutine to check variable array sizes
        ! call MPI_Barrier(MPI_Comm_world, ierr)
        ! if (present(inArrC)) call check_array_size("outputxN_P", "inArrC" &
        !                                            , Re_arr3=inArrC)
        ! if (present(inArrB)) call check_array_size("outputxN_P", "inArrB" &
        !                                            , Re_arr3=inArrB)
        ! if (present(inArrA)) call check_array_size("outputxN_P", "inArrA" &
        !                                            , Re_arr3=inArrA)
        ! if (present(inArr9)) call check_array_size("outputxN_P", "inArr9" &
        !                                            , Re_arr3=inArr9)
        ! if (present(inArr8)) call check_array_size("outputxN_P", "inArr8" &
        !                                            , Re_arr3=inArr8)
        ! if (present(inArr7)) call check_array_size("outputxN_P", "inArr7" &
        !                                            , Re_arr3=inArr7)
        ! if (present(inArr6)) call check_array_size("outputxN_P", "inArr6" &
        !                                            , Re_arr3=inArr6)
        ! if (present(inArr5)) call check_array_size("outputxN_P", "inArr5" &
        !                                            , Re_arr3=inArr5)
        ! if (present(inArr4)) call check_array_size("outputxN_P", "inArr4" &
        !                                            , Re_arr3=inArr4)
        ! if (present(inArr3)) call check_array_size("outputxN_P", "inArr3" &
        !                                            , Re_arr3=inArr3)
        ! if (present(inArr2)) call check_array_size("outputxN_P", "inArr2" &
        !                                            , Re_arr3=inArr2)
        ! call check_array_size("outputxN_P", "inArr1", Re_arr3=inArr1)
        ! call MPI_Barrier(MPI_Comm_world, ierr)

        ! format = (1x,e15.8) this will be the format used to read and write all data in the simulation
        sublength = 16
        headerlines = 1

        !Determine Entry information and setup appropriate variable type
        entrylength = 3*intLen + n*entryLen + 2; !entry size in bytes
        types(1) = MPI_LB
        types(2) = MPI_Character
        types(3) = MPI_UB

        blockLengths(1) = 1
        blockLengths(2) = entrylength
        blockLengths(3) = 1

        disp(1) = 0
        disp(2) = 0
        disp(3) = entrylength

        headerdisp = headerlines*entrylength
        blockdisp = entrylength*Rn3*Rn2*lstartR

        call MPI_type_struct(3, blockLengths, disp, types, entryType, ierr)
        call MPI_Type_Commit(entryType, ierr)

        currentdisp = headerdisp + blockdisp

    !!!!!!!!!!!!!!

        !Format definitions
2500    format("(3(1x,i", i0, "),", i0, "(1x,es", i0, ".", i0, "e3),A2)")   !tuy20160504
        write (FMT, 2500) (intLen - 1), n, (entryLen - 1), per
        !if(rank.eq.1) print *, FMT

2600    format("(3(1x,i", i0, "),A", i0, ",A2)")
        write (FMT2, 2600) (intLen - 1), n*entryLen
        !if(rank.eq.1) print *, FMT2

    !!!!!!!!!!!!!!!

        !     print *, 'Calling inside outputNx!',rank,kt
        call filenamer(inFilename, filenamepgm, kt)
        !     print *, 'Check -1 on process ',rank

        !Open file to write through MPI interface
        !Please see
        ! http://www.dei.unipd.it/~addetto/manuali_online/SP/MPISubRef/d3d80mst02.html#ToC
        ! For documentation of MPI functions in general and file handling function in particular.

        !     if(rank.eq.0) print *, 'filename: ',filenamepgm

        !Make the file so it will exist for the MPI call.  Also, make sure it is empty
        if (rank .eq. 0) then
            open (unit=5, file=trim(filenamepgm))
            write (5, *) ' '
            close (5)
            !       print *, 'Opened 6x file successfully!'
        end if

        !     print *, 'Check 0 on process ',rank
        !    print *, 'file name on process ',rank, filenamepgm
        call MPI_Barrier(MPI_Comm_World, ierr)

        !     print *, 'Check A on process ',rank
        call MPI_File_Open(MPI_COMM_WORLD, trim(filenamepgm), &
                           MPI_MODE_WRONLY, mpi_info_null, outfile, ierr)
        outfile_hold = outfile
        !    print *, 'Check B on process ',rank,ierr,outfile,outfile_hold
        !Check that the file opened without errors
        if (ierr .ne. 0) then
            call MPI_error_string(ierr, buffer, errorInt, ierr2)
            print *, 'ERROR ', ierr, ': ', buffer
            print *, 'Detected on processor ', rank, ' while opening file'
            print *, filenamepgm, ' did not write correctly'
            print *, 'Stopping simulation'
            call MPI_FINALIZE(ierr)
            stop
        end if
        !    print *, 'Check C on process ',rank,ierr,outfile,outfile_hold
        !file handle is "outfile"

        !Have the header node write the header for the file
        if (rank .eq. 0) then
            select case (n)
            case (12)
                write (bufferC, FMT2) nx, ny, nz, ' ', achar(10)
                call MPI_File_Write(outfile, bufferC, 1, entryType, istatus, ierr)
            case (11)
                write (bufferB, FMT2) nx, ny, nz, ' ', achar(10)
                call MPI_File_Write(outfile, bufferB, 1, entryType, istatus, ierr)
            case (10)
                write (bufferA, FMT2) nx, ny, nz, ' ', achar(10)
                call MPI_File_Write(outfile, bufferA, 1, entryType, istatus, ierr)
            case (9)
                write (buffer9, FMT2) nx, ny, nz, ' ', achar(10)
                call MPI_File_Write(outfile, buffer9, 1, entryType, istatus, ierr)
            case (8)
                write (buffer8, FMT2) nx, ny, nz, ' ', achar(10)
                call MPI_File_Write(outfile, buffer8, 1, entryType, istatus, ierr)
            case (7)
                write (buffer7, FMT2) nx, ny, nz, ' ', achar(10)
                call MPI_File_Write(outfile, buffer7, 1, entryType, istatus, ierr)
            case (6)
                write (buffer6, FMT2) nx, ny, nz, ' ', achar(10)
                call MPI_File_Write(outfile, buffer6, 1, entryType, istatus, ierr)
            case (5)
                write (buffer5, FMT2) nx, ny, nz, ' ', achar(10)
                call MPI_File_Write(outfile, buffer5, 1, entryType, istatus, ierr)
            case (4)
                write (buffer4, FMT2) nx, ny, nz, ' ', achar(10)
                call MPI_File_Write(outfile, buffer4, 1, entryType, istatus, ierr)
            case (3)
                write (buffer3, FMT2) nx, ny, nz, ' ', achar(10)
                call MPI_File_Write(outfile, buffer3, 1, entryType, istatus, ierr)
            case (2)
                write (buffer2, FMT2) nx, ny, nz, ' ', achar(10)
                call MPI_File_Write(outfile, buffer2, 1, entryType, istatus, ierr)
            case (1)
                write (buffer1, FMT2) nx, ny, nz, ' ', achar(10)
                call MPI_File_Write(outfile, buffer1, 1, entryType, istatus, ierr)
            case default
                print '(A)', "Error: Column numbers for output NOT support!"
                print '(A)', "Stopping"
                call MPI_Barrier(MPI_Comm_World, ierr)
                call MPI_Finalize(ierr)
                stop
            end select
        end if

        !    print *, 'Check D on process ',rank,ierr,outfile,outfile_hold
        call MPI_Barrier(MPI_Comm_World, ierr)

        !move the file pointer for each processor to where it needs to
        !...begin writing the file
        !print *, 'Check E on process ',rank
        outfile = outfile_hold
        call MPI_File_Seek(outfile, currentdisp, MPI_Seek_Set, ierr)
        !    print *, 'Check f on process ',rank,ierr,outfile,outfile_hold
        if (ierr .ne. 0) then
            call MPI_error_string(ierr, buffer, errorInt, ierr2)
            print *, 'ERROR ', ierr, ': ', buffer
            print *, 'Detected on processor ', rank, ' while seeking file'
            print *, filenamepgm, ' did not write correctly'
            print *, 'Stopping simulation'
            call MPI_FINALIZE(ierr)
            stop
        end if
        !     print *, 'Check F on process ',rank
        !     print '(A,i2,3i4)', 'size of inArr1 on process: ',rank,size(inArr1,1),size(inArr1,2),size(inArr1,3)

        !Write the data.
        !Rn1t = Rn1; Rn2t = Rn2; Rn3t = Rn3
        !Rn1 = Rn1t; Rn2 = Rn2t; Rn3 = Rn3t
        outfile = outfile_hold
        select case (n)
        case (1)
            do k = 1, Rn1
                ix = k + lstartR
                do j = 1, Rn2
                    do i = 1, Rn3
                        ! write(*,FMT) k,j,i,inArr1(i,j,k)," "
                        ! write(*,*) Rn1,Rn2,Rn3
                        if ((k .gt. Rn1) .or. (j .gt. Rn2) .or. (i .gt. Rn3)) exit
                        write (buffer1, FMT) ix, j, i, inArr1(i, j, k), achar(10)

                        call MPI_FILE_WRITE(outfile, buffer1, 1, entryType, istatus, ierr)
                    end do
                end do
            end do
        case (2)
            do k = 1, Rn1
                ix = k + lstartR
                do j = 1, Rn2
                    do i = 1, Rn3
                        if ((k .gt. Rn1) .or. (j .gt. Rn2) .or. (i .gt. Rn3)) exit
                        write (buffer2, FMT) ix, j, i, inArr1(i, j, k), inArr2(i, j, k), &
                            achar(10)
                        call MPI_FILE_WRITE(outfile, buffer2, 1, entryType, istatus, ierr)
                    end do
                end do
            end do
        case (3)
            do k = 1, Rn1
                ix = k + lstartR
                do j = 1, Rn2
                    do i = 1, Rn3
                        if ((k .gt. Rn1) .or. (j .gt. Rn2) .or. (i .gt. Rn3)) exit
                        write (buffer3, FMT) ix, j, i, inArr1(i, j, k), inArr2(i, j, k), inArr3(i, j, k), achar(10)
                        call MPI_FILE_WRITE(outfile, buffer3, 1, entryType, istatus, ierr)
                    end do
                end do
            end do
        case (4)
            do k = 1, Rn1
                ix = k + lstartR
                do j = 1, Rn2
                    do i = 1, Rn3
                        if ((k .gt. Rn1) .or. (j .gt. Rn2) .or. (i .gt. Rn3)) exit
                        write (buffer4, FMT) ix, j, i, inArr1(i, j, k), inArr2(i, j, k), &
                            inArr3(i, j, k), inArr4(i, j, k), achar(10)
                        call MPI_FILE_WRITE(outfile, buffer4, 1, entryType, istatus, ierr)
                    end do
                end do
            end do
        case (5)
            do k = 1, Rn1
                ix = k + lstartR
                do j = 1, Rn2
                    do i = 1, Rn3
                        if ((k .gt. Rn1) .or. (j .gt. Rn2) .or. (i .gt. Rn3)) exit
                        write (buffer5, FMT) ix, j, i, inArr1(i, j, k), inArr2(i, j, k), &
                            inArr3(i, j, k), inArr4(i, j, k), inArr5(i, j, k), &
                            achar(10)
                        call MPI_FILE_WRITE(outfile, buffer5, 1, entryType, istatus, ierr)
                    end do
                end do
            end do
        case (6)
            do k = 1, Rn1
                ix = k + lstartR
                do j = 1, Rn2
                    do i = 1, Rn3
                        !print *,i,j,k,Rn1,Rn2,Rn3
                        if ((k .gt. Rn1) .or. (j .gt. Rn2) .or. (i .gt. Rn3)) exit
                        write (buffer6, FMT) ix, j, i, inArr1(i, j, k), inArr2(i, j, k), &
                            inArr3(i, j, k), inArr4(i, j, k), inArr5(i, j, k), &
                            inArr6(i, j, k), achar(10)
                        call MPI_FILE_WRITE(outfile, buffer6, 1, entryType, istatus, ierr)
                    end do
                end do
            end do
        case (7)
            do k = 1, Rn1
                ix = k + lstartR
                do j = 1, Rn2
                    do i = 1, Rn3
                        if ((k .gt. Rn1) .or. (j .gt. Rn2) .or. (i .gt. Rn3)) exit
                        write (buffer7, FMT) ix, j, i, inArr1(i, j, k), inArr2(i, j, k), &
                            inArr3(i, j, k), inArr4(i, j, k), inArr5(i, j, k), &
                            inArr6(i, j, k), inArr7(i, j, k), achar(10)
                        call MPI_FILE_WRITE(outfile, buffer7, 1, entryType, istatus, ierr)
                    end do
                end do
            end do
        case (8)
            do k = 1, Rn1
                ix = k + lstartR
                do j = 1, Rn2
                    do i = 1, Rn3
                        if ((k .gt. Rn1) .or. (j .gt. Rn2) .or. (i .gt. Rn3)) exit
                        write (buffer8, FMT) ix, j, i, inArr1(i, j, k), inArr2(i, j, k), &
                            inArr3(i, j, k), inArr4(i, j, k), inArr5(i, j, k), &
                            inArr6(i, j, k), inArr7(i, j, k), inArr8(i, j, k), &
                            achar(10)
                        call MPI_FILE_WRITE(outfile, buffer8, 1, entryType, istatus, ierr)
                    end do
                end do
            end do
        case (9)
            do k = 1, Rn1
                ix = k + lstartR
                do j = 1, Rn2
                    do i = 1, Rn3
                        if ((k .gt. Rn1) .or. (j .gt. Rn2) .or. (i .gt. Rn3)) exit
                        write (buffer9, FMT) ix, j, i, inArr1(i, j, k), inArr2(i, j, k), &
                            inArr3(i, j, k), inArr4(i, j, k), inArr5(i, j, k), &
                            inArr6(i, j, k), inArr7(i, j, k), inArr8(i, j, k), &
                            inArr9(i, j, k), achar(10)
                        call MPI_FILE_WRITE(outfile, buffer9, 1, entryType, istatus, ierr)
                    end do
                end do
            end do
        case (10)
            do k = 1, Rn1
                ix = k + lstartR
                do j = 1, Rn2
                    do i = 1, Rn3
                        if ((k .gt. Rn1) .or. (j .gt. Rn2) .or. (i .gt. Rn3)) exit
                        write (bufferA, FMT) ix, j, i, inArr1(i, j, k), inArr2(i, j, k), &
                            inArr3(i, j, k), inArr4(i, j, k), inArr5(i, j, k), &
                            inArr6(i, j, k), inArr7(i, j, k), inArr8(i, j, k), &
                            inArr9(i, j, k), inArrA(i, j, k), achar(10)
                        call MPI_FILE_WRITE(outfile, bufferA, 1, entryType, istatus, ierr)
                    end do
                end do
            end do
        case (11)
            do k = 1, Rn1
                ix = k + lstartR
                do j = 1, Rn2
                    do i = 1, Rn3
                        if ((k .gt. Rn1) .or. (j .gt. Rn2) .or. (i .gt. Rn3)) exit
                        write (bufferB, FMT) ix, j, i, inArr1(i, j, k), inArr2(i, j, k), &
                            inArr3(i, j, k), inArr4(i, j, k), inArr5(i, j, k), &
                            inArr6(i, j, k), inArr7(i, j, k), inArr8(i, j, k), &
                            inArr9(i, j, k), inArrA(i, j, k), inArrB(i, j, k), &
                            achar(10)
                        call MPI_FILE_WRITE(outfile, bufferB, 1, entryType, istatus, ierr)
                    end do
                end do
            end do
        case (12)
            do k = 1, Rn1
                ix = k + lstartR
                do j = 1, Rn2
                    do i = 1, Rn3
                        if ((k .gt. Rn1) .or. (j .gt. Rn2) .or. (i .gt. Rn3)) exit
                        write (bufferC, FMT) ix, j, i, inArr1(i, j, k), inArr2(i, j, k), &
                            inArr3(i, j, k), inArr4(i, j, k), inArr5(i, j, k), &
                            inArr6(i, j, k), inArr7(i, j, k), inArr8(i, j, k), &
                            inArr9(i, j, k), inArrA(i, j, k), inArrB(i, j, k), &
                            inArrC(i, j, k), achar(10)
                        call MPI_FILE_WRITE(outfile, bufferC, 1, entryType, istatus, ierr)
                    end do
                end do
            end do
        case default
            if (rank .eq. 0) then
                print '(A)', "Error: Column numbers for output NOT support!"
                print '(A)', "Stopping"
            end if
            call MPI_Barrier(MPI_Comm_World, ierr)
            call MPI_Finalize(ierr)
            stop
        end select

        !Close file through MPI and check for errors
        call MPI_FILE_CLOSE(outfile, ierr)
        if (ierr .ne. 0) then
            call MPI_error_string(ierr, buffer, errorInt, ierr2)
            print *, 'ERROR ', ierr, ': ', buffer
            print *, 'Detected on processor ', rank, ' while closing file'
            print *, filenamepgm, ' did not write correctly'
            print *, 'Stopping simulation'
            call MPI_FINALIZE(ierr)
            stop
        end if

        call MPI_Barrier(MPI_COMM_WORLD, ierr)
        if (ierr .ne. 0) then
            call MPI_ERROR_STRING(ierr, buffer, errorInt, ierr2)
            print '(A,A)', 'MPI_BARRIER ERROR: ', buffer
            print *, ierr
        end if
        !print *,'Leaving_output',rank

        !     print *, 'Check G on process ',rank
    end subroutine

end module

program test
    use test_out
    implicit none
    include 'mpif.h'



    character(len=:), allocatable :: fileName
    integer(kind=idp) :: kt
    real(kind=rdp), dimension(Rn3,Rn2,Rn1) :: inArr

    fileName = "mupro_output_3D"
    kt = 10
    inArr = 0

    call MPI_INITIALIZED(init_flag, ierr)
    if (.not. init_flag) call MPI_INIT(ierr)
    call MPI_Barrier(MPI_COMM_WORLD, ierr)
    call mpi_comm_rank(mpi_comm_world, rank, ierr)
    call mpi_comm_size(mpi_comm_world, process, ierr)

    call outputxN_P(fileName,kt,inArr)

    call MPI_Finalize(ierr)
end program test
