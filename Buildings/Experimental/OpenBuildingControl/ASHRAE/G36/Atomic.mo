within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36;
package Atomic "Subsequences as defined in guidline G36"

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
      "Measured outdoor volumetric airflow rate [fixme: which quantity attribute should we use, add for all volume flow]"
      annotation (Placement(transformation(extent={{-220,150},{-180,190}}),
          iconTransformation(extent={{-120,70},{-100,90}})));
    CDL.Interfaces.RealInput VOutMinSet_flow(unit="m3/s", quantity="VolumeFlowRate")
      "Minimum outdoor volumetric airflow rate setpoint"
      annotation (Placement(transformation(extent={{-220,200},{-180,240}}),
          iconTransformation(extent={{-120,40},{-100,60}})));
    CDL.Interfaces.IntegerInput uOperationMode "AHU operation mode status signal"
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
      Ti=TiDamLim,
      Td=0.1,
      final yMax=conSigMax,
      final yMin=conSigMin,
      controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI,
      k=kPDamLim) "Damper position limit controller"
      annotation (Placement(transformation(extent={{-140,180},{-120,200}})));
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
    CDL.Logical.LessEqualThreshold equ(final threshold=allowedFreProStaNum)
      "Freeze protection stage above allowedFreProStaNum disables the control"
      annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
    CDL.Logical.Equal equ1 "Logical equal block"
      annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));

  protected
    parameter Types.FreezeProtectionStage allowedFreProSta = Types.FreezeProtectionStage.stage1
      "Freeze protection stage 1";
    parameter Real allowedFreProStaNum = Integer(allowedFreProSta)-1
      "Freeze protection stage control loop upper enable limit";
    parameter Types.OperationMode occupied = Types.OperationMode.occupied "Operation mode is Occupied";
    parameter Real occupiedNum = Integer(occupied) "Numerical value for Occupied operation mode";

    CDL.Continuous.Constant outDamPhyPosMinSig(final k=outDamPhyPosMin)
      "Physically fixed minimum position of the outdoor air damper. This is the initial position of the economizer damper"
      annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
    CDL.Continuous.Constant outDamPhyPosMaxSig(final k=outDamPhyPosMax)
      "Physically fixed maximum position of the outdoor air damper."
      annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
    CDL.Continuous.Constant retDamPhyPosMinSig(final k=retDamPhyPosMin)
      "Physically fixed minimum position of the return air damper"
      annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
    CDL.Continuous.Constant retDamPhyPosMaxSig(final k=retDamPhyPosMax)
      "Physically fixed maximum position of the return air damper. This is the initial condition of the return air damper"
      annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
    CDL.Continuous.Constant minSignalLimit(final k=conSigMin)
      "Equals minimum controller output signal"
      annotation (Placement(transformation(extent={{-100,200},{-80,220}})));
    CDL.Continuous.Constant maxSignalLimit(final k=conSigMax)
      "Equals maximum controller output signal"
      annotation (Placement(transformation(extent={{-20,200},{0,220}})));
    CDL.Continuous.Constant sigFraForOutDam(final k=conSigFraOutDam)
      "Equals the fraction of the control loop signal below which the outdoor air damper
    limit gets modulated and above which the return air damper limit gets modulated"
      annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
    CDL.Continuous.Constant OperationMode(final k=occupiedNum) "Control loop is enabled in occupied operation mode"
      annotation (Placement(transformation(extent={{-160,-220},{-140,-200}})));

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
    connect(uOperationMode, intToRea1.u)
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
calculation and assignments"),       Text(
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
limit modulation"),                  Text(
            extent={{-78,-170},{66,-252}},
            lineColor={0,0,0},
            fontSize=12,
            horizontalAlignment=TextAlignment.Left,
            textString="Enable/disable conditions
for damper position limits
control loop"),                      Text(
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
the AHU operation mode (<code>OperationMode</code>) is Occupied, and Freeze protection stage
<code>uFreProSta</code> is not larger than 1. Otherwise the damper position limits are set to
their corresponding maximum and minimum physical or at commissioning fixed limits, as illustrated below:
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
</html>",   revisions="<html>
<ul>
<li>
June 06, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
  end EconDamperPositionLimitsMultiZone;

  block EconEnableDisableMultiZone
    "Multiple zone VAV AHU economizer enable/disable switch"

    parameter Boolean use_enthalpy = true
      "Set to true to evaluate outdoor air enthalpy in addition to temperature";
    parameter Modelica.SIunits.Temperature delTemHis=1
      "Delta between the temperature hysteresis high and low limit";
    parameter Modelica.SIunits.SpecificEnergy delEntHis=1000
      "Delta between the enthalpy hysteresis high and low limits"
      annotation(Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = use_enthalpy));
    parameter Modelica.SIunits.Time retDamFulOpeTim = 180
      "Time period to keep RA damper fully open at disable to avoid pressure fluctuations";
    parameter Modelica.SIunits.Time smaDisDel = 15
      "Small time delay before closing the OA damper at disable to avoid pressure fluctuations";

    CDL.Interfaces.RealInput TOut(unit="K", quantity = "ThermodynamicTemperature") "Outdoor air (OA) temperature"
      annotation (Placement(transformation(extent={{-220,250},{-180,290}}),
          iconTransformation(extent={{-120,90},{-100,110}})));
    CDL.Interfaces.RealInput hOut(unit="J/kg", quantity="SpecificEnergy") if use_enthalpy
        "Outdoor air enthalpy"
        annotation (Placement(transformation(extent={{-220,170},{-180,210}}),
          iconTransformation(extent={{-120,50},{-100,70}})));
    CDL.Interfaces.RealInput TOutCut(unit="K", quantity = "ThermodynamicTemperature")
      "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
      annotation (Placement(transformation(extent={{-220,210},{-180,250}}),
          iconTransformation(extent={{-120,70},{-100,90}})));
    CDL.Interfaces.RealInput hOutCut(unit="J/kg") if use_enthalpy
      "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
      annotation (Placement(transformation(extent={{-220,130},{-180,170}}),iconTransformation(extent={{-120,30},{-100,50}})));
    CDL.Interfaces.RealInput uOutDamPosMin(min=0, max=1)
      "Minimum outdoor air damper position, from EconDamperPositionLimitsMultiZone sequence"
      annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
          iconTransformation(extent={{-120,-70},{-100,-50}})));
    CDL.Interfaces.RealInput uOutDamPosMax(min=0, max=1)
      "Maximum outdoor air damper position, from EconDamperPositionLimitsMultiZone sequence"
      annotation (Placement(transformation(extent={{-220,-150},{-180,-110}}),
          iconTransformation(extent={{-120,-50},{-100,-30}})));
    CDL.Interfaces.RealInput uRetDamPosMax(min=0, max=1)
      "Maximum return air damper position, from EconDamperPositionLimitsMultiZone sequence"
      annotation (Placement(transformation(extent={{-220,-250},{-180,-210}}),
          iconTransformation(extent={{-120,-110},{-100,-90}})));
    CDL.Interfaces.RealInput uRetDamPosMin(min=0, max=1)
      "Minimum return air damper position, from EconDamperPositionLimitsMultiZone sequence"
      annotation (Placement(transformation(extent={{-220,-280},{-180,-240}}),
          iconTransformation(extent={{-120,-130},{-100,-110}})));
    CDL.Interfaces.RealInput uRetDamPhyPosMax(min=0, max=1)
      "Physical maximum return air damper position, from EconDamperPositionLimitsMultiZone sequence"
      annotation (Placement(transformation(extent={{-220,-220},{-180,-180}}),
          iconTransformation(extent={{-120,-90},{-100,-70}})));
    CDL.Interfaces.BooleanInput uSupFan "Supply fan on/off status signal"
      annotation (Placement(transformation(extent={{-220,90},{-180,130}}),iconTransformation(extent={{-120,-30},{-100,-10}})));
    CDL.Interfaces.IntegerInput uZoneState "Zone state status signal"
      annotation (Placement(transformation(extent={{-220,-30},{-180,10}}),
          iconTransformation(extent={{-120,-10},{-100,10}})));
    CDL.Interfaces.IntegerInput uFreProSta "Freeze protection stage status signal"
      annotation (Placement(transformation(extent={{-220,30},{-180,70}}),
          iconTransformation(extent={{-120,10},{-100,30}})));

    CDL.Interfaces.RealOutput yOutDamPosMax "Maximum outdoor air damper position"
      annotation (Placement(transformation(extent={{180,-150},{200,-130}}),
          iconTransformation(extent={{100,28},{140,68}})));
    CDL.Interfaces.RealOutput yRetDamPosMin "Minimum return air damper position"
      annotation (Placement(transformation(extent={{180,-260},{200,-240}}),
          iconTransformation(extent={{100,-100},{140,-60}})));
    CDL.Interfaces.RealOutput yRetDamPosMax "Maximum return air damper position"
      annotation (Placement(transformation(
          extent={{180,-220},{200,-200}}), iconTransformation(extent={{100,-40},{140,0}})));

    CDL.Logical.Hysteresis hysOutTem(final uHigh=uTemHigLimCutHig, final uLow=uTemHigLimCutLow)
      "Outdoor air temperature hysteresis for both fixed and differential dry bulb temperature cutoff conditions"
      annotation (Placement(transformation(extent={{-100,240},{-80,260}})));
    CDL.Logical.Hysteresis hysOutEnt(final uLow=uEntHigLimCutLow, final uHigh=uEntHigLimCutHig) if use_enthalpy
      "Outdoor air enthalpy hysteresis for both fixed and differential enthalpy cutoff conditions"
      annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
    CDL.Logical.Switch OutDamSwitch "Set maximum OA damper position to minimum at disable (after time delay)"
      annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
    CDL.Logical.Switch RetDamSwitch "Set minimum RA damper position to maximum at disable"
      annotation (Placement(transformation(extent={{-60,-270},{-40,-250}})));
    CDL.Logical.Switch MaxRetDamSwitch
      "Keep maximum RA damper position at physical maximum for a short time period after disable signal"
      annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
    CDL.Logical.Switch MinRetDamSwitch
      "Keep minimum RA damper position at physical maximum for a short time period after disable"
      annotation (Placement(transformation(extent={{40,-260},{60,-240}})));
    CDL.Logical.TrueFalseHold TrueFalseHold(duration=600) "10 min on/off delay"
      annotation (Placement(transformation(extent={{0,200},{20,220}})));
    CDL.Logical.GreaterEqual greEqu "Logical greater or equal block"
      annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
    CDL.Logical.Timer timer "Timer gets started as the economizer gets disabled"
      annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
    CDL.Logical.Nor nor1 "Logical nor"
      annotation (Placement(transformation(extent={{-40,200},{-20,220}})));
    CDL.Logical.Not not2 "Logical \"not\" starts the timer at disable signal "
      annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
    CDL.Logical.Less les1 "Check if the RA damper should be fully open"
      annotation (Placement(transformation(extent={{-8,-190},{12,-170}})));
    CDL.Logical.And3 andEnaDis "Logical \"and\" checks freeze protection stage and zone state"
     annotation (Placement(transformation(extent={{40,30},{60,50}})));
    CDL.Logical.LessEqualThreshold equ(final threshold=freProDisabledNum)
      "Logical block to check if the freeze protection is deactivated"
      annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
    CDL.Logical.GreaterThreshold greThr(final threshold=heatingNum) "Check if ZoneState is other than heating"
      annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
    CDL.Logical.GreaterThreshold greThr2(final threshold=0) "Check if the timer got started"
      annotation (Placement(transformation(extent={{88,-182},{108,-162}})));
    CDL.Logical.And3 and2 "Logical and"
      annotation (Placement(transformation(extent={{130,-200},{150,-180}})));
    CDL.Logical.And and1 "Logical \"and\" checks supply fan status"
      annotation (Placement(transformation(extent={{0,100},{20,120}})));
    CDL.Conversions.IntegerToReal intToRea "Integer to real converter"
      annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
    CDL.Conversions.IntegerToReal intToRea1 "Integer to real converter"
      annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));

  protected
    parameter Real uTemHigLimCutHig(final unit="K", quantity = "ThermodynamicTemperature") = 0
      "Hysteresis high limit cutoff";
    parameter Real uTemHigLimCutLow(
      final unit="K", quantity = "ThermodynamicTemperature") = uTemHigLimCutHig - delTemHis
      "Hysteresis low limit cutoff";
    parameter Real uEntHigLimCutHig(final unit="J/kg", quantity="SpecificEnergy") = 0
      "Hysteresis block high limit cutoff";
    parameter Real uEntHigLimCutLow(final unit="J/kg", quantity="SpecificEnergy") = uEntHigLimCutHig - delEntHis
      "Hysteresis block low limit cutoff";
    parameter Types.FreezeProtectionStage freProDisabled = Types.FreezeProtectionStage.stage0
      "Freeze protection stage 0 (disabled)";
    parameter Real freProDisabledNum = Integer(freProDisabled)-1
      "Numerical value for freeze protection stage 0";
    parameter Types.ZoneState heating = Types.ZoneState.heating "Heating zone state";
    parameter Real heatingNum = Integer(heating) "Numerical value for heating zone state";

    CDL.Continuous.Constant openRetDam(final k=retDamFulOpeTim)
      "Keep return damper open to its physical maximum for a short period of time before closing the outdoor air damper
    and resuming the maximum return air damper position, per G36 Part N7"
      annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
    CDL.Continuous.Constant disableDelay(final k=smaDisDel)
      "Small delay before closing the outdoor air damper to avoid pressure fluctuations"
      annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
    CDL.Continuous.Add add2(k2=-1) if use_enthalpy "Add block determines difference between hOut and hOutCut"
      annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
    CDL.Continuous.Add add1(k2=-1) "Add block determines difference between TOut and TOutCut"
      annotation (Placement(transformation(extent={{-140,240},{-120,260}})));
    CDL.Logical.Constant entSubst(final k=false) if not use_enthalpy
      "Deactivates outdoor air enthalpy condition if there is no enthalpy sensor"
      annotation (Placement(transformation(extent={{-100,190},{-80,210}})));

  equation
    connect(OutDamSwitch.y, yOutDamPosMax) annotation (Line(points={{61,-140},{61,-140},{190,-140}}, color={0,0,127}));
    connect(TOut, add1.u1) annotation (Line(points={{-200,270},{-160,270},{-160,256},{-142,256}},
          color={0,0,127}));
    connect(TOutCut, add1.u2) annotation (Line(points={{-200,230},{-160,230},{-160,244},{-142,244}},
          color={0,0,127}));
    connect(add1.y, hysOutTem.u) annotation (Line(points={{-119,250},{-102,250}}, color={0,0,127}));
    connect(hOut, add2.u1) annotation (Line(points={{-200,190},{-160,190},{-160,176},{-142,176}},
          color={0,0,127}));
    connect(hOutCut, add2.u2)
      annotation (Line(points={{-200,150},{-160,150},{-160,164},{-142,164}}, color={0,0,127}));
    connect(add2.y, hysOutEnt.u) annotation (Line(points={{-119,170},{-102,170}}, color={0,0,127}));
    connect(hysOutTem.y, nor1.u1) annotation (Line(points={{-79,250},{-60,250},{-60,210},{-42,210}}, color={255,0,255}));
    if use_enthalpy then
      connect(hysOutEnt.y, nor1.u2)
        annotation (Line(points={{-79,170},{-60,170},{-60,202},{-42,202}},  color={255,0,255}));
    else
      connect(entSubst.y, nor1.u2) annotation (Line(points={{-79,200},{-60,200},{-60,202},{-42,202}}, color={255,0,255}));
    end if;
    connect(disableDelay.y, greEqu.u2)
      annotation (Line(points={{-39,-110},{-20,-110},{-20,-108},{-12,-108}}, color={0,0,127}));
    connect(timer.y, greEqu.u1) annotation (Line(points={{51,-60},{62,-60},{62,-80},{-20,-80},{-20,-100},{-12,-100}},
          color={0,0,127}));
    connect(greEqu.y, OutDamSwitch.u2) annotation (Line(points={{11,-100},{20,-100},{20,-140},{38,-140}}, color={255,0,255}));
    connect(uOutDamPosMin, OutDamSwitch.u1)
      annotation (Line(points={{-200,-160},{-120,-160},{-120,-134},{-120,-132},{38,-132}}, color={0,0,127}));
    connect(uOutDamPosMax, OutDamSwitch.u3)
      annotation (Line(points={{-200,-130},{-80,-130},{-80,-148},{38,-148}}, color={0,0,127}));
    connect(uRetDamPhyPosMax, MaxRetDamSwitch.u1)
      annotation (Line(points={{-200,-200},{-78,-200},{-78,-202},{38,-202}}, color={0,0,127}));
    connect(uRetDamPosMax, MaxRetDamSwitch.u3)
      annotation (Line(points={{-200,-230},{-78,-230},{-78,-218},{38,-218}}, color={0,0,127}));
    connect(timer.y, les1.u1)
      annotation (Line(points={{51,-60},{72,-60},{72,-154},{-20,-154},{-20,-180},{-10,-180}},color={0,0,127}));
    connect(nor1.y, TrueFalseHold.u) annotation (Line(points={{-19,210},{-1,210}}, color={255,0,255}));
    connect(andEnaDis.y, not2.u)
      annotation (Line(points={{61,40},{72,40},{72,-20},{-20,-20},{-20,-60},{-12,-60}}, color={255,0,255}));
    connect(MinRetDamSwitch.y, yRetDamPosMin)
      annotation (Line(points={{61,-250},{124,-250},{190,-250}}, color={0,0,127}));
    connect(MaxRetDamSwitch.y, yRetDamPosMax) annotation (Line(points={{61,-210},{190,-210}},  color={0,0,127}));
    connect(openRetDam.y, les1.u2)
      annotation (Line(points={{-39,-180},{-30,-180},{-30,-188},{-10,-188}}, color={0,0,127}));
    connect(not2.y, timer.u) annotation (Line(points={{11,-60},{28,-60}},   color={255,0,255}));
    connect(uFreProSta, intToRea.u) annotation (Line(points={{-200,50},{-200,50},{-162,50}}, color={255,127,0}));
    connect(intToRea.y, equ.u) annotation (Line(points={{-139,50},{-134,50},{-122,50}}, color={0,0,127}));
    connect(equ.y, andEnaDis.u2)
      annotation (Line(points={{-99,50},{-62,50},{-20,50},{-20,40},{38,40}},color={255,0,255}));
    connect(uZoneState, intToRea1.u) annotation (Line(points={{-200,-10},{-182,-10},{-162,-10}}, color={255,127,0}));
    connect(intToRea1.y, greThr.u) annotation (Line(points={{-139,-10},{-134,-10},{-130,-10},{-122,-10}}, color={0,0,127}));
    connect(greThr.y, andEnaDis.u3)
      annotation (Line(points={{-99,-10},{-20,-10},{-20,32},{38,32}}, color={255,0,255}));
    connect(and2.y, MaxRetDamSwitch.u2)
      annotation (Line(points={{151,-190},{162,-190},{162,-230},{20,-230},{20,-210},{38,-210}}, color={255,0,255}));
    connect(and2.y, MinRetDamSwitch.u2)
      annotation (Line(points={{151,-190},{162,-190},{162,-230},{20,-230},{20,-250},{38,-250}}, color={255,0,255}));
    connect(timer.y, greThr2.u)
      annotation (Line(points={{51,-60},{82,-60},{82,-172},{86,-172}},   color={0,0,127}));
    connect(not2.y, RetDamSwitch.u2)
      annotation (Line(points={{11,-60},{20,-60},{20,-72},{-90,-72},{-90,-260},{-62,-260}},color={255,0,255}));
    connect(uRetDamPosMax, RetDamSwitch.u1)
      annotation (Line(points={{-200,-230},{-140,-230},{-140,-252},{-62,-252}},color={0,0,127}));
    connect(uRetDamPosMin, RetDamSwitch.u3)
      annotation (Line(points={{-200,-260},{-140,-260},{-140,-268},{-62,-268}},color={0,0,127}));
    connect(RetDamSwitch.y, MinRetDamSwitch.u3)
      annotation (Line(points={{-39,-260},{-30,-260},{-30,-258},{38,-258}},color={0,0,127}));
    connect(uRetDamPhyPosMax, MinRetDamSwitch.u1)
      annotation (Line(points={{-200,-200},{-120,-200},{-120,-242},{38,-242}},color={0,0,127}));
    connect(TrueFalseHold.y, and1.u1)
      annotation (Line(points={{21,210},{30,210},{30,130},{-10,130},{-10,110},{-2,110}},color={255,0,255}));
    connect(and1.y, andEnaDis.u1)
      annotation (Line(points={{21,110},{21,110},{30,110},{30,48},{38,48}},color={255,0,255}));
    connect(greThr2.y, and2.u1)
      annotation (Line(points={{109,-172},{120,-172},{120,-182},{128,-182}}, color={255,0,255}));
    connect(les1.y, and2.u2)
      annotation (Line(points={{13,-180},{20,-180},{20,-188},{112,-188},{112,-190},{128,-190}},
                                                                         color={255,0,255}));
    connect(uSupFan, and1.u2)
      annotation (Line(points={{-200,110},{-102,110},{-102,102},{-2,102}},color={255,0,255}));
    connect(not2.y, and2.u3)
      annotation (Line(points={{11,-60},{20,-60},{20,-76},{78,-76},{78,-198},{128,-198}}, color={255,0,255}));
      annotation(Evaluate=true, Dialog(group="Enthalpy sensor in use", enable = use_enthalpy),
      Icon(graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-2,60},{78,60}},
            color={0,0,127},
            thickness=0.5),
          Line(
            points={{-78,-64},{-2,-64},{-2,60}},
            color={0,0,127},
            thickness=0.5),
          Text(
            extent={{-170,150},{158,112}},
            lineColor={0,0,127},
            textString="%name")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-180,-280},{180,280}},
          initialScale=0.1), graphics={
          Rectangle(
            extent={{-170,-44},{170,-272}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-170,16},{170,-36}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-170,76},{170,24}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-170,136},{170,84}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-170,272},{170,144}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
                                       Text(
            extent={{102,168},{184,156}},
            lineColor={0,0,0},
            horizontalAlignment=TextAlignment.Left,
            textString="Outdoor air
conditions"),                          Text(
            extent={{100,70},{278,36}},
            lineColor={0,0,0},
            horizontalAlignment=TextAlignment.Left,
            textString="Freeze protection -
disable if \"stage1\"
and above"),                           Text(
            extent={{100,-42},{268,-90}},
            lineColor={0,0,0},
            horizontalAlignment=TextAlignment.Left,
            textString="Damper position
limit assignments
with delays"),                         Text(
            extent={{102,18},{226,-34}},
            lineColor={0,0,0},
            horizontalAlignment=TextAlignment.Left,
            textString="Zone state -
disable if
Heating"),                         Text(
            extent={{100,102},{194,92}},
            lineColor={0,0,0},
            horizontalAlignment=TextAlignment.Left,
            textString="Supply fan status")}),
  Documentation(info="<html>
<p>
This is a multiple zone VAV AHU economizer enable/disable sequence
based on ASHRAE G36 PART5-N.7 and PART5-A.17. Additional
conditions included in the sequence are: freeze protection (freeze protection
stage 0-3, see PART5-N.12), supply fan status (on or off, see PART5-N.5),
and zone state (cooling, heating, or deadband, as illustrated in the
modulation control chart, PART5-N.2.c).
</p>
<p>
Economizer shall be disabled whenever the outdoor air conditions
exceed the economizer high limit setpoint as specified by the local
code. This sequence allows for all device types listed in
ASHRAE 90.1-2013 and Title 24-2013.
</p>
<p>
In addition, economizer shall be disabled without a delay whenever any of the
following is true: supply fan is off, zone state is <code>Heating</code>,
freeze protection stage is not <code>0</code>.
</p>
<p>
The following state machine chart illustrates the above listed conditions:
</p>
<p align=\"center\">
<img alt=\"Image of economizer enable-disable state machine chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/EconEnableDisableStateMachineChartMultiZone.png\"/>
</p>
</html>",   revisions="<html>
<ul>
<li>
June 27, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
  end EconEnableDisableMultiZone;

  block EconModulationMultiZone
    "Outdoor and return air damper position modulation sequence for multiple zone VAV AHU"

    parameter Real outDamConSigMax(min=0, max=1, unit="1") = retDamConSigMin
    "Maximum control loop signal for the outdoor air damper";
    parameter Real retDamConSigMin(min=0, max=1, unit="1") = 0.5
    "Minimum control loop signal for the return air damper";
    parameter Real conSigMin=0 "Lower limit of controller output";
    parameter Real conSigMax=1 "Upper limit of controller output";
    parameter Real kPMod=1 "Gain of modulation controller";
    parameter Modelica.SIunits.Time TiMod=300 "Time constant of modulation controller integrator block";

    CDL.Interfaces.RealInput TSup(unit="K", quantity = "ThermodynamicTemperature")
      "Measured supply air temperature" annotation (Placement(transformation(extent={{-160,-40},{-120,0}}),
          iconTransformation(extent={{-120,50},{-100,70}})));
    CDL.Interfaces.RealInput TCooSet(unit="K", quantity = "ThermodynamicTemperature")
      "Supply air temperature cooling setpoint" annotation (Placement(transformation(extent={{-160,-10},{-120,30}}),
          iconTransformation(extent={{-120,80},{-100,100}})));
    CDL.Interfaces.RealInput uOutDamPosMin(min=0, max=1, unit="1")
      "Minimum economizer damper position limit as returned by the EconDamperPositionLimitsMultiZone sequence"
      annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
          iconTransformation(extent={{-120,-30},{-100,-10}})));    //fixme: add quantity for ALL damper positions?
    CDL.Interfaces.RealInput uOutDamPosMax(min=0, max=1, unit="1")
      "Maximum economizer damper position limit as returned by the EconEnableDisableMultiZone sequence.
    If the economizer is disabled, this value equals uOutDamPosMin"
      annotation (Placement(transformation(extent={{-160,-90},{-120,-50}}),
          iconTransformation(extent={{-120,0},{-100,20}})));
    CDL.Interfaces.RealInput uRetDamPosMin(min=0, max=1, unit="1")
      "Minimum return air damper position limit as returned by the EconEnableDisableMultiZone sequence"
      annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
          iconTransformation(extent={{-120,-100},{-100,-80}})));
    CDL.Interfaces.RealInput uRetDamPosMax(min=0, max=1, unit="1")
      "Maximum return air damper position limit as returned by the EconEnableDisableMultiZone sequence"
      annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
          iconTransformation(extent={{-120,-70},{-100,-50}})));

    CDL.Interfaces.RealOutput yOutDamPos(min=0, max=1, unit="1") "Economizer damper position"
      annotation (Placement(transformation(extent={{120,-30},{140,-10}}),
          iconTransformation(extent={{100,-30},{120,-10}})));
    CDL.Interfaces.RealOutput yRetDamPos(min=0, max=1, unit="1") "Return air damper position"
      annotation (Placement(transformation(extent={{120,10},{140,30}}),
          iconTransformation(extent={{100,10},{120,30}})));

    CDL.Continuous.LimPID damPosController(
      controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI,
      Td=0.1,
      final yMax=conSigMax,
      final yMin=conSigMin,
      k=kPMod,
      Ti=TiMod)
      "Contoller that outputs a signal based on the error between the measured SAT and SAT cooling setpoint"
      annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
      //fixme: Td=0.1 - not used in the model, but still required by LimPID,
    CDL.Continuous.Line outDamPos(limitBelow=true, limitAbove=true)
      "Damper position is linearly proportional to the control signal between signal limits"
      annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
    CDL.Continuous.Line retDamPos(limitBelow=true, limitAbove=true)
      "Damper position is linearly proportional to the control signal between signal limits"
      annotation (Placement(transformation(extent={{60,60},{80,80}})));

  protected
    CDL.Continuous.Constant outDamMinLimSig(final k=damPosController.yMin)
      "Minimal control loop signal for the outdoor air damper"
      annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    CDL.Continuous.Constant outDamMaxLimSig(k=outDamConSigMax)
      "Maximum control loop signal for the outdoor air damper"
      annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
    CDL.Continuous.Constant retDamMinLimSig(k=retDamConSigMin)
      "Minimal control loop signal for the return air damper"
      annotation (Placement(transformation(extent={{-20,70},{0,90}})));
    CDL.Continuous.Constant retDamMaxLimSig(k=damPosController.yMax)
      "Maximal control loop signal for the return air damper"
      annotation (Placement(transformation(extent={{-20,30},{0,50}})));

  equation
    connect(TSup,damPosController. u_m)
      annotation (Line(points={{-140,-20},{-70,-20},{-70,-2}},color={0,0,127}));
    connect(outDamPos.y, yOutDamPos)
      annotation (Line(points={{81,-30},{100,-30},{100,-20},{120,-20},{130,-20}},color={0,0,127}));
    connect(retDamPos.y, yRetDamPos)
      annotation (Line(points={{81,70},{100,70},{100, 20},{130,20}}, color={0,0,127}));
    connect(retDamMaxLimSig.y,retDamPos. x2)
      annotation (Line(points={{1,40},{2,40}, {0,40},{40,40},{40,66},{58,66},{58,66}},color={0,0,127}));
    connect(damPosController.y,retDamPos. u) annotation (Line(points={{-59,10},{30,
            10},{30,70},{58,70}}, color={0,0,127}));
    connect(damPosController.y, outDamPos.u) annotation (Line(points={{-59,10},{40,
            10},{40,-30},{58,-30}},color={0,0,127}));
    connect(uRetDamPosMax,retDamPos. f1) annotation (Line(points={{-140,100},{50,100},
            {50,74},{58,74}}, color={0,0,127}));
    connect(uOutDamPosMin, outDamPos.f1) annotation (Line(points={{-140,-100},{-140,
            -100},{28,-100},{28,-26},{58,-26}}, color={0,0,127}));
    connect(outDamMinLimSig.y, outDamPos.x1) annotation (Line(points={{1,-10},{1,-10},
            {28,-10},{28,-22},{58,-22}}, color={0,0,127}));
    connect(retDamMinLimSig.y,retDamPos. x1) annotation (Line(points={{1,80},{2,80},
            {40,80},{40,78},{58,78}}, color={0,0,127}));
    connect(outDamMaxLimSig.y, outDamPos.x2) annotation (Line(points={{1,-50},{32,
            -50},{32,-34},{58,-34}}, color={0,0,127}));
    connect(TCooSet, damPosController.u_s) annotation (Line(points={{-140,10},{-140,
            10},{-82,10}}, color={0,0,127}));
    connect(uRetDamPosMin,retDamPos. f2)
      annotation (Line(points={{-140,60},{-40,60},{-40,62},{58,62}}, color={0,0,127}));
    connect(uOutDamPosMax, outDamPos.f2) annotation (Line(points={{-140,-70},{40,-70},
            {40,-38},{50,-38},{58,-38}}, color={0,0,127}));
    annotation (
      defaultComponentName = "ecoMod",
      Icon(graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{20,58}}, color={28,108,200}),
          Line(
            points={{-92,-84},{-50,-84},{12,70},{82,70}},
            color={0,0,127},
            thickness=0.5),
          Line(
            points={{-66,58},{12,58},{50,-76},{100,-76}},
            color={0,0,127},
            pattern=LinePattern.Dash,
            thickness=0.5),
          Text(
            extent={{-108,138},{102,110}},
            lineColor={0,0,127},
            textString="%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
              120}}), graphics={
          Rectangle(
            extent={{-118,118},{18,-118}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{22,118},{118,-118}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
                                     Text(
            extent={{-84,56},{-40,16}},
            lineColor={0,0,0},
            fontSize=12,
            horizontalAlignment=TextAlignment.Left,
            textString="Damper position
supply air temperature
control loop"),                      Text(
            extent={{82,128},{126,88}},
            lineColor={0,0,0},
            fontSize=12,
            horizontalAlignment=TextAlignment.Left,
            textString="Damper position
assignments")}),
  Documentation(info="<html>
<p>
This is a multiple zone VAV AHU economizer modulation block. It calculates
the outdoor and return air damper positions based on the supply air temperature
control loop signal. The implementation is in line with ASHRAE
Guidline 36 (G36), PART5.N.2.c. Damper positions are linearly mapped to
the supply air control loop signal. This is a final sequence in the
composite multizone VAV AHU economizer control sequence. Damper position
limits, which are the inputs to the sequence, are the outputs of
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsMultiZone</a> and
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconEnableDisableMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconEnableDisableMultiZone</a>
sequences.
</p>
<p>
When the economizer is enabled, the PI controller modulates the damper
positions. Return and outdoor damper are not interlocked. When the economizer is disabled,
the damper positions are set to the minimum outdoor air damper position limits.
</p>
<p>
Control charts below show the input-output structure and an economizer damper
modulation sequence assuming a well tuned controller. Control diagram:
</p>
<p align=\"center\">
<img alt=\"Image of the multizone AHU modulation sequence control diagram\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/EconModulationControlDiagramMultiZone.png\"/>
</p>
<p>
Multizone AHU economizer modulation control chart:
<br/>
</p>
<p align=\"center\">
<img alt=\"Image of the multizone AHU modulation sequence expected performance\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/EconModulationControlChartMultiZone.png\"/>
</p>
</html>",   revisions="<html>
<ul>
<li>
June 28, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
  end EconModulationMultiZone;

  block VAVSingleZoneTSupSet "Supply air set point for single zone VAV system"

    parameter Modelica.SIunits.Temperature TMax
      "Maximum supply air temperature for heating"
      annotation (Dialog(group="Temperatures"));

    parameter Modelica.SIunits.Temperature TMin
      "Minimum supply air temperature for cooling"
      annotation (Dialog(group="Temperatures"));

    parameter Real yHeaMax(min=0, max=1, unit="1")
      "Maximum fan speed for heating"
      annotation (Dialog(group="Speed"));

    parameter Real yMin(min=0, max=1, unit="1")
      "Minimum fan speed"
      annotation (Dialog(group="Speed"));

    parameter Real yCooMax(min=0, max=1, unit="1") = 1
      "Maximum fan speed for cooling"
      annotation (Dialog(group="Speed"));

    CDL.Interfaces.RealInput uHea(min=0, max=1, unit="1")
      "Heating control signal"
      annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

    CDL.Interfaces.RealInput uCoo(min=0, max=1, unit="1")
      "Cooling control signal"
      annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

    CDL.Interfaces.RealInput TSetZon(unit="K", displayUnit="degC")
      "Average of heating and cooling setpoints for zone temperature"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

    CDL.Interfaces.RealInput TZon(unit="K", displayUnit="degC")
      "Zone temperature"
      annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

    CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
      "Outdoor air temperature"
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

    CDL.Interfaces.RealOutput THeaEco(unit="K", displayUnit="degC")
      "Temperature setpoint for heating coil and for economizer"
      annotation (Placement(transformation(extent={{100,50},{120,70}})));

    CDL.Interfaces.RealOutput TCoo(unit="K", displayUnit="degC")
      "Cooling supply air temperature setpoint"
      annotation (Placement(transformation(extent={{100,-10},{120,10}}),
          iconTransformation(extent={{100,-10},{120,10}})));

    CDL.Interfaces.RealOutput y(min=0, max=1, unit="1") "Fan speed"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

  protected
    CDL.Continuous.Line TSetCooHig
      "Table to compute the setpoint for cooling for uCoo = 0...1"
      annotation (Placement(transformation(extent={{0,100},{20,120}})));
    CDL.Continuous.Line offSetTSetHea
      "Table to compute the setpoint offset for heating for uCoo = 0...1"
      annotation (Placement(transformation(extent={{0,140},{20,160}})));
    CDL.Continuous.Add addTHe "Adder for heating setpoint calculation"
      annotation (Placement(transformation(extent={{60,160},{80,180}})));
    CDL.Continuous.Line offSetTSetCoo
      "Table to compute the setpoint offset for cooling for uHea = 0...1"
      annotation (Placement(transformation(extent={{0,60},{20,80}})));
    CDL.Continuous.Add addTCoo "Adder for cooling setpoint calculation"
      annotation (Placement(transformation(extent={{60,80},{80,100}})));

    CDL.Continuous.Add dT(final k2=-1) "Difference zone minus outdoor temperature"
      annotation (Placement(transformation(extent={{-80,-200},{-60,-180}})));
    CDL.Continuous.AddParameter yMed(
      p=yCooMax - (yMin - yCooMax)/(0.56 - 5.6)*5.6,
      k=(yMin - yCooMax)/(0.56 - 5.6)) "Fan speed at medium cooling load"
      annotation (Placement(transformation(extent={{-40,-200},{-20,-180}})));
    Controls.SetPoints.Table yHea(final table=[0.5,yMin; 1,yHeaMax])
      "Fan speed for heating"
      annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
    CDL.Logical.LessEqualThreshold yMinChe1(final threshold=0.25)
      "Check for cooling signal for fan speed"
      annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
    CDL.Logical.Switch switch1
      annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
    CDL.Logical.LessEqualThreshold yMinChe2(final threshold=0.5)
      "Check for cooling signal for fan speed"
      annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
    CDL.Logical.Switch switch2
      annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
    CDL.Logical.LessEqualThreshold yMinChe3(threshold=0.75)
      "Check for cooling signal for fan speed"
      annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
    CDL.Logical.Switch switch3
      annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));
    CDL.Continuous.Add add(final k1=-1)
      annotation (Placement(transformation(extent={{0,-240},{20,-220}})));
    CDL.Continuous.Add add1
      annotation (Placement(transformation(extent={{40,-270},{60,-250}})));
    CDL.Continuous.Gain gain(final k=4)
      annotation (Placement(transformation(extent={{-80,-256},{-60,-236}})));
    CDL.Continuous.AddParameter yMed1(
      final p=2*yMin,
      final k=-yMin)
      "Fan speed at medium cooling load"
      annotation (Placement(transformation(extent={{-20,-290},{0,-270}})));
    CDL.Continuous.Gain gain1(final k=4)
      annotation (Placement(transformation(extent={{-80,-356},{-60,-336}})));
    CDL.Continuous.Product product
      annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));
    CDL.Continuous.AddParameter yMed2(
      final p=-3*yCooMax,
      final k=4*yCooMax)
      "Fan speed at medium cooling load"
      annotation (Placement(transformation(extent={{-20,-390},{0,-370}})));
    CDL.Continuous.Product product1
      annotation (Placement(transformation(extent={{-40,-350},{-20,-330}})));
    CDL.Continuous.Add add2(
      final k1=4,
      final k2=-1)
      annotation (Placement(transformation(extent={{0,-340},{20,-320}})));
    CDL.Continuous.Add add3
      annotation (Placement(transformation(extent={{40,-370},{60,-350}})));
    CDL.Continuous.Limiter yMedLim(
      final uMax=yCooMax,
      final uMin=yMin) "Limiter for yMed"
      annotation (Placement(transformation(extent={{-10,-200},{10,-180}})));
    CDL.Continuous.Limiter TDea(uMax=24 + 273.15, uMin=21 + 273.15)
      "Limiter that outputs the dead band value for the supply air temperature"
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    CDL.Continuous.Line TSetHeaHig
      "Block to compute the setpoint for heating for uHea = 0...1"
      annotation (Placement(transformation(extent={{2,180},{22,200}})));
    CDL.Continuous.Constant con0(final k=0) "Contant that outputs zero"
      annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
    CDL.Continuous.Constant con25(final k=0.25) "Contant that outputs 0.25"
      annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
    CDL.Continuous.Constant con05(final k=0.5) "Contant that outputs 0.5"
      annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
    CDL.Continuous.Constant con75(final k=0.75) "Contant that outputs 0.75"
      annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
    CDL.Continuous.Constant conTMax(final k=TMax) "Constant that outputs TMax"
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    CDL.Continuous.Constant conTMin(final k=TMin) "Constant that outputs TMin"
      annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
    CDL.Continuous.Add TDeaTMin(final k2=-1) "Outputs TDea-TMin"
      annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));

    CDL.Continuous.AddParameter addTDea(
      final p=-1.1,
      final k=-1)
      "Adds constant offset"
      annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
    CDL.Continuous.Add TMaxTDea(
      final k2=-1) "Outputs TMax-TDea"
      annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  equation
    connect(offSetTSetHea.u, uCoo) annotation (Line(points={{-2,150},{-2,150},{
            -32,150},{-32,52},{-94,52},{-94,40},{-120,40}},
                                       color={0,0,127}));
    connect(offSetTSetHea.y, addTHe.u2) annotation (Line(points={{21,150},{21,150},
            {40,150},{40,164},{58,164}},
                                  color={0,0,127}));
    connect(addTHe.y, THeaEco) annotation (Line(points={{81,170},{92,170},{92,60},
            {110,60}}, color={0,0,127}));
    connect(TSetCooHig.y, addTCoo.u1) annotation (Line(points={{21,110},{40,110},
            {40,96},{58,96}},
                            color={0,0,127}));
    connect(offSetTSetCoo.y, addTCoo.u2) annotation (Line(points={{21,70},{40,70},
            {40,84},{58,84}},   color={0,0,127}));
    connect(TSetCooHig.u, uCoo) annotation (Line(points={{-2,110},{-2,110},{-22,110},
            {-32,110},{-32,52},{-94,52},{-94,40},{-120,40}},
                                        color={0,0,127}));
    connect(offSetTSetCoo.u, uHea) annotation (Line(points={{-2,70},{-2,70},{-20,
            70},{-60,70},{-90,70},{-90,80},{-120,80}},
                                      color={0,0,127}));
    connect(addTCoo.y, TCoo)
      annotation (Line(points={{81,90},{81,90},{84,90},{84,0},{110,0}},
                                                              color={0,0,127}));
    connect(dT.u1, TZon) annotation (Line(points={{-82,-184},{-86,-184},{-86,-40},
            {-120,-40}},
                   color={0,0,127}));
    connect(dT.u2, TOut) annotation (Line(points={{-82,-196},{-90,-196},{-90,-80},
            {-120,-80}},
                   color={0,0,127}));
    connect(dT.y, yMed.u)
      annotation (Line(points={{-59,-190},{-59,-190},{-42,-190}},
                                                               color={0,0,127}));
    connect(yMinChe1.u, uCoo) annotation (Line(points={{-82,-90},{-82,-90},{-94,-90},
            {-94,40},{-120,40}},       color={0,0,127}));
    connect(switch1.u2, yMinChe1.y) annotation (Line(points={{58,-90},{-40,-90},{-59,
            -90}},       color={255,0,255}));
    connect(switch2.y, switch1.u3) annotation (Line(points={{41,-120},{50,-120},{50,
            -98},{58,-98}},   color={0,0,127}));
    connect(yMinChe2.u, uCoo) annotation (Line(points={{-82,-120},{-94,-120},{-94,
            40},{-120,40}}, color={0,0,127}));
    connect(yMinChe3.u, uCoo) annotation (Line(points={{-82,-150},{-94,-150},{-94,
            40},{-120,40}}, color={0,0,127}));
    connect(switch3.y, switch2.u3) annotation (Line(points={{1,-150},{10,-150},{10,
            -128},{18,-128}}, color={0,0,127}));
    connect(yMinChe2.y, switch2.u2) annotation (Line(points={{-59,-120},{-59,-120},
            {18,-120}}, color={255,0,255}));
    connect(yMinChe3.y, switch3.u2) annotation (Line(points={{-59,-150},{-40,-150},
            {-22,-150}}, color={255,0,255}));
    connect(yMedLim.y, add.u1) annotation (Line(points={{11,-190},{20,-190},{20,-208},
            {-50,-208},{-50,-224},{-2,-224}}, color={0,0,127}));
    connect(gain.u, uCoo) annotation (Line(points={{-82,-246},{-94,-246},{-94,40},
            {-120,40}}, color={0,0,127}));
    connect(gain.y, yMed1.u) annotation (Line(points={{-59,-246},{-58,-246},{-54,-246},
            {-54,-280},{-22,-280}}, color={0,0,127}));
    connect(add.y, add1.u1) annotation (Line(points={{21,-230},{32,-230},{32,-254},
            {38,-254}}, color={0,0,127}));
    connect(yMed1.y, add1.u2) annotation (Line(points={{1,-280},{10,-280},{10,-266},
            {38,-266}}, color={0,0,127}));
    connect(add1.y, switch2.u1) annotation (Line(points={{61,-260},{72,-260},{72,-134},
            {8,-134},{8,-112},{18,-112}}, color={0,0,127}));
    connect(gain1.u, uCoo) annotation (Line(points={{-82,-346},{-94,-346},{-94,40},
            {-120,40}}, color={0,0,127}));
    connect(product.u1, yMedLim.y) annotation (Line(points={{-42,-234},{-50,-234},
            {-50,-208},{20,-208},{20,-190},{11,-190}},
                                                   color={0,0,127}));
    connect(product.y, add.u2) annotation (Line(points={{-19,-240},{-12,-240},{-12,
            -236},{-2,-236}}, color={0,0,127}));
    connect(product.u2, gain.y)
      annotation (Line(points={{-42,-246},{-59,-246}}, color={0,0,127}));
    connect(yMedLim.y, add2.u1) annotation (Line(points={{11,-190},{20,-190},{20,-208},
            {-50,-208},{-50,-324},{-2,-324}}, color={0,0,127}));
    connect(product1.y, add2.u2) annotation (Line(points={{-19,-340},{-14,-340},{-14,
            -336},{-2,-336}}, color={0,0,127}));
    connect(add2.y, add3.u1) annotation (Line(points={{21,-330},{24,-330},{24,-354},
            {38,-354}}, color={0,0,127}));
    connect(yMed2.y, add3.u2) annotation (Line(points={{1,-380},{22,-380},{22,-366},
            {38,-366}}, color={0,0,127}));
    connect(product1.u2, gain1.y) annotation (Line(points={{-42,-346},{-59,-346}},
                        color={0,0,127}));
    connect(product1.u1, yMedLim.y) annotation (Line(points={{-42,-334},{-50,-334},
            {-50,-218},{-50,-208},{20,-208},{20,-190},{11,-190}},        color={0,
            0,127}));
    connect(yMed2.u, uCoo) annotation (Line(points={{-22,-380},{-54,-380},{-94,-380},
            {-94,40},{-120,40}}, color={0,0,127}));
    connect(add3.y, switch3.u3) annotation (Line(points={{61,-360},{76,-360},{76,-168},
            {-34,-168},{-34,-158},{-22,-158}}, color={0,0,127}));
    connect(yHea.y, switch1.u1) annotation (Line(points={{1,-70},{18,-70},{40,-70},
            {40,-82},{58,-82}}, color={0,0,127}));
    connect(switch1.y, y) annotation (Line(points={{81,-90},{90,-90},{90,-60},{110,
            -60}}, color={0,0,127}));
    connect(yMedLim.y, switch3.u1) annotation (Line(points={{11,-190},{20,-190},{
            20,-170},{-40,-170},{-40,-142},{-22,-142}},
                                                     color={0,0,127}));
    connect(yMedLim.u, yMed.y)
      annotation (Line(points={{-12,-190},{-19,-190}}, color={0,0,127}));
    connect(TDea.u, TSetZon)
      annotation (Line(points={{-82,0},{-82,0},{-120,0}},  color={0,0,127}));
    connect(con0.y, TSetHeaHig.x1) annotation (Line(points={{-59,190},{-52,190},{
            -52,198},{0,198}},
                           color={0,0,127}));
    connect(TDea.y, TSetHeaHig.f1) annotation (Line(points={{-59,0},{-52,0},{-52,
            194},{0,194}},
                      color={0,0,127}));
    connect(con05.y, TSetHeaHig.x2) annotation (Line(points={{-59,120},{-46,120},
            {-46,186},{0,186}},color={0,0,127}));
    connect(conTMax.y, TSetHeaHig.f2) annotation (Line(points={{-59,30},{-40,30},
            {-40,182},{0,182}},color={0,0,127}));
    connect(uHea, TSetHeaHig.u) annotation (Line(points={{-120,80},{-90,80},{-90,70},
            {-36,70},{-36,190},{0,190}}, color={0,0,127}));
    connect(TSetHeaHig.y, addTHe.u1) annotation (Line(points={{23,190},{40,190},{
            40,176},{58,176}},
                          color={0,0,127}));
    connect(con0.y, offSetTSetHea.x1) annotation (Line(points={{-59,190},{-56,190},
            {-56,158},{-2,158}}, color={0,0,127}));
    connect(con25.y, offSetTSetHea.x2) annotation (Line(points={{-59,160},{-54,
            160},{-54,146},{-2,146}},
                                 color={0,0,127}));
    connect(con0.y, offSetTSetHea.f1) annotation (Line(points={{-59,190},{-56,190},
            {-56,154},{-2,154}}, color={0,0,127}));
    connect(yHea.u, uHea) annotation (Line(points={{-22,-70},{-90,-70},{-90,80},{-120,
            80}}, color={0,0,127}));
    connect(TDea.y, TDeaTMin.u1) annotation (Line(points={{-59,0},{-40,0},{-40,-14},
            {-22,-14}}, color={0,0,127}));
    connect(conTMin.y, TDeaTMin.u2) annotation (Line(points={{-59,-30},{-50,-30},{
            -50,-26},{-22,-26}}, color={0,0,127}));
    connect(TDeaTMin.y, addTDea.u)
      annotation (Line(points={{1,-20},{-2,-20},{8,-20}}, color={0,0,127}));
    connect(addTDea.y, offSetTSetHea.f2) annotation (Line(points={{31,-20},{34,
            -20},{34,40},{-14,40},{-14,142},{-2,142}},
                                                  color={0,0,127}));
    connect(TSetCooHig.x1, con05.y) annotation (Line(points={{-2,118},{-24,118},{
            -46,118},{-46,120},{-59,120}},
                                       color={0,0,127}));
    connect(TSetCooHig.f1, TDea.y) annotation (Line(points={{-2,114},{-10,114},{
            -52,114},{-52,0},{-59,0}},
                                   color={0,0,127}));
    connect(TSetCooHig.x2, con75.y) annotation (Line(points={{-2,106},{-8,106},{
            -44,106},{-44,90},{-59,90}},
                                     color={0,0,127}));
    connect(TSetCooHig.f2, conTMin.y) annotation (Line(points={{-2,102},{-2,114},
            {-50,114},{-50,-30},{-59,-30}},color={0,0,127}));
    connect(offSetTSetCoo.f1, con0.y) annotation (Line(points={{-2,74},{-56,74},{
            -56,190},{-59,190}},
                             color={0,0,127}));
    connect(offSetTSetCoo.x1, con0.y) annotation (Line(points={{-2,78},{-56,78},{
            -56,70},{-56,190},{-59,190}},
                                      color={0,0,127}));
    connect(offSetTSetCoo.x2, con05.y) annotation (Line(points={{-2,66},{-10,66},
            {-46,66},{-46,120},{-59,120}},color={0,0,127}));
    connect(TMaxTDea.u1, conTMax.y) annotation (Line(points={{-22,26},{-40,26},{-40,
            30},{-59,30}}, color={0,0,127}));
    connect(TDea.y, TMaxTDea.u2) annotation (Line(points={{-59,0},{-40,0},{-40,14},
            {-22,14}}, color={0,0,127}));
    connect(TMaxTDea.y, offSetTSetCoo.f2) annotation (Line(points={{1,20},{10,20},
            {10,50},{-10,50},{-10,62},{-2,62}}, color={0,0,127}));
    annotation (
    defaultComponentName = "setPoiVAV",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}),                                        graphics={
          Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
      Polygon(
        points={{80,-76},{58,-70},{58,-82},{80,-76}},
        lineColor={95,95,95},
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid),
      Line(points={{8,-76},{78,-76}},   color={95,95,95}),
      Line(points={{-54,-22},{-54,-62}},color={95,95,95}),
      Polygon(
        points={{-54,0},{-60,-22},{-48,-22},{-54,0}},
        lineColor={95,95,95},
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-88,-6},{-47,-26}},
        lineColor={0,0,0},
            textString="T"),
      Text(
        extent={{64,-82},{88,-93}},
        lineColor={0,0,0},
            textString="u"),
          Line(
            points={{-44,-6},{-30,-6},{-14,-42},{26,-42},{38,-62},{60,-62}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{-44,-6},{-30,-6},{-14,-42},{2,-42},{18,-66},{60,-66}},
            color={255,0,0},
            pattern=LinePattern.Dot,
            thickness=0.5),
      Line(points={{-4,-76},{-60,-76}}, color={95,95,95}),
      Polygon(
        points={{-64,-76},{-42,-70},{-42,-82},{-64,-76}},
        lineColor={95,95,95},
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid),
          Text(
            extent={{-98,90},{-72,68}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="uHea"),
          Text(
            extent={{-96,50},{-70,28}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="uCoo"),
          Text(
            extent={{68,72},{94,50}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="THeaEco"),
          Text(
            extent={{68,12},{94,-10}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="TCoo"),
          Text(
            extent={{74,-50},{100,-72}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="y"),
          Text(
            extent={{-96,-30},{-70,-52}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="TZon"),
          Text(
            extent={{-98,-68},{-72,-90}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="TOut"),
      Line(points={{-54,50},{-54,10}},  color={95,95,95}),
      Polygon(
        points={{-54,72},{-60,50},{-48,50},{-54,72}},
        lineColor={95,95,95},
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-88,68},{-47,48}},
        lineColor={0,0,0},
            textString="y"),
          Line(points={{-46,44},{-28,20},{18,20},{28,36},{38,36},{50,54}}, color={
                0,0,0}),
          Line(points={{18,20},{38,20},{50,54},{28,54},{18,20}}, color={0,0,0}),
          Text(
            extent={{-96,12},{-70,-10}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="TSetZon")}),
          Diagram(
          coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-420},{100,220}}), graphics={
          Rectangle(
            extent={{-88,-314},{70,-400}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-88,-214},{70,-300}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{32,-304},{68,-286}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            textString="0.25 < y < 0.5"),
          Text(
            extent={{32,-404},{68,-386}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            textString="0.75 < y < 1"),
          Rectangle(
            extent={{-88,-172},{70,-210}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{30,-212},{66,-194}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            textString="0.5 < y < 0.75")}),
            Documentation(info="<html>
<p>
Block that outputs the set points for the supply air temperature for
cooling, heating and economizer control,
and the fan speed for a single zone VAV system.
</p>
<p>
For the temperature set points, the
parameters are the maximum supply air temperature <code>TMax</code>,
and the minimum supply air temperature for cooling <code>TMin</code>.
The deadband temperature is equal to the
average set point for the zone temperature
for heating and cooling, as obtained from the input <code>TSetZon</code>,
constraint to be within <i>21</i>&deg;C (&asymp;<i>70</i> F) and
<i>24</i>&deg;C (&asymp;<i>75</i> F).
The setpoints are computed as shown in the figure below.
Note that the setpoint for the supply air temperature for heating
and for economizer control is the same, and this setpoint is
lower than <code>TMin</code> when the heating loop signal
is zero and the economizer is in cooling mode, as shown in the figure.
</p>
<p>
For the fan speed set point, the
parameters are the maximu fan speed at heating <code>yHeaMax</code>,
the minimum fan speed <code>yMin</code> and
the maximum fan speed for cooling <code>yCooMax</code>.
For a cooling control signal of <code>yCoo &gt; 0.25</code>,
the speed is faster increased the larger the difference is between
the zone temperature minus outdoor temperature <code>TZon-TOut</code>.
The figure below shows the sequence.
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/VAVSingleZoneTSupSet.png\"/>
</p>
<p>
The output <code>TCoo</code> is to be used to control the cooling coil,
and the output
<code>THeaEco</code> is to be used to control the heating coil and the
economizer dampers.
</p>
<p>
Note that the inputs <code>uHea</code> and <code>uCoo</code> must be computed
based on the same temperature sensors and control loops
</p>
</html>",   revisions="<html>
<ul>
<li>
April 26, 2017, by Michael Wetter:<br/>
Updated documentation and renamed output signal to <code>THeaEco</code>.
</li>
<li>
January 10, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end VAVSingleZoneTSupSet;

  package Validation "Package with validation models"
    extends Modelica.Icons.ExamplesPackage;

    model EconDamperPositionLimitsMultiZone_LoopDisable
      "Validation model for the multiple zone VAV AHU minimum outdoor air control - damper position limits"
      extends Modelica.Icons.Example;

      parameter Types.FreezeProtectionStage freProStage1 = Types.FreezeProtectionStage.stage1
        "Freeze protection stage 1";
      parameter Types.FreezeProtectionStage freProStage2 = Types.FreezeProtectionStage.stage2
        "Freeze protection stage 2";
      parameter Integer freProStage1Num = Integer(freProStage1)-1
        "Numerical value for freeze protection stage 1";
      parameter Integer freProStage2Num = Integer(freProStage2)-1
        "Numerical value for freeze protection stage 2";
      parameter Types.OperationMode occupied = Types.OperationMode.occupied
        "AHU operation mode is Occupied";
      parameter Types.OperationMode warmUp = Types.OperationMode.warmUp
        "AHU operation mode is WarmUp";
      parameter Integer occupiedNum = Integer(occupied)
        "Numerical value for AHU operation mode Occupied";
      parameter Integer warmUpNum = Integer(warmUp)
        "Numerical value for AHU operation mode WarmUp";
      parameter Modelica.SIunits.VolumeFlowRate VOutSet_flow=0.71
        "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
      parameter Modelica.SIunits.VolumeFlowRate VOutMin_flow=0.61
        "Volumetric airflow sensor output, minimum value in the example";
      parameter Modelica.SIunits.VolumeFlowRate VOutIncrease_flow=0.2
        "Maximum increase in airflow volume during the example simulation";

      // Fan Status
      CDL.Logical.Constant fanStatus(k=false) "Fan is off"
        annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
      CDL.Integers.Constant freProSta(k=freProStage1Num) "Freeze protection stage is 1"
        annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));
      CDL.Integers.Constant operationMode(k=occupiedNum) "AHU operation mode is Occupied"
        annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));

      // Operation Mode
      CDL.Logical.Constant fanStatus1(k=true)  "Fan is on"
        annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
      CDL.Integers.Constant freProSta1(k=freProStage1Num) "Freeze protection stage is 1"
        annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
      CDL.Integers.Constant operationMode1(k=warmUpNum)
        "AHU operation mode is NOT Occupied"
        annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

      // Freeze Protection Stage
      CDL.Logical.Constant fanStatus2(k=true)  "Fan is on"
        annotation (Placement(transformation(extent={{80,-20},{100,0}})));
      CDL.Integers.Constant freProSta2(k=freProStage2Num)
        "Freeze protection stage is 2"
        annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
      CDL.Integers.Constant operationMode2(k=occupiedNum) "AHU operation mode is Occupied"
        annotation (Placement(transformation(extent={{80,-60},{100,-40}})));

      Modelica.Blocks.Sources.Ramp VOut_flow(
        duration=1800,
        offset=VOutMin_flow,
        height=VOutIncrease_flow)
        "Measured outdoor airflow rate"
        annotation (Placement(transformation(extent={{-200,60},{-180,80}})));
      Modelica.Blocks.Sources.Ramp VOut1_flow(
        duration=1800,
        offset=VOutMin_flow,
        height=VOutIncrease_flow)
        "Measured outdoor airflow rate"
        annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
      Modelica.Blocks.Sources.Ramp VOut2_flow(
        duration=1800,
        offset=VOutMin_flow,
        height=VOutIncrease_flow)
        "Measured outdoor airflow rate"
        annotation (Placement(transformation(extent={{80,60},{100,80}})));
      CDL.Continuous.Constant VOutMinSet_flow(k=VOutSet_flow)
        "Outdoor airflow rate setpoint, 15cfm/occupant and 100 occupants"
        annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
      CDL.Continuous.Constant VOutMinSet1_flow(k=VOutSet_flow)
        "Outdoor airflow rate setpoint, 15cfm/occupant and 100 occupants"
        annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
      CDL.Continuous.Constant VOutMinSet2_flow(k=VOutSet_flow)
        "Outdoor airflow rate setpoint, 15cfm/occupant and 100 occupants"
        annotation (Placement(transformation(extent={{80,20},{100,40}})));

      EconDamperPositionLimitsMultiZone ecoDamLim
        "Multiple zone VAV AHU minimum outdoor air control - damper position limits"
          annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
      EconDamperPositionLimitsMultiZone ecoDamLim1
        "Multiple zone VAV AHU minimum outdoor air control - damper position limits"
          annotation (Placement(transformation(extent={{20,-20},{40,0}})));
      EconDamperPositionLimitsMultiZone ecoDamLim2
        "Multiple zone VAV AHU minimum outdoor air control - damper position limits"
          annotation (Placement(transformation(extent={{160,-20},{180,0}})));

    equation
      connect(VOut_flow.y, ecoDamLim.VOut_flow) annotation (Line(points={{-179,70},{-140,70},
              {-140,-2},{-121,-2}}, color={0,0,127}));
      connect(VOutMinSet_flow.y, ecoDamLim.VOutMinSet_flow)
        annotation (Line(points={{-179,30},{-150,30},{-150,-5},{-121,-5}}, color={0,0,127}));
      connect(fanStatus.y, ecoDamLim.uSupFan)
        annotation (Line(points={{-179,-10},{-160,-10},{-121,-10}}, color={255,0,255}));
      connect(operationMode.y, ecoDamLim.uOperationMode)
        annotation (Line(points={{-179,-50},{-160,-50},{-160,-28},{-160,-15},{-121,-15}},
        color={255,127,0}));
      connect(freProSta.y, ecoDamLim.uFreProSta)
        annotation (Line(points={{-179,-90},{-150,-90},{-150,-18},{-121,-18}}, color={255,127,0}));
      connect(VOut1_flow.y, ecoDamLim1.VOut_flow) annotation (Line(points={{-39,70},{0,70},{
              0,-2},{19,-2}}, color={0,0,127}));
      connect(VOutMinSet1_flow.y, ecoDamLim1.VOutMinSet_flow) annotation (Line(points={{-39,
              30},{-10,30},{-10,-5},{19,-5}}, color={0,0,127}));
      connect(fanStatus1.y, ecoDamLim1.uSupFan) annotation (Line(points={{-39,-10},
              {-20,-10},{19,-10}}, color={255,0,255}));
      connect(operationMode1.y, ecoDamLim1.uOperationMode) annotation (Line(points={{-39,-50},{
              -20,-50},{-20,-28},{-20,-15},{19,-15}}, color={255,127,0}));
      connect(freProSta1.y, ecoDamLim1.uFreProSta) annotation (Line(points={{-39,
              -90},{-10,-90},{-10,-18},{19,-18}}, color={255,127,0}));
      connect(VOut2_flow.y, ecoDamLim2.VOut_flow) annotation (Line(points={{101,70},{140,70},
              {140,-2},{159,-2}}, color={0,0,127}));
      connect(VOutMinSet2_flow.y, ecoDamLim2.VOutMinSet_flow) annotation (Line(points={{101,
              30},{130,30},{130,-5},{159,-5}}, color={0,0,127}));
      connect(fanStatus2.y, ecoDamLim2.uSupFan) annotation (Line(points={{101,-10},
              {120,-10},{159,-10}}, color={255,0,255}));
      connect(operationMode2.y, ecoDamLim2.uOperationMode) annotation (Line(points={{101,-50},{
              120,-50},{120,-28},{120,-15},{159,-15}}, color={255,127,0}));
      connect(freProSta2.y, ecoDamLim2.uFreProSta) annotation (Line(points={{101,
              -90},{130,-90},{130,-18},{159,-18}}, color={255,127,0}));
      annotation (
      experiment(StopTime=1800.0, Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/EconDamperPositionLimitsMultiZone_LoopDisable.mos"
        "Simulate and plot"),
        Icon(graphics={Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}), Polygon(
              lineColor={0,0,255},
              fillColor={75,138,73},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-120},{
                220,120}}), graphics={
            Text(
              extent={{-200,110},{-166,98}},
              lineColor={0,0,0},
              lineThickness=0.5,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              horizontalAlignment=TextAlignment.Left,
              fontSize=16,
              textString="Fan is off"),
            Text(
              extent={{-60,114},{68,96}},
              lineColor={0,0,0},
              lineThickness=0.5,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              horizontalAlignment=TextAlignment.Left,
              fontSize=16,
              textString="Operation mode is other than Occupied"),
            Text(
              extent={{80,114},{208,96}},
              lineColor={0,0,0},
              lineThickness=0.5,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              horizontalAlignment=TextAlignment.Left,
              fontSize=16,
              textString="Freeze protection status is higher than 1")}),
        Documentation(info="<html>
  <p>
This example validates enable/disable conditions for
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsMultiZone</a>
for the following input signals: <code>uSupFan</code>, <code>uFreProSta</code>, <code>uOperationMode</code>.
</p>
</html>",     revisions="<html>
<ul>
<li>
June 06, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
    end EconDamperPositionLimitsMultiZone_LoopDisable;

    model EconDamperPositionLimitsMultiZone_VOut_flow
      "Validation model for the multiple zone VAV AHU minimum outdoor air control - damper position limits"
      extends Modelica.Icons.Example;

      parameter Modelica.SIunits.VolumeFlowRate minVOutSet_flow=0.71
        "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
      parameter Modelica.SIunits.VolumeFlowRate minVOut_flow=0.61
        "Minimal measured volumetric airflow";
      parameter Modelica.SIunits.VolumeFlowRate VOutIncrease_flow=0.2
        "Maximum volumetric airflow increase during the example simulation";

      CDL.Continuous.Constant VOutMinSet_flow(k=minVOutSet_flow)
        "Outdoor volumetric airflow rate setpoint, 15cfm/occupant and 100 occupants"
        annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
      Modelica.Blocks.Sources.Ramp VOut_flow(
        duration=1800,
        offset=minVOut_flow,
        height=VOutIncrease_flow)
        "Measured outdoor airflow rate"
        annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

      EconDamperPositionLimitsMultiZone ecoDamLim
        "Multiple zone VAV AHU minimum outdoor air control - damper position limits"
        annotation (Placement(transformation(extent={{20,-10},{40,10}})));

    protected
      parameter Types.FreezeProtectionStage freProDisabled = Types.FreezeProtectionStage.stage0
        "Indicates that the freeze protection is disabled";
      parameter Integer freProDisabledNum = Integer(freProDisabled)-1
        "Numerical value for freeze protection stage 0";
      parameter Types.OperationMode occupied = Types.OperationMode.occupied
        "Operation mode is Occupied";
      parameter Integer occupiedNum = Integer(occupied)
        "Numerical value for Occupied operation mode";

      CDL.Logical.Constant fanStatus(k=true) "Fan is on"
        annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
      CDL.Integers.Constant freProSta(k=freProDisabledNum) "Freeze protection status - disabled"
        annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
      CDL.Integers.Constant operationMode(k=occupiedNum) "Operation mode - occupied"
        annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

    equation
      connect(VOut_flow.y, ecoDamLim.VOut_flow) annotation (Line(points={{-39,80},{0,80},{0,8},{19,8}},color={0,0,127}));
      connect(VOutMinSet_flow.y, ecoDamLim.VOutMinSet_flow)
        annotation (Line(points={{-39,40},{-10,40},{-10,5},{19,5}},color={0,0,127}));
      connect(fanStatus.y, ecoDamLim.uSupFan)
        annotation (Line(points={{-39,0},{-20,0},{19,0}},color={255,0,255}));
      connect(operationMode.y, ecoDamLim.uOperationMode)
        annotation (Line(points={{-39,-40},{-20,-40},{-20,-18},{-20,-5},{19,-5}},color={255,127,0}));
      connect(freProSta.y, ecoDamLim.uFreProSta)
        annotation (Line(points={{-39,-80},{-10,-80},{-10,-8},{19,-8}},color={255,127,0}));
      annotation (
      experiment(StopTime=1800.0, Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/EconDamperPositionLimitsMultiZone_VOut_flow.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(extent={{-80,-100},{80,100}}),
             graphics={Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}), Polygon(
              lineColor={0,0,255},
              fillColor={75,138,73},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,-100},{80,100}})),
        Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconDamperPositionLimitsMultiZone</a>
for the following control signals: <code>VOut_flow</code>, <code>VOutMinSet_flow</code>. The control loop is always enabled in this
example.
</p>
</html>",     revisions="<html>
<ul>
<li>
June 06, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
    end EconDamperPositionLimitsMultiZone_VOut_flow;

    model EconEnableDisableMultiZone_FreProSta_ZonSta
      "Model validates economizer disable for heating zone state and activated freeze protection"
      extends Modelica.Icons.Example;

      parameter Modelica.SIunits.Temperature TOutCutoff=297
        "Outdoor temperature high limit cutoff";
      parameter Modelica.SIunits.SpecificEnergy hOutCutoff=65100
        "Outdoor air enthalpy high limit cutoff";
      parameter Types.FreezeProtectionStage freProDisabled = Types.FreezeProtectionStage.stage0
        "Indicates that the freeze protection is disabled";
      parameter Integer freProDisabledNum = Integer(freProDisabled)-1
        "Numerical value for freeze protection stage 0";
      parameter Types.ZoneState heating = Types.ZoneState.heating
        "Zone state is heating";
      parameter Integer heatingNum = Integer(heating)
        "Numerical value for heating zone state";
      parameter Types.FreezeProtectionStage freProEnabled = Types.FreezeProtectionStage.stage2
        "Indicates that the freeze protection is eanbled";
      parameter Integer freProEnabledNum = Integer(freProEnabled)-1
        "Numerical value for freeze protection stage 0";
      parameter Types.ZoneState cooling = Types.ZoneState.cooling
        "Zone state is cooling";
      parameter Integer coolingNum = Integer(cooling)
        "Numerical value for cooling zone state";

      EconEnableDisableMultiZone econEnableDisableMultiZone "Multizone VAV AHU enable disable sequence"
        annotation (Placement(transformation(extent={{82,40},{102,60}})));
      EconEnableDisableMultiZone econEnableDisableMultiZone1 "Multizone VAV AHU enable disable sequence"
        annotation (Placement(transformation(extent={{82,-40},{102,-20}})));

    protected
      CDL.Continuous.Constant TOutBelowCutoff(k=TOutCutoff - 2)
        "Outdoor air temperature is slightly below the cutoff"
        annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
      CDL.Continuous.Constant TOutCut(k=TOutCutoff)
        annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
      CDL.Continuous.Constant hOutBelowCutoff(k=hOutCutoff - 1000)
        "Outdoor air enthalpy is slightly below the cufoff"
        annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
      CDL.Continuous.Constant hOutCut(k=hOutCutoff) "Outdoor air enthalpy cutoff"
        annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
      CDL.Integers.Constant freProSta(k=freProDisabledNum) "Freeze Protection Status (Deactivated = 0)"
        annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
      CDL.Integers.Constant zoneState(k=heatingNum) "Zone State is heating (heating = 1)"
        annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
      CDL.Integers.Constant freProSta1(k=freProEnabledNum) "Freeze Protection Status (Activated > 0)"
        annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
      CDL.Integers.Constant zoneState1(k=coolingNum) "Zone State is not heating (heating = 1)"
        annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

      CDL.Continuous.Constant outDamPosMax(k=0.9) "Maximal allowed economizer damper position"
        annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
      CDL.Continuous.Constant outDamPosMin(k=0.1) "Minimal allowed economizer damper position"
        annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
      CDL.Continuous.Constant retDamPhyPosMax(k=1) "Maximal allowed economizer damper position"
        annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
      CDL.Continuous.Constant retDamPosMax(k=0.8) "Maximal allowed economizer damper position"
        annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
      CDL.Continuous.Constant retDamPosMin(k=0) "Minimal allowed economizer damper position"
        annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
      CDL.Logical.Constant SupFanSta(k=true)
        annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));

    equation
      connect(TOutBelowCutoff.y, econEnableDisableMultiZone.TOut) annotation (Line(
            points={{-19,150},{32,150},{32,60},{81,60}}, color={0,0,127}));
      connect(TOutCut.y, econEnableDisableMultiZone.TOutCut) annotation (Line(
            points={{-19,110},{31.5,110},{31.5,58},{81,58}}, color={0,0,127}));
      connect(TOutCut.y, econEnableDisableMultiZone1.TOutCut) annotation (Line(
            points={{-19,110},{32,110},{32,-22},{81,-22}}, color={0,0,127}));
      connect(TOutBelowCutoff.y, econEnableDisableMultiZone1.TOut) annotation (
          Line(points={{-19,150},{32,150},{32,-20},{81,-20}}, color={0,0,127}));
      connect(hOutBelowCutoff.y, econEnableDisableMultiZone.hOut) annotation (Line(
            points={{-79,110},{-60,110},{-60,56},{81,56}}, color={0,0,127}));
      connect(hOutCut.y, econEnableDisableMultiZone.hOutCut) annotation (Line(
            points={{-79,70},{-70,70},{-70,54},{81,54}}, color={0,0,127}));
      connect(hOutBelowCutoff.y, econEnableDisableMultiZone1.hOut) annotation (Line(
            points={{-79,110},{-60,110},{-60,56},{10,56},{10,-24},{81,-24}}, color={0,0,127}));
      connect(hOutCut.y, econEnableDisableMultiZone1.hOutCut) annotation (Line(
            points={{-79,70},{-70,70},{-70,54},{6,54},{6,-26},{81,-26}}, color={0,0,127}));
      connect(zoneState.y, econEnableDisableMultiZone.uZoneState) annotation (Line(
            points={{-139,10},{-120,10},{-120,50},{81,50}}, color={255,127,0}));
      connect(freProSta.y, econEnableDisableMultiZone.uFreProSta)
        annotation (Line(points={{-139,50},{-130,50},{-130,52},{81,52}}, color={255,127,0}));
      connect(freProSta1.y, econEnableDisableMultiZone1.uFreProSta)
        annotation (Line(points={{61,-110},{70,-110},{70,-28},{81,-28}}, color={255,127,0}));
      connect(zoneState1.y, econEnableDisableMultiZone1.uZoneState) annotation (
          Line(points={{61,-70},{72,-70},{72,-30},{81,-30}}, color={255,127,0}));
      connect(retDamPosMax.y, econEnableDisableMultiZone.uRetDamPosMax) annotation (
         Line(points={{-79,-50},{-68,-50},{-68,40},{81,40}}, color={0,0,127}));
      connect(retDamPhyPosMax.y, econEnableDisableMultiZone.uRetDamPhyPosMax)
        annotation (Line(points={{-79,-10},{-70,-10},{-70,42},{81,42}}, color={0,0,127}));
      connect(retDamPosMin.y, econEnableDisableMultiZone.uRetDamPosMin) annotation (
         Line(points={{-79,-90},{-66,-90},{-66,38},{8,38},{81,38}},        color={0,0,127}));
      connect(outDamPosMax.y, econEnableDisableMultiZone.uOutDamPosMax) annotation (
         Line(points={{-39,-110},{-30,-110},{-30,46},{81,46}}, color={0,0,127}));
      connect(outDamPosMin.y, econEnableDisableMultiZone.uOutDamPosMin) annotation (
         Line(points={{-39,-150},{-28,-150},{-28,44},{81,44}}, color={0,0,127}));
      connect(outDamPosMin.y, econEnableDisableMultiZone1.uOutDamPosMin)
        annotation (Line(points={{-39,-150},{22,-150},{22,-36},{81,-36}}, color={0,0,127}));
      connect(outDamPosMax.y, econEnableDisableMultiZone1.uOutDamPosMax)
        annotation (Line(points={{-39,-110},{20,-110},{20,-34},{81,-34}}, color={0,0,127}));
      connect(retDamPosMin.y, econEnableDisableMultiZone1.uRetDamPosMin)
        annotation (Line(points={{-79,-90},{30,-90},{30,-42},{81,-42}}, color={0,0,127}));
      connect(retDamPosMax.y, econEnableDisableMultiZone1.uRetDamPosMax)
        annotation (Line(points={{-79,-50},{0,-50},{0,-40},{81,-40}}, color={0,0,127}));
      connect(retDamPhyPosMax.y, econEnableDisableMultiZone1.uRetDamPhyPosMax)
        annotation (Line(points={{-79,-10},{0,-10},{0,-38},{81,-38}}, color={0,0,127}));
      connect(SupFanSta.y, econEnableDisableMultiZone.uSupFan) annotation (Line(
            points={{-139,-30},{-34,-30},{-34,48},{81,48}}, color={255,0,255}));
      connect(SupFanSta.y, econEnableDisableMultiZone1.uSupFan) annotation (Line(
            points={{-139,-30},{-34,-30},{-34,-32},{81,-32}}, color={255,0,255}));
      annotation (
        experiment(StopTime=1800.0, Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/EconEnableDisableMultiZone_FreProSta_ZonSta.mos"
        "Simulate and plot"),
      Icon(graphics={
            Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false, extent={{-180,-180},{180,180}}), graphics={
            Text(
              extent={{80,42},{164,14}},
              lineColor={0,0,0},
              horizontalAlignment=TextAlignment.Left,
              fontSize=12,
              textString="Tests zone state disable condition"),
            Text(
              extent={{80,-36},{174,-64}},
              lineColor={0,0,0},
              horizontalAlignment=TextAlignment.Left,
              fontSize=12,
              textString="Tests freeze protection disable condition")}),
        Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconEnableDisableMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconEnableDisableMultiZone</a>
for the following control signals: zone state, freeze protection stage.
</p>
</html>",     revisions="<html>
<ul>
<li>
June 13, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
    end EconEnableDisableMultiZone_FreProSta_ZonSta;

    model EconEnableDisableMultiZone_TOut_hOut
      "Model validates economizer disable in case outdoor air conditions are above cutoff"
      extends Modelica.Icons.Example;

      parameter Modelica.SIunits.Temperature TOutCutoff=297
        "Outdoor temperature high limit cutoff";
      parameter Modelica.SIunits.SpecificEnergy hOutCutoff=65100
        "Outdoor air enthalpy high limit cutoff";
      parameter Types.FreezeProtectionStage freProDisabled = Types.FreezeProtectionStage.stage0
        "Indicates that the freeze protection is disabled";
      parameter Integer freProDisabledNum = Integer(freProDisabled)-1
        "Numerical value for freeze protection stage 0";
      parameter Types.ZoneState deadband = Types.ZoneState.deadband
        "Zone state is deadband";
      parameter Integer deadbandNum = Integer(deadband)
        "Numerical value for deadband zone state";

      CDL.Continuous.Constant TOutCut(k=TOutCutoff) "Outdoor air temperature cutoff"
        annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
      CDL.Continuous.Constant hOutCut(k=hOutCutoff) "Outdoor air enthalpy cutoff"
        annotation (Placement(transformation(extent={{-240,40},{-220,60}})));
      CDL.Continuous.Constant TOutCut1(k=TOutCutoff) "Outdoor air temperature cutoff"
        annotation (Placement(transformation(extent={{0,80},{20,100}})));
      CDL.Continuous.Constant hOutCut1(k=hOutCutoff) "Outdoor air enthalpy cutoff"
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      CDL.Continuous.Constant hOutBelowCutoff(k=hOutCutoff - 1000)
        "Outdoor air enthalpy is slightly below the cufoff"
        annotation (Placement(transformation(extent={{-240,80},{-220,100}})));
      CDL.Continuous.Constant TOutBelowCutoff(k=TOutCutoff - 2)
        "Outdoor air temperature is slightly below the cutoff"
        annotation (Placement(transformation(extent={{40,80},{60,100}})));
      CDL.Logical.TriggeredTrapezoid TOut(
        rising=1000,
        falling=800,
        amplitude=4,
        offset=TOutCutoff - 2) "Outoor air temperature"
        annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
      CDL.Logical.TriggeredTrapezoid hOut(
        amplitude=4000,
        offset=hOutCutoff - 2200,
        rising=1000,
        falling=800) "Outdoor air enthalpy"
        annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

      EconEnableDisableMultiZone econEnableDisableMultiZone "Multizone VAV AHU economizer enable disable sequence"
        annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
      EconEnableDisableMultiZone econEnableDisableMultiZone1 "Multizone VAV AHU economizer enable disable sequence"
        annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
      EconEnableDisableMultiZone econEnableDisableMultiZone2(use_enthalpy=false)
        "Multizone VAV AHU economizer enable disable sequence"
        annotation (Placement(transformation(extent={{220,-40},{240,-20}})));

    protected
      CDL.Integers.Constant ZoneState(k=deadbandNum) "Zone State is deadband"
        annotation (Placement(transformation(extent={{-200,-12},{-180,8}})));
      CDL.Continuous.Constant outDamPosMax(k=0.9) "Maximal allowed economizer damper position"
        annotation (Placement(transformation(extent={{-240,-80},{-220,-60}})));
      CDL.Continuous.Constant outDamPosMin(k=0.1) "Minimal allowed economizer damper position"
        annotation (Placement(transformation(extent={{-240,-120},{-220,-100}})));
      CDL.Continuous.Constant retDamPosMax(k=0.8) "Maximal allowed economizer damper position"
        annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
      CDL.Continuous.Constant retDamPosMin(k=0)   "Minimal allowed economizer damper position"
        annotation (Placement(transformation(extent={{-160,-200},{-140,-180}})));
      CDL.Continuous.Constant retDamPhyPosMax(k=1) "Maximal allowed economizer damper position"
        annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
      CDL.Integers.Constant FreProSta(k=freProDisabledNum) "Freeze Protection Status - Disabled"
        annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
      CDL.Sources.BooleanPulse booPul(final startTime=10, period=2000) "Boolean pulse signal"
        annotation (Placement(transformation(extent={{-200,120},{-180,140}})));
      CDL.Sources.BooleanPulse booPul1(final startTime=10, period=2000) "Boolean pulse signal"
        annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
      CDL.Logical.Constant SupFanSta(k=true) "Supply fan status signal"
          annotation (Placement(transformation(extent={{-200,-42},{-180,-22}})));

    equation
      connect(TOutCut.y, econEnableDisableMultiZone.TOutCut) annotation (Line(
            points={{-139,90},{-112,90},{-112,-22},{-81,-22}}, color={0,0,127}));
      connect(hOutCut.y, econEnableDisableMultiZone.hOutCut) annotation (Line(
            points={{-219,50},{-150,50},{-150,-26},{-81,-26}}, color={0,0,127}));
      connect(FreProSta.y, econEnableDisableMultiZone.uFreProSta) annotation (Line(
            points={{-179,30},{-120,30},{-120,-28},{-81,-28}}, color={255,127,0}));
      connect(outDamPosMax.y, econEnableDisableMultiZone.uOutDamPosMax) annotation (
         Line(points={{-219,-70},{-150,-70},{-150,-34},{-81,-34}}, color={0,0,127}));
      connect(outDamPosMin.y, econEnableDisableMultiZone.uOutDamPosMin)
        annotation (Line(points={{-219,-110},{-210,-110},{-210,-60},{-140,-60},{-140,-36},{-81,-36}},
            color={0,0,127}));
      connect(retDamPhyPosMax.y, econEnableDisableMultiZone.uRetDamPhyPosMax)
        annotation (Line(points={{-139,-110},{-110,-110},{-110,-38},{-81,-38}}, color={0,0,127}));
      connect(retDamPosMax.y, econEnableDisableMultiZone.uRetDamPosMax)
        annotation (Line(points={{-139,-150},{-106,-150},{-106,-40},{-81,-40}}, color={0,0,127}));
      connect(retDamPosMin.y, econEnableDisableMultiZone.uRetDamPosMin) annotation (
         Line(points={{-139,-190},{-102,-190},{-102,-42},{-81,-42}}, color={0,0,127}));
      connect(econEnableDisableMultiZone.uZoneState, ZoneState.y)
        annotation (Line(points={{-81,-30},{-140,-30},{-140,-2},{-179,-2}}, color={255,127,0}));
      connect(TOutCut1.y, econEnableDisableMultiZone1.TOutCut) annotation (Line(
            points={{21,90},{30,90},{30,-22},{79,-22}},color={0,0,127}));
      connect(hOutCut1.y, econEnableDisableMultiZone1.hOutCut) annotation (Line(
            points={{-59,50},{10,50},{10,-26},{79,-26}}, color={0,0,127}));
      connect(hOutBelowCutoff.y, econEnableDisableMultiZone.hOut) annotation (Line(
            points={{-219,90},{-180,90},{-180,66},{-130,66},{-130,-24},{-81,-24}},color={0,0,127}));
      connect(TOutBelowCutoff.y, econEnableDisableMultiZone1.TOut) annotation (
          Line(points={{61,90},{70,90},{70,-20},{80,-20},{79,-20}},    color={0,0,127}));
      connect(booPul.y, TOut.u)
        annotation (Line(points={{-179,130},{-162,130}}, color={255,0,255}));
      connect(TOut.y, econEnableDisableMultiZone.TOut)
        annotation (Line(points={{-139,130},{-110,130},{-110,-20},{-81,-20}},color={0,0,127}));
      connect(booPul1.y, hOut.u) annotation (Line(points={{-59,90},{-50,90},{-42,90}}, color={255,0,255}));
      connect(hOut.y, econEnableDisableMultiZone1.hOut)
        annotation (Line(points={{-19,90},{-10,90},{-10,60},{20,60},{20,-24},{79,-24}}, color={0,0,127}));
      connect(FreProSta.y, econEnableDisableMultiZone1.uFreProSta) annotation (Line(
            points={{-179,30},{-52,30},{-52,-28},{79,-28}}, color={255,127,0}));
      connect(ZoneState.y, econEnableDisableMultiZone1.uZoneState) annotation (Line(
            points={{-179,-2},{-160,-2},{-160,14},{4,14},{4,-30},{79,-30}},      color={255,127,0}));
      connect(outDamPosMax.y, econEnableDisableMultiZone1.uOutDamPosMax)
        annotation (Line(points={{-219,-70},{8,-70},{8,-34},{79,-34}},     color={0,0,127}));
      connect(outDamPosMin.y, econEnableDisableMultiZone1.uOutDamPosMin)
        annotation (Line(points={{-219,-110},{-190,-110},{-190,-64},{12,-64},{12,-36},{79,-36}},   color={0,0,127}));
      connect(retDamPhyPosMax.y, econEnableDisableMultiZone1.uRetDamPhyPosMax)
        annotation (Line(points={{-139,-110},{16,-110},{16,-38},{79,-38}},   color={0,0,127}));
      connect(retDamPosMax.y, econEnableDisableMultiZone1.uRetDamPosMax)
        annotation (Line(points={{-139,-150},{20,-150},{20,-40},{79,-40}},   color={0,0,127}));
      connect(retDamPosMin.y, econEnableDisableMultiZone1.uRetDamPosMin)
        annotation (Line(points={{-139,-190},{32,-190},{32,-42},{79,-42}}, color={0,0,127}));
      connect(TOut.y, econEnableDisableMultiZone2.TOut) annotation (Line(points={{-139,130},{-82,130},{200,130},{200,-20},{
              219,-20}}, color={0,0,127}));
      connect(TOutCut.y, econEnableDisableMultiZone2.TOutCut) annotation (Line(
            points={{-139,90},{-120,90},{-120,120},{188,120},{188,-22},{219,-22}},color={0,0,127}));
      connect(FreProSta.y, econEnableDisableMultiZone2.uFreProSta) annotation (Line(
            points={{-179,30},{170,30},{170,-28},{219,-28}}, color={255,127,0}));
      connect(ZoneState.y, econEnableDisableMultiZone2.uZoneState) annotation (Line(
            points={{-179,-2},{-168,-2},{-168,20},{150,20},{150,-30},{219,-30}},color={255,127,0}));
      connect(outDamPosMax.y, econEnableDisableMultiZone2.uOutDamPosMax)
        annotation (Line(points={{-219,-70},{178,-70},{178,-34},{219,-34}}, color={0,0,127}));
      connect(outDamPosMin.y, econEnableDisableMultiZone2.uOutDamPosMin)
        annotation (Line(points={{-219,-110},{-180,-110},{-180,-70},{188,-70},{188,-38},{188,-36},{219,-36}},
            color={0,0,127}));
      connect(retDamPhyPosMax.y, econEnableDisableMultiZone2.uRetDamPhyPosMax)
        annotation (Line(points={{-139,-110},{192,-110},{192,-38},{219,-38}}, color={0,0,127}));
      connect(retDamPosMax.y, econEnableDisableMultiZone2.uRetDamPosMax)
        annotation (Line(points={{-139,-150},{196,-150},{196,-40},{219,-40}}, color={0,0,127}));
      connect(retDamPosMin.y, econEnableDisableMultiZone2.uRetDamPosMin)
        annotation (Line(points={{-139,-190},{198,-190},{198,-42},{219,-42}}, color={0,0,127}));
      connect(SupFanSta.y, econEnableDisableMultiZone.uSupFan) annotation (Line(
            points={{-179,-32},{-134,-32},{-81,-32}},             color={255,0,255}));
      connect(SupFanSta.y, econEnableDisableMultiZone1.uSupFan) annotation (Line(
            points={{-179,-32},{-160,-32},{-160,-12},{-20,-12},{-20,-32},{79,-32}},color={255,0,255}));
      connect(SupFanSta.y, econEnableDisableMultiZone2.uSupFan) annotation (Line(
            points={{-179,-32},{-170,-32},{-170,-12},{140,-12},{140,-32},{219,-32}},color={255,0,255}));
      annotation (
      experiment(StopTime=1800.0, Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/EconEnableDisableMultiZone_TOut_hOut.mos"
        "Simulate and plot"),
      Icon(graphics={
            Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false, extent={{-260,-220},{260,220}}),
            graphics={Text(
              extent={{-234,206},{346,154}},
              lineColor={0,0,0},
              horizontalAlignment=TextAlignment.Left,
              textString="Example high limit cutoff conditions:
                      ASHRAE 90.1-2013:
                      Device Type: Fixed Enthalpy + Fixed Drybulb, Fixed Drybulb
                      TOut > 75 degF [24 degC]
                      hOut > 28 Btu/lb [65.1 kJ/kg]"),
            Text(
              extent={{-82,-40},{42,-68}},
              lineColor={0,0,0},
              horizontalAlignment=TextAlignment.Left,
              fontSize=12,
              textString="Tests temperature hysteresis"),
            Text(
              extent={{80,-40},{208,-68}},
              lineColor={0,0,0},
              horizontalAlignment=TextAlignment.Left,
              fontSize=12,
              textString="Tests enthalpy hysteresis"),
            Text(
              extent={{220,-46},{348,-74}},
              lineColor={0,0,0},
              horizontalAlignment=TextAlignment.Left,
              fontSize=12,
              textString="No enthalpy
sensor")}),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconEnableDisableMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconEnableDisableMultiZone</a>
for the following control signals: <code>TOut</code>, <code>TOutCut</code>,
<code>hOut</code>, <code>hOutCut</code>.
</p>
</html>",     revisions="<html>
<ul>
<li>
June 13, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
    end EconEnableDisableMultiZone_TOut_hOut;

    model EconModulationMultiZone_TSup
      "Validation model for multiple zone VAV AHU outdoor and return air damper position modulation sequence"
      extends Modelica.Icons.Example;

      parameter Modelica.SIunits.Temperature TCooSet=291.15
        "Supply air temperature setpoint";

      CDL.Continuous.Constant TCooSetSig(k=TCooSet) "Supply air temperature setpoint"
        annotation (Placement(transformation(extent={{-20,60},{0,80}})));
      Modelica.Blocks.Sources.Ramp TSup(
        duration=900,
        height=4,
        offset=TCooSet - 2) "Measured supply air temperature"
        annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

      CDL.Continuous.Constant outDamPosMin(k=0)
        annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
      CDL.Continuous.Constant outDamPosMax(k=1)
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      CDL.Continuous.Constant RetDamPosMin(k=0)
        annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
      CDL.Continuous.Constant RetDamPosMax(k=1)
        annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

      EconModulationMultiZone ecoMod "Economizer modulation sequence"
        annotation (Placement(transformation(extent={{40,20},{60,40}})));

    equation
      connect(TCooSetSig.y, ecoMod.TCooSet) annotation (Line(points={{1,70},{8,70},{
              8,48},{8,39},{39,39}}, color={0,0,127}));
      connect(TSup.y,ecoMod.TSup)  annotation (Line(points={{-39,70},{-30,70},{-30,36},
              {39,36}},color={0,0,127}));
      connect(RetDamPosMax.y, ecoMod.uRetDamPosMax) annotation (Line(points={{-59,-40},
              {-20,-40},{-20,24},{-6,24},{39,24}}, color={0,0,127}));
      connect(RetDamPosMin.y, ecoMod.uRetDamPosMin) annotation (Line(points={{-59,-70},
              {8,-70},{8,16},{8,21},{39,21}},color={0,0,127}));
      connect(outDamPosMax.y, ecoMod.uOutDamPosMax) annotation (Line(points={{-59,20},
              {-48,20},{-30,20},{-30,31},{39,31}}, color={0,0,127}));
      connect(outDamPosMin.y, ecoMod.uOutDamPosMin) annotation (Line(points={{-59,-10},
              {-34,-10},{-24,-10},{-24,28},{39,28}}, color={0,0,127}));
      annotation (
      experiment(StopTime=900.0, Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/EconModulationMultiZone_TSup.mos"
        "Simulate and plot"),
        Icon(graphics={Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}), Polygon(
              lineColor={0,0,255},
              fillColor={75,138,73},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
        Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconModulationMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconModulationMultiZone</a>
for supply air temeperature (<code>TSup</code>) and supply air temperature cooling setpoint (<code>TCooSet</code>)
control signals.
</p>
</html>",     revisions="<html>
<ul>
<li>
June 30, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
    end EconModulationMultiZone_TSup;

    model VAVSingleZoneTSupSet_T
      "Validation model for outdoor minus room air temperature"
      extends Modelica.Icons.Example;

      VAVSingleZoneTSupSet setPoiVAV(
        yHeaMax=0.7,
        yMin=0.3,
        TMax=303.15,
        TMin=289.15,
        yCooMax=0.9)
        "Block that computes the setpoints for temperature and fan speed"
        annotation (Placement(transformation(extent={{0,-10},{20,10}})));

      CDL.Continuous.Constant uHea(k=0) "Heating control signal"
        annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

      CDL.Continuous.Constant uCoo(k=0.6) "Cooling control signal"
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

      Modelica.Blocks.Sources.Ramp TOut(
        duration=1,
        height=18,
        offset=273.15 + 10) "Outdoor air temperature"
        annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

      CDL.Continuous.Constant TZon(k=273.15 + 22) "Zone temperature"
        annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
      CDL.Continuous.Add dT(k2=-1) "Difference zone minus outdoor temperature"
        annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
      CDL.Continuous.Constant TSetZon(k=273.15 + 22) "Average zone set point"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
    equation
      connect(uCoo.y, setPoiVAV.uCoo) annotation (Line(points={{-59,50},{-31.5,50},
              {-31.5,4},{-2,4}},color={0,0,127}));
      connect(TZon.y, setPoiVAV.TZon) annotation (Line(points={{-59,-10},{-32,-10},{
              -32,-4},{-2,-4}}, color={0,0,127}));
      connect(TOut.y, setPoiVAV.TOut) annotation (Line(points={{-59,-50},{-28,-50},{
              -28,-8},{-2,-8}}, color={0,0,127}));
      connect(uHea.y, setPoiVAV.uHea) annotation (Line(points={{-59,80},{-59,80},{
              -20,80},{-20,8},{-2,8}},
                                   color={0,0,127}));
      connect(dT.u1, TZon.y) annotation (Line(points={{-2,-34},{-32,-34},{-32,-10},{
              -59,-10}}, color={0,0,127}));
      connect(dT.u2, TOut.y) annotation (Line(points={{-2,-46},{-28,-46},{-28,-50},{
              -59,-50}}, color={0,0,127}));
      connect(TSetZon.y, setPoiVAV.TSetZon) annotation (Line(points={{-59,20},{-40,
              20},{-40,0},{-2,0}}, color={0,0,127}));
      annotation (
      experiment(StopTime=1.0, Tolerance=1e-6),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/VAVSingleZoneTSupSet_T.mos"
            "Simulate and plot"),
        Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.VAVSingleZoneTSupSet\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.VAVSingleZoneTSupSet</a>
for a change in temperature difference between zone air and outdoor air.
Hence, this model validates whether the adjustment of the fan speed for medium
cooling load is correct implemented.
</p>
</html>",     revisions="<html>
<ul>
<li>
January 10, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
    end VAVSingleZoneTSupSet_T;

    model VAVSingleZoneTSupSet_u "Validation model for control input"
      extends Modelica.Icons.Example;

      VAVSingleZoneTSupSet setPoiVAV(
        yHeaMax=0.7,
        yMin=0.3,
        TMax=303.15,
        TMin=289.15)
        "Block that computes the setpoints for temperature and fan speed"
        annotation (Placement(transformation(extent={{0,-10},{20,10}})));

      CDL.Continuous.Constant TZon(k=273.15 + 23) "Zone air temperature"
        annotation (Placement(transformation(extent={{-80,-22},{-60,0}})));

      CDL.Continuous.Constant TOut(k=273.15 + 21) "Outdoor temperature"
        annotation (Placement(transformation(extent={{-80,-62},{-60,-40}})));

      Modelica.Blocks.Sources.Ramp uHea(
        duration=0.25,
        height=-1,
        offset=1) "Heating control signal"
        annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

      Modelica.Blocks.Sources.Ramp uCoo(duration=0.25, startTime=0.75)
        "Cooling control signal"
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

      CDL.Continuous.Constant TSetZon(k=273.15 + 22) "Average zone set point"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
    equation
      connect(TZon.y, setPoiVAV.TZon) annotation (Line(points={{-59,-11},{-31.5,-11},
              {-31.5,-4},{-2,-4}}, color={0,0,127}));
      connect(TOut.y, setPoiVAV.TOut) annotation (Line(points={{-59,-51},{-24,-51},{
              -24,-8},{-2,-8}}, color={0,0,127}));
      connect(uHea.y, setPoiVAV.uHea) annotation (Line(points={{-59,80},{-12,80},{
              -12,8},{-2,8}},
                          color={0,0,127}));
      connect(uCoo.y, setPoiVAV.uCoo) annotation (Line(points={{-59,50},{-59,50},{
              -16,50},{-16,4},{-2,4}},
                                   color={0,0,127}));
      connect(TSetZon.y, setPoiVAV.TSetZon) annotation (Line(points={{-59,20},{-20,
              20},{-20,0},{-2,0}}, color={0,0,127}));
      annotation (
      experiment(StopTime=1.0, Tolerance=1e-6),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/VAVSingleZoneTSupSet_u.mos"
            "Simulate and plot"),
        Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.VAVSingleZoneTSupSet\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.VAVSingleZoneTSupSet</a>
for different control signals.
</p>
</html>",     revisions="<html>
<ul>
<li>
January 10, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
    end VAVSingleZoneTSupSet_u;
  annotation (Documentation(revisions="<html>
</html>",   info="<html>
<p>
This package contains models that validate the control sequences.
The examples plot various outputs, which have been verified against
analytical solutions. These model outputs are stored as reference data to
allow continuous validation whenever models in the library change.
</p>
</html>"));
  end Validation;
  annotation (Icon(graphics={Rectangle(
        extent={{-60,60},{60,-60}},
        lineColor={0,0,127},
        lineThickness=0.5)}),
Documentation(info="<html>
<p>
This package contains atomic control sequences from
ASHRAE Guideline 36. Atomic control sequences are building
blocks of composite sequences.
</p>
</html>"));
end Atomic;
