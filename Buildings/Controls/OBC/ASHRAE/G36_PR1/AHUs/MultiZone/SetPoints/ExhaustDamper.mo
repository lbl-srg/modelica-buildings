within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints;
block ExhaustDamper
  "Control of actuated exhaust air dampers without fans"

  parameter Modelica.SIunits.PressureDifference dpBuiSet(
    displayUnit="Pa",
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
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan "Supply fan status"
    annotation (Placement(transformation(extent={{-120,-50},{-80,-10}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yExhDam(
     final unit="1",
     min=0,
     max=1)
    "Exhaust damper control signal (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

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
  Buildings.Controls.OBC.CDL.Continuous.LimPID conP(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final k=k,
    yMax=1,
    yMin=0) "Building static pressure controller"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
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
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiNor(
    final k=1/dpBuiSet)
    "Gain to normalize the control error"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(
    final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

equation
  connect(uFan, swi.u2)
    annotation (Line(points={{-100,-30},{38,-30}}, color={255,0,255}));
  connect(zerDam.y, swi.u3)
    annotation (Line(points={{-39,-60},{20,-60},{20,-38},{38,-38}},
      color={0,0,127}));
  connect(swi.y, yExhDam)
    annotation (Line(points={{61,-30},{72,-30},{72,0},{90,0}},
      color={0,0,127}));
  connect(dpBui, movMea.u)
    annotation (Line(points={{-100,60},{-62,60}}, color={0,0,127}));
  connect(movMea.y, conErr.u1)
    annotation (Line(points={{-39,60},{-32,60}}, color={0,0,127}));
  connect(conErr.y, gaiNor.u)
    annotation (Line(points={{-9,60},{-2,60}},color={0,0,127}));
  connect(gaiNor.y, conP.u_s)
    annotation (Line(points={{21,60},{38,60}}, color={0,0,127}));
  connect(dpBuiSetPoi1.y, conErr.u2)
    annotation (Line(points={{-39,20},{-20,20},{-20,48}}, color={0,0,127}));
  connect(zer1.y, conP.u_m)
    annotation (Line(points={{21,20},{50,20},{50,48}}, color={0,0,127}));
  connect(conP.y, swi.u1)
    annotation (Line(points={{61,60},{66,60},{66,0},{20,0},{20,-22},{38,-22}},
      color={0,0,127}));

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
          textString="uFan"),
        Text(
          extent={{52,16},{96,-18}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yExhDam"),
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
Control sequence for actuated exhaust damper <code>yExhDam</code>
without fans. It is implemented according to ASHRAE Guidline 35 (G36), PART5.N.8.
(for multi zone VAV AHU), PART5.P.6 and PART3.2B.3 (for single zone VAV AHU).
</p>
<h4>Multi zone VAV AHU: Control of actuated exhaust dampers without fans (PART5.N.8)</h4>
<ol>
<li>The exhaust damper is enabled when the associated supply fan is proven on
<code>uFan = true</code>, and disabled otherwise.</li>
<li>When enabled, a P-only control loop modulates the exhaust damper to maintain
a building static pressure of <code>dpBui</code>, which is by default <i>12</i> Pa (<i>0.05</i> inchWC).
</li>
<li>
When <code>uFan = false</code>, the damper is closed.
</li>
</ol>
</html>", revisions="<html>
<ul>
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
