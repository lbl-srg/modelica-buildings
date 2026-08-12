within Buildings.Fluid.Geothermal.ZonedBorefields.Examples;
model SeriesConnectedZonesDarcyPressureDropVariableTemperature
  "Validation of temperature-dependent Darcy-Weisbach pressure drop"
  extends Buildings.Fluid.Geothermal.ZonedBorefields.Examples.SeriesConnectedZones(
    borHol(
      use_detailedPressureDrop=true,
      fluidProperties=Buildings.Fluid.Types.FluidProperties.ActualTemperature,
      use_TDepRConv=false),
    conDat(
      roughness=0.001e-3));

  Modelica.Units.SI.MassFlowRate m_flow = pum.m_flow
    "Mass flow rate through the zoned borefield";

  Modelica.Units.SI.PressureDifference dpBorFie =
    TBorFieIn.port_b.p - TBorFieOut.port_a.p
    "Pressure drop across the zoned borefield";

  Modelica.Units.SI.Temperature TIn = TBorFieIn.T
    "Borefield inlet temperature";

  Modelica.Units.SI.Temperature TOut = TBorFieOut.T
    "Borefield outlet temperature";

  annotation (
    experiment(StopTime=2592000, Tolerance=1e-6),
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/ZonedBorefields/Examples/SeriesConnectedZonesDarcyPressureDropVariableTemperature.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates temperature-dependent Darcy-Weisbach pressure drop in a
zoned borefield.
</p>
<p>
The Darcy-Weisbach pressure-drop calculation is enabled by setting
<code>use_DarcyPressureDrop=true</code> on the zoned borefield model instance.
Temperature-dependent density and viscosity for the pressure-drop calculation
are enabled with <code>use_TDepPressureDrop=true</code>.
</p>
<p>
The fluid type is derived from the redeclared <code>Medium</code>. No separate
fluid-property selector is used in the configuration data record.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2026, by Lone Meertens:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>
for the Darcy-Weisbach pressure-drop implementation and
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4483\">Buildings, #4483</a>
for temperature-dependent fluid properties.
</li>
</ul>
</html>"));
end SeriesConnectedZonesDarcyPressureDropVariableTemperature;
