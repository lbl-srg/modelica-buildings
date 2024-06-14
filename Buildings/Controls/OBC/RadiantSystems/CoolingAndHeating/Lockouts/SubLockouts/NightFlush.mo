within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts;
block NightFlush "Locks out heating if building is in night flush mode"
  Controls.OBC.CDL.Interfaces.BooleanInput uNigFlu
    "True if night flush mode is on; false otherwise"
    annotation (Placement(transformation(extent={{-142,-20},{-102,20}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yNigFluHea
    "True if heating is allowed, false if heating is locked out"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Controls.OBC.CDL.Logical.Not           not1
    "If night flush mode is on, heating should not be on"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
equation
  connect(not1.y, yNigFluHea)
    annotation (Line(points={{14,0},{120,0}}, color={255,0,255}));
  connect(uNigFlu, not1.u)
    annotation (Line(points={{-122,0},{-10,0}}, color={255,0,255}));
  annotation (defaultComponentName = "nitFluLoc",Documentation(info="<html>
<p>
If night flush mode is on, heating is locked out. 
The purpose of this lockout is to allow the slab to be pre-cooled below its setpoint without the building's heating system turning on.
 Output is expressed as a heating or cooling signal. If the heating signal is true, heating is allowed (i.e., it is not locked out).
  If the cooling signal is true, cooling is allowed (i.e., it is not locked out).
  A true signal indicates only that heating or cooling is permitted- it does not indicate the actual status
  of the final heating or cooling signal, which depends on the slab temperature and slab setpoint 
  (see package <a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal\">
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
        textString="N"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-94,98},{282,82}},
          lineColor={0,0,0},
          lineThickness=1,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Night Flush Lockout: 
Locks out heating mode if night flush is on")}));
end NightFlush;
