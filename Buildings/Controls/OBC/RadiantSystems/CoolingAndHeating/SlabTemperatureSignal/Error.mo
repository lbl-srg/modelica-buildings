within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal;
block Error "Determines difference between slab temperature and slab setpoint"
  Controls.OBC.CDL.Interfaces.RealInput TSla "Slab temperature"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}})));
  Controls.OBC.CDL.Interfaces.RealInput TSlaSet "Slab temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Controls.OBC.CDL.Interfaces.RealOutput slaTemErr
    "Difference between slab temp and setpoint"
    annotation (Placement(transformation(extent={{100,-10},{140,30}})));
  Controls.OBC.CDL.Continuous.Add add(k2=-1)
    "Slab temperature minus slab setpoint"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(TSla, add.u1) annotation (Line(points={{-120,10},{-61,10},{-61,16},{
          -2,16}}, color={0,0,127}));
  connect(TSlaSet, add.u2) annotation (Line(points={{-120,-30},{-60,-30},{-60,4},
          {-2,4}}, color={0,0,127}));
  connect(add.y, slaTemErr)
    annotation (Line(points={{22,10},{120,10}}, color={0,0,127}));
  annotation (defaultComponentName = "err",Documentation(info="<html>
<p>
This calculates the slab error, ie the difference between the slab temperature and its setpoint.
This term is what drives calls for heating or for cooling. 

</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation. 
</li>
</ul>
</html>"),Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),  Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-70},{-40,-70},{31,38}}),
        Line(points={{31,38},{86,38}}),
        Text(
        extent={{-56,90},{48,-88}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        textString="E"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-48,86},{48,40}},
          lineColor={0,0,0},
          lineThickness=1,
          horizontalAlignment=TextAlignment.Left,
          fontName="Arial Narrow",
          textStyle={TextStyle.Bold},
          textString="Slab Error:
Calculates slab error 
from slab temperature 
and slab setpoint")}));
end Error;
