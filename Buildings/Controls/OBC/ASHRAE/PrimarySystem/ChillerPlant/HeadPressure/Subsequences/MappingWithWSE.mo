within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences;
block MappingWithWSE
  "Equipment setpoints when chiller head pressure control is enabled, for plants with waterside economizer and headered condenser water pumps"
  parameter Real minTowSpe = 0.1
    "Minimum cooling tower fan speed";
  parameter Real minConWatPumSpe = 0.1
    "Minimum condenser water pump speed";
  parameter Real minHeaPreValPos = 0.1
    "Minimum head pressure control valve position";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaPreCon
    "Chiller head pressure control loop signal"
    annotation (Placement(transformation(extent={{-160,110},{-120,150}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput desConWatPumSpe
    "Design condenser water pump speed for current stage"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    "Status of water side economizer: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaPreEna
    "Status of head pressure control: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-160,-180},{-120,-140}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMaxTowSpeSet(
    final unit="1",
    final min=0,
    final max=1) "Maximum cooling tower speed setpoint"
    annotation (Placement(transformation(extent={{120,160},{160,200}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpeSet(
    final unit="1",
    final min=0,
    final max=1) "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{120,50},{160,90}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaPreConVal(
    final unit="1",
    final min=0,
    final max=1) "Head pressure control valve position"
    annotation (Placement(transformation(extent={{120,-180},{160,-140}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Line maxCooTowSpeSet
    "Maximum cooling tower speed setpoint"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{0,140},{20,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hal(final k=0.5)
    "Constant value"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowMaxSpe(
    final k=minTowSpe)
    "Minimum allowable tower speed"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.CDL.Reals.Line conWatPumSpe
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hal1(final k=0.5)
    "Constant value"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one2(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=minConWatPumSpe) "Minimum condenser water pump speed"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one3(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one4(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=minHeaPreValPos)
    "Minimum head pressure control valve position"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer1(final k=0)
    "Constant value"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Line heaPreConVal
    "Head pressure control valve position"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{80,170},{100,190}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer2(final k=0)
    "Constant value"
    annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));

equation
  connect(zer.y, maxCooTowSpeSet.x1)
    annotation (Line(points={{22,150},{30,150},{30,138},{38,138}},color={0,0,127}));
  connect(one.y, maxCooTowSpeSet.f1)
    annotation (Line(points={{-18,150},{-10,150},{-10,134},{38,134}},
      color={0,0,127}));
  connect(hal.y, maxCooTowSpeSet.x2)
    annotation (Line(points={{-18,110},{-10,110},{-10,126},{38,126}},
      color={0,0,127}));
  connect(hpTowMaxSpe.y, maxCooTowSpeSet.f2)
    annotation (Line(points={{22,110},{30,110},{30,122},{38,122}},color={0,0,127}));
  connect(uHeaPreCon, maxCooTowSpeSet.u)
    annotation (Line(points={{-140,130},{38,130}}, color={0,0,127}));
  connect(hal1.y,conWatPumSpe. x1)
    annotation (Line(points={{22,50},{30,50},{30,38},{38,38}},color={0,0,127}));
  connect(con.y,conWatPumSpe. f2)
    annotation (Line(points={{22,0},{30,0},{30,22},{38,22}},color={0,0,127}));
  connect(one2.y,conWatPumSpe. x2)
    annotation (Line(points={{-18,0},{-10,0},{-10,26},{38,26}}, color={0,0,127}));
  connect(uHeaPreCon,conWatPumSpe. u)
    annotation (Line(points={{-140,130},{-80,130},{-80,30},{38,30}},
      color={0,0,127}));
  connect(zer1.y, heaPreConVal.x1)
    annotation (Line(points={{22,-40},{30,-40},{30,-52},{38,-52}},color={0,0,127}));
  connect(one3.y, heaPreConVal.f1)
    annotation (Line(points={{-18,-40},{-10,-40},{-10,-56},{38,-56}},
      color={0,0,127}));
  connect(one4.y, heaPreConVal.x2)
    annotation (Line(points={{-18,-80},{-10,-80},{-10,-64},{38,-64}},
      color={0,0,127}));
  connect(con1.y, heaPreConVal.f2)
    annotation (Line(points={{22,-80},{30,-80},{30,-68},{38,-68}},color={0,0,127}));
  connect(uHeaPreCon, heaPreConVal.u)
    annotation (Line(points={{-140,130},{-80,130},{-80,-60},{38,-60}},
      color={0,0,127}));
  connect(maxCooTowSpeSet.y, swi.u3)
    annotation (Line(points={{62,130},{70,130},{70,172},{78,172}},
      color={0,0,127}));
  connect(swi.y, yMaxTowSpeSet)
    annotation (Line(points={{102,180},{140,180}}, color={0,0,127}));
  connect(desConWatPumSpe, swi1.u1)
    annotation (Line(points={{-140,60},{-60,60},{-60,78},{78,78}}, color={0,0,127}));
  connect(conWatPumSpe.y, swi1.u3)
    annotation (Line(points={{62,30},{70,30},{70,62},{78,62}},
      color={0,0,127}));
  connect(swi1.y, yConWatPumSpeSet)
    annotation (Line(points={{102,70},{140,70}}, color={0,0,127}));
  connect(uWSE, swi2.u2)
    annotation (Line(points={{-140,0},{-100,0},{-100,-110},{78,-110}},
      color={255,0,255}));
  connect(zer2.y, swi3.u3)
    annotation (Line(points={{-18,-180},{60,-180},{60,-168},{78,-168}},
      color={0,0,127}));
  connect(uHeaPreEna, swi3.u2)
    annotation (Line(points={{-140,-160},{78,-160}}, color={255,0,255}));
  connect(swi2.y, swi3.u1)
    annotation (Line(points={{102,-110},{110,-110},{110,-140},{60,-140},
      {60,-152},{78,-152}}, color={0,0,127}));
  connect(swi3.y, yHeaPreConVal)
    annotation (Line(points={{102,-160},{140,-160}}, color={0,0,127}));
  connect(one.y, swi.u1)
    annotation (Line(points={{-18,150},{-10,150},{-10,188},{78,188}},
      color={0,0,127}));
  connect(desConWatPumSpe, conWatPumSpe.f1)
    annotation (Line(points={{-140,60},{-60,60},{-60,34},{38,34}},
      color={0,0,127}));
  connect(one4.y, swi2.u3)
    annotation (Line(points={{-18,-80},{-10,-80},{-10,-118},{78,-118}},
      color={0,0,127}));
  connect(uHeaPreEna, not1.u)
    annotation (Line(points={{-140,-160},{-110,-160},{-110,-140},{-102,-140}},
      color={255,0,255}));
  connect(uWSE, or2.u1)
    annotation (Line(points={{-140,0},{-100,0},{-100,180},{-82,180}},
      color={255,0,255}));
  connect(not1.y, or2.u2)
    annotation (Line(points={{-78,-140},{-60,-140},{-60,-120},{-90,-120},{-90,
          172},{-82,172}},  color={255,0,255}));
  connect(or2.y, swi.u2)
    annotation (Line(points={{-58,180},{78,180}}, color={255,0,255}));
  connect(or2.y, swi1.u2)
    annotation (Line(points={{-58,180},{-50,180},{-50,70},{78,70}},
      color={255,0,255}));
  connect(heaPreConVal.y, swi2.u1)
    annotation (Line(points={{62,-60},{70,-60},{70,-102},{78,-102}},
      color={0,0,127}));

annotation (
  defaultComponentName= "heaPreConEqu",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        borderPattern=BorderPattern.Raised),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
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
  Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-120,-200},{120,200}})),
  Documentation(info="<html>
<p>
Block that resets maximum cooling tower speed setpoint <code>yMaxTowSpeSet</code>, 
controls condenser water pump speed <code>yConWatPumSpeSet</code> and 
head pressure control valve position <code>yHeaPreConVal</code>
for plants with water side economizers and headered condenser water pumps. 
The development follows ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems 
Phase II – Central Plants and Hydronic Systems (Draft on March 23, 2020), 
section 5.2.10 Head pressure control, part 5.2.10.5, 5.2.10.6 and 5.2.10.7.
</p>
<p>
1. For each chiller, when the waterside economizer is disabled (<code>uWSE</code> = false), 
map chiller head pressure control loop signal <code>uHeaPreCon</code> as follows:
</p>
<ul>
<li>
When <code>uHeaPreCon</code> changes from 0 to 50%, reset maximum cooling tower
speed setpoint <code>yMaxTowSpeSet</code> from 100% to minimum speed 
<code>minTowSpe</code>.
</li>
<li>
When <code>uHeaPreCon</code> changes from 50% to 100%, reset condenser water 
pump speed <code>yConWatPumSpeSet</code> from design speed for the stage 
<code>desConWatPumSpe</code> to minimum speed <code>minConWatPumSpe</code>.
</li>
<li>
Each head pressure control valve <code>yHeaPreConVal</code> of enabled chiller shall 
be 100% open, irrespective of loop output.
</li>
</ul>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/HeadPressure/Subsequences/HeadControlCWP_WSE.png\"
     alt=\"HeadControlCWP_WSE.png\" />
</p>

<p>
2. When the waterside economizer is enabled (<code>uWSE</code> = true), 
</p>
<ul>
<li>
Maximum cooling tower speed setpoint <code>yMaxTowSpeSet</code> shall be 100% 
irrespective of loop output.
</li>
<li>
Condenser water pump speed <code>yConWatPumSpeSet</code> shall be equal to the design
speed for the stage <code>desConWatPumSpe</code>, irrespective of loop output.
</li>
<li>
Each enabled chiller head pressure control loop output <code>uHeaPreCon</code> 
shall reset head pressure control valve position <code>yHeaPreConVal</code> 
from 100% open at 0% loop output to minimum position <code>minHeaPreValPos</code>
at 100% loop output.
</li>
</ul>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/HeadPressure/Subsequences/HeadControlValve_WSE.png\"
     alt=\"HeadControlValve_WSE.png\" />
</p>

<p>
3. When the head pressure control loop is disabled (<code>uHeaPreEna</code> = false), 
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
end MappingWithWSE;
