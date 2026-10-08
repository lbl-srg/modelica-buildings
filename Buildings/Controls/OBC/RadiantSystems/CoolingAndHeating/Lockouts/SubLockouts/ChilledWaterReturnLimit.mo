within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts;
block ChilledWaterReturnLimit
  "Locks out cooling if chilled water return temperature is below user-specified threshold"
  parameter Real TWatSetLow(min=0,
    final unit="K",
    final displayUnit="degC",
    final quantity="Temperature")=285.9
    "Lower limit for chilled water return temperature, below which cooling is locked out";
    parameter Real cooLocDurWatTem(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=1800 "Time for which cooling is locked out if CHW return is too cold";
  Controls.OBC.CDL.Logical.TrueHoldWithReset           truHol(duration=cooLocDurWatTem)
    "Holds signal for user-specified time threshhold"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Controls.OBC.CDL.Logical.Not           not6
    "Negates signal so that cooling is locked out if CHW return water temp is too low"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Controls.OBC.CDL.Interfaces.RealInput TSlaRet "Slab water return temperature"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yCooTChiWatRetLim
    "True if water temperature is above low threshhold, false if not"
    annotation (Placement(transformation(extent={{100,-10},{140,30}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys1(
    uLow=TWatSetLow,
    uHigh=TWatSetLow + 1)
    "Test if CHW is below low limit- output false if CHW temp is low, output true if not"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Controls.OBC.CDL.Logical.Not           not1
    "Negates signal so that cooling is locked out if CHW return water temp is too low"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(truHol.y, not6.u)
    annotation (Line(points={{42,10},{58,10}}, color={255,0,255}));
  connect(not6.y,yCooTChiWatRetLim)
    annotation (Line(points={{82,10},{120,10}}, color={255,0,255}));
  connect(TSlaRet, hys1.u) annotation (Line(points={{-120,20},{-92,20},{-92,10},{-62,
          10}}, color={0,0,127}));
  connect(hys1.y, not1.u)
    annotation (Line(points={{-38,10},{-22,10}}, color={255,0,255}));
  connect(not1.y, truHol.u)
    annotation (Line(points={{2,10},{18,10}}, color={255,0,255}));
  annotation (defaultComponentName = "chwRetLim",Documentation(info="<html>
<p>
If chilled water return temperature is below a user-specified threshold, cooling is locked out for a user-specified amount of time (typically 0.5 hours).
 Output is expressed as a heating or cooling signal. If the heating signal is true, heating is allowed (ie, it is not locked out).
  If the cooling signal is true, cooling is allowed (ie, it is not locked out).
  A true signal indicates only that heating or cooling is *permitted*- it does *not* indicate the actual status
  of the final heating or cooling signal, which depends on the slab temperature and slab setpoint (see SlabTempSignal for more info). 
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
        textString="C"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-68,82},{308,66}},
          lineColor={0,0,0},
          lineThickness=1,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Chilled Water Return Lockout: 
Lock out cooling for user-specified time amount if CHW return temperature is below low limit")}));
end ChilledWaterReturnLimit;
