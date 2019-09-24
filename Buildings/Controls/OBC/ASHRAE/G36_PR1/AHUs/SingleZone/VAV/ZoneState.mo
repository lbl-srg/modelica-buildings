within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV;
block ZoneState "Select the zone state"
  parameter Real uLow(final unit = "1") = 0.01
    "Hysteresis parameter uLow for heating and cooling control signals to avoid chattering";
  parameter Real uHigh(final unit = "1") = 0.05
    "Hysteresis parameter uHigh for heating and cooling control signals to avoid chattering";
  CDL.Interfaces.RealInput uHea "Heating control signal"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput uCoo "Cooling control signal"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.IntegerOutput yZonSta "Zone state"
    annotation (Placement(transformation(extent={{140,-10},{160,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
protected
  CDL.Conversions.BooleanToInteger booToIntHea(integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.heating)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  CDL.Conversions.BooleanToInteger booToIntCoo(integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.cooling)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  CDL.Logical.Nor nor
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  CDL.Conversions.BooleanToInteger booToIntDea(integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.deadband)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  CDL.Integers.MultiSum sumInt(final nin=3) "Sum of inputs"
    annotation (Placement(transformation(extent={{116,-10},{136,10}})));

  CDL.Logical.And and1
    annotation (Placement(transformation(extent={{-72,30},{-52,50}})));
  CDL.Continuous.Hysteresis greThr(uLow=uLow, uHigh=uHigh)
    "Check if it is in heating mode"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  CDL.Continuous.Hysteresis greThr1(uLow=uLow, uHigh=uHigh)
    "Check if it is in cooling mode"
    annotation (Placement(transformation(extent={{-44,-50},{-24,-30}})));
  CDL.Continuous.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-130,0},{-110,20}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  CDL.Continuous.Hysteresis greThr3(uLow=-uLow, uHigh=uLow)
    "Check if it is in heating mode"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-44,0},{-24,20}})));
equation
  connect(nor.y, booToIntDea.u)
    annotation (Line(points={{62,-70},{78,-70}}, color={255,0,255}));
  connect(booToIntHea.y, sumInt.u[1]) annotation (Line(points={{22,40},{68,40},
          {68,4.66667},{114,4.66667}}, color={255,127,0}));
  connect(booToIntCoo.y, sumInt.u[2]) annotation (Line(points={{62,-20},{80,-20},
          {80,0},{114,0}}, color={255,127,0}));
  connect(sumInt.y, yZonSta)
    annotation (Line(points={{138,0},{150,0}}, color={255,127,0}));
  connect(greThr.y, and1.u1)
    annotation (Line(points={{-98,70},{-76,70},{-76,40},{-74,40}}, color={255,0,255}));
  connect(uHea, greThr.u)
    annotation (Line(points={{-160,40},{-136,40},{-136,70},{-122,70}}, color={0,0,127}));
  connect(uCoo, greThr1.u)
    annotation (Line(points={{-160,-40},{-46,-40}}, color={0,0,127}));
  connect(uCoo, add1.u2) annotation (Line(points={{-160,-40},{-136,-40},{-136,4},
          {-132,4}}, color={0,0,127}));
  connect(uHea, add1.u1) annotation (Line(points={{-160,40},{-136,40},{-136,16},
          {-132,16}}, color={0,0,127}));
  connect(and2.y, booToIntCoo.u)
    annotation (Line(points={{12,-20},{38,-20}}, color={255,0,255}));
  connect(greThr1.y, and2.u2) annotation (Line(points={{-22,-40},{-20,-40},{-20,
          -28},{-12,-28}}, color={255,0,255}));
  connect(add1.y, greThr3.u)
    annotation (Line(points={{-108,10},{-102,10}}, color={0,0,127}));
  connect(and1.y, booToIntHea.u)
    annotation (Line(points={{-50,40},{-2,40}}, color={255,0,255}));
  connect(and1.y, not1.u) annotation (Line(points={{-50,40},{-48,40},{-48,10},{
          -46,10}}, color={255,0,255}));
  connect(greThr3.y, and1.u2) annotation (Line(points={{-78,10},{-76,10},{-76,
          32},{-74,32}}, color={255,0,255}));
  connect(not1.y, and2.u1) annotation (Line(points={{-22,10},{-20,10},{-20,-20},
          {-12,-20}}, color={255,0,255}));
  connect(and2.y, nor.u2) annotation (Line(points={{12,-20},{20,-20},{20,-78},{
          38,-78}}, color={255,0,255}));
  connect(booToIntDea.y, sumInt.u[3]) annotation (Line(points={{102,-70},{108,
          -70},{108,-4.66667},{114,-4.66667}}, color={255,127,0}));
  connect(and1.y, nor.u1) annotation (Line(points={{-50,40},{-10,40},{-10,0},{
          26,0},{26,-70},{38,-70}}, color={255,0,255}));
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
        lineColor={0,0,255})}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
   Documentation(info="<html>
<p>
Block that outputs the zone state. It first checks if the zone is in heating state; 
if not, then checks if the zone is in cooling state; otherwise it is in deadband state.
</p>
<p>
These states are defined in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates</a>.
</p>
<p>
The logic of the block is described as follows.
</p>
<p>
The zone state is heating when both of the following two conditions satisfy: 
<ul>
<li>
the heating control signal <code>uHea</code> becomes greater than the parameter <code>uHigh</code>; 
</li>
<li>
the delta between <code>uHea</code> and the cooling control signal <code>uCoo</code> becomes greater than 
the parameter <code>uLow</code>, which can be written as <code>(uHea-uCoo)>uLow</code>. 
</li>
</ul>
</p>
<p>
The zone state is not heating when either of the following conditions satisfies: <code>uHea</code> becomes less than the parameter
<code>uLow</code> or <code>(uHea-uCoo)</code> becomes less than <code>-uLow</code>. The parameters 
<code>uHigh</code> and <code>uLow</code> are hysteresis parameters to avoid chattering, which apply in the same way
for the cooling state checking.
</p>
<p>
The zone state is cooling when the zone state is not heating and the cooling control signal <code>uCoo</code> becomes
greater than <code>uHigh</code>. When <code>uCoo</code> becomes less than <code>uLow</code>, then the zone state is not cooling.
</p>
<p>
The zone state is deadband when it is neither in heating state nor in cooling state.
</p>
</html>",revisions="<html>
<ul>
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
end ZoneState;
