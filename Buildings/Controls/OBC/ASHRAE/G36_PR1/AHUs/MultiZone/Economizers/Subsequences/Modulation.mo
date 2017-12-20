within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences;
block Modulation
  "Outdoor and return air damper position modulation sequence for multi zone VAV AHU"

  parameter Real uMin(
    final max=0,
    final unit="1")=-0.25
    "Lower limit of controller input when outdoor damper opens (see diagram)"
    annotation (Evaluate=true,Dialog(tab="Commissioning", group="Controller"));
  parameter Real uMax(
    final min=0,
    final unit="1")=+0.25
    "Upper limit of controller input when return damper is closed (see diagram)"
    annotation (Evaluate=true,Dialog(tab="Commissioning", group="Controller"));

  parameter Real uOutDamMax(
    final min=-1,
    final max=1,
    final unit="1") = (uMin + uMax)/2
    "Maximum loop signal for the OA damper to be fully open"
    annotation (Evaluate=true, Dialog(tab="Commissioning", group="Controller"));
  parameter Real uRetDamMin(
    final min=-1,
    final max=1,
    final unit="1") = (uMin + uMax)/2
    "Minimum loop signal for the RA damper to be fully open"
    annotation (Evaluate=true, Dialog(tab="Commissioning", group="Controller"));

  parameter Modelica.SIunits.Time samplePeriod = 300
    "Sample period of component, used to limit the rate of change of the dampers (to avoid quick opening that can result in frost)";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTSup(final unit="1")
    "Signal for supply air temperature control (T Sup Control Loop Signal in diagram)"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMin(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum economizer damper position limit as returned by the damper position limits  sequence"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMax(
    final min=0,
    final max=1,
    final unit="1") "Maximum economizer damper position limit as returned by the economizer enable-disable sequence.
    If the economizer is disabled, this value equals uOutDamPosMin" annotation (
    Placement(transformation(extent={{-160,-70},{-120,-30}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDamPosMin(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum return air damper position limit as returned by the economizer enable-disable sequence"
    annotation (Placement(transformation(extent={{-160,30},{-120,70}}),
      iconTransformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDamPosMax(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum return air damper position limit as returned by the economizer enable-disable sequence"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
      iconTransformation(extent={{-120,70},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Economizer damper position" annotation (Placement(
    transformation(extent={{120,-70},{140,-50}}),
      iconTransformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position" annotation (Placement(
    transformation(extent={{120,50},{140,70}}),
      iconTransformation(extent={{100,10},{120,30}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamMinLimSig(
    final k=uMin) "Minimal control loop signal for the outdoor air damper"
    annotation (Placement(transformation(extent={{-60,-32},{-40,-12}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamMaxLimSig(
    final k=uOutDamMax) "Maximum control loop signal for the outdoor air damper"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamConMinLimSig(
    final k=uRetDamMin)
    "Minimal control loop signal for the return air damper"
    annotation (Placement(transformation(extent={{-80,68},{-60,88}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamMaxLimSig(
    final k=uMax) "Maximal control loop signal for the return air damper"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Line outDamPos(
    final limitBelow=true,
    final limitAbove=true)
    "Damper position is linearly proportional to the control signal between signal limits"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Line retDamPos(
    final limitBelow=true,
    final limitAbove=true)
    "Damper position is linearly proportional to the control signal between signal limits"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min "Overwrite due to freeze protection"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max "Overwrite due to freeze protection"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  CDL.Discrete.FirstOrderHold firOrdHolOutDam(final samplePeriod=samplePeriod)
    "First order hold to avoid too fast opening/closing of damper (which may cause freeze protection to be too slow to compensate)"
    annotation (Placement(transformation(extent={{92,-70},{112,-50}})));
  CDL.Discrete.FirstOrderHold firOrdHolRetDam(final samplePeriod=samplePeriod)
    "First order hold to avoid too fast opening/closing of damper (which may cause freeze protection to be too slow to compensate)"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
equation
  connect(outDamPos.x2, outDamMaxLimSig.y)
    annotation (Line(points={{-2,-34},{-30,-34},{-30,-50},{-79,-50}},color={0,0,127}));
  connect(outDamPos.x1, outDamMinLimSig.y)
    annotation (Line(points={{-2,-22},{-39,-22}},                    color={0,0,127}));
  connect(outDamPos.f1, uOutDamPosMin)
    annotation (Line(points={{-2,-26},{-24,-26},{-24,-100},{-140,-100}},color={0,0,127}));
  connect(outDamPos.f2, uOutDamPosMax)
    annotation (Line(points={{-2,-38},{-20,-38},{-20,-66},{-108,-66},{-108,-50},{-140,-50}},
    color={0,0,127}));
  connect(retDamPos.x2, retDamMaxLimSig.y)
    annotation (Line(points={{-2,66},{-28,66},{-28,20},{-39,20}},color={0,0,127}));
  connect(retDamPos.x1, retDamConMinLimSig.y)
    annotation (Line(points={{-2,78},{-59,78}},color={0,0,127}));
  connect(retDamPos.f1, uRetDamPosMax)
    annotation (Line(points={{-2,74},{-48,74},{-48,100},{-140,100}},color={0,0,127}));
  connect(retDamPos.f2, uRetDamPosMin)
    annotation (Line(points={{-2,62},{-12,62},{-12,50},{-140,50}}, color={0,0,127}));
  connect(min.u2, uOutDamPosMax)
    annotation (Line(points={{58,-66},{-108,-66},{-108,-50},{-140,-50}},color={0,0,127}));
  connect(min.u1, outDamPos.y)
    annotation (Line(points={{58,-54},{28,-54},{28,-30},{21,-30}}, color={0,0,127}));
  connect(max.u1, retDamPos.y)
    annotation (Line(points={{58,66},{30,66},{30,70},{21,70}}, color={0,0,127}));
  connect(uRetDamPosMin, max.u2)
    annotation (Line(points={{-140,50},{-12,50},{-12,54},{58,54}}, color={0,0,127}));
  connect(min.y, firOrdHolOutDam.u)
    annotation (Line(points={{81,-60},{90,-60}}, color={0,0,127}));
  connect(firOrdHolOutDam.y, yOutDamPos)
    annotation (Line(points={{113,-60},{130,-60}}, color={0,0,127}));
  connect(uTSup, retDamPos.u) annotation (Line(points={{-140,0},{-22,0},{-22,70},
          {-2,70}}, color={0,0,127}));
  connect(uTSup, outDamPos.u) annotation (Line(points={{-140,0},{-22,0},{-22,
          -30},{-2,-30}}, color={0,0,127}));
  connect(max.y, firOrdHolRetDam.u)
    annotation (Line(points={{81,60},{88,60}}, color={0,0,127}));
  connect(firOrdHolRetDam.y, yRetDamPos)
    annotation (Line(points={{111,60},{130,60}}, color={0,0,127}));
  annotation (
    defaultComponentName="mod",
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{
            120,120}}), graphics={
        Rectangle(
          extent={{-26,118},{46,-118}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-118,118},{-34,-118}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-80,128},{-36,88}},
          lineColor={0,0,0},
          fontSize=12,
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position
supply air temperature
control loop"),
        Text(
          extent={{-20,128},{24,88}},
          lineColor={0,0,0},
          fontSize=12,
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position
assignments"),
        Rectangle(
          extent={{52,118},{118,-118}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{58,124},{102,84}},
          lineColor={0,0,0},
          fontSize=12,
          horizontalAlignment=TextAlignment.Left,
          textString="Overwrite if the freeze protection
that tracks TFre at the measured
mixed air temperature limits the
damper position")}),
    Documentation(info="<html>
<p>
This is a multi zone VAV AHU economizer modulation block. It calculates
the outdoor and return air damper positions based on the supply air temperature
control loop signal. The implementation is in line with ASHRAE
Guidline 36 (G36), PART5.N.2.c. Damper positions are linearly mapped to
the supply air control loop signal. This is a final sequence in the
composite multi zone VAV AHU economizer control sequence. Damper position
limits, which are the inputs to the sequence, are the outputs of
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Limits\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Limits</a> and
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable</a>
sequences.
</p>
<p>
When the economizer is enabled, the PI controller modulates the damper
positions. Return and outdoor damper are not interlocked. When the economizer is disabled,
the damper positions are set to the minimum outdoor air damper position limits.
</p>
<p>
The time rate of change of the damper signals is limited by a first order hold,
using the sample time <code>samplePeriod</code>.
This prevents a quick opening of the outdoor air damper, for example when the
outdoor airflow setpoint has a step change.
Slowing down the opening of the outdoor air damper allows the freeze protection
to componensate with its dynamics that is faster than the opening of the outdoor air damper.
To avoid that all dampers are closed, the return air damper has the same
time rate of change limitation.
</p>
<p>
The control charts below show the input-output structure and an economizer damper
modulation sequence assuming a well configured controller. Control diagram:
</p>
<p align=\"center\">
<img alt=\"Image of the multi zone AHU modulation sequence control diagram\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/EconModulationControlDiagramMultiZone.png\"/>
</p>
<p>
Multi zone AHU economizer modulation control chart:
<br/>
</p>
<p align=\"center\">
<img alt=\"Image of the multi zone AHU modulation sequence expected performance\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/EconModulationControlChartMultiZone.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, 2017, by Michael Wetter:<br/>
Corrected implementation for when dampers are
such positioned that they prevent the mixed air temperature from being
below the freezing set point.
</li>
<li>
October 11, 2017, by Michael Wetter:<br/>
Corrected implementation to use control loop signal as input.
</li>
<li>
September 29, 2017, by Michael Wetter:<br/>
Corrected implementation by adding reverse action.
</li>
<li>
June 28, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Modulation;
