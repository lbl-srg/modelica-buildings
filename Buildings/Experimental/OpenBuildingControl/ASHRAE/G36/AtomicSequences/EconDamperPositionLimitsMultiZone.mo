within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconDamperPositionLimitsMultiZone "Based on measured and requred minimum outdoor airflow the controller resets 
  the min limit of the economizer damper and the max limit of the return air 
  damper in order to maintain the minimum required outdoor airflow."
  // fixme: add keep previous pos if VOut>VOutSet AND outDamPos>outDamPosMin
  // to avoid non-realistic setting of say econ min limit to 0 because the
  // measured flow is higher while the economizer is open wider (enabled or
  // modulating above the min)
  // fixme: potentially a better name since used in communication with Brent: OA control loop

  parameter Real retDamPhyPosMax(min=0, max=1, unit="1")= 1 "Physical or at the comissioning fixed maximum opening of the return air damper.";
  parameter Real retDamPhyPosMin(min=0, max=1, unit="1")=0 "Physical or at the comissioning fixed minimum opening of the return air damper.";
  parameter Real outDamPhyPosMax(min=0, max=1, unit="1")=1 "Physical or at the comissioning fixed maximum opening of the outdoor air damper.";
  parameter Real outDamPhyPosMin(min=0, max=1, unit="1")=0 "Physical or at the comissioning fixed minimum opening of the outdoor air damper.";
  parameter Real yConSigMin=0 "Lower limit of controller output";
  parameter Real yConSigMax=1 "Upper limit of controller output";
  parameter Real sigFraOutDam(min=yConSigMin, max=yConSigMax, unit="1")=0.5
    "Fraction of the control loop signal below which the outdoor air damper limit gets modulated and above which the return air damper limit gets modulated";

  CDL.Interfaces.RealInput uVOut
    "Measured outdoor airflow rate. Sensor output. Location: after the economizer damper intake."
    annotation (Placement(transformation(extent={{-280,160},{-240,200}}),
        iconTransformation(extent={{-280,160},{-240,200}})));
  CDL.Interfaces.RealInput uVOutMinSet
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-280,220},{-240,260}}),
        iconTransformation(extent={{-280,220},{-240,260}})));
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
    annotation (Placement(transformation(extent={{-140,200},{-120,220}})));

  CDL.Continuous.Constant sigFraForOutDam(k=sigFraOutDam)
    "Fraction of the control signal above which the minimum outdoor damper position is and stays equal to a fully open position and the maximum return air damper limit modulates downwards."
    annotation (Placement(transformation(extent={{-20,220},{0,240}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-280,-140},{-240,-100}}),
        iconTransformation(extent={{-280,-140},{-240,-100}})));
  CDL.Interfaces.RealOutput yOutDamPosMin(min=0, max=1, unit="1")
    "Minimum economizer damper position limit." annotation (Placement(
        transformation(extent={{240,38},{260,58}}),  iconTransformation(extent={{240,38},
            {260,58}})));
  CDL.Interfaces.RealOutput yRetDamPosMax(min=0, max=1, unit="1")
    "Maximum return air damper position limit" annotation (Placement(
        transformation(extent={{240,-22},{260,-2}}),iconTransformation(extent={{240,-22},
            {260,-2}})));
  CDL.Continuous.Line minOutDam(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  CDL.Continuous.Line minRetDam(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{140,140},{160,160}})));
  CDL.Logical.And3 nand
    "If any of the input signals is not true, the block outputs true, damper modulation gets supressed and dampers are kept in their initial positions."
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  CDL.Logical.Switch RetDamPosMin
    "Set to RetDamPhyPosMax if the supply fan is off or the AHU mode is disabled to prevent any modulation"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Logical.Switch outDamPosMax
    "Set to EcoDamPhyPosMin if the supply fan is off or the AHU mode is disabled to prevent any modulation"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  CDL.Continuous.Constant minSignalLimit(k=0)
    "Identical to controller parameter - Lower limit of output. fixme - set equal to yMin from PID"
    annotation (Placement(transformation(extent={{-20,158},{0,178}})));
  CDL.Continuous.Constant maxSignalLimit(k=1)
    "Identical to controller parameter - Upper limit of output. foxme - set equal to param yMax from PID"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  CDL.Interfaces.RealOutput yRetDamPosMin(min=0, max=1, unit="1")
    "Maximum return air damper position limit" annotation (Placement(
        transformation(extent={{240,-2},{260,18}}), iconTransformation(extent={{180,-20},
            {200,0}})));
  CDL.Interfaces.RealOutput yOutDamPosMax(min=0, max=1, unit="1")
    "Minimum economizer damper position limit." annotation (Placement(
        transformation(extent={{240,18},{260,38}}),  iconTransformation(extent={{180,36},
            {200,56}})));

  CDL.Interfaces.IntegerInput uFreProSta( quantity="Status")= 0
    "Freeze Protection Status signal, it can be an integer 0 - 3 [fixme check quantity]"
    annotation (Placement(transformation(extent={{-280,-260},{-240,-220}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-220,-250},{-200,-230}})));
  CDL.Logical.LessEqualThreshold ZoneStateStatusHeating(threshold=1)
    "If true, the heating signal is 0. fixme: use ZoneState type instead."
    annotation (Placement(transformation(extent={{-180,-250},{-160,-230}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-110,-120},{-90,-100}})));
  CDL.Logical.Equal              ZoneStateStatusHeating1
    "If true, the heating signal is 0. fixme: use ZoneState type instead."
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{-220,-170},{-200,-150}})));
  CDL.Interfaces.IntegerInput uAHUModSta(quantity="Status")=0
    "AHU System Mode status signal, [fixme: see documentation for more details]"
    annotation (Placement(transformation(extent={{-280,-180},{-240,-140}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Continuous.Constant con(k=1)
    annotation (Placement(transformation(extent={{-220,-200},{-200,-180}})));
  CDL.Continuous.Constant outDamPhyPosMinSig(k=outDamPhyPosMin)
    "Physical or at the comissioning fixed minimum position of the outdoor damper. This is the initial position of the economizer damper."
    annotation (Placement(transformation(extent={{-220,-60},{-200,-40}})));
  CDL.Continuous.Constant outDamPhyPosMaxSig(k=outDamPhyPosMax)
    "Physical or at the comissioning fixed maximum open position of the outdoor air damper."
    annotation (Placement(transformation(extent={{-220,-20},{-200,0}})));
  CDL.Continuous.Constant retDamPhyPosMinSig(k=retDamPhyPosMin)
    "Physical or at the comissioning fixed minimum opening of the return air damper. Assuming 0 airflow through the damper at this position."
    annotation (Placement(transformation(extent={{-220,20},{-200,40}})));
  CDL.Continuous.Constant retDamPhyPosMaxSig(final k=retDamPhyPosMax)
    "Physical or at the comissioning fixed maximum opening of the return air damper. This is the initial condition of the return air damper."
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));
equation
  connect(uVOut,minOutAirDamPosController. u_m)
    annotation (Line(points={{-260,180},{-130,180},{-130,198}},
                                                           color={0,0,127}));
  connect(minRetDam.y, yRetDamPosMax) annotation (Line(points={{161,150},{180,150},
          {180,-12},{250,-12}},color={0,0,127}));
  connect(RetDamPosMin.y, minRetDam.f2) annotation (Line(points={{81,10},{20,10},
          {20,142},{138,142}},      color={0,0,127}));
  connect(sigFraForOutDam.y, minRetDam.x1) annotation (Line(points={{1,230},{40,
          230},{40,158},{138,158}},
                              color={0,0,127}));
  connect(maxSignalLimit.y, minRetDam.x2) annotation (Line(points={{1,110},{32,110},
          {32,146},{138,146}},    color={0,0,127}));
  connect(minOutAirDamPosController.y, minRetDam.u) annotation (Line(points={{-119,
          210},{138,210},{138,150}},        color={0,0,127}));
  connect(outDamPosMax.y, minOutDam.f2) annotation (Line(points={{81,-30},{46,-30},
          {46,82},{138,82}},          color={0,0,127}));
  connect(minSignalLimit.y, minOutDam.x1) annotation (Line(points={{1,168},{36,168},
          {36,98},{138,98}},        color={0,0,127}));
  connect(sigFraForOutDam.y, minOutDam.x2) annotation (Line(points={{1,230},{20,
          230},{20,86},{138,86}},
                                color={0,0,127}));
  connect(minOutAirDamPosController.y, minOutDam.u) annotation (Line(points={{-119,
          210},{-40,210},{-40,90},{138,90}},  color={0,0,127}));
  connect(outDamPosMax.y, yOutDamPosMax) annotation (Line(points={{81,-30},{220,
          -30},{220,28},{250,28}},  color={0,0,127}));
  connect(minOutDam.y, yOutDamPosMin) annotation (Line(points={{161,90},{200,90},
          {200,48},{250,48}}, color={0,0,127}));
  connect(uVOutMinSet, minOutAirDamPosController.u_s) annotation (Line(points={{-260,
          240},{-180,240},{-180,210},{-142,210}},       color={0,0,127}));
  connect(intToRea.y, ZoneStateStatusHeating.u) annotation (Line(points={{-199,-240},
          {-199,-240},{-182,-240}},       color={0,0,127}));
  connect(uFreProSta, intToRea.u)
    annotation (Line(points={{-260,-240},{-222,-240}}, color={255,127,0}));
  connect(uSupFan, nand.u1) annotation (Line(points={{-260,-120},{-172,-120},{-172,
          -102},{-142,-102}},
                          color={255,0,255}));
  connect(ZoneStateStatusHeating.y, nand.u3) annotation (Line(points={{-159,-240},
          {-152,-240},{-152,-118},{-142,-118}},   color={255,0,255}));
  connect(nand.y, not1.u)
    annotation (Line(points={{-119,-110},{-112,-110}},
                                                   color={255,0,255}));
  connect(not1.y, RetDamPosMin.u2) annotation (Line(points={{-89,-110},{40,-110},
          {40,10},{58,10}},     color={255,0,255}));
  connect(not1.y, outDamPosMax.u2) annotation (Line(points={{-89,-110},{40,-110},
          {40,-30},{58,-30}},   color={255,0,255}));
  connect(uAHUModSta, intToRea1.u) annotation (Line(points={{-260,-160},{-260,-160},
          {-222,-160}},     color={255,127,0}));
  connect(ZoneStateStatusHeating1.y, nand.u2) annotation (Line(points={{-159,-160},
          {-152,-160},{-152,-130},{-152,-110},{-142,-110}},
                                                          color={255,0,255}));
  connect(intToRea1.y, ZoneStateStatusHeating1.u1)
    annotation (Line(points={{-199,-160},{-182,-160}},
                                                     color={0,0,127}));
  connect(ZoneStateStatusHeating1.u2, con.y) annotation (Line(points={{-182,-168},
          {-188,-168},{-188,-190},{-199,-190}},
                                             color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, RetDamPosMin.u1) annotation (Line(points={{-199,70},
          {-94,70},{-94,18},{58,18}},     color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, minRetDam.f1) annotation (Line(points={{-199,70},
          {-40,70},{-40,154},{138,154}}, color={0,0,127}));
  connect(retDamPhyPosMinSig.y, RetDamPosMin.u3) annotation (Line(points={{-199,
          30},{-93.5,30},{-93.5,2},{58,2}}, color={0,0,127}));
  connect(retDamPhyPosMinSig.y, yRetDamPosMin) annotation (Line(points={{-199,30},
          {200,30},{200,8},{250,8}}, color={0,0,127}));
  connect(outDamPhyPosMaxSig.y, outDamPosMax.u3) annotation (Line(points={{-199,
          -10},{-120,-10},{-120,-38},{58,-38}}, color={0,0,127}));
  connect(outDamPhyPosMinSig.y, outDamPosMax.u1) annotation (Line(points={{-199,
          -50},{-140,-50},{-140,-22},{58,-22}}, color={0,0,127}));
  connect(outDamPhyPosMinSig.y, minOutDam.f1) annotation (Line(points={{-199,-50},
          {-48,-50},{-48,94},{138,94}}, color={0,0,127}));
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
    Diagram(coordinateSystem(                           extent={{-240,-260},{240,
            260}},
        initialScale=0.1), graphics={Rectangle(extent={{-240,-90},{240,-260}},
            lineColor={28,108,200}), Text(
          extent={{80,-186},{224,-268}},
          lineColor={28,108,200},
          fontSize=12,
          textString="Conditions to enable the control loop. 
If any is false, the output damper limits 
are physical minimum and maximum for
outdoor and return air dampers, respectively. ")}),
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
