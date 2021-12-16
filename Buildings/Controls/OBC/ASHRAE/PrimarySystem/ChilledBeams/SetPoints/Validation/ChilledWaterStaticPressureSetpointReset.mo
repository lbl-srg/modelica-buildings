within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeams.SetPoints.Validation;
model ChilledWaterStaticPressureSetpointReset
  "Validate chilled water static pressure setpoint reset"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeams.SetPoints.ChilledWaterStaticPressureSetpointReset
    chiWatStaPreSetRes(
    final nVal=2)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul[2](
    final period=fill(4000, 2))
    "Boolean pulse source"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin2[2](
    final amplitude=fill(0.5, 2),
    final freqHz=fill(1/1800, 2),
    final phase=fill(1.57, 2),
    final offset=fill(0.5, 2))
    "Sine signal"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

equation
  connect(booPul.y, chiWatStaPreSetRes.uPumSta) annotation (Line(points={{-38,
          30},{20,30},{20,5},{38,5}}, color={255,0,255}));
  connect(sin2.y, chiWatStaPreSetRes.uValPos) annotation (Line(points={{-38,-30},
          {20,-30},{20,-5},{38,-5}}, color={0,0,127}));
annotation (
  experiment(
      StopTime=3600,
      Interval=0.5,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChilledBeams/SetPoints/Validation/ChilledWaterStaticPressureSetpointReset.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeams.SetPoints.ChilledWaterStaticPressureSetpointReset\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeams.SetPoints.ChilledWaterStaticPressureSetpointReset</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 16, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end ChilledWaterStaticPressureSetpointReset;
