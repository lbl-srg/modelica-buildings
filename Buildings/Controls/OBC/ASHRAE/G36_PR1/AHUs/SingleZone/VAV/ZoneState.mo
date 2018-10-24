within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV;
block ZoneState "Select the zone state"
  CDL.Interfaces.RealInput uHea "Heating control signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput uCoo "Cooling control signal"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
protected
  CDL.Conversions.BooleanToInteger booToIntHea(integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.heating)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
public
  CDL.Continuous.Greater greHea
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  CDL.Continuous.Greater greCoo
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  CDL.Continuous.Sources.Constant con(k=0)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
protected
  CDL.Conversions.BooleanToInteger booToIntCoo(integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.cooling)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
public
  CDL.Logical.Nor nor
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
protected
  CDL.Conversions.BooleanToInteger booToIntDea(integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.deadband)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
public
  CDL.Integers.MultiSum                        sumInt(final nin=3) "Sum of inputs"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  CDL.Interfaces.IntegerOutput yZonSta "Zone state"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(con.y, greCoo.u2) annotation (Line(points={{-79,-90},{-70,-90},{-70,
          42},{-62,42}},
                     color={0,0,127}));
  connect(greHea.u2, greCoo.u2) annotation (Line(points={{-62,82},{-70,82},{-70,
          42},{-62,42}}, color={0,0,127}));
  connect(uHea, greHea.u1) annotation (Line(points={{-120,40},{-90,40},{-90,90},
          {-62,90}}, color={0,0,127}));
  connect(uCoo, greCoo.u1) annotation (Line(points={{-120,-40},{-80,-40},{-80,
          50},{-62,50}},
                     color={0,0,127}));
  connect(greHea.y, booToIntHea.u)
    annotation (Line(points={{-39,90},{18,90}}, color={255,0,255}));
  connect(greCoo.y, booToIntCoo.u)
    annotation (Line(points={{-39,50},{18,50}}, color={255,0,255}));
  connect(greCoo.y, nor.u2) annotation (Line(points={{-39,50},{-36,50},{-36,2},{
          -22,2}}, color={255,0,255}));
  connect(greHea.y, nor.u1) annotation (Line(points={{-39,90},{-30,90},{-30,10},
          {-22,10}}, color={255,0,255}));
  connect(nor.y, booToIntDea.u)
    annotation (Line(points={{1,10},{18,10}}, color={255,0,255}));
  connect(booToIntHea.y, sumInt.u[1]) annotation (Line(points={{41,90},{52,90},{
          52,4.66667},{58,4.66667}}, color={255,127,0}));
  connect(booToIntCoo.y, sumInt.u[2]) annotation (Line(points={{41,50},{48,50},{
          48,0},{58,0}}, color={255,127,0}));
  connect(booToIntDea.y, sumInt.u[3]) annotation (Line(points={{41,10},{44,10},{
          44,-4.66667},{58,-4.66667}}, color={255,127,0}));
  connect(sumInt.y, yZonSta)
    annotation (Line(points={{81.7,0},{110,0}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
</p>
</html>",revisions="<html>
<ul>
<li>
October 24, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneState;
