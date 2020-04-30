within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model Connection2Pipe
  "Model of a connection to a collector/distributor"
  extends Networks.BaseClasses.PartialConnection2Pipe(
    redeclare model Model_pipDis =
      Buildings.Fluid.FixedResistances.LosslessPipe,
    redeclare model Model_pipCon =
      Buildings.Fluid.FixedResistances.LosslessPipe);
annotation (
Documentation(
info="<html>
<p>
This is a model of a connection with a two-pipe distribution network using 
as pipe model a fixed hydraulic resistance with no heat loss .
</p>
</html>",
revisions=
"<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Connection2Pipe;
