within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block TankCycle "Block that determines tank cycle flag"

  parameter Modelica.Units.SI.Temperature TTanSet[2, 2]
    "Tank temperature setpoints: 2 cycles with 2 setpoints"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Integer nTTan=0
    "Number of tank temperature points"
    annotation (Dialog(connectorSizing=true),HideResult=true);

  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConWatOutTan_flow(
    final unit="kg/s")
    "Mass flow rate out of lower port of TES tank (>0 when charging)"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTan[nTTan](
    each final unit="K",
    each displayUnit="degC")
    "TES tank temperature"
    annotation (Placement(
        transformation(extent={{-200,-60},{-160,-20}}),   iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput idxCycTan(
    final min=1, final max=2)
    "Index of active tank cycle"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
                             iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold criTem1[nTTan](
    each t=sum(TTanSet[2])/2, each h=1E-4)
    "Temperature criterion for first tank cycle"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allCriTem1(final nin=nTTan)
    "All temperature criteria met"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold criFlo1(final t=0, h=1E-4)
    "Flow criterion for first tank cycle"
    annotation (Placement(transformation(extent={{-150,70},{-130,90}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold criTem2[nTTan](each t=sum(TTanSet[1])/2, each h=1E-4)
  "Temperature criterion for first tank cycle"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allCriTem2(final nin=nTTan)
    "All temperature criteria met"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(final
      integerTrue=1, final integerFalse=2) "Convert"
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Neither of temperature criterion is true" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3(final
      integerTrue=2, final integerFalse=0) "Convert" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,0})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4(final
      integerTrue=1, final integerFalse=0) "Convert" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-58,0})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt1 "Set cycle index as maximum"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,40})));
  Buildings.Controls.OBC.CDL.Logical.And allCri2 "All criteria met"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And allCri1 "All criteria met"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch idxIni "Index at initial time"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,80})));
  Buildings.Controls.OBC.CDL.Logical.Timer timAllCri1(t=5*60)
    "All criteria met for given time"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timAllCri2(t=5*60)
    "All criteria met for given time"
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Switch
                                           intSwi "Switch index"
    annotation (Placement(transformation(extent={{122,-10},{142,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idx1(final k=1) "Index"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch
                                           intSwi1 "Switch index"
    annotation (Placement(transformation(extent={{70,-110},{90,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idx2(final k=2) "Index"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Modelica.Blocks.Sources.IntegerExpression preIdxCycTan(y=pre(idxCycTan))
    "Previous index value"
    annotation (Placement(transformation(extent={{20,-130},{42,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not criFlo2
    "Flow criterion for second tank cycle"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
initial equation
  pre(idxCycTan)=idxIni.y;
equation
  connect(criTem1.y, allCriTem1.u)
    annotation (Line(points={{-98,-40},{-62,-40}}, color={255,0,255}));
  connect(TTan, criTem2.u) annotation (Line(points={{-180,-40},{-152,-40},{-152,
          -80},{-122,-80}},
                      color={0,0,127}));
  connect(TTan, criTem1.u)
    annotation (Line(points={{-180,-40},{-122,-40}},color={0,0,127}));
  connect(criTem2.y, allCriTem2.u)
    annotation (Line(points={{-98,-80},{-62,-80}},   color={255,0,255}));
  connect(allCriTem2.y, booToInt3.u) annotation (Line(points={{-38,-80},{-30,
          -80},{-30,-12}},
                      color={255,0,255}));
  connect(allCriTem1.y, booToInt4.u) annotation (Line(points={{-38,-40},{-34,
          -40},{-34,-20},{-58,-20},{-58,-12}},
                                          color={255,0,255}));
  connect(allCriTem1.y, allCri1.u1)
    annotation (Line(points={{-38,-40},{-22,-40}}, color={255,0,255}));
  connect(allCriTem2.y, allCri2.u1)
    annotation (Line(points={{-38,-80},{-22,-80}},   color={255,0,255}));
  connect(maxInt1.u2, booToInt3.y) annotation (Line(points={{-34,28},{-34,20},{
          -30,20},{-30,12}},
                         color={255,127,0}));
  connect(booToInt4.y, maxInt1.u1) annotation (Line(points={{-58,12},{-58,20},{
          -46,20},{-46,28}},
                         color={255,127,0}));
  connect(allCriTem1.y, or2.u1) annotation (Line(points={{-38,-40},{-34,-40},{
          -34,-20},{0,-20},{0,-12}},                   color={255,0,255}));
  connect(allCriTem2.y, or2.u2) annotation (Line(points={{-38,-80},{-30,-80},{
          -30,-22},{8,-22},{8,-12}}, color={255,0,255}));
  connect(or2.y, idxIni.u2) annotation (Line(points={{0,12},{0,60},{-28,60},{
          -28,80},{-22,80}},
                         color={255,0,255}));
  connect(maxInt1.y, idxIni.u1)
    annotation (Line(points={{-40,52},{-40,88},{-22,88}}, color={255,127,0}));
  connect(criFlo1.y, booToInt.u)
    annotation (Line(points={{-128,80},{-72,80}},color={255,0,255}));
  connect(booToInt.y, idxIni.u3) annotation (Line(points={{-48,80},{-34,80},{
          -34,72},{-22,72}},
                         color={255,127,0}));
  connect(criFlo1.y, allCri1.u2) annotation (Line(points={{-128,80},{-76,80},{
          -76,-60},{-26,-60},{-26,-48},{-22,-48}},
                                               color={255,0,255}));
  connect(mConWatOutTan_flow, criFlo1.u)
    annotation (Line(points={{-180,80},{-152,80}}, color={0,0,127}));
  connect(allCri1.y, timAllCri1.u)
    annotation (Line(points={{2,-40},{8,-40}}, color={255,0,255}));
  connect(allCri2.y, timAllCri2.u)
    annotation (Line(points={{2,-80},{8,-80}},   color={255,0,255}));
  connect(timAllCri1.passed, intSwi.u2) annotation (Line(points={{32,-48},{80,
          -48},{80,0},{120,0}}, color={255,0,255}));
  connect(idx1.y, intSwi.u1) annotation (Line(points={{62,20},{100,20},{100,8},
          {120,8}}, color={255,127,0}));
  connect(timAllCri2.passed, intSwi1.u2) annotation (Line(points={{32,-88},{36,
          -88},{36,-100},{68,-100}},  color={255,0,255}));
  connect(idx2.y, intSwi1.u1) annotation (Line(points={{62,-80},{66,-80},{66,
          -92},{68,-92}},   color={255,127,0}));
  connect(intSwi.y, idxCycTan)
    annotation (Line(points={{144,0},{180,0}}, color={255,127,0}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{92,-100},{100,-100},{
          100,-8},{120,-8}}, color={255,127,0}));
  connect(preIdxCycTan.y, intSwi1.u3) annotation (Line(points={{43.1,-120},{60,
          -120},{60,-108},{68,-108}}, color={255,127,0}));
  connect(criFlo1.y, criFlo2.u) annotation (Line(points={{-128,80},{-120,80},{
          -120,40},{-112,40}}, color={255,0,255}));
  connect(criFlo2.y, allCri2.u2) annotation (Line(points={{-88,40},{-80,40},{
          -80,-100},{-26,-100},{-26,-88},{-22,-88}},   color={255,0,255}));
  annotation (
  defaultComponentName="cycTan",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})));
end TankCycle;
