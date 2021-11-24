within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences;
block Modulation
  "Outdoor and return air damper position modulation sequence for multi zone VAV AHU"

  parameter Real uMin(
    final max=0,
    final unit="1")=-0.25
    "Lower limit of controller input when outdoor damper opens (see diagram)"
    annotation (Dialog(tab="Commissioning", group="Controller"));
  parameter Real uMax(
    final min=0,
    final unit="1")=+0.25
    "Upper limit of controller input when return damper is closed (see diagram)"
    annotation (Dialog(tab="Commissioning", group="Controller"));
  parameter Real uOutDamMax(
    final min=-1,
    final max=1,
    final unit="1") = (uMin + uMax)/2
    "Maximum loop signal for the OA damper to be fully open"
    annotation (Dialog(tab="Commissioning", group="Controller"));
  parameter Real uRetDamMin(
    final min=-1,
    final max=1,
    final unit="1") = (uMin + uMax)/2
    "Minimum loop signal for the RA damper to be fully open"
    annotation (Dialog(tab="Commissioning", group="Controller"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTSup(final unit="1")
    "Signal for supply air temperature control (T Sup Control Loop Signal in diagram)"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMin(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum economizer damper position limit as returned by the damper position limits  sequence"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMax(
    final min=0,
    final max=1,
    final unit="1") "Maximum economizer damper position limit as returned by the economizer enable-disable sequence.
    If the economizer is disabled, this value equals uOutDamPosMin"
    annotation (Placement(transformation(extent={{-160,-70},{-120,-30}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDamPosMin(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum return air damper position limit as returned by the economizer enable-disable sequence"
    annotation (Placement(transformation(extent={{-160,30},{-120,70}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDamPosMax(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum return air damper position limit as returned by the economizer enable-disable sequence"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Economizer damper position"
    annotation (Placement(transformation(extent={{120,-80},{160,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position"
    annotation (Placement(transformation(extent={{120,40},{160,80}}),
        iconTransformation(extent={{100,40},{140,80}})));

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

equation
  connect(outDamPos.x2, outDamMaxLimSig.y)
    annotation (Line(points={{-2,-34},{-30,-34},{-30,-50},{-78,-50}},color={0,0,127}));
  connect(outDamPos.x1, outDamMinLimSig.y)
    annotation (Line(points={{-2,-22},{-38,-22}}, color={0,0,127}));
  connect(outDamPos.f1, uOutDamPosMin)
    annotation (Line(points={{-2,-26},{-24,-26},{-24,-100},{-140,-100}},color={0,0,127}));
  connect(outDamPos.f2, uOutDamPosMax)
    annotation (Line(points={{-2,-38},{-20,-38},{-20,-66},{-108,-66},{-108,-50},{-140,-50}},
    color={0,0,127}));
  connect(retDamPos.x2, retDamMaxLimSig.y)
    annotation (Line(points={{-2,66},{-28,66},{-28,20},{-38,20}},color={0,0,127}));
  connect(retDamPos.x1, retDamConMinLimSig.y)
    annotation (Line(points={{-2,78},{-58,78}},color={0,0,127}));
  connect(retDamPos.f1, uRetDamPosMax)
    annotation (Line(points={{-2,74},{-48,74},{-48,100},{-140,100}},color={0,0,127}));
  connect(retDamPos.f2, uRetDamPosMin)
    annotation (Line(points={{-2,62},{-12,62},{-12,50},{-140,50}}, color={0,0,127}));
  connect(min.u2, uOutDamPosMax)
    annotation (Line(points={{58,-66},{-36,-66},{-36,-50},{-140,-50}},  color={0,0,127}));
  connect(min.u1, outDamPos.y)
    annotation (Line(points={{58,-54},{48,-54},{48,-30},{22,-30}}, color={0,0,127}));
  connect(max.u1, retDamPos.y)
    annotation (Line(points={{58,66},{30,66},{30,70},{22,70}}, color={0,0,127}));
  connect(uRetDamPosMin, max.u2)
    annotation (Line(points={{-140,50},{-12,50},{-12,54},{58,54}}, color={0,0,127}));
  connect(uTSup, retDamPos.u)
    annotation (Line(points={{-140,0},{-22,0},{-22,70},{-2,70}}, color={0,0,127}));
  connect(uTSup, outDamPos.u)
    annotation (Line(points={{-140,0},{-22,0},{-22,-30},{-2,-30}}, color={0,0,127}));

  connect(yOutDamPos, min.y)
    annotation (Line(points={{140,-60},{82,-60}}, color={0,0,127}));
  connect(max.y, yRetDamPos)
    annotation (Line(points={{82,60},{120,60}}, color={0,0,127}));
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
          extent={{-116,118},{-34,102}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position supply
air temperature control loop"),
        Text(
          extent={{-24,118},{24,106}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position
assignments"),
        Rectangle(
          extent={{52,118},{118,-118}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{54,118},{120,96}},
          lineColor={0,0,0},
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
Guidline 36 (G36), PART 5.N.2.c. Damper positions are linearly mapped to
the supply air control loop signal. This is a final sequence in the
composite multi zone VAV AHU economizer control sequence. Damper position
limits, which are the inputs to the sequence, are the outputs of
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits</a> and
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences.Enable</a>
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
<img alt=\"Image of the multi zone AHU modulation sequence control diagram\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/EconModulationControlDiagram.png\"/>
</p>
<p>
Multi zone AHU economizer modulation control chart:
<br/>
</p>
<p align=\"center\">
<img alt=\"Image of the multi zone AHU modulation sequence expected performance\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/EconModulationControlChart.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
April 24, 2021, by Michael Wetter:<br/>
Removed limit on time rate of change on damper signal.
The dampers model has already a delay which should make them sufficiently slow.
Adding this delay in the controller makes it harder to tune the controls.
This change also removed the parameter <code>samplePeriod</code>.
</li>
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
