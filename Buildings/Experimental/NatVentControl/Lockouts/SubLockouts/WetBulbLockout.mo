within Buildings.Experimental.NatVentControl.Lockouts.SubLockouts;
block WetBulbLockout
  "Locks out natural ventilation based on outdoor air wet bulb temperature"
  parameter Real TWetBulDif(min=0.001,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=4.44 "Allowable difference between outdoor air wet bulb temperature and room air temperature setpoint: OA WB +  this difference must be less than room air temperature setpoint";
  Controls.OBC.CDL.Continuous.Add addDif(k2=-1)
    "Difference between room setpoint and wet bulb temperature"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Controls.OBC.CDL.Interfaces.RealInput TRooSet
    "Thermostat setpoint temperature used in window control" annotation (
      Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Controls.OBC.CDL.Interfaces.RealInput TWetBul
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys(
    uLow=TWetBulDifLo,
    uHigh=TWetBulDif,
    pre_y_start=true)
    "Tests if room air setpoint minus wet bulb temp is greater than user-specified tolerance (typically 8 F). If so, window can open. If not, window must be closed."
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yWetBulNatVenSig
    "True if natural ventilation allowed; otherwise false" annotation (
      Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
          extent={{100,-18},{140,22}})));
protected
          parameter Real TWetBulDifLo(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=TWetBulDif*0.99  "Lower hysteresis limit";
equation
  connect(addDif.y, hys.u)
    annotation (Line(points={{-38,10},{-22,10}}, color={0,0,127}));
  connect(TRooSet, addDif.u1) annotation (Line(points={{-120,30},{-82,30},{-82,
          16},{-62,16}}, color={0,0,127}));
  connect(TWetBul, addDif.u2) annotation (Line(points={{-120,-30},{-82,-30},{
          -82,4},{-62,4}}, color={0,0,127}));
  connect(hys.y, yWetBulNatVenSig)
    annotation (Line(points={{2,10},{120,10}}, color={255,0,255}));
  annotation (defaultComponentName = "wetBulLoc",Documentation(info="<html>
  <p>
  This block locks out natural ventilation if the wet bulb temperature is too high. 
  <p> The user specifies a tolerance (TWetBulDif, typically 4.5 degrees Celsius), and the wet bulb temperature must be below the room setpoint minus the tolerance 
  in order for natural ventilation to be permitted. 
</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,40},{-80,-82},{80,-82},{80,40},{-80,40}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-54,40},{-60,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-60,86},{60,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{60,40},{54,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          extent={{-40,32},{44,-42}},
          lineColor={28,108,200},
          textString="B"),
        Text(
          lineColor={0,0,255},
          extent={{-146,104},{154,144}},
          textString="%name")}),
                             Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={Text(
          extent={{-90,98},{310,66}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Wet Bulb Lockout:
Locks out natural ventilation if room setpoint
minus wet bulb temperature is less than a user-specified difference
i.e. wet bulb temperature is too high")}));
end WetBulbLockout;
