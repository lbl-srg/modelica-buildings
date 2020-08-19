within Buildings.Experimental.NatVentControl.Lockouts;
block WindLockout
  "Locks out natural ventilation due to high wind speed"
   parameter Real TWinHiLim(min=0,
    final unit="m/s",
    final displayUnit="m/s",
    final quantity="Velocity")=8.94 "Wind speed above which window must be closed";
  Controls.OBC.CDL.Continuous.Hysteresis hys(
    uLow=TWinHiLimLo,
    uHigh=TWinHiLim,
    pre_y_start=true)
    "Tests if wind speed is above 20 mph (8.94 m/s); if so, locks out nat vent"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Controls.OBC.CDL.Interfaces.RealInput winSpe
    "Wind speed perpendicular to window" annotation (Placement(transformation(
          extent={{-140,-10},{-100,30}}), iconTransformation(extent={{-140,
            -20},{-100,20}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput natVenSigWin
    "True if natural ventilation allowed; otherwise false" annotation (
      Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
          extent={{100,-20},{140,20}})));
protected
    parameter Real TWinHiLimLo(min=0,
    final unit="m/s",
    final displayUnit="m/s",
    final quantity="Velocity")=TWinHiLim*0.99  "Lower hysteresis limit";
equation
  connect(winSpe, hys.u)
    annotation (Line(points={{-120,10},{-22,10}}, color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{2,10},{18,10}}, color={255,0,255}));
  connect(not1.y, natVenSigWin)
    annotation (Line(points={{42,10},{120,10}}, color={255,0,255}));
  annotation (defaultComponentName = "WindLockout",Documentation(info="<html>
  <p>
  This block locks out natural ventilation if wind speed is greater than a user-specified amount (typically 20 mph).
</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{-80,60},{-80,-62},{80,-62},{80,60},{-80,60}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-54,60},{-60,100}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-60,106},{60,100}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{60,60},{54,100}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          extent={{-22,62},{28,-34}},
          lineColor={28,108,200},
          textString="W")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end WindLockout;
