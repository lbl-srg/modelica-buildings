within Buildings.Experimental.DHC.Networks;
model Distribution2Pipe
  "Model of a two-pipe distribution network, using fixed resistance pipe model"
  extends Buildings.Experimental.DHC.Networks.BaseClasses.PartialDistribution2Pipe(
    redeclare Connection2Pipe con[nCon](
      final dpDis_nominal=dpDis_nominal),
    redeclare model Model_pipDis=Fluid.FixedResistances.LosslessPipe);
  parameter Modelica.Units.SI.PressureDifference dpDis_nominal[nCon]
    "Pressure drop in distribution line (supply only, not counting return line)"
    annotation (Dialog(tab="General", group="Nominal condition"));
  annotation (
    Documentation(
      info="<html>
<p>
This is a model of a two-pipe distribution network using
</p>
<ul>
<li>
a connection model with fixed hydraulic resistance with no heat loss as a pipe
model in the main line, and
</li>
<li>
a dummy pipe model with no hydraulic resistance and no heat loss for the end of
the distribution line (after the last connection). 
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Distribution2Pipe;
