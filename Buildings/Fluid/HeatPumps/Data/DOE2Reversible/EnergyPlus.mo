within Buildings.Fluid.HeatPumps.Data.DOE2Reversible;
record EnergyPlus =
 Buildings.Fluid.HeatPumps.Data.DOE2Reversible.Generic (
    dpHeaSou_nominal=30000,
    dpHeaLoa_nominal=30000,
    hea(
      PLRMax=1.2,
      PLRMinUnl=0.3,
      PLRMin=0.3,
      CapFunT={0.9415266,0.05527431,0.0003573558, 0.001258391,-0.00006420546, 0.0005350989},
      EIRFunT={0.2286246,0.02498714,-0.00001267106,0.009327184,0.00005892037,-0.0003268512},
      EIRFunPLR={0,1.12853,-0.0264962,-0.103811}),
    coo(
      Q_flow=-12500,
      COP_nominal=1.5,
      mLoa_flow=0.5525,
      mSou_flow=0.3525,
      PLRMax=1.2,
      PLRMinUnl=0.2,
      PLRMin=0.2,
      CapFunT={0.950829,0.03419327,0.000266642,-0.001733397,-0.0001762417,-0.0000369198},
      EIRFunT={0.7362431,0.02136491,0.0003638909,-0.004284947,0.0003389817,-0.0003632396},
      EIRFunPLR={0,1.22895,-0.751383,0.517396}))
   "Data record for DOE2 reversible heat pump used in EnergyPlus example file"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  defaultComponentName="EPdataHP",
  defaultComponentPrefixes="parameter",
  Documentation(info= "<html>
<p>
This data corresponds to the EnergyPlus example file <code>GSHPSimple-GLHE.idf</code>
from EnergyPlus 9.1, with a nominal cooling capacity of <i>39890</i> Watts and
nominal heating capacity of <i>39040</i> Watt.
</p>
</html>", revisions="<html>
<ul>
<li>
June 19, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
