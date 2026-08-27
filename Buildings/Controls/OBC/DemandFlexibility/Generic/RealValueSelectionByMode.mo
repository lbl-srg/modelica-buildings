within Buildings.Controls.OBC.DemandFlexibility.Generic;
block RealValueSelectionByMode "Real value selection by mode"

  parameter Boolean use_pre
    "True: the pre-cool or pre-heat mode is used";

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
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Output value based on the demand flexibility mode"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter pasThrDef(final k=1)
    if not use_pre
    "Simple pass-through block for the default mode input value"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiPre if use_pre
    "True: output the value for the pre-cool or pre-heat mode; False: output the value for the default mode"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiShe
    "True: output the value for the load-shed mode; False: output the value for other demand flexibility modes"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiReb
    "True: output the value for the load-rebound mode; False: output the value for other demand flexibility modes"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquPre if use_pre
    "Check whether it is the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntPre(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.preCondition)
    if use_pre
    "Integer constant for the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquShe
    "Check whether it is the load-shed mode"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntShe(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadShed)
    "Integer constant for the load-shed mode"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquReb
    "Check whether it is the load-rebound mode"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntReb(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadRebound)
    "Integer constant for the load-rebound mode"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
equation
  connect(uPre, swiPre.u1)
    annotation (Line(points={{-160,40},{-130,40},{-130,108},{18,108}},
      color={0,0,127}));
  connect(swiReb.y, y)
    annotation (Line(points={{122,-60},{130,-60},{130,0},{160,0}},
      color={0,0,127}));
  connect(intEquPre.y, swiPre.u2)
    annotation (Line(points={{-18,70},{10,70},{10,100},{18,100}}, color={255,0,255}));
  connect(conIntShe.y, intEquShe.u2)
    annotation (Line(points={{-58,-30},{-50,-30},{-50,-18},{-42,-18}},
      color={255,127,0}));
  connect(demFleMod, intEquShe.u1)
    annotation (Line(points={{-160,80},{-90,80},{-90,-10},{-42,-10}},
      color={255,127,0}));
  connect(demFleMod, intEquReb.u1)
    annotation (Line(points={{-160,80},{-90,80},{-90,-80},{-42,-80}},
      color={255,127,0}));
  connect(conIntReb.y, intEquReb.u2)
    annotation (Line(points={{-58,-100},{-50,-100},{-50,-88},{-42,-88}},
      color={255,127,0}));
  connect(intEquShe.y, swiShe.u2)
    annotation (Line(points={{-18,-10},{20,-10},{20,0},{58,0}}, color={255,0,255}));
  connect(intEquReb.y, swiReb.u2)
    annotation (Line(points={{-18,-80},{40,-80},{40,-60},{98,-60}},
      color={255,0,255}));
  connect(uShe, swiShe.u1)
    annotation (Line(points={{-160,-40},{-110,-40},{-110,8},{58,8}}, color={0,0,127}));
  connect(uReb, swiReb.u1)
    annotation (Line(points={{-160,-80},{-100,-80},{-100,-52},{98,-52}}, color={0,0,127}));
  connect(swiPre.y, swiShe.u3)
    annotation (Line(points={{42,100},{50,100},{50,-8},{58,-8}}, color={0,0,127}));
  connect(swiShe.y, swiReb.u3)
    annotation (Line(points={{82,0},{90,0},{90,-68},{98,-68}}, color={0,0,127}));
  connect(uDef, swiPre.u3)
    annotation (Line(points={{-160,0},{-120,0},{-120,92},{18,92}},
      color={0,0,127}));
  connect(conIntPre.y, intEquPre.u2)
    annotation (Line(points={{-58,50},{-50,50},{-50,62},{-42,62}},
      color={255,127,0}));
  connect(demFleMod, intEquPre.u1)
    annotation (Line(points={{-160,80},{-90,80},{-90,70},{-42,70}},
      color={255,127,0}));
  connect(uDef, pasThrDef.u)
    annotation (Line(points={{-160,0},{-120,0},{-120,30},{18,30}},
      color={0,0,127}));
  connect(pasThrDef.y, swiShe.u3)
    annotation (Line(points={{42,30},{50,30},{50,-8},{58,-8}}, color={0,0,127}));
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
This block serves to choose which of the input variables, including
<code>uPre</code>, <code>uDef</code>, <code>uShe</code>, and <code>uReb</code>, to
output as the output variable <code>y</code>, based on the demand flexibility mode
<code>demFleMod</code>. 
</p>
<p>
The demand flexibility mode includes the pre-cool or pre-heat mode
(<i>demFleMod = 0</i>), the default mode (<i>demFleMod = 1</i>), the load-shed mode
(<i>demFleMod = 2</i>), and the load-rebound mode (<i>demFleMod = 3</i>). These
modes correspond to the input variables <code>uPre</code>, <code>uDef</code>,
<code>uShe</code>, and <code>uReb</code>. If <code>demFleMod</code> is any other
integer, the output variable <code>y</code> takes the value of <code>uDef</code>.
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
