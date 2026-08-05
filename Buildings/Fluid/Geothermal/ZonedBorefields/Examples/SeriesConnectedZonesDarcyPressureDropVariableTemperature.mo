within Buildings.Fluid.Geothermal.ZonedBorefields.Examples;
model SeriesConnectedZonesDarcyPressureDropVariableTemperature
  "Validation of temperature-dependent Darcy-Weisbach pressure drop"
  extends Buildings.Fluid.Geothermal.ZonedBorefields.Examples.SeriesConnectedZones(
    conDat(
      use_DarcyPressureDrop=true,
      use_TDepPressureDrop=true,
      use_TDepRConv=false,
      fluidPropertyEvaluation=
        Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.Water,
      X_a=0,
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
