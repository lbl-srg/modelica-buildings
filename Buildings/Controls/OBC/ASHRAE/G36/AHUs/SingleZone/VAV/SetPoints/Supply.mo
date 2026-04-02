within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints;
block Supply "Supply air set point for single zone VAV system"

  parameter Real TSup_max(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum supply air temperature for heating"
    annotation (Dialog(group="Temperatures"));
  parameter Real TSup_min(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Minimum supply air temperature for cooling"
    annotation (Dialog(group="Temperatures"));
  parameter Real TSupDew_max(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum supply air dew-point temperature. It's typically only needed in humid type “A” climates. A typical value is 17°C. 
    For mild and dry climates, a high set point (e.g. 24°C) should be entered for maximum efficiency"
    annotation (Dialog(group="Temperatures"));
  parameter Real TSupDea_min(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=294.15
    "Minimum supply temperature when it is in deadband state"
    annotation (__cdl(ValueInReference=true), Dialog(group="Temperatures"));
  parameter Real TSupDea_max(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=297.15
    "Maximum supply temperature when it is in deadband state"
    annotation (__cdl(ValueInReference=true), Dialog(group="Temperatures"));
  parameter Real maxHeaSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum fan speed for heating"
    annotation (Dialog(group="Speed"));
  parameter Real maxCooSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum fan speed for cooling"
    annotation (Dialog(group="Speed"));
  parameter Real minSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum fan speed"
    annotation (Dialog(group="Speed"));
  parameter Real temPoiOne(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Point 1 on x-axis of control map for temperature control, when it is in heating state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Temperatures"));
  parameter Real temPoiTwo(
    final unit="1",
    final min=0,
    final max=1)=0.25
    "Point 2 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Temperatures"));
  parameter Real temPoiThr(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Point 3 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Temperatures"));
  parameter Real temPoiFou(
    final unit="1",
    final min=0,
    final max=1)=0.75
    "Point 4 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Temperatures"));
  parameter Real spePoiOne(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Point 1 on x-axis of control map for speed control, when it is in heating state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Speed"));
  parameter Real spePoiTwo(
    final unit="1",
    final min=0,
    final max=1)=0.25
    "Point 2 on x-axis of control map for speed control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Speed"));
  parameter Real spePoiThr(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Point 3 on x-axis of control map for speed control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Speed"));
  parameter Real spePoiFou(
    final unit="1",
    final min=0,
    final max=1)=0.75
    "Point 4 on x-axis of control map for speed control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Speed"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-160,110},{-120,150}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-160,50},{-120,90}}),
        iconTransformation(extent={{-140,44},{-100,84}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-160,10},{-120,50}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-160,-30},{-120,10}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling setpoints for zone temperature"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Heating setpoints for zone temperature"
    annotation (Placement(transformation(extent={{-160,-130},{-120,-90}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final min=0,
    final max=1,
    final unit="1") "Fan speed"
    annotation (Placement(transformation(extent={{120,110},{160,150}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1SupFan
    "Supply fan commanded status"
    annotation (Placement(transformation(extent={{120,70},{160,110}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupHeaEcoSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature setpoint for heating coil and for economizer"
    annotation (Placement(transformation(extent={{120,-60},{160,-20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{120,-130},{160,-90}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fanOff(
    final k=0)
    "Fan off status"
    annotation (Placement(transformation(extent={{-20,150},{0,170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch fanSpe "Supply fan speed"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Reals.LimitSlewRate ramLim(
    final raisingSlewRate=1/600,
    final Td=60)
    "Prevent changes in fan speed of more than 10% per minute"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant unoMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Unoccupied mode index"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isUnoMod
    "Check if it is in unoccupied mode"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Supply fan status"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.SupplyFan supFanSpe(
    final TSupDew_max=TSupDew_max,
    final maxHeaSpe=maxHeaSpe,
    final maxCooSpe=maxCooSpe,
    final minSpe=minSpe,
    final spePoiOne=spePoiOne,
    final spePoiTwo=spePoiTwo,
    final spePoiThr=spePoiThr,
    final spePoiFou=spePoiFou)
    "Supply fan speed setpoint"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.SupplyTemperature supTemSet(
    final TSup_max=TSup_max,
    final TSup_min=TSup_min,
    final TSupDea_min=TSupDea_min,
    final TSupDea_max=TSupDea_max,
    final temPoiOne=temPoiOne,
    final temPoiTwo=temPoiTwo,
    final temPoiThr=temPoiThr,
    final temPoiFou=temPoiFou)
    "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

equation
  connect(isUnoMod.y, fanSpe.u2)
    annotation (Line(points={{-18,130},{38,130}}, color={255,0,255}));
  connect(fanOff.y, fanSpe.u1) annotation (Line(points={{2,160},{20,160},{20,138},
          {38,138}}, color={0,0,127}));
  connect(fanSpe.y, ramLim.u)
    annotation (Line(points={{62,130},{78,130}}, color={0,0,127}));
  connect(ramLim.y, y)
    annotation (Line(points={{102,130},{140,130}}, color={0,0,127}));
  connect(isUnoMod.y, not1.u) annotation (Line(points={{-18,130},{0,130},{0,90},
          {38,90}}, color={255,0,255}));
  connect(not1.y, y1SupFan)
    annotation (Line(points={{62,90},{140,90}}, color={255,0,255}));
  connect(TZon, supFanSpe.TZon) annotation (Line(points={{-140,70},{-70,70},{-70,
          8},{-42,8}}, color={0,0,127}));
  connect(TOut, supFanSpe.TOut) annotation (Line(points={{-140,30},{-80,30},{-80,
          3},{-42,3}}, color={0,0,127}));
  connect(uHea, supFanSpe.uHea) annotation (Line(points={{-140,-10},{-80,-10},{-80,
          -4},{-42,-4},{-42,-3}}, color={0,0,127}));
  connect(uCoo, supFanSpe.uCoo) annotation (Line(points={{-140,-40},{-70,-40},{-70,
          -8},{-42,-8}}, color={0,0,127}));
  connect(supFanSpe.y, fanSpe.u3) annotation (Line(points={{-18,0},{20,0},{20,122},
          {38,122}}, color={0,0,127}));
  connect(TCooSet, supTemSet.TCooSet) annotation (Line(points={{-140,-80},{-100,
          -80},{-100,-72},{-2,-72}}, color={0,0,127}));
  connect(THeaSet, supTemSet.THeaSet) annotation (Line(points={{-140,-110},{-50,
          -110},{-50,-77},{-2,-77}}, color={0,0,127}));
  connect(uHea, supTemSet.uHea) annotation (Line(points={{-140,-10},{-80,-10},{-80,
          -83},{-2,-83}}, color={0,0,127}));
  connect(uCoo, supTemSet.uCoo) annotation (Line(points={{-140,-40},{-70,-40},{-70,
          -88},{-2,-88}}, color={0,0,127}));
  connect(supTemSet.TSupHeaEcoSet, TSupHeaEcoSet) annotation (Line(points={{22,-80},
          {60,-80},{60,-40},{140,-40}}, color={0,0,127}));
  connect(supTemSet.TSupCooSet, TSupCooSet) annotation (Line(points={{22,-87},{60,
          -87},{60,-110},{140,-110}}, color={0,0,127}));
  connect(uOpeMod, isUnoMod.u1)
    annotation (Line(points={{-140,130},{-42,130}}, color={255,127,0}));
  connect(unoMod.y, isUnoMod.u2) annotation (Line(points={{-78,100},{-60,100},{-60,
          122},{-42,122}}, color={255,127,0}));
annotation (defaultComponentName = "setPoiVAV",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={
      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-100,140},{100,100}},
        textString="%name",
        textColor={0,0,255}),
    Polygon(
      points={{80,-76},{58,-70},{58,-82},{80,-76}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Line(points={{8,-76},{78,-76}},   color={95,95,95}),
    Line(points={{-54,-22},{-54,-62}},color={95,95,95}),
    Polygon(
      points={{-54,0},{-60,-22},{-48,-22},{-54,0}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-88,-6},{-47,-26}},
      textColor={0,0,0},
          textString="T"),
    Text(
      extent={{64,-82},{88,-93}},
      textColor={0,0,0},
          textString="u"),
        Line(
          points={{-44,-6},{-30,-6},{-14,-42},{26,-42},{38,-62},{60,-62}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-44,-6},{-30,-6},{-14,-42},{2,-42},{18,-66},{60,-66}},
          color={255,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5),
    Line(points={{-4,-76},{-60,-76}}, color={95,95,95}),
    Polygon(
      points={{-64,-76},{-42,-70},{-42,-82},{-64,-76}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,16},{-76,6}},
          textColor={0,0,127},
          textString="uHea"),
        Text(
          extent={{-100,-14},{-80,-24}},
          textColor={0,0,127},
          textString="uCoo"),
        Text(
          extent={{52,8},{98,-6}},
          textColor={0,0,127},
          textString="TSupHeaEcoSet"),
        Text(
          extent={{62,-54},{98,-66}},
          textColor={0,0,127},
          textString="TSupCooSet"),
        Text(
          extent={{86,86},{100,76}},
          textColor={0,0,127},
          textString="y"),
        Text(
          extent={{-98,-54},{-72,-64}},
          textColor={0,0,127},
          textString="TCooSet"),
        Text(
          extent={{-100,46},{-80,36}},
          textColor={0,0,127},
          textString="TOut"),
    Line(points={{-54,50},{-54,10}},  color={95,95,95}),
    Polygon(
      points={{-54,72},{-60,50},{-48,50},{-54,72}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-88,68},{-47,48}},
      textColor={0,0,0},
          textString="y"),
        Line(points={{-46,44},{-28,20},{18,20},{28,36},{38,36},{50,54}}, color={
              0,0,0}),
        Line(points={{18,20},{38,20},{50,54},{28,54},{18,20}}, color={0,0,0}),
        Text(
          extent={{-96,96},{-66,86}},
          textColor={0,0,127},
          textString="uOpeMod"),
        Text(
          extent={{-98,-84},{-72,-96}},
          textColor={0,0,127},
          textString="THeaSet"),
        Text(
          extent={{-100,68},{-80,58}},
          textColor={0,0,127},
          textString="TZon"),
        Text(
          extent={{70,46},{98,36}},
          textColor={255,0,255},
          textString="y1SupFan")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-140},{120,180}})),
  Documentation(info="<html>
<p>
Block that outputs the set points for the supply air temperature for
cooling, heating and economizer control, and the fan speed for a single zone VAV system.
The implementation is according to the Section 5.18.4 of ASHRAE Guideline 36, May 2020.
</p> 
<h4>Fan speed setpoint</h4>
<p>
The speed setpoint is calculated in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.SupplyFan\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.SupplyFan</a>.
The supply fan shall run whenever the unit is in any mode other than unoccupied mode.
Also, a ramp function should be applied to prevent changes in fan speed of more
than 10% per minute.
</p>
<h4>Supply temperature setpoints</h4>
<p>
The output <code>TSupCooSet</code> is to be used to control the cooling coil,
and the output
<code>TSupHeaEcoSet</code> is to be used to control the heating coil and the
economizer dampers.
When it is in deadband state, the output <code>TSupCooSet</code> and <code>TSupHeaEcoSet</code>
shall be average of the zone heating setpoint <code>THeaSet</code> and the zone
cooling setpoint <code>TCooSet</code> but shall be no lower than <code>TSupDea_min</code>,
21 &deg;C (70 &deg;F),
and no higher than <code>TSupDea_max</code>, 24 &deg;C (75 &deg;F).
The temperature setpoints are calculated in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.SupplyTemperature\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.SupplyTemperature</a>.
</p>
<p>
Note that the inputs <code>uHea</code> and <code>uCoo</code> must be computed
based on the same temperature sensors and control loops.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2025, by Jianjun Hu:<br/>
Improved setpoints calculation to avoid discontinuity.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4282\">issue 4282</a>.
</li>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Supply;
