within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints;
block ExhaustDamper
  "Control of actuated exhaust air dampers without fans"

  parameter Real dpBuiSet(
    final unit="Pa",
    final quantity="PressureDifference",
    max=30) = 12
    "Building static pressure difference relative to ambient (positive to pressurize the building)";
  parameter Real k(min=0, unit="1") = 0.5
    "Gain, applied to building pressure control error normalized with dpBuiSet"
    annotation(Dialog(group="Exhaust damper P-control parameter"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpBui(
    final unit="Pa",
    displayUnit="Pa")
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-120,-50},{-80,-10}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yExhDamPos(
     final unit="1",
     min=0,
     max=1)
    "Exhaust damper control signal (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{80,-20},{120,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(
    delta=300)
    "Average building static pressure measurement"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback conErr(
    u1(final unit="Pa", displayUnit="Pa"),
    u2(final unit="Pa", displayUnit="Pa"),
    y(final unit="Pa", displayUnit="Pa"))
    "Control error"
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conP(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final k=k,
    final r=dpBuiSet)
               "Building static pressure controller"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Check if exhaust damper should be activated"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerDam(
    final k=0)
    "Close damper when disabled"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpBuiSetPoi1(
    final k=dpBuiSet)
    "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(
    final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

equation
  connect(uSupFan, swi.u2)
    annotation (Line(points={{-100,-30},{38,-30}}, color={255,0,255}));
  connect(zerDam.y, swi.u3)
    annotation (Line(points={{-38,-60},{20,-60},{20,-38},{38,-38}},
      color={0,0,127}));
  connect(swi.y, yExhDamPos)
    annotation (Line(points={{62,-30},{72,-30},{72,0},{100,0}},
      color={0,0,127}));
  connect(dpBui, movMea.u)
    annotation (Line(points={{-100,60},{-62,60}}, color={0,0,127}));
  connect(movMea.y, conErr.u1)
    annotation (Line(points={{-38,60},{-32,60}}, color={0,0,127}));
  connect(dpBuiSetPoi1.y, conErr.u2)
    annotation (Line(points={{-38,20},{-20,20},{-20,48}}, color={0,0,127}));
  connect(zer1.y, conP.u_m)
    annotation (Line(points={{22,20},{30,20},{30,48}}, color={0,0,127}));
  connect(conP.y, swi.u1)
    annotation (Line(points={{42,60},{66,60},{66,0},{20,0},{20,-22},{38,-22}},
      color={0,0,127}));

  connect(conErr.y, conP.u_s)
    annotation (Line(points={{-8,60},{18,60}}, color={0,0,127}));
annotation (
  defaultComponentName = "exhDam",
  Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-94,74},{-64,46}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="dpBui"),
        Text(
          extent={{-94,-48},{-70,-70}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uSupFan"),
        Text(
          extent={{52,16},{96,-18}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yExhDamPos"),
        Polygon(
          points={{-80,92},{-88,70},{-72,70},{-80,92}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,80},{-80,-88}}, color={192,192,192}),
        Line(points={{-90,-78},{82,-78}}, color={192,192,192}),
        Polygon(
          points={{90,-78},{68,-70},{68,-86},{90,-78}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-78},{-80,-78},{14,62},{80,62}}, color={0,0,127}),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,-80},{80,80}})),
 Documentation(info="<html>
<p>
Control sequence for actuated exhaust damper <code>yExhDamPos</code>
without fans. It is implemented according to ASHRAE Guidline 35 (G36), PART 5.N.8.
(for multi zone VAV AHU), PART 5.P.6 and PART3.2B.3 (for single zone VAV AHU).
</p>
<h4>Multi zone VAV AHU: Control of actuated exhaust dampers without fans (PART 5.N.8)</h4>
<ol>
<li>The exhaust damper is enabled when the associated supply fan is proven on
<code>uSupFan = true</code>, and disabled otherwise.</li>
<li>When enabled, a P-only control loop modulates the exhaust damper to maintain
a building static pressure of <code>dpBui</code>, which is by default <i>12</i> Pa (<i>0.05</i> inchWC).
</li>
<li>
When <code>uSupFan = false</code>, the damper is closed.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
October 15, 2020, by Michael Wetter:<br/>
Moved normalization of control error to PID controller.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2182\">#2182</a>.
</li>
<li>
October 17, 2017, by Jianjun Hu:<br/>
Changed model name.
</li>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExhaustDamper;
