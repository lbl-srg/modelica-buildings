within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Networks;
model UnidirectionalSeries
  "Hydraulic network for unidirectional series DHC system"
  extends DHC.Networks.BaseClasses.PartialDistribution1Pipe(
    redeclare BaseClasses.ConnectionSeriesAutosize con[nCon](
      each final dp_length_nominal=dp_length_nominal,
      final lDis=lDis,
      final lCon=lCon,
      final dhDis=dhDis,
      final dhCon=dhCon),
    redeclare model Model_pipDis = BaseClasses.PipeAutosize (
      final dp_length_nominal=dp_length_nominal,
      final dh=dhEnd,
      final length=lEnd));
  parameter Real dp_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate";
  parameter Modelica.SIunits.Length lDis[nCon]
    "Length of the distribution pipe before each connection";
  parameter Modelica.SIunits.Length lCon[nCon]
    "Length of each connection pipe (supply only, not counting return line)";
  parameter Modelica.SIunits.Length lEnd
    "Length of the end of the distribution line (after last connection)";
  parameter Modelica.SIunits.Length dhDis[nCon](
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
    "Hydraulic diameter of of the end of the distribution line (after last connection)";
  annotation (Documentation(info="<html>
<p>
Note that <code>dhDis</code> needs to be vectorized, even if the same value 
is computed for each array element in case of a series network. 
This is because the same class  
Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Networks.BaseClasses.ConnectionSeriesAutosize
is used for all connections, so the initialzation system of equations
would be overdetermined if using a scalar variable.
</p>
</html>"));
end UnidirectionalSeries;
