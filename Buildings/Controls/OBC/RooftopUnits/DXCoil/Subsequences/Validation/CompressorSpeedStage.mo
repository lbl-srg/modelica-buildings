within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Validation;
model CompressorSpeedStage
  "Validate sequence for compressor speed using cooling coil valve postion and previous enable signals"

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.CompressorSpeedStage ComSpeSta(
    conCooCoiLow=0.2,
    conCooCoiHig=0.8,
    minComSpe=0.1,
    maxComSpe=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P)
    "Compressor speed control for DX coil staging signal"
    annotation (Placement(transformation(extent={{20,-12},{40,8}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    width=0.5,
    period=3600,
    shift=1800)
    "Previous enable signal"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=1,
    duration=1800)
    "Cooling coil valve position"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

equation
  connect(booPul.y, ComSpeSta.uPreDXCoi) annotation (Line(points={{-18,30},
          {0,30},{0,3.8},{18,3.8}}, color={255,0,255}));
  connect(ram.y, ComSpeSta.uCooCoi) annotation (Line(points={{-18,-30},{0,-30},{
          0,-8},{18,-8}}, color={0,0,127}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/DXCoil/Subsequences/Validation/CompressorSpeedStage.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Validation.CompressorSpeedStage\">
Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Validation.CompressorSpeedStage</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 13, 2022, by Junke Wang and Karthik Devaprasad:<br/>
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
              points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end CompressorSpeedStage;
