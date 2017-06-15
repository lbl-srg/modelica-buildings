within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block ActuatedReliefDamperWithoutFan_MultiZone
  "Control of actuated relief  dampers without fans"
  parameter Modelica.SIunits.Pressure buiPreSet=
      0.05*248.84 "Building static pressure setpoint"
    annotation(Evaluate=true, Dialog(group="For Multi-Zone AHU",enable = (numOfZon>1)));
  parameter Real kp(min=0, unit="1") = 0.5 "Gain of P-controller";

  CDL.Continuous.Constant zerDam(k=0) "Close damper when disabled"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  CDL.Continuous.Constant buiPreSetpoint(k=buiPreSet)
    "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  CDL.Continuous.LimPID damPosController(
    yMax=1,
    yMin=0,
    Td=0.1,
    Nd=1,
    Ti=300,
    k=kp,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.P)
    "Contoller that outputs a signal based on the error between the measured "
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  CDL.Interfaces.RealInput uBuiPre(unit="Pa")
    "Measured building static pressure"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
                             iconTransformation(extent={{-120,50},{-100,70}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-140,
            -20},{-100,20}}), iconTransformation(extent={{-120,-70},{-100,-50}})));
  CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  CDL.Interfaces.RealOutput yRelDamPos "Relief damper position"
    annotation (
      Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(
          extent={{100,-10},{120,10}})));

equation
  connect(buiPreSetpoint.y, damPosController.u_s)
    annotation (Line(points={{-59,60},{-59,60},{-42,60}}, color={0,0,127}));
  connect(uBuiPre, damPosController.u_m) annotation (Line(points={{-120,40},{-64,
          40},{-30,40},{-30,48}}, color={0,0,127}));
  connect(uSupFan, swi.u2)
    annotation (Line(points={{-120,0},{18,0}},         color={255,0,255}));
  connect(damPosController.y, swi.u1)
    annotation (Line(points={{-19,60},{0,60},{0,8},{18,8}}, color={0,0,127}));
  connect(zerDam.y, swi.u3) annotation (Line(points={{-59,-20},{0,-20},{0,-8},{18,
          -8}},     color={0,0,127}));
  connect(swi.y, yRelDamPos)
    annotation (Line(points={{41,0},{110,0}},         color={0,0,127}));
  annotation (Icon(graphics={
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
          extent={{-98,126},{98,104}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{60,100}})),
 Documentation(info="<html>      
<p>
This atomic sequence controls actuated relief dampers (<code>yRelDamPos</code>) without fans. It is implemented according to ASHRAE Guidline 35 (G36), PART5.N.8. (for multiple zone VAV AHU), 
PART5.P.6 and PART3.2B.3 (for single zone VAV AHU).
</p>   
<h4>Multiple zone VAV AHU: Control of actuated relief dampers without fans(PART5.N.8)</h4>
<ol>
<li>Relief dampers shall be enabled when the associated supply fan is proven on (<code>uSupFan = true</code>), and disabled otherwise.</li>
<li>When enabled, use a P-only control loop to modulate relief dampers to maintain 0.05” (12 Pa) building static pressure (<code>uBuiPre</code>). Close damper when disabled.</li>
</ol>
<p align=\"center\">
<img alt=\"Image of the modulation sequence control diagram\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/ActuatedReliefDamperWithoutFanControlDiagram_MultiZone.png\"/>
</p>

</html>", revisions="<html>
<ul>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ActuatedReliefDamperWithoutFan_MultiZone;
