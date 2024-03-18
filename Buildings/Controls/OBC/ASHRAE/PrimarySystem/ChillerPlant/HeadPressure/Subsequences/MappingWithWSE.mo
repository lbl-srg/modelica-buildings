within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences;
block MappingWithWSE
  "Equipment setpoints when chiller head pressure control is enabled, for plants with waterside economizer and headered condenser water pumps"
  parameter Real minTowSpe = 0.1
    "Minimum cooling tower fan speed";
  parameter Real minConWatPumSpe = 0.1
    "Minimum condenser water pump speed";
  parameter Real minHeaPreValPos = 0.1
    "Minimum head pressure control valve position";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaPreCon(
    final unit="1",
    final min=0,
    final max=1)
    "Chiller head pressure control loop signal"
    annotation (Placement(transformation(extent={{-220,110},{-180,150}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput desConWatPumSpe(
    final unit="1",
    final min=0,
    final max=1)
    "Design condenser water pump speed for current stage"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    "Status of water side economizer: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-220,-40},{-180,0}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaPreEna
    "Status of head pressure control: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMaxTowSpeSet(
    final unit="1",
    final min=0,
    final max=1) "Maximum cooling tower speed setpoint"
    annotation (Placement(transformation(extent={{180,120},{220,160}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpeSet(
    final unit="1",
    final min=0,
    final max=1) "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{180,20},{220,60}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaPreConVal(
    final unit="1",
    final min=0,
    final max=1) "Head pressure control valve position"
    annotation (Placement(transformation(extent={{180,-180},{220,-140}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Line maxCooTowSpeSet
    "Maximum cooling tower speed setpoint"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hal(final k=0.5)
    "Constant value"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowMaxSpe(
    final k=minTowSpe)
    "Minimum allowable tower speed"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Reals.Line conWatPumSpe
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hal1(final k=0.5)
    "Constant value"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one2(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=minConWatPumSpe) "Minimum condenser water pump speed"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one3(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one4(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=minHeaPreValPos)
    "Minimum head pressure control valve position"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer1(final k=0)
    "Constant value"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Line heaPreConVal
    "Head pressure control valve position"
    annotation (Placement(transformation(extent={{0,-78},{20,-58}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch the maximum tower speed setpoint based on the economizer status"
    annotation (Placement(transformation(extent={{60,170},{80,190}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Switch the condenser water pump speed setpoint based on the economizer status"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "Switch the head pressure control valve setpoint based on the economizer status"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3
    "Switch the valve setpoint to 0 when the head pressure control  is disabled"
    annotation (Placement(transformation(extent={{140,-170},{160,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer2(final k=0)
    "Constant value"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi4
    "Switch the pump speed setpoint to 0 when the head pressure control  is disabled"
    annotation (Placement(transformation(extent={{140,30},{160,50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi5
    "Switch the maximum tower speed setpoint to 0 when the head pressure control  is disabled"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));

equation
  connect(zer.y, maxCooTowSpeSet.x1)
    annotation (Line(points={{-38,160},{-20,160},{-20,138},{-2,138}}, color={0,0,127}));
  connect(one.y, maxCooTowSpeSet.f1)
    annotation (Line(points={{-98,160},{-80,160},{-80,134},{-2,134}},
      color={0,0,127}));
  connect(hal.y, maxCooTowSpeSet.x2)
    annotation (Line(points={{-98,100},{-80,100},{-80,126},{-2,126}},
      color={0,0,127}));
  connect(hpTowMaxSpe.y, maxCooTowSpeSet.f2)
    annotation (Line(points={{-38,100},{-20,100},{-20,122},{-2,122}}, color={0,0,127}));
  connect(uHeaPreCon, maxCooTowSpeSet.u)
    annotation (Line(points={{-200,130},{-2,130}}, color={0,0,127}));
  connect(hal1.y,conWatPumSpe. x1)
    annotation (Line(points={{-38,50},{-20,50},{-20,38},{-2,38}}, color={0,0,127}));
  connect(con.y,conWatPumSpe. f2)
    annotation (Line(points={{-38,0},{-20,0},{-20,22},{-2,22}}, color={0,0,127}));
  connect(one2.y,conWatPumSpe. x2)
    annotation (Line(points={{-98,0},{-80,0},{-80,26},{-2,26}}, color={0,0,127}));
  connect(uHeaPreCon,conWatPumSpe. u)
    annotation (Line(points={{-200,130},{-140,130},{-140,30},{-2,30}},
      color={0,0,127}));
  connect(zer1.y, heaPreConVal.x1)
    annotation (Line(points={{-38,-40},{-20,-40},{-20,-60},{-2,-60}}, color={0,0,127}));
  connect(one3.y, heaPreConVal.f1)
    annotation (Line(points={{-98,-40},{-80,-40},{-80,-64},{-2,-64}},
      color={0,0,127}));
  connect(one4.y, heaPreConVal.x2)
    annotation (Line(points={{-98,-90},{-80,-90},{-80,-72},{-2,-72}},
      color={0,0,127}));
  connect(con1.y, heaPreConVal.f2)
    annotation (Line(points={{-38,-90},{-20,-90},{-20,-76},{-2,-76}}, color={0,0,127}));
  connect(uHeaPreCon, heaPreConVal.u)
    annotation (Line(points={{-200,130},{-140,130},{-140,-68},{-2,-68}},
      color={0,0,127}));
  connect(maxCooTowSpeSet.y, swi.u3)
    annotation (Line(points={{22,130},{40,130},{40,172},{58,172}},
      color={0,0,127}));
  connect(desConWatPumSpe, swi1.u1)
    annotation (Line(points={{-200,60},{-120,60},{-120,78},{58,78}}, color={0,0,127}));
  connect(conWatPumSpe.y, swi1.u3)
    annotation (Line(points={{22,30},{40,30},{40,62},{58,62}},
      color={0,0,127}));
  connect(uWSE, swi2.u2)
    annotation (Line(points={{-200,-20},{-160,-20},{-160,-120},{58,-120}},
      color={255,0,255}));
  connect(zer2.y, swi3.u3)
    annotation (Line(points={{62,-180},{110,-180},{110,-168},{138,-168}},
      color={0,0,127}));
  connect(uHeaPreEna, swi3.u2)
    annotation (Line(points={{-200,-160},{138,-160}},color={255,0,255}));
  connect(swi2.y, swi3.u1)
    annotation (Line(points={{82,-120},{120,-120},{120,-152},{138,-152}},
      color={0,0,127}));
  connect(swi3.y, yHeaPreConVal)
    annotation (Line(points={{162,-160},{200,-160}}, color={0,0,127}));
  connect(one.y, swi.u1)
    annotation (Line(points={{-98,160},{-80,160},{-80,188},{58,188}},
      color={0,0,127}));
  connect(desConWatPumSpe, conWatPumSpe.f1)
    annotation (Line(points={{-200,60},{-120,60},{-120,34},{-2,34}},
      color={0,0,127}));
  connect(one4.y, swi2.u3)
    annotation (Line(points={{-98,-90},{-80,-90},{-80,-128},{58,-128}},
      color={0,0,127}));
  connect(heaPreConVal.y, swi2.u1)
    annotation (Line(points={{22,-68},{40,-68},{40,-112},{58,-112}},
      color={0,0,127}));
  connect(uWSE, swi.u2) annotation (Line(points={{-200,-20},{-160,-20},{-160,180},
          {58,180}}, color={255,0,255}));
  connect(uWSE, swi1.u2) annotation (Line(points={{-200,-20},{-160,-20},{-160,70},
          {58,70}}, color={255,0,255}));
  connect(uHeaPreEna, swi4.u2) annotation (Line(points={{-200,-160},{100,-160},{
          100,40},{138,40}}, color={255,0,255}));
  connect(swi1.y, swi4.u1) annotation (Line(points={{82,70},{120,70},{120,48},{138,
          48}}, color={0,0,127}));
  connect(zer2.y, swi4.u3) annotation (Line(points={{62,-180},{110,-180},{110,32},
          {138,32}}, color={0,0,127}));
  connect(swi4.y, yConWatPumSpeSet)
    annotation (Line(points={{162,40},{200,40}}, color={0,0,127}));
  connect(swi.y, swi5.u1) annotation (Line(points={{82,180},{120,180},{120,148},
          {138,148}}, color={0,0,127}));
  connect(zer2.y, swi5.u3) annotation (Line(points={{62,-180},{110,-180},{110,132},
          {138,132}}, color={0,0,127}));
  connect(uHeaPreEna, swi5.u2) annotation (Line(points={{-200,-160},{100,-160},{
          100,140},{138,140}}, color={255,0,255}));
  connect(swi5.y, yMaxTowSpeSet)
    annotation (Line(points={{162,140},{200,140}}, color={0,0,127}));
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
          preserveAspectRatio=false, extent={{-180,-200},{180,200}})),
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
the head pressure control valve shall be closed; the maximum tower speed setpoint
and the condenser water pump speed setpoint becomes 0.
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
