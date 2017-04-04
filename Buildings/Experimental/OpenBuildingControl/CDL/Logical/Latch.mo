within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block Latch "Maintains an on signal until conditions changes"

  Interfaces.BooleanInput u "Connector of Boolean input signal: latch input"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
   Interfaces.BooleanInput u0 "Connector of Boolean input signal: clr input"
     annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));

  Interfaces.BooleanOutput y
    "Connector of Real output signal used as actuator signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Integer scenario "scenario index";

algorithm
  when (not u0) and (pre(u) <> u) and (pre(u) == false) then
    scenario :=1;
  elsewhen (pre(u0)==u0) and (not u0) and (pre(u) <> u) and (pre(u) == true) then
    scenario :=2;
  elsewhen (pre(u0)<>u0) and (not u0) and (pre(u) <> u) and (pre(u) == true) then
    scenario :=3;
  elsewhen (not u0) and u then
    scenario :=4;
  elsewhen (not u0) and (not u) then
    scenario :=5;
  elsewhen u0 then
    scenario :=6;
  end when;

equation
  if (scenario == 1 or scenario == 2) then y = true;
  elseif (scenario == 3) then y = false;
  elseif (scenario == 4) then y = true;
  elseif (scenario == 5) then y = false;
  elseif (scenario == 6 and u) then y = false;
  else
    y = false;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{-73,9},{-87,-5}},
          lineColor=DynamicSelect({235,235,235}, if u > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{81,7},{95,-7}},
          lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-73,-53},{-87,-67}},
          lineColor=DynamicSelect({235,235,235}, if u > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Line(points={{-68,-62},{4,-62},{4,-22},{74,-22}}, color={255,0,255}),
        Line(points={{-68,24},{-48,24},{-48,56},{-16,56},{-16,24},{24,24},{24,56},
              {54,56},{54,24},{74,24}}, color={255,0,255}),
        Text(
          extent={{-38,-46},{-8,-58}},
          lineColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textString="Clear"),
        Text(
          extent={{-16,46},{24,32}},
          lineColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textString="Latch input")}),
                                Documentation(info="<html>
<p>
The block maintains an <code>ON</code> signal until some other condition occurs to turn the signal <code>OFF</code>.
Once the <code>latch</code> input <code>u</code> receives an <code>ON</code> signal, the output <code>y</code>
turns <code>ON</code> and remains <code>ON</code> until the <code>clr</code> input <code>u0</code> turns <code>ON</code>, even if <code>u</code> 
turns <code>OFF</code>. 
When the <code>clr</code> input <code>u0</code> turns <code>ON</code>, the output <code>y</code> turns <code>OFF</code>. 
</p>

<table summary=\"summary\" border=\"1\">
<tr><th> Scenario </th><th> <code>latch</code> input <code>u</code> </th>
<th> <code>clr</code> input <code>u0</code> </th><th> output <code>y</code> </th>
<th> Description </th>
</tr>
<tr><td> 1 </td><td> <code>OFF</code> </td><td> from <code>OFF</code> to <code>ON</code> </td><td> <code>ON</code> </td>
<td>If <code>clr</code> <code>OFF</code> and <code>latch</code> switches from <code>OFF</code> to <code>ON</code>, then output <code>ON</code>.</td></tr>
<tr><td> 2 </td><td> <code>OFF</code> </td><td> from <code>ON</code> to <code>OFF</code> </td><td> <code>ON</code> </td>
<td>If <code>clr</code> <code>OFF</code> and <code>latch</code> switches from <code>ON</code> to <code>OFF</code>, then remain output <code>ON</code>.</td></tr>
<tr><td> 3 </td><td> from <code>ON</code> to <code>OFF</code> </td><td> from <code>ON</code> to <code>OFF</code> </td><td> <code>OFF</code> </td>
<td>If <code>clr</code> and <code>latch</code> switch from <code>ON</code> to <code>OFF</code> at same time, then output <code>OFF</code>.</td></tr>
<tr><td> 4 </td><td> <code>OFF</code> </td><td>  <code>ON</code> </td><td> <code>ON</code> </td>
<td>Initially, if <code>clr</code> <code>OFF</code> and <code>latch</code> <code>ON</code>, then output <code>ON</code>.</td></tr>
<tr><td> 5 </td><td> <code>OFF</code> </td><td>  <code>OFF</code> </td><td> <code>OFF</code> </td>
<td>Initially, if <code>clr</code> <code>OFF</code> and <code>latch</code> <code>OFF</code>, then output <code>OFF</code>.</td></tr>
<tr><td> 6 </td><td> <code>ON</code> </td><td>  <code>ON</code> or <code>OFF</code> </td><td> <code>OFF</code> </td>
<td>If <code>latch</code> <code>ON</code>, then output <code>OFF</code>.</td></tr>
</table>
<br/>

</html>", revisions="<html>
<ul>
<li>
March 30, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Latch;
