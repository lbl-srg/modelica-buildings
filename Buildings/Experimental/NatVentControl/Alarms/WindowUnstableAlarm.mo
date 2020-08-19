within Buildings.Experimental.NatVentControl.Alarms;
block WindowUnstableAlarm
  "Alarm if window moves within a specified range more than a specified amount of time within a given time interval"
  annotation (defaultComponentName = "WindowUnstableAlarm",Documentation(info="<html>
<p>
</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Polygon(
          points={{-38,92},{42,92},{62,34},{62,-28},{42,-88},{-38,-88},{-58,-28},
              {-58,32},{-38,92}},
          lineColor={255,0,0},
          lineThickness=1), Text(
          extent={{-18,52},{18,-44}},
          lineColor={255,0,0},
          lineThickness=1,
          textString="U")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end WindowUnstableAlarm;
