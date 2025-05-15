within Buildings.DHC.Plants.Combined.Controls.BaseClasses;
block HoursToNextWarmup "Number of hours to next warmup period"
  parameter Integer warUpStaHou=4
    "Warmup period beginning hour";

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Hours to next warmup period"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.CivilTime civTim
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Reals.Modulo mod1
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=24*3600)
    "24 hours in seconds"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant warUpBeg(
    final k=warUpStaHou)
    "Warmup period beginning hour"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre
    "Later than the beginning hour of the warmup period"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=3600)
    "Convert to seconds"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=24)
    "Add constant"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(
    final k=1/3600)
    "Gain factor"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Find difference"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Find difference"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));

equation
  connect(civTim.y, mod1.u1) annotation (Line(points={{-78,20},{-70,20},{-70,6},
          {-42,6}}, color={0,0,127}));
  connect(con.y, mod1.u2) annotation (Line(points={{-78,-20},{-70,-20},{-70,-6},
          {-42,-6}}, color={0,0,127}));
  connect(mod1.y, gre.u1)
    annotation (Line(points={{-18,0},{-2,0}}, color={0,0,127}));
  connect(gre.y, swi.u2)
    annotation (Line(points={{22,0},{78,0}}, color={255,0,255}));
  connect(warUpBeg.y, gai.u) annotation (Line(points={{-78,-60},{-60,-60},{-60,-40},
          {-42,-40}}, color={0,0,127}));
  connect(gai.y, gre.u2) annotation (Line(points={{-18,-40},{-10,-40},{-10,-8},{
          -2,-8}}, color={0,0,127}));
  connect(warUpBeg.y, addPar.u) annotation (Line(points={{-78,-60},{-60,-60},{-60,
          80},{-42,80}}, color={0,0,127}));
  connect(mod1.y, gai1.u) annotation (Line(points={{-18,0},{-10,0},{-10,40},{-2,
          40}}, color={0,0,127}));
  connect(gai1.y, sub.u2) annotation (Line(points={{22,40},{30,40},{30,54},{38,54}},
        color={0,0,127}));
  connect(addPar.y, sub.u1) annotation (Line(points={{-18,80},{20,80},{20,66},{38,
          66}}, color={0,0,127}));
  connect(warUpBeg.y, sub1.u1) annotation (Line(points={{-78,-60},{-60,-60},{-60,
          -74},{38,-74}}, color={0,0,127}));
  connect(gai1.y, sub1.u2) annotation (Line(points={{22,40},{30,40},{30,-86},{38,
          -86}}, color={0,0,127}));
  connect(sub.y, swi.u1)
    annotation (Line(points={{62,60},{70,60},{70,8},{78,8}}, color={0,0,127}));
  connect(sub1.y, swi.u3) annotation (Line(points={{62,-80},{70,-80},{70,-8},{78,
          -8}}, color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{102,0},{140,0}}, color={0,0,127}));

annotation (defaultComponentName="nexWarHou",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-100,100},{100,140}},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}})),
Documentation(info="<html>
<p>
It calculates the total number of hours to next warmup period.
</p>
</html>", revisions="<html>
<ul>
<li>
February 12, 2025, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end HoursToNextWarmup;
