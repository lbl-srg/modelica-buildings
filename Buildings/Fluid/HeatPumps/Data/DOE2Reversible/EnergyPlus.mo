within Buildings.Fluid.HeatPumps.Data.DOE2Reversible;
record EnergyPlus = Buildings.Fluid.HeatPumps.Data.DOE2Reversible.Generic (
 COPCoo_nominal=1.5,
 dp1_nominal=30000,
 dp2_nominal=30000,
 m1_flow_nominal=0.5525,
 m2_flow_nominal=0.3525,
   hea(
    PLRMax=1.2,
    PLRMinUnl=0.3,
    PLRMin=0.3,
    capFunT={0.9415266,0.05527431,0.0003573558,0.001258391,-0.00006420546,0.0005350989},
    EIRFunT={0.2286246,0.02498714,-0.00001267106,0.009327184,0.00005892037,-0.0003268512},
    EIRFunPLR={0,1.12853,-0.0264962,-0.103811},
    QEva_flow_nominal=-12500*0.7),
  coo(
    PLRMax=1.2,
    PLRMinUnl=0.2,
    PLRMin=0.2,
    capFunT={0.950829,0.03419327,0.000266642,-0.001733397,-0.0001762417,-0.0000369198},
    EIRFunT={0.7362431,0.02136491,0.0003638909,-0.004284947,0.0003389817,-0.0003632396},
    EIRFunPLR={0,1.22895,-0.751383,0.517396},
    QEva_flow_nominal=-12500))
   "Data record for DOE2 reversible heat pump used in the EnergyPlus example file"
  annotation (
  defaultComponentName="perHP",
  defaultComponentPrefixes="parameter",
  Documentation(info= "<html>
</html>", revisions="<html>
<ul>
<li>
June 19, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
