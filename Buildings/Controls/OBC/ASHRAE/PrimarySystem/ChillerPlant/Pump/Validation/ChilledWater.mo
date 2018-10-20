within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.Validation;
model ChilledWater
  "Validate the chilled water pump control sequence"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.ChilledWater chiWatPum(
      VEva_nominal=2.5) "Chilled water pump controller"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uPla(k=true)
    "Plant status"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatPumSet(k=12000)
    "Chilled water pump pressure difference setpoint"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWatPum(
    freqHz=1/1800,
    amplitude=500,
    offset=12000)
                 "Measured chilled water pump pressure"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatFlo(freqHz=1/3600, offset=1)
    "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

equation
  connect(dpChiWatPum.y, chiWatPum.dpChiWatPum)
    annotation (Line(points={{-59,-20},{0,-20},{0,-4},{38,-4}},
                                                              color={0,0,127}));
  connect(dpChiWatPumSet.y, chiWatPum.dpChiWatPumSet)
    annotation (Line(points={{-59,-70},{20,-70},{20,-8},{38,-8}}, color={0,0,127}));
  connect(chiWatFlo.y, chiWatPum.VEva_flow)
    annotation (Line(points={{-59,30},{0,30},{0,4},{38,4}},       color={0,0,127}));

  connect(uPla.y, chiWatPum.uPla) annotation (Line(points={{-59,70},{20,70},{20,
          8},{38,8}}, color={255,0,255}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Pump/Validation/ChilledWater.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.ChilledWater\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.ChilledWater</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 12, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChilledWater;
