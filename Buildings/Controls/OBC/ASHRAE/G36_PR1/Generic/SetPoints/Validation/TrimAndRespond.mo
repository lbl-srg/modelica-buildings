within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.Validation;
model TrimAndRespond "Model validates the trim and respond block"
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond trimRespondLogic(
    iniSet=120,
    minSet=37,
    maxSet=370,
    delTim=300,
    samplePeriod=120,
    numIgnReq=2,
    triAmo=-10,
    resAmo=15,
    maxRes=37) "Block implementing trim and respond logic"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    k=true) "Logic true indicating device ON"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    amplitude=6,
    freqHz=1/5400) "Block generates sine signal"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond trimRespondLogic1(
    iniSet=120,
    minSet=37,
    maxSet=370,
    delTim=300,
    samplePeriod=120,
    numIgnReq=2,
    triAmo=-10,
    resAmo=15,
    maxRes=37) "Block implementing trim and respond logic"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
    amplitude=6,
    freqHz=1/5400) "Block generates sine signal"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    period=3600,
    width=0.18333333) "Generate pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Switch between two Real signals"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=0)
    "Zero request when device is OFF"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

equation
  connect(con.y, trimRespondLogic.uDevSta)
    annotation (Line(points={{41,80},{60,80},{60,68},{68,68}},
      color={255,0,255}));
  connect(sine.y, abs.u)
    annotation (Line(points={{-79,40},{-62,40}}, color={0,0,127}));
  connect(not1.y, trimRespondLogic1.uDevSta)
    annotation (Line(points={{41,-10},{64,-10},{64,-22},{68,-22}},
      color={255,0,255}));
  connect(con1.y, swi.u1)
    annotation (Line(points={{-79,-40},{-74,-40},{-74,-32},{-62,-32}},
      color={0,0,127}));
  connect(sine1.y, swi.u3)
    annotation (Line(points={{-79,-70},{-70,-70},{-70,-48},{-62,-48}},
      color={0,0,127}));
  connect(swi.y, abs1.u)
    annotation (Line(points={{-39,-40},{-30,-40},{-30,-70},{-22,-70}},
      color={0,0,127}));
  connect(booPul.y, swi.u2)
    annotation (Line(points={{-79,-10},{-70,-10},{-70,-40},{-62,-40}},
      color={255,0,255}));
  connect(booPul.y, not1.u)
    annotation (Line(points={{-79,-10},{18,-10}}, color={255,0,255}));
  connect(abs.y, round2.u)
    annotation (Line(points={{-39,40},{-22,40}}, color={0,0,127}));
  connect(round2.y, reaToInt1.u)
    annotation (Line(points={{1,40},{18,40}}, color={0,0,127}));
  connect(reaToInt1.y, trimRespondLogic.numOfReq)
    annotation (Line(points={{41,40},{60,40},{60,52},{68,52}},
      color={255,127,0}));
  connect(abs1.y, round1.u)
    annotation (Line(points={{1,-70},{18,-70}}, color={0,0,127}));
  connect(round1.y, reaToInt2.u)
    annotation (Line(points={{41,-70},{50,-70},{50,-52},{8,-52},{8,-40},
      {18,-40}}, color={0,0,127}));
  connect(reaToInt2.y, trimRespondLogic1.numOfReq)
    annotation (Line(points={{41,-40},{54,-40},{54,-38},{68,-38}},
      color={255,127,0}));

annotation (experiment(StopTime=7200.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/Generic/SetPoints/Validation/TrimAndRespond.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end TrimAndRespond;
