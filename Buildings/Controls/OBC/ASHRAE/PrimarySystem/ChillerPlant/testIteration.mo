within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block testIteration "Defines lead-lag or lead-standby equipment rotation"

  parameter Integer num = 2
    "Total number of chillers, the same number applied to isolation valves, CW pumps, CHW pumps";

  parameter Real small(unit = "s") = 1
    "Hysteresis detla";

  parameter Real stagingRuntime(unit = "s") = 240 * 60 * 60
    "Staging runtime";

  parameter Boolean initRoles[num] = {true, false}
    "Sets initial roles: true = lead, false = lag. There should be only one lead device";

  parameter Real overlap(unit = "s") = 5 * 60
    "Time period during which the previous lead stays on";

  CDL.Continuous.Add add2(
    k1=1,
    k2=1,
    y(start=1, fixed=true),
    u1(start=0, fixed=true))
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  CDL.Continuous.Sources.Constant con1(k=1)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
equation
  connect(add2.u2, con1.y) annotation (Line(points={{-42,-16},{-58,-16},{-58,
          -30},{-79,-30}}, color={0,0,127}));
  connect(add2.y, add2.u1) annotation (Line(points={{-19,-10},{-12,-10},{-12,16},
          {-62,16},{-62,-4},{-42,-4}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-180,-120},{180,120}})),
      defaultComponentName="equRot",
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
                              Text(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          textString="equRot"),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-75,-6},{-89,8}},
          lineColor=DynamicSelect({235,235,235}, if u1 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u1 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
  Documentation(info="<html>
<p>
fixme
</p>
</html>", revisions="<html>
<ul>
<li>
, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>

</html>"));
end testIteration;
