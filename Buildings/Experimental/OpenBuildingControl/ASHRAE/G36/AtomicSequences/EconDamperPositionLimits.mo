within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model EconDamperPositionLimits "Based on measured and requred minimum outdoor airflow the controller resets 
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
    annotation (Placement(transformation(extent={{-220,60},{-180,100}})));
  CDL.Interfaces.RealInput uVOutMinSet
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
        iconTransformation(extent={{-220,100},{-180,140}})));
  CDL.Continuous.Constant retDamPhyPosMinSig(k=retDamPhyPosMin)
    "Physical or at the comissioning fixed minimum opening of the return air damper. Assuming 0 airflow through the damper at this position. fixme: this maybe needs to be an input."
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  //fixme add units, should be percentage
  CDL.Continuous.Constant outDamPhyPosMinSig(k=outDamPhyPosMin)
    "Physical or at the comissioning fixed minimum position of the economizer damper - economizer damper closed. Assuming VOut = 0 at this condition. This is the initial position of the economizer damper. fixme: It should always be 0 (pp), should we define this as final?"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  CDL.Continuous.LimPID minOutAirDamPosController(
    Ti=0.9,
    Td=0.1,
    Nd=1,
    k=0.02,
    yMax=yConSigMax,
    yMin=yConSigMin,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI)
    "Contoller that outputs a signal based on the error between the measured outdoor airflow and the minimum outdoor airflow requirement."
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));

  CDL.Continuous.Constant sigFraForOutDam(k=sigFraOutDam)
    "Fraction of the control signal for which the economizer damper is and stays fully open and above which the return air damper modulates downwards."
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}})));
  CDL.Interfaces.BooleanInput uAHUMod
    "AHU Mode, fixme: see pg. 103 in G36 for the full list of modes, here we use true = \"occupied\""
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}})));
  CDL.Interfaces.RealOutput yOutDamPosMin
    "Minimum economizer damper position limit." annotation (Placement(
        transformation(extent={{180,10},{200,30}}),  iconTransformation(extent={{180,10},
            {200,30}})));
  CDL.Interfaces.RealOutput yRetDamPosMax
    "Maximum return air damper position limit" annotation (Placement(
        transformation(extent={{180,-50},{200,-30}}),
                                                    iconTransformation(extent={{180,-50},
            {200,-30}})));
  CDL.Continuous.Constant retDamPhyPosMaxSig(final k=retDamPhyPosMax)
    "Physical or at the comissioning fixed maximum opening of the return air damper. This is the initial condition of the return air damper."
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  CDL.Continuous.Constant outDamPhyPosMaxSig(k=outDamPhyPosMax)
    "Physical or at the comissioning fixed maximum position of the economizer damper - economizer damper fully open. fixme: this maybe needs to be an input."
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  CDL.Continuous.Line minOutDam(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{102,0},{122,20}})));
  CDL.Continuous.Line minRetDam(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{102,40},{122,60}})));
  CDL.Logical.Nand nand
    "If any of the input signals is not true, the block outputs true, damper modulation gets supressed and dampers are kept in their initial positions."
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Logical.Switch RetDamPosMin
    "Set to RetDamPhyPosMax if the supply fan is off or the AHU mode is disabled to prevent any modulation"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  CDL.Logical.Switch outDamPosMax
    "Set to EcoDamPhyPosMin if the supply fan is off or the AHU mode is disabled to prevent any modulation"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  CDL.Continuous.Constant minSignalLimit(k=0)
    "Identical to controller parameter - Lower limit of output. fixme - set equal to yMin from PID"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  CDL.Continuous.Constant maxSignalLimit(k=1)
    "Identical to controller parameter - Upper limit of output. foxme - set equal to param yMax from PID"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  CDL.Interfaces.RealOutput yRetDamPosMin
    "Maximum return air damper position limit" annotation (Placement(
        transformation(extent={{180,-30},{200,-10}}),
                                                    iconTransformation(extent={{180,-30},
            {200,-10}})));
  CDL.Interfaces.RealOutput yOutDamPosMax
    "Minimum economizer damper position limit." annotation (Placement(
        transformation(extent={{180,-10},{200,10}}), iconTransformation(extent=
            {{100,0},{120,20}})));

equation
  connect(uVOut,minOutAirDamPosController. u_m)
    annotation (Line(points={{-200,80},{-90,80},{-90,98}}, color={0,0,127}));
  connect(uSupFan, nand.u1) annotation (Line(points={{-200,40},{-100,40},{-100,
          30},{-82,30}},
                      color={255,0,255}));
  connect(uAHUMod, nand.u2) annotation (Line(points={{-200,0},{-100,0},{-100,22},
          {-82,22}},       color={255,0,255}));
  connect(nand.y, outDamPosMax.u2) annotation (Line(points={{-59,30},{-50,30},{
          -50,-110},{-22,-110}},  color={255,0,255}));
  connect(nand.y, RetDamPosMin.u2) annotation (Line(points={{-59,30},{-50,30},{
          -50,-70},{-22,-70}},    color={255,0,255}));
  connect(outDamPhyPosMaxSig.y, outDamPosMax.u3) annotation (Line(points={{-119,
          -100},{-50,-100},{-50,-118},{-22,-118}}, color={0,0,127}));
  connect(outDamPhyPosMinSig.y, outDamPosMax.u1) annotation (Line(points={{-119,
          -140},{-52,-140},{-52,-102},{-22,-102}}, color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, RetDamPosMin.u1) annotation (Line(points={{-119,
          -20},{-52,-20},{-52,-62},{-22,-62}},   color={0,0,127}));
  connect(retDamPhyPosMinSig.y, RetDamPosMin.u3) annotation (Line(points={{-119,
          -60},{-56,-60},{-56,-78},{-22,-78}},     color={0,0,127}));
  connect(minRetDam.y, yRetDamPosMax) annotation (Line(points={{123,50},{160,50},
          {160,-40},{190,-40}},color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, minRetDam.f1) annotation (Line(points={{-119,
          -20},{12,-20},{12,54},{100,54}},
                                       color={0,0,127}));
  connect(RetDamPosMin.y, minRetDam.f2) annotation (Line(points={{1,-70},{20,
          -70},{20,42},{100,42}},   color={0,0,127}));
  connect(sigFraForOutDam.y, minRetDam.x1) annotation (Line(points={{1,130},{42,
          130},{42,58},{100,58}},
                              color={0,0,127}));
  connect(maxSignalLimit.y, minRetDam.x2) annotation (Line(points={{1,70},{32,
          70},{32,46},{100,46}},  color={0,0,127}));
  connect(minOutAirDamPosController.y, minRetDam.u) annotation (Line(points={{-79,110},
          {-28,110},{-28,50},{100,50}},     color={0,0,127}));
  connect(outDamPosMax.y, minOutDam.f2) annotation (Line(points={{1,-110},{46,
          -110},{46,2},{100,2}},      color={0,0,127}));
  connect(outDamPhyPosMinSig.y, minOutDam.f1) annotation (Line(points={{-119,
          -140},{32,-140},{32,14},{100,14}},
                                          color={0,0,127}));
  connect(minSignalLimit.y, minOutDam.x1) annotation (Line(points={{1,100},{36,
          100},{36,18},{100,18}},   color={0,0,127}));
  connect(sigFraForOutDam.y, minOutDam.x2) annotation (Line(points={{1,130},{18,
          130},{18,6},{100,6}}, color={0,0,127}));
  connect(minOutAirDamPosController.y, minOutDam.u) annotation (Line(points={{-79,110},
          {-38,110},{-38,10},{100,10}},       color={0,0,127}));
  connect(retDamPhyPosMinSig.y, yRetDamPosMin) annotation (Line(points={{-119,
          -60},{-56,-60},{-56,-144},{150,-144},{150,-20},{190,-20}},
                                                               color={0,0,127}));
  connect(outDamPosMax.y, yOutDamPosMax) annotation (Line(points={{1,-110},{140,
          -110},{140,0},{190,0}},   color={0,0,127}));
  connect(minOutDam.y, yOutDamPosMin) annotation (Line(points={{123,10},{150,10},
          {150,20},{190,20}}, color={0,0,127}));
  connect(uVOutMinSet, minOutAirDamPosController.u_s) annotation (Line(points={
          {-200,120},{-152,120},{-152,110},{-102,110}}, color={0,0,127}));
  annotation (
    defaultComponentName = "ecoEnaDis",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(
          points={{2,66},{-64,-62},{66,-62},{2,66}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-96,100},{-26,64}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uVOutMin"),
        Text(
          extent={{118,42},{188,6}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPosMax"),
        Text(
          extent={{-96,62},{-26,26}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uVOut"),
        Text(
          extent={{118,64},{188,28}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPosMin"),
        Text(
          extent={{-96,-20},{-26,-56}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uAHUMod"),
        Text(
          extent={{-96,22},{-26,-14}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uSupFan"),
        Text(
          extent={{118,-10},{188,-46}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPosMax"),
        Text(
          extent={{118,12},{188,-24}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPosMin")}),
    Diagram(coordinateSystem(                           extent={{-180,-180},{
            180,180}},
        initialScale=0.1)),
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
end EconDamperPositionLimits;
