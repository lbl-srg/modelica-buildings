within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences;
block Setpoints_noWSE
  "Equipment setpoints when chiller head pressure control is enabled, for plants without waterside economizer"
  parameter Real minTowSpe
    "Minimum cooling tower fan speed";
  parameter Real minHeaPreValPos
    "Minimum head pressure control valve position";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaPreCon
    "Chiller head pressure control loop signal"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaPreEna
    "Status of head pressure control: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMaxTowSpeSet(
    final unit="1",
    final min=0,
    final max=1) "Maximum cooling tower speed setpoint"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaPreConVal(
    final unit="1",
    final min=0,
    final max=1) "Head pressure control valve position"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
      iconTransformation(extent={{100,-70},{120,-50}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Line maxCooTowSpeSet
    "Maximum cooling tower speed setpoint"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hal(final k=0.5)
    "Constant value"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hpTowMaxSpe(
    final k=minTowSpe)
    "Minimum allowable tower speed"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Line heaPreConVal
    "Head pressure control valve position"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hal1(final k=0.5)
    "Constant value"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one1(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one2(k=1) "Constant one"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=minHeaPreValPos)
    "Minimum head pressure control valve position"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer2(final k=0)
    "Constant value"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));

equation
  connect(zer.y, maxCooTowSpeSet.x1)
    annotation (Line(points={{1,90},{20,90},{20,68},{38,68}}, color={0,0,127}));
  connect(one.y, maxCooTowSpeSet.f1)
    annotation (Line(points={{-39,90},{-30,90},{-30,64},{38,64}}, color={0,0,127}));
  connect(hal.y, maxCooTowSpeSet.x2)
    annotation (Line(points={{-39,40},{-30,40},{-30,56},{38,56}}, color={0,0,127}));
  connect(hpTowMaxSpe.y, maxCooTowSpeSet.f2)
    annotation (Line(points={{1,40},{20,40},{20,52},{38,52}}, color={0,0,127}));
  connect(uHeaPreCon, maxCooTowSpeSet.u)
    annotation (Line(points={{-120,10},{-80,10},{-80,60},{38,60}}, color={0,0,127}));
  connect(maxCooTowSpeSet.y, yMaxTowSpeSet)
    annotation (Line(points={{61,60},{110,60}}, color={0,0,127}));
  connect(hal1.y, heaPreConVal.x1)
    annotation (Line(points={{1,0},{20,0},{20,-12},{38,-12}}, color={0,0,127}));
  connect(one1.y, heaPreConVal.f1)
    annotation (Line(points={{-39,0},{-30,0},{-30,-16},{38,-16}},
      color={0,0,127}));
  connect(con.y, heaPreConVal.f2)
    annotation (Line(points={{1,-50},{20,-50},{20,-28},{38,-28}}, color={0,0,127}));
  connect(one2.y, heaPreConVal.x2)
    annotation (Line(points={{-39,-50},{-30,-50},{-30,-24},{38,-24}},
      color={0,0,127}));
  connect(uHeaPreCon, heaPreConVal.u)
    annotation (Line(points={{-120,10},{-80,10},{-80,-20},{38,-20}},
      color={0,0,127}));
  connect(uHeaPreEna, swi.u2)
    annotation (Line(points={{-120,-80},{58,-80}}, color={255,0,255}));
  connect(heaPreConVal.y, swi.u1)
    annotation (Line(points={{61,-20},{80,-20},{80,-40},{40,-40},{40,-72},
      {58,-72}}, color={0,0,127}));
  connect(zer2.y, swi.u3)
    annotation (Line(points={{-19,-100},{40,-100},{40,-88},{58,-88}},
      color={0,0,127}));
  connect(swi.y, yHeaPreConVal)
    annotation (Line(points={{81,-80},{110,-80}}, color={0,0,127}));

annotation (
  defaultComponentName= "heaPreConEqu",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Line(points={{-70,60},{-70,-54},{70,-54},{70,58}}, color={28,108,200}),
        Line(
          points={{-70,36},{-2,36},{70,-34}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-70,36},{-2,-30}},
          color={28,108,200},
          thickness=0.5),
        Polygon(
          points={{-70,60},{-72,56},{-68,56},{-70,60}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{70,60},{68,56},{72,56},{70,60}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-2,-54},{-2,52}},
          color={28,108,200},
          pattern=LinePattern.Dash)}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-120},{100,120}})),
  Documentation(info="<html>
<p>
Block that resets maximum cooling tower speed setpoint <code>yMaxTowSpeSet</code>
and controls head pressure control valve position <code>yHeaPreConVal</code>,
for plants without water side economizers. The development follows
ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.10 Head pressure control, part 5.2.10.3 and 5.2.10.6.
</p>
<p>
1. For each chiller, map chiller head pressure control loop signal 
<code>uHeaPreCon</code> as follows:
</p>
<ul>
<li>
When <code>uHeaPreCon</code> changes from 0 to 50%, reset maximum cooling tower
speed point <code>yMaxTowSpeSet</code> from 100% to minimum speed 
<code>minTowSpe</code>.
</li>
<li>
When <code>uHeaPreCon</code> changes from 50% to 100%, reset head pressure control
valve position <code>yHeaPreConVal</code> from 100% open to 
<code>minHeaPreValPos</code>.
</li>
</ul>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/HeadPressure/Subsequences/HeadControlValve_noWSE.png\"
     alt=\"HeadControlValve_noWSE.png\" />
</p>

<p>
2. When the head pressure control loop is disabled (<code>uHeaPreEna</code> = false), 
the head pressure control valve shall be closed. 
</p>
</html>",
revisions="<html>
<ul>
<li>
January 30, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Setpoints_noWSE;
