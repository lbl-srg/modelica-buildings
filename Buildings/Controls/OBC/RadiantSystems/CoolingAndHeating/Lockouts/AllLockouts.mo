within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts;
block AllLockouts "Composite block of all lockouts: room air temperature, chilled water return, hysteresis, and night flush"
    parameter Real TZonHigSet(min=0,
    final unit="K",
    final displayUnit="degC",
    final quantity="Temperature")=297.6
    "Air temperature high limit above which heating is locked out";
    parameter Real TZonLowSet(min=0,
    final unit="K",
    final displayUnit="degC",
    final quantity="Temperature")=293.15
    "Air temperature low limit below which heating is locked out";
   parameter Real TWatSetLow(min=0,
    final unit="K",
    final displayUnit="degC",
    final quantity="Temperature")=285.9
    "Lower limit for chilled water return temperature, below which cooling is locked out";
   parameter  Real cooLocDurWatTem(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=1800 "Time for which cooling is locked if CHW return is too cold";
    parameter Real heaLocDurAftCoo(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which heating is locked out after cooling concludes";
    parameter Real cooLocDurAftHea(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which cooling is locked out after heating concludes";
  Controls.OBC.CDL.Logical.And3 andHea
    "Combines signals from heating lockouts to produce true signal if heating is allowed"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Controls.OBC.CDL.Logical.And3 andCoo
    "Combines signals from cooling lockouts to produce true signal if cooling is allowed"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Controls.OBC.CDL.Interfaces.RealInput TSlaWatRet
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating signal- true if heating is called for, false if not"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling signal- true if cooling is called for, false if not"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}})));
  Controls.OBC.CDL.Interfaces.RealInput TRooAir "Room air temperature"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uNigFlu
    "Night flush signal- true if night flush is on"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yHea
    "True if heating allowed, false if locked out"
    annotation (Placement(transformation(extent={{100,10},{140,50}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yCoo
    "True if cooling allowed, false if cooling locked out"
    annotation (Placement(transformation(extent={{100,-70},{140,-30}})));
  SubLockouts.HysteresisLimit hysLim(heaLocDurAftCoo=heaLocDurAftCoo, cooLocDurAftHea=cooLocDurAftHea)
    "Locks out heating (heating signal false) if cooling has just been on; locks out cooling (cooling signal false) if heating has just been on"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  SubLockouts.AirTemperatureLimit airTemLim(TZonHigSet=TZonHigSet, TZonLowSet=
        TZonLowSet)
    "Locks out heating (heating signal is false) if air is too hot; locks out cooling (cooling signal is false) if slab is too cold"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  SubLockouts.NightFlush nitFluLoc
    "Locks out heating (heating signal is false) if night flush mode is on"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  SubLockouts.ChilledWaterReturnLimit chwRetLim(TWatSetLow=TWatSetLow, cooLocDurWatTem=cooLocDurWatTem)
    "Locks out cooling (cooling signal false) if chilled water return temperature is too low"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
equation
  connect(andHea.y, yHea)
    annotation (Line(points={{82,30},{120,30}}, color={255,0,255}));
  connect(andCoo.y, yCoo)
    annotation (Line(points={{82,-50},{120,-50}}, color={255,0,255}));
  connect(uHea, hysLim.uHea) annotation (Line(points={{-120,50},{-80,50},{-80,
          -5.8},{-42.2,-5.8}}, color={255,0,255}));
  connect(uCoo, hysLim.uCoo) annotation (Line(points={{-120,10},{-84,10},{-84,
          -18},{-42,-18}}, color={255,0,255}));
  connect(TRooAir, airTemLim.TRoo) annotation (Line(points={{-120,-30},{-73,-30},
          {-73,37.2},{-42,37.2}}, color={0,0,127}));
  connect(airTemLim.yHeaTZon, andHea.u2) annotation (Line(points={{-18,33},
          {20,33},{20,30},{58,30}}, color={255,0,255}));
  connect(airTemLim.yCooTZon, andCoo.u1) annotation (Line(points={{-18,25},
          {30,25},{30,-42},{58,-42}}, color={255,0,255}));
  connect(uNigFlu, nitFluLoc.uNigFlu) annotation (Line(points={{-120,90},{-82,
          90},{-82,70},{-42.2,70}}, color={255,0,255}));
  connect(TSlaWatRet, chwRetLim.TSlaRet) annotation (Line(points={{-120,-70},{-80,-70},
          {-80,-68},{-42,-68}}, color={0,0,127}));
  connect(chwRetLim.yCooTChiWatRetLim, andCoo.u3) annotation (Line(points={{-18,-69},
          {20,-69},{20,-58},{58,-58}}, color={255,0,255}));
  connect(nitFluLoc.yNigFluHea, andHea.u1) annotation (Line(points={{-18,70},{
          20,70},{20,38},{58,38}}, color={255,0,255}));
  connect(hysLim.yHeaNotLoc, andHea.u3) annotation (Line(points={{-18,-8},{50,
          -8},{50,22},{58,22}}, color={255,0,255}));
  connect(hysLim.yCooNotLoc, andCoo.u2) annotation (Line(points={{-18,-18},{0,
          -18},{0,-50},{58,-50}}, color={255,0,255}));
  annotation (defaultComponentName = "allLoc",Documentation(info="<html>
<p>
This block encompasses all lockouts.
</p>

<p>
Heating lockouts are as follows:
</p>

<ul>
<li>1. Air Temperature Lockout: Heating is locked out if room air temperature is above a user-specified temperature threshold (typically 76<code>degF</code>). </li>
<li>2. Night Flush Lockout: Heating is locked out if night flush mode is on, as night flush setpoints are typically below heating setpoint, but heating is not desired during night flush operation,
as this would waste energy and negate the cooling effect of the flush. </li>
<li>3. Hysteresis Lockout: Heating is locked out if cooling was on within a user-specified amount of time (typically one hour).</li>
</ul>

<p>Cooling lockouts are as follows:</p>
<ul>
<li>1. Air Temperature Lockout (<a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.AirTemperatureLimit\">
Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.AirTemperatureLimit</a>): Cooling is locked out if room air temperature is below a user-specified temperature threshhold (typically 68<code>degF</code>).</li>
<li>2. Chilled Water Return Temperature Lockout (<a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.ChilledWaterReturnLimit\">
Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.ChilledWaterReturnLimit</a>): Cooling is locked out for a user-specified amount of time (typically 30 minutes) if chilled water return temperature is too cold, 
as this indicates that the room needs less cooling than is being provided.</li>
<li>3. Hysteresis Lockout  (<a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.HysteresisLimit\">
Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.HysteresisLimit</a>): 
Cooling is locked out if heating was on within a user-specified amount of time (typically one hour).</li>
</ul>

<p>Output is expressed as a heating or cooling signal. If the heating signal is <code>true</code>, heating is allowed (i.e., it is not locked out).
If the cooling signal is true, cooling is allowed (ie, it is not locked out).</p>
<p>
A true signal indicates only that heating or cooling is permitted - it does not indicate the actual status
  of the final heating or cooling signal, which depends on the slab temperature and slab setpoint 
  (see <a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal.SlabSetpointPerimeter\">
Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal.SlabSetpointPerimeter</a> for more information).
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
        textString="L"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-64,100},{312,84}},
          lineColor={0,0,0},
          lineThickness=1,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="All Lockouts Combined")}));
end AllLockouts;
