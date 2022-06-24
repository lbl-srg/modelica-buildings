within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences;
block Limits
  "Multi zone VAV AHU minimum outdoor air control - damper position limits"

  parameter Real uRetDamMin(
    final min=yMin,
    final max=yMax,
    final unit="1") = 0.5
    "Loop signal value to start decreasing the maximum return air damper position"
    annotation (Dialog(tab="Commissioning", group="Controller"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Controller"));

  parameter Real k(
    final unit="1")=0.05 "Gain of damper limit controller"
    annotation (Dialog(group="Controller"));

  parameter Real Ti(
    final unit="s",
    final quantity="Time")=120
    "Time constant of damper limit controller integrator block"
    annotation (Dialog(group="Controller",
    enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real Td(
    final unit="s",
    final quantity="Time")=0.1
  "Time constant of damper limit controller derivative block"
    annotation (Dialog(group="Controller",
    enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
        or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1 "Physically fixed maximum position of the return air damper"
    annotation (Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation (Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper"
    annotation (Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation (Dialog(tab="Commissioning", group="Physical damper position limits"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOut_flow_normalized(
   final unit="1")
    "Measured outdoor volumetric airflow rate, normalized by design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-220,150},{-180,190}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinSet_flow_normalized(
    final unit="1")
    "Effective minimum outdoor airflow setpoint, normalized by design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-220,200},{-180,240}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-220,-200},{-180,-160}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    "Freeze protection status signal"
    annotation (Placement(transformation(extent={{-220,-160},{-180,-120}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status signal"
    annotation (Placement(transformation(extent={{-220,-120},{-180,-80}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPosMin(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") "Minimum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{180,80},{220,120}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPosMax(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") "Maximum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{180,30},{220,70}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPosMin(
    final min=retDamPhyPosMin,
    final max=retDamPhyPosMax,
    final unit="1") "Minimum return air damper position limit"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPosMax(
    final min=retDamPhyPosMin,
    final max=retDamPhyPosMax,
    final unit="1") "Maximum return air damper position limit"
    annotation (Placement(transformation(extent={{180,-70},{220,-30}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1")
    "Physical maximum return air damper position limit. Required as an input for the economizer enable disable sequence"
    annotation (Placement(transformation(extent={{180,-110},{220,-70}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset damLimCon(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin)
    "Damper position limit controller"
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));

protected
  parameter Real yMin=0 "Lower limit of control loop signal";
  parameter Real yMax=1 "Upper limit of control loop signal";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPhyPosMinSig(
    final k=outDamPhyPosMin)
    "Physically fixed minimum position of the outdoor air damper. This is the initial position of the economizer damper"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPhyPosMaxSig(
    final k=outDamPhyPosMax)
    "Physically fixed maximum position of the outdoor air damper."
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPhyPosMinSig(
    final k=retDamPhyPosMin)
    "Physically fixed minimum position of the return air damper"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPhyPosMaxSig(
    final k=retDamPhyPosMax)
    "Physically fixed maximum position of the return air damper. This is the initial condition of the return air damper"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSigLim(
    final k=yMin)
    "Equals minimum controller output signal"
    annotation (Placement(transformation(extent={{-100,200},{-80,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxSigLim(
    final k=yMax)
    "Equals maximum controller output signal"
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sigFraForOutDam(
    final k=uRetDamMin) "Equals the fraction of the control loop signal below which the outdoor air damper
    limit gets modulated and above which the return air damper limit gets modulated"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Line minOutDam(
    final limitBelow=true,
    final limitAbove=true)
    "Linear mapping of the outdoor air damper position to the control signal"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Line minRetDam(
    final limitBelow=true,
    final limitAbove=true)
    "Linear mapping of the return air damper position to the control signal"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDamPosMinSwitch
    "A switch to deactivate the return air damper minimal outdoor airflow control"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch outDamPosMaxSwitch
    "A switch to deactivate the outdoor air damper minimal outdoor airflow control"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not block"
    annotation (Placement(transformation(extent={{-8,-110},{12,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage1)
    "Freeze protection stage 1"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-160,-210},{-140,-190}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual intLesEqu
    "Check if freeze protection stage is stage 0"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if operation mode is occupied"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));

equation
  connect(minRetDam.y, yRetDamPosMax) annotation (Line(points={{142,110},{150,110},
          {150,-50},{200,-50}}, color={0,0,127}));
  connect(retDamPosMinSwitch.y, minRetDam.f2) annotation (Line(points={{62,-20},
          {62,-18},{62,-20},{100,-20},{100,102},{118,102}}, color={0,0,127}));
  connect(sigFraForOutDam.y, minRetDam.x1) annotation (Line(points={{-38,210},{-30,
          210},{-30,118},{118,118}}, color={0,0,127}));
  connect(maxSigLim.y, minRetDam.x2) annotation (Line(points={{2,210},{8,210},{8,
          106},{118,106}}, color={0,0,127}));
  connect(VOut_flow_normalized, damLimCon.u_m) annotation (Line(points={{-200,170},
          {-130,170},{-130,178}}, color={0,0,127}));
  connect(VOutMinSet_flow_normalized, damLimCon.u_s) annotation (Line(points={{-200,
          220},{-160,220},{-160,190},{-142,190}}, color={0,0,127}));
  connect(damLimCon.y, minRetDam.u) annotation (Line(points={{-118,190},{-80,190},
          {-80,110},{118,110}},      color={0,0,127}));
  connect(outDamPosMaxSwitch.y, minOutDam.f2) annotation (Line(points={{62,20},{
          110,20},{110,142},{118,142}}, color={0,0,127}));
  connect(minSigLim.y, minOutDam.x1) annotation (Line(points={{-78,210},{-70,210},
          {-70,182},{104,182},{104,158},{118,158}},      color={0,0,127}));
  connect(sigFraForOutDam.y, minOutDam.x2) annotation (Line(points={{-38,210},{-38,
          210},{-30,210},{-30,146},{118,146}},     color={0,0,127}));
  connect(damLimCon.y, minOutDam.u) annotation (Line(points={{-118,190},{-80,190},
          {-80,150},{118,150}},      color={0,0,127}));
  connect(outDamPosMaxSwitch.y, yOutDamPosMax) annotation (Line(points={{62,20},
          {110,20},{110,50},{200,50}}, color={0,0,127}));
  connect(minOutDam.y, yOutDamPosMin) annotation (Line(points={{142,150},{160,150},
          {160,100},{200,100}},    color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, retDamPosMinSwitch.u1) annotation (Line(points={{-138,
          -40},{-60,-40},{-60,-12},{38,-12}},   color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, minRetDam.f1) annotation (Line(points={{-138,-40},
          {-60,-40},{-60,114},{118,114}}, color={0,0,127}));
  connect(retDamPhyPosMinSig.y, retDamPosMinSwitch.u3) annotation (Line(points={{-138,0},
          {-120,0},{-120,-28},{38,-28}},          color={0,0,127}));
  connect(outDamPhyPosMaxSig.y, outDamPosMaxSwitch.u3) annotation (Line(points={{-138,40},
          {-120,40},{-120,12},{38,12}},           color={0,0,127}));
  connect(outDamPhyPosMinSig.y, outDamPosMaxSwitch.u1) annotation (Line(points={{-138,80},
          {0,80},{0,28},{38,28}},           color={0,0,127}));
  connect(outDamPhyPosMinSig.y, minOutDam.f1) annotation (Line(points={{-138,80},
          {0,80},{0,154},{118,154}}, color={0,0,127}));
  connect(not1.y, retDamPosMinSwitch.u2) annotation (Line(points={{14,-100},{20,
          -100},{20,-20},{38,-20}},color={255,0,255}));
  connect(not1.y, outDamPosMaxSwitch.u2) annotation (Line(points={{14,-100},{20,
          -100},{20,20},{38,20}},color={255,0,255}));
  connect(retDamPosMinSwitch.y, yRetDamPosMin) annotation (Line(points={{62,-20},
          {100,-20},{100,0},{200,0}}, color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, yRetDamPhyPosMax) annotation (Line(points={{-138,
          -40},{40,-40},{40,-90},{200,-90}}, color={0,0,127}));
  connect(uOpeMod, intEqu.u1)
    annotation (Line(points={{-200,-180},{-122,-180}}, color={255,127,0}));
  connect(conInt1.y, intEqu.u2)
    annotation (Line(points={{-138,-200},{-130,-200},{-130,-188},{-122,-188}},
      color={255,127,0}));
  connect(conInt.y, intLesEqu.u2)
    annotation (Line(points={{-138,-160},{-130,-160},{-130,-148},{-122,-148}},
      color={255,127,0}));
  connect(uFreProSta, intLesEqu.u1)
    annotation (Line(points={{-200,-140},{-122,-140}}, color={255,127,0}));
  connect(damLimCon.trigger, uSupFan)
    annotation (Line(points={{-136,178},{-136,166},{-100,166},{-100,-100},{-200,
          -100}},               color={255,0,255}));
  connect(uSupFan, and2.u1) annotation (Line(points={{-200,-100},{-140,-100},{-140,
          -100},{-82,-100}}, color={255,0,255}));
  connect(intLesEqu.y, and2.u2) annotation (Line(points={{-98,-140},{-90,-140},{
          -90,-108},{-82,-108}}, color={255,0,255}));
  connect(and2.y, and3.u1)
    annotation (Line(points={{-58,-100},{-42,-100}}, color={255,0,255}));
  connect(and3.y, not1.u)
    annotation (Line(points={{-18,-100},{-10,-100}}, color={255,0,255}));
  connect(intEqu.y, and3.u2) annotation (Line(points={{-98,-180},{-50,-180},{-50,
          -108},{-42,-108}}, color={255,0,255}));

annotation (
    defaultComponentName="damLim",
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-88,138},{88,108}},
          textColor={0,0,127},
          textString="%name"),
        Line(
          points={{-60,-60},{2,62},{2,62},{64,-60},{-60,-60}},
          color={0,0,127},
          thickness=0.5)}),
    Diagram(coordinateSystem(extent={{-180,-240},{180,240}}), graphics={
        Rectangle(
          extent={{-172,-74},{16,-234}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-172,232},{16,128}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{24,232},{172,-232}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-172,124},{16,-68}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{26,230},{172,184}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position limit
calculation and
assignments"),
        Text(
          extent={{-170,160},{-4,130}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Physical damper position
limits set at commissioning"),
        Text(
          extent={{28,78},{150,30}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Switches to deactivate
limit modulation"),
        Text(
          extent={{-80,-196},{124,-226}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Enable/disable conditions
for damper position limits
control loop"),
        Text(
          extent={{-170,126},{14,94}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position limits
outdoor air volume flow
control loop")}),
    Documentation(info="<html>
<p>
This block models the multi zone VAV AHU minimum outdoor air control with a single
common damper for minimum outdoor air and economizer functions based on outdoor airflow
measurement, designed in line with ASHRAE Guidline 36 (G36), PART 5.N.6.c.
</p>
<p>
The controller is enabled when the supply fan is proven on (<code>uSupFan=true</code>),
the AHU operation mode <a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes</a> equals <code>occupied</code>,
and the freeze protection stage <a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages</a> is <code>stage1</code> or lower.
Otherwise the damper position limits are set to their corresponding maximum and minimum physical or at
commissioning fixed limits. The state machine chart below illustrates listed conditions:
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits state machine chart\"
src=\"modelica://Buildings/Resources/Images/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/EconDamperLimitsStateMachineChart.png\"/>
</p>
<p>
The controller sets the outdoor and return damper position limits so
that the outdoor airflow rate <code>VOut_flow</code> stays equal or above the
minimum outdoor air setpoint <code>VOutMinSet_flow</code>. The fraction of the controller
output signal between <code>yMin</code> and <code>uRetDamMin</code> is
linearly mapped to the outdoor air damper minimal position <code>yOutDamPosMin</code>
while the fraction of the controller output between <code>uRetDamMin</code> and
<code>yMax</code> is linearly mapped to the return air damper maximum position
<code>yRetDamPosMax</code>. Thus the dampers are not interlocked.
</p>
<p>
The following control charts show the input/output structure and an expected damper position
limits for a well configured controller.
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits control diagram\"
src=\"modelica://Buildings/Resources/Images/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/EconDamperLimitsControlDiagram.png\"/>
</p>
<p>
The expected damper position limits vs. the control loop signal are as follows:
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits control chart\"
src=\"modelica://Buildings/Resources/Images/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/EconDamperLimitsControlChart.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Changed default value of integral time for minimum outdoor air control.
Set <code>yMin</code> to 0.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2019\">#2019</a>.
</li>
<li>
March 14, 2020, by Jianjun Hu:<br/>
Replaced mulAnd by logic and block to avoid vector-valued calculation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1829\">#1829</a>.
</li>
<li>
July 17, 2017, by Michael Wetter:<br/>
Replaced block that checks for equality of real values within a tolerance
by two inequality checks.
</li>
<li>
June 06, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Limits;
