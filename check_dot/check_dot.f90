program ReadFileAndCountCommas
    implicit none
  
    character(100) :: line    ! 假设每行最多有100个字符
    integer :: i, commaCountEposhom, commaCountSigappl, j, k
  
    ! 打开文件
    open(unit=10, file='test.in', status='old')
  
    ! 读取一行数据
    do
      read(10, '(A)', iostat=i) line
      if (i /= 0) exit  ! 读到文件末尾
      ! 在这里处理line字符串，计算逗号的数量
      commaCountEposhom = 0
      commaCountSigappl = 0
      ! 找到 "eposhom_v" 后的逗号数量
      i = index(line, 'eposhom_v')
      j = index(line, 'sigappl_v')
      write(*,*) i
      write(*,*) j
      do k = i, j
        
      ! 找到 "sigappl_v" 后的逗号数量
      i = index(line, 'sigappl_v')
      if (i > 0) then
        do while (line(i:i) == ',')
          commaCountSigappl = commaCountSigappl + 1
          i = i + 1
        end do
      end if
      ! 输出逗号的数量
      print *, 'eposhom_v 后的逗号数量为:', commaCountEposhom
      print *, 'sigappl_v 后的逗号数量为:', commaCountSigappl
    end do
  
    ! 关闭文件
    close(10)
  
  end program ReadFileAndCountCommas
  