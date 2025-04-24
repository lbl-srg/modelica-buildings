within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Validation;
model StageUpDown
  "Validate sequence for staging up and down DX coils"

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.StageUpDown DXCoiSta(
    final nCoi=1,
    final dUHys=0.01,
    final dTHys(displayUnit="K") = 1)
    "DX coil staging up and down"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold nexDXCoi(
    final trueHoldDuration=120)
    "Hold pulse signal for easy visualization"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold preDXCoi(
    final trueHoldDuration=120)
    "Hold pulse signal for easy visualization"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pulCoi(
    final amplitude=0.9,
    final width=0.6,
    final period=1800,
    final shift=0,
    final offset=0.1)
    "Coil valve position"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Maintain DX coil status till the conditions to change it are met"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Feedback delay"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramComSpe(
    final height=1,
    final duration=1800,
    startTime=600)
    "Compressor speed ratio"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=DXCoiSta.nCoi)
    "Replicate speed signal for number of coils"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

equation
  connect(DXCoiSta.yUp, nexDXCoi.u) annotation (Line(points={{-8,6},{0,6},{0,50},
          {18,50}}, color={255,0,255}));
  connect(DXCoiSta.yDow, preDXCoi.u) annotation (Line(points={{-8,-6},{0,-6},{0,
          -50},{18,-50}}, color={255,0,255}));
  connect(pulCoi.y, DXCoiSta.uCoi)
    annotation (Line(points={{-58,0},{-32,0}}, color={0,0,127}));
  connect(DXCoiSta.yUp, lat.u)
    annotation (Line(points={{-8,6},{0,6},{0,0},{18,0}}, color={255,0,255}));
  connect(lat.y, pre1.u)
    annotation (Line(points={{42,0},{58,0}}, color={255,0,255}));
  connect(pre1.y, DXCoiSta.uDXCoi[1]) annotation (Line(points={{82,0},{90,0},{90,
          72},{-50,72},{-50,6},{-32,6}}, color={255,0,255}));
  connect(DXCoiSta.yDow, lat.clr)
    annotation (Line(points={{-8,-6},{18,-6}}, color={255,0,255}));
  connect(ramComSpe.y, reaScaRep.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={0,0,127}));
  connect(reaScaRep.y, DXCoiSta.uComSpe) annotation (Line(points={{-18,-40},{-10,
          -40},{-10,-20},{-46,-20},{-46,-6},{-32,-6}}, color={0,0,127}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/DXCoil/Subsequences/Validation/StageUpDown.mos"
    "Simulate and plot"),
    Documentation(info="<html>
    <p>
    This is a validation model for the controller
    <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.StageUpDown\">
    Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.StageUpDown</a>. 
    </p>
    <p>
    Simulation results are observed as follows: 
    <ul>
    <li>
    When the coil valve position <code>DXCoiSta.uCoi</code> exceeds the threshold 
    <code>DXCoiSta.uThrCoiUp</code> set at 0.8 for a duration of <code>DXCoiSta.timPerUp</code> 
    amounting to 480 seconds, and no changes in DX coil status <code>DXCoiSta.uDXCoi[1]</code> 
    are detected, the controller initiates staging up of the DX coil <code>nexDXCoi.y=true</code>. 
    </li>
    <li>
    When the compressor speed ratio <code>DXCoiSta.uComSpe</code> falls below the threshold 
    <code>DXCoiSta.uThrCoiDow</code> set at 0.2  for a duration of <code>DXCoiSta.timPerDow</code> 
    amounting to 180 seconds, and no changes in <code>DXCoiSta.uDXCoi[1]</code> are detected, 
    the controller initiates staging down of the DX coil <code>preDXCoi.y=true</code>. 
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
end StageUpDown;
