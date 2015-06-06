within Buildings.OpenStudioToModelica.InternalHeatGains;
model FixedTemperatureNoInternalHeatGain
  "This model imposes the temperature in each zone and set the the internal heat gain to zero"
  extends Buildings.OpenStudioToModelica.Interfaces.InternalHeatGains;
  Modelica.Blocks.Sources.Constant zeroIhg(k=0) "Radiant internal heat gain"
    annotation (Placement(transformation(extent={{-10,52},{10,72}})));
  Modelica.Blocks.Interfaces.RealInput TZon
    "Prescribed temperature for the thermal zone"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature temZon
    "Source that imposes the temperature in a zone"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow
    "Heating or cooling power needed to maintain the zone temperature"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={80,-120})));
  Modelica.Blocks.Sources.RealExpression PZone(y=temZon.port.Q_flow)
    "Sensible power needed to control the tempretaure in the zone"
    annotation (Placement(transformation(extent={{0,-90},{40,-70}})));
equation

  connect(temZon.port, roomConnector_out.heaPorAir) annotation (Line(points={{
          10,-20},{54,-20},{54,0.05},{100.05,0.05}}, color={191,0,0}));
  connect(TZon, temZon.T) annotation (Line(points={{-120,0},{-66,0},{-66,-20},{
          -12,-20}}, color={0,0,127}));
  connect(PZone.y, Q_flow)
    annotation (Line(points={{42,-80},{120,-80}}, color={0,0,127}));
  connect(zeroIhg.y, roomConnector_out.qGai[1]) annotation (Line(points={{11,62},
          {54,62},{54,0.05},{100.05,0.05}}, color={0,0,127}));
  connect(zeroIhg.y, roomConnector_out.qGai[2]) annotation (Line(points={{11,62},
          {54,62},{54,0.05},{100.05,0.05}}, color={0,0,127}));
  connect(zeroIhg.y, roomConnector_out.qGai[3]) annotation (Line(points={{11,62},
          {54,62},{54,0.05},{100.05,0.05}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-70,80},{70,22}},
          lineColor={0,0,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="[0,0,0]"),
          Text(
          extent={{-120,-30},{120,-70}},
          lineColor={0,0,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="T zon")}),
    Documentation(revisions="<html>
<ul>
<li>
March 23, 2015, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end FixedTemperatureNoInternalHeatGain;
