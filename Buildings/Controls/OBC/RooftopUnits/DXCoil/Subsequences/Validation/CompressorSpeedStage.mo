within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Validation;
model CompressorSpeedStage
  "Validate sequence for compressor speed using cooling coil valve postion and previous enable signals"

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.CompressorSpeedStage ComSpeSta(
    dTHys(displayUnit="K") = 1,
    minComSpe=0.1,
    maxComSpe=1)
    "Compressor speed control for DX coil staging signal"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.5,
    final period=3600,
    final shift=1800)
    "Previous enable signal"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pulCoi1(
    final amplitude=1,
    final width=0.5,
    final period=450)
    "Coil valve position"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.9,
    final period=3600,
    final shift=30)
    "Coil proven on signal signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(booPul.y, ComSpeSta.uPreDXCoi) annotation (Line(points={{-18,40},{0,40},
          {0,6},{18,6}}, color={255,0,255}));
  connect(booPul1.y, ComSpeSta.uDXCoi)
    annotation (Line(points={{-18,0},{18,0}}, color={255,0,255}));
  connect(pulCoi1.y, ComSpeSta.uCoi) annotation (Line(points={{-18,-40},{0,-40},
          {0,-5.8},{18,-5.8}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/DXCoil/Subsequences/Validation/CompressorSpeedStage.mos"
    "Simulate and plot"),
    Documentation(info="<html>
    <p>
    This is a validation model for the controller
    <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.CompressorSpeedStage\">
    Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.CompressorSpeedStage</a>. 
    </p>
    <p>
    Simulation results are observed as follows: 
    <ul>
    <li>
    When the previously enabled DX coil signal is false <code>booPul.y = false</code>, 
    the controller maps a compressor's minimum speed 
    <code>ComSpeSta.minComSpe</code> of 0.1 and maximum speed <code>ComSpeSta.maxComSpe</code> 
    of 1 to a lower cooling coil valve position signal <code>ComSpeSta.conCooCoiLow</code> of 0.2 and a higher one 
    <code>ComSpeSta.conCooCoiHig</code> of 0.8 from the cooling coil signal <code>ramCooCoi.y</code>. 
    </li>
    <li>
    When <code>booPul.y = true</code>, the controller outputs <code>ComSpeSta.yComSpe=1</code>. 
    </li>
    </ul>
    </p>
    </html>",revisions="<html>
    <ul>
    <li>
    August 7, 2023, by Junke Wang and Karthik Devaprasad:<br/>
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
