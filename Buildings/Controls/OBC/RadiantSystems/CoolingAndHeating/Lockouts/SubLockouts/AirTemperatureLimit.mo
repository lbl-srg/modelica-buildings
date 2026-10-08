within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts;
block AirTemperatureLimit "Locks out heating if room air is hotter than user-specified threshold; locks out cooling if room air is colder than user-specified threshold"
   parameter Real TZonHigSet(min=0,
    final unit="K",
    final displayUnit="degC",
    final quantity="Temperature")=297.6
    "Air temperature high limit above which heating is locked out";
    parameter Real TZonLowSet(min=0,
    final unit="K",
    final displayUnit="degC",
    final quantity="Temperature")=293.15
    "Air temperature low limit below which cooling is locked out";
  Buildings.Controls.OBC.CDL.Logical.Not           not2
    "Negates hysteresis output to give heating signal"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHeaTZon
    "True if heating is allowed, false if heating is locked out because room air is too hot"
    annotation (Placement(transformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yCooTZon
    "True if cooling allowed, false if cooling locked out because room air is too cold"
    annotation (Placement(transformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRoo(unit="K", displayUnit="K")
    "Room air temperature"
    annotation (Placement(transformation(extent={{-140,52},{-100,92}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=TZonHigSet - 0.1, uHigh=
        TZonHigSet) "If room air temp is above high threshold, lock out heating"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=TZonLowSet, uHigh=TZonLowSet
         + 0.1) "If room air temp is below low threshold, lock out cooling"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
equation
  connect(not2.y, yHeaTZon)
    annotation (Line(points={{62,30},{120,30}}, color={255,0,255}));
  connect(hys.y, not2.u)
    annotation (Line(points={{22,30},{38,30}}, color={255,0,255}));
  connect(TRoo, hys.u) annotation (Line(points={{-120,72},{-60,72},{-60,30},{-2,
          30}}, color={0,0,127}));
  connect(hys1.y, yCooTZon)
    annotation (Line(points={{22,-50},{120,-50}}, color={255,0,255}));
  connect(TRoo, hys1.u) annotation (Line(points={{-120,72},{-60,72},{-60,-50},{
          -2,-50}}, color={0,0,127}));
  annotation (defaultComponentName = "airTemLim",Documentation(info="<html>
<p>
If room air temperature is above a specified temperature threshold (typically 76<code>degF</code>), heating is looked out. 
If room air temperature is below a specified temperature threshold (typically 68<code>degF</code>), cooling is locked out.
</p>
<p>
Output is expressed as a heating or cooling signal. If the heating signal is <code>true</code>, heating is allowed (ie, it is not locked out).
</p>
<p>
If the cooling signal is true, cooling is allowed (ie, it is not locked out).
A true signal indicates only that heating or cooling is permitted- it does not indicate the actual status
of the final heating or cooling signal, which depends on the slab temperature and slab setpoint (see <a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal\">
Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal</a> for more info).
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation. 
</li>
</ul>
</html>"),Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),graphics={
        Text(
          lineColor={0,0,255},
          extent={{-148,104},{152,144}},
          textString="%name"),
        Rectangle(extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(points={{90,0},{68,8}, {68,-8},{90,0}},
          lineColor={192,192,192}, fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,0},{80,0}}),
        Text(
        extent={{-56,90},{48,-88}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        textString="A"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-70,96},{306,80}},
          lineColor={0,0,0},
          lineThickness=1,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Air Temperature Lockout: 
Lock out heating if room air temperature is above user-specified high threshold
Lock out cooling if room air temperature is below user specified low threshold")}));
end AirTemperatureLimit;
