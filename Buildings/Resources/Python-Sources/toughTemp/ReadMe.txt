July 15, 2021
--------------
Files included
--------------
MESHVmat1j       Ordered mesh file
C01RH1j          Ordered INCON file
C02RHmj.inp      INFILE w/ GENER included to indicate relative 
                   thickness of layers
readsave.inp     Information Modelica needs for reading TOUGH SAVE file
writeincon.inp   Information MOdelica needs for writing TOUGH INCON file
                   (includes dummy entries for Modelica-supplied information)

-------------
Model Extent
-------------
x: 0 to 3 m (one-half problem by symmetry)
y: 0 to 21 m
z: 0 (top) to -200 m (bottom)

--------------------------------
Rectangular Grid Discretization
--------------------------------
Lateral grid spacing 0.25 m, 12 elements in x, 84 elements in y
Layer thickness varies from 0.5 to 40 m; most of vadose zone has 2.5 m thick
layers; max borehole-layer thickness is 10 m; 40 layers
Total number of elements = 40*84*12 + 1 (surface element) = 40321

Borehole is at x=0.125 m, y=11.88 m, z=-1 to -101 m.

Layer Thicknesses (m): 
above borehole
0.5       0.5       
borehole
1.0       1.5       2.5       2.5       2.5     
2.5       2.5       2.5       2.5       2.5       2.5       2.5       2.5
2.5       2.5       2.5       2.5       2.5       2.5       2.5       2.5
2.5       2.5       2.5       2.5       5.0       5.0       10.0      10.0
5.0       5.0       
below borehole
5.0       5.0       10.0      10.0      10.0      20.0      40.0


-------------------
Boundary Conditions
-------------------
Pressure is held fixed at min and max y values.
Model is closed at min and max x values.
Flow is from large y to small y, driven by boundary P values (set in a
separate step and supplied in INCON file C04RH1j).
Top layer P is held fixed at P = 1 atm and RH=0.5; Modelica to supply
variable surface temperature.
Bottom layer is closed to fluid flow, but T is held fixed at initial T to 
maintain geothermal gradient.
 
---------------------------------------------------------------------------
Interesting Point Locations for Monitoring
---------------------------------------------------------------------------
El_Name  x (m)   y (m)   z (m)   Comment
---------------------------------------------------------------------------
Near borehole in x
A4j 6    1.375   11.12   -1.5    top of borehole,    downgradient of borehole
AOj 6    1.375   11.12   -49.75  capillary fringe,   downgradient of borehole
AYj 6    1.375   11.12   -98.5   bottom of borehole, downgradient of borehole
A4p 6    1.375   12.62   -1.5    top of borehole,    upgradient of borehole
AOp 6    1.375   12.62   -49.75  capillary fringe,   upgradient of borehole
AYp 6    1.375   12.62   -98.5   bottom of borehole, upgradient of borehole
Far from borehole in x
A4j12    2.875   11.12   -1.5    top of borehole,    downgradient of borehole
AOj12    2.875   11.12   -49.75  capillary fringe,   downgradient of borehole
A4p12    2.875   12.62   -1.5    top of borehole,    upgradient of borehole
AOp12    2.875   12.62   -49.75  capillary fringe,   upgradient of borehole
---------------------------------------------------------------------------


