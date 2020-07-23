within Buildings.Experimental.RadiantControl.SlabTempSignal;
block SlabSetPerim "Determines slab temperature setpoint for perimeter zones from forecast outdoor air high temperature"
  Controls.OBC.CDL.Logical.Sources.Pulse           booPul1(period=86400,
      startTime=0)
    "Pulse each day at midnight triggering sample of forecast outdoor air high temperature"
    annotation (Placement(transformation(extent={{-82,80},{-62,100}})));
  Controls.OBC.CDL.Discrete.TriggeredSampler           triSam
    "Samples forecast high at midnight each day"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Controls.SetPoints.Table           tabSlab(table=[274.8166667,302.5944444;
        274.8167222,300.9277778; 280.3722222,300.9277778; 280.3727778,
        300.9277778; 285.9277778,300.9277778; 285.9283333,298.7055556;
        291.4833333,298.7055556; 291.4838889,296.4833333; 292.5944444,
        296.4833333; 292.5945,296.4833333; 293.15,296.4833333; 293.1500556,
        295.9277778; 295.3722222,295.9277778; 295.3722778,295.3722222;
        295.9277778,295.3722222; 295.9278333,292.5944444; 299.8166667,
        292.5944444; 299.8172222,291.4833333; 302.5944444,291.4833333])
    "Slab setpoint lookup table"
    annotation (Placement(transformation(extent={{-122,22},{-164,64}})));
  Modelica.Blocks.Discrete.ZeroOrderHold zeroOrderHold(samplePeriod=86400,
      startTime=0) "Holds slab setpoint for a day"
    annotation (Placement(transformation(extent={{104,-2},{124,18}})));
  Controls.OBC.CDL.Interfaces.RealInput TFor
    "High temperature for the day, as forecasted one day prior"
    annotation (Placement(transformation(extent={{-222,110},{-182,150}})));
  Controls.OBC.CDL.Interfaces.RealOutput TSlaSetPer
    "Slab temperature setpoint, determined based on forecast outdoor air high temperature"
    annotation (Placement(transformation(extent={{180,30},{220,70}})));
equation
  connect(triSam.y,tabSlab. u) annotation (Line(points={{-58,130},{46,130},
          {46,43},{-117.8,43}},
                              color={0,0,127}));
  connect(booPul1.y, triSam.trigger) annotation (Line(points={{-60,90},{-60,
          118.2},{-70,118.2}}, color={255,0,255}));
  connect(tabSlab.y, zeroOrderHold.u) annotation (Line(points={{-166.1,43},
          {-166.1,-44},{102,-44},{102,8}}, color={0,0,127}));
  connect(TFor, triSam.u)
    annotation (Line(points={{-202,130},{-82,130}}, color={0,0,127}));
  connect(zeroOrderHold.y, TSlaSetPer) annotation (Line(points={{125,8},{154,8},
          {154,50},{200,50}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This determines the slab temperature setpoint for a perimeter zone from the forecast high OAT.
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
        Line(points={{-80,-70},{-40,-70},{31,38}}),
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="duration=%duration"),
        Line(points={{31,38},{86,38}}),
       Text(
          extent={{-72,78},{102,6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        textString="Sp"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-180,-100},{180,180}})));
end SlabSetPerim;
