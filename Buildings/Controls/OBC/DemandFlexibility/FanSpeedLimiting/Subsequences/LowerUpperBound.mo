within Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences;
block LowerUpperBound "Lower upper bound"

  parameter Integer nAHU(min=1)
    "Number of air handling units";
  parameter Real fanSpeDel_small(
    min=0,
    unit="1")=0.005
    "A small fan speed delta, used to reduce the effects of rounding errors when comparing the current fan speed command to the target fan speed"
    annotation (Dialog(group="Temperature setpoint parameters"));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,58},{-100,98}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput fanSpeLimCur[nAHU](unit="1")
    "Current fan speed limit" annotation (Placement(transformation(extent={{-240,0},
            {-200,40}}),    iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput fanSpeLimDef[nAHU](unit="1")
    "Default fan speed limit" annotation (Placement(transformation(extent={{-240,
            -40},{-200,0}}), iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput fanSpeLimTarShe[nAHU](unit="1")
    "Target fan speed limit for the load-shed mode" annotation (Placement(
        transformation(extent={{-240,-80},{-200,-40}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reach_lowUppBou[nAHU]
    "Reach the lower or upper bound" annotation (Placement(transformation(
          extent={{200,-20},{240,20}}), iconTransformation(extent={{100,-20},{
            140,20}})));
protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntShe(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadShed)
    "Integer constant for the load-shed mode"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquShe
    "Check whether it is the load-shed mode"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepShe(
    final nout=nAHU)
    "Repeat the boolean scalar for being in the load-shed mode"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepReb(
    final nout=nAHU)
    "Repeat the boolean scalar for being in the load-rebound mode"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquReb
    "Check whether it is the load-rebound mode"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntReb(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadRebound)
    "Integer constant for the load-rebound mode"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addFanSpeDelShe[nAHU](final p=
        fill(fanSpeDel_small, nAHU))
    "Add a small fan speed delta during the load-shed mode"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Less lesFanSpeLimTarShe[nAHU](final h=fill(
        0.5*fanSpeDel_small, nAHU))
    "The fan speed command is less than the load-shed target fan speed limit during the load-shed mode"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter subFanSpeDelReb[nAHU](final p=
        fill(-fanSpeDel_small, nAHU))
    "Subtract a small fan speed delta during the load-rebound mode"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greFanSpeLimDefReb[nAHU](final h=
        fill(0.5*fanSpeDel_small, nAHU))
    "The fan speed command is greater than the default fan speed limit during the load-rebound mode"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Logical.And reaFanSpeLimTarShe[nAHU]
    "In the load-shed mode, the fan speed command has reached the load-shed target fan speed limit"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.And reaFanSpeLimDef[nAHU]
    "In the load-rebound mode, the fan speed command has reached the default fan speed limit"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Controls.OBC.CDL.Logical.Or orReaLimSheReb[nAHU]
    "The fan speed command has reached a fan speed limit during the load-shed mode and the load-rebound mode"
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
equation
  connect(demFleMod, intEquShe.u1) annotation (Line(points={{-220,80},{-130,80},
          {-130,30},{-42,30}},
                            color={255,127,0}));
  connect(demFleMod, intEquReb.u1) annotation (Line(points={{-220,80},{-130,80},
          {-130,70},{-42,70}},
                            color={255,127,0}));
  connect(conIntShe.y, intEquShe.u2) annotation (Line(points={{-78,10},{-58,10},
          {-58,22},{-42,22}},
                        color={255,127,0}));
  connect(conIntReb.y, intEquReb.u2) annotation (Line(points={{-78,50},{-60,50},
          {-60,62},{-42,62}},
                        color={255,127,0}));
  connect(intEquShe.y, booScaRepShe.u)
    annotation (Line(points={{-18,30},{-2,30}}, color={255,0,255}));
  connect(intEquReb.y, booScaRepReb.u)
    annotation (Line(points={{-18,70},{18,70}}, color={255,0,255}));
  connect(fanSpeLimCur, greFanSpeLimDefReb.u1) annotation (Line(points={{-220,
          20},{-160,20},{-160,-10},{-42,-10}}, color={0,0,127}));
  connect(fanSpeLimDef, subFanSpeDelReb.u) annotation (Line(points={{-220,-20},{
          -180,-20},{-180,-30},{-122,-30}}, color={0,0,127}));
  connect(subFanSpeDelReb.y, greFanSpeLimDefReb.u2) annotation (Line(points={{-98,
          -30},{-68,-30},{-68,-18},{-42,-18}}, color={0,0,127}));
  connect(fanSpeLimCur, lesFanSpeLimTarShe.u1) annotation (Line(points={{-220,
          20},{-160,20},{-160,-50},{-42,-50}}, color={0,0,127}));
  connect(fanSpeLimTarShe, addFanSpeDelShe.u) annotation (Line(points={{-220,-60},
          {-180,-60},{-180,-70},{-122,-70}}, color={0,0,127}));
  connect(addFanSpeDelShe.y, lesFanSpeLimTarShe.u2) annotation (Line(points={{-98,
          -70},{-68,-70},{-68,-58},{-42,-58}}, color={0,0,127}));
  connect(booScaRepReb.y, reaFanSpeLimDef.u1) annotation (Line(points={{42,70},
          {60,70},{60,10},{78,10}}, color={255,0,255}));
  connect(greFanSpeLimDefReb.y, reaFanSpeLimDef.u2) annotation (Line(points={{-18,
          -10},{60,-10},{60,2},{78,2}}, color={255,0,255}));
  connect(booScaRepShe.y, reaFanSpeLimTarShe.u1) annotation (Line(points={{22,
          30},{40,30},{40,-70},{78,-70}}, color={255,0,255}));
  connect(lesFanSpeLimTarShe.y, reaFanSpeLimTarShe.u2) annotation (Line(points=
          {{-18,-50},{20,-50},{20,-78},{78,-78}}, color={255,0,255}));
  connect(reaFanSpeLimDef.y, orReaLimSheReb.u1) annotation (Line(points={{102,
          10},{120,10},{120,-30},{138,-30}}, color={255,0,255}));
  connect(reaFanSpeLimTarShe.y, orReaLimSheReb.u2) annotation (Line(points={{
          102,-70},{120,-70},{120,-38},{138,-38}}, color={255,0,255}));
  connect(orReaLimSheReb.y, reach_lowUppBou) annotation (Line(points={{162,-30},
          {180,-30},{180,0},{220,0}}, color={255,0,255}));
  annotation (defaultComponentName="lowUppBou",
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
    grid={2,2},
        extent={{-200,-100},{200,100}})),
    Documentation(revisions="<html>
<ul>
<li>
October 21, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block checks whether the current fan speed limit <code>fanSpeLimCur</code> has
reached a lower bound or an upper bound.
</p>
<p>
Input variable <code>fanSpeLimDef</code> is the default fan speed limit. Input
variable <code>fanSpeLimTarShe</code> is the target fan speed limit for the
load-shed mode. Input variable <code>demFleMod</code> is the demand flexibility mode.
Parameter <code>fanSpeDel_small</code> is a small fan speed delta that is used to
reduce the effects of rounding errors.
</p>
<p>
If <code>fanSpeLimCur</code> satisfies any of the following, the boolean output
variable <code>reach_lowUppBou</code> will become <code>true</code>. Otherwise,
<code>reach_lowUppBou</code> will be <code>false</code>:
</p>
<ul>
<li>
<code>demFleMod = 2</code> and
<code>fanSpeLimCur &lt; fanSpeLimTarShe + fanSpeDel_small</code>
</li>
<li>
or: <code>demFleMod = 3</code> and
<code>fanSpeLimCur &gt; fanSpeLimDef - fanSpeDel_small</code>
</li>
</ul>
</html>"));
end LowerUpperBound;
