within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconDamperPositionLimitsMultiZone "Based on measured and requred minimum outdoor airflow the controller resets 
  the min limit of the economizer damper and the max limit of the return air 
  damper in order to maintain the minimum required outdoor airflow."
  // fixme: add keep previous pos if VOut>VOutSet AND outDamPos>outDamPosMin
  // to avoid non-realistic setting of say econ min limit to 0 because the
  // measured flow is higher while the economizer is open wider (enabled or
  // modulating above the min)
  // fixme: potentially a better name since used in communication with Brent: OA control loop

  parameter Real retDamPhyPosMax(min=0, max=1, unit="1") = 1 "Physical or at the comissioning fixed maximum opening of the return air damper.";
  parameter Real retDamPhyPosMin(min=0, max=1, unit="1") = 0 "Physical or at the comissioning fixed minimum opening of the return air damper.";
  parameter Real outDamPhyPosMax(min=0, max=1, unit="1") = 1 "Physical or at the comissioning fixed maximum opening of the outdoor air damper.";
  parameter Real outDamPhyPosMin(min=0, max=1, unit="1") = 0 "Physical or at the comissioning fixed minimum opening of the outdoor air damper.";
  parameter Real yConSigMin=0 "Lower limit of controller output";
  parameter Real yConSigMax=1 "Upper limit of controller output";
  parameter Real sigFraOutDam(min=yConSigMin, max=yConSigMax, unit="1")=0.5
    "Fraction of the control loop signal below which the outdoor air damper limit gets modulated and above which the return air damper limit gets modulated";

  CDL.Interfaces.RealInput uVOut(quantity="VolumeFlow", unit="m3/s", displayUnit="m3/h")
    "Measured outdoor airflow rate. Sensor output. Location: after the economizer damper intake. [fixme: is quantity ok?]"
    annotation (Placement(transformation(extent={{-280,180},{-240,220}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput uVOutMinSet(quantity="VolumeFlow", unit="m3/s", displayUnit="m3/h")
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-280,240},{-240,280}}),
        iconTransformation(extent={{-120,40},{-100,60}})));
  //fixme add units, should be percentage
  CDL.Continuous.LimPID minOutAirDamPosController(
    Ti=0.9,
    Td=0.1,
    Nd=1,
    k=0.02,
    yMax=yConSigMax,
    yMin=yConSigMin,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI)
    "Contoller that outputs a signal based on the error between the measured outdoor airflow and the minimum outdoor airflow requirement."
    annotation (Placement(transformation(extent={{-180,220},{-160,240}})));

  CDL.Continuous.Constant sigFraForOutDam(k=sigFraOutDam)
    "Fraction of the control signal above which the minimum outdoor damper position is and stays equal to a fully open position and the maximum return air damper limit modulates downwards."
    annotation (Placement(transformation(extent={{40,240},{60,260}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-280,-160},{-240,-120}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.RealOutput yOutDamPosMin(min=0, max=1, unit="1")
    "Minimum economizer damper position limit." annotation (Placement(
        transformation(extent={{240,70},{260,90}}),  iconTransformation(extent={{100,10},
            {120,30}})));
  CDL.Interfaces.RealOutput yRetDamPosMax(min=0, max=1, unit="1")
    "Maximum return air damper position limit" annotation (Placement(
        transformation(extent={{240,-50},{260,-30}}),
                                                    iconTransformation(extent={{100,-70},
            {120,-50}})));
  CDL.Continuous.Line minOutDam(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  CDL.Continuous.Line minRetDam(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
  CDL.Logical.And3 nand
    "If any of the input signals is not true, the block outputs true, damper modulation gets supressed and dampers are kept in their initial positions."
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  CDL.Logical.Switch RetDamPosMin
    "Set to retDamPhyPosMax if the supply fan is off, the AHU mode is disabled, or the freeze protection got activated to prevent any modulation"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  CDL.Logical.Switch outDamPosMax
    "Set to outDamPhyPosMin if the supply fan is off, the AHU mode is disabled, or the freeze protection got activated to prevent any modulation"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  CDL.Continuous.Constant minSignalLimit(k=0)
    "Identical to controller parameter - Lower limit of output. fixme - set equal to yMin from PID"
    annotation (Placement(transformation(extent={{-20,240},{0,260}})));
  CDL.Continuous.Constant maxSignalLimit(k=1)
    "Identical to controller parameter - Upper limit of output. foxme - set equal to param yMax from PID"
    annotation (Placement(transformation(extent={{100,240},{120,260}})));
  CDL.Interfaces.RealOutput yRetDamPosMin(min=0, max=1, unit="1")
    "Maximum return air damper position limit" annotation (Placement(
        transformation(extent={{240,-10},{260,10}}),iconTransformation(extent={{100,-30},
            {120,-10}})));
  CDL.Interfaces.RealOutput yOutDamPosMax(min=0, max=1, unit="1")
    "Minimum economizer damper position limit." annotation (Placement(
        transformation(extent={{240,30},{260,50}}),  iconTransformation(extent={{100,50},
            {120,70}})));

  CDL.Interfaces.IntegerInput uFreProSta( quantity="Status")= 0
    "Freeze Protection Status signal, it can be an integer 0 - 3 [fixme check quantity]"
    annotation (Placement(transformation(extent={{-280,-270},{-240,-230}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-220,-260},{-200,-240}})));
  CDL.Logical.LessEqualThreshold ZoneStateStatusHeating(threshold=1)
    "If true, the heating signal is 0. fixme: use ZoneState type instead."
    annotation (Placement(transformation(extent={{-180,-260},{-160,-240}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-110,-140},{-90,-120}})));
  CDL.Logical.Equal              ZoneStateStatusHeating1
    "If true, the heating signal is 0. fixme: use ZoneState type instead."
    annotation (Placement(transformation(extent={{-180,-190},{-160,-170}})));
  CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{-220,-190},{-200,-170}})));
  CDL.Interfaces.IntegerInput uAHUModSta(quantity="Status")=0
    "AHU System Mode status signal, [fixme: see documentation for more details]"
    annotation (Placement(transformation(extent={{-280,-200},{-240,-160}}),
        iconTransformation(extent={{-120,-60},{-100,-40}})));
  CDL.Continuous.Constant con(k=1) "AHU Mode Status is \"Occupied\""
    annotation (Placement(transformation(extent={{-220,-220},{-200,-200}})));
  CDL.Continuous.Constant outDamPhyPosMinSig(k=outDamPhyPosMin)
    "Physical or at the comissioning fixed minimum position of the outdoor damper. This is the initial position of the economizer damper."
    annotation (Placement(transformation(extent={{-220,70},{-200,90}})));
  CDL.Continuous.Constant outDamPhyPosMaxSig(k=outDamPhyPosMax)
    "Physical or at the comissioning fixed maximum open position of the outdoor air damper."
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));
  CDL.Continuous.Constant retDamPhyPosMinSig(k=retDamPhyPosMin)
    "Physical or at the comissioning fixed minimum opening of the return air damper. Assuming 0 airflow through the damper at this position."
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));
  CDL.Continuous.Constant retDamPhyPosMaxSig(final k=retDamPhyPosMax)
    "Physical or at the comissioning fixed maximum opening of the return air damper. This is the initial condition of the return air damper."
    annotation (Placement(transformation(extent={{-220,-50},{-200,-30}})));
equation
  connect(uVOut,minOutAirDamPosController. u_m)
    annotation (Line(points={{-260,200},{-170,200},{-170,218}},
                                                           color={0,0,127}));
  connect(minRetDam.y, yRetDamPosMax) annotation (Line(points={{161,110},{180,110},
          {180,20},{220,20},{220,-40},{250,-40}},
                               color={0,0,127}));
  connect(RetDamPosMin.y, minRetDam.f2) annotation (Line(points={{61,0},{61,2},{
          61,0},{100,0},{100,102},{138,102}},
                                    color={0,0,127}));
  connect(sigFraForOutDam.y, minRetDam.x1) annotation (Line(points={{61,250},{90,
          250},{90,118},{138,118}},
                              color={0,0,127}));
  connect(maxSignalLimit.y, minRetDam.x2) annotation (Line(points={{121,250},{130,
          250},{130,106},{138,106}},
                                  color={0,0,127}));
  connect(minOutAirDamPosController.y, minRetDam.u) annotation (Line(points={{-159,
          230},{-90,230},{-90,110},{138,110}},
                                            color={0,0,127}));
  connect(outDamPosMax.y, minOutDam.f2) annotation (Line(points={{61,40},{112,40},
          {112,162},{138,162}},       color={0,0,127}));
  connect(minSignalLimit.y, minOutDam.x1) annotation (Line(points={{1,250},{10,250},
          {10,178},{138,178}},      color={0,0,127}));
  connect(sigFraForOutDam.y, minOutDam.x2) annotation (Line(points={{61,250},{70,
          250},{70,166},{138,166}},
                                color={0,0,127}));
  connect(minOutAirDamPosController.y, minOutDam.u) annotation (Line(points={{-159,
          230},{-60,230},{-60,170},{138,170}},color={0,0,127}));
  connect(outDamPosMax.y, yOutDamPosMax) annotation (Line(points={{61,40},{140,40},
          {250,40}},                color={0,0,127}));
  connect(minOutDam.y, yOutDamPosMin) annotation (Line(points={{161,170},{200,170},
          {200,80},{250,80}}, color={0,0,127}));
  connect(uVOutMinSet, minOutAirDamPosController.u_s) annotation (Line(points={{-260,
          260},{-200,260},{-200,230},{-182,230}},       color={0,0,127}));
  connect(intToRea.y, ZoneStateStatusHeating.u) annotation (Line(points={{-199,-250},
          {-199,-250},{-182,-250}},       color={0,0,127}));
  connect(uSupFan, nand.u1) annotation (Line(points={{-260,-140},{-172,-140},{-172,
          -122},{-142,-122}},
                          color={255,0,255}));
  connect(ZoneStateStatusHeating.y, nand.u3) annotation (Line(points={{-159,-250},
          {-152,-250},{-152,-138},{-142,-138}},   color={255,0,255}));
  connect(nand.y, not1.u)
    annotation (Line(points={{-119,-130},{-112,-130}},
                                                   color={255,0,255}));
  connect(not1.y, RetDamPosMin.u2) annotation (Line(points={{-89,-130},{0,-130},
          {0,0},{38,0}},        color={255,0,255}));
  connect(not1.y, outDamPosMax.u2) annotation (Line(points={{-89,-130},{-90,-130},
          {0,-130},{0,40},{38,40}},
                                color={255,0,255}));
  connect(uAHUModSta, intToRea1.u) annotation (Line(points={{-260,-180},{-260,-180},
          {-222,-180}},     color={255,127,0}));
  connect(ZoneStateStatusHeating1.y, nand.u2) annotation (Line(points={{-159,-180},
          {-152,-180},{-152,-150},{-152,-130},{-142,-130}},
                                                          color={255,0,255}));
  connect(intToRea1.y, ZoneStateStatusHeating1.u1)
    annotation (Line(points={{-199,-180},{-182,-180}},
                                                     color={0,0,127}));
  connect(ZoneStateStatusHeating1.u2, con.y) annotation (Line(points={{-182,-188},
          {-188,-188},{-188,-210},{-199,-210}},
                                             color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, RetDamPosMin.u1) annotation (Line(points={{-199,
          -40},{-48,-40},{-48,8},{38,8}}, color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, minRetDam.f1) annotation (Line(points={{-199,-40},
          {-134,-40},{-134,114},{-68,114},{138,114}},
                                         color={0,0,127}));
  connect(retDamPhyPosMinSig.y, RetDamPosMin.u3) annotation (Line(points={{-199,0},
          {-90,0},{-90,-8},{38,-8}},        color={0,0,127}));
  connect(retDamPhyPosMinSig.y, yRetDamPosMin) annotation (Line(points={{-199,0},
          {-148,0},{-148,-20},{148,-20},{200,-20},{200,0},{250,0}},
                                     color={0,0,127}));
  connect(outDamPhyPosMaxSig.y, outDamPosMax.u3) annotation (Line(points={{-199,40},
          {-120,40},{-120,32},{38,32}},         color={0,0,127}));
  connect(outDamPhyPosMinSig.y, outDamPosMax.u1) annotation (Line(points={{-199,80},
          {-20,80},{-20,48},{38,48}},           color={0,0,127}));
  connect(outDamPhyPosMinSig.y, minOutDam.f1) annotation (Line(points={{-199,80},
          {-48,80},{-48,174},{138,174}},color={0,0,127}));
  connect(intToRea.u, uFreProSta)
    annotation (Line(points={{-222,-250},{-260,-250}}, color={255,127,0}));
  annotation (
    defaultComponentName = "ecoEnaDis",
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,58},{82,42}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uVOutMinSet"),
        Text(
          extent={{80,56},{316,38}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPosMax"),
        Text(
          extent={{-96,86},{92,74}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uVOut"),
        Text(
          extent={{78,94},{314,76}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPosMin"),
        Text(
          extent={{-96,-40},{98,-54}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uAHUModSta"),
        Text(
          extent={{-96,10},{88,-6}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uSupFan"),
        Text(
          extent={{80,-28},{316,-46}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPosMax"),
        Text(
          extent={{78,12},{314,-6}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPosMin"),
        Line(
          points={{-62,-58},{62,-58},{0,64},{-62,-58}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-88,134},{88,104}},
          lineColor={85,0,255},
          textString="DamperLimits"),
        Text(
          extent={{-96,-70},{86,-86}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uFreProSta")}),
    Diagram(coordinateSystem(                           extent={{-240,-280},{240,
            280}},
        initialScale=0.1), graphics={Rectangle(extent={{-240,-110},{240,-280}},
            lineColor={28,108,200}), Text(
          extent={{80,-206},{224,-288}},
          lineColor={28,108,200},
          fontSize=12,
          textString="Conditions to enable the control loop. 
If any is false, the output damper limits 
are physical minimum and maximum for
outdoor and return air dampers, respectively. "),
        Rectangle(extent={{-240,280},{-100,160}}, lineColor={28,108,200}),
                                     Text(
          extent={{-164,192},{-104,166}},
          lineColor={28,108,200},
          fontSize=12,
          textString="Outdoor airflow 
control loop."),                     Rectangle(extent={{-100,280},{240,-110}},
            lineColor={28,108,200}), Text(
          extent={{96,-48},{240,-130}},
          lineColor={28,108,200},
          fontSize=12,
          textString="Damper position limit 
calculation and assignments."),      Rectangle(extent={{-240,160},{-100,-110}},
            lineColor={28,108,200}), Text(
          extent={{-240,-48},{-96,-130}},
          lineColor={28,108,200},
          fontSize=12,
          textString="Physical damper position 
limits set at commissioning."),      Text(
          extent={{22,84},{70,48}},
          lineColor={28,108,200},
          fontSize=8,
          textString="Switches that deactivate 
the limit modulation.")}),
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
