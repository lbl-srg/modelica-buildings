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
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTan[nTTan](
    each final unit="K",
    each displayUnit="degC")
    "TES tank temperature"
    annotation (Placement(
        transformation(extent={{-200,-80},{-160,-40}}),   iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput idxCycTan(
    final min=1, final max=2)
    "Index of active tank cycle"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
                             iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold criTem1[nTTan](
    each t=sum(TTanSet[2])/2)
    "Temperature criterion for first tank cycle"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allCriTem1(final nin=nTTan)
    "All temperature criteria met"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold criFlo1(final t=0)
    "Flow criterion for first tank cycle"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold criTem2[nTTan](
    each t=sum(TTanSet[1])/2) "Temperature criterion for first tank cycle"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold  criFlo2(final t=0)
    "Flow criterion for first tank cycle"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allCriTem2(final nin=nTTan)
    "All temperature criteria met"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(final
      integerTrue=1, final integerFalse=2) "Convert"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Neither of temperature criterion is true" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-20})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3(final
      integerTrue=2, final integerFalse=0) "Convert" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-20})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4(final
      integerTrue=1, final integerFalse=0) "Convert" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-58,-20})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt1 "Set cycle index as maximum"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,20})));
  Buildings.Controls.OBC.CDL.Logical.And allCri2 "All criteria met"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And allCri1 "All criteria met"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Switch idxIni "Index at initial time"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,60})));
  Buildings.Controls.OBC.CDL.Logical.Timer timAllCri1(t=5*60)
    "All criteria met for given time"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timAllCri2(t=5*60)
    "All criteria met for given time"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Switch
                                           intSwi "Switch index"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idx1(final k=1) "Index"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch
                                           intSwi1 "Switch index"
    annotation (Placement(transformation(extent={{70,-130},{90,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idx2(final k=2) "Index"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Modelica.Blocks.Sources.IntegerExpression preIdxCycTan(y=pre(idxCycTan))
    "Previous index value"
    annotation (Placement(transformation(extent={{20,-150},{42,-130}})));
initial equation
  pre(idxCycTan)=idxIni.y;
equation
  connect(criTem1.y, allCriTem1.u)
    annotation (Line(points={{-78,-60},{-62,-60}}, color={255,0,255}));
  connect(TTan, criTem2.u) annotation (Line(points={{-180,-60},{-152,-60},{-152,
          -100},{-102,-100}},
                      color={0,0,127}));
  connect(TTan, criTem1.u)
    annotation (Line(points={{-180,-60},{-102,-60}},color={0,0,127}));
  connect(criTem2.y, allCriTem2.u)
    annotation (Line(points={{-78,-100},{-62,-100}}, color={255,0,255}));
  connect(allCriTem2.y, booToInt3.u) annotation (Line(points={{-38,-100},{-30,-100},
          {-30,-32}}, color={255,0,255}));
  connect(allCriTem1.y, booToInt4.u) annotation (Line(points={{-38,-60},{-34,-60},
          {-34,-40},{-58,-40},{-58,-32}}, color={255,0,255}));
  connect(allCriTem1.y, allCri1.u1)
    annotation (Line(points={{-38,-60},{-22,-60}}, color={255,0,255}));
  connect(allCriTem2.y, allCri2.u1)
    annotation (Line(points={{-38,-100},{-22,-100}}, color={255,0,255}));
  connect(maxInt1.u2, booToInt3.y) annotation (Line(points={{-34,8},{-34,0},{-30,
          0},{-30,-8}},  color={255,127,0}));
  connect(booToInt4.y, maxInt1.u1) annotation (Line(points={{-58,-8},{-58,0},{-46,
          0},{-46,8}},   color={255,127,0}));
  connect(allCriTem1.y, or2.u1) annotation (Line(points={{-38,-60},{-34,-60},{-34,
          -40},{-8.88178e-16,-40},{-8.88178e-16,-32}}, color={255,0,255}));
  connect(allCriTem2.y, or2.u2) annotation (Line(points={{-38,-100},{-30,-100},{
          -30,-42},{8,-42},{8,-32}}, color={255,0,255}));
  connect(or2.y, idxIni.u2) annotation (Line(points={{0,-8},{0,40},{-28,40},{-28,
          60},{-22,60}}, color={255,0,255}));
  connect(maxInt1.y, idxIni.u1)
    annotation (Line(points={{-40,32},{-40,68},{-22,68}}, color={255,127,0}));
  connect(criFlo1.y, booToInt.u)
    annotation (Line(points={{-78,60},{-72,60}}, color={255,0,255}));
  connect(booToInt.y, idxIni.u3) annotation (Line(points={{-48,60},{-34,60},{-34,
          52},{-22,52}}, color={255,127,0}));
  connect(criFlo1.y, allCri1.u2) annotation (Line(points={{-78,60},{-74,60},{-74,
          -80},{-26,-80},{-26,-68},{-22,-68}}, color={255,0,255}));
  connect(criFlo2.y, allCri2.u2) annotation (Line(points={{-78,20},{-76,20},{-76,
          -114},{-30,-114},{-30,-108},{-22,-108}}, color={255,0,255}));
  connect(mConWatOutTan_flow, criFlo1.u)
    annotation (Line(points={{-180,60},{-102,60}}, color={0,0,127}));
  connect(mConWatOutTan_flow, criFlo2.u) annotation (Line(points={{-180,60},{-150,
          60},{-150,20},{-102,20}}, color={0,0,127}));
  connect(allCri1.y, timAllCri1.u)
    annotation (Line(points={{2,-60},{8,-60}}, color={255,0,255}));
  connect(allCri2.y, timAllCri2.u)
    annotation (Line(points={{2,-100},{8,-100}}, color={255,0,255}));
  connect(timAllCri1.passed, intSwi.u2) annotation (Line(points={{32,-68},{80,
          -68},{80,0},{108,0}}, color={255,0,255}));
  connect(idx1.y, intSwi.u1) annotation (Line(points={{62,20},{100,20},{100,8},
          {108,8}}, color={255,127,0}));
  connect(timAllCri2.passed, intSwi1.u2) annotation (Line(points={{32,-108},{36,
          -108},{36,-120},{68,-120}}, color={255,0,255}));
  connect(idx2.y, intSwi1.u1) annotation (Line(points={{62,-100},{66,-100},{66,
          -112},{68,-112}}, color={255,127,0}));
  connect(intSwi.y, idxCycTan)
    annotation (Line(points={{132,0},{180,0}}, color={255,127,0}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{92,-120},{100,-120},{
          100,-8},{108,-8}}, color={255,127,0}));
  connect(preIdxCycTan.y, intSwi1.u3) annotation (Line(points={{43.1,-140},{60,
          -140},{60,-128},{68,-128}}, color={255,127,0}));
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
