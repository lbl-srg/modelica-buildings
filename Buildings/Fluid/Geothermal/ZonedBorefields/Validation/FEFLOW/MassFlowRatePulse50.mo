within Buildings.Fluid.Geothermal.ZonedBorefields.Validation.FEFLOW;
model MassFlowRatePulse50
  "Comparative model validation with FEFLOW for a response to a pulse in inlet mass flow rate"
  extends Buildings.Fluid.Geothermal.ZonedBorefields.Validation.FEFLOW.MassFlowRatePulse100(
    redeclare Modelica.Blocks.Sources.Pulse m_flow(
      amplitude=0.5*borFieDat.conDat.mZon_flow_nominal,
      each period=3600*24*10,
      offset=0.5*borFieDat.conDat.mZon_flow_nominal,
      each startTime=0),
      TOut(
        fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/Geothermal/ZonedBorefields/Validation/FEFLOW/MassFlowRatePulse.txt")));

  annotation (
  Diagram(coordinateSystem(extent={{-100,-60},{140,80}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/ZonedBorefields/Validation/FEFLOW/MassFlowRatePulse50.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This validation cases compares the outlet temperature of a borefield with two
zones against the temperatures that were calculated with the FEFLOW software.
The mass flow rate in both zones is a pulse function.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 24, 2024, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=15465600,
      Tolerance=1e-06));
end MassFlowRatePulse50;
