within Buildings.Experimental.DHC.Examples.Combined.Generation5.Networks;
model UnidirectionalSeries
  "Hydronic network for unidirectional series DHC system"
  extends DHC.Networks.BaseClasses.PartialDistribution1Pipe(
    tau=5*60,
    redeclare BaseClasses.ConnectionSeriesAutosize con[nCon](
      each final dp_length_nominal=dp_length_nominal,
      final lDis=lDis,
      final lCon=lCon,
      final dhDis=dhDis,
      final dhCon=dhCon),
    redeclare model Model_pipDis = BaseClasses.PipeAutosize (
      roughness=7e-6,
      fac=1.5,
      final dp_length_nominal=dp_length_nominal,
      final dh(fixed=true)=dhEnd,
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
    "Hydraulic diameter of of the end of the distribution line (after last connection)";
  annotation (Documentation(info="<html>
<p>
This model represents a one-pipe distribution network with built-in computation
of the pipe diameter based on the pressure drop per pipe length
at nominal flow rate.
</p>
<h4>Modeling considerations</h4>
<p>
Note that <code>dhDis</code> needs to be vectorized, even if the same value
is computed for each array element in case of a one-pipe network.
This is because the pipe diameter is computed at initialization by the model
<a href=\"Buildings.Experimental.DHC.Examples.Combined.Generation5.Networks.BaseClasses.ConnectionSeriesAutosize\">
Buildings.Experimental.DHC.Examples.Combined.Generation5.Networks.BaseClasses.ConnectionSeriesAutosize</a>
which is instantiated for each connection.
So the initialization system of equations would be overdetermined if using
a parameter binding with a scalar variable.
</p>
</html>", revisions="<html>
<ul>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end UnidirectionalSeries;
