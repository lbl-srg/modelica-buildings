within Buildings.Experimental.RadiantControl;
package SlabTemperatureSignal
  "Blocks that determine slab temperature setpoint and heating/cooling signal"

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
    parameter Boolean off_within_deadband=true "If flow should turn off when slab setpoint is within deadband, set to true. Otherwise, set to false";

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
    Controls.OBC.CDL.Interfaces.BooleanOutput htgCal
      "True if there is a call for heating; false if not"
      annotation (Placement(transformation(extent={{150,-10},{190,30}})));
    Controls.OBC.CDL.Interfaces.BooleanOutput clgCal
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
    Controls.OBC.CDL.Logical.Sources.Constant con(k=off_within_deadband)
      "If user has specified that heating & cooling should both be off if slab is within deadband, off_within_deadband is true. Otherwise, it is false"
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
    connect(and3.y, htgCal)
      annotation (Line(points={{142,10},{170,10}}, color={255,0,255}));
    connect(and4.y, clgCal)
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
<p>
<p>
If this value is exceeded and slab temperature is below setpoint, heating is turned on. 
If this value is exceeded and slab temperature is above setpoint, cooling is turned on. <p>
<p>
The user also specifies the final occupied hour (k). <p>

<p>Finally, the user specifies whether or not heating and cooling should both be off when the slab error is within deadband (off_within_deadband).
If this variable is true, neither heating nor cooling is requested when the slab error is smaller than the user-specified difference from slab setpoint
(TDeaNor if the room is occupied, or TDeaRel if the room is unoccupied).  
If this variable is false, either heating or cooling will be on at all times. 
It is recommended that this variable be set to true, as setting this to false requires either heating or cooling to be on at all times,
which is more energy intensive and may be impractical with many building designs. <p> 

<p> The slab setpoint is selected at midnight each day based on that day's forecasted outdoor air high temperature.
From this point until the building's last occupied hour, the building system attempts to meet the slab setpoint within the specified occupied deadband. 
After the last occupied hour, the building system attempts to meet the slab setpoint within the specified unoccupied deadband. <p>

<p>If the slab temperature is above the setpoint + deadband, a call for cooling is produced. 
If the slab temperature is below the slab setpoint minus deadband, a call for heating is produced. <p>

</p>
</html>",   revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated description. 
</li>
</html>"),  Icon(coordinateSystem(
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
            fontSize=12,
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
            fontSize=11,
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
            fontSize=8,
            textString="Final cooling signal- 
true
if slab calls for cooling 
AND 
slab temperature
is not within deadband
"),       Text(
            extent={{48,4},{102,-108}},
            lineColor={238,46,47},
            lineThickness=1,
            fontName="Arial Narrow",
            horizontalAlignment=TextAlignment.Left,
            fontSize=8,
            textString="Final heating signal- 
true
if slab calls for heating 
AND 
slab temperature
is not within deadband
"),       Text(
            extent={{-118,228},{-22,182}},
            lineColor={0,0,0},
            lineThickness=1,
            horizontalAlignment=TextAlignment.Left,
            fontSize=14,
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
            fontSize=8,
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

  block Error "Determines difference between slab temperature and slab setpoint"
    Controls.OBC.CDL.Interfaces.RealInput TSla "Slab temperature"
      annotation (Placement(transformation(extent={{-140,-10},{-100,30}})));
    Controls.OBC.CDL.Interfaces.RealInput TSlaSet "Slab temperature setpoint"
      annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
    Controls.OBC.CDL.Interfaces.RealOutput slaTemErr
      "Difference between slab temp and setpoint"
      annotation (Placement(transformation(extent={{100,-10},{140,30}})));
    Controls.OBC.CDL.Continuous.Add add(k2=-1)
      "Slab temperature minus slab setpoint"
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
  equation
    connect(TSla, add.u1) annotation (Line(points={{-120,10},{-61,10},{-61,16},{
            -2,16}}, color={0,0,127}));
    connect(TSlaSet, add.u2) annotation (Line(points={{-120,-30},{-60,-30},{-60,4},
            {-2,4}}, color={0,0,127}));
    connect(add.y, slaTemErr)
      annotation (Line(points={{22,10},{120,10}}, color={0,0,127}));
    annotation (defaultComponentName = "err",Documentation(info="<html>
<p>
This calculates the slab error, ie the difference between the slab temperature and its setpoint.
This term is what drives calls for heating or for cooling. 

</p>
</html>",   revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated description. 
</li>
</html>"),  Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Text(
            lineColor={0,0,255},
            extent={{-150,110},{150,150}},
            textString="%name"),  Rectangle(
          extent={{-100,-100},{100,100}},
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
          extent={{-56,90},{48,-88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="E"),
          Text(
            extent={{226,60},{106,10}},
            lineColor={0,0,0},
            textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(
          coordinateSystem(preserveAspectRatio=false), graphics={Text(
            extent={{-48,86},{48,40}},
            lineColor={0,0,0},
            lineThickness=1,
            horizontalAlignment=TextAlignment.Left,
            fontSize=14,
            fontName="Arial Narrow",
            textStyle={TextStyle.Bold},
            textString="Slab Error:
Calculates slab error 
from slab temperature 
and slab setpoint")}));
  end Error;

  block SlabSetpointPerimeter
    "Determines slab temperature setpoint for perimeter zones from forecast outdoor air high temperature"
    Controls.SetPoints.Table           tabSlab(table=[274.8166667,302.5944444;
          274.8167222,300.9277778; 280.3722222,300.9277778; 280.3727778,
          300.9277778; 285.9277778,300.9277778; 285.9283333,298.7055556;
          291.4833333,298.7055556; 291.4838889,296.4833333; 292.5944444,
          296.4833333; 292.5945,296.4833333; 293.15,296.4833333; 293.1500556,
          295.9277778; 295.3722222,295.9277778; 295.3722778,295.3722222;
          295.9277778,295.3722222; 295.9278333,292.5944444; 299.8166667,
          292.5944444; 299.8172222,291.4833333; 302.5944444,291.4833333])
      "Slab setpoint lookup table"
      annotation (Placement(transformation(extent={{-20,-62},{-62,-20}})));
    Controls.OBC.CDL.Interfaces.RealInput TFor
      "High temperature for the day, as forecasted one day prior"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Controls.OBC.CDL.Interfaces.RealOutput TSlaSetPer
      "Slab temperature setpoint, determined based on forecast outdoor air high temperature"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));
    Controls.OBC.CDL.Discrete.Sampler sam(samplePeriod=86400)
      "Samples forecast high each day"
      annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  equation
    connect(sam.y, tabSlab.u) annotation (Line(points={{-18,10},{0,10},{0,-41},{
            -15.8,-41}},
                   color={0,0,127}));
    connect(TFor, sam.u) annotation (Line(points={{-120,0},{-92,0},{-92,10},{-42,
            10}},
          color={0,0,127}));
    connect(tabSlab.y, TSlaSetPer) annotation (Line(points={{-64.1,-41},{-84,-41},
            {-84,-80},{78,-80},{78,0},{120,0}}, color={0,0,127}));
    annotation (defaultComponentName = "slaSetPer",Documentation(info="<html>
<p>
This determines the slab temperature setpoint for a perimeter zone from the forecast high OAT. 
Temperature setpoint is selected from a lookup table. 
<p>Note that this setpoint is determined differently than the setpoint for core zones, which is set to a constant value throughout the year (typically 70F). <p>
</p>
</html>",   revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated description. 
</li>
</html>"),  Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Text(
            lineColor={0,0,255},
            extent={{-150,110},{150,150}},
            textString="%name"),  Rectangle(
          extent={{-100,-100},{100,100}},
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
          extent={{-90,60},{90,-60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="Sp"),
          Text(
            extent={{-56,90},{48,-60}},
            lineColor={0,0,0},
            textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
            Text(
            extent={{-62,90},{34,44}},
            lineColor={0,0,0},
            lineThickness=1,
            horizontalAlignment=TextAlignment.Left,
            fontSize=14,
            fontName="Arial Narrow",
            textString="Slab Perimeter Setpoint: 
Selects slab temperature setpoint 
for a perimeter zone 
from lookup table based on forecast high",
            textStyle={TextStyle.Bold})}));
  end SlabSetpointPerimeter;

  package Validation "Validation models for slab temperature blocks"

    model DeadbandControl "Validation model for deadband control"
      final parameter Real TemDeaRel(min=0,
        final unit="K",
        final displayUnit="K",
        final quantity="TemperatureDifference")=2.22 "Difference from slab temp setpoint required to trigger heating or cooling during occupied hours";
      final parameter Real TemDeaNor(min=0,
        final unit="K",
        final displayUnit="K",
        final quantity="TemperatureDifference")=0.28
                                               "Difference from slab temp setpoint required to trigger heating or cooling during unoccpied hours";
      final parameter Real LastOcc(min=0,max=24)=16 "Last occupied hour";
      final parameter Boolean OffTru=true "True: both heating and cooling signals turn off when slab setpoint is within deadband";
      final parameter Boolean OffFal=false "False: signals may be on when slab setpoint is within deadband";
      Controls.OBC.CDL.Continuous.Sources.Sine sin(
        amplitude=TemDeaNor,
        freqHz=1/14400,
        phase(displayUnit="rad"),
        offset=0) "Varying slab temperature error"
        annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
      Controls.OBC.CDL.Continuous.Sources.Sine sin1(
        amplitude=TemDeaRel,
        freqHz=1/14400,
        phase(displayUnit="rad"),
        offset=0) "Varying slab temperature error"
        annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
      Buildings.Experimental.RadiantControl.SlabTemperatureSignal.DeadbandControl deaCon(
        TDeaRel=TemDeaRel,
        TDeaNor=TemDeaNor,
        k=LastOcc,
        off_within_deadband=OffTru)
        annotation (Placement(transformation(extent={{-20,40},{0,60}})));
      Buildings.Experimental.RadiantControl.SlabTemperatureSignal.DeadbandControl deaCon1(
        TDeaRel=TemDeaRel,
        TDeaNor=TemDeaNor,
        k=LastOcc,
        off_within_deadband=OffFal)
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
      Buildings.Experimental.RadiantControl.SlabTemperatureSignal.DeadbandControl deaCon2(
        TDeaRel=TemDeaRel,
        TDeaNor=TemDeaNor,
        k=LastOcc,
        off_within_deadband=OffTru)
        annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
      Buildings.Experimental.RadiantControl.SlabTemperatureSignal.DeadbandControl deaCon3(
        TDeaRel=TemDeaRel,
        TDeaNor=TemDeaNor,
        k=LastOcc,
        off_within_deadband=OffFal)
        annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
      Buildings.Experimental.RadiantControl.SlabTemperatureSignal.DeadbandControl deaConTes(
        TDeaRel=TemDeaRel,
        TDeaNor=TemDeaNor,
        k=LastOcc,
        off_within_deadband=OffTru)
        annotation (Placement(transformation(extent={{50,60},{80,92}})));
      Buildings.Experimental.RadiantControl.SlabTemperatureSignal.DeadbandControl deaConTesFal(
        TDeaRel=TemDeaRel,
        TDeaNor=TemDeaNor,
        k=LastOcc,
        off_within_deadband=OffFal)
        annotation (Placement(transformation(extent={{50,8},{80,40}})));
      Buildings.Experimental.RadiantControl.SlabTemperatureSignal.DeadbandControl deaConTes1(
        TDeaRel=TemDeaRel,
        TDeaNor=TemDeaNor,
        k=LastOcc,
        off_within_deadband=OffTru)
        annotation (Placement(transformation(extent={{50,-40},{80,-8}})));
      Buildings.Experimental.RadiantControl.SlabTemperatureSignal.DeadbandControl deaConTesFal1(
        TDeaRel=TemDeaRel,
        TDeaNor=TemDeaNor,
        k=LastOcc,
        off_within_deadband=OffFal)
        annotation (Placement(transformation(extent={{50,-92},{80,-60}})));
    equation
      connect(sin.y, deaCon.slaTemErr) annotation (Line(points={{-38,30},{-24,
              30},{-24,40.8},{-21.7333,40.8}},
                                      color={0,0,127}));
      connect(sin1.y, deaCon2.slaTemErr) annotation (Line(points={{-38,-50},{
              -24,-50},{-24,-39.2},{-21.7333,-39.2}},
                                             color={0,0,127}));
      connect(sin1.y, deaCon3.slaTemErr) annotation (Line(points={{-38,-50},{
              -24,-50},{-24,-79.2},{-21.7333,-79.2}},
                                             color={0,0,127}));
      connect(sin.y, deaCon1.slaTemErr) annotation (Line(points={{-38,30},{-24,
              30},{-24,0.8},{-21.7333,0.8}},
                                        color={0,0,127}));
      connect(sin.y, deaConTes.slaTemErr) annotation (Line(points={{-38,30},{20,30},
              {20,61.28},{47.4,61.28}}, color={0,0,127}));
      connect(sin.y, deaConTesFal.slaTemErr) annotation (Line(points={{-38,30},{20,30},
              {20,9.28},{47.4,9.28}}, color={0,0,127}));
      connect(sin1.y, deaConTes1.slaTemErr) annotation (Line(points={{-38,-50},{22,-50},
              {22,-38.72},{47.4,-38.72}}, color={0,0,127}));
      connect(sin1.y, deaConTesFal1.slaTemErr) annotation (Line(points={{-38,-50},{22,
              -50},{22,-90.72},{47.4,-90.72}}, color={0,0,127}));
      annotation (Documentation(info="<html>
<p>
This validates the deadband control, which determines whether the slab is in heating or in cooling. 
Two error sizes were tested, as well as two options- 
one in which the slab is allowed to receive no flow if it is within deadband, 
and the other in which the slab must receive either heating or cooling at all times.
</p>
</html>",     revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated description. 
</li>
</html>"),    experiment(StartTime=0,StopTime=172800.0, Tolerance=1e-06),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/RadiantControl/SlabTemperatureSignal/Validation/DeadbandControl.mos"
            "Simulate and plot"),Icon(
            coordinateSystem(extent={{-100,-120},{100,100}}),         graphics={
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
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
    end DeadbandControl;

    model SlabError "Validation model for slab temperature error block"

        final parameter Real TSlaSet(min=0,
        final unit="K",
        final displayUnit="K",
        final quantity="Temperature")=294.3;
      Controls.OBC.CDL.Continuous.Sources.Sine sin(
        amplitude=TSlaSet/5,
        freqHz=1/86400,
        phase(displayUnit="rad"),
        offset=TSlaSet) "Varying slab temperature"
        annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
      Controls.OBC.CDL.Continuous.Sources.Constant TSlaStp(k=TSlaSet)
        "Slab temperature setpoint (constant)"
        annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
      Error err annotation (Placement(transformation(extent={{6,4},{26,24}})));
    equation
      connect(sin.y, err.TSla) annotation (Line(points={{-18,30},{-10,30},{-10,15},{
              4,15}}, color={0,0,127}));
      connect(TSlaStp.y, err.TSlaSet) annotation (Line(points={{-18,-10},{-12,-10},{
              -12,11},{4,11}}, color={0,0,127}));
      annotation (Documentation(info="<html>
<p>
This validates the slab error model, ie the difference between the slab temperature and its setpoint.
</p>
</html>",     revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated description. 
</li>
</html>"),    experiment(StartTime=0.0, StopTime=172000.0, Tolerance=1e-06),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/RadiantControl/SlabTemperatureSignal/Validation/SlabError.mos"
            "Simulate and plot"),Icon(graphics={
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
    end SlabError;

    model SlabSetpointPerimeterZone
      "Validation model for slab setpoint for a perimeter zone"
      final parameter Real TOut(min=0,
        final unit="K",
        final displayUnit="K",
        final quantity="Temperature")=294.3;
      SlabSetpointPerimeter slaSetPer
        annotation (Placement(transformation(extent={{-4,20},{16,40}})));
      Controls.OBC.CDL.Continuous.Sources.TimeTable timTab(table=[0,274.8166667;
            86400,274.8167222; 172800,280.3722222; 259200,280.3727778; 345600,
            285.9277778; 432000,285.9283333; 518400,291.4833333; 604800,291.4838889;
            691200,292.5944444; 777600,292.5945; 864000,293.15; 950400,293.1500556;
            1036800,295.3722222; 1123200,295.3722778; 1209600,295.9277778; 1296000,
            295.9278333; 1382400,299.8166667; 1468800,299.8172222; 1555200,
            302.5944444], extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
        annotation (Placement(transformation(extent={{-60,18},{-40,38}})));
    equation
      connect(timTab.y[1], slaSetPer.TFor) annotation (Line(points={{-38,28},{-22,28},{
              -22,30},{-6,30}}, color={0,0,127}));
      annotation (Documentation(info="<html>
<p>
This validates the slab setpoint for a perimeter zone based on forecast OAT.
</p>
</html>",     revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated description. 
</li>
</html>"),    experiment(StartTime=0, StopTime=1641600.0, Tolerance=1e-06),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/RadiantControl/SlabTemperatureSignal/Validation/SlabSetpointPerimeterZone.mos"
            "Simulate and plot"),Icon(graphics={
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
    end SlabSetpointPerimeterZone;

    package BaseClasses "Base classes for validation models"

      block ForecastHighChicago
        "Outputs next-day forecast high temperature for Chicago"
        Utilities.Time.ModelTime modTim1 "Model timer for forecast high"
          annotation (Placement(transformation(extent={{32,26},{52,46}})));
        Controls.SetPoints.Table forHi(table=[0,272.05; 86400,275.35; 172800,273.75;
              259200,272.55; 345600,269.85; 432000,262.05; 518400,260.35; 604800,
              264.85; 691200,274.85; 777600,275.35; 864000,277.55; 950400,277.05;
              1036800,268.15; 1123200,270.35; 1209600,275.95; 1296000,283.15; 1382400,
              284.85; 1468800,280.35; 1555200,275.35; 1641600,274.85; 1728000,285.35;
              1814400,276.45; 1900800,277.05; 1987200,275.95; 2073600,275.95; 2160000,
              266.45; 2246400,258.15; 2332800,265.35; 2419200,266.45; 2505600,267.55;
              2592000,272.05; 2678400,268.15; 2764800,272.55; 2851200,272.55; 2937600,
              272.55; 3024000,261.45; 3110400,263.75; 3196800,264.25; 3283200,269.25;
              3369600,278.15; 3456000,281.45; 3542400,287.05; 3628800,279.85; 3715200,
              275.35; 3801600,272.05; 3888000,268.75; 3974400,269.85; 4060800,276.45;
              4147200,279.85; 4233600,273.15; 4320000,272.55; 4406400,275.35; 4492800,
              284.85; 4579200,287.55; 4665600,283.75; 4752000,277.55; 4838400,274.85;
              4924800,273.15; 5011200,275.95; 5097600,279.25; 5184000,278.15; 5270400,
              274.85; 5356800,283.15; 5443200,270.95; 5529600,274.85; 5616000,279.85;
              5702400,284.25; 5788800,284.85; 5875200,289.85; 5961600,283.75; 6048000,
              282.55; 6134400,276.45; 6220800,282.05; 6307200,282.05; 6393600,283.15;
              6480000,275.35; 6566400,280.35; 6652800,290.35; 6739200,278.75; 6825600,
              281.45; 6912000,280.95; 6998400,279.85; 7084800,278.15; 7171200,279.85;
              7257600,290.95; 7344000,294.25; 7430400,288.15; 7516800,286.45; 7603200,
              276.45; 7689600,280.95; 7776000,277.55; 7862400,279.85; 7948800,277.55;
              8035200,275.35; 8121600,278.15; 8208000,279.25; 8294400,282.55; 8380800,
              284.25; 8467200,283.15; 8553600,290.95; 8640000,297.05; 8726400,292.05;
              8812800,289.85; 8899200,297.55; 8985600,304.25; 9072000,303.75; 9158400,
              302.05; 9244800,304.25; 9331200,292.55; 9417600,281.45; 9504000,278.75;
              9590400,279.25; 9676800,288.75; 9763200,295.95; 9849600,285.35; 9936000,
              283.75; 10022400,284.85; 10108800,288.15; 10195200,289.25; 10281600,
              288.15; 10368000,289.85; 10454400,297.05; 10540800,297.55; 10627200,
              303.15; 10713600,303.75; 10800000,295.95; 10886400,286.45; 10972800,
              285.35; 11059200,290.95; 11145600,295.35; 11232000,291.45; 11318400,
              290.35; 11404800,293.15; 11491200,288.15; 11577600,289.25; 11664000,
              289.85; 11750400,286.45; 11836800,289.25; 11923200,292.05; 12009600,
              296.45; 12096000,300.35; 12182400,300.95; 12268800,297.05; 12355200,
              298.15; 12441600,300.35; 12528000,295.95; 12614400,302.55; 12700800,
              302.55; 12787200,300.35; 12873600,302.55; 12960000,298.15; 13046400,
              298.15; 13132800,298.15; 13219200,302.05; 13305600,303.75; 13392000,
              294.25; 13478400,305.35; 13564800,299.85; 13651200,306.45; 13737600,
              299.85; 13824000,296.45; 13910400,298.75; 13996800,295.35; 14083200,
              295.95; 14169600,303.15; 14256000,304.85; 14342400,304.25; 14428800,
              298.15; 14515200,292.05; 14601600,302.05; 14688000,305.35; 14774400,
              303.75; 14860800,297.55; 14947200,288.15; 15033600,293.75; 15120000,
              299.85; 15206400,303.75; 15292800,303.75; 15379200,303.15; 15465600,
              299.85; 15552000,300.35; 15638400,292.05; 15724800,297.05; 15811200,
              297.55; 15897600,303.75; 15984000,305.95; 16070400,305.95; 16156800,
              302.05; 16243200,301.45; 16329600,296.45; 16416000,297.55; 16502400,
              298.75; 16588800,300.95; 16675200,302.05; 16761600,298.15; 16848000,
              305.35; 16934400,306.45; 17020800,307.05; 17107200,307.05; 17193600,
              308.15; 17280000,302.55; 17366400,300.95; 17452800,302.55; 17539200,
              304.25; 17625600,305.35; 17712000,303.15; 17798400,300.95; 17884800,
              304.85; 17971200,303.15; 18057600,300.95; 18144000,302.55; 18230400,
              304.85; 18316800,300.95; 18403200,302.55; 18489600,304.85; 18576000,
              304.25; 18662400,303.15; 18748800,294.85; 18835200,294.85; 18921600,
              298.15; 19008000,300.35; 19094400,301.45; 19180800,299.85; 19267200,
              301.45; 19353600,301.45; 19440000,298.75; 19526400,297.55; 19612800,
              296.45; 19699200,298.75; 19785600,298.15; 19872000,299.25; 19958400,
              302.05; 20044800,303.75; 20131200,302.05; 20217600,295.95; 20304000,
              295.95; 20390400,298.15; 20476800,299.85; 20563200,301.45; 20649600,
              301.45; 20736000,302.55; 20822400,300.95; 20908800,301.45; 20995200,
              298.75; 21081600,293.75; 21168000,295.35; 21254400,302.05; 21340800,
              304.25; 21427200,303.15; 21513600,297.05; 21600000,299.85; 21686400,
              299.25; 21772800,299.85; 21859200,300.35; 21945600,299.25; 22032000,
              293.75; 22118400,297.05; 22204800,299.25; 22291200,295.35; 22377600,
              294.85; 22464000,293.15; 22550400,294.85; 22636800,289.85; 22723200,
              289.25; 22809600,294.25; 22896000,297.55; 22982400,293.75; 23068800,
              293.75; 23155200,302.05; 23241600,304.85; 23328000,300.35; 23414400,
              292.05; 23500800,292.05; 23587200,292.55; 23673600,295.95; 23760000,
              292.55; 23846400,289.85; 23932800,288.75; 24019200,286.45; 24105600,
              285.35; 24192000,287.55; 24278400,295.95; 24364800,289.85; 24451200,
              289.85; 24537600,289.85; 24624000,289.85; 24710400,283.15; 24796800,
              283.75; 24883200,285.35; 24969600,287.05; 25056000,288.15; 25142400,
              288.75; 25228800,295.95; 25315200,299.25; 25401600,295.95; 25488000,
              284.25; 25574400,286.45; 25660800,289.25; 25747200,285.35; 25833600,
              290.35; 25920000,286.45; 26006400,287.55; 26092800,293.75; 26179200,
              286.45; 26265600,288.75; 26352000,294.85; 26438400,294.25; 26524800,
              288.15; 26611200,286.45; 26697600,288.15; 26784000,287.55; 26870400,
              290.35; 26956800,291.45; 27043200,276.45; 27129600,277.05; 27216000,
              275.95; 27302400,277.55; 27388800,284.85; 27475200,288.75; 27561600,
              284.85; 27648000,280.35; 27734400,279.25; 27820800,280.95; 27907200,
              288.15; 27993600,275.35; 28080000,277.05; 28166400,276.45; 28252800,
              277.05; 28339200,273.15; 28425600,265.95; 28512000,270.95; 28598400,
              268.15; 28684800,273.75; 28771200,276.25; 28857600,281.45; 28944000,
              274.85; 29030400,277.55; 29116800,277.05; 29203200,276.45; 29289600,
              280.35; 29376000,284.25; 29462400,276.45; 29548800,271.45; 29635200,
              272.55; 29721600,273.15; 29808000,275.35; 29894400,275.35; 29980800,
              273.75; 30067200,267.55; 30153600,267.55; 30240000,268.15; 30326400,
              267.55; 30412800,265.35; 30499200,267.55; 30585600,273.75; 30672000,
              273.75; 30758400,272.55; 30844800,271.45; 30931200,274.25; 31017600,
              274.25; 31104000,272.55; 31190400,270.95; 31276800,265.35; 31363200,
              271.45; 31449600,275.95])
          "Forecast high lookup table: x axis time in seconds, y axis forecast high temperature"
          annotation (Placement(transformation(extent={{-6,-30},{-48,12}})));
        Controls.OBC.CDL.Interfaces.RealOutput TForHiChi
          "Forecasted high temperature"
          annotation (Placement(transformation(extent={{100,-18},{140,22}})));
        Controls.OBC.CDL.Discrete.Sampler sam(samplePeriod=86400)
          "Samples forecast temperature each day"
          annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
      equation
        connect(modTim1.y, forHi.u) annotation (Line(points={{53,36},{70,36},{70,-9},
                {-1.8,-9}}, color={0,0,127}));
        connect(sam.y, TForHiChi) annotation (Line(points={{42,-70},{80,-70},{80,2},{
                120,2}}, color={0,0,127}));
        connect(forHi.y, sam.u) annotation (Line(points={{-50.1,-9},{-60,-9},{-60,-70},
                {18,-70}}, color={0,0,127}));
        annotation (defaultComponentName = "forHiChi",Documentation(info="<html>
<p>
This outputs the next-day high temperature for Chicago, so that an appropriate radiant slab setpoint can be chosen from the lookup table. 
</p>
</html>",       revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated description. 
</li>
</html>"),      Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={
              Text(
                lineColor={0,0,255},
                extent={{-150,110},{150,150}},
                textString="%name"),  Rectangle(
              extent={{-100,-100},{100,100}},
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
             Text(
                extent={{-72,78},{102,6}},
                lineColor={0,0,0},
                fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="F"),
              Text(
                extent={{226,60},{106,10}},
                lineColor={0,0,0},
                textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(
              coordinateSystem(preserveAspectRatio=false), graphics={Text(
                extent={{-94,110},{24,66}},
                lineColor={0,0,0},
                lineThickness=1,
                horizontalAlignment=TextAlignment.Left,
                fontSize=14,
                fontName="Arial Narrow",
                textStyle={TextStyle.Bold},
                textString="Chicago Forecast High Outdoor Temperature")}));
      end ForecastHighChicago;

      package Validation "Validation models for output-only blocks"

        model ChicagoForecastHigh
          "Validation model for forecast high temperature for Chicago"
          ForecastHighChicago forHiChi
            annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
          BoundaryConditions.WeatherData.ReaderTMY3 weaDat2(filNam=
                ModelicaServices.ExternalReferences.loadResource(
                "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
            "Weather data reader"
            annotation (Placement(transformation(extent={{26,24},{46,44}})));
          BoundaryConditions.WeatherData.Bus weaBus1
                                                    annotation (Placement(
                transformation(extent={{8,54},{48,94}}),     iconTransformation(extent={
                    {-168,106},{-148,126}})));
        equation
          connect(weaDat2.weaBus,weaBus1. TDryBul) annotation (Line(
              points={{46,34},{40,34},{40,74},{28,74}},
              color={255,204,51},
              thickness=0.5), Text(
              string="%second",
              index=1,
              extent={{-6,3},{-6,3}},
              horizontalAlignment=TextAlignment.Right));
          annotation (experiment(Tolerance=1E-06, StopTime=172800),
        __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/RadiantControl/SlabTemperatureSignal/Validation/BaseClasses/Validation/ChicagoForecastHigh.mos"
                "Simulate and plot"), Documentation(info="<html>
<p>
This validates the Chicago forecast high. 
</p>
</html>"),        Icon(graphics={
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
        end ChicagoForecastHigh;
      annotation (Documentation(info="<html>
  <p>
  This package contains a validation model for the base class for the validation models for the slab temperature signal module. 
<p>
</p>
</p>
</html>",       revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated package description.<br/>
</li>
</html>"));
      end Validation;
    annotation (Documentation(info="<html>
  <p>
  This package contains base classes for the validation models for the slab temperature signal module. 
<p>
</p>
</p>
</html>",     revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated package description.<br/>
</li>
</html>"));
    end BaseClasses;
    annotation (preferredView="info", Documentation(info="<html>

This package contains validation models blocks that determine the slab setpoint as well as calls for radiant slab heating or cooling.
<li> This package includes three models that validate the three blocks: 
<li> 1. DeadbandControl: determines the slab heating or cooling signal based on the slab temperature error.
<li> 2. Error: calculates the slab temperature error (i.e., slab temperature distance from setpoint)
<li> 3. SlabSetpointPerimeter:: determines the slab setpoint from the outdoor air temperature forecast high. 
</p>
</html>",   revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated package description.<br/>
</li> 
</html>"));
  end Validation;
  annotation (preferredView="info", Documentation(info="<html>

This package contains the blocks that determine the slab setpoint as well as calls for radiant slab heating or cooling.
<li> This package includes three blocks: 
<li> 1. DeadbandControl: determines the slab heating or cooling signal based on the slab temperature error.
<li> 2. Error: calculates the slab temperature error (i.e., slab temperature distance from setpoint)
<li> 3. SlabSetpointPerimeter:: determines the slab setpoint from the outdoor air temperature forecast high. 
<li> These blocks are used together in the ControlPlusLockouts block (<a href=\"modelica://Buildings.Experimental.RadiantControl.ControlPlusLockouts\">
Buildings.Experimental.RadiantControl.ControlPlusLockouts</a>)
<li> to determine the slab setpoint and calls for heating & cooling. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated package description.<br/>
</li> 
</html>"));
end SlabTemperatureSignal;
