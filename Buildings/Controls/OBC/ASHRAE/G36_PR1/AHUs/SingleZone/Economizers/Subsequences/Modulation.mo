within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences;
block Modulation "Outdoor and return air damper position modulation sequence for single zone VAV AHU"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";

  parameter Real k(final unit="1/K") = 1 "Gain of controller";

  parameter Modelica.SIunits.Time Ti=300
    "Time constant of modulation controller integrator block"
    annotation (Dialog(
      enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time Td=0.1
    "Time constant of derivative block for cooling control loop signal"
    annotation (Dialog(
      enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real uMin=0
    "Lower limit of controller output uTSup at which the dampers are at their limits"
    annotation(Evaluate=true);
  parameter Real uMax=1
    "Upper limit of controller output uTSup at which the dampers are at their limits"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-160,90},{-120,130}}),
      iconTransformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSupSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature") "Supply air temperature heating setpoint"
    annotation (Placement(transformation(extent={{-160,60},{-120,100}}),
      iconTransformation(extent={{-120,60},{-100,80}})));

  CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-160,-130},{-120,-90}}),
      iconTransformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMin(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum economizer damper position limit as returned by the damper position limits sequence"
    annotation (Placement(transformation(extent={{-160,-90},{-120,-50}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMax(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum economizer damper position limit as returned by the economizer enable-disable sequence.
    If the economizer is disabled, this value equals uOutDamPosMin"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDamPosMin(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum return air damper position limit as returned by the economizer enable-disable sequence"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDamPosMax(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum return air damper position limit as returned by the economizer enable-disable sequence"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
      iconTransformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Economizer damper position"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}}),
      iconTransformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position"
    annotation (Placement(transformation(extent={{120,10},{140,30}}),
      iconTransformation(extent={{100,10},{120,30}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID uTSup(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=uMax,
    final yMin=uMin,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
    "Contoller that outputs a signal based on the error between the measured SAT and SAT heating setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamMinLimSig(
      final k=uMin) "Minimal control loop signal for the outdoor air damper"
    annotation (Placement(transformation(extent={{-20,-22},{0,-2}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamMaxLimSig(
      final k=uMax) "Maximal control loop signal for the return air damper"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Line outDamPos(
    final limitBelow=true,
    final limitAbove=true)
    "Damper position is linearly proportional to the control signal between signal limits"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Line retDamPos(
    final limitBelow=true,
    final limitAbove=true)
    "Damper position is linearly proportional to the control signal between signal limits"
    annotation (Placement(transformation(extent={{58,10},{78,30}})));

equation
  connect(TSup, uTSup.u_m)
    annotation (Line(points={{-140,110},{-108,110},{-108,58},{-70,58},{-70,68}},
                                                             color={0,0,127}));
  connect(outDamPos.y, yOutDamPos)
    annotation (Line(points={{81,-20},{100,-20},{120,-20},{130,-20}},          color={0,0,127}));
  connect(retDamPos.y, yRetDamPos)
    annotation (Line(points={{79,20},{100,20},{130,20}},           color={0,0,127}));
  connect(retDamMaxLimSig.y,retDamPos. x2)
    annotation (Line(points={{1,30},{30,30},{30,16},{56,16}},                       color={0,0,127}));
  connect(uTSup.y, retDamPos.u) annotation (Line(points={{-59,80},{40,80},{40,20},
          {56,20}},     color={0,0,127}));
  connect(uTSup.y, outDamPos.u) annotation (Line(points={{-59,80},{40,80},{40,-20},
          {58,-20}}, color={0,0,127}));
  connect(uRetDamPosMax,retDamPos. f1)
    annotation (Line(points={{-140,40},{-112,40},{-112,48},{48,48},{48,24},{56,
          24}},                                                    color={0,0,127}));
  connect(uOutDamPosMin, outDamPos.f1)
    annotation (Line(points={{-140,-70},{28,-70},{28,-16},{58,-16}},               color={0,0,127}));
  connect(outDamMinLimSig.y, outDamPos.x1)
    annotation (Line(points={{1,-12},{1,-12},{28,-12},{58,-12}},           color={0,0,127}));
  connect(THeaSupSet, uTSup.u_s)
    annotation (Line(points={{-140,80},{-82,80}},           color={0,0,127}));
  connect(uRetDamPosMin,retDamPos. f2)
    annotation (Line(points={{-140,0},{-112,0},{-112,-10},{-38,-10},{-38,12},{
          56,12}},                                                 color={0,0,127}));
  connect(uOutDamPosMax, outDamPos.f2) annotation (Line(points={{-140,-40},{40,
          -40},{40,-28},{58,-28}},     color={0,0,127}));
  connect(retDamMaxLimSig.y, outDamPos.x2)
    annotation (Line(points={{1,30},{30,30},{30,-24},{58,-24}}, color={0,0,127}));
  connect(outDamMinLimSig.y, retDamPos.x1)
    annotation (Line(points={{1,-12},{24,-12},{24,28},{56,28}}, color={0,0,127}));
  connect(uSupFan, uTSup.trigger) annotation (Line(points={{-140,-110},{-78,-110},
          {-78,68}},       color={255,0,255}));
  annotation (
    defaultComponentName = "mod",
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
          extent={{-102,128},{-58,88}},
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
This is a single zone VAV AHU economizer modulation block. It calculates
the outdoor and return air damper positions based on the single zone VAV AHU
supply air temperature control loop signal. Economizer dampers are modulated
based on the calculated heating supply air temperature setpoint.
The implementation is in line with ASHRAE
Guidline 36 (G36), PART5.P.3.b. Damper positions are linearly mapped to
the supply air control loop signal. This is a final sequence in the
composite single zone VAV AHU economizer control sequence. Damper position
limits, which are the inputs to the sequence, are the outputs of
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Limits\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Limits</a> and
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Enable</a>
sequences.
</p>
<p>
When the economizer is enabled, the PI controller modulates the damper
positions. Return and outdoor damper are not interlocked. When the economizer is disabled,
the damper positions are set to the minimum outdoor air damper position limits.
</p>
<p>
The control charts below show the input-output structure and an economizer damper
modulation sequence assuming a well configured controller. Control diagram:
</p>
<p align=\"center\">
<img alt=\"Image of the single zone AHU modulation sequence control diagram\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/EconModulationControlDiagramSingleZone.png\"/>
</p>
<p>
Single zone AHU economizer modulation control chart:
<br/>
</p>
<p align=\"center\">
<img alt=\"Image of the single zone AHU modulation sequence expected performance\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/EconModulationControlChartSingleZone.png\"/>
</p>

</html>", revisions="<html>
<ul>
<li>
October 19, 2017, by Jianjun Hu:<br/>
Changed name of controller output limit from yMin/yMax to uMin/uMax.
</li>
<li>
July 07, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Modulation;
