within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Networks;
model UnidirectionalParallel
  "Hydraulic network for unidirectional parallel DHC system"
  extends Experimental.DHC.Networks.BaseClasses.PartialDistribution2Pipe(
    redeclare BaseClasses.ConnectionParallelAutosize con[nCon](
      each final dp_length_nominal=dp_length_nominal,
      final lDis=lDis,
      final lCon=lCon,
      final dhDis=dhDis,
      final dhDisRet=dhDisRet,
      final dhCon=dhCon),
    redeclare model Model_pipDis = BaseClasses.PipeAutosize (
      final dp_length_nominal=dp_length_nominal,
      final dh=dhEnd,
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
    each start=0.2,
    each min=0.01)
    "Hydraulic diameter of the distribution pipe before each connection";
  parameter Modelica.SIunits.Length dhDisRet[nCon](
    each fixed=false,
    each start=0.2,
    each min=0.01)
    "Hydraulic diameter of the distribution pipe before each connection";
  parameter Modelica.SIunits.Length dhCon[nCon](
    each fixed=false,
    each start=0.2,
    each min=0.01)
    "Hydraulic diameter of each connection pipe";
  parameter Modelica.SIunits.Length dhEnd(
    fixed=false,
    start=0.2,
    min=0.01)
    "Hydraulic diameter of the end of the distribution line";
end UnidirectionalParallel;
