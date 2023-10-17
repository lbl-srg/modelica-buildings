within Buildings.Experimental.DHC.Networks;
model Distribution2PipeAutoSize
  "Hydronic network for unidirectional parallel DHC system"
  extends
    Buildings.Experimental.DHC.Networks.BaseClasses.PartialDistribution2Pipe(
    tau=5*60,
    redeclare
      Buildings.Experimental.DHC.Networks.Connections.Connection2PipeAutosize
      con[nCon](
      each final dp_length_nominal=dp_length_nominal,
      final lDis=lDis,
      final lCon=lCon,
      final dhDis=dhDis,
      final dhDisRet=dhDisRet,
      final dhCon=dhCon),
    redeclare model Model_pipDis =
        Buildings.Experimental.DHC.Networks.Pipes.PipeAutosize (
        roughness=7e-6,
        fac=1.5,
        final dp_length_nominal=dp_length_nominal,
        final dh(fixed=true) = dhEnd,
        final length=2*lEnd));
  parameter Real dp_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate";
  parameter Modelica.Units.SI.Length lDis[nCon]
    "Length of the distribution pipe before each connection (supply only, not counting return line)";
  parameter Modelica.Units.SI.Length lCon[nCon]
    "Length of each connection pipe (supply only, not counting return line)";
  parameter Modelica.Units.SI.Length lEnd
    "Length of the end of the distribution line (supply only, not counting return line)";
  parameter Modelica.Units.SI.Length dhDis[nCon](
    each fixed=false,
    each start=0.05,
    each min=0.01)
    "Hydraulic diameter of the distribution pipe before each connection";
  parameter Modelica.Units.SI.Length dhDisRet[nCon](
    each fixed=false,
    each start=0.05,
    each min=0.01)
    "Hydraulic diameter of the distribution pipe before each connection";
  parameter Modelica.Units.SI.Length dhCon[nCon](
    each fixed=false,
    each start=0.05,
    each min=0.01) "Hydraulic diameter of each connection pipe";
  parameter Modelica.Units.SI.Length dhEnd(
    fixed=false,
    start=0.05,
    min=0.01) "Hydraulic diameter of the end of the distribution line";
  annotation (Documentation(info="<html>
<p>
This is a model of a two-pipe distribution network using
</p>
<ul>
<li>
a connection model with an auto-sized pipe in the main line whose hydraulic diameter is calculated at initialization based on the pressure drop per pipe length
at nominal flow rate, and
</li>
<li>
a dummy pipe model with no hydraulic resistance and no heat loss for the end of
the distribution line (after the last connection).
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Distribution2PipeAutoSize;
