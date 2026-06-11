within Buildings.Controls.OBC.DemandFlexibility.Generic;
block RealValueSelectionByMode "Real value selection by mode"

  parameter Boolean use_pre
    "The pre-cool or pre-heat mode is used";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDef
    "Input value for the default mode"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPre if use_pre
    "Input value for the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uReb
    "Input value for the load-rebound mode"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uShe
    "Input value for the load-shed mode"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uMod
    "Demand flexibility mode;  -1 = pre-cool or pre-heat, 0 = default, 1 = load-shed, 2 = load-rebound"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Output value based on the demand flexibility mode"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter pasThrDef(k=1)  if not use_pre
    "Simple pass-through block for the default mode input value"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Switch swiPre if use_pre
    "True: output the value for the pre-cool or pre-heat mode; False: output the value for the default mode"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiShe
    "True: output the value for the load-shed mode; False: output the value for other demand flexibility modes"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiReb
    "True: output the value for the load-rebound mode; False: output the value for other demand flexibility modes"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquPre if use_pre
    "Check whether it is the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntPre(k=-1) if use_pre
    "Integer constant for the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquShe
    "Check whether it is the load-shed mode"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntShe(k=1)
    "Integer constant for the load-shed mode"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquReb
    "Check whether it is the load-rebound mode"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntReb(k=2)
    "Integer constant for the load-rebound mode"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(uPre, swiPre.u1)
    annotation (Line(points={{-160,40},{-130,40},{-130,98},{18,98}},
      color={0,0,127}));
  connect(swiReb.y, y)
    annotation (Line(points={{122,-70},{130,-70},{130,0},{160,0}},
      color={0,0,127}));
  connect(intEquPre.y, swiPre.u2)
    annotation (Line(points={{-18,70},{10,70},{10,90},{18,90}}, color={255,0,255}));
  connect(conIntShe.y, intEquShe.u2)
    annotation (Line(points={{-58,-10},{-50,-10},{-50,2},{-42,2}},
      color={255,127,0}));
  connect(uMod, intEquShe.u1)
    annotation (Line(points={{-160,80},{-100,80},{-100,10},{-42,10}},
      color={255,127,0}));
  connect(uMod, intEquReb.u1)
    annotation (Line(points={{-160,80},{-100,80},{-100,-50},{-42,-50}},
      color={255,127,0}));
  connect(conIntReb.y, intEquReb.u2)
    annotation (Line(points={{-58,-70},{-50,-70},{-50,-58},{-42,-58}},
      color={255,127,0}));
  connect(intEquShe.y, swiShe.u2)
    annotation (Line(points={{-18,10},{58,10}}, color={255,0,255}));
  connect(intEquReb.y, swiReb.u2)
    annotation (Line(points={{-18,-50},{40,-50},{40,-70},{98,-70}},
      color={255,0,255}));
  connect(uShe, swiShe.u1)
    annotation (Line(points={{-160,-40},{-110,-40},{-110,-100},{0,-100},{0,18},
      {58,18}}, color={0,0,127}));
  connect(uReb, swiReb.u1)
    annotation (Line(points={{-160,-80},{-120,-80},{-120,-110},{60,-110},{60,-62},
      {98,-62}}, color={0,0,127}));
  connect(swiPre.y, swiShe.u3)
    annotation (Line(points={{42,90},{50,90},{50,2},{58,2}}, color={0,0,127}));
  connect(swiShe.y, swiReb.u3)
    annotation (Line(points={{82,10},{90,10},{90,-78},{98,-78}}, color={0,0,127}));
  connect(uDef, swiPre.u3)
    annotation (Line(points={{-160,0},{-120,0},{-120,90},{0,90},{0,82},{18,82}},
      color={0,0,127}));
  connect(conIntPre.y, intEquPre.u2)
    annotation (Line(points={{-58,50},{-50,50},{-50,62},{-42,62}},
      color={255,127,0}));
  connect(uMod, intEquPre.u1)
    annotation (Line(points={{-160,80},{-100,80},{-100,70},{-42,70}},
      color={255,127,0}));
  connect(uDef, pasThrDef.u) annotation (Line(points={{-160,0},{-120,0},{-120,-30},
          {10,-30},{10,-10},{18,-10}}, color={0,0,127}));
  connect(pasThrDef.y, swiShe.u3) annotation (Line(points={{42,-10},{50,-10},{50,
          2},{58,2}}, color={0,0,127}));
  annotation (defaultComponentName="reaValSelByMod",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    extent={{-140,-120},{140,120}},
    grid={2,2})),
    Documentation(info="<html>
<p>
This sequence serves to choose which of the input variables, including
<code>uPre</code>, <code>uDef</code>, <code>uShe</code>, and <code>uReb</code>, to
output as the output variable <code>y</code>, based on the demand flexibility mode
<code>uMod</code>. 
</p>
<p>
The demand flexibility mode includes the pre-cool or pre-heat mode
(<i>uMod = -1</i>), the default mode (<i>uMod = 0</i>), the load-shed mode
(<i>uMod = 1</i>), and the load-rebound mode (<i>uMod = 2</i>). These modes
correspond to the input variables <code>uPre</code>, <code>uDef</code>,
<code>uShe</code>, and <code>uReb</code>. If <code>uMod</code> is any other integer,
the output variable <code>y</code> takes the value of <code>uDef</code>.
</p>
<p>
The parameter <code>use_pre</code> specifies whether the pre-cool/pre-heat mode
should be used.
</p>
</html>", revisions="<html>
<ul>
<li>
June 11, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end RealValueSelectionByMode;
