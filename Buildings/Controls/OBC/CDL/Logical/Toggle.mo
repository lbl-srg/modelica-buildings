within Buildings.Controls.OBC.CDL.Logical;
block Toggle "Toggles output value whenever its input turns on"
  parameter Boolean pre_u_start=false "Start value of pre(u) at initial time";
  parameter Boolean pre_y_start=false "Value of pre(y) at initial time";
  Interfaces.BooleanInput u "Connector of Boolean input signal: toggle input"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Interfaces.BooleanInput u0 "Connector of Boolean input signal: clr input"
     annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Interfaces.BooleanOutput y
    "Connector of Real output signal used as actuator signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Integer scenario "Scenario index";

initial equation
  pre(y) = pre_y_start;
  pre(u) = pre_u_start;
  pre(u0) = pre_u_start;
  pre(scenario) = 0;

equation
  when (not u0) and ((pre(u)<>u) and (pre(u) == false)) and (pre(y) == false) then
    scenario =  1;
  elsewhen (not u0) and ((pre(u)<>u) and (pre(u) == false)) and (pre(y) == true) then
    scenario =  2;
  elsewhen (not u0) and ((pre(u)<>u) and (pre(u) == true)) and (pre(y) == false) then
    scenario =  3;
  elsewhen (not u0) and ((pre(u)<>u) and (pre(u) == true)) and (pre(y) == true) then
    scenario =  4;
  elsewhen (not u0) and (not u) then
    scenario =  5;
  elsewhen (not u0) and u then
    scenario =  6;
  elsewhen u0 then
    scenario =  7;
  end when;

  if scenario == 1 then y = true;
  elseif scenario == 2 then y = false;
  elseif scenario == 3 then y = false;
  elseif scenario == 4 then y = true;
  elseif scenario == 5 then y = false;
  elseif scenario == 6 then y = true;
  elseif scenario == 7 then y = false;
  else
    y = false;
  end if;

  annotation (
        defaultComponentName="tog",
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{-73,9},{-87,-5}},
          lineColor=DynamicSelect({235,235,235}, if u then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-73,-53},{-87,-67}},
          lineColor=DynamicSelect({235,235,235}, if u0 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u0 then {0,255,0}
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
          textString="Toggle input"),
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p>
The block toggles output value whenever input turns <code>ON</code>. For instance, when the <code>toggle</code> input <code>u</code>
turns <code>ON</code>, the output <code>y</code> turns <code>ON</code> and remains <code>ON</code> when the input <code>u</code> turns <code>OFF</code> again.
When the input <code>u</code> turns back <code>ON</code>, the output turns <code>OFF</code>.
When the <code>clr</code> input turns <code>ON</code>, the output turns <code>OFF</code>.
</p>


<table summary=\"summary\" border=\"1\">
<tr><th> Scenario </th>
<th> <code>clr</code> input <code>u0</code> </th><th> <code>toggle</code> input <code>u</code> </th>
<th> output <code>y</code> </th><th> Description </th>
</tr>
<tr><td> 1 </td><td> <code>OFF</code> </td><td> from <code>OFF</code> to <code>ON</code> </td><td> <code>ON</code> </td>
<td>If <code>clr</code> <code>OFF</code>, <code>toggle</code> switches from <code>OFF</code> to <code>ON</code>, previous output is <code>OFF</code>, then output <code>ON</code>.</td></tr>

<tr><td> 2 </td><td> <code>OFF</code> </td><td> from <code>OFF</code> to <code>ON</code> </td><td> <code>OFF</code> </td>
<td>If <code>clr</code> <code>OFF</code>, <code>toggle</code> switches from <code>OFF</code> to <code>ON</code>, previous output is <code>ON</code>, then output <code>OFF</code>.</td></tr>

<tr><td> 3 </td><td> <code>OFF</code> </td><td> from <code>ON</code> to <code>OFF</code> </td><td> <code>OFF</code> </td>
<td>If <code>clr</code> <code>OFF</code>, <code>toggle</code> switches from <code>ON</code> to <code>OFF</code>, previous output is <code>OFF</code>, then remain output <code>OFF</code>.</td></tr>

<tr><td> 4 </td><td> <code>OFF</code> </td><td> from <code>ON</code> to <code>OFF</code> </td><td> <code>ON</code> </td>
<td>If <code>clr</code> <code>OFF</code>, <code>toggle</code> switches from <code>ON</code> to <code>OFF</code>, previous output is <code>ON</code>, then remain output <code>ON</code>.</td></tr>

<tr><td> 5 </td><td> <code>OFF</code> </td><td>  <code>OFF</code> </td><td> <code>OFF</code> </td>
<td>Initially, if <code>clr</code> <code>OFF</code> and <code>toggle</code> <code>OFF</code>, then output <code>OFF</code>.</td></tr>

<tr><td> 6 </td><td> <code>OFF</code> </td><td>  <code>ON</code> </td><td> <code>ON</code> </td>
<td>Initially, if <code>clr</code> <code>OFF</code> and <code>toggle</code> <code>ON</code>, then output <code>ON</code>.</td></tr>

<tr><td> 7 </td><td> <code>ON</code> </td><td>  <code>ON</code> or <code>OFF</code> </td><td> <code>OFF</code> </td>
<td>If <code>clr</code> <code>ON</code>, then output <code>OFF</code>.</td></tr>

</table>
<br/>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/Toggle.png\"
     alt=\"Toggle.png\" />
</p>

</html>", revisions="<html>
<ul>
<li>
March 31, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Toggle;
