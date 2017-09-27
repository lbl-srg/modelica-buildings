within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints;
block ReliefDamper "Control of actuated relief  dampers without fans"
  parameter Real minRelDamPos(
    min=0,
    max=1,
    final unit="1") = 0.1
    "Relief damper position maintaining building static pressure at setpoint when the system is at minPosMin"
    annotation(Evaluate=true, Dialog(group="Nominal parameters"));
  parameter Real maxRelDamPos(
    min=0,
    max=1,
    final unit="1") = 0.9
    "Relief damper position maintaining building static pressure at setpoint when outdoor air damper is fully open and fan speed is at cooling maximum"
    annotation(Evaluate=true, Dialog(group="Nominal parameters"));
  parameter Real minPosMin(
    min=0,
    max=1,
    final unit="1")=0.4
    "Outdoor air damper position when fan operating at minimum speed to supply minimum outdoor air flow"
    annotation(Evaluate=true, Dialog(group="Nominal parameters"));
  parameter Real outDamPhyPosMax(
    min=0,
    max=1,
    final unit="1")=1
    "Physical or at the comissioning fixed maximum position of the outdoor air damper"
    annotation(Evaluate=true, Dialog(group="Nominal parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPos(
    min=0,
    max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelDamPos(
    min=0,
    max=1,
    final unit="1")
    "Relief damper position"
    annotation (Placement(transformation(extent={{120,-10},{140,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Line relDamPos(
    limitBelow=true,
    limitAbove=true)
    "Linearly map relief damper position to the outdoor air damper position"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Check if relief damper should be open"
    annotation (Placement(transformation(extent={{60,60},{80,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis greThr(
    final uLow=0.02,
    final uHigh=0.05)
    "Check if outdoor air damper is open"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if relief damper should be activated"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerDam(
    final k=0)
    "Close damper when disabled"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minRelDam(
    final k=minRelDamPos)
    "Relief damper position maintaining building static pressure at setpoint while the system is at minPosMin"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxRelDam(
    final k=maxRelDamPos)
    "Relief damper position maintaining building static pressure at setpoint when outdoor air damper is fully open and fan speed is at cooling maximum"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minPosAtMinSpd(
    final k=minPosMin)
    "Outdoor air damper position when fan operating at minimum speed to supply minimum outdoor air flow"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPhyPosMaxSig(
    final k=outDamPhyPosMax)
    "Physical or at the comissioning fixed maximum position of the outdoor air damper"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

equation
  connect(outDamPhyPosMaxSig.y, relDamPos.x2)
    annotation (Line(points={{-19,-60},{4,-60},{4,-4},{18,-4}},
      color={0,0,127}));
  connect(maxRelDam.y, relDamPos.f2)
    annotation (Line(points={{-59,-80},{12,-80},{12,-8},{18,-8}},
      color={0,0,127}));
  connect(uOutDamPos, relDamPos.u)
    annotation (Line(points={{-120,0},{18,0}},
      color={0,0,127}));
  connect(zerDam.y, swi1.u3)
    annotation (Line(points={{1,80},{20,80},{20,58},{58,58}},
      color={0,0,127}));
  connect(greThr.y, and2.u2)
    annotation (Line(points={{-39,20},{-32,20},{-32,42},{-22,42}},
      color={255,0,255}));
  connect(uSupFan, and2.u1)
    annotation (Line(points={{-120,60},{-80,60},{-80,50},{-22,50}},
      color={255,0,255}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{1,50},{58,50}},
      color={255,0,255}));
  connect(relDamPos.y, swi1.u1)
    annotation (Line(points={{41,0},{48,0},{48,42},{58,42}},
      color={0,0,127}));
  connect(uOutDamPos, greThr.u)
    annotation (Line(points={{-120,0},{-80,0},{-80,20},{-62,20}},
      color={0,0,127}));
  connect(minPosAtMinSpd.y, relDamPos.x1)
    annotation (Line(points={{-19,-20},{-12,-20},{-12,8},{18,8}},
      color={0,0,127}));
  connect(minRelDam.y, relDamPos.f1)
    annotation (Line(points={{-59,-40},{-4,-40},{-4,4},{18,4}},
      color={0,0,127}));
  connect(swi1.y, yRelDamPos)
    annotation (Line(points={{81,50},{100,50},{100,0},{130,0}},
      color={0,0,127}));

annotation (
  defaultComponentName = "relDam",
  Icon(graphics={Rectangle(
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
          points={{-46,92},{-54,70},{-38,70},{-46,92}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-46,82},{-46,-86}}, color={192,192,192}),
        Line(points={{-56,-78},{68,-78}}, color={192,192,192}),
        Polygon(
          points={{72,-78},{50,-70},{50,-86},{72,-78}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-46,-78},{14,62},{80,62}},           color={0,0,127}),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name")}),
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{120,
            100}})),
 Documentation(info="<html>      
<p>
Control sequence for relief dampers 
without fans. It is implemented according to ASHRAE Guidline 35 (G36), PART5.N.8. 
(for multi zone VAV AHU), PART5.P.6 and PART3.2B.3 (for single zone VAV AHU).
</p>   

<h4>Single zone VAV AHU: Control of actuated relief dampers without fans (PART5.P.6)</h4>
<ol>
<li>Relief damper position setpoints (PART3.2B.3)
<ul>
<li><code>minRelDamPos</code>: The relief damper position that maintains a building 
pressure of <i>0.05</i> inchWC (<i>12</i> while the system is at <code>minPosMin</code> 
(i.e., the economizer damper is positioned to provide <code>minOA</code> while 
the supply fan is at minimum speed).</li>
<li><code>maxRelDamPos</code>: The relief damper position that maintains a building 
pressure of <i>0.05</i> inchWC (<i>12</i> Pa) while the economizer damper is fully open and the fan 
speed is at cooling maximum.</li>
</ul>
</li>
<li>Relief dampers shall be enabled when the associated supply fan is proven on and 
any outdoor air damper is open <code>uOutDamPos &gt; 0</code> and disabled and closed 
otherwise.</li>
<li>Relief damper position shall be reset linearly from <code>minRelDamPos</code> to 
<code>maxRelDamPos</code> as the commanded economizer damper position goes from 
<code>minPos*</code> to fully open.</li>
</ol>
<p align=\"center\">
<img alt=\"Image of the relief damper control diagram for single zone AHU\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/ReliefDamperControlDiagram_SingleZone.png\"/>
</p>
Expected control performance:
<p align=\"center\">
<img alt=\"Image of the relief damper control chart for single zone AHU\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/ReliefDamperControlChart_SingleZone.png\"/>
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
