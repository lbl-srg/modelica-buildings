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
  Buildings.Controls.OBC.CDL.Reals.Switch curSta
    "Current chiller stage setpoint"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt[2]
    "Real input to integer output"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch curSta1
    "Current chiller stage setpoint"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1[2]
    "Real input to integer output"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
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
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staTwo(
    final k=2) "Chiller stage index"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staOne(
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
  connect(staCha.y, curSta1.u2)
    annotation (Line(points={{-38,40},{-30,40},{-30,-80},{-22,-80}},
      color={255,0,255}));
  connect(staTwo.y, curSta1.u3)
    annotation (Line(points={{-78,-60},{-60,-60},{-60,-88},{-22,-88}},
      color={0,0,127}));
  connect(staOne.y, curSta1.u1)
    annotation (Line(points={{-78,-20},{-40,-20},{-40,-72},{-22,-72}},
      color={0,0,127}));
  connect(staOne.y, reaToInt[1].u)
    annotation (Line(points={{-78,-20},{18,-20}}, color={0,0,127}));
  connect(curSta.y, reaToInt[2].u)
    annotation (Line(points={{2,-40},{10,-40},{10,-20},{18,-20}}, color={0,0,127}));
  connect(reaToInt[1].y, staUpInd.uChiSta)
    annotation (Line(points={{42,-20},{50,-20},{50,20},{-10,20},{-10,55},{-2,55}},
      color={255,127,0}));
  connect(reaToInt[2].y, staUpInd.uStaSet)
    annotation (Line(points={{42,-20},{50,-20},{50,20},{-10,20},{-10,51},{-2,51}},
      color={255,127,0}));
  connect(staTwo.y, reaToInt1[1].u)
    annotation (Line(points={{-78,-60},{18,-60}}, color={0,0,127}));
  connect(curSta1.y, reaToInt1[2].u)
    annotation (Line(points={{2,-80},{10,-80},{10,-60},{18,-60}}, color={0,0,127}));
  connect(reaToInt1[1].y, staDowInd.uChiSta)
    annotation (Line(points={{42,-60},{72,-60},{72,55},{78,55}}, color={255,127,0}));
  connect(reaToInt1[2].y, staDowInd.uStaSet)
    annotation (Line(points={{42,-60},{72,-60},{72,51},{78,51}}, color={255,127,0}));

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
<p>
It has two instances <code>staUpInd</code> and <code>staDowInd</code>, which shows
the calculation of the chiller stage index in the staging up and staging down process.
</p>
<p>
For the instance <code>staUpInd</code>,
</p>
<ul>
<li>
Before 540 seconds, the plant is not in staging up process. The chiller stage
<code>yChiSta</code> equals previous stage setpoint, which is 1.
</li>
<li>
In the period from 540 seconds to 720 seconds, the plant is in staging up process
but the process is not yet requiring changing the condenser water pumps
(<code>uUpsDevSta=false</code>). The chiller stage <code>yChiSta</code> still
equals previous stage setpoint (1) but not yet equals the new setpoint
<code>uStaSet</code> (2).
</li>
<li>
Since the 720 seconds, the process requires changing the condenser water pumps
(<code>uUpsDevSta=true</code>). The chiller stage <code>yChiSta</code> equals the
new setpoint <code>uStaSet</code> (2).
</li>
</ul>
<p>
For the instance <code>staDowInd</code>,
</p>
<ul>
<li>
Before 540 seconds, the plant is not in staging down process. The chiller stage
<code>yChiSta</code> equals previous stage setpoint, which is 2.
</li>
<li>
In the period from 540 seconds to 720 seconds, the plant is in staging down process
but the process is not yet requiring changing the condenser water pumps
(<code>uUpsDevSta=false</code>). The chiller stage <code>yChiSta</code> still
equals previous stage setpoint (2) but not yet equals the new setpoint
<code>uStaSet</code> (1).
</li>
<li>
Since the 720 seconds, the process requires changing the condenser water pumps
(<code>uUpsDevSta=true</code>). The chiller stage <code>yChiSta</code> equals the
new setpoint <code>uStaSet</code> (1).
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 24, 2019 by Jianjun Hu:<br/>
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
