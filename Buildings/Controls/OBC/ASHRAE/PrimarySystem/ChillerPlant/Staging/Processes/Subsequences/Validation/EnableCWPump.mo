within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model EnableCWPump
  "Validate sequence of generating stage index for CW pump control"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableCWPump
    staUpInd "Generating chiller stage index when there is stage up command"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableCWPump
    staDowInd "Generating chiller stage index when there is stage down command"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Switch curSta "Current chiller stage"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt "Real input to integer output"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch curSta1 "Current chiller stage"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1 "Real input to integer output"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not staCha "Stage change command"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.20,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not upsDevSta "Upstream device status"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(
    final k=false)
    "No stage change"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staTwo(
    final k=2) "Chiller stage index"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staOne(
    final k=1) "Chiller stage index"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

equation
  connect(booPul.y, staCha.u)
    annotation (Line(points={{-78,40},{-62,40}}, color={255,0,255}));
  connect(booPul1.y, upsDevSta.u)
    annotation (Line(points={{-78,80},{-62,80}}, color={255,0,255}));
  connect(upsDevSta.y, staUpInd.uUpsDevSta)
    annotation (Line(points={{-38,80},{-20,80},{-20,68},{-2,68}},
      color={255,0,255}));
  connect(staCha.y, staUpInd.uStaUp)
    annotation (Line(points={{-38,40},{-30,40},{-30,62},{-2,62}},
      color={255,0,255}));
  connect(fal.y, staUpInd.uStaDow)
    annotation (Line(points={{-38,0},{-20,0},{-20,58},{-2,58}},
      color={255,0,255}));
  connect(upsDevSta.y, staDowInd.uUpsDevSta)
    annotation (Line(points={{-38,80},{60,80},{60,68},{78,68}},
      color={255,0,255}));
  connect(fal.y, staDowInd.uStaUp)
    annotation (Line(points={{-38,0},{60,0},{60,62},{78,62}},
      color={255,0,255}));
  connect(staCha.y, staDowInd.uStaDow)
    annotation (Line(points={{-38,40},{66,40},{66,58},{78,58}},
      color={255,0,255}));
  connect(staCha.y, curSta.u2)
    annotation (Line(points={{-38,40},{-30,40},{-30,-40},{-22,-40}},
      color={255,0,255}));
  connect(staTwo.y, curSta.u1)
    annotation (Line(points={{-78,-60},{-60,-60},{-60,-32},{-22,-32}},
      color={0,0,127}));
  connect(staOne.y, curSta.u3)
    annotation (Line(points={{-78,-20},{-40,-20},{-40,-48},{-22,-48}},
      color={0,0,127}));
  connect(curSta.y, reaToInt.u)
    annotation (Line(points={{2,-40},{18,-40}}, color={0,0,127}));
  connect(reaToInt.y, staUpInd.uChiSta)
    annotation (Line(points={{42,-40},{60,-40},{60,-20},{-14,-20},{-14,52},
      {-2,52}}, color={255,127,0}));
  connect(staCha.y, curSta1.u2)
    annotation (Line(points={{-38,40},{-30,40},{-30,-80},{-22,-80}},
      color={255,0,255}));
  connect(curSta1.y, reaToInt1.u)
    annotation (Line(points={{2,-80},{18,-80}}, color={0,0,127}));
  connect(reaToInt1.y, staDowInd.uChiSta)
    annotation (Line(points={{42,-80},{72,-80},{72,52},{78,52}}, color={255,127,0}));
  connect(staTwo.y, curSta1.u3)
    annotation (Line(points={{-78,-60},{-60,-60},{-60,-88},{-22,-88}},
      color={0,0,127}));
  connect(staOne.y, curSta1.u1)
    annotation (Line(points={{-78,-20},{-40,-20},{-40,-72},{-22,-72}},
      color={0,0,127}));

annotation (
 experiment(StopTime=3600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/EnableCWPump.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableCWPump\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableCWPump</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 24, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}})));
end EnableCWPump;
