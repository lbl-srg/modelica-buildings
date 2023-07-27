within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations;
block ReturnFan
  "Modulates dampers of economizer in buildings using return fan to control the pressure"

  parameter Boolean have_dirCon=true
    "True: the building have direct pressure control"
    annotation (__cdl(ValueInReference=false));
  parameter Real uMin(
    final max=0,
    final unit="1")=-0.25
    "Lower limit of controller input when outdoor damper opens (see diagram)"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Commissioning", group="Controller"));
  parameter Real uMax(
    final min=0,
    final unit="1")=+0.25
    "Upper limit of controller input when return damper is closed (see diagram)"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Commissioning", group="Controller"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTSup(
    final unit="1")
    "Supply air temperature control loop signal"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDam_max(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum return air damper position limit as returned by the economizer enable-disable sequence"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetDam_min(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum return air damper position limit as returned by the economizer enable-disable sequence"
    annotation (Placement(transformation(extent={{-160,-10},{-120,30}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDam(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position"
    annotation (Placement(transformation(extent={{120,20},{160,60}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelDam(
    final min=0,
    final max=1,
    final unit="1") if not have_dirCon
    "Relief air damper position"
    annotation (Placement(transformation(extent={{120,-70},{160,-30}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDam(
    final min=0,
    final max=1,
    final unit="1") "Outdoor air damper position"
    annotation (Placement(transformation(extent={{120,-120},{160,-80}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant damMinLimSig(
    final k=uMin)
    "Minimal control loop signal for the relief and return air damper position"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant damMaxLimSig(
    final k=uMax)
    "Maximal control loop signal for the return and exhast air damper"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Line retDamPos(
    final limitBelow=true,
    final limitAbove=true) "Return air damper position"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Line relDamPos(
    final limitBelow=true,
    final limitAbove=true) if not have_dirCon
    "Relief air damper position"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0) if not have_dirCon
    "Constant zero"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

equation
  connect(damMinLimSig.y, retDamPos.x1) annotation (Line(points={{-78,-20},{-60,
          -20},{-60,48},{38,48}}, color={0,0,127}));
  connect(uRetDam_max, retDamPos.f1) annotation (Line(points={{-140,60},{-80,60},
          {-80,44},{38,44}}, color={0,0,127}));
  connect(damMaxLimSig.y, retDamPos.x2) annotation (Line(points={{-18,-20},{0,-20},
          {0,36},{38,36}}, color={0,0,127}));
  connect(uRetDam_min, retDamPos.f2) annotation (Line(points={{-140,10},{-80,10},
          {-80,32},{38,32}}, color={0,0,127}));
  connect(damMinLimSig.y, relDamPos.x1) annotation (Line(points={{-78,-20},{-60,
          -20},{-60,-42},{38,-42}}, color={0,0,127}));
  connect(zer.y, relDamPos.f1) annotation (Line(points={{-78,-90},{-60,-90},{-60,
          -46},{38,-46}}, color={0,0,127}));
  connect(damMaxLimSig.y, relDamPos.x2) annotation (Line(points={{-18,-20},{0,-20},
          {0,-54},{38,-54}}, color={0,0,127}));
  connect(one.y, relDamPos.f2) annotation (Line(points={{-18,-90},{0,-90},{0,-58},
          {38,-58}}, color={0,0,127}));
  connect(uTSup, retDamPos.u) annotation (Line(points={{-140,100},{20,100},{20,40},
          {38,40}}, color={0,0,127}));
  connect(uTSup, relDamPos.u) annotation (Line(points={{-140,100},{20,100},{20,-50},
          {38,-50}}, color={0,0,127}));
  connect(one.y, yOutDam) annotation (Line(points={{-18,-90},{0,-90},{0,-100},
          {140,-100}}, color={0,0,127}));
  connect(retDamPos.y, yRetDam)
    annotation (Line(points={{62,40},{140,40}}, color={0,0,127}));
  connect(relDamPos.y, yRelDam)
    annotation (Line(points={{62,-50},{140,-50}}, color={0,0,127}));
annotation (defaultComponentName="ecoMod",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
                 Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Line(
          points={{-84,76},{-42,76},{40,-66},{110,-66}},
          color={0,0,127},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(
          points={{-82,-74},{-40,-74},{40,80},{92,80}},
          color={0,0,127},
          thickness=0.5),
        Text(
          extent={{-98,68},{-72,52}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uTSup"),
        Text(
          extent={{-98,10},{-44,-8}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uRetDam_max"),
        Text(
          extent={{-98,-50},{-44,-68}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uRetDam_min"),
        Text(
          extent={{60,68},{98,52}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yRetDam"),
        Text(
          extent={{58,10},{98,-8}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yRelDam"),
        Text(
          extent={{58,-50},{98,-68}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yOutDam")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
  Documentation(info="<html>
<p>
Block modulates the damper of economizers of buildings with pressure controlled by
return fan and airflow tracking. It is implemented according to Section 5.16.2.3.d,
Figure 5.16.2.3-2 and Figure 5.16.2.3-3 of ASHRAE Guideline 36, May 2020.
</p>
<p>
Return air damper position limits, which are the inputs to the sequence, are the outputs of
sequences in package
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits</a>.
It also requires input <code>uTSup</code> from
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplySignals\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplySignals</a>
sequences.
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
The modulation is shown as the control chart:
<br/>
</p>
<p align=\"center\">
<img alt=\"Image of the damper modulation for economizer in buildings with pressure controller by return fan\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/Economizers/Subsequences/Modulations/ReturnFan.png\"/>
</p>
<p>
Note in the above chart, if the building has direct pressure control
(<code>have_dirCon</code>), the profile for relief air damper control should
be ignored.
</p>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReturnFan;
