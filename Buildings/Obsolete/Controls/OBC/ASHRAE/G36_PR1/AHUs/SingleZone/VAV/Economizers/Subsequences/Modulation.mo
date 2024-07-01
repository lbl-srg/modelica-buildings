within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences;
block Modulation "Outdoor and return air damper position modulation sequence for single zone VAV AHU"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Real k(final unit="1/K") = 1 "Gain of controller";
  parameter Real Ti(
    final unit="s",
    final quantity="Time")=300
    "Time constant of modulation controller integrator block"
    annotation (Dialog(
      enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for cooling control loop signal"
    annotation (Dialog(
      enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real uMin(
    final min=0.1,
    final max=0.9,
    final unit="1") = 0.1
    "Lower limit of controller output uTSup at which the dampers are at their limits";
  parameter Real uMax(
    final min=0.1,
    final max=1,
    final unit="1") = 0.9
    "Upper limit of controller output uTSup at which the dampers are at their limits";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-160,90},{-120,130}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature") "Supply air temperature heating setpoint"
    annotation (Placement(transformation(extent={{-160,60},{-120,100}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-160,-130},{-120,-90}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMin(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum economizer damper position limit as returned by the damper position limits sequence"
    annotation (Placement(transformation(extent={{-160,-90},{-120,-50}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMax(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum economizer damper position limit as returned by the economizer enable-disable sequence.
    If the economizer is disabled, this value equals uOutDamPosMin"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDamPosMin(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum return air damper position limit as returned by the economizer enable-disable sequence"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDamPosMax(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum return air damper position limit as returned by the economizer enable-disable sequence"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") "Heating coil control signal"
    annotation (Placement(transformation(extent={{120,30},{140,50}}),
      iconTransformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Economizer damper position"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}}),
      iconTransformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position"
    annotation (Placement(transformation(extent={{120,-10},{140,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Reals.PIDWithReset uTSup(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=1,
    final yMin=0)
    "Contoller that outputs a signal based on the error between the measured SAT and SAT heating setpoint"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant outDamMinLimSig(
      final k=uMin) "Minimal control loop signal for the outdoor air damper"
    annotation (Placement(transformation(extent={{-60,-88},{-40,-68}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant retDamMaxLimSig(
      final k=uMax) "Maximal control loop signal for the return air damper"
    annotation (Placement(transformation(extent={{-60,-34},{-40,-14}})));

  Buildings.Controls.OBC.CDL.Reals.Line outDamPos(
    final limitBelow=true,
    final limitAbove=true)
    "Damper position is linearly proportional to the control signal between signal limits"
    annotation (Placement(transformation(extent={{24,-50},{44,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Line retDamPos(
    final limitBelow=true,
    final limitAbove=true)
    "Damper position is linearly proportional to the control signal between signal limits"
    annotation (Placement(transformation(extent={{22,-10},{42,10}})));

  Buildings.Controls.OBC.CDL.Reals.Line HeaCoi(final limitBelow=true,
      final limitAbove=true)
    "Heating coil signal is linearly proportional to the control signal between signal limits"
    annotation (Placement(transformation(extent={{22,30},{42,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaCoiMaxLimSig(final k=1)
    "Maximal control loop signal for the heating coil"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaCoiMinLimSig(final k=0)
    "Minimum control loop signal for the heating coil"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant uMaxHeaCoi(final k=1)
    "Maximal control loop signal for the heating coil"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch enaDis "Enable or disable the heating coil"
    annotation (Placement(transformation(extent={{76,30},{96,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant Off(
    final k=0) "Off signal for heating coil"
    annotation (Placement(transformation(extent={{6,-90},{26,-70}})));

equation
  connect(retDamMaxLimSig.y,retDamPos. x2)
    annotation (Line(points={{-38,-24},{-12,-24},{-12,-4},{20,-4}},                 color={0,0,127}));
  connect(uTSup.y, retDamPos.u) annotation (Line(points={{-78,80},{4,80},{4,0},
          {20,0}},      color={0,0,127}));
  connect(uTSup.y, outDamPos.u) annotation (Line(points={{-78,80},{4,80},{4,-40},
          {22,-40}}, color={0,0,127}));
  connect(outDamMinLimSig.y, outDamPos.x1)
    annotation (Line(points={{-38,-78},{-8,-78},{-8,-32},{22,-32}},        color={0,0,127}));
  connect(retDamMaxLimSig.y, outDamPos.x2)
    annotation (Line(points={{-38,-24},{-12,-24},{-12,-44},{22,-44}},
                                                                color={0,0,127}));
  connect(outDamMinLimSig.y, retDamPos.x1)
    annotation (Line(points={{-38,-78},{-8,-78},{-8,8},{20,8}}, color={0,0,127}));
  connect(HeaCoi.u, retDamPos.u)
    annotation (Line(points={{20,40},{4,40},{4,0},{20,0}},   color={0,0,127}));
  connect(THeaSupSet, uTSup.u_s)
    annotation (Line(points={{-140,80},{-102,80}},color={0,0,127}));
  connect(TSup, uTSup.u_m) annotation (Line(points={{-140,110},{-108,110},{-108,
          60},{-90,60},{-90,68}}, color={0,0,127}));
  connect(heaCoiMinLimSig.y, HeaCoi.f1) annotation (Line(points={{-38,20},{-8,
          20},{-8,44},{20,44}},
                            color={0,0,127}));
  connect(heaCoiMaxLimSig.y, HeaCoi.f2) annotation (Line(points={{-38,60},{-4,
          60},{-4,32},{20,32}},
                            color={0,0,127}));
  connect(retDamMaxLimSig.y, HeaCoi.x1) annotation (Line(points={{-38,-24},{-12,
          -24},{-12,48},{20,48}},
                            color={0,0,127}));
  connect(uMaxHeaCoi.y, HeaCoi.x2) annotation (Line(points={{-38,100},{10,100},
          {10,36},{20,36}},
                    color={0,0,127}));
  connect(uOutDamPosMin, outDamPos.f2) annotation (Line(points={{-140,-70},{-92,
          -70},{-92,-48},{22,-48}}, color={0,0,127}));
  connect(uRetDamPosMin, retDamPos.f1)
    annotation (Line(points={{-140,0},{-2,0},{-2,4},{20,4}}, color={0,0,127}));
  connect(uRetDamPosMax, retDamPos.f2) annotation (Line(points={{-140,40},{-92,
          40},{-92,-8},{20,-8}},
                             color={0,0,127}));
  connect(Off.y, enaDis.u3) annotation (Line(points={{28,-80},{62,-80},{62,32},
          {74,32}}, color={0,0,127}));
  connect(uSupFan, enaDis.u2) annotation (Line(points={{-140,-110},{56,-110},{
          56,40},{74,40}}, color={255,0,255}));
  connect(HeaCoi.y, enaDis.u1) annotation (Line(points={{44,40},{50,40},{50,48},
          {74,48}}, color={0,0,127}));
  connect(enaDis.y, yHeaCoi)
    annotation (Line(points={{98,40},{130,40}}, color={0,0,127}));
  connect(uOutDamPosMax, outDamPos.f1) annotation (Line(points={{-140,-40},{-2,
          -40},{-2,-36},{22,-36}}, color={0,0,127}));
  connect(retDamPos.y, yRetDamPos)
    annotation (Line(points={{44,0},{130,0}}, color={0,0,127}));
  connect(outDamPos.y, yOutDamPos)
    annotation (Line(points={{46,-40},{130,-40}}, color={0,0,127}));
  connect(uSupFan, uTSup.trigger) annotation (Line(points={{-140,-110},{-96,-110},
          {-96,68}},       color={255,0,255}));
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
          textColor={0,0,127},
          textString="%name"),
        Line(
          points={{-50,-84},{-94,80}},
          color={0,0,127},
          thickness=0.5)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}}), graphics={
        Rectangle(
          extent={{-18,118},{118,-118}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-116,118},{-20,-118}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                   Text(
          extent={{-104,128},{-60,88}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position
supply air temperature
control loop"),                    Text(
          extent={{32,128},{76,88}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position
assignments and heating coil signal")}),
    Documentation(info="<html>
<p>
This is a single zone VAV AHU economizer modulation block. It calculates
the outdoor and return air damper positions based on the single zone VAV AHU
supply air temperature control loop signal. Economizer dampers are modulated
based on the calculated heating supply air temperature setpoint.
The implementation is in line with ASHRAE
Guidline 36 (G36), PART 5.P.3.b. Damper positions are linearly mapped to
the supply air control loop signal. This is a final sequence in the
composite single zone VAV AHU economizer control sequence. Damper position
limits, which are the inputs to the sequence, are the outputs of
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits</a> and
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable</a>
sequences.
</p>
<p>
When the economizer is enabled, the PI controller modulates the damper
positions. Return and outdoor damper are not interlocked. When the economizer is disabled,
the damper positions are set to the minimum outdoor air damper position limits.
</p>
<p>
The figures below show the input-output structure and an economizer damper
modulation sequence assuming a well configured controller. 
</p>
<p>
Control diagram:
</p>
<p align=\"center\">
<img alt=\"Image of the single zone AHU modulation sequence control diagram\"
src=\"modelica://Buildings/Resources/Images/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/Economizers/Subsequences/ModulationControlDiagram.png\"/>
</p>
<p>
Single zone AHU economizer modulation control chart:
<br/>
</p>
<p align=\"center\">
<img alt=\"Image of the single zone AHU modulation sequence expected performance\"
src=\"modelica://Buildings/Resources/Images/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/Economizers/Subsequences/ModulationControlChart.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
July 29, 2019, by Kun Zhang:<br/>
Reimplemented economizer modulation control sequence.
</li>
<li>
October 31, 2018, by David Blum:<br/>
Added heating coil output.
</li>
<li>
October 19, 2017, by Jianjun Hu:<br/>
Changed name of controller output limit from <code>yMin</code> and <code>yMax</code> to <code>uMin</code> and <code>uMax</code>.
</li>
<li>
July 07, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Modulation;
