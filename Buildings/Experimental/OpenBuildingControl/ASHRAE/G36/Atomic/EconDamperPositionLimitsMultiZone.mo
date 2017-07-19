within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic;
block EconDamperPositionLimitsMultiZone
  "Multiple zone VAV AHU minimum outdoor air control - damper position limits"

  parameter Real retDamPhyPosMax(min=0, max=1, unit="1") = 1
    "Physically fixed maximum position of the return air damper";
  parameter Real retDamPhyPosMin(min=0, max=1, unit="1") = 0
    "Physically fixed minimum position of the return air damper";
  parameter Real outDamPhyPosMax(min=0, max=1, unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper";
  parameter Real outDamPhyPosMin(min=0, max=1, unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper";
  parameter Real conSigMin=0 "Lower limit of control signal output";
  parameter Real conSigMax=1 "Upper limit of control signal output";
  parameter Real conSigFraOutDam(min=conSigMin, max=conSigMax, unit="1")=0.5
    "Fraction of control loop signal output below which the outdoor air damper limit gets
    modulated and above which the return air damper limit gets modulated";
  parameter Real kPDamLim=1 "Gain of damper limit controller";
  parameter Modelica.SIunits.Time TiDamLim=0.9 "Time constant of damper limit controller integrator block";

  CDL.Interfaces.RealInput VOut_flow(unit="m3/s", quantity="VolumeFlowRate")
    "Measured outdoor volumetric airflow rate"
    annotation (Placement(transformation(extent={{-220,150},{-180,190}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput VOutMinSet_flow(unit="m3/s", quantity="VolumeFlowRate")
    "Minimum outdoor volumetric airflow rate setpoint"
    annotation (Placement(transformation(extent={{-220,200},{-180,240}}),
        iconTransformation(extent={{-120,40},{-100,60}})));
  CDL.Interfaces.IntegerInput uOpeMod "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-220,-200},{-180,-160}}),
    iconTransformation(extent={{-120,-60},{-100,-40}})));
  CDL.Interfaces.IntegerInput uFreProSta "Freeze protection status signal"
    annotation (Placement(transformation(extent={{-220,-160},{-180,-120}}),
    iconTransformation(extent={{-120,-90},{-100,-70}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply fan status signal"
    annotation (Placement(transformation(extent={{-220,-120},{-180,-80}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

  CDL.Interfaces.RealOutput yOutDamPosMin(min=0, max=1, unit="1")
    "Minimum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{180,70},{200,90}}),
    iconTransformation(extent={{100,40},{120,60}})));
  CDL.Interfaces.RealOutput yOutDamPosMax(min=0, max=1, unit="1")
    "Maximum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{180,30},{200,50}}),
    iconTransformation(extent={{100,60},{120,80}})));
  CDL.Interfaces.RealOutput yRetDamPosMin(min=0, max=1, unit="1")
    "Minimum return air damper position limit"
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
    iconTransformation(extent={{100,-10},{120,10}})));
  CDL.Interfaces.RealOutput yRetDamPosMax(min=0, max=1, unit="1")
    "Maximum return air damper position limit"
    annotation (Placement(transformation(extent={{180,-50},{200,-30}}),
        iconTransformation(extent={{100,-30},{120,-10}})));
  CDL.Interfaces.RealOutput yRetDamPhyPosMax(min=0, max=1, unit="1")
    "Physical maximum return air damper position limit. Required as an input for the economizer enable disable sequence"
    annotation (Placement(transformation(extent={{180,-90},{200,-70}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

  CDL.Continuous.LimPID damLimController(
    final Ti=TiDamLim,
    final Td=0.1,
    final yMax=conSigMax,
    final yMin=conSigMin,
    final controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI,
    final k=kPDamLim) "Damper position limit controller"
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));

protected
  CDL.Continuous.Sources.Constant outDamPhyPosMinSig(final k=outDamPhyPosMin)
    "Physically fixed minimum position of the outdoor air damper. This is the initial position of the economizer damper"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  CDL.Continuous.Sources.Constant outDamPhyPosMaxSig(final k=outDamPhyPosMax)
    "Physically fixed maximum position of the outdoor air damper."
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  CDL.Continuous.Sources.Constant retDamPhyPosMinSig(final k=retDamPhyPosMin)
    "Physically fixed minimum position of the return air damper"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  CDL.Continuous.Sources.Constant retDamPhyPosMaxSig(final k=retDamPhyPosMax)
    "Physically fixed maximum position of the return air damper. This is the initial condition of the return air damper"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  CDL.Continuous.Sources.Constant minSignalLimit(final k=conSigMin)
    "Equals minimum controller output signal"
    annotation (Placement(transformation(extent={{-100,200},{-80,220}})));
  CDL.Continuous.Sources.Constant maxSignalLimit(final k=conSigMax)
    "Equals maximum controller output signal"
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));
  CDL.Continuous.Sources.Constant sigFraForOutDam(final k=conSigFraOutDam)
    "Equals the fraction of the control loop signal below which the outdoor air damper
    limit gets modulated and above which the return air damper limit gets modulated"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
  CDL.Continuous.Sources.Constant OperationMode(final k=Constants.OperationModes.occModInd)
    "Control loop is enabled in occupied operation mode"
    annotation (Placement(transformation(extent={{-160,-220},{-140,-200}})));

  CDL.Continuous.Line minOutDam(limitBelow=true, limitAbove=true)
    "Linear mapping of the outdoor air damper position to the control signal"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));
  CDL.Continuous.Line minRetDam(limitBelow=true, limitAbove=true)
    "Linear mapping of the return air damper position to the control signal"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  CDL.Logical.Switch retDamPosMinSwitch
    "A switch to deactivate the return air damper minimal outdoor airflow control"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  CDL.Logical.Switch outDamPosMaxSwitch
    "A switch to deactivate the outdoor air damper minimal outdoor airflow control"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  CDL.Logical.And3 and1 "Locical and block"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  CDL.Logical.Not not1 "Logical not block"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  CDL.Conversions.IntegerToReal intToRea "Integer to real converter"
    annotation (Placement(transformation(extent={{-160,-150},{-140,-130}})));
  CDL.Conversions.IntegerToReal intToRea1 "Integer to real converter"
    annotation (Placement(transformation(extent={{-160,-190},{-140,-170}})));
  CDL.Logical.LessEqualThreshold equ(final threshold=Constants.FreezeProtectionStages.stage1)
    "Any freeze protection stage above 1 disables the control"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  CDL.Logical.Equal equ1 "Logical equal block"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));

equation
  connect(minRetDam.y,yRetDamPosMax)  annotation (Line(points={{141,110},{150,110},{150,20},{150,-40},{190,-40}},
    color={0,0,127}));
  connect(retDamPosMinSwitch.y, minRetDam.f2)
    annotation (Line(points={{61,-20},{61,-18},{61,-20},{100,-20},{100,102},{118,102}},color={0,0,127}));
  connect(sigFraForOutDam.y,minRetDam. x1)
    annotation (Line(points={{-39,210},{-30,210},{-30,118},{118,118}},color={0,0,127}));
  connect(maxSignalLimit.y,minRetDam. x2)
    annotation (Line(points={{1,210},{8,210},{8,106},{118,106}},color={0,0,127}));
  connect(VOut_flow,damLimController. u_m)
    annotation (Line(points={{-200,170},{-130,170},{-130,178}},color={0,0,127}));
  connect(VOutMinSet_flow,damLimController. u_s)
    annotation (Line(points={{-200,220},{-160,220},{-160,190},{-142,190}},color={0,0,127}));
  connect(damLimController.y,minRetDam. u)
    annotation (Line(points={{-119,190},{-80,190},{-80,110},{118,110}},color={0,0,127}));
  connect(outDamPosMaxSwitch.y, minOutDam.f2)
    annotation (Line(points={{61,20},{110,20},{110,142},{118,142}}, color={0,0,127}));
  connect(minSignalLimit.y,minOutDam. x1)
    annotation (Line(points={{-79,210},{-70,210},{-70,158},{118,158}},color={0,0,127}));
  connect(sigFraForOutDam.y,minOutDam. x2)
    annotation (Line(points={{-39,210},{-39,210},{-30,210},{-30,146},{118,146}},color={0,0,127}));
  connect(damLimController.y,minOutDam. u)
    annotation (Line(points={{-119,190},{-80,190},{-80,150},{118,150}},  color={0,0,127}));
  connect(outDamPosMaxSwitch.y, yOutDamPosMax)
    annotation (Line(points={{61,20},{126,20},{126,40},{190,40}},color={0,0,127}));
  connect(minOutDam.y,yOutDamPosMin)
    annotation (Line(points={{141,150},{160,150},{160,80},{190,80}}, color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, retDamPosMinSwitch.u1)
    annotation (Line(points={{-139,-40},{0,-40},{0,-12},{38,-12}}, color={0,0,127}));
  connect(retDamPhyPosMaxSig.y,minRetDam. f1)
    annotation (Line(points={{-139,-40},{-60,-40},{-60,114},{118,114}},color={0,0,127}));
  connect(retDamPhyPosMinSig.y, retDamPosMinSwitch.u3)
    annotation (Line(points={{-139,0},{-120,0},{-120,-28},{38,-28}},color={0,0,127}));
  connect(outDamPhyPosMaxSig.y, outDamPosMaxSwitch.u3)
    annotation (Line(points={{-139,40},{-120,40},{-120,12},{38,12}},color={0,0,127}));
  connect(outDamPhyPosMinSig.y, outDamPosMaxSwitch.u1)
    annotation (Line(points={{-139,80},{0,80},{0,28},{38,28}},color={0,0,127}));
  connect(outDamPhyPosMinSig.y,minOutDam. f1)
    annotation (Line(points={{-139,80},{0,80},{0,154},{118,154}},color={0,0,127}));
  connect(uSupFan,and1. u1)
    annotation (Line(points={{-200,-100},{-108,-100},{-108,-82},{-82,-82}},color={255,0,255}));
  connect(and1.y,not1. u)
    annotation (Line(points={{-59,-90},{-42,-90}},color={255,0,255}));
  connect(not1.y, retDamPosMinSwitch.u2)
    annotation (Line(points={{-19,-90},{20,-90},{20,-20},{38,-20}},color={255,0,255}));
  connect(not1.y, outDamPosMaxSwitch.u2)
    annotation (Line(points={{-19,-90},{-19,-90},{20,-90},{20,20},{38,20}},color={255,0,255}));
  connect(retDamPosMinSwitch.y, yRetDamPosMin)
    annotation (Line(points={{61,-20},{126,-20},{126,0},{190,0}},color={0,0,127}));
  connect(and1.u2, equ.y)
    annotation (Line(points={{-82,-90},{-90,-90},{-90,-140},{-99,-140}},color={255,0,255}));
  connect(intToRea.u, uFreProSta)
    annotation (Line(points={{-162,-140},{-162,-140},{-200,-140}}, color={255,127,0}));
  connect(intToRea.y, equ.u)
    annotation (Line(points={{-139,-140},{-130,-140},{-122,-140}}, color={0,0,127}));
  connect(uOpeMod, intToRea1.u)
    annotation (Line(points={{-200,-180},{-182,-180},{-162,-180}}, color={255,127,0}));
  connect(and1.u3, equ1.y)
    annotation (Line(points={{-82,-98},{-86,-98},{-86,-180},{-99,-180}},color={255,0,255}));
  connect(intToRea1.y, equ1.u1)
    annotation (Line(points={{-139,-180},{-130.5,-180},{-122,-180}}, color={0,0,127}));
  connect(OperationMode.y, equ1.u2)
    annotation (Line(points={{-139,-210},{-130,-210},{-130,-188},{-122,-188}},color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, yRetDamPhyPosMax)
    annotation (Line(points={{-139,-40},{40,-40},{40,-80},{190,-80}},color={0,0,127}));
  connect(yRetDamPosMin, yRetDamPosMin) annotation (Line(points={{190,0},{190,0}}, color={0,0,127}));
  annotation (
    defaultComponentName = "ecoDamLim",
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-88,138},{88,108}},
          lineColor={0,0,127},
          textString="%name"),
        Line(
          points={{-60,-60},{2,62},{2,62},{64,-60},{-60,-60}},
          color={0,0,127},
          thickness=0.5)}),
    Diagram(coordinateSystem(extent={{-180,-240},{180,240}},
        initialScale=0.1), graphics={
        Rectangle(
          extent={{-172,232},{16,128}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-172,-72},{16,-232}},
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
          extent={{32,228},{146,204}},
          lineColor={0,0,0},
          fontSize=12,
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position limit
calculation and assignments"),     Text(
          extent={{-160,152},{-16,70}},
          lineColor={0,0,0},
          fontSize=12,
          horizontalAlignment=TextAlignment.Left,
          textString="Physical damper position
limits set at commissioning"),
          Text(extent={{36,68},{114,28}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Switches to deactivate
limit modulation"),                Text(
          extent={{-78,-170},{66,-252}},
          lineColor={0,0,0},
          fontSize=12,
          horizontalAlignment=TextAlignment.Left,
          textString="Enable/disable conditions
for damper position limits
control loop"),                    Text(
          extent={{-160,170},{-16,122}},
          lineColor={0,0,0},
          fontSize=12,
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position limits
outdoor air volume flow
control loop")}),
Documentation(info="<html>
<p>
This block models the multiple zone VAV AHU minimum outdoor air control with a single
common damper for minimum outdoor air and economizer functions based on outdoor airflow
measurement, designed in line with ASHRAE Guidline 36 (G36), PART5.N.6.c.
</p>
<p>
The controller is enabled when the supply fan is proven on (<code>uSupFan=true</code>),
the AHU operation mode, <a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Constants.OperationModes\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Constants.OperationModes</a>, equals <code>occModInt</code>, 
and freeze protection stage, <a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Constants.FreezeProtectionStages\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Constants.FreezeProtectionStages</a>, is not higher than
<code>stage1</code>.
Otherwise the damper position limits are set to their corresponding maximum and minimum physical or at 
commissioning fixed limits. State machine chart below illustrates listed conditions:
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits state machine chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/EconDamperLimitsStateMachineChartMultiZone.png\"/>
</p>
<p>
The controller sets the outdoor and return damper position limits so
that the outdoor airflow rate, <code>VOut_flow</code>, stays equal or above the
minimum outdoor air setpoint, <code>VOutMinSet_flow</code>. Fraction of the controller
output signal between <code>conSigMin</code> and <code>conSigFraOutDam</code> is
linearly mapped to the outdoor air damper minimal position, <code>yOutDamPosMin</code>,
while the fraction of the controller output between <code>conSigFraOutDam</code> and
<code>conSigMax</code> is linearly mapped to the return air damper maximum position,
<code>yRetDamPosMax</code>. Thus the dampers are not interlocked.
</p>
<p>
The following control charts show the input/output structure and an expected damper position
limits for a well tuned controller. Control diagram:
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits control diagram\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/EconDamperLimitsControlDiagramMultiZone.png\"/>
</p>
<p>
Expected control performance (damper position limits vs. control loop signal):
<br/>
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits control chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/EconDamperLimitsControlChartMultiZone.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
June 06, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconDamperPositionLimitsMultiZone;
