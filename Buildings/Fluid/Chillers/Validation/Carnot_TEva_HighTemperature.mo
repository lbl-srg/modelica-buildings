within Buildings.Fluid.Chillers.Validation;
model Carnot_TEva_HighTemperature
  "Test model for Carnot_TEva with high evaporator temperature"
  extends Examples.Carnot_TEva(TEvaLvg(height=34), sou2(use_T_in=true));
  Modelica.Blocks.Sources.Ramp TEvaEnt(
    startTime=3000,
    height=38,
    offset=273.15 + 22,
    duration=60) "Control signal for evaporator entering temperature"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
equation
  connect(TEvaEnt.y, sou2.T_in) annotation (Line(points={{-39,80},{24,80},{90,80},
          {90,-2},{82,-2}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Validation/Carnot_TEva_HighTemperature.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example extends from
<a href=\"modelica://Buildings.Fluid.Chillers.Examples.Carnot_TEva\">
Buildings.Fluid.Chillers.Examples.Carnot_TEva</a>
but increases the set point for the leaving evaporator temperature
to be above its inlet temperature, in which case the model provides no cooling.
Towards the end of the simulation, the inlet temperature of the evaporator is increased
to be above the condenser temperature. In this domain, the model requires cooling
again. While this is not a meaningful operating point for the model, the example
verifies that it robustly simulates this regime.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Carnot_TEva_HighTemperature;
