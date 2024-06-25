within Buildings.Fluid.Geothermal.ZonedBorefields.Validation.FEFLOW;
model MassFlowRatePulse
  "Comparative model validation with FEFLOW for a response to a pulse in inlet mass flow rate"
  extends Buildings.Fluid.Geothermal.ZonedBorefields.Validation.FEFLOW.Pulse(
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
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/ZonedBorefields/Validation/FEFLOW/MassFlowRatePulse.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This validation cases compares the outlet temperature of a borefield with two
zones against the temperatures that were calculated with the FEFLOW software.
The mass flow rate in both zones is a pulse function.
</p>
<p>
fixme: revise
The temperatures <code>TOut</code> are the leaving water temperatures from FEFLOW,
computed with FEFLOW's analytical solution for the borehole heat transfer.
Comparing <code>TOut</code> with the temperatures <code>TBorFieOut</code>
shows good agreement except at the initial transient at the start of the
simulation when the mass flow rate changes from zero to the design flow rate.
The leaving water temperatures at this initial transient
show similar discrepancies as the comparison of FEFLOW's analytical and
numerical solutions that is presented in the FEFLOW white paper (DHI-WASY 2010).
In the FEFLOW white paper, it is explained that the reason for this difference is
due to the FEFLOW's analytical solution not being valid for such short-time dynamics.
Therefore, the validation of the Modelica implementation is satisfactory.
</p>
<h5>References</h5>
<p>
DHI-WASY Software FEFLOW. Finite Element Subsurface Flow &amp; Transport Simulation System.
White Paper Vol. V.
DHI-WASY GmbH. Berlin 2010.
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
end MassFlowRatePulse;
