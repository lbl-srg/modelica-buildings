within Buildings.OpenStudioToModelica.InternalHeatGains;
model FixedTemperatureIHGSchedule
  "This model imposes the temperature in each zone and set the the internal heat gains using a schedule"
  extends Buildings.OpenStudioToModelica.Interfaces.InternalHeatGains;
  parameter Modelica.SIunits.Area AZon "Area of the thermal zone";
  parameter Modelica.SIunits.HeatFlux PLig
    "Lights power per zone per unit area";
  parameter Real nOcc "Number of zone occupants per unit area";
  parameter Modelica.SIunits.Power PPer=120 "Power per person";
  parameter Modelica.SIunits.HeatFlux PPlu "Plug load per zone per unit area";
  parameter Real patternWeekPlug[24]=zeros(24)
    "Pattern for plug loads during week days (fraction of P_nominal)";
  parameter Real patternWeekendPlug[24]=zeros(24)
    "Pattern for plug loads during weekend days (fraction of P_nominal)";
  parameter Real patternWeekOcc[24]=zeros(24)
    "Pattern for occupancy during week days (fraction of nominal occupancy)";
  parameter Real patternWeekendOcc[24]=zeros(24)
    "Pattern for occupancy during weekend days (fraction of nominal occupancy)";
  parameter Real patternWeekLight[24]=zeros(24)
    "Pattern for lights during week days (fraction of P_nominal)";
  parameter Real patternWeekendLight[24]=zeros(24)
    "Pattern for lights during weekend days (fraction of P_nominal)";
  Modelica.Blocks.Sources.Constant zeroIhg(k=0) "Radiant internal heat gain"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Modelica.Blocks.Interfaces.RealInput TZon
    "Prescribed temperature for the thermal zone"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature temZon
    "Source that imposes the temperature in a zone"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow
    "Heating or cooling power needed to maintain the zone temperature"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,-110})));
  Modelica.Blocks.Sources.RealExpression PZone(y=temZon.port.Q_flow)
    "Sensible power needed to control the tempretaure in the zone"
    annotation (Placement(transformation(extent={{40,-90},{80,-70}})));
  Schedules.WeekAndWeekends.Lights lights(
    ATot=AZon,
    PLig=PLig,
    patternWeek=patternWeekLight,
    patternWeekend=patternWeekendLight)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Schedules.WeekAndWeekends.Occupants occupants(
    ATot=AZon,
    nOcc=nOcc,
    PPer=PPer,
    patternWeek=patternWeekOcc,
    patternWeekend=patternWeekendOcc)
    annotation (Placement(transformation(extent={{-60,-26},{-40,-6}})));
  Schedules.WeekAndWeekends.PlugLoads plugLoads(
    ATot=AZon,
    PPlu=PPlu,
    patternWeek=patternWeekPlug,
    patternWeekend=patternWeekendPlug)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Modelica.Blocks.Math.Sum sumIhg(nin=3)
    "Sum of the internal heat gains per unit area"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Modelica.Blocks.Math.Sum sumElLoa(nin=2) "Sum of the electric loads "
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Interfaces.RealOutput PEl
    "Electric power consumed by lights and plug loads in the zone" annotation (
      Placement(transformation(extent={{100,-60},{120,-40}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-110})));
equation

  connect(temZon.port, roomConnector_out.heaPorAir) annotation (Line(points={{0,70},{
          54,70},{54,0.05},{100.05,0.05}},        color={191,0,0}));
  connect(TZon, temZon.T) annotation (Line(points={{-120,0},{-66,0},{-66,70},{-22,
          70}},  color={0,0,127}));
  connect(PZone.y, Q_flow)
    annotation (Line(points={{82,-80},{84,-80},{120,-80}},
                                                  color={0,0,127}));
  connect(zeroIhg.y, roomConnector_out.qGai[1]) annotation (Line(points={{41,20},
          {54,20},{54,0.05},{100.05,0.05}}, color={0,0,127}));
  connect(zeroIhg.y, roomConnector_out.qGai[3]) annotation (Line(points={{41,20},
          {54,20},{54,0.05},{100.05,0.05}}, color={0,0,127}));
  connect(lights.P_m2, sumIhg.u[1]) annotation (Line(points={{-39,-54},{-30,-54},
          {-30,-21.3333},{-22,-21.3333}}, color={0,0,127}));
  connect(occupants.P_m2, sumIhg.u[2])
    annotation (Line(points={{-39,-20},{-30,-20},{-22,-20}}, color={0,0,127}));
  connect(plugLoads.P_m2, sumIhg.u[3]) annotation (Line(points={{-39,6},{-30,6},
          {-30,-18.6667},{-22,-18.6667}}, color={0,0,127}));
  connect(sumIhg.y, roomConnector_out.qGai[2]) annotation (Line(points={{1,-20},
          {54,-20},{54,0.05},{100.05,0.05}}, color={0,0,127}));
  connect(lights.P, sumElLoa.u[2]) annotation (Line(
      points={{-39,-46},{-26,-46},{-26,-49},{18,-49}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(plugLoads.P, sumElLoa.u[1]) annotation (Line(
      points={{-39,14},{-39,14},{-28,14},{-28,-51},{18,-51}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(sumElLoa.y, PEl) annotation (Line(
      points={{41,-50},{110,-50}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-130,90},{110,50}},
          lineColor={0,0,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="T zon"),
    Rectangle(visible=true,
      lineColor={255,255,255},
      fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-78,-88},{34,32}}),
    Line(visible=true,
      points={{-78,-88},{-78,32},{72,32},{72,-88},{-78,-88},{-78,-58},{72,-58},{
              72,-28},{-78,-28},{-78,2},{72,2},{72,32},{34,32},{34,-88}})}),
    Documentation(revisions="<html>
<ul>
<li>
March 23, 2015, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end FixedTemperatureIHGSchedule;
