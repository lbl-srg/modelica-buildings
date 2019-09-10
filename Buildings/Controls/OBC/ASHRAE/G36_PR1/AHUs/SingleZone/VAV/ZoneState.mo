within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV;
block ZoneState "Select the zone state"
  CDL.Interfaces.RealInput uHea "Heating control signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput uCoo "Cooling control signal"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
protected
  CDL.Conversions.BooleanToInteger booToIntHea(integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.heating)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
public
  CDL.Continuous.GreaterThreshold
                         greThr
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  CDL.Continuous.GreaterThreshold
                         greThr1
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
protected
  CDL.Conversions.BooleanToInteger booToIntCoo(integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.cooling)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
public
  CDL.Logical.Nor nor
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
protected
  CDL.Conversions.BooleanToInteger booToIntDea(integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.deadband)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
public
  CDL.Integers.MultiSum                        sumInt(final nin=3) "Sum of inputs"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  CDL.Interfaces.IntegerOutput yZonSta "Zone state"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(greThr.y, booToIntHea.u)
    annotation (Line(points={{-38,20},{18,20}}, color={255,0,255}));
  connect(greThr1.y, booToIntCoo.u)
    annotation (Line(points={{-38,-10},{18,-10}}, color={255,0,255}));
  connect(greThr1.y, nor.u2) annotation (Line(points={{-38,-10},{-36,-10},{-36,
          -58},{-22,-58}}, color={255,0,255}));
  connect(greThr.y, nor.u1) annotation (Line(points={{-38,20},{-30,20},{-30,-50},
          {-22,-50}},color={255,0,255}));
  connect(nor.y, booToIntDea.u)
    annotation (Line(points={{2,-50},{18,-50}},
                                              color={255,0,255}));
  connect(booToIntHea.y, sumInt.u[1]) annotation (Line(points={{42,20},{52,20},
          {52,4.66667},{58,4.66667}},color={255,127,0}));
  connect(booToIntCoo.y, sumInt.u[2]) annotation (Line(points={{42,-10},{48,-10},
          {48,0},{58,0}},color={255,127,0}));
  connect(booToIntDea.y, sumInt.u[3]) annotation (Line(points={{42,-50},{52,-50},
          {52,-4.66667},{58,-4.66667}},color={255,127,0}));
  connect(sumInt.y, yZonSta)
    annotation (Line(points={{82,0},{110,0}},   color={255,127,0}));
  connect(greThr.u, uHea) annotation (Line(points={{-62,20},{-90,20},{-90,40},{
          -120,40}}, color={0,0,127}));
  connect(greThr1.u, uCoo) annotation (Line(points={{-62,-10},{-84,-10},{-84,
          -40},{-120,-40}}, color={0,0,127}));
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
October 24, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneState;
