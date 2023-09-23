within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Validation;
model CompressorSpeedStage
  "Validate sequence for compressor speed using cooling coil valve postion and previous enable signals"

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.CompressorSpeedStage ComSpeSta(
    dTHys(displayUnit="K") = 1,
    minComSpe=0.1,
    maxComSpe=1)
    "Compressor speed control for DX coil staging signal"
    annotation (Placement(transformation(extent={{20,-8},{40,12}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.5,
    final period=3600,
    final shift=1800)
    "Previous enable signal"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramCooCoi(final height=1,
      final duration=1800) "Cooling coil valve position"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  CDL.Continuous.Sources.Pulse                        pulCoi1(
    final amplitude=3,
    final width=0.3,
    final period=450,
    shift=450,
    final offset=-1.5) "Coil valve position"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  CDL.Logical.Sources.Pulse                        booPul1(
    final width=0.9,
    final period=3600,
    final shift=30) "Coil proven on signal signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(booPul.y, ComSpeSta.uPreDXCoi) annotation (Line(points={{-18,30},{0,
          30},{0,8},{18,8}},        color={255,0,255}));

  connect(ramCooCoi.y, ComSpeSta.uCoi) annotation (Line(points={{-18,-30},{4,
          -30},{4,0},{18,0}}, color={0,0,127}));
  connect(pulCoi1.y, ComSpeSta.TSupCoiDif) annotation (Line(points={{-18,-70},{
          10,-70},{10,-4},{18,-4}}, color={0,0,127}));
  connect(booPul1.y, ComSpeSta.uDXCoi)
    annotation (Line(points={{-18,0},{2,0},{2,4},{18,4}}, color={255,0,255}));
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
