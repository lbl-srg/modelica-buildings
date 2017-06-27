within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic;
block ActuatedReliefDamperWithoutFan_SingleZone
  "Control of actuated relief  dampers without fans"
  parameter Real minRelDamPos(min=0, max=1, unit="1") = 0.1
    "Relief damper position that maintains a building pressure of 
    0.05 inchWC (12.44 Pa) while the system is at MinPosMin 
    (i.e., the economizer damper is positioned to provide MinOA 
    while the supply fan is at minimum speed)."
    annotation(Evaluate=true, Dialog(group="For Single-Zone AHU"));
  parameter Real maxRelDamPos(min=0, max=1, unit="1") = 0.9
    "Relief damper position that maintains a building pressure of 
    0.05 inchWC (12.44 Pa) while the economizer damper is fully open 
    and the fan speed is at cooling maximum."
    annotation(Evaluate=true, Dialog(group="For Single-Zone AHU"));
  parameter Real minPosMin(min=0, max=1, unit="1")=0.4
    "Outdoor air damper position, when fan operating at minimum speed 
    to supply minimum outdoor air flow"
    annotation(Evaluate=true, Dialog(group="For Single-Zone AHU"));
  parameter Real outDamPhyPosMax(min=0, max=1, unit="1")=1
    "Physical or at the comissioning fixed maximum position of 
    the economizer damper"
    annotation(Evaluate=true, Dialog(group="For Single-Zone AHU"));

  CDL.Continuous.Constant zerDam(k=0) "Close damper when disabled"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off" annotation (Placement(transformation(extent={{-140,
            -40},{-100,0}}),  iconTransformation(extent={{-120,-70},{-100,-50}})));

  CDL.Interfaces.RealOutput yRelDamPos "Relief damper position" annotation (
      Placement(transformation(extent={{120,-90},{140,-70}}),iconTransformation(
          extent={{100,-10},{120,10}})));
  CDL.Interfaces.RealInput uOutDamPos(unit="1") "Outdoor damper position"
    annotation (Placement(transformation(extent={{-140,-94},{-100,-54}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  CDL.Continuous.Constant minRelDam(k=minRelDamPos)
    "The relief damper position that maintains a building pressure of 
    0.05 inchWC (12.44 Pa) while the system is at MinPosMin 
    (i.e., the economizer damper is positioned to provide MinOA 
    while the supply fan is at minimum speed)."
    annotation (Placement(transformation(extent={{-80,-126},{-60,-106}})));
  CDL.Continuous.Constant maxRelDam(k=maxRelDamPos)
    "The relief damper position that maintains a building pressure of 0.05 inchWC (12.44 Pa) while the economizer damper is fully open (physical maximum) and the fan speed is at cooling maximum."
    annotation (Placement(transformation(extent={{-80,-172},{-60,-152}})));
  CDL.Continuous.Constant minPosAtMinSpd(k=minPosMin)
    "Outdoor air damper position, when fan operating at minimum speed to supply minimum outdoor air flow"
    annotation (Placement(transformation(extent={{-40,-104},{-20,-84}})));
  CDL.Continuous.Line relDamPos(limitBelow=true, limitAbove=true)
    "Relief damper position shall be reest linearly from minRelDamPos to maxRelDamPos as the commanded economizer damper position is goes from minPosMin to its physical maximum"
    annotation (Placement(transformation(extent={{20,-84},{40,-64}})));
  CDL.Continuous.Constant outDamPhyPosMaxSig(k=outDamPhyPosMax)
    "Physical or at the comissioning fixed maximum position of the economizer damper - economizer damper fully open. "
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{60,-22},{80,-42}})));
  CDL.Logical.GreaterThreshold greThr
    annotation (Placement(transformation(extent={{-60,-68},{-40,-48}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
equation
  connect(outDamPhyPosMaxSig.y, relDamPos.x2) annotation (Line(points={{-19,-140},
          {4,-140},{4,-78},{18,-78}}, color={0,0,127}));
  connect(maxRelDam.y, relDamPos.f2) annotation (Line(points={{-59,-162},{-59,-162},
          {12,-162},{12,-82},{18,-82}}, color={0,0,127}));
  connect(uOutDamPos, relDamPos.u) annotation (Line(points={{-120,-74},{-120,-74},
          {18,-74}},          color={0,0,127}));
  connect(zerDam.y, swi1.u3) annotation (Line(points={{1,-10},{1,-10},{20,-10},{
          20,-24},{58,-24}},  color={0,0,127}));
  connect(greThr.y, and2.u2) annotation (Line(points={{-39,-58},{-32,-58},{-32,-48},
          {-22,-48}}, color={255,0,255}));
  connect(uSupFan, and2.u1) annotation (Line(points={{-120,-20},{-80,-20},{-80,-40},
          {-22,-40}}, color={255,0,255}));
  connect(and2.y, swi1.u2) annotation (Line(points={{1,-40},{20,-40},{20,-32},{58,
          -32}}, color={255,0,255}));
  connect(relDamPos.y, swi1.u1) annotation (Line(points={{41,-74},{48,-74},{48,-40},
          {58,-40}}, color={0,0,127}));
  connect(uOutDamPos, greThr.u) annotation (Line(points={{-120,-74},{-80,-74},{-80,
          -58},{-62,-58}}, color={0,0,127}));
  connect(minPosAtMinSpd.y, relDamPos.x1) annotation (Line(points={{-19,-94},{-12,
          -94},{-12,-66},{18,-66}}, color={0,0,127}));
  connect(minRelDam.y, relDamPos.f1) annotation (Line(points={{-59,-116},{-59,-116},
          {-4,-116},{-4,-70},{18,-70}}, color={0,0,127}));
  connect(swi1.y, yRelDamPos) annotation (Line(points={{81,-32},{100,-32},{100,-80},
          {130,-80}},
                    color={0,0,127}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{120,20}})),
 Documentation(info="<html>      
<p>
This atomic sequence controls actuated relief dampers (<code>yRelDamPos</code>) without fans. It is implemented according to ASHRAE Guidline 35 (G36), PART5.N.8. (for multiple zone VAV AHU), 
PART5.P.6 and PART3.2B.3 (for single zone VAV AHU).
</p>   

<h4>Single zone VAV AHU: Control of actuated relief dampers without fans(PART5.P.6)</h4>
<ol>
<li>Relief damper position setpoints (PART3.2B.3)
<ul>
<li><code>minRelDamPos</code>: The relief damper position that maintains a building pressure of 12 Pa (0.05”) 
while the system is at MinPosMin (i.e., the economizer damper is positioned to provide MinOA while the supply fan is at minimum speed).</li>
<li><code>maxRelDamPos</code>: The relief damper position that maintains a building pressure of 12 Pa (0.05”) 
while the economizer damper is fully open and the fan speed is at cooling maximum.</li>
</ul>
</li>
<li>Relief dampers shall be enabled when the associated supply fan is proven on and any outdoor air damper is open (<code>uOutDamPos > 0</code>) and disabled and closed otherwise.</li>
<li>Relief damper position shall be reset linearly from MinRelief to MaxRelief as the commanded economizer damper position is goes from MinPos* to 100% open.</li>
</ol>
<p align=\"center\">
<img alt=\"Image of the modulation sequence control diagram\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/ActuatedReliefDamperWithoutFanControlDiagram_SingleZone.png\"/>
</p>
Expected control performance:
<p align=\"center\">
<img alt=\"Image of the modulation sequence control diagram\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/ActuatedReliefDamperWithoutFanControlChart_SingleZone.png\"/>
</p>

</html>", revisions="<html>
<ul>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ActuatedReliefDamperWithoutFan_SingleZone;
