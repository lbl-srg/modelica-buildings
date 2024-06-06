within Buildings.Controls.OBC.ASHRAE.G36.Generic.Validation;
model TrimAndRespond "Model validates the trim and respond block"
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond trimRespondLogic(
    final iniSet=120,
    final minSet=37,
    final maxSet=370,
    final delTim=300,
    final samplePeriod=120,
    final numIgnReq=2,
    final triAmo=-10,
    final resAmo=15,
    final maxRes=37)
    "Block implementing trim and respond logic – Case with negative trim amount"
    annotation (Placement(transformation(extent={{70,40},{90,60}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond trimRespondLogic1(
    final iniSet=120,
    final minSet=37,
    final maxSet=370,
    final delTim=300,
    final samplePeriod=120,
    final numIgnReq=2,
    final triAmo=10,
    final resAmo=-15,
    final maxRes=-37)
    "Block implementing trim and respond logic – Case with positive trim amount"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond trimRespondLogic2(
    final iniSet=120,
    final minSet=37,
    final maxSet=370,
    final delTim=300,
    final samplePeriod=120,
    final numIgnReq=2,
    final triAmo=-10,
    final resAmo=15,
    final maxRes=37) "Block implementing trim and respond logic"
    annotation (Placement(transformation(extent={{70,-60},{90,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) "Logic true indicating device ON"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sine(
    final amplitude=6,
    final freqHz=1/5400) "Block generates sine signal"
    annotation (Placement(transformation(extent={{-82,20},{-62,40}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-54,20},{-34,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sine1(
    final amplitude=6,
    freqHz=1/5400) "Block generates sine signal"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=3600,
    final width=0.18333333) "Generate pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Switch between two Real signals"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(final k=0)
    "Zero request when device is OFF"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Round round2(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Reals.Round round1(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  CDL.Logical.Sources.TimeTable
                            hol(
    table=[0,0; 5,1; 10,0; 15,1; 16,0],
    timeScale=100,
    final period=2000)
               "Source for hold signal"
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond trimRespondLogicHold(
    have_hol=true,
    final iniSet=120,
    final minSet=37,
    final maxSet=370,
    final delTim=300,
    final samplePeriod=120,
    final numIgnReq=2,
    final triAmo=-10,
    final resAmo=15,
    final maxRes=37,
    dtHol=300)
    "Block implementing trim and respond logic  – Case with hold signal"
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
equation
  connect(con.y, trimRespondLogic.uDevSta)
    annotation (Line(points={{42,70},{50,70},{50,58},{68,58}},
      color={255,0,255}));
  connect(sine.y, abs.u)
    annotation (Line(points={{-60,30},{-56,30}}, color={0,0,127}));
  connect(not1.y,trimRespondLogic2. uDevSta)
    annotation (Line(points={{42,-30},{60,-30},{60,-42},{68,-42}},
      color={255,0,255}));
  connect(con1.y, swi.u1)
    annotation (Line(points={{-68,-60},{-64,-60},{-64,-52},{-52,-52}},
      color={0,0,127}));
  connect(sine1.y, swi.u3)
    annotation (Line(points={{-68,-100},{-60,-100},{-60,-68},{-52,-68}},
      color={0,0,127}));
  connect(swi.y, abs1.u)
    annotation (Line(points={{-28,-60},{-20,-60},{-20,-100},{-12,-100}},
      color={0,0,127}));
  connect(booPul.y, swi.u2)
    annotation (Line(points={{-68,-30},{-60,-30},{-60,-60},{-52,-60}},
      color={255,0,255}));
  connect(booPul.y, not1.u)
    annotation (Line(points={{-68,-30},{18,-30}}, color={255,0,255}));
  connect(abs.y, round2.u)
    annotation (Line(points={{-32,30},{-22,30}}, color={0,0,127}));
  connect(round2.y, reaToInt1.u)
    annotation (Line(points={{2,30},{18,30}}, color={0,0,127}));
  connect(reaToInt1.y, trimRespondLogic.numOfReq)
    annotation (Line(points={{42,30},{60,30},{60,42},{68,42}},
      color={255,127,0}));
  connect(abs1.y, round1.u)
    annotation (Line(points={{12,-100},{18,-100}},
                                                color={0,0,127}));
  connect(round1.y, reaToInt2.u)
    annotation (Line(points={{42,-100},{50,-100},{50,-80},{8,-80},{8,-60},{18,
          -60}}, color={0,0,127}));
  connect(reaToInt2.y,trimRespondLogic2. numOfReq)
    annotation (Line(points={{42,-60},{60,-60},{60,-58},{68,-58}},
      color={255,127,0}));
  connect(con.y,trimRespondLogic1. uDevSta)
    annotation (Line(points={{42,70},{50,70},{50,8},{68,8}},   color={255,0,255}));
  connect(reaToInt1.y,trimRespondLogic1. numOfReq)
    annotation (Line(points={{42,30},{60,30},{60,-8},{68,-8}}, color={255,127,0}));

  connect(con.y, trimRespondLogicHold.uDevSta) annotation (Line(points={{42,70},
          {50,70},{50,108},{68,108}},  color={255,0,255}));
  connect(reaToInt1.y, trimRespondLogicHold.numOfReq) annotation (Line(points={{42,30},
          {60,30},{60,92},{68,92}},            color={255,127,0}));
  connect(hol.y[1], trimRespondLogicHold.uHol)
    annotation (Line(points={{-68,100},{68,100}}, color={255,0,255}));
annotation (experiment(StopTime=7200.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Generic/Validation/TrimAndRespond.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond\">
Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 28, 2019, by Jianjun Hu:<br/>
Added more validation of negative response amount.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1530\">#1503</a>.
</li>
<li>
July 10, 2017, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})));
end TrimAndRespond;
