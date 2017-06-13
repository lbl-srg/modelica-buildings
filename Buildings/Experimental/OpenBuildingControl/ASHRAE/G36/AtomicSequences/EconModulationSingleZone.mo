within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconModulationSingleZone "Based on supply air temperature (SAT) setpoint and measured 
  supply air temperature, the controller resets the economizer and return air
  damper positions. Damper position limits are inputs to this model. To 
  prevent modulation, provide input signals that set max and min position
  limits to the same value."

  CDL.Interfaces.RealInput TSup
    "Measured supply air temperature. Sensor output."
    annotation (Placement(transformation(extent={{-180,56},{-140,96}}),
        iconTransformation(extent={{-158,78},{-140,96}})));
                               //fixme brakes the validation, introduce when ready (unit="K", displayUnit="degC")
  CDL.Interfaces.RealInput TCooSet
    "Output of a ***TSupSet sequence. The economizer modulates to the TCoo rather 
    than to the THea. If Zone State is Cooling, economizer modulates to a temperture 
    slightly lower than the TCoo [PART5.P.3.b]."
    annotation (Placement(transformation(extent={{-180,82},{-140,122}}),
        iconTransformation(extent={{-160,100},{-142,118}})));
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
    annotation (Placement(transformation(extent={{-20,-34},{0,-14}})));

  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-158,-18},{-140,0}})));
  CDL.Interfaces.RealOutput yOutDamPos(min=0, max=1, unit="1") "Economizer damper position"
                                                annotation (Placement(
        transformation(extent={{140,-30},{160,-10}}), iconTransformation(extent={{140,-30},
            {160,-10}})));
  CDL.Interfaces.RealOutput yRetDamPos(min=0, max=1, unit="1") "Return air damper position"
                                               annotation (Placement(
        transformation(extent={{140,10},{160,30}}), iconTransformation(extent={{140,10},
            {160,30}})));
  CDL.Continuous.Line outDamPos(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Continuous.Line RetDamPos(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  CDL.Continuous.Constant minSignalLimit(k=damPosController.yMin)
    "Identical to controller parameter - Lower limit of output."
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  CDL.Continuous.Constant maxSignalLimit(k=damPosController.yMax)
    "Identical to controller parameter - Upper limit of output."
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  CDL.Interfaces.RealInput uHea(min=0, max=1, unit="1")
    "Heating control signal."
    annotation (Placement(transformation(extent={{-180,-10},{-140,30}}),
        iconTransformation(extent={{-158,16},{-140,34}})));
  CDL.Interfaces.RealInput uOutDamPosMin(min=0, max=1, unit="1")
    "Minimum economizer damper position limit as returned by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-180,-70},{-140,-30}}),
        iconTransformation(extent={{-158,-48},{-140,-30}})));
  CDL.Interfaces.RealInput uOutDamPosMax(min=0, max=1, unit="1")
    "Maximum economizer damper position limit as returned by the EconEnableDisable sequence. If the economizer is disabled, this value equals uOutDamPosMin"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
        iconTransformation(extent={{-158,-76},{-140,-58}})));
  CDL.Interfaces.RealInput uRetDamPosMin(min=0, max=1, unit="1")
    "Minimum return air damper position limit as returned by the EconDamPosLimits sequence. 
    fixme: This is a fixed value and the mentioned sequence assignes the value, which should in principle always be 0, but I'd like to avoid setting the value in multiple places."
    annotation (Placement(transformation(extent={{-180,-128},{-140,-88}}),
        iconTransformation(extent={{-158,-106},{-140,-88}})));
  CDL.Interfaces.RealInput uRetDamPosMax(min=0, max=1, unit="1")
    "Maximum return air damper position limit as returned by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-180,-160},{-140,-120}}),
        iconTransformation(extent={{-158,-134},{-140,-116}})));
  CDL.Logical.Switch DisableRetDamModulation
    "If the heating is on or the fan is off, keep return air damper at it's maximum limit set by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));
  CDL.Logical.Switch DisableEcoDamModulation
    "If the heating is on or the fan is off, keep the economizer damper at its minimum limit set by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-40,-122},{-20,-102}})));
  CDL.Logical.LessEqualThreshold ZoneStateStatusHeating(threshold=0)
    "If true, the heating signal is 0. fixme: use ZoneState type instead."
    annotation (Placement(transformation(extent={{-80,-44},{-60,-24}})));
  CDL.Logical.And andBlock
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(TSup,damPosController. u_m) annotation (Line(points={{-160,76},{-100,
          76},{-100,56},{-44,56},{-44,-44},{-10,-44},{-10,-36}},
                                              color={0,0,127}));
  connect(outDamPos.y, yOutDamPos) annotation (Line(points={{81,10},{90,10},{90,
          -20},{150,-20}}, color={0,0,127}));
  connect(RetDamPos.y, yRetDamPos) annotation (Line(points={{81,50},{90,50},{90,
          20},{150,20}}, color={0,0,127}));
  connect(maxSignalLimit.y, RetDamPos.x2) annotation (Line(points={{1,30},{30,
          30},{30,46},{58,46}}, color={0,0,127}));
  connect(damPosController.y, RetDamPos.u) annotation (Line(points={{1,-24},{20,
          -24},{20,50},{58,50}}, color={0,0,127}));
  connect(minSignalLimit.y, outDamPos.x1) annotation (Line(points={{1,70},{40,
          70},{40,18},{58,18}}, color={0,0,127}));
  connect(damPosController.y, outDamPos.u) annotation (Line(points={{1,-24},{30,
          -24},{30,10},{58,10}}, color={0,0,127}));
  connect(andBlock.u2, uSupFan) annotation (Line(points={{-82,-78},{-114,-78},{
          -114,-20},{-160,-20}},
                            color={255,0,255}));
  connect(uHea,ZoneStateStatusHeating. u) annotation (Line(points={{-160,10},{
          -108,10},{-108,-34},{-84,-34},{-82,-34}},
                                color={0,0,127}));
  connect(ZoneStateStatusHeating.y, andBlock.u1) annotation (Line(points={{-59,-34},
          {-50,-34},{-50,-20},{-100,-20},{-100,-52},{-100,-70},{-82,-70}},
                                                                        color={255,
          0,255}));
  connect(andBlock.y, DisableEcoDamModulation.u2) annotation (Line(points={{-59,-70},
          {-50,-70},{-50,-112},{-42,-112}},      color={255,0,255}));
  connect(andBlock.y, DisableRetDamModulation.u2) annotation (Line(points={{-59,-70},
          {-50,-70},{-50,-150},{-42,-150}},      color={255,0,255}));
  connect(uOutDamPosMax, DisableEcoDamModulation.u1) annotation (Line(points={{-160,
          -80},{-120,-80},{-120,-90},{-70,-90},{-70,-104},{-42,-104}},
                                                   color={0,0,127}));
  connect(uOutDamPosMin, DisableEcoDamModulation.u3) annotation (Line(points={{-160,
          -50},{-90,-50},{-90,-120},{-42,-120}},   color={0,0,127}));
  connect(uRetDamPosMin, DisableRetDamModulation.u1) annotation (Line(points={{-160,
          -108},{-90,-108},{-90,-142},{-42,-142}},      color={0,0,127}));
  connect(uRetDamPosMax, DisableRetDamModulation.u3) annotation (Line(points={{-160,
          -140},{-80,-140},{-80,-158},{-42,-158}},      color={0,0,127}));
  connect(minSignalLimit.y, RetDamPos.x1) annotation (Line(points={{1,70},{30,
          70},{30,58},{58,58}}, color={0,0,127}));
  connect(uRetDamPosMax, RetDamPos.f1) annotation (Line(points={{-160,-140},{50,
          -140},{50,54},{58,54}}, color={0,0,127}));
  connect(DisableRetDamModulation.y, RetDamPos.f2) annotation (Line(points={{-19,
          -150},{10,-150},{10,42},{58,42}},     color={0,0,127}));
  connect(uOutDamPosMin, outDamPos.f1) annotation (Line(points={{-160,-50},{-32,
          -50},{-32,14},{58,14}},      color={0,0,127}));
  connect(DisableEcoDamModulation.y, outDamPos.f2) annotation (Line(points={{-19,
          -112},{40,-112},{40,2},{58,2}}, color={0,0,127}));
  connect(maxSignalLimit.y, outDamPos.x2)
    annotation (Line(points={{1,30},{30,30},{30,6},{58,6}}, color={0,0,127}));
  connect(TCooSet, damPosController.u_s) annotation (Line(points={{-160,102},{
          -30,102},{-30,-24},{-22,-24}}, color={0,0,127}));
  annotation (
    defaultComponentName = "ecoMod",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
            140}}),                                             graphics={
        Rectangle(
        extent={{-140,-140},{140,140}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-138,128},{-96,98}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="TCooSet"),
        Text(
          extent={{74,32},{136,6}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPos"),
        Text(
          extent={{-138,94},{-100,80}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="TSup"),
        Text(
          extent={{62,-14},{144,-26}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPos"),
        Text(
          extent={{-138,32},{-106,18}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uHea"),
        Text(
          extent={{-136,66},{-104,52}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uCoo"),
        Line(points={{20,58}}, color={28,108,200}),
        Line(points={{-114,-104},{-50,-104},{68,102},{104,102}},
                                                           color={28,108,200},
          thickness=0.5),
        Line(
          points={{-100,104},{-48,104},{64,-106},{118,-106}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Text(
          extent={{-138,8},{-86,-18}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uSupFan"),
        Text(
          extent={{-136,-22},{-66,-58}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOutDamPosMin"),
        Text(
          extent={{-136,-50},{-66,-86}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOutDamPosMax"),
        Text(
          extent={{-136,-80},{-66,-116}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uRetDamPosMin"),
        Text(
          extent={{-136,-106},{-66,-142}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uRetDamPosMax"),
        Text(
          extent={{-64,182},{48,146}},
          lineColor={85,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{
            140,120}})),
    Documentation(info="<html>      
    <p>
    fixme ?Brent: If the dampers are not interloacked, should the linear mapping have
    different control loop signal limits.
    fixme - issues: initiate inputs and outputs
    </p>
<p>
This atomic sequence sets the economizer and
return air damper position. The implementation is according
to ASHRAE Guidline 36 (G36), Part 5.P.3.b and functionaly it represents the
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
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/DamperModulationSequenceEcon.PNG\"/>
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
end EconModulationSingleZone;
