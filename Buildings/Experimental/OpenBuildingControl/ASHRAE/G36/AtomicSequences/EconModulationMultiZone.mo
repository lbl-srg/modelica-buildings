within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model EconModulationMultiZone "Based on supply air temperature (SAT) setpoint and measured 
  supply air temperature, the controller resets the economizer and return air
  damper positions. Damper position limits are inputs to this model. To 
  prevent modulation, provide input signals that set max and min position
  limits to the same value."

  parameter Real minLimRetDam(min=0, max=1, unit="1") = 0.5
  "Intermediate control paramter between controller Upper limit of output and Lower limit of output: for return air damper";
  parameter Real maxLimOutDam(min=0, max=1, unit="1") = 0.5
  "Intermediate control paramter between controller Upper limit of output and Lower limit of output: for outdoor air damper";

  CDL.Interfaces.RealInput TSup
    "Measured supply air temperature. Sensor output."
    annotation (Placement(transformation(extent={{-160,36},{-120,76}}),
        iconTransformation(extent={{-138,58},{-120,76}})));
                               //fixme brakes the validation, introduce when ready (unit="K", displayUnit="degC")
  CDL.Interfaces.RealInput TCooSet
    "Output of a ***TSupSet sequence. The economizer modulates to the TCoo rather 
    than to the THea. If Zone State is Cooling, economizer modulates to a temperture 
    slightly lower than the TCoo [PART5.P.3.b]."
    annotation (Placement(transformation(extent={{-160,62},{-120,102}}),
        iconTransformation(extent={{-138,84},{-120,102}})));
                                  //fixme brakes the validation, introduce when ready (unit="K", displayUnit="degC")
  CDL.Continuous.LimPID damPosController(
    yMax=1,
    yMin=0,
    Td=0.1,
    Nd=1,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI,
    k=1,
    Ti=300)
    "Contoller that outputs a signal based on the error between the measured 
    SAT and SAT setpoint [SAT setpoint is the cooling setpoint, in case of 
    cooling reduced in 2F per G36]"
    annotation (Placement(transformation(extent={{-20,-74},{0,-54}})));

  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-160,-36},{-120,4}}),
        iconTransformation(extent={{-138,-14},{-120,4}})));
  CDL.Interfaces.RealOutput yOutDamPos "Economizer damper position"
                                                annotation (Placement(
        transformation(extent={{120,-30},{140,-10}}), iconTransformation(extent={{120,-30},
            {140,-10}})));
  CDL.Interfaces.RealOutput yRetDamPos "Return air damper position"
                                               annotation (Placement(
        transformation(extent={{120,10},{140,30}}), iconTransformation(extent={{120,10},
            {140,30}})));
  CDL.Continuous.Line outDamPos(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{60,8},{80,28}})));
  CDL.Continuous.Line RetDamPos(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  CDL.Continuous.Constant minSignalLimit(k=damPosController.yMin)
    "Identical to controller parameter - Lower limit of output."
    annotation (Placement(transformation(extent={{-20,-6},{0,14}})));
  CDL.Continuous.Constant maxSignalLimit(k=damPosController.yMax)
    "Identical to controller parameter - Upper limit of output."
    annotation (Placement(transformation(extent={{-20,36},{0,56}})));
  CDL.Interfaces.RealInput uHea(min=0, max=1)
    "Heating control signal."
    annotation (Placement(transformation(extent={{-160,-10},{-120,30}}),
        iconTransformation(extent={{-138,12},{-120,30}})));
  CDL.Interfaces.RealInput uCoo(min=0, max=1)
    "Cooling control signal."
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-138,36},{-120,54}})));
  CDL.Interfaces.RealInput uOutDamPosMin
    "Minimum economizer damper position limit as returned by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-160,-62},{-120,-22}}),
        iconTransformation(extent={{-138,-40},{-120,-22}})));
  CDL.Interfaces.RealInput uOutDamPosMax
    "Maximum economizer damper position limit as returned by the EconEnableDisable sequence. If the economizer is disabled, this value equals uOutDamPosMin"
    annotation (Placement(transformation(extent={{-160,-88},{-120,-48}}),
        iconTransformation(extent={{-138,-66},{-120,-48}})));
  CDL.Interfaces.RealInput uRetDamPosMin
    "Minimum return air damper position limit as returned by the EconDamPosLimits sequence. 
    fixme: This is a fixed value and the mentioned sequence assignes the value, which should in principle always be 0, but I'd like to avoid setting the value in multiple places."
    annotation (Placement(transformation(extent={{-160,-116},{-120,-76}}),
        iconTransformation(extent={{-138,-94},{-120,-76}})));
  CDL.Interfaces.RealInput uRetDamPosMax
    "Maximum return air damper position limit as returned by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-160,-140},{-120,-100}}),
        iconTransformation(extent={{-138,-118},{-120,-100}})));
  CDL.Logical.Switch DisableRetDamModulation
    "If the heating is on or the fan is off, keep return air damper at it's maximum limit set by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
  CDL.Logical.Switch DisableEcoDamModulation
    "If the heating is on or the fan is off, keep the economizer damper at its minimum limit set by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  CDL.Logical.GreaterThreshold coolingZoneState
    "Checks whether the cooling control signal is larger than 0. fixme: use Zone State type instead as input."
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  CDL.Logical.LessEqualThreshold ZoneStateStatusHeating(threshold=0)
    "If true, the heating signal is 0. fixme: use ZoneState type instead."
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  CDL.Logical.And andBlock
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  CDL.Continuous.Add add(k1=1, k2=-2)
    "A workaround to deduct 2degC from the cooling SAT in case the cooling signal is present."
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  CDL.Conversions.BooleanToReal typeConverter
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Continuous.Constant minSignalLimit_RetDam(k=minLimRetDam)
    "Intermediate control paramter between controller Upper limit of output and Lower limit of output."
    annotation (Placement(transformation(extent={{-20,68},{0,88}})));
  CDL.Continuous.Constant maxSignalLimit_OutDam(k=maxLimOutDam)
    "Intermediate control paramter between controller Upper limit of output and Lower limit of output."
    annotation (Placement(transformation(extent={{-20,-38},{0,-18}})));
equation
  connect(TSup,damPosController. u_m) annotation (Line(points={{-140,56},{-46,
          56},{-46,-76},{-10,-76}},           color={0,0,127}));
  connect(outDamPos.y, yOutDamPos) annotation (Line(points={{81,18},{90,18},{90,
          -20},{130,-20}}, color={0,0,127}));
  connect(RetDamPos.y, yRetDamPos) annotation (Line(points={{81,50},{90,50},{90,
          20},{130,20}}, color={0,0,127}));
  connect(maxSignalLimit.y, RetDamPos.x2) annotation (Line(points={{1,46},{30,46},
          {58,46}},             color={0,0,127}));
  connect(damPosController.y, RetDamPos.u) annotation (Line(points={{1,-64},{20,
          -64},{20,50},{58,50}}, color={0,0,127}));
  connect(damPosController.y, outDamPos.u) annotation (Line(points={{1,-64},{30,
          -64},{30,18},{58,18}}, color={0,0,127}));
  connect(coolingZoneState.u, uCoo)
    annotation (Line(points={{-82,0},{-82,0},{-120,0}}, color={0,0,127}));
  connect(andBlock.u2, uSupFan) annotation (Line(points={{-82,-78},{-104,-78},{
          -104,-16},{-140,-16}},
                            color={255,0,255}));
  connect(uHea,ZoneStateStatusHeating. u) annotation (Line(points={{-140,10},{
          -94,10},{-94,-40},{-82,-40},{-82,-40}},
                                color={0,0,127}));
  connect(ZoneStateStatusHeating.y, andBlock.u1) annotation (Line(points={{-59,-40},
          {-50,-40},{-50,-20},{-100,-20},{-100,-52},{-100,-70},{-82,-70}},
                                                                        color={255,
          0,255}));
  connect(andBlock.y, DisableEcoDamModulation.u2) annotation (Line(points={{-59,
          -70},{-50,-70},{-50,-140},{-42,-140}}, color={255,0,255}));
  connect(andBlock.y, DisableRetDamModulation.u2) annotation (Line(points={{-59,
          -70},{-50,-70},{-50,-170},{-42,-170}}, color={255,0,255}));
  connect(uOutDamPosMax, DisableEcoDamModulation.u1) annotation (Line(points={{-140,
          -68},{-108,-68},{-108,-132},{-42,-132}}, color={0,0,127}));
  connect(uOutDamPosMin, DisableEcoDamModulation.u3) annotation (Line(points={{-140,
          -42},{-94,-42},{-94,-148},{-42,-148}},   color={0,0,127}));
  connect(uRetDamPosMin, DisableRetDamModulation.u1) annotation (Line(points={{-140,
          -96},{-86,-96},{-86,-162},{-42,-162}},        color={0,0,127}));
  connect(uRetDamPosMax, DisableRetDamModulation.u3) annotation (Line(points={{-140,
          -120},{-80,-120},{-80,-178},{-42,-178}},      color={0,0,127}));
  connect(uRetDamPosMax, RetDamPos.f1) annotation (Line(points={{-140,-120},{50,
          -120},{50,54},{58,54}}, color={0,0,127}));
  connect(DisableRetDamModulation.y, RetDamPos.f2) annotation (Line(points={{
          -19,-170},{10,-170},{10,42},{58,42}}, color={0,0,127}));
  connect(uOutDamPosMin, outDamPos.f1) annotation (Line(points={{-140,-42},{-94,
          -42},{-94,-58},{-34,-58},{-34,22},{58,22}},
                                       color={0,0,127}));
  connect(DisableEcoDamModulation.y, outDamPos.f2) annotation (Line(points={{-19,
          -140},{40,-140},{40,10},{58,10}},
                                          color={0,0,127}));
  connect(TCooSet, add.u1) annotation (Line(points={{-140,82},{-82,82},{-82,76}},
                     color={0,0,127}));
  connect(add.y,damPosController. u_s) annotation (Line(points={{-59,70},{-40,70},
          {-40,-64},{-22,-64}},     color={0,0,127}));
  connect(coolingZoneState.y, typeConverter.u) annotation (Line(points={{-59,0},
          {-52,0},{-52,16},{-90,16},{-90,30},{-82,30}}, color={255,0,255}));
  connect(typeConverter.y, add.u2) annotation (Line(points={{-59,30},{-50,30},{-50,
          50},{-90,50},{-90,64},{-82,64}}, color={0,0,127}));
  connect(minSignalLimit.y, outDamPos.x1) annotation (Line(points={{1,4},{8,4},{
          16,4},{16,26},{58,26}}, color={0,0,127}));
  connect(minSignalLimit_RetDam.y, RetDamPos.x1) annotation (Line(points={{1,78},
          {10,78},{20,78},{20,58},{58,58}}, color={0,0,127}));
  connect(maxSignalLimit_OutDam.y, outDamPos.x2) annotation (Line(points={{1,-28},
          {24,-28},{24,14},{58,14}}, color={0,0,127}));
  annotation (
    defaultComponentName = "ecoMod",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}}),                                             graphics={
        Rectangle(
        extent={{-120,-120},{120,120}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,102},{-78,82}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="TCooSet"),
        Text(
          extent={{58,34},{114,0}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPos"),
        Text(
          extent={{-120,72},{-90,60}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="TSup"),
        Text(
          extent={{60,-4},{116,-38}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPos"),
        Text(
          extent={{-118,32},{-90,16}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uHea"),
        Text(
          extent={{-118,54},{-88,38}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uCoo"),
        Line(points={{20,58}}, color={28,108,200}),
        Line(points={{-92,-84},{-50,-84},{12,70},{82,70}}, color={28,108,200},
          thickness=0.5),
        Line(
          points={{-66,58},{12,58},{50,-76},{100,-76}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Text(
          extent={{-118,6},{-74,-16}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uSupFan"),
        Text(
          extent={{-118,-14},{-46,-50}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOutDamPosMin"),
        Text(
          extent={{-118,-38},{-48,-74}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOutDamPosMax"),
        Text(
          extent={{-118,-66},{-48,-102}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uRetDamPosMin"),
        Text(
          extent={{-116,-90},{-46,-126}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uRetDamPosMax"),
        Text(
          extent={{-44,152},{34,128}},
          lineColor={85,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-180},{
            120,100}})),
    Documentation(info="<html>      
    <p>
    fixme ?Brent: If the dampers are not interloacked, should the linear mapping have
    different control loop signal limits.
    fixme - issues: initiate inputs and outputs
    </p>
<p>
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
<p>
fixme: interpret corresponding text from G36 as implemented here.
</p>
<p>
Control charts below show the input-output structure and an economizer damper 
modulation sequence assuming a well tuned controller. Control diagram:
</p>
<p align=\"center\">
<img alt=\"Image of the modulation sequence control diagram\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconModulationControlDiagram.png\"/>
</p>
<p>
The modulation is indirectly enabled through outputs of EconDamPosLimits, but also the conditions illustrated here:
<br>
</br>
</p>
<p align=\"center\">
<img alt=\"Image of the modulation sequence state machine chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconModulationStateMachineChart.png\"/>
</p>
<p>
Expected control performance, upon tuning:
fixme: create our customized chart instead
<br>
</br>
</p>
<p align=\"center\">
<img alt=\"Image of the modulation sequence expected performance\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/DamperModulationSequenceEcon_MultiZone.png\"/>
</p>
<p>
bla
</p>

</html>", revisions="<html>
<ul>
<li>
April 07, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconModulationMultiZone;
