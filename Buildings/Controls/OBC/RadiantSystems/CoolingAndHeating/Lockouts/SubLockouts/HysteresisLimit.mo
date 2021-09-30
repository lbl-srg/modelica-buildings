within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts;
block HysteresisLimit
  "Locks out heating if cooling occurred in the past hour; locks out cooling if heating occurred in the past hour"
   parameter Real heaLocDurAftCoo(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which heating is locked out after cooling concludes";
   parameter Real cooLocDurAftHea(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which cooling is locked out after heating concludes";
  Controls.OBC.CDL.Logical.LogicalSwitch logSwiHot
    "Once simulation has been running for user-specified time duration, enables hysteresis prevention"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Utilities.Time.ModelTime modTim "Model time"
    annotation (Placement(transformation(extent={{-320,-40},{-300,-20}})));
  Controls.OBC.CDL.Logical.Pre           pre(pre_u_start=false)
                                             "Breaks Boolean loop"
    annotation (Placement(transformation(extent={{-260,80},{-240,100}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating signal- true if heating is on; false if not"
                                                  annotation (Placement(
        transformation(extent={{-380,40},{-340,80}}), iconTransformation(extent=
           {{-142,22},{-102,62}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yCooNotLoc
    "True if cooling allowed; false if cooling locked out" annotation (
      Placement(transformation(extent={{100,-112},{140,-72}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling signal- true if cooling is on; false if not"
                                                  annotation (Placement(
        transformation(extent={{-380,-140},{-340,-100}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yHeaNotLoc
    "True if heating allowed; false if heating locked out" annotation (
      Placement(transformation(extent={{100,-26},{140,14}}), iconTransformation(
          extent={{100,0},{140,40}})));
  Controls.OBC.CDL.Logical.Pre           pre1(pre_u_start=false)
                                              "Breaks Boolean loop"
    annotation (Placement(transformation(extent={{-260,-120},{-240,-100}})));
  Controls.Continuous.OffTimer offTimCol
    "Records time since cooling turned off"
    annotation (Placement(transformation(extent={{-220,-120},{-200,-100}})));
  Controls.OBC.CDL.Logical.LogicalSwitch logSwiCol
    "Once simulation has been running for user-specified time duration, enables hysteresis prevention"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys(
    uLow=cooLocDurAftHea - 0.1,
    uHigh=cooLocDurAftHea,
    pre_y_start=true)
    "Checks if heating has been off for user-specified duration"
    annotation (Placement(transformation(extent={{-178,80},{-158,100}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys1(
    uLow=cooLocDurAftHea - 0.1,
    uHigh=cooLocDurAftHea,
    pre_y_start=false)
    "Checks if simulation has been running for at least lockout duration: if not, no hysteresis lockouts"
    annotation (Placement(transformation(extent={{-260,20},{-240,40}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys2(
    uLow=heaLocDurAftCoo - 0.1,
    uHigh=heaLocDurAftCoo,
    pre_y_start=false)
    "Checks if simulation has been running for at least lockout duration: if not, no hysteresis lockouts"
    annotation (Placement(transformation(extent={{-260,-60},{-240,-40}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys3(
    uLow=heaLocDurAftCoo - 0.1,
    uHigh=heaLocDurAftCoo,
    pre_y_start=true)
    "Checks if cooling has been off for user-specified duration"
    annotation (Placement(transformation(extent={{-180,-120},{-160,-100}})));
  Controls.OBC.CDL.Logical.Sources.Constant con(k=true)
    "Constant true if time < threshhold"
    annotation (Placement(transformation(extent={{-260,-20},{-240,0}})));
  Controls.OBC.CDL.Logical.Sources.Constant con1(k=true)
    "Constant true if time < threshhold"
    annotation (Placement(transformation(extent={{-260,-170},{-240,-150}})));
  Controls.OBC.CDL.Logical.Not not3 "Negates cooling signal output"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Controls.OBC.CDL.Logical.And and3
    "True (heating is allowed) if cooling signal is currently false AND cooling has been off for specified duration"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Controls.OBC.CDL.Logical.And and2
    "True (cooling is allowed) if heating signal is currently false AND heating has been off for specified duration"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Controls.OBC.CDL.Logical.Not not2 "Negates heating signal output"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Controls.Continuous.OffTimer offTimHot
    "Records time since heating turned off"
    annotation (Placement(transformation(extent={{-218,80},{-198,100}})));
equation
  connect(uHea, pre.u) annotation (Line(points={{-360,60},{-280,60},{-280,90},
          {-262,90}}, color={255,0,255}));
  connect(pre1.y, offTimCol.u)
    annotation (Line(points={{-238,-110},{-222,-110}},
                                                     color={255,0,255}));
  connect(uCoo, pre1.u) annotation (Line(points={{-360,-120},{-290,-120},{
          -290,-110},{-262,-110}},
                            color={255,0,255}));
  connect(modTim.y, hys1.u) annotation (Line(points={{-299,-30},{-280,-30},{
          -280,30},{-262,30}}, color={0,0,127}));
  connect(hys1.y, logSwiHot.u2)
    annotation (Line(points={{-238,30},{-102,30}}, color={255,0,255}));
  connect(hys.y, logSwiHot.u1) annotation (Line(points={{-156,90},{-120,90},{
          -120,38},{-102,38}}, color={255,0,255}));
  connect(hys2.y, logSwiCol.u2) annotation (Line(points={{-238,-50},{-120,-50},
          {-120,-110},{-102,-110}}, color={255,0,255}));
  connect(modTim.y, hys2.u) annotation (Line(points={{-299,-30},{-280.5,-30},{
          -280.5,-50},{-262,-50}}, color={0,0,127}));
  connect(offTimCol.y, hys3.u)
    annotation (Line(points={{-199,-110},{-182,-110}},
                                                     color={0,0,127}));
  connect(hys3.y, logSwiCol.u1) annotation (Line(points={{-158,-110},{-140,-110},
          {-140,-102},{-102,-102}}, color={255,0,255}));
  connect(con.y, logSwiHot.u3) annotation (Line(points={{-238,-10},{-170,-10},{
          -170,22},{-102,22}}, color={255,0,255}));
  connect(con1.y, logSwiCol.u3) annotation (Line(points={{-238,-160},{-122,-160},
          {-122,-118},{-102,-118}}, color={255,0,255}));
  connect(uCoo, not3.u) annotation (Line(points={{-360,-120},{-294,-120},{
          -294,-176},{-112,-176},{-112,-150},{-82,-150}}, color={255,0,255}));
  connect(logSwiCol.y, and3.u1) annotation (Line(points={{-78,-110},{-62,-110},
          {-62,-130},{-42,-130}}, color={255,0,255}));
  connect(not3.y, and3.u2) annotation (Line(points={{-58,-150},{-52,-150},{-52,
          -138},{-42,-138}}, color={255,0,255}));
  connect(and3.y, yHeaNotLoc) annotation (Line(points={{-18,-130},{60,-130},{60,
          -6},{120,-6}}, color={255,0,255}));
  connect(uHea, not2.u) annotation (Line(points={{-360,60},{-280,60},{-280,
          114},{-114,114},{-114,90},{-82,90}}, color={255,0,255}));
  connect(not2.y, and2.u1) annotation (Line(points={{-58,90},{-46,90},{-46,30},
          {-42,30}}, color={255,0,255}));
  connect(logSwiHot.y, and2.u2) annotation (Line(points={{-78,30},{-62,30},{-62,
          22},{-42,22}}, color={255,0,255}));
  connect(and2.y, yCooNotLoc) annotation (Line(points={{-18,30},{20,30},{20,-92},
          {120,-92}}, color={255,0,255}));
  connect(offTimHot.y, hys.u)
    annotation (Line(points={{-197,90},{-180,90}}, color={0,0,127}));
  connect(pre.y, offTimHot.u)
    annotation (Line(points={{-238,90},{-220,90}}, color={255,0,255}));
  annotation (defaultComponentName = "hysLim",Documentation(info="<html>
<p>
Cooling is locked out for a specified amount of time after heating turns off (typically 1hr). 
Heating is locked out for a specified amount of time after cooling turns off (typically 1hr).
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
        preserveAspectRatio=false, extent={{-100,-100},{100,100}}),      graphics={
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
        extent={{-90,90},{90,-90}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        textString="H"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-340,-180},{100,160}}), graphics={
        Rectangle(
          extent={{-300,120},{-80,-20}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          extent={{-230,90},{194,-12}},
          lineColor={28,108,200},
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          textString="If model time is greater
 than user-specified time threshold, 
check if heating has been off
 for at least threshold amount of time. 
If model time < user-specified threshold,
 output true. "),
        Text(
          extent={{-294,-56},{-248,-102}},
          lineColor={238,46,47},
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          textString="If model time is greater than user-specified time threshold, 
check if cooling has been off for at least threshold amount of time. 
If model time < user-specified threshold,
 output true. "),
        Rectangle(
          extent={{-300,-40},{-80,-180}},
          lineColor={238,46,47},
          lineThickness=1),
        Rectangle(
          extent={{-80,120},{40,-20}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-80,-40},{40,-180}},
          lineColor={238,46,47},
          lineThickness=1),
        Text(
          extent={{-42,122},{382,20}},
          lineColor={28,108,200},
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          textString="If heating has been off 
for specified amount of time 
AND is currently off, 
cooling is not locked out 
(cooling signal is true)"),
        Text(
          extent={{-70,-26},{354,-128}},
          lineColor={238,46,47},
          fontName="Arial Narrow",
          horizontalAlignment=TextAlignment.Left,
          textString="If cooling has been off 
for specified amount of time 
AND is currently off, 
heating is not locked out 
(heating signal is true)"),
        Text(
          extent={{-284,150},{92,134}},
          lineColor={0,0,0},
          lineThickness=1,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Hysteresis Lockout: 
Locks out cooling if heating has been on within a user-specified time threshold;
Locks out heating if cooling has been on within a user-specified time threshold")}));
end HysteresisLimit;
