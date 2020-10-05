within Buildings.Experimental.NaturalVentilation.Alarms.Validation;
model ZoneTemperature "Validation model for slab temperature alarm"
   final parameter Real TimErr(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=3600  "Time threshhold zone temp must be out of range to trigger alarm";
  final parameter Real TemErr(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1.1 "Difference from zone temp setpoint required to trigger alarm";

  Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=TemErr/2,
    freqHz=1/86400,
    phase(displayUnit="rad"),
    offset=293.15 + 2*TemErr)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  ZoneTemperatureAlarm zonTemAla1
    annotation (Placement(transformation(extent={{0,38},{20,58}})));
  ZoneTemperatureAlarm zonTemAla2
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Sine sin2(
    amplitude=TemErr/2,
    freqHz=4/86400,
    phase(displayUnit="rad"),
    offset=293.15)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con(k=293.15)
    annotation (Placement(transformation(extent={{-98,-2},{-78,18}})));
equation
  connect(con.y, zonTemAla1.TRooSet) annotation (Line(points={{-76,8},{-70,8},
          {-70,44.6},{-2,44.6}}, color={0,0,127}));
  connect(con.y, zonTemAla2.TRooSet) annotation (Line(points={{-76,8},{-70,8},
          {-70,-33.4},{-2,-33.4}}, color={0,0,127}));
  connect(sin2.y, zonTemAla2.TRooMea) annotation (Line(points={{-38,-10},{-20,
          -10},{-20,-27},{-2,-27}}, color={0,0,127}));
  connect(sin.y, zonTemAla1.TRooMea) annotation (Line(points={{-38,70},{-20,
          70},{-20,51},{-2,51}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This model validates the zone temperature alarm, which should show true if the zone temperature has been a user-specified amount away from setpoint for a user-specified amount of time.  
</p>
</html>"),experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Alarms/Validation/ZoneTemperature.mos"
        "Simulate and plot"), Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ZoneTemperature;
