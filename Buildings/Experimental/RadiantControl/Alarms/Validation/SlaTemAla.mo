within Buildings.Experimental.RadiantControl.Alarms.Validation;
model SlaTemAla "Validation model for slab temperature alarm"
   final parameter Real TimErr(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=14400  "Time threshhold slab temp must be out of range to trigger alarm";
  final parameter Real TemErr(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1.1 "Difference from slab temp setpoint required to trigger alarm";

  Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=TemErr/2,
    freqHz=1/86400,
    phase(displayUnit="rad"),
    offset=TemErr)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Controls.OBC.CDL.Continuous.Sources.Sine sin1(
    amplitude=TemErr/2,
    freqHz=4/86400,
    phase(displayUnit="rad"),
    offset=TemErr)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  SlabTempAlarm slaTemAla
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  SlabTempAlarm slaTemAla1
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(sin.y, slaTemAla.slaTemErr) annotation (Line(points={{-38,50},{-20,50},
          {-20,53},{-2,53}}, color={0,0,127}));
  connect(sin1.y, slaTemAla1.slaTemErr) annotation (Line(points={{-38,10},{-20,
          10},{-20,13},{-2,13}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This model validates the slab temperature alarm, which should show true if slab has been a user-specified amount out of range for a user-specified amount of time.  
</p>
</html>"),experiment(StopTime=172800.0, Tolerance=1e-06),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/RadiantControl/Alarms/Validation/SlaTemAla.mos"
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
end SlaTemAla;
