# FFT block

This is a basic block that provides Fast Fourier Transform to other blocks.Containing several modules:
1. mode_fft, defines the fft basic type(type_FFTcontext), and setup,forward,backward and other subroutine
2. mod_fft_double_size, provides higher precision Fourier transform

Learn more about the intel cluster fft from [here](https://www.intel.com/content/www/us/en/develop/documentation/onemkl-developer-reference-c/top/fourier-transform-functions/cluster-fft-functions/computing-cluster-fft.html)

# Module FFT
Set types of Fast Fourier Transform, as well as initialization and calculation subroutines.

## 1. mod_fft(fft.f90)
The module is used to define the dimension data to be used in the FFT caculation. It contains some subroutines and types.
```fortran
mod_fft
    ---fitted_setup()
    ---fft_setup(context)
    ---forward_mpi(fwd, fwdk)
    ---backward_mpi(fwdk, fwd)
    ---forward2_mpi(fwd, fwdk)
    ---backward2_mpi(fwdk, fwd)
    ---fft_mpi_derivative(u, u_prime, ord, der)
    ---fitted_mpi_derivative(u, u_prime, ord, der)
    ---fitted_mpi_curvature(u, u_prime, ord, der)
    ---type type_FFTContext
```
Among them, `fft_setup`,`fitted_mpi_derivative`, `fitted_mpi_curvature`, `backward_mpi`, `backward2_mpi`, `forward_mpi`, `forward2_mpi`, `type_mupro_FFTContext`are is commanded to the appropriate form in the interface.f90. Besides, `forward_mpi`, `backward_mpi` can also be used in original form.

```fortran
module mod_mupro_fft
  use mod_fft, only: type_mupro_FFTContext => type_FFTContext
  use mod_fft, only: mupro_fft_setup => fft_setup
  use mod_fft, only: mupro_fitted_derivative => fitted_mpi_derivative
  use mod_fft, only: mupro_fitted_curvature => fitted_mpi_curvature
  use mod_fft, only: backward_mpi => backward_mpi
  use mod_fft, only: mupro_fft_backward => backward_mpi
  use mod_fft, only: mupro_fft_backward2 => backward2_mpi
  use mod_fft, only: forward_mpi => forward_mpi
  use mod_fft, only: mupro_fft_forward => forward_mpi
  use mod_fft, only: mupro_fft_forward2 => forward2_mpi
  use mod_fft, only: mqk1_3, mqk2_3, mqk3_3
  use mod_fft, only: mqk1_2, mqk2_2
end module
```
The module uses the mod_lib_base, mod_lib_log, and iso_C_binding module, also includes  FFTW MPI Fortran Interface:
```fortran
use mod_lib_base
use mod_lib_log
use, intrinsic :: iso_C_binding

include 'fftw3-mpi.f03'
```
In addition, some variables are defined for boundary calculation in the module. These parameters have little to do with calculating the Fourier transform.
```fortran
  ! fitted related parameters
  real(kind=rdp):: am11, am12, am13, am14
  real(kind=rdp):: am21, am22, am23, am24
  real(kind=rdp):: am31, am32, am33, am34
  real(kind=rdp):: am41, am42, am43, am44
  real(kind=rdp), allocatable, dimension(:)::cubicA, cubicB, squareA, squareB
  real(kind=rdp), allocatable, dimension(:)::linearC, linearD, linearA, linearB
  real(kind=rdp):: pointC, pointD

```
### 1.1 type_mupro_FFTContext
The member properties of this type are as follows:
| Variable | Type     | Meaning                                                |
| :------: | :---:    | :----------------------------------------------------- |
|   Rn1    | int32    | Size of real space x dimension on the current core     |
|   Rn2    | int32    | Size of real space y dimension on the current core     |
|   Rn3    | int32    | Size of real space z dimension on the current core     |
|   Cn1    | int32    | Size of fourier space x dimension on the current core  |
|   Cn2    | int32    | Size of fourier space y dimension on the current core  |
|   Cn3    | int32    | Size of fourier space z dimension on the current core  |
|   Hn1    | int32    | Dimension sizes for 2D-transform arrays.  They should be sized f(Rn3,Hn2,Hn1) |
|   Hn2    | int32    | Dimension sizes for 2D-transform arrays.  They should be sized f(Rn3,Hn2,Hn1) |
|  lstart  | int32    | Starting index of the data along x on the current core |
|  Rn1All  | int32(:) | xxx |
|lstartRAll| int32(:) | xxx |
| kvec|int32 pointer(:,:,:,:)|xxx |

```{important}
MPI slicing in FFT only happens along the last dimension of Fortran array, so to have such slicing happens along the x direction, we have to define
the x as the last dimension, y as the second to last, and so on. To give an example, the dimension for polarization is (3,z,y,x).
```

```{note}
Since MPI slicing happens along the last dimension of Fortran array (which is x in our convention), so $\text{Rn3}=\text{nz}$, $\text{Rn2}=\text{ny}$, $\text{Rn1}\neq \text{nx}$, and $\text{lstartR} = \text{0}$ for rank 0, and $\text{lstartR}\neq \text{0}$ for other ranks.
```

### 1.2 mupro_fft_setup(context)
Initialize cluster distributed FFT, so that we can use forward and backward functions afterwards.
```{important}
You must call this fft setup subroutine after [mupro_size_setup](base#mupro_size_setup) and [mupro_mpi_setup](base#mupro_mpi_setup) but before all other subroutines that involves 3D data.
```
| Argument |                      Type(Intent)                      | Meaning                                              |
| :------: | :----------------------------------------------------: | :--------------------------------------------------- |
| context  | [type_mupro_FFTContext(OUT)](#11-type_mupro_fftcontext)   | The simulation size you want to have for the solvers |
### 1.3 mupro_fitted_derivative(u, u_prime, ord, der)
Calculate derivate of 3D data. This function can be called in both thin film and bulk cases. In the thin film case, due to
the sudden change in data across the film interface and surface, a special fitting step is included, which is also why the
subroutine is called mupro_fitted_derivative.
| Argument |                      Type(Intent)                      | Meaning                                              |
| :------: | :----------------------------------------------------: | :--------------------------------------------------- |
| u        | real(kind=rdp),dimension(Rn3,Rn2,Rn1)(IN)                    | Data in real space                                   |
| u_prime  | real(kind=rdp),dimension(3,Rn3,Rn2,Rn1)(OUT)                   | Derivative in real space, in the order of $\frac{d}{dx}$, $\frac{d}{dy}$, $\frac{d}{dz}$ |
| ord      | integer(kind=isp)(IN)                                  | Derivative in real space, in the order of $\frac{d}{dx}$, $\frac{d}{dy}$, $\frac{d}{dz}$  |
| der      | integer(kind=isp)(IN)                                  | The direction to calculate derivative, 1: only $\frac{d}{dx}$, 2: only $\frac{d}{dy}$, 3: only $\frac{d}{dz}$, 4: all derivates, 5: $\frac{d}{dx}$ and $\frac{d}{dy}$   |

### 1.4 mupro_fitted_curvature(u, u_prime, ord, der)
Calculate curvature of 3D data. This function can be called in both thin film and bulk cases. In the thin film case, due to
the sudden change in data across the film interface and surface, a special fitting step is included, which is also why the
subroutine is called mupro_fitted_curvature.
| Argument |                      Type(Intent)                      | Meaning                                              |
| :------: | :----------------------------------------------------: | :--------------------------------------------------- |
| u        | real(kind=rdp),dimension(Rn3,Rn2,Rn1)(IN)                    | Data in real space                                                  |
| u_prime  | real(kind=rdp),dimension(6,Rn3,Rn2,Rn1)(OUT)                   | Curvature in real space, in the order of $\frac{d^2}{dx^2}$, $\frac{d^2}{dy^2}$, $\frac{d^2}{dz^2}$, $\frac{d^2}{dydz}$ , $\frac{d^2}{dxdz}$, $\frac{d^2}{dxdy}$                                                  |
| ord      | integer(kind=isp)(IN)                                  | Order for the fitting along z direction in the thin film case, you can choose from 0 to 4                                                  |
| der      | integer(kind=isp)(INOUT)                               | The direction to calculate Curvature, 1 for $\frac{d^2}{dxdy}$, 2 for $\frac{d^2}{dxdz}$, 4 for $\frac{d^2}{dydz}$, 8 for $\frac{d^2}{dz^2}$, 16 for $\frac{d^2}{dy^2}$, 32 for $\frac{d^2}{dx^2}$. To request multiple second derivatives these numbers should be added together                                                  |
### 1.5 mupro_fft_backward(fwdk, fwd) && backward_mpi(fwdk, fwd)
Backward fft from fourier space to real space in three dimension
| Argument |                      Type(Intent)                      | Meaning                                              |
| :------: | :----------------------------------------------------: | :--------------------------------------------------- |
| fwdk     | complex(kind=cdp),dimension(Cn3,Cn2,Cn1)(IN)           | 3D data in fourier sapce                             |
| fwd      | real(kind=rdp),dimension(Rn3,Rn2,Rn1)(OUT)             | 3D data in real space                                |
### 1.6 mupro_fft_backward2(fwdk, fwd)
Backward fft from fourier space to real space in two dimension.
| Argument |                      Type(Intent)                      | Meaning                                              |
| :------: | :----------------------------------------------------: | :--------------------------------------------------- |
| fwdk     | complex(kind=cdp),dimension(Cn3,Cn2,Cn1)(IN)           | 2D data in fourier space                             |
| fwd      | real(kind=rdp),dimension(Rn3,Rn2,Rn1)(OUT)             | 2D data in real space                                |
### 1.7 mupro_fft_forward(fwd, fwdw) && forward_mpi(fwd, fwdw)
Forward fft from real space to fourier space in three dimension.
| Argument |                      Type(Intent)                      | Meaning                                              |
| :------: | :----------------------------------------------------: | :--------------------------------------------------- |
| fwd      | real(kind=rdp),dimension(Rn3,Rn2,Rn1)(IN)              | 3D data in real space                                |
| fwdk     | complex(kind=cdp),dimension(Cn3,Cn2,Cn1)(OUT)          | 3D data in fourier sapce                             |
### 1.8 mupro_fft_forward2(fwd, fwdk)
Forward fft from real space to fourier space in two dimension.
| Argument |                      Type(Intent)                      | Meaning                                              |
| :------: | :----------------------------------------------------: | :--------------------------------------------------- |
| fwd      | real(kind=rdp),dimension(Rn3,Rn2,Rn1)(IN)              | 2D data in real space                                |
| fwdk     | complex(kind=cdp),dimension(Cn3,Cn2,Cn1)(OUT)          | 2D data in fourier space                             |

## 2. mod_fft_double_size(fft_doubleSize.f90)
This module is similar to the fft module, which provides high-precision Fourier forward transform and backward transform.
```fortran
mod_fft_double_size
    ---fft_setup_doubleSize(context)
    ---forward_mpi_doubleSize(fwdx2,fwdx2k)
    ---backward_mpi_doubleSize(fwdx2k,fwdx2)
    ---type type_FFTDoubleSizeContext
```
This module is only provided for internal use which is used in mod_lib_fft at the end:
```fortran
module mod_lib_fft
  use mod_fft, only: fitted_mpi_derivative, backward_mpi, backward2_mpi
  use mod_fft, only: forward_mpi, forward2_mpi, fitted_mpi_curvature

  use mod_fft, only: am11, am12, am13, am14
  use mod_fft, only: am21, am22, am23, am24
  use mod_fft, only: am31, am32, am33, am34
  use mod_fft, only: am41, am42, am43, am44

  use mod_fft, only: cubicA, cubicB, squareA, squareB
  use mod_fft, only: linearC, linearD, linearA, linearB
  use mod_fft, only: pointC, pointD

  use mod_fft, only: lstartR, lstart2, lstart3 !Starts for distributed last dimension for real, 2D-transform, and 3D-transform arrays, respectively
  use mod_fft, only: Rn1, Rn2, Rn3, Cn1, Cn2, Cn3 !Dimension sizes for Real and 3D-transform arrays, respectively
  !Real arrays should be sized f(Rn3,Rn2,Rn1) while 3D-transform arrays should be f(Cn3,Cn2,Cn1)
  use mod_fft, only: Hn1, Hn2 !Dimension sizes for 2D-transform arrays.  They should be sized f(Rn3,Hn2,Hn1)
  use mod_fft, only: mqk1_3, mqk2_3, mqk3_3
  use mod_fft, only: mqk1_2, mqk2_2
  use mod_fft, only: Rn1All, lstartRAll !, Rn1_doubleSizeAll, lstartR_doubleSizeAll !system size parameters Rn1 and lstart of all processes

  use mod_fft_double_size 
end module
```
### 2.1 type_FFTDoubleSizeContext
Type type_FFTDoubleSizeContext extends type_FFTContext.The member properties of this type are as follows:
| Variable | Type  | Meaning                                                |
| :------: | :---: | :----------------------------------------------------- |
|   Rn1_doubleSize    | int32 | Size of real space x dimension on the current core     |
|   Rn2_doubleSize    | int32 | Size of real space y dimension on the current core     |
|   Rn3_doubleSize    | int32 | Size of real space z dimension on the current core     |
|   Cn1_doubleSize    | int32 | Size of fourier space x dimension on the current core  |
|   Cn2_doubleSize    | int32 | Size of fourier space y dimension on the current core  |
|   Cn3_doubleSize    | int32 | Size of fourier space z dimension on the current core  |
|  lstart_doubleSize  | int32 | Starting index of the data along x on the current core |
|  Hn1_doubleSize     | int32 | Dimension sizes for 2D-transform arrays.  They should be sized f(Rn3,Hn2,Hn1) |
|  Hn2_doubleSize     | int32 | Dimension sizes for 2D-transform arrays.  They should be sized f(Rn3,Hn2,Hn1) |
|  Rn1All_doubleSize  | int32(:) | xxx |
|  lstartRall_doubleSize  | int32(:) | xxx |


### 2.2 fft_setup_doubleSize(context)
Initialize cluster distributed FFT, so that we can use forward and backward functions afterwards.
```{important}
You must call this fft setup subroutine after [mupro_size_setup](base#mupro_size_setup) and [mupro_mpi_setup](base#mupro_mpi_setup) but before all other subroutines that involves 3D data.
```
| Arguments|Type(Intent)|Meaning|
|:--:|:--:|:--:|
|context|[type_FFTDoubleSizeContext(OUT)](#21-type_fftdoublesizecontext)|The simulation size you want to have for the solvers|
### 2.3 forward_mpi_doubleSize(fwdx2,fwdx2k)
Higher accuracy forward FFT from real space to  Fourier space in three dimension.
| Argument |                      Type(Intent)                      | Meaning                                              |
| :------: | :----------------------------------------------------: | :--------------------------------------------------- |
| fwdx2      | real(kind=rdp),dimension(Rn3_doubleSize,Rn2_doubleSize,Rn1_doubleSize)(IN)              | 3D data in real space                                |
| fwdx2k     | complex(kind=cdp),dimension(Cn3_doubleSize,Cn2_doubleSize,Cn1_doubleSize)(OUT)          | 3D data in fourier sapce                             |
### 2.4 backward_mpi_doubleSize(fwdx2k,fwdx2)
Higher accuracy backward FFT from Fourier space to  real space in three dimension.
| Argument |                      Type(Intent)                      | Meaning                                              |
| :------: | :----------------------------------------------------: | :--------------------------------------------------- |
| fwdx2k     | complex(kind=cdp),dimension(Cn3_doubleSize,Cn2_doubleSize,Cn1_doubleSize)(IN)           | 2D data in fourier space                             |
| fwdx2      | real(kind=rdp),dimension(Rn3_doubleSize,Rn2_doubleSize,Rn1_doubleSize)(OUT)             | 2D data in real space                                |

## Below is an example fortran program from the mkl example folder:

```f90
program dp_c2c_3d
  use, intrinsic :: iso_c_binding
  use mpi
  implicit none
  include 'fftw3-mpi.f03'

  ! Sizes of 3D transform
  integer(C_INTPTR_T), parameter :: N1 = 256
  integer(C_INTPTR_T), parameter :: N2 = 128
  integer(C_INTPTR_T), parameter :: N3 = 312

  type(C_PTR) :: plan_fwd, plan_bwd, x_ptr, y_ptr
  complex(C_DOUBLE_COMPLEX), pointer :: x(:,:,:), y(:,:,:)

  real(C_DOUBLE) :: r, l, loc_err_l2, loc_norm_l2, err_l2, norm_l2, rel_err
  real(C_DOUBLE), parameter :: eps = 1.d-14
  logical :: test_passed

  ! FFT local sizes
  integer(C_INTPTR_T) :: i, j, k, local_size, local_n1, local_1_start

  ! MPI stuff
  integer*4, parameter :: comm = MPI_COMM_WORLD
  integer*4 :: stat, irank, nrank

  ! MPI initialization
  call mpi_init(stat)
  call mpi_comm_size(comm, nrank, stat)
  call mpi_comm_rank(comm, irank, stat)

  if (0 == irank) then
      print '(" Number of MPI processes "I0)', nrank
      print '(" FFT data size: "I0" x "I0" x "I0)', N1, N2, N3
      print *,"Data distribution across first dimension"
  endif

  ! FFTW3 MPI initialization
  call fftw_mpi_init()

  ! allocating array
  local_size = fftw_mpi_local_size_3d(N1, N2, N3, comm, local_n1, local_1_start)
  x_ptr = fftw_alloc_complex(local_size)
  y_ptr = fftw_alloc_complex(local_size)
  call c_f_pointer(x_ptr, x, [N3, N2, local_n1])
  call c_f_pointer(y_ptr, y, [N3, N2, local_n1])

  print '(" FFT local data size on rank "I2": "I3" x "I3" x "I3)', &
      irank, local_n1, N2, N3

  plan_fwd = fftw_mpi_plan_dft_3d(N1, N2, N3, x, y, comm, &
      FFTW_FORWARD, FFTW_ESTIMATE)
  plan_bwd = fftw_mpi_plan_dft_3d(N1, N2, N3, y, x, comm, &
      FFTW_BACKWARD, FFTW_ESTIMATE)

  ! Note reversed indexing: x(k,j,i) <- foo(i,j,k)
  forall (i=1:local_n1, j=1:N2, k=1:N3)
      x(k, j, i) = foo(local_1_start + i, j, k, N1, N2, N3)
      y(k, j, i) = foo(local_1_start + i, j, k, N1, N2, N3)
  end forall

  call fftw_mpi_execute_dft(plan_fwd, x, y)
  call fftw_mpi_execute_dft(plan_bwd, y, x)

  loc_err_l2 = 0
  loc_norm_l2 = 0
  do i = 1, local_n1
      do j = 1, N2
          do k = 1, N3
              l = real(foo(local_1_start + i, j, k, N1, N2, N3))
              r = real(x(k, j, i))/(N1 * N2 * N3) - l

              loc_err_l2 = loc_err_l2 + r**2
              loc_norm_l2 = loc_norm_l2 + l**2
          end do
      end do
  end do

  err_l2 = 0
  norm_l2 = 0
  call mpi_allreduce(loc_err_l2, err_l2, 1, MPI_DOUBLE, MPI_SUM, comm, stat)
  call mpi_allreduce(loc_norm_l2, norm_l2, 1, MPI_DOUBLE, MPI_SUM, comm, stat)
  err_l2 = sqrt(err_l2)
  norm_l2 = sqrt(norm_l2)
  rel_err = err_l2 / norm_l2

  call fftw_destroy_plan(plan_fwd)
  call fftw_destroy_plan(plan_bwd)
  call fftw_free(x_ptr)
  call fftw_free(y_ptr)

  call fftw_mpi_cleanup()
  call mpi_finalize(stat)

  test_passed = rel_err < eps
  if (0 == irank) then
      print *, "=================================="
      print *, "computational relative error in L2 = ", rel_err
      if (test_passed) then
          print *," TEST PASSED"
      else
          print *," TEST FAILED"
      endif
  endif

  if (.not. test_passed) call exit(1)
  call exit(0)

contains

  pure complex(C_DOUBLE_COMPLEX) function foo(i, j, k, N1, N2, N3)
      integer(C_INTPTR_T), intent(in) :: i, j, k, N1, N2, N3

      foo = CMPLX( sin(1.1d0 * i / N1 + 1.2d0 * j / N2), cos(1.3d0 * k / N3) ,C_DOUBLE)
  end function foo

end program dp_c2c_3d

```
