within Buildings.DHC.Networks;
model Distribution1Pipe_R
  "Model of a one-pipe distribution network with hydraulic diameter of main line pipes calculated from pressure drop per length"
  extends Buildings.DHC.Networks.BaseClasses.PartialDistribution1Pipe(
    tau=5*60,
    redeclare Buildings.DHC.Networks.Connections.Connection1Pipe_R
      con[nCon](
      each final dp_length_nominal=dp_length_nominal,
      final lDis=lDis,
      final dhDis=dhDis),
    redeclare model Model_pipDis = Buildings.DHC.Networks.Pipes.PipeAutosize(
        final dp_length_nominal=dp_length_nominal,
        final dh(fixed=true) = dhEnd,
        final length=lEnd),
    pipEnd(fac=1));
  parameter Real dp_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate";
  parameter Modelica.Units.SI.Length lDis[nCon]
    "Length of the distribution pipe before each connection";

  parameter Modelica.Units.SI.Length lEnd
    "Length of the end of the distribution line (after last connection)";
  final parameter Modelica.Units.SI.Length dhDis[nCon](
    each fixed=false,
    each start=0.05,
    each min=0.01)
    "Hydraulic diameter of the distribution pipe before each connection";

  final parameter Modelica.Units.SI.Length dhEnd(
    fixed=false,
    start=0.05,
    min=0.01)
    "Hydraulic diameter of of the end of the distribution line (after last connection)";
  annotation (Documentation(info="<html>
<p>
This is a model of a one-pipe distribution network using a connection model with pipes in the main line whose hydraulic diameters 
are calculated at initialization based on the pressure drop per pipe length at nominal flow rate <a href=\"modelica://Buildings.DHC.Networks.Connections.Connection1Pipe_R\">
Buildings.DHC.Networks.Connections.Connection1Pipe_R</a>. The same pipe model is also used
at the end of the distribution line (after the last connection) only on the supply side.
</p>
<h4>Modeling considerations</h4>
<p>
Note that <code>dhDis</code> needs to be vectorized, even if the same value
is computed for each array element in case of a one-pipe network.
This is because the pipe diameter is computed at initialization by the model
<a href=\"modelica://Buildings.DHC.Networks.Pipes.PipeAutosize\">
Buildings.DHC.Networks.Pipes.PipeAutosize</a>
which is instantiated for each connection.
So the initialization system of equations would be overdetermined if using
a parameter binding with a scalar variable.
</p>
</html>", revisions="<html>
<ul>
<li>
March 15, 2024, by David Blum:<br/>
Renamed.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3712\">issue 3712</a>.
</li>
<li>
December 20, 2023, by Ettore Zanetti:<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
</li>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Distribution1Pipe_R;
