within Buildings.Examples.DemandFlexibility.HVAC.Validation;
model setpoint_processing_validation
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    amplitude=15,
    freqHz=0.00013888888,
    offset=290.15)
    annotation (Placement(transformation(extent={{-76,40},{-56,60}})));
  setpoint_processing setpoint_processing1
    annotation (Placement(transformation(extent={{8,-2},{28,18}})));
equation
  connect(sin.y, setpoint_processing1.TZonHeaSetCom) annotation (Line(points={{
          -54,50},{-2,50},{-2,13},{6,13}}, color={0,0,127}));
  connect(sin.y, setpoint_processing1.TZonCooSetCom) annotation (Line(points={{
          -54,50},{-2,50},{-2,3.8},{6,3.8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end setpoint_processing_validation;
