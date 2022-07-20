within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable;
block WithWSE "Enable devices when plants is enabled in waterside economizer mode"

  parameter Integer nSta = 3
    "Number of chiller stages";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-220,130},{-180,170}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIni(
    final min=0,
    final max=nSta)
    "Initial chiller stage (at plant enable)"
    annotation (Placement(transformation(extent={{-220,90},{-180,130}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta(
    final min=0,
    final max=nSta)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-220,0},{-180,40}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSEConIsoVal
    "Waterside economizer condenser isolation valve status"
    annotation (Placement(transformation(extent={{-220,-40},{-180,0}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaPriChiPum
    "Lead primary chilled water pump"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaConPum
    "Lead condenser water pump"
    annotation (Placement(transformation(extent={{-220,-130},{-180,-90}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaTwoCel
    "Lead cooling tower cell"
    annotation (Placement(transformation(extent={{-220,-170},{-180,-130}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEnaPlaPro
    "True: it is in the plant enabling process"
    annotation (Placement(transformation(extent={{180,130},{220,170}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yWSEConIsoVal
    "Waterside economizer condenser water isolation valve"
    annotation (Placement(transformation(extent={{180,-40},{220,0}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPriChiPum
    "Lead primary chilled water pump"
    annotation (Placement(transformation(extent={{180,-80},{220,-40}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaConPum
    "Lead condenser water pump"
    annotation (Placement(transformation(extent={{180,-130},{220,-90}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaTwoCel
    "Lead cooling tower cell"
    annotation (Placement(transformation(extent={{180,-170},{220,-130}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Waterside condenser water isolation valve"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Lead primary chilled water pump"
    annotation (Placement(transformation(extent={{140,-70},{160,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Lead condenser water pump"
    annotation (Placement(transformation(extent={{140,-120},{160,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Or or5
    "Lead cooling tower cell"
    annotation (Placement(transformation(extent={{140,-160},{160,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if current stage is initial stage"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Not in initial stage"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Becoming not initial stage"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=0)
    "Stage 0"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if initial stage is 0"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Plant enable edge"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Plant enabled with 0 initial stage, it means enabled with economizer-only operation"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  Buildings.Controls.OBC.CDL.Logical.Latch ecoMod "Plant enabled in economizer mode"
    annotation (Placement(transformation(extent={{80,140},{100,160}})));

equation
  connect(uPla, edg.u)
    annotation (Line(points={{-200,150},{-142,150}}, color={255,0,255}));
  connect(edg.y, and1.u1)
    annotation (Line(points={{-118,150},{18,150}},  color={255,0,255}));
  connect(intEqu.y, and1.u2) annotation (Line(points={{-38,110},{-20,110},{-20,
          142},{18,142}},  color={255,0,255}));
  connect(and1.y, ecoMod.u)
    annotation (Line(points={{42,150},{78,150}},color={255,0,255}));
  connect(uIni, intEqu.u1)
    annotation (Line(points={{-200,110},{-62,110}},  color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-118,80},{-100,80},{
          -100,102},{-62,102}},
                            color={255,127,0}));
  connect(uIni, intEqu1.u1) annotation (Line(points={{-200,110},{-160,110},{-160,
          50},{-102,50}},   color={255,127,0}));
  connect(uChiSta, intEqu1.u2)
    annotation (Line(points={{-200,20},{-160,20},{-160,42},{-102,42}}, color={255,127,0}));
  connect(intEqu1.y, not1.u)
    annotation (Line(points={{-78,50},{-62,50}}, color={255,0,255}));
  connect(not1.y, edg1.u)
    annotation (Line(points={{-38,50},{-22,50}},   color={255,0,255}));
  connect(edg1.y, ecoMod.clr) annotation (Line(points={{2,50},{60,50},{60,144},{
          78,144}},  color={255,0,255}));
  connect(ecoMod.y, yEnaPlaPro)
    annotation (Line(points={{102,150},{200,150}}, color={255,0,255}));
  connect(uWSEConIsoVal, or2.u1)
    annotation (Line(points={{-200,-20},{138,-20}}, color={255,0,255}));
  connect(ecoMod.y, or2.u2) annotation (Line(points={{102,150},{120,150},{120,-28},
          {138,-28}}, color={255,0,255}));
  connect(uLeaPriChiPum, or1.u1)
    annotation (Line(points={{-200,-60},{138,-60}}, color={255,0,255}));
  connect(ecoMod.y, or1.u2) annotation (Line(points={{102,150},{120,150},{120,-68},
          {138,-68}}, color={255,0,255}));
  connect(uLeaConPum, or4.u1)
    annotation (Line(points={{-200,-110},{138,-110}}, color={255,0,255}));
  connect(ecoMod.y, or4.u2) annotation (Line(points={{102,150},{120,150},{120,-118},
          {138,-118}}, color={255,0,255}));
  connect(uLeaTwoCel, or5.u1)
    annotation (Line(points={{-200,-150},{138,-150}}, color={255,0,255}));
  connect(ecoMod.y, or5.u2) annotation (Line(points={{102,150},{120,150},{120,-158},
          {138,-158}}, color={255,0,255}));
  connect(or2.y, yWSEConIsoVal)
    annotation (Line(points={{162,-20},{200,-20}}, color={255,0,255}));
  connect(or1.y, yLeaPriChiPum)
    annotation (Line(points={{162,-60},{200,-60}}, color={255,0,255}));
  connect(or4.y, yLeaConPum)
    annotation (Line(points={{162,-110},{200,-110}}, color={255,0,255}));
  connect(or5.y, yLeaTwoCel)
    annotation (Line(points={{162,-150},{200,-150}}, color={255,0,255}));

annotation (defaultComponentName = "wseSta",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-180,-180},{180,180}})),
  Documentation(info="<html>
<p>
It controls the devices when the chiller plant is enabled in waterside economizer
mode. It is implemented as provided in sections 5.2.2.4, section 1.
</p>
<ul>
<li>
Open the condenser water isolation valve of the waterside economizer.
</li>
<li>
Stage on lead primary chilled water pump, condenser water pump, and cooling
tower respectively.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
July 20, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end WithWSE;
