within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.Validation;
model TrimAndRespond "Model validates the trim and respond block"
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond
    trimRespondLogic(
    final iniSet=120,
    final minSet=37,
    final maxSet=370,
    final delTim=300,
    final samplePeriod=120,
    final numIgnReq=2,
    final triAmo=-10,
    final resAmo=15,
    final maxRes=37) "Block implementing trim and respond logic"
    annotation (Placement(transformation(extent={{70,60},{90,80}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond
    trimRespondLogic1(
    final iniSet=120,
    final minSet=37,
    final maxSet=370,
    final delTim=300,
    final samplePeriod=120,
    final numIgnReq=2,
    final triAmo=10,
    final resAmo=-15,
    final maxRes=-37) "Block implementing trim and respond logic"
    annotation (Placement(transformation(extent={{70,10},{90,30}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond
    trimRespondLogic2(
    final iniSet=120,
    final minSet=37,
    final maxSet=370,
    final delTim=300,
    final samplePeriod=120,
    final numIgnReq=2,
    final triAmo=-10,
    final resAmo=15,
    final maxRes=37) "Block implementing trim and respond logic"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) "Logic true indicating device ON"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sine(
    final amplitude=6,
    final freqHz=1/5400) "Block generates sine signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-52,40},{-32,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sine1(
    final amplitude=6,
    freqHz=1/5400) "Block generates sine signal"
    annotation (Placement(transformation(extent={{-88,-90},{-68,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=3600,
    final width=0.18333333) "Generate pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{-88,-20},{-68,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Switch between two Real signals"
    annotation (Placement(transformation(extent={{-48,-50},{-28,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(final k=0)
    "Zero request when device is OFF"
    annotation (Placement(transformation(extent={{-88,-50},{-68,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Round round2(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Reals.Round round1(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

equation
  connect(con.y, trimRespondLogic.uDevSta)
    annotation (Line(points={{42,90},{50,90},{50,78},{68,78}},
      color={255,0,255}));
  connect(sine.y, abs.u)
    annotation (Line(points={{-58,50},{-54,50}}, color={0,0,127}));
  connect(not1.y,trimRespondLogic2. uDevSta)
    annotation (Line(points={{42,-10},{60,-10},{60,-22},{68,-22}},
      color={255,0,255}));
  connect(con1.y, swi.u1)
    annotation (Line(points={{-66,-40},{-62,-40},{-62,-32},{-50,-32}},
      color={0,0,127}));
  connect(sine1.y, swi.u3)
    annotation (Line(points={{-66,-80},{-58,-80},{-58,-48},{-50,-48}},
      color={0,0,127}));
  connect(swi.y, abs1.u)
    annotation (Line(points={{-26,-40},{-20,-40},{-20,-80},{-12,-80}},
      color={0,0,127}));
  connect(booPul.y, swi.u2)
    annotation (Line(points={{-66,-10},{-58,-10},{-58,-40},{-50,-40}},
      color={255,0,255}));
  connect(booPul.y, not1.u)
    annotation (Line(points={{-66,-10},{18,-10}}, color={255,0,255}));
  connect(abs.y, round2.u)
    annotation (Line(points={{-30,50},{-22,50}}, color={0,0,127}));
  connect(round2.y, reaToInt1.u)
    annotation (Line(points={{2,50},{18,50}}, color={0,0,127}));
  connect(reaToInt1.y, trimRespondLogic.numOfReq)
    annotation (Line(points={{42,50},{60,50},{60,62},{68,62}},
      color={255,127,0}));
  connect(abs1.y, round1.u)
    annotation (Line(points={{12,-80},{18,-80}},color={0,0,127}));
  connect(round1.y, reaToInt2.u)
    annotation (Line(points={{42,-80},{50,-80},{50,-60},{8,-60},{8,-40},
      {18,-40}}, color={0,0,127}));
  connect(reaToInt2.y,trimRespondLogic2. numOfReq)
    annotation (Line(points={{42,-40},{60,-40},{60,-38},{68,-38}},
      color={255,127,0}));
  connect(con.y,trimRespondLogic1. uDevSta)
    annotation (Line(points={{42,90},{50,90},{50,28},{68,28}}, color={255,0,255}));
  connect(reaToInt1.y,trimRespondLogic1. numOfReq)
    annotation (Line(points={{42,50},{60,50},{60,12},{68,12}}, color={255,127,0}));

annotation (experiment(StopTime=7200.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/Generic/SetPoints/Validation/TrimAndRespond.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond</a>.
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
