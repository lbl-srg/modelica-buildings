within Buildings.Experimental.DHC.Examples.Combined.Generation5.Networks;
model UnidirectionalParallel
  "Hydronic network for unidirectional parallel DHC system"
  extends Experimental.DHC.Networks.BaseClasses.PartialDistribution2Pipe(
    tau=5*60,
    redeclare BaseClasses.ConnectionParallelAutosize con[nCon](
      each final dp_length_nominal=dp_length_nominal,
      final lDis=lDis,
      final lCon=lCon,
      final dhDis=dhDis,
      final dhDisRet=dhDisRet,
      final dhCon=dhCon),
    redeclare model Model_pipDis = BaseClasses.PipeAutosize (
      roughness=7e-6,
      fac=1.5,
      final dp_length_nominal=dp_length_nominal,
      final dh(fixed=true)=dhEnd,
      final length=2*lEnd));
  parameter Real dp_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate";
  parameter Modelica.SIunits.Length lDis[nCon]
    "Length of the distribution pipe before each connection (supply only, not counting return line)";
  parameter Modelica.SIunits.Length lCon[nCon]
    "Length of each connection pipe (supply only, not counting return line)";
  parameter Modelica.SIunits.Length lEnd
    "Length of the end of the distribution line (supply only, not counting return line)";
  parameter Modelica.SIunits.Length dhDis[nCon](
    each fixed=false,
    each start=0.05,
    each min=0.01)
    "Hydraulic diameter of the distribution pipe before each connection";
  parameter Modelica.SIunits.Length dhDisRet[nCon](
    each fixed=false,
    each start=0.05,
    each min=0.01)
    "Hydraulic diameter of the distribution pipe before each connection";
  parameter Modelica.SIunits.Length dhCon[nCon](
    each fixed=false,
    each start=0.05,
    each min=0.01)
    "Hydraulic diameter of each connection pipe";
  parameter Modelica.SIunits.Length dhEnd(
    fixed=false,
    start=0.05,
    min=0.01)
    "Hydraulic diameter of the end of the distribution line";
  annotation (Documentation(info="<html>
<p>
This model represents a two-pipe distribution network with built-in computation
of the pipe diameters based on the pressure drop per pipe length
at nominal flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end UnidirectionalParallel;
