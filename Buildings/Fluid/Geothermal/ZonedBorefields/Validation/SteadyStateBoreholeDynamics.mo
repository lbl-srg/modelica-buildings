within Buildings.Fluid.Geothermal.ZonedBorefields.Validation;
model SteadyStateBoreholeDynamics "Description"
  extends Buildings.Fluid.Geothermal.ZonedBorefields.Validation.TransientBoreholeDynamics(
    borHol(
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial),
      filDat(
        steadyState=true));

  annotation (
  Diagram(coordinateSystem(extent={{-100,-60},{140,80}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/ZonedBorefields/Validation/SteadyStateBoreholeDynamics.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This validation cases tests the independent operation of borefield zones for the
borefield configured in
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Validation\">
Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Validation</a>.
</p>
<p>
The model assumes no dynamics in the boreholes. The heating rate to a zone is
constant (when activated). The duration of heat injection into each zone is a
multiple of 1 month, with alternating signals to each zone to obtain all
possible combinations of activated and deactivated zones.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=31536000,
      Tolerance=1e-06));
end SteadyStateBoreholeDynamics;
