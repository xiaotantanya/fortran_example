# Diffraction Documentation

## Contents
- [Diffraction Documentation](#diffraction-documentation)
  - [Contents](#contents)
  - [1.Purpose](#1purpose)
  - [2.Input files](#2input-files)
    - [2.1.*paramerter.system.in*](#21paramertersystemin)
    - [2.2.*parameter.atom.in*](#22parameteratomin)
    - [2.3.*phaseFra.in (optional)*](#23phasefrain-optional)
    - [2.4.*displace.in (optional)*](#24displacein-optional)
    - [2.5.*strucOrd.in (optional)*](#25strucordin-optional)
    - [2.6.*region.in (optional)*](#26regionin-optional)
  - [3.Output files](#3output-files)
  - [References](#references)

## 1.Purpose

The Q-POP-Diffraction module computes the diffraction pattern of a material microstructure predicted by phase-field simulations. It takes inputs of 
* crystal cell and atomic information 
* the real-space microstructure data described by the spatial distributions of phases, structural orders, and mechanical displacements that are generated by phase-field simulations, and outputs the corresponding diffraction intensity distribution in the reciprocal space.

Formalism of the diffraction computation can be found in Ref[^1].

## 2.Input files

The input of the program consists of 2 required input files including *`parameter.system.in`* and *`parameter.atom.in`*, and 4 optional input files including *`phaseFra.in`*, *`displace.in`*, *`strucOrd.in`*, and *`region.in`*. The choice of optional input file(s) to be provided depends on the type of the system considered.

### 2.1.*paramerter.system.in*

Declares the size of the system and the number of phases. The format is as follows:

<table style="text-align: center">
    <caption>Table 1 Format of the input file <i>parameter.system.in</i></caption>
	<tr>
	    <th colspan="3">Data in the file</th>
	    <th>Explanation</th>
	</tr >
    <tr>
    	<td colspan="3"></td>
        <td>Comment or empty line</td>
    </tr>
	<tr >
	    <td>l<sub>1</sub></td>
	    <td>l<sub>2</sub></td>
	    <td>l<sub>3</sub></td>
        <td>System size in each direction (in nm)</td>
	</tr>
    <tr >
	    <td>n<sub>1</sub></td>
	    <td>n<sub>2</sub></td>
	    <td>n<sub>3</sub></td>
        <td>Total number of simulation grids in each direction</td>
	</tr>
    <tr>
    	<td>n<sub>s</sub></td>
        <td>n<sub>f</sub></td>
        <td></td>
        <td>Thickness of the substrate and the film (in grid numbers). For a bulk system, put n<sub>s</sub> 		= n<sub>f</sub> = 0.</td>
    </tr>
    <tr>
        <td colspan="3"></td>
    	<td>Comment or empty line</td>
    </tr>
    <tr>
    	<td>N</td>
        <td></td>
        <td></td>
        <td>Total number of phases</td>
    </tr>
    <tr>
    	<td>H</td>
        <td></td>
        <td></td>
        <td>Total number of structural order parameters</td>
    </tr>
    <tr>
        <td colspan="3"></td>
        <td>Comment or empty line</td>
    </tr>
    <tr>
        <td>ε<sub>11</sub></td>
        <td>ε<sub>22</sub></td>
        <td>ε<sub>33</sub></td>
        <td rowspan="2">Average mechanical strain of the system</td>
    </tr>
    <tr>
        <td>ε<sub>23</sub></td>
        <td>ε<sub>13</sub></td>
        <td>ε<sub>12</sub></td>
    </tr>
</table>

### 2.2.*parameter.atom.in*

Declares the crystal cell and atomic information. The format is as follows:

<table style="text-align: center">
    <caption>Table 2 Format of the input file <i>parameter.atom.in</i></caption>
	<tr>
	    <th colspan="3">Data in the file</th>
	    <th colspan="2">Explanation</th>
	</tr >
    <tr>
    	<td colspan="3"></td>
        <td colspan="2">Comment or empty line</td>
    </tr>
	<tr >
	    <td>q<sub>10</sub></td>
	    <td>q<sub>20</sub></td>
	    <td>q<sub>30</sub></td>
        <td colspan="2">Reciprocal lattice point around which the diffraction pattern will be calculated (nm<sup>-1</sup>)</td>
	</tr>
    <tr >
	    <td>a<sub>1</sub></td>
	    <td>a<sub>2</sub></td>
	    <td>a<sub>3</sub></td>
        <td colspan="2">Lattice parameter a of an unstrained unit cell (nm)</td>
	</tr>
    <tr >
	    <td>b<sub>1</sub></td>
	    <td>b<sub>2</sub></td>
	    <td>b<sub>3</sub></td>
        <td colspan="2">Lattice parameter b of an unstrained unit cell (nm)</td>
	</tr>
    <tr>
        <td>N</td>
        <td></td>
        <td></td>
        <td colspan="2">Number of atoms in a unit cell</td>
    </tr>
    <tr>
        <td colspan="3"></td>
        <td colspan="2">Comment or empty line</td>
    </tr>
    <tr>
        <td>ΔR<sub>n,1</sub></td>
	    <td>ΔR<sub>n,2</sub></td>
	    <td>ΔR<sub>n,3</sub></td>
        <td colspan="2">Coordinates of the n-th atom in a unit cell (unitless). <font color="blue">This line repeats N times, in the sequence of n=1,2,…,N.</font></td> 
    </tr>
    <tr>
        <td colspan="3"></td>
        <td colspan="2">Comment or empty line</td>
    </tr>
    <tr>
        <td>m</td>
        <td></td>
        <td></td>
        <td colspan="2">Phase identifier (ID)</td>
    </tr>
    <tr>
        <td>f<sub>n,m</sub>(real)</td>
    	<td>f<sub>n,m</sub>(image)</td>
        <td></td>
        <td>Atomic form factor of the n-th atom in a unit cell of the m-th phase, real and imaginary parts (unitless). <font color="blue">This line repeats N times, in the sequence of n=1,2,…,N.</font> </td>
        <td rowspan="2"><font color="blue">This part further repeats M times, in the sequence of m=1,2,…,M. Each repetition provides the information of one phase.</font></td>
    </tr>
    <tr>
        <td>b<sub>n,m,h,1</sub></td>
        <td>b<sub>n,m,h,2</sub></td>
        <td>b<sub>n,m,h,3</sub></td>
        <td>Atomic-displacement-over-order-parameter coefficient bn,m,h of the n-th atom over the h-th order parameter, in the m-th phase. <font color="blue">This line repeats N×H times, in the sequence of (n,h)=(1,1),(1,2),…,(1,H),(2,1),…,(2,H),…,(N,H). This line is removed if H=0.</font></td>
    </tr>
</table>

We recommend the [X-ray database](https://henke.lbl.gov/optical_constants/asf.html) from Lawrence Berkeley National Laboratory [^2] for atomic form factors.

### 2.3.*phaseFra.in (optional)*

Stores an array of the spatial distribution of phase fraction $η_m (r)$ (unitless) arranged in a row-major order, where m is the phase ID with m=1,2,...,M. This file should be provided for systems with multiple phases that have different chemical compositions (M≥2). It can be obtained from phase-field simulations. The format is as follows:

<table style="text-align: center">
    <caption>Table 3 Format of the input file <i>phaseFra.in</i></caption>
	<tr>
	    <th colspan="7">Data in the file</th>
	    <th>Explanation</th>
	</tr >
    <tr>
        <td>n<sub>1</sub></td>
	    <td>n<sub>2</sub></td>
	    <td>n<sub>3</sub></td>
        <td colspan="4"></td>
        <td>Total number of simulation grids in each direction</td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td><i>η</i><sub>1</sub>(1,1,1)</td>
        <td><i>η</i><sub>2</sub>(1,1,1)</td>
        <td>...</td>
        <td><i>η</i><sub>M</sub>(1,1,1)</td>
        <td>Phase fraction <i>η</i><sub>m</sub> of the m-th phase (m=1,2,…,M) at grid point (1,1,1)</td>
    </tr>
    <tr>
        <td colspan="7"><b>⋮</b></td>
        <td><b>⋮</b></td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>n<sub>3</sub></td>
        <td><i>η</i><sub>1</sub>(1,1,n<sub>3</sub>)</td>
        <td><i>η</i><sub>2</sub>(1,1,n<sub>3</sub>)</td>
        <td>...</td>
        <td><i>η</i><sub>M</sub>(1,1,n<sub>3</sub>)</td>
        <td>Phase fraction <i>η</i><sub>m</sub> of the m-th phase (m=1,2,…,M) at grid point (1,1,n<sub>3</sub>) </td>
    </tr>
   	<tr>
        <td colspan="7"><b>⋮</b></td>
        <td><b>⋮</b></td>
    </tr>
    <tr>
        <td>1</td>
        <td>n<sub>2</sub></td>
        <td>n<sub>3</sub></td>
        <td><i>η</i><sub>1</sub>(1,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td><i>η</i><sub>2</sub>(1,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td>...</td>
        <td><i>η</i><sub>M</sub>(1,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td>Phase fraction <i>η</i><sub>m</sub> of the m-th phase (m=1,2,…,M) at grid point (1,n<sub>2</sub>,n<sub>3</sub>) </td>
    </tr>
   	<tr>
        <td colspan="7"><b>⋮</b></td>
        <td><b>⋮</b></td>
    </tr>
    <tr>
        <td>n<sub>1</sub></td>
        <td>n<sub>2</sub></td>
        <td>n<sub>3</sub></td>
        <td><i>η</i><sub>1</sub>(n<sub>1</sub>,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td><i>η</i><sub>2</sub>(n<sub>1</sub>,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td>...</td>
        <td><i>η</i><sub>M</sub>(n<sub>1</sub>,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td>Phase fraction <i>η</i><sub>m</sub> of the m-th phase (m=1,2,…,M) at grid point (n<sub>1</sub>,n<sub>2</sub>,n<sub>3</sub>) </td>
    </tr>
</table>

### 2.4.*displace.in (optional)*

Stores an array of the spatial distribution of mechanical displacement u(r) (unit: nm) arranged in a row-major order. This file should be provided for systems that show strong mechanical deformations. It can be obtained from phase-field simulations. The format is as follows:

<table style="text-align: center">
    <caption>Table 4 Format of the input file <i>displace.in</i></caption>
	<tr>
	    <th colspan="7">Data in the file</th>
	    <th>Explanation</th>
	</tr >
    <tr>
        <td>n<sub>1</sub></td>
	    <td>n<sub>2</sub></td>
	    <td>n<sub>3</sub></td>
        <td colspan="4"></td>
        <td>Total number of simulation grids in each direction</td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td><i>u</i><sub>1</sub>(1,1,1)</td>
        <td><i>u</i><sub>2</sub>(1,1,1)</td>
        <td>...</td>
        <td><i>u</i><sub>3</sub>(1,1,1)</td>
        <td>Displacement <i>u</i> at grid point (1,1,1)</td>
    </tr>
    <tr>
        <td colspan="7"><b>⋮</b></td>
        <td><b>⋮</b></td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>n<sub>3</sub></td>
        <td><i>u</i><sub>1</sub>(1,1,n<sub>3</sub>)</td>
        <td><i>u</i><sub>2</sub>(1,1,n<sub>3</sub>)</td>
        <td>...</td>
        <td><i>u</i><sub>3</sub>(1,1,n<sub>3</sub>)</td>
        <td>Displacement <i>u</i> at grid point (1,1,n<sub>3</sub>) </td>
    </tr>
   	<tr>
        <td colspan="7"><b>⋮</b></td>
        <td><b>⋮</b></td>
    </tr>
    <tr>
        <td>1</td>
        <td>n<sub>2</sub></td>
        <td>n<sub>3</sub></td>
        <td><i>u</i><sub>1</sub>(1,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td><i>u</i><sub>2</sub>(1,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td>...</td>
        <td><i>u</i><sub>3</sub>(1,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td>Displacement <i>u</i> at grid point (1,n<sub>2</sub>,n<sub>3</sub>) </td>
    </tr>
   	<tr>
        <td colspan="7"><b>⋮</b></td>
        <td><b>⋮</b></td>
    </tr>
    <tr>
        <td>n<sub>1</sub></td>
        <td>n<sub>2</sub></td>
        <td>n<sub>3</sub></td>
        <td><i>u</i><sub>1</sub>(n<sub>1</sub>,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td><i>u</i><sub>2</sub>(n<sub>1</sub>,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td>...</td>
        <td><i>u</i><sub>3</sub>(n<sub>1</sub>,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td>Displacement <i>u</i> at grid point (n<sub>1</sub>,n<sub>2</sub>,n<sub>3</sub>) </td>
    </tr>
</table>

### 2.5.*strucOrd.in (optional)*

Stores an array of the spatial distribution of structural order parameter $ζ_h (r)$ (unitless) arranged in a row-major order, where h is the structural order parameter ID with h=1,2,...,H. This file should be provided for systems possessing structural orders (H≥1). It can be obtained from phase-field simulations. The format is as follows:

<table style="text-align: center">
    <caption>Table 5 Format of the input file <i>strucOrd.in</i> </caption>
	<tr>
	    <th colspan="7">Data in the file</th>
	    <th>Explanation</th>
	</tr >
    <tr>
        <td>n<sub>1</sub></td>
	    <td>n<sub>2</sub></td>
	    <td>n<sub>3</sub></td>
        <td colspan="4"></td>
        <td>Total number of simulation grids in each direction</td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td><i>ζ</i><sub>1</sub>(1,1,1)</td>
        <td><i>ζ</i><sub>2</sub>(1,1,1)</td>
        <td>...</td>
        <td><i>ζ</i><sub>H</sub>(1,1,1)</td>
        <td>Value of the h-th order parameter <i>ζ</i><sub>H</sub> (h=1,2,...,H) at grid point (1,1,1)</td>
    </tr>
    <tr>
        <td colspan="7"><b>⋮</b></td>
        <td><b>⋮</b></td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>n<sub>3</sub></td>
        <td><i>ζ</i><sub>1</sub>(1,1,n<sub>3</sub>)</td>
        <td><i>ζ</i><sub>2</sub>(1,1,n<sub>3</sub>)</td>
        <td>...</td>
        <td><i>ζ</i><sub>H</sub>(1,1,n<sub>3</sub>)</td>
        <td>Value of the h-th order parameter <i>ζ</i><sub>H</sub> (h=1,2,...,H) at grid point (1,1,n<sub>3</sub>)</td>
    </tr>
   	<tr>
        <td colspan="7"><b>⋮</b></td>
        <td><b>⋮</b></td>
    </tr>
    <tr>
        <td>1</td>
        <td>n<sub>2</sub></td>
        <td>n<sub>3</sub></td>
        <td><i>ζ</i><sub>1</sub>(1,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td><i>ζ</i><sub>2</sub>(1,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td>...</td>
        <td><i>ζ</i><sub>H</sub>(1,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td>Value of the h-th order parameter <i>ζ</i><sub>H</sub> (h=1,2,...,H) at grid point (1,n<sub>2</sub>,n<sub>3</sub>) </td>
    </tr>
   	<tr>
        <td colspan="7"><b>⋮</b></td>
        <td><b>⋮</b></td>
    </tr>
    <tr>
        <td>n<sub>1</sub></td>
        <td>n<sub>2</sub></td>
        <td>n<sub>3</sub></td>
        <td><i>ζ</i><sub>1</sub>(n<sub>1</sub>,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td><i>ζ</i><sub>2</sub>(n<sub>1</sub>,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td>...</td>
        <td><i>ζ</i><sub>H</sub>(n<sub>1</sub>,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td>Value of the h-th order parameter <i>ζ</i><sub>H</sub> (h=1,2,...,H) at grid point (n<sub>1</sub>,n<sub>2</sub>,n<sub>3</sub>) </td>
    </tr>
</table>

### 2.6.*region.in (optional)*

Stores an array of the spatial distribution of a weight parameter *g*(r) (unitless) arranged in a row-major order, describing the selected real-space region the diffraction of which should be computed. *g*=0~1, where *g*(r)=1 indicates that the spatial point r is fully inside the computed region and *g*(r)=0 indicates that the spatial point r is outside the region. A diffuse boundary of the region is allowed by using a finite *g* with 0<*g*<1, meaning that the spatial point r is partially inside the computed region with a weight of *g*. If this file is omitted, the program takes a default region for the diffraction computation and then stores the corresponding *g*(r) data in an output file `region.00000000.dat`. The format of *region.in* is as follows:

<table style="text-align: center">
    <caption>Table 6 Format of the input file <i>region.in</i> </caption>
	<tr>
	    <th colspan="4">Data in the file</th>
	    <th>Explanation</th>
	</tr >
    <tr>
        <td>n<sub>1</sub></td>
	    <td>n<sub>2</sub></td>
	    <td>n<sub>3</sub></td>
        <td></td>
        <td>Total number of simulation grids in each direction</td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>1</td>
        <td><i>g</i>(1,1,1)</td>
        <td>Weight parameter <i>g</i> at grid point (1,1,1) </td>
    </tr>
    <tr>
        <td colspan="4"><b>⋮</b></td>
        <td><b>⋮</b></td>
    </tr>
    <tr>
        <td>1</td>
        <td>1</td>
        <td>n<sub>3</sub></td>
        <td><i>g</i>(1,1,n<sub>3</sub>)</td>
        <td>Weight parameter <i>g</i> at grid point (1,1,n<sub>3</sub>)</td>
    </tr>
   	<tr>
        <td colspan="4"><b>⋮</b></td>
        <td><b>⋮</b></td>
    </tr>
    <tr>
        <td>1</td>
        <td>n<sub>2</sub></td>
        <td>n<sub>3</sub></td>
        <td><i>g</i>(1,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td>Weight parameter <i>g</i> at grid point (1,n<sub>2</sub>,n<sub>3</sub>) </td>
    </tr>
   	<tr>
        <td colspan="4"><b>⋮</b></td>
        <td><b>⋮</b></td>
    </tr>
    <tr>
        <td>n<sub>1</sub></td>
        <td>n<sub>2</sub></td>
        <td>n<sub>3</sub></td>
        <td><i>g</i>(n<sub>1</sub>,n<sub>2</sub>,n<sub>3</sub>)</td>
        <td>Weight parameter <i>g</i> at grid point (n<sub>1</sub>,n<sub>2</sub>,n<sub>3</sub>) </td>
    </tr>
</table>

## 3.Output files

The program outputs 4 files as follows.
* `I.00000000.dat` : Stores an array of the diffraction intensity *I*(q) (unitless), arranged in a row-major order.
* `lg_{10}I.00000000.dat` : Stores an array of $log_{10}$*I*(q)(unitless), arranged in a row-major order.
* `QVector.00000000.dat` : Stores an array of the reciprocal space vectors $q_1$, $q_2$, and $q_3$ ($nm^{−1}$) of the computed diffraction intensity *I*(q), arranged in a row-major order.
* `region.00000000.dat` : Stores an array of the weight parameter g(r) (unitless) arranged in a row-major order. For the definition of g(r), see Section 2.6. The data follow a same format with those in *`region.in`*. This output file is generated only if *`region.in`* is not provided.

## References

[^1]: T. Yang et al. Computing diffraction patterns of microstructures from phase-field simulations. Acta Mater. 239, 118258 (2022).
[^2]: B.L. Henke, E.M. Gullikson, and J.C. Davis. X-ray interactions: photoabsorption, scattering, transmission, and reflection at E=50-30000 eV, Z=1-92, At. Data Nucl. Data Tables 54, 181 (1993).
