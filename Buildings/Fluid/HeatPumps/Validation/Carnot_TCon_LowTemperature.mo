within Buildings.Fluid.HeatPumps.Validation;
model Carnot_TCon_LowTemperature
  "Test model for Carnot_TCon with low condenser leaving water temperature"
  extends Examples.Carnot_TCon(TConLvg(height=-32), sou1(use_T_in=true));
  Modelica.Blocks.Sources.Ramp TConEnt(
    duration=60,
    offset=273.15 + 20,
    startTime=3000,
    height=-19) "Control signal for condenser entering temperature"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
equation
  connect(TConEnt.y, sou1.T_in)
    annotation (Line(points={{-69,10},{-62,10}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/Carnot_TCon_LowTemperature.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example extends from
<a href=\"modelica://Buildings.Fluid.HeatPumps.Examples.Carnot_TCon\">
Buildings.Fluid.HeatPumps.Examples.Carnot_TCon</a>
but decreases the set point for the leaving condenser temperature
to be below its inlet temperature, in which case the model provides no heating.
Towards the end of the simulation, the inlet temperature of the condenser is decreased
to be below the evaporator temperature. In this domain, the model requires cooling
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
end Carnot_TCon_LowTemperature;
