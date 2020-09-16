within Buildings.Experimental.RadiantControl.Lockouts.SubLockouts;
block HysteresisLimit
  "Locks out heating if cooling occurred in the past hour; locks out cooling if heating occurred in the past hour"
   parameter Real TiHea(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which heating is locked out after cooling concludes";
   parameter Real TiCoo(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which cooling is locked out after heating concludes";
  Controls.OBC.CDL.Logical.LogicalSwitch           logSwiHot
    "Once simulation has been running for one hour, enables hysteresis prevention"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{-260,-20},{-240,0}})));
  Utilities.Time.ModelTime modTim
    annotation (Placement(transformation(extent={{-320,-42},{-300,-22}})));
  Controls.Continuous.OffTimer           offTimHot
    "Records time since heating turned off"
    annotation (Placement(transformation(extent={{-220,80},{-200,100}})));
  Controls.OBC.CDL.Logical.Pre           pre(pre_u_start=false)
                                             "Breaks Boolean loop"
    annotation (Placement(transformation(extent={{-260,80},{-240,100}})));
  Controls.OBC.CDL.Interfaces.BooleanInput heaSig annotation (Placement(
        transformation(extent={{-380,40},{-340,80}}), iconTransformation(extent=
           {{-142,22},{-102,62}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput clgSigHys
    "True if cooling allowed; false if cooling locked out" annotation (
      Placement(transformation(extent={{100,-112},{140,-72}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Controls.OBC.CDL.Interfaces.BooleanInput cooSig annotation (Placement(
        transformation(extent={{-380,-140},{-340,-100}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput htgSigHys
    "True if heating allowed; false if heating locked out" annotation (
      Placement(transformation(extent={{100,-26},{140,14}}), iconTransformation(
          extent={{100,0},{140,40}})));
  Controls.OBC.CDL.Logical.Pre           pre1(pre_u_start=false)
                                              "Breaks Boolean loop"
    annotation (Placement(transformation(extent={{-260,-100},{-240,-80}})));
  Controls.Continuous.OffTimer offTimCol
    "Records time since cooling turned off"
    annotation (Placement(transformation(extent={{-220,-100},{-200,-80}})));
  Controls.OBC.CDL.Logical.LogicalSwitch           logSwiCold
    "Once simulation has been running for one hour, enables hysteresis prevention"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1
    annotation (Placement(transformation(extent={{-262,-142},{-242,-122}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-82,80},{-62,100}})));
  Modelica.Blocks.Logical.Not not2
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys(
    uLow=TiCoo - 0.1,
    uHigh=TiCoo,
    pre_y_start=true)
    "Checks if heating valve has been closed for user-specified duration"
    annotation (Placement(transformation(extent={{-178,80},{-158,100}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys1(
    uLow=TiCoo - 0.1,
    uHigh=TiCoo,
    pre_y_start=false)
    "Checks if simulation has been running for at least lockout duration: if not, no hysteresis lockouts"
    annotation (Placement(transformation(extent={{-260,20},{-240,40}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys2(
    uLow=TiHea - 0.1,
    uHigh=TiHea,
    pre_y_start=false)
    "Checks if simulation has been running for at least lockout duration: if not, no hysteresis lockouts"
    annotation (Placement(transformation(extent={{-260,-60},{-240,-40}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys3(
    uLow=TiHea - 0.1,
    uHigh=TiHea,
    pre_y_start=true)
    "Checks if cooling valve has been closed for user-specified duration"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));
equation
  connect(booleanConstant.y,logSwiHot. u3) annotation (Line(points={{-239,-10},
          {-120,-10},{-120,22},{-102,22}},      color={255,0,255}));
  connect(pre.y,offTimHot. u) annotation (Line(points={{-238,90},{-222,90}},
                                                color={255,0,255}));
  connect(heaSig, pre.u) annotation (Line(points={{-360,60},{-280,60},{-280,90},
          {-262,90}}, color={255,0,255}));
  connect(pre1.y, offTimCol.u)
    annotation (Line(points={{-238,-90},{-222,-90}}, color={255,0,255}));
  connect(booleanConstant1.y, logSwiCold.u3) annotation (Line(points={{-241,
          -132},{-241,-134},{-120,-134},{-120,-118},{-102,-118}},
                                                      color={255,0,255}));
  connect(cooSig, pre1.u) annotation (Line(points={{-360,-120},{-290,-120},{-290,
          -90},{-262,-90}}, color={255,0,255}));
  connect(logSwiHot.y, and1.u2) annotation (Line(points={{-78,30},{-62,30},{-62,
          22},{-42,22}}, color={255,0,255}));
  connect(heaSig, not1.u) annotation (Line(points={{-360,60},{-280,60},{-280,
          122},{-102,122},{-102,90},{-84,90}},
                               color={255,0,255}));
  connect(not1.y, and1.u1) annotation (Line(points={{-61,90},{-52,90},{-52,30},{
          -42,30}}, color={255,0,255}));
  connect(and1.y, clgSigHys) annotation (Line(points={{-19,30},{20,30},{20,-92},
          {120,-92}}, color={255,0,255}));
  connect(and2.y, htgSigHys) annotation (Line(points={{-19,-130},{40,-130},{40,-6},
          {120,-6}}, color={255,0,255}));
  connect(cooSig, not2.u) annotation (Line(points={{-360,-120},{-290,-120},{-290,
          -150},{-82,-150}}, color={255,0,255}));
  connect(logSwiCold.y, and2.u1) annotation (Line(points={{-78,-110},{-60,-110},
          {-60,-130},{-42,-130}}, color={255,0,255}));
  connect(not2.y, and2.u2) annotation (Line(points={{-59,-150},{-52,-150},{-52,-138},
          {-42,-138}}, color={255,0,255}));
  connect(offTimHot.y, hys.u)
    annotation (Line(points={{-199,90},{-180,90}}, color={0,0,127}));
  connect(modTim.y, hys1.u) annotation (Line(points={{-299,-32},{-280,-32},{
          -280,30},{-262,30}}, color={0,0,127}));
  connect(hys1.y, logSwiHot.u2)
    annotation (Line(points={{-238,30},{-102,30}}, color={255,0,255}));
  connect(hys.y, logSwiHot.u1) annotation (Line(points={{-156,90},{-120,90},{
          -120,38},{-102,38}}, color={255,0,255}));
  connect(hys2.y, logSwiCold.u2) annotation (Line(points={{-238,-50},{-140,-50},
          {-140,-110},{-102,-110}}, color={255,0,255}));
  connect(modTim.y, hys2.u) annotation (Line(points={{-299,-32},{-280.5,-32},{
          -280.5,-50},{-262,-50}}, color={0,0,127}));
  connect(offTimCol.y, hys3.u)
    annotation (Line(points={{-199,-90},{-182,-90}}, color={0,0,127}));
  connect(hys3.y, logSwiCold.u1) annotation (Line(points={{-158,-90},{-121,-90},
          {-121,-102},{-102,-102}}, color={255,0,255}));
  annotation (defaultComponentName = "hysLim",Documentation(info="<html>
<p>
Cooling is locked out for a specified amount of time after heating turns off (typically 1hr). 
Heating is locked out for a specified amount of time after cooling turns off (typically 1hr).
 Output is expressed as a heating or cooling signal. If the heating signal is true, heating is allowed (ie, it is not locked out).
  If the cooling signal is true, cooling is allowed (ie, it is not locked out).
  A true signal indicates only that heating or cooling is *permitted*- it does *not* indicate the actual status
  of the final heating or cooling signal, which depends on the slab temperature and slab setpoint (see SlabTempSignal for more info).
</p>
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
          extent={{-340,-180},{100,140}})));
end HysteresisLimit;
