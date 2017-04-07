within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model EconModulation "Based on measured and requred minimum outdoor airflow the controller resets 
  the min limit of the economizer damper and the max limit of the return air 
  damper in order to maintain the minimum required outdoor airflow."
  // fixme: add keep previous pos if VOut>VOutSet AND EcoDamPos>EcoDamPosMin
  // to avoid non-realistic setting of say econ min limit to 0 because the
  // measured flow is higher while the economizer is open wider (enabled or
  // modulating above the min)

  CDL.Interfaces.RealInput TCoo
    "Measured supply air temperature. Sensor output."
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput TCooSet
    "Output of a ***TSupSet sequence. The economizer modulates to the TCoo rather than to the THea. If Zone State is Cooling, economizer modulates to a temperture slightly lower than the TCoo."
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  //fixme add units, should be percentage
  CDL.Continuous.LimPID DamPosController(
    yMax=1,
    yMin=0,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PID,

    Ti=0.9,
    Td=0.1,
    Nd=1,
    k=0.02)
    "Contoller that outputs a signal based on the error between the measured SAT and SAT setpoint [SAT setpoint is the cooling setpoint, in case of cooling reduced in 2F per G36]"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  CDL.Interfaces.RealOutput yEcoDamPosMin
    "Minimum economizer damper position limit." annotation (Placement(
        transformation(extent={{100,-30},{120,-10}}),iconTransformation(extent={{100,-30},
            {120,-10}})));
  CDL.Interfaces.RealOutput yRetDamPosMax
    "Maximum return air damper position limit" annotation (Placement(
        transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{100,-10},
            {120,10}})));
  CDL.Continuous.Line EcoDamPos(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Continuous.Line RetDamPos(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  CDL.Continuous.Constant minSignalLimit(k=0)
    "Identical to controller parameter - Lower limit of output. fixme - set equal to yMin from PID"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  CDL.Continuous.Constant maxSignalLimit(k=1)
    "Identical to controller parameter - Upper limit of output. foxme - set equal to param yMax from PID"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  CDL.Interfaces.RealInput uHea
    "Heating control signal. fixme: we may instead use the Zone State, pg. 33, which takes 3 string values: Cooling, Heating, Deadband. This would merge the uCool and uHeat input."
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.RealInput uCoo
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealInput uEcoDamPosMin
    "Minimum economizer damper position limit as returned by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-140,-130},{-100,-90}})));
  CDL.Interfaces.RealInput uEcoDamPosMax
    "Maximum economizer damper position limit as returned by the EconEnableDisable sequence. If the economizer is disabled, this value equals uEcoDamPosMin"
    annotation (Placement(transformation(extent={{-140,-160},{-100,-120}})));
  CDL.Interfaces.RealInput uRetDamPosMin
    "fixme - check out: Minimum return air damper position limit as returned by the EconDamPosLimits sequence. This is a fixed value and the mentioned sequence assignes the value, which should in principle always be 0, but I'd like to avoid setting the value in multiple places."
    annotation (Placement(transformation(extent={{-140,-190},{-100,-150}})));
  CDL.Interfaces.RealInput uRetDamPosMax
    "Minimum economizer damper position limit as returned by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-140,-220},{-100,-180}})));
  CDL.Logical.Switch DisableRetDamModulation
    "If the heating is on or the fan is off, keep return air damper at it's maximum limit set by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
  CDL.Logical.GreaterThreshold coolingZoneState
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  CDL.Logical.Switch EnableEcoDamModulation
    "If the heating is on or the fan is off, keep the economizer damper at its minimum limit set by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  CDL.Logical.LessEqualThreshold ZoneStateStatusCooling(threshold=0)
    "Cooling is off. fixme: should we add an \"equal\" block that takes a parameter rather than an input, since we have such blocks for both less and greater than"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  CDL.Logical.And and1
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  CDL.Continuous.Add add(k1=1, k2=-2)
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  CDL.Conversions.BooleanToInteger booleanToInteger1
    annotation (Placement(transformation(extent={{-80,12},{-60,32}})));
  CDL.Conversions.IntegerToReal integerToReal
    annotation (Placement(transformation(extent={{-80,34},{-60,54}})));
equation
  connect(TCoo, DamPosController.u_m) annotation (Line(points={{-120,40},{-50,
          40},{-50,-30},{-10,-30},{-10,-22}}, color={0,0,127}));
  connect(EcoDamPos.y, yEcoDamPosMin) annotation (Line(points={{81,10},{90,10},
          {90,-20},{110,-20}}, color={0,0,127}));
  connect(RetDamPos.y, yRetDamPosMax) annotation (Line(points={{81,50},{90,50},
          {90,0},{110,0}}, color={0,0,127}));
  connect(maxSignalLimit.y, RetDamPos.x2) annotation (Line(points={{1,30},{30,
          30},{30,46},{58,46}}, color={0,0,127}));
  connect(DamPosController.y, RetDamPos.u) annotation (Line(points={{1,-10},{20,
          -10},{20,50},{58,50}}, color={0,0,127}));
  connect(minSignalLimit.y, EcoDamPos.x1) annotation (Line(points={{1,70},{40,
          70},{40,18},{58,18}}, color={0,0,127}));
  connect(DamPosController.y, EcoDamPos.u) annotation (Line(points={{1,-10},{30,
          -10},{30,10},{58,10}}, color={0,0,127}));
  connect(coolingZoneState.u, uCoo)
    annotation (Line(points={{-82,0},{-82,0},{-120,0}}, color={0,0,127}));
  connect(and1.u2, uSupFan) annotation (Line(points={{-82,-78},{-90,-78},{-90,
          -70},{-120,-70}}, color={255,0,255}));
  connect(uHea, ZoneStateStatusCooling.u) annotation (Line(points={{-120,-40},{
          -101,-40},{-82,-40}}, color={0,0,127}));
  connect(ZoneStateStatusCooling.y, and1.u1) annotation (Line(points={{-59,-40},
          {-50,-40},{-50,-20},{-90,-20},{-90,-52},{-90,-70},{-82,-70}}, color={
          255,0,255}));
  connect(and1.y, EnableEcoDamModulation.u2) annotation (Line(points={{-59,-70},
          {-50,-70},{-50,-140},{-42,-140}}, color={255,0,255}));
  connect(and1.y, DisableRetDamModulation.u2) annotation (Line(points={{-59,-70},
          {-50,-70},{-50,-170},{-42,-170}}, color={255,0,255}));
  connect(uEcoDamPosMax, EnableEcoDamModulation.u1) annotation (Line(points={{
          -120,-140},{-80,-140},{-80,-132},{-42,-132}}, color={0,0,127}));
  connect(uEcoDamPosMin, EnableEcoDamModulation.u3) annotation (Line(points={{
          -120,-110},{-70,-110},{-70,-148},{-42,-148}}, color={0,0,127}));
  connect(uRetDamPosMin, DisableRetDamModulation.u1) annotation (Line(points={{
          -120,-170},{-80,-170},{-80,-162},{-42,-162}}, color={0,0,127}));
  connect(uRetDamPosMax, DisableRetDamModulation.u3) annotation (Line(points={{
          -120,-200},{-80,-200},{-80,-178},{-42,-178}}, color={0,0,127}));
  connect(minSignalLimit.y, RetDamPos.x1) annotation (Line(points={{1,70},{30,
          70},{30,58},{58,58}}, color={0,0,127}));
  connect(uRetDamPosMax, RetDamPos.f1) annotation (Line(points={{-120,-200},{50,
          -200},{50,54},{58,54}}, color={0,0,127}));
  connect(DisableRetDamModulation.y, RetDamPos.f2) annotation (Line(points={{
          -19,-170},{10,-170},{10,42},{58,42}}, color={0,0,127}));
  connect(uEcoDamPosMin, EcoDamPos.f1) annotation (Line(points={{-120,-110},{
          -32,-110},{-32,14},{58,14}}, color={0,0,127}));
  connect(EnableEcoDamModulation.y, EcoDamPos.f2) annotation (Line(points={{-19,
          -140},{40,-140},{40,2},{58,2}}, color={0,0,127}));
  connect(maxSignalLimit.y, EcoDamPos.x2)
    annotation (Line(points={{1,30},{30,30},{30,6},{58,6}}, color={0,0,127}));
  connect(TCooSet, add.u1) annotation (Line(points={{-120,80},{-92,80},{-92,86},
          {-82,86}}, color={0,0,127}));
  connect(coolingZoneState.y, booleanToInteger1.u) annotation (Line(points={{
          -59,0},{-70,0},{-70,22},{-82,22}}, color={255,0,255}));
  connect(booleanToInteger1.y, integerToReal.u) annotation (Line(points={{-59,
          22},{-70,22},{-70,44},{-82,44}}, color={255,127,0}));
  connect(integerToReal.y, add.u2) annotation (Line(points={{-59,44},{-56,44},{
          -56,62},{-56,62},{-90,62},{-90,74},{-82,74}}, color={0,0,127}));
  connect(add.y, DamPosController.u_s) annotation (Line(points={{-59,80},{-40,
          80},{-40,-10},{-22,-10}}, color={0,0,127}));
  annotation (
    defaultComponentName = "ecoMod",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,100},{-26,64}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uVOutMin"),
        Text(
          extent={{112,70},{182,34}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPosMax"),
        Text(
          extent={{-96,62},{-26,26}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uVOut"),
        Text(
          extent={{112,6},{182,-30}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPosMin"),
        Text(
          extent={{-96,-20},{-26,-56}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uAHUMod"),
        Text(
          extent={{-96,22},{-26,-14}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uSupFan"),
        Line(points={{20,58}}, color={28,108,200}),
        Line(points={{-74,-64},{-28,-64},{34,62},{78,62}}, color={28,108,200}),

        Line(
          points={{-54,62},{-10,62},{60,-60},{82,-60}},
          color={28,108,200},
          pattern=LinePattern.Dash)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-240},{
            100,100}})),
    Documentation(info="<html>      
    <p>
    fixme status: initiate inputs and outputs
This atomic sequence sets the economizer and
return air damper position. The implementation is according
to ASHRAE Guidline 36 (G36), PART5.N.2.c and functionaly it represents the 
final sequence in the composite economizer control sequence.
</p>   
<p>
The controller is enabled indirectly through the output of the the EconEnableDisable 
sequence, which defines the maximum economizer damper position. Thus, strictly 
speaking, the modulation sequence remains active, but if the economizer gets
disabled, the range of economizer damper modulation equals zero.
fixme: return air damper may be modulated even if econ disable, according to
this control loop. Check if that is desired. Last time I reflected on this
it seemed it would not pose functional dificulties.
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconModulationStateMachineChart.png\"/>
</p>
<p>
fixme: interpret corresponding text from G36 as implemented here.
</p>
<p>
Control charts below show the input-output structure and an economizer damper 
modulation sequence assuming a well tuned controller. Control diagram:
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconModulationLimitsControlDiagram.png\"/>
</p>
<p>
Expected control performance, upon tuning:
<br>
</br>
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconModulationLimitsControlChart.png\"/>
</p>
<p>
bla
</p>

</html>", revisions="<html>
<ul>
<li>
April 04, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconModulation;
