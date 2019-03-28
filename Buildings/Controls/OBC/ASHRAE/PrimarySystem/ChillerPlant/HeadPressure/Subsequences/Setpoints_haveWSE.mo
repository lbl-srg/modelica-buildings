within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences;
block Setpoints_haveWSE
  "Equipment setpoints when chiller head pressure control is enabled, for plants with waterside economizer"
  parameter Real minTowSpe
    "Minimum cooling tower fan speed";
  parameter Real minConWatPumSpe
    "Minimum condenser water pump speed";
  parameter Real minHeaPreValPos
    "Minimum head pressure control valve position";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet
    "Current maximum cooling tower speed setpoint"
    annotation (Placement(transformation(extent={{-160,160},{-120,200}}),
      iconTransformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaPreCon
    "Chiller head pressure control loop signal"
    annotation (Placement(transformation(extent={{-160,90},{-120,130}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe
    "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-160,38},{-120,78}}),
      iconTransformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe_nominal
    "Design condenser water pump speed for current stage"
    annotation (Placement(transformation(extent={{-160,10},{-120,50}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    "Status of water side economizer: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-160,-40},{-120,0}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaPreConVal
    "Current head pressure control valve position"
    annotation (Placement(transformation(extent={{-160,-170},{-120,-130}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaPreEna
    "Status of head pressure control: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-160,-200},{-120,-160}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMaxTowSpeSet(
    final unit="1",
    final min=0,
    final max=1) "Maximum cooling tower speed setpoint"
    annotation (Placement(transformation(extent={{120,150},{140,170}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpe(
    final unit="1",
    final min=0,
    final max=1) "Condenser water pump speed"
    annotation (Placement(transformation(extent={{120,40},{140,60}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaPreConVal(
    final unit="1",
    final min=0,
    final max=1) "Head pressure control valve position"
    annotation (Placement(transformation(extent={{120,-190},{140,-170}}),
      iconTransformation(extent={{100,-70},{120,-50}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Line maxCooTowSpeSet
    "Maximum cooling tower speed setpoint"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hal(final k=0.5)
    "Constant value"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hpTowMaxSpe(
    final k=minTowSpe)
    "Minimum allowable tower speed"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conWatPumSpe
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hal1(final k=0.5)
    "Constant value"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one2(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=minConWatPumSpe) "Minimum condenser water pump speed"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one3(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one4(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=minHeaPreValPos)
    "Minimum head pressure control valve position"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(final k=0)
    "Constant value"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Line heaPreConVal
    "Head pressure control valve position"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer2(final k=0)
    "Constant value"
    annotation (Placement(transformation(extent={{-40,-210},{-20,-190}})));

equation
  connect(zer.y, maxCooTowSpeSet.x1)
    annotation (Line(points={{-19,140},{0,140},{0,118},{18,118}}, color={0,0,127}));
  connect(one.y, maxCooTowSpeSet.f1)
    annotation (Line(points={{-59,140},{-50,140},{-50,114},{18,114}},
      color={0,0,127}));
  connect(hal.y, maxCooTowSpeSet.x2)
    annotation (Line(points={{-59,90},{-50,90},{-50,106},{18,106}},
      color={0,0,127}));
  connect(hpTowMaxSpe.y, maxCooTowSpeSet.f2)
    annotation (Line(points={{-19,90},{0,90},{0,102},{18,102}}, color={0,0,127}));
  connect(uHeaPreCon, maxCooTowSpeSet.u)
    annotation (Line(points={{-140,110},{18,110}}, color={0,0,127}));
  connect(hal1.y,conWatPumSpe. x1)
    annotation (Line(points={{-19,30},{0,30},{0,18},{18,18}}, color={0,0,127}));
  connect(con.y,conWatPumSpe. f2)
    annotation (Line(points={{-19,-20},{0,-20},{0,2},{18,2}}, color={0,0,127}));
  connect(one2.y,conWatPumSpe. x2)
    annotation (Line(points={{-59,-20},{-50,-20},{-50,6},{18,6}}, color={0,0,127}));
  connect(uHeaPreCon,conWatPumSpe. u)
    annotation (Line(points={{-140,110},{-100,110},{-100,10},{18,10}},
      color={0,0,127}));
  connect(zer1.y, heaPreConVal.x1)
    annotation (Line(points={{-19,-60},{0,-60},{0,-72},{18,-72}}, color={0,0,127}));
  connect(one3.y, heaPreConVal.f1)
    annotation (Line(points={{-59,-60},{-50,-60},{-50,-76},{18,-76}},
      color={0,0,127}));
  connect(one4.y, heaPreConVal.x2)
    annotation (Line(points={{-59,-110},{-50,-110},{-50,-84},{18,-84}},
      color={0,0,127}));
  connect(con1.y, heaPreConVal.f2)
    annotation (Line(points={{-19,-110},{0,-110},{0,-88},{18,-88}}, color={0,0,127}));
  connect(uHeaPreCon, heaPreConVal.u)
    annotation (Line(points={{-140,110},{-100,110},{-100,-80},{18,-80}},
      color={0,0,127}));
  connect(uMaxTowSpeSet, swi.u1)
    annotation (Line(points={{-140,180},{60,180},{60,168},{78,168}},
      color={0,0,127}));
  connect(uWSE, swi.u2)
    annotation (Line(points={{-140,-20},{-104,-20},{-104,160},{78,160}},
      color={255,0,255}));
  connect(maxCooTowSpeSet.y, swi.u3)
    annotation (Line(points={{41,110},{60,110},{60,152},{78,152}},
      color={0,0,127}));
  connect(swi.y, yMaxTowSpeSet)
    annotation (Line(points={{101,160},{130,160}}, color={0,0,127}));
  connect(uWSE, swi1.u2)
    annotation (Line(points={{-140,-20},{-104,-20},{-104,50},{78,50}},
      color={255,0,255}));
  connect(uConWatPumSpe, swi1.u1)
    annotation (Line(points={{-140,58},{78,58}}, color={0,0,127}));
  connect(conWatPumSpe.y, swi1.u3)
    annotation (Line(points={{41,10},{60,10},{60,42},{78,42}},
      color={0,0,127}));
  connect(swi1.y, yConWatPumSpe)
    annotation (Line(points={{101,50},{130,50}}, color={0,0,127}));
  connect(heaPreConVal.y, swi2.u1)
    annotation (Line(points={{41,-80},{60,-80},{60,-122},{78,-122}},
      color={0,0,127}));
  connect(uWSE, swi2.u2)
    annotation (Line(points={{-140,-20},{-104,-20},{-104,-130},{78,-130}},
      color={255,0,255}));
  connect(uHeaPreConVal, swi2.u3)
    annotation (Line(points={{-140,-150},{60,-150},{60,-138},{78,-138}},
      color={0,0,127}));
  connect(zer2.y, swi3.u3)
    annotation (Line(points={{-19,-200},{60,-200},{60,-188},{78,-188}},
      color={0,0,127}));
  connect(uHeaPreEna, swi3.u2)
    annotation (Line(points={{-140,-180},{78,-180}}, color={255,0,255}));
  connect(swi2.y, swi3.u1)
    annotation (Line(points={{101,-130},{110,-130},{110,-160},{60,-160},
      {60,-172},{78,-172}}, color={0,0,127}));
  connect(swi3.y, yHeaPreConVal)
    annotation (Line(points={{101,-180},{130,-180}}, color={0,0,127}));
  connect(uConWatPumSpe_nominal, conWatPumSpe.f1)
    annotation (Line(points={{-140,30},{-48,30},{-48,14},{18,14}},
      color={0,0,127}));

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
  Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-120,-220},{120,200}})),
  Documentation(info="<html>
<p>
Block that resets maximum cooling tower speed setpoint <code>yMaxTowSpeSet</code>, 
controls condenser water pump speed <code>yConWatPumSpe</code> and 
head pressure control valve position <code>yHeaPreConVal</code>
for plants with water side economizers. The development follows
ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.10 Head pressure control, part 5.2.10.4, 5.2.10.5 and 5.2.10.6.
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
pump speed <code>yConWatPumSpe</code> from design speed for the stage 
<code>uConWatPumSpe_nominal</code> to minimum speed <code>minConWatPumSpe</code>.
</li>
</ul>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/HeadPressure/Subsequences/HeadControlCWP_WSE.png\"
     alt=\"HeadControlCWP_WSE.png\" />
</p>

<p>
2. When the waterside economizer is enabled (<code>uWSE</code> = true), each
enabled chiller head pressure control loop output <code>uHeaPreCon</code> 
shall reset head pressure control valve position <code>yHeaPreConVal</code> 
from 100% open at 0% loop output to minimum position <code>minHeaPreValPos</code>
at 100% loop output.
</p>

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
end Setpoints_haveWSE;
