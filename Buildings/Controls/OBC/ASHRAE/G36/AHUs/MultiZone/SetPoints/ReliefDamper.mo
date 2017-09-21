within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.SetPoints;
block ReliefDamper "Control of actuated relief  dampers without fans"
  parameter Modelica.SIunits.Pressure buiPreSet=0.05*248.84
    "Building static pressure setpoint"
    annotation(Evaluate=true);
  parameter Real kp(min=0, unit="1") = 0.5
    "Gain factor"
    annotation(Dialog(group="Relief damper P-control parameter"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBuiPre(
    final unit="Pa",
    quantity="PressureDifference")
    "Measured building static pressure"
    annotation (Placement(transformation(extent={{-120,0},{-80,40}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-120,-40},{-80,0}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelDamPos(
    min=0, max=1, unit="1")
    "Relief damper position"
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerDam(
    final k=0)
    "Close damper when disabled"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant buiPreSetpoint(
    final k=buiPreSet)
    "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID damPosController(
    final yMax=1,
    final yMin=0,
    Td=0.1,
    Nd=1,
    Ti=300,
    final k=kp,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P)
    "Contoller that outputs a signal based on the error between the measured "
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Check if relief damper should be activated"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(buiPreSetpoint.y, damPosController.u_s)
    annotation (Line(points={{-39,40},{-22,40}}, color={0,0,127}));
  connect(uBuiPre, damPosController.u_m)
    annotation (Line(points={{-100,20},{-10,20},{-10,28}},
      color={0,0,127}));
  connect(uSupFan, swi.u2)
    annotation (Line(points={{-100,-20},{-32,-20},{-32,0},{38,0}},
      color={255,0,255}));
  connect(damPosController.y, swi.u1)
    annotation (Line(points={{1,40},{20,40},{20,8},{38,8}},
      color={0,0,127}));
  connect(zerDam.y, swi.u3)
    annotation (Line(points={{-39,-40},{20,-40},{20,-8},{38,-8}},
      color={0,0,127}));
  connect(swi.y, yRelDamPos)
    annotation (Line(points={{61,0},{90,0}},  color={0,0,127}));

annotation (
  defaultComponentName = "reliefDamper_multiZone",
  Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,78},{-56,42}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uBuiPre"),
        Text(
          extent={{-96,-42},{-52,-78}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uSupFan"),
        Text(
          extent={{34,22},{96,-18}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRelDamPos"),
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
    Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-80,-80},{80,80}})),
 Documentation(info="<html>      
<p>
This sequence controls actuated relief dampers (<code>yRelDamPos</code>) 
without fans. It is implemented according to ASHRAE Guidline 35 (G36), PART5.N.8. 
(for multiple zone VAV AHU), PART5.P.6 and PART3.2B.3 (for single zone VAV AHU).
</p>   
<h4>Multiple zone VAV AHU: Control of actuated relief dampers without fans(PART5.N.8)</h4>
<ol>
<li>Relief dampers shall be enabled when the associated supply fan is proven on 
(<code>uSupFan = true</code>), and disabled otherwise.</li>
<li>When enabled, use a P-only control loop to modulate relief dampers to maintain 
0.05” (12 Pa) building static pressure (<code>uBuiPre</code>). 
Close damper when disabled.</li>
</ol>
<p align=\"center\">
<img alt=\"Image of relief damper control diagram for multiple zone AHU\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHUs/ReliefDamperControlDiagram_MultiZone.png\"/>
</p>
<h4>References</h4>
<p>
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR.
<i>ASHRAE Guideline 36P, High Performance Sequences of Operation for HVAC
systems</i>. First Public Review Draft (June 2016)</a>
</p>
</html>", revisions="<html>
<ul>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReliefDamper;
