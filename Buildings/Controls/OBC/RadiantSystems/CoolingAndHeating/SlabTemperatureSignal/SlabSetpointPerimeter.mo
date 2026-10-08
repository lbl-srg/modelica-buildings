within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal;
block SlabSetpointPerimeter
  "Determines slab temperature setpoint for perimeter zones from forecast outdoor air high temperature"
  Controls.SetPoints.Table           tabSlab(table=[274.8166667,302.5944444;
        274.8167222,300.9277778; 280.3722222,300.9277778; 280.3727778,
        300.9277778; 285.9277778,300.9277778; 285.9283333,298.7055556;
        291.4833333,298.7055556; 291.4838889,296.4833333; 292.5944444,
        296.4833333; 292.5945,296.4833333; 293.15,296.4833333; 293.1500556,
        295.9277778; 295.3722222,295.9277778; 295.3722778,295.3722222;
        295.9277778,295.3722222; 295.9278333,292.5944444; 299.8166667,
        292.5944444; 299.8172222,291.4833333; 302.5944444,291.4833333])
    "Slab setpoint lookup table"
    annotation (Placement(transformation(extent={{-20,-62},{-62,-20}})));
  Controls.OBC.CDL.Interfaces.RealInput TFor
    "High temperature for the day, as forecasted one day prior"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Controls.OBC.CDL.Interfaces.RealOutput TSlaSetPer
    "Slab temperature setpoint, determined based on forecast outdoor air high temperature"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Controls.OBC.CDL.Discrete.Sampler sam(samplePeriod=86400)
    "Samples forecast high each day"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(sam.y, tabSlab.u) annotation (Line(points={{-18,10},{0,10},{0,-41},{
          -15.8,-41}},
                 color={0,0,127}));
  connect(TFor, sam.u) annotation (Line(points={{-120,0},{-92,0},{-92,10},{-42,
          10}},
        color={0,0,127}));
  connect(tabSlab.y, TSlaSetPer) annotation (Line(points={{-64.1,-41},{-84,-41},
          {-84,-80},{78,-80},{78,0},{120,0}}, color={0,0,127}));
  annotation (defaultComponentName = "slaSetPer",Documentation(info="<html>
<p>
This determines the slab temperature setpoint for a perimeter zone from the forecast high OAT. 
Temperature setpoint is selected from a lookup table. </p>
<p>Note that this setpoint is determined differently than the setpoint for core zones, which is set to a constant value throughout the year (typically 70F).
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
        extent={{-90,60},{90,-60}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        textString="Sp"),
        Text(
          extent={{-56,90},{48,-60}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-62,90},{34,44}},
          lineColor={0,0,0},
          lineThickness=1,
          horizontalAlignment=TextAlignment.Left,
          fontName="Arial Narrow",
          textString="Slab Perimeter Setpoint: 
Selects slab temperature setpoint 
for a perimeter zone 
from lookup table based on forecast high",
          textStyle={TextStyle.Bold})}));
end SlabSetpointPerimeter;
