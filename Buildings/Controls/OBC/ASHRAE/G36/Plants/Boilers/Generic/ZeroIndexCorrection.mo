within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic;
block ZeroIndexCorrection
  "Block to pass modified list item values when index signal is zero, while avoiding assert errors"

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uInd
    "Index signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uVal
    "List item value"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIndMod
    "Modified index value to avoid assert errors"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValMod
    "Modified list item value"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if the index signal is zero"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntZer(
    final k=0)
    "Constant zero integer signal"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=0,
    final realFalse=1)
    "Pass a zero multiplication signal to the capacity modfier"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt
    "Add one to the index value when it is zero"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Pass an integer one signal to the index modifier"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Multiply the capacity value by zero when the index signal is zero"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

equation
  connect(uInd, intEqu.u1)
    annotation (Line(points={{-120,40},{-42,40}}, color={255,127,0}));
  connect(conIntZer.y, intEqu.u2) annotation (Line(points={{-58,10},{-50,10},{-50,
          32},{-42,32}}, color={255,127,0}));
  connect(intEqu.y, booToRea.u) annotation (Line(points={{-18,40},{-10,40},{-10,
          20},{-2,20}}, color={255,0,255}));
  connect(uInd, addInt.u1) annotation (Line(points={{-120,40},{-80,40},{-80,86},
          {38,86}}, color={255,127,0}));
  connect(intEqu.y, booToInt1.u) annotation (Line(points={{-18,40},{-10,40},{-10,
          60},{-2,60}}, color={255,0,255}));
  connect(booToInt1.y, addInt.u2) annotation (Line(points={{22,60},{30,60},{30,74},
          {38,74}}, color={255,127,0}));
  connect(addInt.y, yIndMod) annotation (Line(points={{62,80},{80,80},{80,40},{120,
          40}}, color={255,127,0}));
  connect(mul.y,yValMod)
    annotation (Line(points={{62,-40},{120,-40}}, color={0,0,127}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{22,20},{30,20},{30,-34},
          {38,-34}}, color={0,0,127}));
  connect(uVal, mul.u2) annotation (Line(points={{-120,-40},{30,-40},{30,-46},{38,
          -46}}, color={0,0,127}));
  annotation (defaultComponentName="zerIndCor",
    Icon(coordinateSystem(preserveAspectRatio=false),
      graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-110,140},{110,100}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This block has been implemented to retain the original interpretation and
implementation of the boilr plant sequences in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers</a> while accommodating changes
to the real-value extractor block 
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.RealExtractor\">
Buildings.Controls.OBC.CDL.Routing.RealExtractor</a>.
</p>
<p>
Some of the calculations in the the boiler plant sequence implementation rely on
the use of zero capacity and flowrate values corresponding to the zero plant stage
representing plant disabled status. Since the <code>RealExtractor</code> block no
longer allows the assignment of a specific value at index values lower than 1,
this block has been implemented to assign the requiered zero value at zero index.
</p>
<p>
The block accepts input signals <code>uInd</code> for the
current index value, and <code>uVal</code> for the current list value signal. 
It outputs a modified index signal <code>yIndMod</code> and a modified 
value signal <code>yValMod</code>.
</p>
<ul>
<li>
<code>yIndMod</code> is set to 1 and <code>yValMod</code> is set to zero 
when <code>uInd</code> is zero.
</li>
<li>
<code>yIndMod</code> is set to <code>uInd</code> and <code>yValMod</code> is
set to <code>uVal</code> when <code>uInd</code> is not zero.
</li>
</ul>
<p>
For an example of usage, check the
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Capacities\">
Capacities</a> block.
</p>
</html>", revisions="<html>
<ul>
<li>
April 3, 2023, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZeroIndexCorrection;
