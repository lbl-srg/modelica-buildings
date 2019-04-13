within Buildings.Controls.OBC.CDL.Logical;
block Toggle "Toggles output value whenever its input turns true"

  parameter Boolean pre_u_start=false "Start value of pre(u) at initial time";
  parameter Boolean pre_y_start=false "Value of pre(y) at initial time";

  Interfaces.BooleanInput u "Toggle input"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Interfaces.BooleanInput u0 "Clear input"
     annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Interfaces.BooleanOutput y
    "Output signal"
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

  if (scenario == 0 and not u0 and u) then y = true;
  elseif (scenario == 0 and not u0 and not u) then y = false;
  elseif scenario == 1 then y = true;
  elseif scenario == 2 then y = false;
  elseif scenario == 3 then y = false;
  elseif scenario == 4 then y = true;
  elseif scenario == 5 then y = false;
  elseif scenario == 6 then y = true;
  elseif scenario == 7 then y = false;
  else
    y = false;
  end if;

annotation (defaultComponentName="tog",
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
Block that toggles the output value whenever its input turns <code>true</code>. For instance,
</p>
<ul>
<li>
Suppose the clear input <code>u0</code> is <code>false</code>. When the toggle input <code>u</code>
becomes <code>true</code>, the output <code>y</code> becomes <code>true</code> and
remains <code>true</code> even when <code>u</code> turns <code>false</code> again.
When <code>u</code> turns back to <code>true</code>, then <code>y</code> becomes <code>false</code>.
</li>
<li>
If the clear input <code>u0</code> is <code>true</code>, the output <code>y</code> 
keeps <code>false</code>.
</li>
</ul>

<p>
The table below shows the different scenarios.
</p>

<table summary=\"summary\" border=\"1\">
<tr><th> Scenario </th>
<th>input <code>u0</code> </th><th> toggle input <code>u</code></th>
<th>output <code>y</code> </th><th>Description</th>
</tr>
<tr><td> 1 </td><td> <code>false</code> </td><td> from <code>false</code> to <code>true</code> </td><td> <code>true</code> </td>
<td>If <code>u0</code> <code>false</code>, toggle switches from <code>false</code> to <code>true</code>, previous output is <code>false</code>, then output <code>true</code>.</td></tr>

<tr><td> 2 </td><td> <code>false</code> </td><td> from <code>false</code> to <code>true</code> </td><td> <code>false</code> </td>
<td>If <code>u0</code> <code>false</code>, toggle switches from <code>false</code> to <code>true</code>, previous output is <code>true</code>, then output <code>false</code>.</td></tr>

<tr><td> 3 </td><td> <code>false</code> </td><td> from <code>true</code> to <code>false</code> </td><td> <code>false</code> </td>
<td>If <code>u0</code> <code>false</code>, toggle switches from <code>true</code> to <code>false</code>, previous output is <code>false</code>, then remain output <code>false</code>.</td></tr>

<tr><td> 4 </td><td> <code>false</code> </td><td> from <code>true</code> to <code>false</code> </td><td> <code>true</code> </td>
<td>If <code>u0</code> <code>false</code>, toggle switches from <code>true</code> to <code>false</code>, previous output is <code>true</code>, then remain output <code>true</code>.</td></tr>

<tr><td> 5 </td><td> <code>false</code> </td><td>  <code>false</code> </td><td> <code>false</code> </td>
<td>Initially, if <code>u0</code> <code>false</code> and toggle <code>false</code>, then output <code>false</code>.</td></tr>

<tr><td> 6 </td><td> <code>false</code> </td><td>  <code>true</code> </td><td> <code>true</code> </td>
<td>Initially, if <code>u0</code> <code>false</code> and toggle <code>true</code>, then output <code>true</code>.</td></tr>

<tr><td> 7 </td><td> <code>true</code> </td><td>  <code>true</code> or <code>false</code> </td><td> <code>false</code> </td>
<td>If <code>u0</code> <code>true</code>, then output <code>false</code>.</td></tr>

</table>
<br/>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/Toggle.png\"
     alt=\"Toggle.png\" />
</p>

</html>", revisions="<html>
<ul>
<li>
April 4, 2019, by Jianjun Hu:<br/>
Corrected implementation that causes wrong output at initial stage. 
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1402\">issue 1402</a>.
</li>
<li>
March 31, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Toggle;
