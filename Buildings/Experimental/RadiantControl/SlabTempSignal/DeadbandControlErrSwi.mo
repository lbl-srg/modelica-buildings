within Buildings.Experimental.RadiantControl.SlabTempSignal;
block DeadbandControlErrSwi
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
    "Call for heating or cooling in times of relaxed deadband, i.e. during unoccupied hours"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Modelica.Blocks.Logical.LogicalSwitch logSwi
    "Switches between occupied and unoccupied deadband based on time of day"
    annotation (Placement(transformation(extent={{-40,-118},{-20,-98}})));
  Modelica.Blocks.Sources.BooleanPulse booPul(width=w, period=86400)
    "1 if slab needs to meet occupied setpoint within tight deadband, 0 if looser deadband (after occupied hours)"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Controls.OBC.CDL.Continuous.Hysteresis           hys(uLow=-TDeaNor, uHigh=TDeaNor)
    "Call for heating or cooling in times of tight deadband, i.e. during occupied hours"
    annotation (Placement(transformation(extent={{-120,-62},{-100,-42}})));
  Controls.OBC.CDL.Logical.Not           not1
    "Negates hysteresis for heating control"
    annotation (Placement(transformation(extent={{20,-26},{40,-6}})));
  Controls.OBC.CDL.Interfaces.RealInput slaTemErr
    annotation (Placement(transformation(extent={{-196,-158},{-156,-118}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput htgCal
    "True if there is a call for heating; false if not"
    annotation (Placement(transformation(extent={{150,-10},{190,30}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput clgCal
    "True if there is a call for cooling; false if not"
    annotation (Placement(transformation(extent={{150,-110},{190,-70}})));
  Modelica.Blocks.Logical.LogicalSwitch logiSwi1
    "Switches between occupied and unoccupied deadband based on time of day"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Controls.OBC.CDL.Continuous.Abs           abs
    "Absolute value of difference between slab setpoint and slab temp"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Modelica.Blocks.Logical.And and1
    "Makes sure no heating occurs if error is within deadband"
    annotation (Placement(transformation(extent={{124,2},{144,22}})));
  Modelica.Blocks.Logical.And and2
    "Makes sure no cooling occurs if error is within deadband"
    annotation (Placement(transformation(extent={{120,-102},{140,-82}})));
  Modelica.Blocks.Logical.LogicalSwitch logiSwi2
    "Passes signal if flow is allowed to stop if slab temp is within deadband; if flow is NOT allowed to stop, always passes true"
    annotation (Placement(transformation(extent={{80,118},{100,138}})));
  Modelica.Blocks.Sources.BooleanConstant booCon
    annotation (Placement(transformation(extent={{22,40},{42,60}})));
  Modelica.Blocks.Sources.BooleanConstant booCon1(k=off_within_deadband)
    annotation (Placement(transformation(extent={{22,80},{42,100}})));
  Modelica.Blocks.Logical.Hysteresis hys2(uLow=TDeaNor - 0.1, uHigh=TDeaNor)
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Modelica.Blocks.Logical.Hysteresis hys1(uLow=TDeaRel - 0.1, uHigh=TDeaRel)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
protected
          parameter Real w=(k/24)*100 "Width of day";
equation
  connect(hysRel.y, logSwi.u3) annotation (Line(points={{-98,-130},{-80,-130},{-80,
          -116},{-42,-116}}, color={255,0,255}));
  connect(booPul.y, logSwi.u2) annotation (Line(points={{-99,-90},{-70,-90},{-70,
          -108},{-42,-108}}, color={255,0,255}));
  connect(hys.y, logSwi.u1) annotation (Line(points={{-98,-52},{-78,-52},{-78,-100},
          {-42,-100}}, color={255,0,255}));
  connect(logSwi.y, not1.u) annotation (Line(points={{-19,-108},{18,-108},{18,-16}},
        color={255,0,255}));
  connect(slaTemErr, hys.u) annotation (Line(points={{-176,-138},{-141,-138},{-141,
          -52},{-122,-52}}, color={0,0,127}));
  connect(slaTemErr, hysRel.u) annotation (Line(points={{-176,-138},{-140,-138},
          {-140,-130},{-122,-130}}, color={0,0,127}));
  connect(slaTemErr, abs.u) annotation (Line(points={{-176,-138},{-140,-138},{-140,
          50},{-122,50}}, color={0,0,127}));
  connect(booPul.y, logiSwi1.u2) annotation (Line(points={{-99,-90},{-4,-90},{-4,
          130},{18,130}}, color={255,0,255}));
  connect(not1.y, and1.u2) annotation (Line(points={{42,-16},{116,-16},{116,4},{
          122,4}},  color={255,0,255}));
  connect(logSwi.y, and2.u2) annotation (Line(points={{-19,-108},{96,-108},{96,-100},
          {118,-100}}, color={255,0,255}));
  connect(logiSwi1.y, logiSwi2.u1) annotation (Line(points={{41,130},{56,130},{56,
          136},{78,136}}, color={255,0,255}));
  connect(logiSwi2.y, and2.u1) annotation (Line(points={{101,128},{106,128},{106,
          -92},{118,-92}}, color={255,0,255}));
  connect(booCon.y, logiSwi2.u3) annotation (Line(points={{43,50},{74,50},{74,120},
          {78,120}}, color={255,0,255}));
  connect(logiSwi2.y, and1.u1) annotation (Line(points={{101,128},{106,128},{106,
          12},{122,12}}, color={255,0,255}));
  connect(booCon1.y, logiSwi2.u2) annotation (Line(points={{43,90},{64,90},{64,128},
          {78,128}}, color={255,0,255}));
  connect(and2.y, clgCal) annotation (Line(points={{141,-92},{142,-92},{142,-90},
          {170,-90}}, color={255,0,255}));
  connect(and1.y, htgCal) annotation (Line(points={{145,12},{146,12},{146,10},{170,
          10}}, color={255,0,255}));
  connect(abs.y, hys2.u) annotation (Line(points={{-98,50},{-96,50},{-96,110},{-42,
          110}}, color={0,0,127}));
  connect(hys2.y, logiSwi1.u1) annotation (Line(points={{-19,110},{-12,110},{-12,
          138},{18,138}}, color={255,0,255}));
  connect(abs.y, hys1.u) annotation (Line(points={{-98,50},{-96,50},{-96,30},{-42,
          30}}, color={0,0,127}));
  connect(hys1.y, logiSwi1.u3) annotation (Line(points={{-19,30},{4,30},{4,122},
          {18,122}}, color={255,0,255}));
  annotation (defaultComponentName = "deaConErrSwi", Documentation(info="<html>
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
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="duration=%duration"),
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
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-150,
            -150},{150,150}})));
end DeadbandControlErrSwi;
