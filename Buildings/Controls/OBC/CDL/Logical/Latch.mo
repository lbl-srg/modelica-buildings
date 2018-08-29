within Buildings.Controls.OBC.CDL.Logical;
block Latch "Maintains an on signal until conditions changes"

  parameter Boolean pre_u_start=false "Start value of pre(u) at initial time";
  parameter Boolean pre_y_start=false "Value of pre(y) at initial time";

  Interfaces.BooleanInput u "Latch input"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Interfaces.BooleanInput u0 "Control input"
     annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Interfaces.BooleanOutput y
    "Output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Integer scenario "scenario index";

initial equation
  pre(y) = pre_y_start;
  pre(u) = pre_u_start;
  pre(u0) = pre_u_start;
  pre(scenario) = 0;

equation
  when (not u0) and (pre(u) <> u) and (pre(u) == false) then
    scenario = 1;
  elsewhen (pre(u0)==u0) and (not u0) and (pre(u) <> u) and (pre(u) == true) then
    scenario = 2;
  elsewhen (pre(u0)<>u0) and (not u0) and (pre(u) <> u) and (pre(u) == true) then
    scenario = 3;
  elsewhen (not u0) and u then
    scenario = 4;
  elsewhen (not u0) and (not u) then
    scenario = 5;
  elsewhen u0 then
    scenario = 6;
  end when;

  if (scenario == 1 or scenario == 2) then y = true;
  elseif (scenario == 3) then y = false;
  elseif (scenario == 4) then y = true;
  elseif (scenario == 5) then y = false;
  elseif (scenario == 6 and u) then y = false;
  else
    y = false;
  end if;
  annotation (
        defaultComponentName="lat",
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
The block maintains a <code>true</code> output signal until the input <code>u0</code>
switches to <code>false</code>.
When the latch input <code>u</code> switches to <code>true</code>, the output <code>y</code>
becomes <code>true</code> and remains <code>true</code>,
even if <code>u</code> turns <code>false</code>,
until the clear input <code>u0</code> becomes <code>true</code>.
When the clear input <code>u0</code> becomes <code>true</code>, then
the output <code>y</code> becomes <code>false</code>.
</p>
<p>
The table below shows the different scenarios.
</p>

<table summary=\"summary\" border=\"1\">
<tr><th> Scenario
<th> clear input <code>u0</code> </th>
<th> latch input <code>u</code> </th>
<th> output <code>y</code> </th>
<th> Description </th>
</tr>
<tr>
<td> 1 </td><td> <code>false</code> </td><td> from <code>false</code> to <code>true</code> </td>
<td> <code>true</code> </td>
<td>If <code>u0=false</code> and <code>latch</code> switches from <code>false</code> to <code>true</code>,
then <code>y=true</code>.</td>
</tr>
<tr><td> 2 </td><td> <code>false</code> </td><td> from <code>true</code> to <code>false</code> </td>
<td> <code>true</code> </td>
<td>If <code>u0=false</code> and <code>latch</code> switches from <code>true</code> to <code>false</code>,
then remain <code>y=true</code>.</td></tr>

<tr><td> 3 </td><td> from <code>true</code> to <code>false</code> </td><td> from <code>true</code> to <code>false</code> </td>
<td> <code>false</code> </td>
<td>If <code>u</code> and <code>u0</code> switch from <code>true</code> to <code>false</code> at same time,
then <code>y=false</code>.</td></tr>

<tr><td> 4 </td><td> <code>false</code> </td><td>  <code>true</code> </td><td> <code>true</code> </td>
<td>Initially, if <code>u0=false</code> and <code>u=true</code>,
then <code>y=true</code>.</td></tr>

<tr><td> 5 </td><td> <code>false</code> </td><td>  <code>false</code> </td><td> <code>false</code> </td>
<td>Initially, if <code>u0=false</code> and <code>u=false</code>,
then <code>y=false</code>.</td></tr>

<tr><td> 6 </td><td> <code>true</code> </td><td>  <code>true</code> or <code>false</code> </td>
<td> <code>false</code> </td>
<td>If <code>u=true</code>, then <code>y=false</code>.</td></tr>
</table>
<br/>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/Latch.png\"
     alt=\"Latch.png\" />
</p>

</html>", revisions="<html>
<ul>
<li>
December 1, 2017, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
March 30, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Latch;
