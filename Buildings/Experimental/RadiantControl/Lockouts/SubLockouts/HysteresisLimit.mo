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
    annotation (Placement(transformation(extent={{-100,22},{-80,42}})));
  Controls.OBC.CDL.Continuous.Greater           gre4
    "Checks if simulation has been running for at least lockout duration: if not, no hysteresis lockouts"
    annotation (Placement(transformation(extent={{-260,20},{-240,40}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{-260,-22},{-240,-2}})));
  Utilities.Time.ModelTime modTim
    annotation (Placement(transformation(extent={{-320,-42},{-300,-22}})));
  Controls.OBC.CDL.Continuous.Greater           gre3Hot
    "Checks if heating valve has been closed for at least an hour"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Controls.Continuous.OffTimer           offTimHot
    "Records time since heating turned off"
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));
  Controls.OBC.CDL.Logical.Pre           pre(pre_u_start=false)
                                             "Breaks Boolean loop"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));
  Controls.OBC.CDL.Interfaces.BooleanInput heatingSignal
    annotation (Placement(transformation(extent={{-380,50},{-340,90}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput coolingSignal_Hysteresis
    "True if cooling allowed; false if cooling locked out"
    annotation (Placement(transformation(extent={{100,-112},{140,-72}})));
  Controls.OBC.CDL.Interfaces.BooleanInput coolingSignal
    annotation (Placement(transformation(extent={{-380,-110},{-340,-70}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput heatingSignal_Hysteresis
    "True if heating allowed; false if heating locked out"
    annotation (Placement(transformation(extent={{100,-26},{140,14}})));
  Controls.OBC.CDL.Logical.Pre           pre1(pre_u_start=false)
                                              "Breaks Boolean loop"
    annotation (Placement(transformation(extent={{-260,-100},{-240,-80}})));
  Controls.Continuous.OffTimer offTimCol
    "Records time since cooling turned off"
    annotation (Placement(transformation(extent={{-220,-100},{-200,-80}})));
  Controls.OBC.CDL.Continuous.Greater greCol
    "Checks if cooling has been off for at least an hour"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));
  Controls.OBC.CDL.Logical.LogicalSwitch           logSwiCold
    "Once simulation has been running for one hour, enables hysteresis prevention"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1
    annotation (Placement(transformation(extent={{-262,-142},{-242,-122}})));
  Controls.OBC.CDL.Continuous.Greater           gre1
    "Check if simulation has been running for at least lockout duration: if not, no hysteresis lockouts"
    annotation (Placement(transformation(extent={{-260,-62},{-240,-42}})));
  Modelica.Blocks.Sources.Constant TiCo(k=TiCoo)
    "Time for which cooling is locked out after heating stops"
    annotation (Placement(transformation(extent={{-320,2},{-300,22}})));
  Modelica.Blocks.Sources.Constant TiH1(k=TiHea)
    "Time for which heating is locked out after cooling stops"
    annotation (Placement(transformation(extent={{-320,-80},{-300,-60}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-78,80},{-58,100}})));
  Modelica.Blocks.Logical.Not not2
    annotation (Placement(transformation(extent={{-78,-162},{-58,-142}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
equation
  connect(gre3Hot.y,logSwiHot. u1) annotation (Line(points={{-158,70},{-110,
          70},{-110,40},{-102,40}},             color={255,0,255}));
  connect(booleanConstant.y,logSwiHot. u3) annotation (Line(points={{-239,
          -12},{-239,-11},{-102,-11},{-102,24}},color={255,0,255}));
  connect(gre4.y,logSwiHot. u2) annotation (Line(points={{-238,30},{-238,32},{-102,
          32}},                                             color={255,0,255}));
  connect(modTim.y,gre4. u1) annotation (Line(points={{-299,-32},{-280,-32},{-280,
          30},{-262,30}},     color={0,0,127}));
  connect(offTimHot.y,gre3Hot. u1) annotation (Line(points={{-199,70},{-182,
          70}},         color={0,0,127}));
  connect(pre.y,offTimHot. u) annotation (Line(points={{-238,70},{-222,70}},
                                                color={255,0,255}));
  connect(heatingSignal, pre.u)
    annotation (Line(points={{-360,70},{-262,70}}, color={255,0,255}));
  connect(pre1.y, offTimCol.u)
    annotation (Line(points={{-238,-90},{-222,-90}}, color={255,0,255}));
  connect(offTimCol.y, greCol.u1)
    annotation (Line(points={{-199,-90},{-182,-90}}, color={0,0,127}));
  connect(greCol.y, logSwiCold.u1) annotation (Line(points={{-158,-90},{
          -118,-90},{-118,-102},{-102,-102}}, color={255,0,255}));
  connect(booleanConstant1.y, logSwiCold.u3) annotation (Line(points={{-241,
          -132},{-241,-131},{-102,-131},{-102,-118}}, color={255,0,255}));
  connect(coolingSignal, pre1.u)
    annotation (Line(points={{-360,-90},{-262,-90}}, color={255,0,255}));
  connect(modTim.y, gre1.u1) annotation (Line(points={{-299,-32},{-280,-32},{-280,
          -52},{-262,-52}},       color={0,0,127}));
  connect(gre1.y, logSwiCold.u2) annotation (Line(points={{-238,-52},{-118,
          -52},{-118,-110},{-102,-110}}, color={255,0,255}));
  connect(TiCo.y, gre3Hot.u2) annotation (Line(points={{-299,12},{-279.5,12},{-279.5,
          62},{-182,62}}, color={0,0,127}));
  connect(TiCo.y, gre4.u2) annotation (Line(points={{-299,12},{-280,12},{-280,22},
          {-262,22}}, color={0,0,127}));
  connect(TiH1.y, gre1.u2) annotation (Line(points={{-299,-70},{-280,-70},{-280,
          -60},{-262,-60}}, color={0,0,127}));
  connect(TiH1.y, greCol.u2) annotation (Line(points={{-299,-70},{-280,-70},{-280,
          -98},{-182,-98}}, color={0,0,127}));
  connect(logSwiHot.y, and1.u2) annotation (Line(points={{-78,32},{-62,32},{-62,
          22},{-42,22}}, color={255,0,255}));
  connect(heatingSignal, not1.u) annotation (Line(points={{-360,70},{-280,70},{-280,
          124},{-80,124},{-80,90}}, color={255,0,255}));
  connect(not1.y, and1.u1) annotation (Line(points={{-57,90},{-52,90},{-52,30},{
          -42,30}}, color={255,0,255}));
  connect(and1.y, coolingSignal_Hysteresis) annotation (Line(points={{-19,30},{22,
          30},{22,-92},{120,-92}}, color={255,0,255}));
  connect(and2.y, heatingSignal_Hysteresis) annotation (Line(points={{-19,-130},
          {22,-130},{22,-6},{120,-6}}, color={255,0,255}));
  connect(coolingSignal, not2.u) annotation (Line(points={{-360,-90},{-280,-90},
          {-280,-152},{-80,-152}}, color={255,0,255}));
  connect(logSwiCold.y, and2.u1) annotation (Line(points={{-78,-110},{-60,-110},
          {-60,-130},{-42,-130}}, color={255,0,255}));
  connect(not2.y, and2.u2) annotation (Line(points={{-57,-152},{-52,-152},{-52,-138},
          {-42,-138}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
Cooling is locked out for a specified amount of time after heating turns off (typically 1hr). Heating is locked out for a specified amount of time after cooling turns off (typically 1hr).
</p>
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
        textString="H"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-340,-180},{100,140}})));
end HysteresisLimit;
