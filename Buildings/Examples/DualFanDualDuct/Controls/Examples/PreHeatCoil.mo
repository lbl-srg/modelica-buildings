within Buildings.Examples.DualFanDualDuct.Controls.Examples;
model PreHeatCoil "Test model for preheat coil controller"
extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Constant TSupSet(k=273.15 + 16)
    "Set point for supply air temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Constant TAirSup(k=273.15 + 15)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Trapezoid TMix(
    amplitude=15,
    rising=900,
    width=900,
    falling=900,
    period=3600,
    offset=273.15 + 5) "Mixed air temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Examples.DualFanDualDuct.Controls.PreHeatCoil preHeatCoil
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation

  connect(TMix.y, preHeatCoil.TMix) annotation (Line(points={{-59,70},{-30,70},{
          -30,6},{-1,6}}, color={0,0,127}));
  connect(preHeatCoil.TSupSetHea, TSupSet.y) annotation (Line(points={{-1,0},{-24,
          0},{-50,0},{-50,40},{-59,40}}, color={0,0,127}));
  connect(preHeatCoil.TAirSup, TAirSup.y) annotation (Line(points={{-1,-6},{-54,
          -6},{-54,-10},{-59,-10}}, color={0,0,127}));
  annotation (
   __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DualFanDualDuct/Controls/Examples/PreHeatCoil.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6, StopTime=10800),
    Documentation(info="<html>
<p>
Test model for the preheat coil controller.
</p>
</html>", revisions="<html>
<ul>
<li>
March 15, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PreHeatCoil;
