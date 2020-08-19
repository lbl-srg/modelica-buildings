<<<<<<< HEAD
within Buildings.Experimental.NatVentControl.Alarms;
block ZoneTempAlarm
  "Alarm if zone temp is out of range for more than a given time duration"
  annotation (defaultComponentName = "ZoneTempAlarm",Documentation(info="<html>
  <p>
  If zone temperature is more than a user-specified tolerance out of range from setpoint for more than a user-specified time duration, alarm is set to true. 
</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Polygon(
          points={{-40,90},{40,90},{60,32},{60,-30},{40,-90},{-40,-90},{-60,-30},
              {-60,30},{-40,90}},
          lineColor={255,0,0},
          lineThickness=1), Text(
          extent={{-18,50},{18,-46}},
          lineColor={255,0,0},
          lineThickness=1,
          textString="Z")}), Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={Polygon(
          points={{-32,-22},{-32,-22}},
          lineColor={28,108,200},
          lineThickness=1)}));
end ZoneTempAlarm;
=======
within Buildings.Experimental.NatVentControl.Alarms;
block ZoneTempAlarm
  "Alarm if zone temp is out of range for more than a given time duration"
  annotation (defaultComponentName = "ZoneTempAlarm",Documentation(info="<html>
  <p>
  If zone temperature is more than a user-specified tolerance out of range from setpoint for more than a user-specified time duration, alarm is set to true. 
</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Polygon(
          points={{-40,90},{40,90},{60,32},{60,-30},{40,-90},{-40,-90},{-60,-30},
              {-60,30},{-40,90}},
          lineColor={255,0,0},
          lineThickness=1), Text(
          extent={{-18,50},{18,-46}},
          lineColor={255,0,0},
          lineThickness=1,
          textString="Z")}), Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={Polygon(
          points={{-32,-22},{-32,-22}},
          lineColor={28,108,200},
          lineThickness=1)}));
end ZoneTempAlarm;
>>>>>>> 2008edcd25685faae709310e80edf551fd923411
