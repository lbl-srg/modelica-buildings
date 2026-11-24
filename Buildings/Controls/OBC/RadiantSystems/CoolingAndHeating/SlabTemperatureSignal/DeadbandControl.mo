within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal;
block DeadbandControl
  "Outputs call for heating or cooling based on slab temperature error, i.e. difference between slab setpoint and actual slab temp. No heating or cooling allowed if slab temp is within deadband"
parameter Real TDeaRel(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=2.22 "Difference from slab temp setpoint required to trigger heating or cooling during occupied hours";
parameter Real TDeaNor(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=0.28
                                           "Difference from slab temp setpoint required to trigger heating or cooling during unoccpied hours";
  parameter Real k(min=0,max=24)=18 "Last occupied hour";
  parameter Boolean offWitDea=true "If flow should turn off when slab setpoint is within deadband, set to true. Otherwise, set to false";

  Controls.OBC.CDL.Continuous.Hysteresis hysRel(uLow=-TDeaRel, uHigh=TDeaRel)
    "Call for heating or cooling in times of relaxed deadband, i.e. during unoccupied hours. True indicates warm slab (call for cooling). False indicates cold slab (call for heating)"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Controls.OBC.CDL.Continuous.Hysteresis           hys(uLow=-TDeaNor, uHigh=TDeaNor)
    "Call for heating or cooling in times of tight deadband, i.e. during occupied hours. True indicates warm slab (call for cooling). False indicates cold slab (call for heating)"
    annotation (Placement(transformation(extent={{-120,-62},{-100,-42}})));
  Controls.OBC.CDL.Logical.Not           not1
    "Negates output for heating control"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Controls.OBC.CDL.Interfaces.RealInput slaTemErr "Slab temperature error"
    annotation (Placement(transformation(extent={{-196,-158},{-156,-118}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput uHea
    "True if there is a call for heating; false if not"
    annotation (Placement(transformation(extent={{150,-10},{190,30}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput uCoo
    "True if there is a call for cooling; false if not"
    annotation (Placement(transformation(extent={{150,-110},{190,-70}})));
  Controls.OBC.CDL.Continuous.Abs           abs
    "Absolute value of difference between slab setpoint and slab temp"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Controls.OBC.CDL.Continuous.Hysteresis           hys3(uLow=TDeaNor - 0.1,
      uHigh=TDeaNor)
    "Tests if absolute value of error is greater than occupied error threshhold (signal used during occ hours)"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Controls.OBC.CDL.Continuous.Hysteresis           hys2(uLow=TDeaRel - 0.1,
      uHigh=TDeaRel)
    "Tests if absolute value of error is greater than relaxed error threshhold (signal used during unocc hours)"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul1(width=w, period=86400)
    "True if occupied (and setpoint should be met within a smaller tolerance), false if unoccupied (and setpoint should be met within a larger tolerance)"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Controls.OBC.CDL.Logical.Sources.Constant con(k=offWitDea)
    "If user has specified that heating & cooling should both be off if slab is within deadband, offWitDea is true. Otherwise, it is false"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Controls.OBC.CDL.Logical.Sources.Constant con1(k=true)
    "Constant true value- allows heating or cooling call if \"off within deadband\" is false"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Controls.OBC.CDL.Logical.And and3
    "Heating call is true if slab is hot AND error is not within deadband, if user has indicated that no calls should be issued when slab is in deadband"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Controls.OBC.CDL.Logical.And and4
    "Cooling call is true if slab is cold AND error is not within deadband, if user has indicated that no calls should be issued when slab is in deadband"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Controls.OBC.CDL.Logical.LogicalSwitch logSwi1
    "Switches between occupied and unoccupied deadband based on time of day"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Controls.OBC.CDL.Logical.LogicalSwitch logSwi2
    "Switches between occupied and unoccupied absolute error threshhold based on occupancy signal"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Controls.OBC.CDL.Logical.LogicalSwitch logSwi3
    "Passes signal if flow is allowed to stop if slab temp is within deadband; if flow is NOT allowed to stop, always passes true"
    annotation (Placement(transformation(extent={{82,120},{102,140}})));
protected
          parameter Real w=k/24 "Width of day";
equation
  connect(slaTemErr, hys.u) annotation (Line(points={{-176,-138},{-141,-138},{-141,
          -52},{-122,-52}}, color={0,0,127}));
  connect(slaTemErr, hysRel.u) annotation (Line(points={{-176,-138},{-140,-138},
          {-140,-130},{-122,-130}}, color={0,0,127}));
  connect(slaTemErr, abs.u) annotation (Line(points={{-176,-138},{-140,-138},{
          -140,50},{-122,50}},
                          color={0,0,127}));
  connect(abs.y, hys3.u) annotation (Line(points={{-98,50},{-80,50},{-80,110},{
          -42,110}}, color={0,0,127}));
  connect(abs.y, hys2.u) annotation (Line(points={{-98,50},{-80,50},{-80,30},{
          -42,30}}, color={0,0,127}));
  connect(not1.y, and3.u2) annotation (Line(points={{62,-10},{64,-10},{64,2},{
          118,2}}, color={255,0,255}));
  connect(and3.y, uHea)
    annotation (Line(points={{142,10},{170,10}}, color={255,0,255}));
  connect(and4.y, uCoo)
    annotation (Line(points={{142,-90},{170,-90}}, color={255,0,255}));
  connect(hys.y, logSwi1.u1) annotation (Line(points={{-98,-52},{-72,-52},{-72,
          -102},{-42,-102}}, color={255,0,255}));
  connect(hysRel.y, logSwi1.u3) annotation (Line(points={{-98,-130},{-72,-130},
          {-72,-118},{-42,-118}}, color={255,0,255}));
  connect(booPul1.y, logSwi1.u2) annotation (Line(points={{-98,-90},{-80,-90},{
          -80,-110},{-42,-110}}, color={255,0,255}));
  connect(logSwi1.y, and4.u2) annotation (Line(points={{-18,-110},{112,-110},{
          112,-98},{118,-98}}, color={255,0,255}));
  connect(logSwi1.y, not1.u) annotation (Line(points={{-18,-110},{20,-110},{20,
          -10},{38,-10}}, color={255,0,255}));
  connect(booPul1.y, logSwi2.u2) annotation (Line(points={{-98,-90},{0,-90},{0,
          130},{18,130}}, color={255,0,255}));
  connect(hys3.y, logSwi2.u1) annotation (Line(points={{-18,110},{-8,110},{-8,
          138},{18,138}}, color={255,0,255}));
  connect(hys2.y, logSwi2.u3) annotation (Line(points={{-18,30},{10,30},{10,122},
          {18,122}}, color={255,0,255}));
  connect(con.y, logSwi3.u2) annotation (Line(points={{62,90},{68,90},{68,130},
          {80,130}}, color={255,0,255}));
  connect(con1.y, logSwi3.u3) annotation (Line(points={{62,50},{72,50},{72,122},
          {80,122}}, color={255,0,255}));
  connect(logSwi2.y, logSwi3.u1) annotation (Line(points={{42,130},{66,130},{66,
          138},{80,138}}, color={255,0,255}));
  connect(logSwi3.y, and4.u1) annotation (Line(points={{104,130},{104,-90},{118,
          -90}}, color={255,0,255}));
  connect(logSwi3.y, and3.u1)
    annotation (Line(points={{104,130},{104,10},{118,10}}, color={255,0,255}));
  annotation (defaultComponentName = "deaCon", Documentation(info="<html>
<p>
This determines calls for heating or cooling based on the slab error, ie the difference between the slab temperature and the slab temperature setpoint. 
The user specifies two error thresholds- one value for occupied hours (TDeaNor, typically 0.5F), 
and one larger value for unoccupied hours (TDeaRel,typically 4F), when slab temperature can fluctuate within a wider range. 
These variables indicate the absolute value of the allowable slab error. 
</p>
<p>
If this value is exceeded and slab temperature is below setpoint, heating is turned on. 
If this value is exceeded and slab temperature is above setpoint, cooling is turned on. </p>
<p>
The user also specifies the final occupied hour (k). </p>

<p>Finally, the user specifies whether or not heating and cooling should both be off when the slab error is within deadband (offWitDea).
If this variable is true, neither heating nor cooling is requested when the slab error is smaller than the user-specified difference from slab setpoint
(TDeaNor if the room is occupied, or TDeaRel if the room is unoccupied).  
If this variable is false, either heating or cooling will be on at all times. 
It is recommended that this variable be set to true, as setting this to false requires either heating or cooling to be on at all times,
which is more energy intensive and may be impractical with many building designs. </p>

<p> The slab setpoint is selected at midnight each day based on that day's forecasted outdoor air high temperature.
From this point until the building's last occupied hour, the building system attempts to meet the slab setpoint within the specified occupied deadband. 
After the last occupied hour, the building system attempts to meet the slab setpoint within the specified unoccupied deadband. </p>

<p>If the slab temperature is above the setpoint + deadband, a call for cooling is produced. 
If the slab temperature is below the slab setpoint minus deadband, a call for heating is produced. </p>

</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation. 
</li>
</ul>
</html>"),Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-150,-150},{150,150}}),  graphics={
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),  Rectangle(
        extent={{-150,-150},{150,150}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-70},{-40,-70},{31,38}}),
        Line(points={{31,38},{86,38}}),
       Text(
          extent={{-72,78},{72,6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        textString="D"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3))),
        Text(
          lineColor={0,0,255},
          extent={{-156,152},{144,192}},
          textString="%name")}),                                                                Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-150,
            -150},{150,260}}), graphics={
        Rectangle(
          extent={{-150,158},{40,12}},
          lineColor={0,140,72},
          lineThickness=1),
        Rectangle(
          extent={{-150,10},{40,-150}},
          lineColor={244,125,35},
          lineThickness=1),
        Rectangle(
          extent={{40,160},{150,30}},
          lineColor={102,44,145},
          lineThickness=1),
        Text(
          extent={{-144,156},{-100,94}},
          lineColor={0,140,72},
          lineThickness=1,
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          textString="Test absolute slab temperature error
against occupied 
or unoccupied 
error thresholds"),
        Text(
          extent={{-132,16},{-88,-46}},
          lineColor={244,125,35},
          lineThickness=1,
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          textString="Test slab temperature error
 against occupied or
 unoccupied error thresholds"),
        Rectangle(
          extent={{42,28},{150,-150}},
          lineColor={217,67,180},
          lineThickness=1),
        Text(
          extent={{50,-58},{104,-170}},
          lineColor={28,108,200},
          lineThickness=1,
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          textString="Final cooling signal- 
true
if slab calls for cooling 
AND 
slab temperature
is not within deadband
"),     Text(
          extent={{48,4},{102,-108}},
          lineColor={238,46,47},
          lineThickness=1,
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          textString="Final heating signal- 
true
if slab calls for heating 
AND 
slab temperature
is not within deadband
"),     Text(
          extent={{-118,228},{-22,182}},
          lineColor={0,0,0},
          lineThickness=1,
          horizontalAlignment=TextAlignment.Left,
          fontName="Arial Narrow",
          textStyle={TextStyle.Bold},
          textString="Deadband Control: 
Calls for heating or cooling 
based on slab temperature error,
whether or not slab temperature is within deadband,
and user specification for
slab behavior within deadband"),
        Text(
          extent={{108,128},{150,64}},
          lineColor={102,44,145},
          lineThickness=1,
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          textString="If user specifies 
that
heating &
cooling 
should 
stop within 
deadband, 
signal is false
if error is 
within deadband,
locking out 
heating 
& cooling.
Otherwise, 
signal is true. ")}));
end DeadbandControl;
