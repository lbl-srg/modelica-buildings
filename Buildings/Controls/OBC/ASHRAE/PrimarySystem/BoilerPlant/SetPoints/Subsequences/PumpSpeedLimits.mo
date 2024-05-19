within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences;
block PumpSpeedLimits
    "Sequence to calculate pump speed limits from regulation signal"

  parameter Boolean have_varPriPum = true
    "True: Variable speed pumps in primary loop; False: Constant speed pumps in primary loop";

  parameter Integer nSta = 5
    "Number of stages"
    annotation(Evaluate=true,Dialog(enable=have_varPriPum));

  parameter Real minSecPumSpe(
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1) = 0
    "Minimum secondary pump speed";

  parameter Real minPriPumSpeSta[nSta](
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1) = {0,0,0,0,0}
    "Vector of minimum primary pump speed for each stage"
    annotation(Evaluate=true,Dialog(enable=have_varPriPum));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCurSta if have_varPriPum
    "Current stage"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRegSig(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Regulation signal from proportional regulator"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinPriPumSpe(
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1) if have_varPriPum
    "Minimum allowed primary pump speed"
    annotation (Placement(transformation(extent={{100,10},{140,50}}),
      iconTransformation(extent={{100,30},{140,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMaxSecPumSpe(
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1)
    "Maximum allowed secondary pump speed"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-70},{140,-30}})));

protected
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai2(
    final k=-1) if have_varPriPum
    "Invert signal for subtraction"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar2(
    final p=-0.5) if have_varPriPum
    "Extract secondary pump signal from regulation signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Reals.Limiter lim1(
    final uMax=0.5,
    final uMin=0) if have_varPriPum
    "Limit signal between 0 and 0.5"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(
    final k=2) if have_varPriPum
    "Multiply signal by 2"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar3(
    final p=1) if have_varPriPum
    "Generate secondary pump setpoint signal from regulation signal"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=1) if not have_varPriPum
    "Generate secondary pump setpoint signal from regulation signal"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Limiter lim2(
    final uMax=1,
    final uMin=0) if not have_varPriPum
    "Limit signal between 0 and 1"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Limiter lim(
    final uMax=0.5,
    final uMin=0) if have_varPriPum
    "Limit signal between 0 and 0.5"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=2) if have_varPriPum
    "Multiply signal by 2"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro if have_varPriPum
    "Normalize regulation signal in terms of pump speed"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Buildings.Controls.OBC.CDL.Reals.Add add2 if have_varPriPum
    "Add minimum pump speed value to normalized regulation signal"
    annotation (Placement(transformation(extent={{30,20},{50,40}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(
    final p=1) if have_varPriPum
    "Subtract minimum primary pump speed from 1"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig1(
    final nin=nSta) if have_varPriPum
    "Identify minimum primary pump speed for current stage"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2[nSta](
    final k=minPriPumSpeSta) if have_varPriPum
    "Source signal for B-MinPriPumpSpdStage"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai3(
    final k=minSecPumSpe - 1) if have_varPriPum
    "Normalize signal for subtraction"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai4(
    final k=minSecPumSpe - 1) if not have_varPriPum
    "Normalize signal for subtraction"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

equation

  connect(uRegSig, addPar2.u) annotation (Line(points={{-120,0},{-62,0}},
                     color={0,0,127}));

  connect(addPar2.y, lim1.u)
    annotation (Line(points={{-38,0},{-32,0}},   color={0,0,127}));

  connect(lim1.y, gai1.u)
    annotation (Line(points={{-8,0},{-2,0}}, color={0,0,127}));

  connect(addPar3.y, yMaxSecPumSpe) annotation (Line(points={{82,0},{120,0}},
                       color={0,0,127}));

  connect(addPar.y, yMaxSecPumSpe) annotation (Line(points={{82,-40},{90,-40},{90,
          0},{120,0}}, color={0,0,127}));

  connect(uRegSig, lim2.u) annotation (Line(points={{-120,0},{-90,0},{-90,-40},{
          -32,-40}}, color={0,0,127}));

  connect(uRegSig, lim.u) annotation (Line(points={{-120,0},{-90,0},{-90,30},{-62,
          30}}, color={0,0,127}));

  connect(lim.y, gai.u)
    annotation (Line(points={{-38,30},{-32,30}}, color={0,0,127}));

  connect(con2.y, extIndSig1.u)
    annotation (Line(points={{-68,80},{-62,80}}, color={0,0,127}));

  connect(add2.u2, pro.y) annotation (Line(points={{28,24},{26,24},{26,30},{22,30}},
        color={0,0,127}));

  connect(gai.y, pro.u2) annotation (Line(points={{-8,30},{-6,30},{-6,24},{-2,24}},
        color={0,0,127}));

  connect(uCurSta, extIndSig1.index)
    annotation (Line(points={{-120,50},{-50,50},{-50,68}}, color={255,127,0}));

  connect(add2.y, yMinPriPumSpe)
    annotation (Line(points={{52,30},{120,30}}, color={0,0,127}));

  connect(addPar1.y, pro.u1) annotation (Line(points={{42,80},{50,80},{50,66},{-6,
          66},{-6,36},{-2,36}},
                   color={0,0,127}));
  connect(extIndSig1.y, add2.u1) annotation (Line(points={{-38,80},{-36,80},{
          -36,60},{26,60},{26,36},{28,36}}, color={0,0,127}));
  connect(extIndSig1.y, gai2.u)
    annotation (Line(points={{-38,80},{-22,80}}, color={0,0,127}));
  connect(gai2.y, addPar1.u)
    annotation (Line(points={{2,80},{18,80}}, color={0,0,127}));
  connect(gai1.y, gai3.u)
    annotation (Line(points={{22,0},{28,0}}, color={0,0,127}));
  connect(gai3.y, addPar3.u)
    annotation (Line(points={{52,0},{58,0}}, color={0,0,127}));
  connect(lim2.y, gai4.u)
    annotation (Line(points={{-8,-40},{18,-40}}, color={0,0,127}));
  connect(gai4.y, addPar.u)
    annotation (Line(points={{42,-40},{58,-40}}, color={0,0,127}));
  annotation (defaultComponentName="pumSpeLim",
    Icon(graphics={
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        lineThickness=0.1),
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={28,108,200},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        lineThickness=5,
        borderPattern=BorderPattern.Raised),
      Text(
        extent={{-120,146},{100,108}},
        textColor={0,0,255},
        textString="%name"),
      Ellipse(
        extent={{-80,80},{80,-80}},
        lineColor={28,108,200},
        fillColor={170,255,213},
        fillPattern=FillPattern.Solid)},
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
  Diagram(
    coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}})),
  Documentation(
info="<html>
<p>
Block that generates pump speed limits for condensation control
in non-condensing boilers according to RP-1711, March, 2020 draft, sections
5.3.5.3, 5.3.5.4, 5.3.5.5 and 5.3.5.6.
</p>
<p>
The maximum allowed secondary pump speed <code>yMaxSecPumSpe</code> is calculated
as follows:
</p>
<ol>
<li>
if the primary pumps are constant speed <code>have_varPriPum=false</code>, 
<code>yMaxSecPumSpe</code> is reset from 100% pump speed at 0% of regulation
signal <code>uRegSig</code> to minimum pump speed <code>minSecPumSpe</code>
at 100% of <code>uRegSig</code>.    
</li>
<li>
if the primary pumps are variable speed <code>have_varPriPum=true</code>,
<code>yMaxSecPumSpe</code> is reset from 100% pump speed at 50% of <code>uRegSig</code>
to <code>minSecPumSpe</code> at 100% of <code>uRegSig</code>.
</li>
</ol>
<p>
If <code>have_varPriPum=true</code>, the minimum allowed primary pump speed
<code>yMinPriPumSpe</code> is calculated as follows:
</p>
<ul>
<li>
<code>yMinPriPumSpe</code> is reset from <code>minPriPumSpeSta</code> at 0%
of <code>uRegSig</code> to 100% pump speed at 100% of <code>uRegSig</code>.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
July 22, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end PumpSpeedLimits;
