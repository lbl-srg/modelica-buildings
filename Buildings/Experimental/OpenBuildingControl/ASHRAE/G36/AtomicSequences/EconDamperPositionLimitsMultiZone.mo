within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconDamperPositionLimitsMultiZone
  "Multiple zone VAV AHU minimum outdoor air control with a single common damper for 
  minimum outdoor air and economizer functions"

  parameter Real retDamPhyPosMax(min=0, max=1, unit="1") = 1
    "Physical or at the comissioning fixed maximum opening of the return air damper";
  parameter Real retDamPhyPosMin(min=0, max=1, unit="1") = 0
    "Physical or at the comissioning fixed minimum opening of the return air damper";
  parameter Real outDamPhyPosMax(min=0, max=1, unit="1") = 1
    "Physical or at the comissioning fixed maximum opening of the outdoor air damper";
  parameter Real outDamPhyPosMin(min=0, max=1, unit="1") = 0
    "Physical or at the comissioning fixed minimum opening of the outdoor air damper";
  parameter Real yConSigMin=0 "Lower limit of control signal output";
  parameter Real yConSigMax=1 "Upper limit of control signal output";
  parameter Real sigFraOutDam(min=yConSigMin, max=yConSigMax, unit="1")=0.5
    "Fraction of the control loop signal below which the outdoor air damper limit gets 
    modulated and above which the return air damper limit gets modulated";

  CDL.Interfaces.RealInput uVOut(unit="m3/s")
    "Measured outdoor airflow rate [fixme: which quantity attribute should we use]"
    annotation (Placement(transformation(extent={{-280,180},{-240,220}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput uVOutMinSet(unit="m3/s")
    "Minimum outdoor airflow rate set point"
    annotation (Placement(transformation(extent={{-280,240},{-240,280}}),
        iconTransformation(extent={{-120,40},{-100,60}})));
  CDL.Interfaces.IntegerInput uAHUMode
    "AHU System Mode [fixme: implement conversion to enumeration]"
    annotation (Placement(transformation(extent={{-280,-240},{-240,-200}}),
    iconTransformation(extent={{-120,-60},{-100,-40}})));
  CDL.Interfaces.IntegerInput uFreProSta
    "Freeze Protection Status [fixme: implement conversion to enumeration]"
    annotation (Placement(transformation(extent={{-280,-200},{-240,-160}}),
    iconTransformation(extent={{-120,-90},{-100,-70}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status"
    annotation (Placement(transformation(extent={{-280,-160},{-240,-120}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.RealOutput yOutDamPosMin(min=0, max=1, unit="1")
    "Minimum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{240,70},{260,90}}),
    iconTransformation(extent={{100,20}, {120,40}})));
  CDL.Interfaces.RealOutput yOutDamPosMax(min=0, max=1, unit="1")
    "Maximum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{240,30},{260,50}}),
    iconTransformation(extent={{100,60},{120,80}})));
  CDL.Interfaces.RealOutput yRetDamPosMax(min=0, max=1, unit="1")
    "Maximum return air damper position limit"
    annotation (Placement(transformation(extent={{240,-50},{260,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));
  CDL.Interfaces.RealOutput yRetDamPosMin(min=0, max=1, unit="1")
    "Minimum return air damper position limit"
    annotation (Placement(transformation(extent={{240,-10},{260,10}}),
    iconTransformation(extent={{100,-20},{120,0}})));
  CDL.Interfaces.RealOutput yRetDamPhyPosMax(min=0, max=1, unit="1")
    "Physical maximum return air damper position limit. Required as an input for the
    economizer enable disable sequence."
    annotation (Placement(transformation(extent={{240,-90},{260,-70}}),
        iconTransformation(extent={{100,-80},{120,-60}})));

protected
  parameter Real occupied=1
    "AHU System Mode = Occupied [fixme: implement conversion to enumeration]";
  parameter Real higestIgnFreProSta=1
    "Highest freeze protection status that does not deactivate the controller
    [fixme: implement conversion to enumeration]";
  CDL.Continuous.Constant outDamPhyPosMinSig(k=outDamPhyPosMin)
    "Physical or at the comissioning fixed minimum position of the outdoor air damper. 
    This is the initial position of the economizer damper."
    annotation (Placement(transformation(extent={{-220,70},{-200,90}})));
  CDL.Continuous.Constant outDamPhyPosMaxSig(k=outDamPhyPosMax)
    "Physical or at the comissioning fixed maximum position of the outdoor 
    air damper."
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));
  CDL.Continuous.Constant retDamPhyPosMinSig(k=retDamPhyPosMin)
    "Physical or at the comissioning fixed minimum position of the return air damper"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));
  CDL.Continuous.Constant retDamPhyPosMaxSig(final k=retDamPhyPosMax)
    "Physical or at the comissioning fixed maximum position of the return air damper. 
    This is the initial condition of the return air damper."
    annotation (Placement(transformation(extent={{-220,-50},{-200,-30}})));
  CDL.Continuous.Constant minSignalLimit(k=yConSigMin)
    "Equals minimum controller output signal"
    annotation (Placement(transformation(extent={{-20,240},{0,260}})));
  CDL.Continuous.Constant maxSignalLimit(k=yConSigMax)
    "Equals maximum controller output signal"
    annotation (Placement(transformation(extent={{100,240},{120,260}})));
  CDL.Continuous.Constant sigFraForOutDam(k=sigFraOutDam)
    "Equals the fraction of the control loop signal below which the outdoor air damper 
    limit gets modulated and above which the return air damper limit gets modulated"
    annotation (Placement(transformation(extent={{40,240},{60,260}})));
  CDL.Continuous.Constant AHUMode(final k=occupied)
    "Generates AHU System Mode = Occupied signal
    [fixme: implement conversion to enumeration]"
    annotation (Placement(transformation(extent={{-220,-260},{-200,-240}})));

  CDL.Continuous.LimPID damLimController(
    Ti=0.9,
    Td=0.1,
    Nd=1,
    yMax=yConSigMax,
    yMin=yConSigMin,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI,
    k=1)
    "Contoller that outputs a signal based on the error between the measured outdoor 
    airflow and the minimum outdoor airflow requirement."
    annotation (Placement(transformation(extent={{-180,220},{-160,240}})));
  CDL.Continuous.Line minOutDam(limitBelow=true, limitAbove=true)
    "The line maps the outdoor air damper position to the control signal"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  CDL.Continuous.Line minRetDam(limitBelow=true, limitAbove=true)
    "The line maps the return air damper position to the control signal"
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
  CDL.Logical.Switch retDamPosMinSwitch
    "A switch to deactivate the return air damper minimal outdoor airflow control"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  CDL.Logical.Switch outDamPosMaxSwitch
    "A switch to deactivate the outdoor air damper minimal outdoor airflow control"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  CDL.Logical.And3 and1
    "Evaluates input signals to determine whether the minimum outdoor airflow control
    should be enabled or disabled"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  CDL.Logical.Not not1 "Logical not block"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  CDL.Conversions.IntegerToReal intToRea "Integer to real converter"
    annotation (Placement(transformation(extent={{-220,-190},{-200,-170}})));
  CDL.Conversions.IntegerToReal intToRea1 "Integer to real converter"
    annotation (Placement(transformation(extent={{-220,-230},{-200,-210}})));
  CDL.Logical.LessEqualThreshold equ(final threshold=higestIgnFreProSta)
    "Logical block that determines whether the freeze protection stage is below the
    disable threshold"
    annotation (Placement(transformation(extent={{-180,-190},{-160,-170}})));
  CDL.Logical.Equal equ1 annotation (Placement(transformation(extent={{-180,-230},{-160,-210}})));

equation
  connect(minRetDam.y,yRetDamPosMax)  annotation (Line(points={{161,110},{180,110},{180,20},{220,20},
          {220,-40},{250,-40}}, color={0,0,127}));
  connect(retDamPosMinSwitch.y, minRetDam.f2) annotation (Line(points={{61,0},{61,2},{61,0},{100,0},{
          100,102},{138,102}}, color={0,0,127}));
  connect(sigFraForOutDam.y,minRetDam. x1)
    annotation (Line(points={{61,250},{90,250},{90,118},{138,118}}, color={0,0,127}));
  connect(maxSignalLimit.y,minRetDam. x2)
    annotation (Line(points={{121,250},{130,250},{130,106},{138, 106}}, color={0,0,127}));
  connect(uVOut,damLimController. u_m)
    annotation (Line(points={{-260,200},{-170,200},{-170,218}},color={0,0,127}));
  connect(uVOutMinSet,damLimController. u_s)
    annotation (Line(points={{-260,260},{-222,260},{-222,230}, {-182,230}}, color={0,0,127}));
  connect(damLimController.y,minRetDam. u)
    annotation (Line(points={{-159,230},{-90,230},{-90,110},{138,110}}, color={0,0,127}));
  connect(outDamPosMaxSwitch.y, minOutDam.f2)
    annotation (Line(points={{61,40},{112,40},{112,162},{138,162}}, color={0,0,127}));
  connect(minSignalLimit.y,minOutDam. x1)
    annotation (Line(points={{1,250},{10,250},{10,178},{138,178}}, color={0,0,127}));
  connect(sigFraForOutDam.y,minOutDam. x2)
    annotation (Line(points={{61,250},{70,250},{70,166},{138,166}}, color={0,0,127}));
  connect(damLimController.y,minOutDam. u)
    annotation (Line(points={{-159,230},{-60,230},{-60,170},{138, 170}}, color={0,0,127}));
  connect(outDamPosMaxSwitch.y, yOutDamPosMax)
    annotation (Line(points={{61,40},{140,40},{250,40}}, color={0,0,127}));
  connect(minOutDam.y,yOutDamPosMin)
    annotation (Line(points={{161,170},{200,170},{200,80},{250,80}}, color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, retDamPosMinSwitch.u1)
    annotation (Line(points={{-199,-40},{-48,-40},{-48,8},{38,8}}, color={0,0,127}));
  connect(retDamPhyPosMaxSig.y,minRetDam. f1)
    annotation (Line(points={{-199,-40},{-134,-40},{-134,114}, {-68,114},{138,114}}, color={0,0,127}));
  connect(retDamPhyPosMinSig.y, retDamPosMinSwitch.u3)
    annotation (Line(points={{-199,0},{-90,0},{-90,-8},{38,-8}}, color={0,0,127}));
  connect(outDamPhyPosMaxSig.y, outDamPosMaxSwitch.u3)
    annotation (Line(points={{-199,40},{-120,40},{-120,32},{38,32}}, color={0,0,127}));
  connect(outDamPhyPosMinSig.y, outDamPosMaxSwitch.u1)
    annotation (Line(points={{-199,80},{-20,80},{-20,48},{38,48}}, color={0,0,127}));
  connect(outDamPhyPosMinSig.y,minOutDam. f1)
    annotation (Line(points={{-199,80},{-48,80},{-48,174},{138,174}}, color={0,0,127}));
  connect(uSupFan,and1. u1)
    annotation (Line(points={{-260,-140},{-168,-140},{-168,-122},{-142,-122}}, color={255,0,255}));
  connect(and1.y,not1. u)
    annotation (Line(points={{-119,-130},{-102,-130}}, color={255,0,255}));
  connect(not1.y, retDamPosMinSwitch.u2)
    annotation (Line(points={{-79,-130},{0,-130},{0,0},{38,0}}, color={255,0,255}));
  connect(not1.y, outDamPosMaxSwitch.u2)
    annotation (Line(points={{-79,-130},{-79,-130},{0,-130},{0,40},{38,40}}, color={255,0,255}));
  connect(retDamPosMinSwitch.y, yRetDamPosMin)
    annotation (Line(points={{61,0},{250,0},{250,0}}, color={0,0,127}));
  connect(and1.u2, equ.y)
    annotation (Line(points={{-142,-130},{-150,-130},{-150,-180},{-159,-180}}, color={255,0,255}));
  connect(intToRea.u, uFreProSta)
    annotation (Line(points={{-222,-180},{-222,-180},{-260,-180}}, color={255,127,0}));
  connect(intToRea.y, equ.u)
    annotation (Line(points={{-199,-180},{-190,-180},{-182,-180}}, color={0,0,127}));
  connect(uAHUMode, intToRea1.u)
    annotation (Line(points={{-260,-220},{-242,-220},{-222,-220}}, color={255,127,0}));
  connect(and1.u3, equ1.y)
    annotation (Line(points={{-142,-138},{-146,-138},{-146,-220},{-159,-220}}, color={255,0,255}));
  connect(intToRea1.y, equ1.u1)
    annotation (Line(points={{-199,-220},{-190.5,-220},{-182,-220}}, color={0,0,127}));
  connect(AHUMode.y, equ1.u2)
    annotation (Line(points={{-199,-250},{-190,-250},{-190,-228},{-182,-228}}, color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, yRetDamPhyPosMax)
    annotation (Line(points={{-199,-40},{198,-40},{198,-80},{250,-80}}, color={0,0,127}));
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
    Diagram(coordinateSystem(extent={{-240,-280},{240,280}},
        initialScale=0.1), graphics={
        Rectangle(extent={{-240,280},{-100,160}}, lineColor={28,108,200}),
    Text( extent={{-174,192},{-114,166}},
          lineColor={28,108,200},
          fontSize=12,
          textString="Outdoor airflow control loop."),
          Rectangle(extent={{-100,280},{240,-110}},
          lineColor={28,108,200}), Text(
          extent={{40,-48},{184,-130}},
          lineColor={28,108,200},
          fontSize=12,
          textString="Damper position limit calculation and assignments."),
     Rectangle(extent={{-240,160},{-100,-110}},
          lineColor={28,108,200}), Text(
          extent={{-240,-48},{-96,-130}},
          lineColor={28,108,200},
          fontSize=12,
          textString="Physical damper position  limits set at commissioning."),
          Text(extent={{22,84},{70,48}},
          lineColor={28,108,200},
          fontSize=8,
          textString="Switches that deactivate the limit modulation.")}),
    Documentation(info="<html>      
<p>
This block models the multiple zone VAV AHU minimum outdoor air control with a single 
common damper for minimum outdoor air and economizer functions based on outdoor airflow 
measurement, designed in line with ASHRAE Guidline 36 (G36), PART5.N.6.c.
</p>
<p>
The controller is enabled when the supply fan is proven on (<code>uSupFan=true</code>), 
the AHU is in Occupied Mode (<code>uAHUMode=1</code>[fixme: enumeration]), 
and Freeze Protection Stage <code>uFreProSta</code> is not larger than 1. 
Otherwise the damper position limits are set to their corresponding maximum and minimum 
physical or at  comissioning fixed limits, as illustrated below:
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits state machine chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconDamperLimitsStateMachineChartMultiZone.png\"/>
</p>
<p>
The controller controls the outdoor and return damper position limits so
that the outdoor airflow rate, <code>uVOut</code>, stays equal or above the 
minimum outdoor air setpoint, <code>VOutMinSet</code>. Fraction of the controller 
output signal between <code>yConSigMin</code> and <code>sigFraOutDam</code> is 
linearly mapped to the outdoor air damper minimal position, <code>yOutDamPosMin</code>, 
while the fraction of the controller output between <code>sigFraOutDam</code> and 
<code>yConSigMax</code> is linearly mapped to the return air damper maximum position,
<code>yRetDamPosMax</code>.
</p>
<p>
The following control charts show the input-output structure and an expected damper position 
limits for a well tuned controller. Control diagram:
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits control diagram\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconDamperLimitsControlDiagramMultiZone.png\"/>
</p>
<p>
Expected control performance (damper position limits vs. control loop signal):
<br>
</br>
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits control chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconDamperLimitsControlChart.png\"/>
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
