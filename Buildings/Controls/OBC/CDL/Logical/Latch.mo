within Buildings.Controls.OBC.CDL.Logical;
block Latch "Maintains a true signal until change condition"

  parameter Boolean pre_y_start=false "Start value of pre(y) at initial time";

  Interfaces.BooleanInput u "Latch input"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Interfaces.BooleanInput u0 "Clear input"
     annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Interfaces.BooleanOutput y "Output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Integer scenario "scenario index";

initial equation
  pre(y) = pre_y_start;
  pre(u) = false;
  pre(u0) = false;
  pre(scenario) = 0;

equation
  when initial() then
    scenario = 1;
  elsewhen (not u0) and (pre(u)<>u) and (pre(u) == false) then
    scenario = 2;
  elsewhen (not u0) and (pre(u)<>u) and (pre(u) == true) then
    scenario = 3;
  elsewhen (pre(u0)<>u0) and (pre(u0) == true) and (not u) then
    scenario = 4;
  elsewhen u0 then
    scenario = 5;
  end when;

  if (scenario == 1) then y = pre(y);
  elseif (scenario == 2) then y = true;
  elseif (scenario == 3) then y = pre(y);
  elseif (scenario == 4) then y = false;
  else
    y = false;
  end if;

annotation (defaultComponentName="lat",
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
          extent={{81,7},{95,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
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
          textString="Latch input"),
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name")}),Documentation(info="<html>
<p>
Block that generates a <code>true</code> output when latch input <code>u</code> 
rises from <code>false</code> to <code>true</code>. It remains the <code>true</code> 
output until clear input <code>u0</code> becomes <code>true</code>. For instance,
</p>
<ul>
<li>
Suppose the clear input <code>u0</code> is <code>false</code>. When the latch input <code>u</code>
becomes <code>true</code>, then the output <code>y</code> becomes <code>true</code>
and remains <code>true</code>, even if <code>u</code> becomes <code>false</code>.
The output <code>y</code> becomes <code>false</code> only when the clear input 
<code>u0</code> becomes <code>true</code>.
</li>
<li>
Suppose the clear input <code>u0</code> is <code>true</code>, the output <code>y</code> 
remains <code>false</code>, regardless the status of latch input <code>u</code>.
</li>
</ul>
<p>
The table below shows the different scenarios:
</p>
<ul>
<li>
At initial time, the output <code>y</code> will be determined by initial value 
<code>pre_y_start</code>, with <code>false</code> as default.
</li>
</ul>
<table summary=\"summary\" border=\"1\">
<tr>
<th> Scenario </th>
<th> input <code>u0</code> </th>
<th> latch input <code>u</code> </th>
<th> previous output <code>pre(y)</code> </th>
<th> New output <code>y</code> </th>
</tr>
<tr><td> 1 </td><td> <code>false</code> </td>
                <td> <code>true</code> or <code>false</code> </td>
                <td> <code>pre_y_start</code> </td>
                <td> <code>pre_y_start</code> </td></tr>
</table>
<br/>
<ul>
<li>
During the simulation (after the initialization):
</li>
</ul>
<table summary=\"summary\" border=\"1\">
<tr>
<th> Scenario </th>
<th> input <code>u0</code> </th>
<th> previous latch input <code>pre(u)</code> </th>
<th> latch input <code>u</code> </th>
<th> previous output <code>pre(y)</code> </th>
<th> New output <code>y</code> </th>
</tr>
<tr><td> 2 </td><td> <code>false</code> </td>
                <td> <code>false</code> </td>
                <td> <code>true</code> </td>
                <td> <code>true</code> or <code>false</code> </td>
                <td> <code>true</code></td></tr>
<tr><td> 3 </td><td> <code>false</code> </td>
                <td> <code>true</code> </td>
                <td> <code>false</code> </td>
                <td> <code>true</code> or <code>false</code> </td>
                <td> <code>pre(y)</code></tr>
<tr><td> 4 </td><td> from <code>true</code> to <code>false</code> </td>
                <td> <code>true</code> or <code>false</code> </td>
                <td> <code>false</code> </td>
                <td> <code>true</code> or <code>false</code> </td>
                <td> <code>false</code></tr>
<tr><td> 5 </td><td> <code>true</code> </td>
                <td> <code>true</code> or <code>false</code> </td>
                <td> <code>true</code> or <code>false</code> </td>
                <td> <code>true</code> or <code>false</code> </td>
                <td> <code>false</code> </td></tr>
</table>
<br/>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/Latch.png\"
     alt=\"Latch.png\" />
</p>

</html>", revisions="<html>
<ul>
<li>
April 4, 2019, by Jianjun Hu:<br/>
Corrected implementation that causes wrong output at initial stage. 
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1402\">issue 1402</a>.
</li>
<li>
December 1, 2017, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
March 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Latch;
