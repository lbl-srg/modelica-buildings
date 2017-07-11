within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic;
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
control loop"),                    Text(
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

</html>", revisions="<html>
<ul>
<li>
June 28, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconModulationMultiZone;
