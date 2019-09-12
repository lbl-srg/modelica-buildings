within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV;
block ZoneState "Select the zone state"
  parameter Real uLow(final unit = "1") = 0.01
    "Hysteresis parameter uLow for heating and cooling control signals to avoid chattering";
  parameter Real uHigh(final unit = "1") = 0.05
    "Hysteresis parameter uHigh for heating and cooling control signals to avoid chattering";
  CDL.Interfaces.RealInput uHea "Heating control signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput uCoo "Cooling control signal"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
protected
  CDL.Conversions.BooleanToInteger booToIntHea(integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.heating)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
protected
  CDL.Conversions.BooleanToInteger booToIntCoo(integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.cooling)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
public
  CDL.Logical.Nor nor
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
protected
  CDL.Conversions.BooleanToInteger booToIntDea(integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.deadband)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
public
  CDL.Integers.MultiSum                        sumInt(final nin=3) "Sum of inputs"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  CDL.Interfaces.IntegerOutput yZonSta "Zone state"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  CDL.Logical.And and1
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  CDL.Continuous.Hysteresis greThr(uLow=uLow, uHigh=uHigh)
    "Check if it is in heating mode"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  CDL.Continuous.Hysteresis greThr1(uLow=uLow, uHigh=uHigh)
    "Check if it is in cooling mode"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  CDL.Continuous.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  CDL.Continuous.GreaterThreshold greThr2
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
equation
  connect(nor.y, booToIntDea.u)
    annotation (Line(points={{22,-70},{38,-70}},
                                              color={255,0,255}));
  connect(booToIntHea.y, sumInt.u[1]) annotation (Line(points={{62,40},{68,40},{
          68,4.66667},{70,4.66667}}, color={255,127,0}));
  connect(booToIntCoo.y, sumInt.u[2]) annotation (Line(points={{62,-40},{64,-40},
          {64,0},{70,0}},color={255,127,0}));
  connect(booToIntDea.y, sumInt.u[3]) annotation (Line(points={{62,-70},{68,-70},
          {68,-4.66667},{70,-4.66667}},color={255,127,0}));
  connect(sumInt.y, yZonSta)
    annotation (Line(points={{94,0},{110,0}},   color={255,127,0}));
  connect(booToIntHea.u, and1.y)
    annotation (Line(points={{38,40},{22,40}}, color={255,0,255}));
  connect(nor.u1, and1.y) annotation (Line(points={{-2,-70},{-10,-70},{-10,-20},
          {26,-20},{26,40},{22,40}},
                                 color={255,0,255}));
  connect(greThr.y, and1.u1)
    annotation (Line(points={{-38,40},{-2,40}}, color={255,0,255}));
  connect(uHea, greThr.u)
    annotation (Line(points={{-120,40},{-62,40}}, color={0,0,127}));
  connect(uCoo, greThr1.u)
    annotation (Line(points={{-120,-40},{-62,-40}}, color={0,0,127}));
  connect(greThr1.y, nor.u2) annotation (Line(points={{-38,-40},{-20,-40},{-20,-78},
          {-2,-78}},      color={255,0,255}));
  connect(uCoo, add1.u2) annotation (Line(points={{-120,-40},{-94,-40},{-94,4},{
          -92,4}}, color={0,0,127}));
  connect(uHea, add1.u1) annotation (Line(points={{-120,40},{-94,40},{-94,16},{-92,
          16}}, color={0,0,127}));
  connect(add1.y, greThr2.u)
    annotation (Line(points={{-68,10},{-62,10}}, color={0,0,127}));
  connect(greThr2.y, and1.u2) annotation (Line(points={{-38,10},{-34,10},{-34,32},
          {-2,32}}, color={255,0,255}));
  connect(and2.y, booToIntCoo.u)
    annotation (Line(points={{22,-40},{38,-40}}, color={255,0,255}));
  connect(greThr1.y, and2.u2) annotation (Line(points={{-38,-40},{-20,-40},{-20,
          -48},{-2,-48}}, color={255,0,255}));
  connect(greThr2.y, not1.u)
    annotation (Line(points={{-38,10},{-32,10}}, color={255,0,255}));
  connect(and2.u1, not1.y) annotation (Line(points={{-2,-40},{-4,-40},{-4,10},{-8,
          10}},                     color={255,0,255}));
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
        lineColor={0,0,255})}),           Diagram(coordinateSystem(
          preserveAspectRatio=false)),
   Documentation(info="<html>
<p>
This block outputs the zone state.
</p>
<ul>
<li>
The zone state is heating if the heating control signal is nonzero.
</li>
<li>
The zone state is cooling if the cooling control signal is nonzero.
</li>
<li>
The zone state is deadband otherwise.
</li>
</ul>
</html>",revisions="<html>
<ul>
<li>
September 11, 2019, by Kun Zhang:<br/>
Improved the implementation.
</li>
<li>
October 24, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneState;
