within Buildings.Controls.OBC.ASHRAE.G36.ThermalZones;
block ZoneStates "Select the zone state"

  parameter Real uLow(
    final unit = "1") = 0.01
    "Hysteresis parameter uLow for heating and cooling control signals to avoid chattering"
    annotation (__cdl(ValueInReference=false));
  parameter Real uHigh(
    final unit = "1") = 0.05
    "Hysteresis parameter uHigh for heating and cooling control signals to avoid chattering"
    annotation (__cdl(ValueInReference=false));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea "Heating control signal"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo "Cooling control signal"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonSta "Zone state"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToIntHea(
    final integerFalse=0,
    final integerTrue=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.heating)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToIntCoo(
    final integerFalse=0,
    final integerTrue=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.cooling)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{28,-30},{48,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Nor isDea "In deadband state"
    annotation (Placement(transformation(extent={{30,-80},{50,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToIntDea(
    final integerFalse=0,
    final integerTrue=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.deadband)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{70,-80},{90,-60}})));
  Buildings.Controls.OBC.CDL.Logical.And isHea "In heating state if both conditions are true"
    annotation (Placement(transformation(extent={{-72,30},{-52,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysUHea(
    final uLow=uLow,
    final uHigh=uHigh)
    "Check if it is in heating state"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysUCoo(
    final uLow=uLow,
    final uHigh=uHigh)
    "Check if it is in cooling state"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract uHeaMinUCoo
    "Difference between uHea and uCoo"
    annotation (Placement(transformation(extent={{-130,0},{-110,20}})));
  Buildings.Controls.OBC.CDL.Logical.And isCoo "In cooling state if both inputs are true"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysU(
    final uLow=-uLow,
    final uHigh=uLow)
    "Check if heating control signal is bigger than cooling control signal"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not notHea "Not in heating state"
    annotation (Placement(transformation(extent={{-44,0},{-24,20}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt "Add two integer inputs"
    annotation (Placement(transformation(extent={{70,20},{90,40}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt1 "Add two integer inputs"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));

equation
  connect(isDea.y, booToIntDea.u)
    annotation (Line(points={{52,-70},{68,-70}}, color={255,0,255}));
  connect(hysUHea.y, isHea.u1) annotation (Line(points={{-98,70},{-76,70},{-76,
          40},{-74,40}}, color={255,0,255}));
  connect(uHea, hysUHea.u) annotation (Line(points={{-160,40},{-136,40},{-136,
          70},{-122,70}}, color={0,0,127}));
  connect(uCoo,hysUCoo. u)
    annotation (Line(points={{-160,-40},{-102,-40}},color={0,0,127}));
  connect(uCoo, uHeaMinUCoo.u2) annotation (Line(points={{-160,-40},{-136,-40},
          {-136,4},{-132,4}}, color={0,0,127}));
  connect(uHea, uHeaMinUCoo.u1) annotation (Line(points={{-160,40},{-136,40},{-136,
          16},{-132,16}}, color={0,0,127}));
  connect(isCoo.y, booToIntCoo.u)
    annotation (Line(points={{12,-20},{26,-20}}, color={255,0,255}));
  connect(hysUCoo.y, isCoo.u2) annotation (Line(points={{-78,-40},{-20,-40},{-20,
          -28},{-12,-28}}, color={255,0,255}));
  connect(uHeaMinUCoo.y, hysU.u)
    annotation (Line(points={{-108,10},{-102,10}}, color={0,0,127}));
  connect(isHea.y, booToIntHea.u)
    annotation (Line(points={{-50,40},{-2,40}}, color={255,0,255}));
  connect(isHea.y, notHea.u) annotation (Line(points={{-50,40},{-48,40},{-48,10},
          {-46,10}}, color={255,0,255}));
  connect(hysU.y, isHea.u2) annotation (Line(points={{-78,10},{-76,10},{-76,32},
          {-74,32}}, color={255,0,255}));
  connect(notHea.y, isCoo.u1) annotation (Line(points={{-22,10},{-20,10},{-20,-20},
          {-12,-20}}, color={255,0,255}));
  connect(isCoo.y, isDea.u2) annotation (Line(points={{12,-20},{20,-20},{20,-78},
          {28,-78}}, color={255,0,255}));
  connect(isHea.y, isDea.u1) annotation (Line(points={{-50,40},{-48,40},{-48,-70},
          {28,-70}},                 color={255,0,255}));
  connect(booToIntHea.y, addInt.u1) annotation (Line(points={{22,40},{60,40},{60,
          36},{68,36}}, color={255,127,0}));
  connect(booToIntCoo.y, addInt.u2) annotation (Line(points={{50,-20},{60,-20},{
          60,24},{68,24}}, color={255,127,0}));
  connect(addInt.y, addInt1.u1) annotation (Line(points={{92,30},{100,30},{100,6},
          {108,6}}, color={255,127,0}));
  connect(booToIntDea.y, addInt1.u2) annotation (Line(points={{92,-70},{100,-70},
          {100,-6},{108,-6}}, color={255,127,0}));
  connect(addInt1.y, yZonSta)
    annotation (Line(points={{132,0},{160,0}}, color={255,127,0}));
  annotation (
        defaultComponentName="zonSta",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        textColor={0,0,255})}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
   Documentation(info="<html>
<p>
Block that outputs the zone state. It first checks if the zone is in heating state;
if not, it checks if the zone is in cooling state; otherwise it is in deadband state.
</p>
<p>
These states are defined in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates\">
Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates</a>.
</p>
<p>
The logic of the block is as follows.
</p>
<ol>
<li>
The zone state is heating when both of the following two conditions are satisfied:
(i) The heating control signal satisfies <code>uHea &gt; uHigh</code>, where
<code>uHigh</code> is a parameter,
and (ii) the following condition is satisfied <code>uHea - uCoo > uLow</code>,
where <code>uCoo</code> is the cooling control signal and <code>uLow</code> is a parameter.
The second condition is
used to avoid errors when <code>uHea > 0</code> and <code>uCoo > 0</code> at the same time.
</li>
<li>
The zone state is cooling when the zone state is not heating and the cooling control signal satisfies
<code>uCoo > uHigh</code>, where <code>uHigh</code> is a parameter.
If <code>uCoo &lt; uLow</code>, then the zone state is not cooling.
</li>
<li>
The zone state is deadband when it is neither in heating state nor in cooling state.
</li>
</ol>
</html>",revisions="<html>
<ul>
<li>
March 13, 2020, by Jianjun Hu:<br/>
Replaced <code>multiSum</code> block with two addition blocks to avoid vector related implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">#1709</a>.
</li>
<li>
September 11, 2019, by Kun Zhang:<br/>
Improved the implementation to avoid issues when heating and cooling controls occur at the same time.
</li>
<li>
October 24, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneStates;
