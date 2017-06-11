within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconModulationMultiZone "Based on supply air temperature (SAT) setpoint and measured 
  supply air temperature, the controller resets the economizer and return air
  damper positions. Damper position limits are inputs to this model. To 
  prevent modulation, provide input signals that set max and min position
  limits to the same value."

  parameter Real retDamMinSig(min=0, max=1, unit="1") = 0.5
  "Minimum control loop signal for the return air damper";
  parameter Real outDamMaxSig(min=0, max=1, unit="1") = retDamMinSig
  "Maximum control loop signal for the outdoor air damper";
  parameter Real yConSigMin=0 "Lower limit of controller output";
  parameter Real yConSigMax=1 "Upper limit of controller output";

  CDL.Interfaces.RealInput TSup
    "Measured supply air temperature. Sensor output."
    annotation (Placement(transformation(extent={{-160,-40},{-120,0}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
                               //fixme brakes the validation, introduce when ready (unit="K", displayUnit="degC")
  CDL.Interfaces.RealInput TCooSet
    "Output of a ***TSupSet sequence. The economizer modulates to the TCoo rather 
    than to the THea. If Zone State is Cooling, economizer modulates to a temperture 
    slightly lower than the TCoo [PART5.P.3.b]."
    annotation (Placement(transformation(extent={{-160,-10},{-120,30}}),
        iconTransformation(extent={{-120,80},{-100,100}})));
                                  //fixme brakes the validation, introduce when ready (unit="K", displayUnit="degC")
  CDL.Continuous.LimPID damPosController(
    Td=0.1,
    Nd=1,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI,
    k=1,
    Ti=300,
    yMax=yConSigMax,
    yMin=yConSigMin)
    "Contoller that outputs a signal based on the error between the measured SAT and SAT cooling setpoint"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  CDL.Interfaces.RealOutput yOutDamPos(min=0, max=1, unit="1") "Economizer damper position"
                                                annotation (Placement(
        transformation(extent={{120,-30},{140,-10}}), iconTransformation(extent={{100,-30},
            {120,-10}})));
  CDL.Interfaces.RealOutput yRetDamPos(min=0, max=1, unit="1") "Return air damper position"
                                               annotation (Placement(
        transformation(extent={{120,10},{140,30}}), iconTransformation(extent={{100,10},
            {120,30}})));
  CDL.Continuous.Line outDamPos(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal between signal limits."
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  CDL.Continuous.Line RetDamPos(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal between signal limits."
    annotation (Placement(transformation(extent={{62,58},{82,78}})));
  CDL.Continuous.Constant outDamMinLimSig(k=damPosController.yMin)
    "Minimal control loop signal for the outdoor air damper."
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  CDL.Continuous.Constant retDamMaxLimSig(k=damPosController.yMax)
    "Maximal control loop signal for the return air damper."
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  CDL.Interfaces.RealInput uOutDamPosMin(min=0, max=1, unit="1")
    "Minimum economizer damper position limit as returned by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));
  CDL.Interfaces.RealInput uOutDamPosMax(min=0, max=1, unit="1")
    "Maximum economizer damper position limit as returned by the EconEnableDisable sequence. If the economizer is disabled, this value equals uOutDamPosMin"
    annotation (Placement(transformation(extent={{-160,-90},{-120,-50}}),
        iconTransformation(extent={{-120,0},{-100,20}})));
  CDL.Interfaces.RealInput uRetDamPosMin(min=0, max=1, unit="1")
    "Minimum return air damper position limit as returned by the EconDamPosLimits sequence. 
    fixme: This is a fixed value and the mentioned sequence assignes the value, which should in principle always be 0, but I'd like to avoid setting the value in multiple places."
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
        iconTransformation(extent={{-120,-100},{-100,-80}})));
  CDL.Interfaces.RealInput uRetDamPosMax(min=0, max=1, unit="1")
    "Maximum return air damper position limit as returned by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  CDL.Continuous.Constant retDamMinLimSig(k=retDamMinSig)
    "Minimal control loop signal for the return air damper."
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  CDL.Continuous.Constant outDamMaxLimSig(k=outDamMaxSig)
    "Maximum control loop signal for the outdoor air damper"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
equation
  connect(TSup,damPosController. u_m) annotation (Line(points={{-140,-20},{-70,-20},
          {-70,-2}},                          color={0,0,127}));
  connect(outDamPos.y, yOutDamPos) annotation (Line(points={{81,-30},{100,-30},{
          100,-20},{120,-20},{130,-20}},
                           color={0,0,127}));
  connect(RetDamPos.y, yRetDamPos) annotation (Line(points={{83,68},{100,68},{100,
          20},{130,20}}, color={0,0,127}));
  connect(retDamMaxLimSig.y, RetDamPos.x2) annotation (Line(points={{1,40},{2,40},
          {0,40},{40,40},{40,64},{52,64},{60,64}},
                                             color={0,0,127}));
  connect(damPosController.y, RetDamPos.u) annotation (Line(points={{-59,10},{30,
          10},{30,68},{60,68}},  color={0,0,127}));
  connect(damPosController.y, outDamPos.u) annotation (Line(points={{-59,10},{40,
          10},{40,-30},{58,-30}},color={0,0,127}));
  connect(uRetDamPosMax, RetDamPos.f1) annotation (Line(points={{-140,100},{50,100},
          {50,72},{60,72}},       color={0,0,127}));
  connect(uOutDamPosMin, outDamPos.f1) annotation (Line(points={{-140,-100},{-140,
          -100},{28,-100},{28,-26},{58,-26}},
                                       color={0,0,127}));
  connect(outDamMinLimSig.y, outDamPos.x1) annotation (Line(points={{1,-10},{1,-10},
          {28,-10},{28,-22},{58,-22}},        color={0,0,127}));
  connect(retDamMinLimSig.y, RetDamPos.x1) annotation (Line(points={{1,80},{2,80},
          {40,80},{40,76},{60,76}},   color={0,0,127}));
  connect(outDamMaxLimSig.y, outDamPos.x2) annotation (Line(points={{1,-50},{32,
          -50},{32,-34},{58,-34}},   color={0,0,127}));
  connect(TCooSet, damPosController.u_s) annotation (Line(points={{-140,10},{-140,
          10},{-82,10}},                color={0,0,127}));
  connect(uRetDamPosMin, RetDamPos.f2)
    annotation (Line(points={{-140,60},{60,60}}, color={0,0,127}));
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
        Line(points={{-92,-84},{-50,-84},{12,70},{82,70}}, color={28,108,200},
          thickness=0.5),
        Line(
          points={{-66,58},{12,58},{50,-76},{100,-76}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Text(
          extent={{-108,138},{102,110}},
          lineColor={85,0,255},
          textString="EconModul")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}}),     graphics={Text(
          extent={{-44,-110},{-14,-118}},
          lineColor={28,108,200},
          textString="Enable modulation")}),
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
