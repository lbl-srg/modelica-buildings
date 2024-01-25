within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block TankCycle "Block that determines the tank cycle flag"

  parameter Modelica.Units.SI.MassFlowRate mConWatHexCoo_flow_nominal
    "Design total CW mass flow rate through condenser barrels (all units)";

  parameter Modelica.Units.SI.Temperature TTanSet[2, 2]
    "Tank temperature setpoints: 2 cycles with 2 setpoints"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Integer nTTan=0
    "Number of tank temperature points"
    annotation (Dialog(connectorSizing=true),HideResult=true);

  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConWatOutTan_flow(
    final unit="kg/s")
    "Mass flow rate out of lower port of TES tank (>0 when charging)"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
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

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold criTem1[nTTan](
    each t=sum(TTanSet[2])/2, each h=1E-4)
    "Temperature criterion for first tank cycle"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allCriTem1(final nin=nTTan)
    "All temperature criteria met"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold criFlo1(final t=1E-3*
        mConWatHexCoo_flow_nominal, h=1E-3*mConWatHexCoo_flow_nominal/2)
    "Flow criterion for first tank cycle"
    annotation (Placement(transformation(extent={{-150,110},{-130,130}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold criTem2[nTTan](each t=sum(TTanSet[1])/2, each h=1E-4)
  "Temperature criterion for first tank cycle"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allCriTem2(final nin=nTTan)
    "All temperature criteria met"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(final
      integerTrue=1, final integerFalse=2) "Convert"
    annotation (Placement(transformation(extent={{-70,110},{-50,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Neither of temperature criterion is true" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,10})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3(final
      integerTrue=2, final integerFalse=0) "Convert" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,10})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4(final
      integerTrue=1, final integerFalse=0) "Convert" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,10})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt1 "Set cycle index as maximum"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,90})));
  Buildings.Controls.OBC.CDL.Logical.And allCri2 "All criteria met"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And allCri1 "All criteria met"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch idxIni "Index at initial time"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,120})));
  Buildings.Controls.OBC.CDL.Logical.Timer timAllCri1(t=5*60)
    "All criteria met for given time"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timAllCri2(t=5*60)
    "All criteria met for given time"
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Switch
                                           intSwi "Switch index"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idx1(final k=1) "Index"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch
                                           intSwi1 "Switch index"
    annotation (Placement(transformation(extent={{70,-110},{90,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idx2(final k=2) "Index"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Modelica.Blocks.Sources.IntegerExpression preIdxCycTan(y=pre(idxCycTan))
    "Previous index value"
    annotation (Placement(transformation(extent={{38,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not criFlo2
    "Flow criterion for second tank cycle"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  IntegerArrayHold hol(holdDuration=30*60, nin=1) "Hold for minimum runtime"
    annotation (Placement(transformation(extent={{136,-10},{156,10}})));
initial equation
  pre(idxCycTan)=idxIni.y;
equation
  connect(criTem1.y, allCriTem1.u)
    annotation (Line(points={{-118,-40},{-62,-40}},color={255,0,255}));
  connect(TTan, criTem2.u) annotation (Line(points={{-180,-40},{-152,-40},{-152,
          -80},{-142,-80}},
                      color={0,0,127}));
  connect(TTan, criTem1.u)
    annotation (Line(points={{-180,-40},{-142,-40}},color={0,0,127}));
  connect(criTem2.y, allCriTem2.u)
    annotation (Line(points={{-118,-80},{-62,-80}},  color={255,0,255}));
  connect(allCriTem2.y, booToInt3.u) annotation (Line(points={{-38,-80},{-30,
          -80},{-30,-2}},
                      color={255,0,255}));
  connect(allCriTem1.y, booToInt4.u) annotation (Line(points={{-38,-40},{-34,
          -40},{-34,-20},{-60,-20},{-60,-2}},
                                          color={255,0,255}));
  connect(allCriTem1.y, allCri1.u1)
    annotation (Line(points={{-38,-40},{-22,-40}}, color={255,0,255}));
  connect(allCriTem2.y, allCri2.u1)
    annotation (Line(points={{-38,-80},{-22,-80}},   color={255,0,255}));
  connect(maxInt1.u2, booToInt3.y) annotation (Line(points={{-34,78},{-34,30},{-30,
          30},{-30,22}}, color={255,127,0}));
  connect(booToInt4.y, maxInt1.u1) annotation (Line(points={{-60,22},{-60,30},{-46,
          30},{-46,78}}, color={255,127,0}));
  connect(allCriTem1.y, or2.u1) annotation (Line(points={{-38,-40},{-34,-40},{
          -34,-20},{0,-20},{0,-2}},                    color={255,0,255}));
  connect(allCriTem2.y, or2.u2) annotation (Line(points={{-38,-80},{-30,-80},{
          -30,-24},{8,-24},{8,-2}},  color={255,0,255}));
  connect(or2.y, idxIni.u2) annotation (Line(points={{0,22},{0,120},{98,120}},
                         color={255,0,255}));
  connect(maxInt1.y, idxIni.u1)
    annotation (Line(points={{-40,102},{-40,128},{98,128}},
                                                          color={255,127,0}));
  connect(criFlo1.y, booToInt.u)
    annotation (Line(points={{-128,120},{-72,120}},
                                                 color={255,0,255}));
  connect(booToInt.y, idxIni.u3) annotation (Line(points={{-48,120},{-20,120},{-20,
          112},{98,112}},color={255,127,0}));
  connect(mConWatOutTan_flow, criFlo1.u)
    annotation (Line(points={{-180,120},{-152,120}},
                                                   color={0,0,127}));
  connect(allCri1.y, timAllCri1.u)
    annotation (Line(points={{2,-40},{8,-40}}, color={255,0,255}));
  connect(allCri2.y, timAllCri2.u)
    annotation (Line(points={{2,-80},{8,-80}},   color={255,0,255}));
  connect(timAllCri1.passed, intSwi.u2) annotation (Line(points={{32,-48},{80,
          -48},{80,0},{108,0}}, color={255,0,255}));
  connect(idx1.y, intSwi.u1) annotation (Line(points={{62,20},{100,20},{100,8},
          {108,8}}, color={255,127,0}));
  connect(timAllCri2.passed, intSwi1.u2) annotation (Line(points={{32,-88},{36,
          -88},{36,-100},{68,-100}},  color={255,0,255}));
  connect(idx2.y, intSwi1.u1) annotation (Line(points={{62,-80},{66,-80},{66,
          -92},{68,-92}},   color={255,127,0}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{92,-100},{100,-100},{
          100,-8},{108,-8}}, color={255,127,0}));
  connect(preIdxCycTan.y, intSwi1.u3) annotation (Line(points={{61.1,-120},{66,
          -120},{66,-108},{68,-108}}, color={255,127,0}));
  connect(criFlo1.y, criFlo2.u) annotation (Line(points={{-128,120},{-120,120},
          {-120,100},{-150,100},{-150,80},{-142,80}},
                               color={255,0,255}));
  connect(hol.y[1], idxCycTan)
    annotation (Line(points={{158,0},{180,0}}, color={255,127,0}));
  connect(criFlo1.y, allCri1.u2) annotation (Line(points={{-128,120},{-100,120},
          {-100,-54},{-26,-54},{-26,-48},{-22,-48}}, color={255,0,255}));
  connect(criFlo2.y, allCri2.u2) annotation (Line(points={{-118,80},{-106,80},{
          -106,-60},{-26,-60},{-26,-88},{-22,-88}}, color={255,0,255}));
  connect(intSwi.y, hol.u[1])
    annotation (Line(points={{132,0},{134,0}}, color={255,127,0}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})),
    Documentation(info="<html>
<p>
The tank operating conditions should match the operating limits and selection
conditions of the chillers and HRCs.
The highest temperature (at the top of the tank) should be limited by the 
maximum evaporator entering temperature per manufacturer’s recommendations.
The lowest temperature (at the bottom of the tank) should be limited by the 
design CHW supply temperature.
This gives the tank maximum <i>&Delta;T</i> and the actual storage capacity.
However, this value is likely above the maximum <i>&Delta;T</i> that chillers
and HRCs can achieve across the condenser or evaporator barrel (typically
<i>11&nbsp;</i>K). Therefore, in order to fully leverage the TES capacity,
two temperature cycles are needed.
</p>
<p>
The first tank cycle (higher temperature setpoint) is activated whenever 
all of the following conditions are true.
</p>
<ul>
<li>
All tank temperature sensors measure a value higher than the mean setpoint value
of the second tank cycle for <i>5&nbsp;</i>min.
</li>
<li>
The flow rate out of the lower port of the tank is positive (tank is charging)
for <i>5&nbsp;</i>min.
</li>
</ul>
<p>
The second tank cycle (lower temperature setpoint) is activated 
whenever both of the following conditions are true.
</p>
<ul>
<li>
All tank temperature sensors measure a value lower than the mean setpoint value
of the first tank cycle for <i>5&nbsp;</i>min.
</li>
<li>
The flow rate out of the lower port of the tank is negative (tank is discharging)
for <i>5&nbsp;</i>min.
</li>
</ul>
<p>
At initial time the tank cycle flag is set based on the tank temperature condition 
only from the above two clauses without a time delay.
If neither condition is true, the tank cycle flag is set based on the flow condition 
only in the above two clauses without a time delay.
</p>
<p>
The minimum runtime of each tank cycle is fixed at <i>30&nbsp;</i>min.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end TankCycle;
