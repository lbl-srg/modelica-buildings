within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints;
block ReturnFanDirectPressure
  "Return fan control with direct building pressure control"

  parameter Modelica.SIunits.PressureDifference dpBuiSet(
    displayUnit="Pa",
    max=30) = 12
    "Building static pressure difference relative to ambient (positive to pressurize the building)";
  parameter Modelica.SIunits.PressureDifference dpDisMin(
    displayUnit="Pa",
    final min=0,
    final max=1000) = 2.4
    "Minimum return fan discharge static pressure difference setpoint";
  parameter Modelica.SIunits.PressureDifference dpDisMax(
    displayUnit="Pa",
    final min=0,
    final max=1000) = 40
    "Maximum return fan discharge static pressure setpoint";
  parameter Real k(final unit="1") = 1
    "Gain, normalized using dpBuiSet";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpBui(
    final unit="Pa",
    displayUnit="Pa")
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{-180,70},{-140,110}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Fan on/off signal, true if fan is on" annotation (Placement(transformation(
          extent={{-180,-110},{-140,-70}}), iconTransformation(extent={{-140,-80},
            {-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpDisSet(
     final unit="Pa",
     displayUnit="Pa",
     min=0)
    "Return fan discharge static pressure setpoint"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}}),
      iconTransformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yExhDam(
     final unit="1",
     min=0,
     max=1)
    "Exhaust damper control signal (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{120,70},{140,90}}),
      iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback conErr(
     u1(final unit="Pa", displayUnit="Pa"),
     u2(final unit="Pa", displayUnit="Pa"),
     y( final unit="Pa", displayUnit="Pa"))
     "Control error"
    annotation (Placement(transformation(extent={{-98,80},{-78,100}})));

  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(
    delta=300)
    "Average building static pressure measurement"
    annotation (Placement(transformation(extent={{-130,80},{-110,100}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID conP(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final k=k,
    yMax=1,
    yMin=0) "Building static pressure controller"
    annotation (Placement(transformation(extent={{-36,80},{-16,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Line linExhAirDam
    "Exhaust air damper position"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Line linRetFanStaPre
    "Return fan static pressure setpoint"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Exhaust air damper position"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Return fan discharge static pressure setpoint"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpBuiSetPoi(
    final k=dpBuiSet) "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-130,50},{-110,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retFanDisPreMin(
    final k=dpDisMin) "Return fan discharge static pressure minimum setpoint"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retFanDisPreMax(
    final k=dpDisMax) "Return fan discharge static pressure maximum setpoint"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Zero fan control signal"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-68,42},{-48,62}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0.5)
    "Constant 0.5"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{0,26},{20,46}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiNor(
    final k=1/dpBuiSet)
    "Gain to normalize the control error"
    annotation (Placement(transformation(extent={{-66,80},{-46,100}})));

equation
  connect(movMea.u, dpBui)
    annotation (Line(points={{-132,90},{-160,90}}, color={0,0,127}));
  connect(swi.u2, uFan)
    annotation (Line(points={{78,-90},{-160,-90}}, color={255,0,255}));
  connect(swi.u3, zer.y)
    annotation (Line(points={{78,-98},{60,-98},{60,-110},{21,-110}}, color={0,0,127}));
  connect(zer1.y, linExhAirDam.x1)
    annotation (Line(points={{-47,52},{30,52},{30,98},{58,98}},  color={0,0,127}));
  connect(zer1.y, linExhAirDam.f1)
    annotation (Line(points={{-47,52},{30,52},{30,94},{58,94}},  color={0,0,127}));
  connect(con.y, linExhAirDam.x2)
    annotation (Line(points={{21,70},{40,70},{40,86},{58,86}}, color={0,0,127}));
  connect(one.y, linExhAirDam.f2)
    annotation (Line(points={{21,36},{46,36},{46,82},{58,82}}, color={0,0,127}));
  connect(con.y, linRetFanStaPre.x1)
    annotation (Line(points={{21,70},{40,70},{40,-32},{58,-32}}, color={0,0,127}));
  connect(one.y, linRetFanStaPre.x2)
    annotation (Line(points={{21,36},{46,36},{46,-44},{58,-44}}, color={0,0,127}));
  connect(retFanDisPreMin.y, linRetFanStaPre.f1)
    annotation (Line(points={{21,-20},{30,-20},{30,-36},{58,-36}},
      color={0,0,127}));
  connect(retFanDisPreMax.y, linRetFanStaPre.f2)
    annotation (Line(points={{21,-70},{30,-70},{30,-48},{58,-48}},
      color={0,0,127}));
  connect(linRetFanStaPre.y, swi.u1)
    annotation (Line(points={{81,-40},{100,-40},{100,-60},{60,-60},{60,-82},
      {78,-82}}, color={0,0,127}));
  connect(uFan, swi1.u2) annotation (Line(points={{-160,-90},{-100,-90},{-100,20},
          {78,20}}, color={255,0,255}));
  connect(linExhAirDam.y, swi1.u1)
    annotation (Line(points={{81,90},{100,90},{100,70},{60,70},{60,28},{78,28}},
      color={0,0,127}));
  connect(swi1.y, yExhDam)
    annotation (Line(points={{101,20},{108,20},{108,80},{130,80}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{-47,52},{30,52},{30,12},{78,12}},
      color={0,0,127}));
  connect(swi.y, dpDisSet)
    annotation (Line(points={{101,-90},{106,-90},{106,-80},{130,-80}},
      color={0,0,127}));
  connect(conP.y, linExhAirDam.u)
    annotation (Line(points={{-15,90},{58,90}}, color={0,0,127}));
  connect(conP.y, linRetFanStaPre.u)
    annotation (Line(points={{-15,90},{-10,90},{-10,-40},{58,-40}}, color={0,0,127}));
  connect(movMea.y, conErr.u1)
    annotation (Line(points={{-109,90},{-100,90}}, color={0,0,127}));
  connect(dpBuiSetPoi.y, conErr.u2)
    annotation (Line(points={{-109,60},{-88,60},{-88,78}}, color={0,0,127}));
  connect(conErr.y, gaiNor.u)
    annotation (Line(points={{-77,90},{-68,90}}, color={0,0,127}));
  connect(gaiNor.y, conP.u_s)
    annotation (Line(points={{-45,90},{-38,90}}, color={0,0,127}));
  connect(conP.u_m, zer1.y)
    annotation (Line(points={{-26,78},{-26,52},{-47,52}}, color={0,0,127}));

annotation (
  defaultComponentName="buiPreCon",
  Icon(graphics={
        Text(extent={{-98,142},{102,102}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-78,52},{-78,-32},{78,-32},{78,52},{78,52}}, color={28,108,
              200}),
        Line(
          points={{-78,-32},{4,52}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{4,-32},{78,52}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Text(
          extent={{-50,-36},{60,-62}},
          lineColor={28,108,200},
          textString="Building pressure control loop signal")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{120,140}}),
        graphics={
        Rectangle(
          extent={{-138,138},{118,4}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-138,-4},{118,-138}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-134,132},{-58,114}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Exhaust air damper control"),
        Text(
          extent={{-136,-98},{-12,-120}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Return fan discharge static pressure setpoint")}),
  Documentation(info="<html>
<p>
Setpoint for return fan discharge pressure and exhaust air damper
for a multi zone VAV AHU according to ASHRAE guideline G36,
PART5.N.10 (return fan control with direct building pressure).
</p>
<ol>
<li>
<p>Return fan operates whenever associated supply fan is proven on and is
off otherwise.</p>
</li>
<li>
<p>Return fan is controlled to maintain return fan discharge static pressure
at setpoint <code>dpBuiSet</code>.</p>
</li>
<li>
<p>Exhaust damper is only enabled when the associated supply and return
fans are proven on (<code>uFan=true</code>) and the minimum outdoor air damper is open
(to be controlled in a separate sequence).
The exhaust dampers is closed when the fan is disabled.</p>
</li>
<li>
<p>The building static pressure is time averaged with a sliding 5-minute window
to dampen fluctuations. The averaged value shall be displayed and is used
for control.</p>
</li>
<li>
<p>When the exhaust damper is enabled, a control loop modulates the exhaust damper
in sequence with the return fan static pressure setpoint as shown in the figure
below to maintain the building pressure equal to <code>dpBuiSet</code>,
which is by default <i>12</i> Pa (<i>0.05</i> inches).
</p>
</li>
</ol>
<p>
The output signal of the building pressure control is as follows:
</p>
<ol>
<li>
From <i>0</i> to <i>0.5</i>, the building pressure control loop modulates the exhaust
dampers from <code>yExhDam = 0</code> (closed) to <code>yExhDam = 1</code> (open).
</li>
<li>
From <i>0.5</i> to <i>1</i>, the building pressure control loop resets the return fan
discharge static pressure setpoint from <code>dpDisMin</code>
to <code>dpDisMax</code>. The <code>dpDisMin</code> and
<code>dpDisMax</code> are specified in Section G36 PART 3.2A.3.b.
</li>
</ol>
<p align=\"center\">
<img alt=\"Image of return fan control for multi zone AHU\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/ReturnFanControlWithPressure.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
October 16, 2017, by Michael Wetter:<br/>
Revised implementation, normalized control input
and updated documentation.
</li>
<li>
October 16, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReturnFanDirectPressure;
