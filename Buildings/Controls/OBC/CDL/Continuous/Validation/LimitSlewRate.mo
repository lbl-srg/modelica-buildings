within Buildings.Controls.OBC.CDL.Continuous.Validation;
model LimitSlewRate "Validation model for the LimitSlewRate block"
  Buildings.Controls.OBC.CDL.Continuous.LimitSlewRate sleRatLim(
    raisingSlewRate=1/30)
    "Block that limit the increase or decrease rate of input"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    offset=0,
    height=1.5,
    duration=20,
    startTime=10)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    offset=0,
    height=-1.5,
    startTime=60,
    duration=20)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add
    "Signal adder"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp3(
    offset=0,
    height=-1.5,
    duration=30,
    startTime=120+60)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp4(
    offset=0,
    height=1.5,
    duration=30,
    startTime=120)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp5(
    offset=0,
    height=-1.5,
    startTime=240+60,
    duration=40)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp6(
    offset=0,
    height=1.5,
    startTime=240,
    duration=40)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Signal adder"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Signal adder"
    annotation (Placement(transformation(extent={{-40,-48},{-20,-28}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp7(
    offset=0,
    height=-1.5,
    duration=50,
    startTime=360+60)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp8(
    offset=0,
    height=1.5,
    duration=50,
    startTime=360)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3
    "Signal adder"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4
    "Signal adder"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add5
    "Signal adder"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add6
    "Signal adder"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(ramp1.y,add.u1)
    annotation (Line(points={{-58,110},{-46,110},{-46,96},{-42,96}},color={0,0,127}));
  connect(ramp2.y,add.u2)
    annotation (Line(points={{-58,80},{-52,80},{-52,84},{-42,84}},color={0,0,127}));
  connect(ramp4.y,add1.u1)
    annotation (Line(points={{-58,50},{-50,50},{-50,36},{-42,36}},color={0,0,127}));
  connect(ramp3.y,add1.u2)
    annotation (Line(points={{-58,20},{-50,20},{-50,24},{-42,24}},color={0,0,127}));
  connect(ramp6.y,add2.u1)
    annotation (Line(points={{-58,-20},{-50,-20},{-50,-32},{-42,-32}},color={0,0,127}));
  connect(ramp5.y,add2.u2)
    annotation (Line(points={{-58,-50},{-50,-50},{-50,-44},{-42,-44}},color={0,0,127}));
  connect(ramp8.y,add3.u1)
    annotation (Line(points={{-58,-90},{-50,-90},{-50,-104},{-42,-104}},color={0,0,127}));
  connect(ramp7.y,add3.u2)
    annotation (Line(points={{-58,-120},{-50,-120},{-50,-116},{-42,-116}},color={0,0,127}));
  connect(add.y,add4.u1)
    annotation (Line(points={{-18,90},{-12,90},{-12,66},{-2,66}},color={0,0,127}));
  connect(add1.y,add4.u2)
    annotation (Line(points={{-18,30},{-10,30},{-10,54},{-2,54}},color={0,0,127}));
  connect(add2.y,add5.u1)
    annotation (Line(points={{-18,-38},{-10,-38},{-10,-64},{-2,-64}},color={0,0,127}));
  connect(add3.y,add5.u2)
    annotation (Line(points={{-18,-110},{-12,-110},{-12,-76},{-2,-76}},color={0,0,127}));
  connect(add4.y,add6.u1)
    annotation (Line(points={{22,60},{24,60},{24,6},{38,6}},color={0,0,127}));
  connect(add5.y,add6.u2)
    annotation (Line(points={{22,-70},{24,-70},{24,-6},{38,-6}},color={0,0,127}));
  connect(sleRatLim.u,add6.y)
    annotation (Line(points={{68,0},{68,0},{62,0}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=480,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/LimitSlewRate.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.LimitSlewRate\">
Buildings.Controls.OBC.CDL.Continuous.LimitSlewRate</a>.
</p>
<p>
The input <code>ramp1.u</code> varies from <i>0</i> to <i>+1.5</i>,
in <code> 1 s</code>.
</p>
<p>
The increase and decrease rate limits are <code>[increase/incDt, -decrease/decDt] </code>, which is <code>[1, -1]</code> here.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 27, 2022, by Jianjun Hu:<br/>
Renamed the block name from SlewRateLimiter to LimitSlewRate.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2865\">issue 2865</a>.
</li>
<li>
March 29, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-100,-140},{100,140}})),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end LimitSlewRate;
