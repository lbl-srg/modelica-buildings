within Buildings.Experimental.NaturalVentilation.Lockouts.SubLockouts;
block WindLockout "Locks out natural ventilation due to high wind speed"
   parameter Real winSpeLim(min=0,
    final unit="m/s",
    final displayUnit="m/s",
    final quantity="Velocity")=8.94 "Wind speed above which window must be closed";
  Controls.OBC.CDL.Continuous.Hysteresis hys(
    uLow=winSpeLimLo,
    uHigh=winSpeLim,
    pre_y_start=true)
    "Tests if wind speed is above 20 mph (8.94 m/s); if so, locks out nat vent"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Controls.OBC.CDL.Interfaces.RealInput winSpe
    "Wind speed perpendicular to window" annotation (Placement(transformation(
          extent={{-140,-10},{-100,30}}), iconTransformation(extent={{-140,
            -20},{-100,20}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yWinNatVenSig
    "True if natural ventilation allowed; otherwise false" annotation (
      Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
          extent={{100,-20},{140,20}})));
protected
    parameter Real winSpeLimLo(min=0,
    final unit="m/s",
    final displayUnit="m/s",
    final quantity="Velocity")=winSpeLim*0.95  "Lower hysteresis limit";
equation
  connect(winSpe, hys.u)
    annotation (Line(points={{-120,10},{-22,10}}, color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{2,10},{18,10}}, color={255,0,255}));
  connect(not1.y,yWinNatVenSig)
    annotation (Line(points={{42,10},{120,10}}, color={255,0,255}));
  annotation (defaultComponentName = "winLoc",Documentation(info="<html>
  <p>
  This block locks out natural ventilation if wind speed is greater than a user-specified amount (winSpeLim, typically 20 mph).
</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,38},{-80,-84},{80,-84},{80,38},{-80,38}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-54,38},{-60,78}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-60,84},{60,78}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{60,38},{54,78}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          extent={{-22,40},{28,-56}},
          lineColor={28,108,200},
          textString="W"),
        Text(
          lineColor={0,0,255},
          extent={{-154,104},{146,144}},
          textString="%name")}),
                             Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={Text(
          extent={{-88,94},{312,62}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Wind Lockout:
Locks out natural ventilation if wind speed is above a user-specified threshold")}));
end WindLockout;
