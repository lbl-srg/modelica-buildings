within Buildings.Controls.OBC.ASHRAE.G36.Atomic.Validation;
model TrimRespond "Model validates the trim and respond block"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.ASHRAE.G36.Atomic.TrimRespondLogic trimRespondLogic(
    iniSet=120,
    minSet=37,
    maxSet=370,
    delTim=300,
    timSte=120,
    numIgnReq=2,
    triAmo=-10,
    resAmo=15,
    maxRes=37) "Block implementing trim and respond logic"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    k=true) "Logic true indicating device ON"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=6,
    freqHz=1/5400) "Block generates sine signal"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Truncation tru
    "Discards the fractional portion of input and provides a whole number output"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.ASHRAE.G36.Atomic.TrimRespondLogic trimRespondLogic1(
    iniSet=120,
    minSet=37,
    maxSet=370,
    delTim=300,
    timSte=120,
    numIgnReq=2,
    triAmo=-10,
    resAmo=15,
    maxRes=37) "Block implementing trim and respond logic"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=6,
    freqHz=1/5400) "Block generates sine signal"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Truncation tru1
    "Discards the fractional portion of input and provides a whole number output"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    period=3600,
    width=0.18333333) "Generate pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Switch between two Real signals"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=0)
    "Zero request when device is OFF"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

equation
  connect(con.y, trimRespondLogic.uDevSta)
    annotation (Line(points={{41,80},{60,80},{60,68},{68,68}},
      color={255,0,255}));
  connect(sine.y, abs.u)
    annotation (Line(points={{-39,40},{-22,40}}, color={0,0,127}));
  connect(abs.y, tru.u)
    annotation (Line(points={{1,40},{18,40}}, color={0,0,127}));
  connect(tru.y, trimRespondLogic.numOfReq)
    annotation (Line(points={{41,40},{60,40},{60,52},{68,52}},
      color={255,127,0}));
  connect(abs1.y, tru1.u)
    annotation (Line(points={{21,-50},{38,-50}}, color={0,0,127}));
  connect(tru1.y, trimRespondLogic1.numOfReq)
    annotation (Line(points={{61,-50},{64,-50},{64,-38},{68,-38}},
      color={255,127,0}));
  connect(not1.y, trimRespondLogic1.uDevSta)
    annotation (Line(points={{41,-10},{64,-10},{64,-22},{68,-22}},
      color={255,0,255}));
  connect(con1.y, swi.u1)
    annotation (Line(points={{-59,-40},{-54,-40},{-54,-32},{-42,-32}},
      color={0,0,127}));
  connect(sine1.y, swi.u3)
    annotation (Line(points={{-59,-70},{-50,-70},{-50,-48},{-42,-48}},
      color={0,0,127}));
  connect(swi.y, abs1.u)
    annotation (Line(points={{-19,-40},{-10,-40},{-10,-50},{-2,-50}},
      color={0,0,127}));
  connect(booPul.y, swi.u2)
    annotation (Line(points={{-59,-10},{-50,-10},{-50,-40},{-42,-40}},
      color={255,0,255}));
  connect(booPul.y, not1.u)
    annotation (Line(points={{-59,-10},{18,-10}}, color={255,0,255}));

  annotation (experiment(StopTime=7200.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Atomic/Validation/TrimRespond.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Atomic.TrimRespondLogic\">
Buildings.Controls.OBC.ASHRAE.G36.Atomic.TrimRespondLogic</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end TrimRespond;
