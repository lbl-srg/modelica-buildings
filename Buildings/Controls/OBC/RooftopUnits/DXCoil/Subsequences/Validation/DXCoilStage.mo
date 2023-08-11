within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Validation;
model DXCoilStage
  "Validate sequence for staging up and down DX coil using coil valve postion signal"

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.DXCoilStage DXCoiSta(
    nCoi=1,
    uThrCoi=0.8,
    uThrCoi1=0.2,
    dUHys=0.01,
    timPer=480,
    timPer1=180)
    "DX coil staging up and down"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold nexDXCoi(
    final trueHoldDuration=10)
    "Hold pulse signal for easy visualization"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold preDXCoi(
    final trueHoldDuration=10)
    "Hold pulse signal for easy visualization"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pulCoi(
    final amplitude=0.7,
    final width=0.6,
    final period=1800,
    shift=0,
    final offset=0.15) "Coil valve position"
    annotation (Placement(transformation(extent={{-90,-16},{-70,4}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Maintain DX coil status till the conditions to change it are met"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Feedback delay"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));

equation
  connect(DXCoiSta.yUp, nexDXCoi.u) annotation (Line(points={{-28,6},{-10,
          6},{-10,50},{-2,50}},
                    color={255,0,255}));
  connect(DXCoiSta.yDow, preDXCoi.u) annotation (Line(points={{-28,-6},{
          -10,-6},{-10,-50},{-2,-50}},
                          color={255,0,255}));
  connect(pulCoi.y, DXCoiSta.uCoi)
    annotation (Line(points={{-68,-6},{-52,-6}}, color={0,0,127}));
  connect(DXCoiSta.yUp, lat.u)
    annotation (Line(points={{-28,6},{-10,6},{-10,0},{-2,0}},
                                                         color={255,0,255}));
  connect(lat.y, pre1.u)
    annotation (Line(points={{22,0},{48,0}}, color={255,0,255}));
  connect(pre1.y, DXCoiSta.uDXCoi[1]) annotation (Line(points={{72,0},{80,0},{
          80,72},{-60,72},{-60,6},{-52,6}}, color={255,0,255}));
  connect(DXCoiSta.yDow, lat.clr)
    annotation (Line(points={{-28,-6},{-2,-6}},color={255,0,255}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/DXCoil/Subsequences/Validation/DXCoilStage.mos"
    "Simulate and plot"),
    Documentation(info="<html>
    <p>
    This is a validation model for the controller
    <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.DXCoilStage\">
    Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.DXCoilStage</a>. 
    </p>
    <p>
    Simulation results are observed as follows: 
    <ul>
    <li>
    When the coil valve position <code>pulCoi.y</code> exceeds the threshold 
    <code>DXCoiSta.uThrCoi</code> set at 0.8 for a duration of <code>DXCoiSta.timPer</code> 
    amounting to 480 seconds, and no changes in DX coil status <code>DXCoiSta.uDXCoi[1]</code> 
    are detected, the controller initiates staging up of the DX coil <code>nexDXCoi.y=true</code>. 
    </li>
    <li>
    When <code>pulCoi.y</code> falls below the threshold <code>DXCoiSta.uThrCoi1</code> set at 0.2 
    for a duration of <code>DXCoiSta.timPer</code> amounting to 180 seconds, and no changes 
    in <code>DXCoiSta.uDXCoi[1]</code> are detected, the controller initiates staging down 
    of the DX coil <code>preDXCoi.y=true</code>. 
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
end DXCoilStage;
