within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints;
block SupplyTemperature
  "Supply air temperature set point for single zone VAV system"

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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-220,-130},{-180,-90}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling setpoints for zone temperature"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Heating setpoints for zone temperature"
    annotation (Placement(transformation(extent={{-220,60},{-180,100}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupHeaEcoSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature setpoint for heating coil and for economizer"
    annotation (Placement(transformation(extent={{180,10},{220,50}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{180,-110},{220,-70}}),
        iconTransformation(extent={{100,-90},{140,-50}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Average aveZonSet
    "Average of the zone heating and cooling setpoint"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Reals.Limiter lim(
    final uMax=TSupDea_max,
    final uMin=TSupDea_min)
    "Limiter that outputs the dead band value for the supply air temperature"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Reals.Line heaSupTemDif
    "Supply air temperature difference when it is in heating state"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant temOnePoi(
    final k=temPoiOne)
    "Temperature control point one in x-axis of control map"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxSupTem(
    final k=TSup_max)
    "Highest heating supply air temperature"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant temTwoPoi(
    final k=temPoiTwo)
    "Temperature control point two in x-axis of control map"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Line cooSupTem
    "Supply air temperature when it is in cooling state"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant supCooTem(
    final k=TSup_min)
    "Cooling supply air temperature"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar3(
    final p=-1)
    "Minimum cooling supply temperature minus threshold"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Line cooSupTem1
    "Supply air temperature when it is in cooling state"
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant temThrPoi(
    final k=temPoiThr)
    "Temperature control point three in x-axis of control map"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant temFouPoi(
    final k=temPoiFou)
    "Temperature control point four in x-axis of control map"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Max cooSet
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));

public
  CDL.Reals.Add heaEcoSet "Heating coil and economizer setpoint temperature"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  CDL.Reals.Subtract sub "Temperature difference"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
equation
  connect(TCooSet, aveZonSet.u1) annotation (Line(points={{-200,120},{-160,120},
          {-160,106},{-122,106}},   color={0,0,127}));
  connect(THeaSet, aveZonSet.u2) annotation (Line(points={{-200,80},{-160,80},{
          -160,94},{-122,94}},      color={0,0,127}));
  connect(aveZonSet.y, lim.u)
    annotation (Line(points={{-98,100},{-82,100}},    color={0,0,127}));
  connect(uHea, heaSupTemDif.u) annotation (Line(points={{-200,0},{20,0},{20,80},
          {58,80}}, color={0,0,127}));
  connect(zer.y, heaSupTemDif.x1) annotation (Line(points={{-18,140},{40,140},{
          40,88},{58,88}}, color={0,0,127}));
  connect(temOnePoi.y, heaSupTemDif.x2) annotation (Line(points={{-118,40},{
          -110,40},{-110,76},{58,76}}, color={0,0,127}));
  connect(zer.y, cooSupTem.x1) annotation (Line(points={{-18,140},{40,140},{40,
          -12},{58,-12}},   color={0,0,127}));
  connect(lim.y, cooSupTem.f1) annotation (Line(points={{-58,100},{30,100},{30,
          -16},{58,-16}},                       color={0,0,127}));
  connect(temTwoPoi.y, cooSupTem.x2) annotation (Line(points={{-38,-20},{20,-20},
          {20,-24},{58,-24}},          color={0,0,127}));
  connect(supCooTem.y, addPar3.u) annotation (Line(points={{-118,-60},{-22,-60}},
                                  color={0,0,127}));
  connect(addPar3.y, cooSupTem.f2) annotation (Line(points={{2,-60},{50,-60},{
          50,-28},{58,-28}},           color={0,0,127}));
  connect(temThrPoi.y, cooSupTem1.x1) annotation (Line(points={{-38,-90},{20,
          -90},{20,-102},{58,-102}}, color={0,0,127}));
  connect(lim.y, cooSupTem1.f1) annotation (Line(points={{-58,100},{30,100},{30,
          -106},{58,-106}},                     color={0,0,127}));
  connect(temFouPoi.y, cooSupTem1.x2) annotation (Line(points={{-38,-140},{40,
          -140},{40,-114},{58,-114}},  color={0,0,127}));
  connect(supCooTem.y, cooSupTem1.f2) annotation (Line(points={{-118,-60},{-80,
          -60},{-80,-118},{58,-118}},  color={0,0,127}));
  connect(uCoo, cooSupTem.u) annotation (Line(points={{-200,-110},{40,-110},{40,
          -20},{58,-20}},   color={0,0,127}));
  connect(uCoo, cooSupTem1.u) annotation (Line(points={{-200,-110},{58,-110}},
                            color={0,0,127}));
  connect(cooSupTem.y, cooSet.u1) annotation (Line(points={{82,-20},{100,-20},{
          100,-84},{118,-84}},
                           color={0,0,127}));
  connect(cooSupTem1.y, cooSet.u2) annotation (Line(points={{82,-110},{100,-110},
          {100,-96},{118,-96}}, color={0,0,127}));
  connect(cooSet.y, TSupCooSet)
    annotation (Line(points={{142,-90},{200,-90}}, color={0,0,127}));
  connect(zer.y, heaSupTemDif.f1) annotation (Line(points={{-18,140},{40,140},{
          40,84},{58,84}}, color={0,0,127}));
  connect(maxSupTem.y, sub.u1) annotation (Line(points={{-78,40},{-60,40},{-60,
          46},{-42,46}}, color={0,0,127}));
  connect(sub.y, heaSupTemDif.f2) annotation (Line(points={{-18,40},{10,40},{10,
          72},{58,72}}, color={0,0,127}));
  connect(cooSupTem.y, heaEcoSet.u2) annotation (Line(points={{82,-20},{100,-20},
          {100,24},{118,24}}, color={0,0,127}));
  connect(heaSupTemDif.y, heaEcoSet.u1) annotation (Line(points={{82,80},{100,
          80},{100,36},{118,36}}, color={0,0,127}));
  connect(heaEcoSet.y, TSupHeaEcoSet)
    annotation (Line(points={{142,30},{200,30}}, color={0,0,127}));
  connect(lim.y, sub.u2) annotation (Line(points={{-58,100},{-50,100},{-50,34},
          {-42,34}}, color={0,0,127}));
annotation (defaultComponentName = "supTemSet",
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
      points={{80,-40},{58,-34},{58,-46},{80,-40}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Line(points={{8,-40},{78,-40}},   color={95,95,95}),
    Line(points={{-54,48},{-54,-30}}, color={95,95,95}),
    Polygon(
      points={{-54,70},{-60,48},{-48,48},{-54,70}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-88,64},{-47,44}},
      textColor={0,0,0},
          textString="T"),
    Text(
      extent={{64,-44},{88,-55}},
      textColor={0,0,0},
          textString="u"),
        Line(
          points={{-44,42},{-30,42},{-14,6},{26,6},{38,-14},{60,-14}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-44,42},{-30,42},{-14,6},{2,6},{18,-18},{60,-18}},
          color={255,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5),
    Line(points={{-4,-40},{-60,-40}}, color={95,95,95}),
    Polygon(
      points={{-64,-40},{-42,-34},{-42,-46},{-64,-40}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-24},{-76,-34}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHea"),
        Text(
          extent={{-100,-74},{-80,-84}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCoo"),
        Text(
          extent={{52,8},{98,-6}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupHeaEcoSet"),
        Text(
          extent={{62,-64},{98,-76}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupCooSet"),
        Text(
          extent={{-98,86},{-72,76}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TCooSet"),
        Text(
          extent={{-98,36},{-72,24}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="THeaSet")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-160},{180,160}})),
  Documentation(info="<html>
<p>
Block that outputs the set points for the supply air temperature for
cooling, heating and economizer control for a single zone VAV system.
The implementation is according to the Section 5.18.4 of ASHRAE Guideline 36, May 2020.
</p> 

<h4>Supply temperature setpoints</h4>
<p>
The output <code>TSupCooSet</code> is to be used to control the cooling coil,
and the output
<code>TSupHeaEcoSet</code> is to be used to control the heating coil and the
economizer dampers.
</p>
<p>
When it is in deadband state, the output <code>TSupCooSet</code> and <code>TSupHeaEcoSet</code>
shall be average of the zone heating setpoint <code>THeaSet</code> and the zone
cooling setpoint <code>TCooSet</code> but shall be no lower than <code>TSupDea_min</code>,
21 &deg;C (70 &deg;F),
and no higher than <code>TSupDea_max</code>, 24 &deg;C (75 &deg;F),
</p>
<h5>Control mapping</h5>
<ol>
<li>
For a heating-loop signal <code>uHea</code> of 100% to <code>temPoiOne</code> (default 50%), 
<code>TSupHeaEcoSet</code> should be <code>TSup_max</code>.
</li>
<li>
For a heating-loop signal <code>uHea</code> of <code>temPoiOne</code> to 0%, 
<code>TSupHeaEcoSet</code> is reset from <code>TSup_max</code> to the deadband value.
</li>
<li>
In deadband (<code>uHea=0</code>, <code>uCoo=0</code>), <code>TSupHeaEcoSet</code> is
the deadband value.
</li>
<li>
For a cooling-loop signal <code>uCoo</code> of 0% to <code>temPoiTwo</code> (default 25%),
<code>TSupHeaEcoSet</code> is reset from deadband value to <code>TSup_min</code> minus
1 &deg;C (2 &deg;F), while <code>TSupCooSet</code> is the deadband value.
</li>
<li>
For a cooling-loop signal <code>uCoo</code> of <code>temPoiTwo</code> to <code>temPoiThr</code> (default 50%),
<code>TSupHeaEcoSet</code> and <code>TSupCooSet</code> are unchanged.
</li>
<li>
For a cooling-loop signal <code>uCoo</code> of <code>temPoiThr</code> to <code>temPoiFou</code> (default 75%),
<code>TSupHeaEcoSet</code> remains at <code>TSup_min</code> minus
1 &deg;C (2 &deg;F), while <code>TSupCooSet</code> is reset from the deadband value
to <code>TSup_min</code>.
</li>
<li>
For a cooling-loop signal <code>uCoo</code> of <code>temPoiFou</code> to 100%,
<code>TSupHeaEcoSet</code> and <code>TSupCooSet</code> are unchanged.
</li>
</ol>

<p>
The figure below shows the sequence.
</p>
<p align=\"center\">
<img alt=\"Image of temperature reset\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/SetPoints/Supply_Temperature.png\"/>
</p>



<p>
Note that the inputs <code>uHea</code> and <code>uCoo</code> must be computed
based on the same temperature sensors and control loops.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2025, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SupplyTemperature;
