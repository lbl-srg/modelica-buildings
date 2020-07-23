within Buildings.Experimental.RadiantControl.SlabTempSignal.OutputOnly;
block SlabSetCore
  "Determines slab temperature setpoint for core zones"
  parameter Real TSlaCor(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=294.3;

  Controls.OBC.CDL.Interfaces.RealOutput TSlaSetCor
    "Slab temperature setpoint for a core zone"
    annotation (Placement(transformation(extent={{100,-10},{140,30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSlabCore(k=TSlaCor)
    "Slab setpoint for core zones"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(TSlabCore.y, TSlaSetCor)
    annotation (Line(points={{22,10},{120,10}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This outputs a user-selected constant setpoint for a core zone.
</p>
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
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="duration=%duration"),
       Text(
          extent={{-72,78},{102,6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        textString="Sc"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SlabSetCore;
