within Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses;
model Connection2PipeLossless
  "Model of a lossless connection to a collector/distributor"
  extends Buildings.Experimental.DHC.Networks.BaseClasses.PartialConnection2Pipe(
    redeclare model Model_pipDisSup =
        Buildings.Fluid.FixedResistances.LosslessPipe,
    redeclare model Model_pipDisRet =
        Buildings.Fluid.FixedResistances.LosslessPipe,
    redeclare model Model_pipCon=Buildings.Fluid.FixedResistances.LosslessPipe);
  annotation (
    Documentation(
      info="<html>
<p>
This is a model of a connection for a two-pipe system using 
a pipe model with no flow resistance, no heat loss and no transport delay. 
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Connection2PipeLossless;
