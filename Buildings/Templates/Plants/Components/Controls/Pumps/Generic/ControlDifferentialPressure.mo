within Buildings.Templates.Plants.Components.Controls.Pumps.Generic;
block ControlDifferentialPressure
  "Differential pressure control for variable speed pumps"
  annotation (
  defaultComponentName="sta",
  Icon(
    coordinateSystem(
      preserveAspectRatio=true,
      extent={{-100,-100},{100,100}}),
    graphics={
      Line(
        points={{-90,-80.3976},{68,-80.3976}},
        color={192,192,192}),
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        textColor={0,0,255})}),
    Documentation(info="<html>
<p>Used in Guideline 36 for:
</p>
<ul>
<li>
primary-only chiller and boiler plants with headered variable speed 
primary pumps using differential pressure pump speed control,
</li>
<li>
primary-secondary chiller plants plants with one or more sets of 
secondary loop pumps serving downstream control valves,
</li>
<li>
primary-secondary boiler plants plants with variable speed 
secondary pumps serving a secondary loop with a flow meter.
</li>
</ul>
<p>
For other plant configurations, the pumps are staged with the equipment, i.e.,
the number of pumps matches the number of chillers or boilers.
The actual logic to generate the pump enable commands is part of the 
staging event sequencing. 
</p>
<p>
If desired, the stage down flow point <code>dVOffDow</code> can be 
offset slightly below the stage up point <code>dVOffUp</code> to 
prevent cycling between pump stages in applications with highly variable loads.
</p>
<p>
The timers are reset to zero when the status of a pump changes.
This is necessary to ensure the minimum pump runtime with rapidly changing loads. 
</p>
</html>
"), Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end ControlDifferentialPressure;
