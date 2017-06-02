within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconDamperPositionLimitsMultiZone "Based on measured and requred minimum outdoor airflow the controller resets 
  the min limit of the economizer damper and the max limit of the return air 
  damper in order to maintain the minimum required outdoor airflow."
  // fixme: add keep previous pos if VOut>VOutSet AND outDamPos>outDamPosMin
  // to avoid non-realistic setting of say econ min limit to 0 because the
  // measured flow is higher while the economizer is open wider (enabled or
  // modulating above the min)
  // fixme: potentially a better name since used in communication with Brent: OA control loop

  parameter Real retDamPhyPosMax(min=0, max=1, unit="1")= 1 "fixme";
  parameter Real retDamPhyPosMin(min=0, max=1, unit="1")=0 "Constant output value";
  parameter Real outDamPhyPosMax(min=0, max=1, unit="1")=1 "Constant output value";
  parameter Real outDamPhyPosMin(min=0, max=1, unit="1")=0 "Constant output value";
  parameter Real yConSigMin=0 "Lower limit of controller output";
  parameter Real yConSigMax=1 "Upper limit of controller output";
  parameter Real sigFraOutDam(min=yConSigMin, max=yConSigMax, unit="1")=0.6
    "Constant output value, assumes that the controller outputs values between 0 and 1";

  CDL.Interfaces.RealInput uVOut
    "Measured outdoor airflow rate. Sensor output. Location: after the economizer damper intake."
    annotation (Placement(transformation(extent={{-280,60},{-240,100}}),
        iconTransformation(extent={{-280,60},{-240,100}})));
  CDL.Interfaces.RealInput uVOutMinSet
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-280,100},{-240,140}}),
        iconTransformation(extent={{-280,100},{-240,140}})));
  CDL.Continuous.Constant retDamPhyPosMinSig(k=retDamPhyPosMin)
    "Physical or at the comissioning fixed minimum opening of the return air damper. Assuming 0 airflow through the damper at this position. fixme: this maybe needs to be an input. fixme: Have this be a hardware input (make a \"physical data determined at comissioning block\")"
    annotation (Placement(transformation(extent={{-104,-122},{-84,-102}})));
  //fixme add units, should be percentage
  CDL.Continuous.Constant outDamPhyPosMinSig(k=outDamPhyPosMin)
    "Physical or at the comissioning fixed minimum position of the economizer damper - economizer damper closed. Assuming VOut = 0 at this condition. This is the initial position of the economizer damper. fixme: It should always be 0 (pp), should we define this as final? fixme: Have this be a hardware input (make a \"physical data determined at comissioning block\")"
    annotation (Placement(transformation(extent={{-104,-202},{-84,-182}})));
  CDL.Continuous.LimPID minOutAirDamPosController(
    Ti=0.9,
    Td=0.1,
    Nd=1,
    k=0.02,
    yMax=yConSigMax,
    yMin=yConSigMin,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI)
    "Contoller that outputs a signal based on the error between the measured outdoor airflow and the minimum outdoor airflow requirement."
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));

  CDL.Continuous.Constant sigFraForOutDam(k=sigFraOutDam)
    "Fraction of the control signal for which the economizer damper is and stays fully open and above which the return air damper modulates downwards."
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-280,0},{-240,40}}),
        iconTransformation(extent={{-280,0},{-240,40}})));
  CDL.Interfaces.RealOutput yOutDamPosMin(min=0, max=1, unit="1")
    "Minimum economizer damper position limit." annotation (Placement(
        transformation(extent={{180,10},{200,30}}),  iconTransformation(extent={{180,10},
            {200,30}})));
  CDL.Interfaces.RealOutput yRetDamPosMax(min=0, max=1, unit="1")
    "Maximum return air damper position limit" annotation (Placement(
        transformation(extent={{180,-50},{200,-30}}),
                                                    iconTransformation(extent={{180,-50},
            {200,-30}})));
  CDL.Continuous.Constant retDamPhyPosMaxSig(final k=retDamPhyPosMax)
    "Physical or at the comissioning fixed maximum opening of the return air damper. This is the initial condition of the return air damper. fixme: Have this be a hardware input (make a \"physical data determined at comissioning block\")"
    annotation (Placement(transformation(extent={{-104,-82},{-84,-62}})));
  CDL.Continuous.Constant outDamPhyPosMaxSig(k=outDamPhyPosMax)
    "Physical or at the comissioning fixed maximum position of the economizer damper - economizer damper fully open. fixme: Have this be a hardware input (make a \"physical data determined at comissioning block\")"
    annotation (Placement(transformation(extent={{-104,-162},{-84,-142}})));
  CDL.Continuous.Line minOutDam(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  CDL.Continuous.Line minRetDam(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  CDL.Logical.And3 nand
    "If any of the input signals is not true, the block outputs true, damper modulation gets supressed and dampers are kept in their initial positions."
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  CDL.Logical.Switch RetDamPosMin
    "Set to RetDamPhyPosMax if the supply fan is off or the AHU mode is disabled to prevent any modulation"
    annotation (Placement(transformation(extent={{-6,-132},{14,-112}})));
  CDL.Logical.Switch outDamPosMax
    "Set to EcoDamPhyPosMin if the supply fan is off or the AHU mode is disabled to prevent any modulation"
    annotation (Placement(transformation(extent={{-6,-172},{14,-152}})));
  CDL.Continuous.Constant minSignalLimit(k=0)
    "Identical to controller parameter - Lower limit of output. fixme - set equal to yMin from PID"
    annotation (Placement(transformation(extent={{-20,92},{0,112}})));
  CDL.Continuous.Constant maxSignalLimit(k=1)
    "Identical to controller parameter - Upper limit of output. foxme - set equal to param yMax from PID"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  CDL.Interfaces.RealOutput yRetDamPosMin(min=0, max=1, unit="1")
    "Maximum return air damper position limit" annotation (Placement(
        transformation(extent={{180,-30},{200,-10}}),
                                                    iconTransformation(extent={{180,-20},
            {200,0}})));
  CDL.Interfaces.RealOutput yOutDamPosMax(min=0, max=1, unit="1")
    "Minimum economizer damper position limit." annotation (Placement(
        transformation(extent={{180,-10},{200,10}}), iconTransformation(extent={{180,36},
            {200,56}})));

  CDL.Interfaces.IntegerInput uFreProSta( quantity="Status")= 0
    "Freeze Protection Status signal, it can be an integer 0 - 3 [fixme check quantity]"
    annotation (Placement(transformation(extent={{-280,-120},{-240,-80}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-220,-110},{-200,-90}})));
  CDL.Logical.LessEqualThreshold ZoneStateStatusHeating(threshold=1)
    "If true, the heating signal is 0. fixme: use ZoneState type instead."
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-110,20},{-90,40}})));
  CDL.Logical.Equal              ZoneStateStatusHeating1
    "If true, the heating signal is 0. fixme: use ZoneState type instead."
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{-220,-30},{-200,-10}})));
  CDL.Interfaces.IntegerInput uAHUModSta(quantity="Status")=0
    "AHU System Mode status signal, [fixme: see documentation for more details]"
    annotation (Placement(transformation(extent={{-280,-40},{-240,0}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Continuous.Constant con(k=1)
    annotation (Placement(transformation(extent={{-220,-60},{-200,-40}})));
equation
  connect(uVOut,minOutAirDamPosController. u_m)
    annotation (Line(points={{-260,80},{-90,80},{-90,108}},color={0,0,127}));
  connect(outDamPhyPosMaxSig.y, outDamPosMax.u3) annotation (Line(points={{-83,
          -152},{-48,-152},{-48,-170},{-8,-170}},  color={0,0,127}));
  connect(outDamPhyPosMinSig.y, outDamPosMax.u1) annotation (Line(points={{-83,
          -192},{-60,-192},{-60,-154},{-8,-154}},  color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, RetDamPosMin.u1) annotation (Line(points={{-83,-72},
          {-52,-72},{-52,-114},{-8,-114}},       color={0,0,127}));
  connect(retDamPhyPosMinSig.y, RetDamPosMin.u3) annotation (Line(points={{-83,
          -112},{-66,-112},{-66,-130},{-8,-130}},  color={0,0,127}));
  connect(minRetDam.y, yRetDamPosMax) annotation (Line(points={{121,50},{130,50},
          {130,-40},{190,-40}},color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, minRetDam.f1) annotation (Line(points={{-83,-72},
          {12,-72},{12,54},{98,54}},   color={0,0,127}));
  connect(RetDamPosMin.y, minRetDam.f2) annotation (Line(points={{15,-122},{20,
          -122},{20,42},{98,42}},   color={0,0,127}));
  connect(sigFraForOutDam.y, minRetDam.x1) annotation (Line(points={{1,140},{40,
          140},{40,58},{98,58}},
                              color={0,0,127}));
  connect(maxSignalLimit.y, minRetDam.x2) annotation (Line(points={{1,70},{32,
          70},{32,46},{98,46}},   color={0,0,127}));
  connect(minOutAirDamPosController.y, minRetDam.u) annotation (Line(points={{-79,120},
          {-28,120},{-28,50},{98,50}},      color={0,0,127}));
  connect(outDamPosMax.y, minOutDam.f2) annotation (Line(points={{15,-162},{46,
          -162},{46,2},{98,2}},       color={0,0,127}));
  connect(outDamPhyPosMinSig.y, minOutDam.f1) annotation (Line(points={{-83,
          -192},{30,-192},{30,14},{98,14}},
                                          color={0,0,127}));
  connect(minSignalLimit.y, minOutDam.x1) annotation (Line(points={{1,102},{36,
          102},{36,18},{98,18}},    color={0,0,127}));
  connect(sigFraForOutDam.y, minOutDam.x2) annotation (Line(points={{1,140},{20,
          140},{20,6},{98,6}},  color={0,0,127}));
  connect(minOutAirDamPosController.y, minOutDam.u) annotation (Line(points={{-79,120},
          {-40,120},{-40,10},{98,10}},        color={0,0,127}));
  connect(retDamPhyPosMinSig.y, yRetDamPosMin) annotation (Line(points={{-83,
          -112},{-66,-112},{-66,-148},{150,-148},{150,-20},{190,-20}},
                                                               color={0,0,127}));
  connect(outDamPosMax.y, yOutDamPosMax) annotation (Line(points={{15,-162},{
          140,-162},{140,0},{190,0}},
                                    color={0,0,127}));
  connect(minOutDam.y, yOutDamPosMin) annotation (Line(points={{121,10},{150,10},
          {150,20},{190,20}}, color={0,0,127}));
  connect(uVOutMinSet, minOutAirDamPosController.u_s) annotation (Line(points={{-260,
          120},{-160,120},{-102,120}},                  color={0,0,127}));
  connect(intToRea.y, ZoneStateStatusHeating.u) annotation (Line(points={{-199,
          -100},{-199,-100},{-182,-100}}, color={0,0,127}));
  connect(uFreProSta, intToRea.u)
    annotation (Line(points={{-260,-100},{-222,-100}}, color={255,127,0}));
  connect(uSupFan, nand.u1) annotation (Line(points={{-260,20},{-172,20},{-172,
          38},{-142,38}}, color={255,0,255}));
  connect(ZoneStateStatusHeating.y, nand.u3) annotation (Line(points={{-159,
          -100},{-152,-100},{-152,22},{-142,22}}, color={255,0,255}));
  connect(nand.y, not1.u)
    annotation (Line(points={{-119,30},{-112,30}}, color={255,0,255}));
  connect(not1.y, RetDamPosMin.u2) annotation (Line(points={{-89,30},{-52,30},{
          -52,-122},{-8,-122}}, color={255,0,255}));
  connect(not1.y, outDamPosMax.u2) annotation (Line(points={{-89,30},{-52,30},{
          -52,-162},{-8,-162}}, color={255,0,255}));
  connect(uAHUModSta, intToRea1.u) annotation (Line(points={{-260,-20},{-260,
          -20},{-222,-20}}, color={255,127,0}));
  connect(ZoneStateStatusHeating1.y, nand.u2) annotation (Line(points={{-159,
          -20},{-152,-20},{-152,10},{-152,10},{-152,30},{-142,30}}, color={255,
          0,255}));
  connect(intToRea1.y, ZoneStateStatusHeating1.u1)
    annotation (Line(points={{-199,-20},{-182,-20}}, color={0,0,127}));
  connect(ZoneStateStatusHeating1.u2, con.y) annotation (Line(points={{-182,-28},
          {-188,-28},{-188,-50},{-199,-50}}, color={0,0,127}));
  annotation (
    defaultComponentName = "ecoEnaDis",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,
            180}}),                                             graphics={
        Rectangle(
        extent={{-180,-140},{180,180}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-176,138},{-116,106}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uVOutMin"),
        Text(
          extent={{106,34},{176,-2}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPosMax"),
        Text(
          extent={{-176,70},{-136,48}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uVOut"),
        Text(
          extent={{106,64},{176,28}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPosMin"),
        Text(
          extent={{-176,-54},{-116,-86}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uAHUMod"),
        Text(
          extent={{-176,8},{-116,-18}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uSupFan"),
        Text(
          extent={{106,-24},{176,-60}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPosMax"),
        Text(
          extent={{108,8},{178,-28}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPosMin"),
        Line(
          points={{-118,-96},{130,-96},{-4,150},{-118,-96}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-124,216},{112,186}},
          lineColor={85,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(                           extent={{-240,-220},{
            180,180}},
        initialScale=0.1), graphics={
        Text(
          extent={{-128,-36},{-8,-56}},
          lineColor={28,108,200},
          textString="Fixme: These should be inputs, comming from
 some IO.Hardware/Comissioning block"),
        Rectangle(extent={{-116,-40},{-42,-208}},
                                                lineColor={28,108,200}),
        Text(
          extent={{-32,-56},{34,-74}},
          lineColor={28,108,200},
          fontSize=12,
          textString="False means 
controller active, true means
 that OutDamMin gets 
assigned with OutDamPhyMin,
 and RetDamMax gets assigned 
with RetDamPhyMax")}),
    Documentation(info="<html>      
<p>
This atomic sequence sets the minimum economizer damper position limit and
the maximum return air damper position limit. The implementation is according
to ASHRAE Guidline 36 (G36), PART5.N.6.c.
</p>   
<p>
The controller is enabled when the supply fan is proven on and the AHU is in
Occupied Mode. Otherwise the damper position limits are set to their corresponding
maximum and minimum physical or at comissioning fixed limits. The state machine
diagram below illustrates this.
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits state machine chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconDamperLimitsStateMachineChart.png\"/>
</p>
<p>
According to mentioned article from G36, the outdoor airflow rate, uVOut,
shall be maintained at the minimum outdoor air setpoint, VOutMinSet, which is an output of
a separate atomic sequence, by a reverse-acting control loop whose output is 
mapped to the maximum return air damper position, yRetDamPosMax, and to the
minimum supply air damper position, yOutDamPosMin.
</p>
<p>
Control charts below show the input-output structure and a damper limit 
position sequence assuming a well tuned controller. Control diagram:
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits control diagram\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconDamperLimitsControlDiagram.png\"/>
</p>
<p>
Expected control performance, upon tuning:
<br>
</br>
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits control chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconDamperLimitsControlChart.png\"/>
</p>
<p>
fixme: additional text about the functioning of the sequence
Note that VOut depends on whether the economizer damper is controlled to a 
position higher than it's minimum limit. This is defined by the EconEnableDisable
and EconModulate [fixme check seq name] sequences. Fixme feature add: For this reason
we may want to implement something like:
while VOut > VOutSet and outDamPos>outDamPosMin, keep previous outDamPosMin.
fixme: add option for separate minimum outdoor air damper.
</p>

</html>", revisions="<html>
<ul>
<li>
April 04, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconDamperPositionLimitsMultiZone;
