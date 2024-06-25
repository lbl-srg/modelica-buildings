within Buildings.Fluid.Geothermal.ZonedBorefields.Validation.FEFLOW;
model MassFlowRateStep100 "Comparative model validation with FEFLOW for a step response"
  extends Buildings.Fluid.Geothermal.ZonedBorefields.Validation.FEFLOW.MassFlowRatePulse100(
    redeclare Modelica.Blocks.Sources.Step m_flow(
      height=borFieDat.conDat.mZon_flow_nominal,
      each offset=0,
      each startTime=0),
      TOut(
        fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/Geothermal/ZonedBorefields/Validation/FEFLOW/Step.txt")));

  annotation (
  Diagram(coordinateSystem(extent={{-100,-60},{140,80}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/ZonedBorefields/Validation/FEFLOW/MassFlowRateStep100.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This validation cases compares the outlet temperature of a borefield with two
zones against the temperatures that were calculated with the FEFLOW software.
The mass flow rate in both zones is a step function.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 24, 2024, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=15465600,
      Tolerance=1e-06));
end MassFlowRateStep100;
