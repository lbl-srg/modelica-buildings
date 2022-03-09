within Buildings.Fluid.MixingVolumes;
model MixingVolumeEvaporation
  "Mixing volume for water evaporation at equilibrium"
  extends Buildings.Fluid.Interfaces.PartialWaterPhaseChange;
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium(
    redeclare final package Medium_a=MediumWat,
    redeclare final package Medium_b=MediumSte);

  parameter Modelica.SIunits.Volume V "Total volume";

  MediumSte.Temperature T = MediumSte.temperature_phX(
    p=p, h=bal.hOut, X=MediumSte.X_default)
    "Temperature of the fluid";
  Modelica.SIunits.Pressure p = port_a.p
    "Pressure of the fluid";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort(
    T(start=T_start)) if not steadyDynamics
  annotation (Placement(transformation(extent={{-10,-90},{10,-110}})));
  Modelica.Blocks.Interfaces.RealOutput VLiq(unit="m3") "Liquid volume"
  annotation (Placement(transformation(
        origin={110,70},
        extent={{-10,-10},{10,10}},
        rotation=0), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,70})));

protected
  final parameter Boolean steadyDynamics=
    if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then true
      else false
    "= true, if steady state formulation";

  Buildings.Fluid.Interfaces.ConservationEquationEvaporation bal(
    redeclare package MediumSte = MediumSte,
    redeclare package MediumWat = MediumWat,
    allowFlowReversal=allowFlowReversal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    m_flow_nominal=m_flow_nominal,
    show_T=show_T,
    V=V)
    "Energy and mass balance equations with phase change"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem if not steadyDynamics
    "Port temperature"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.RealExpression portT(y=T) if  not steadyDynamics
    "Port temperature"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen if not steadyDynamics
    "Heat flow sensor"
    annotation (Placement(transformation(extent={{-10,-40},{-30,-60}})));
equation
  if not steadyDynamics then
    connect(portT.y,preTem. T)
      annotation (Line(points={{-69,-50},{-62,-50}},color={0,0,127}));
    connect(heaFloSen.port_b,preTem. port)
      annotation (Line(points={{-30,-50},{-40,-50}},color={191,0,0}));
    connect(heaFloSen.port_a, heatPort)
      annotation (Line(points={{-10,-50},{0,-50},{0,-100}}, color={191,0,0}));
    connect(heaFloSen.Q_flow, bal.Q_flow)
      annotation (Line(points={{-20,-40},{-20,6},{18,6}}, color={0,0,127}));
  end if;
  connect(port_a, bal.port_a)
    annotation (Line(points={{-100,0},{20,0}}, color={0,127,255}));
  connect(bal.port_b, port_b)
    annotation (Line(points={{40,0},{100,0}}, color={0,127,255}));
  connect(bal.VOut,VLiq)
    annotation (Line(points={{32,11},{32,70},{110,70}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-152,102},{148,142}},
          textString="%name",
          lineColor={0,0,255}),
       Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor=DynamicSelect({170,213,255}, min(1, max(0, (1-(T-273.15)/50)))*{28,108,200}+min(1, max(0, (T-273.15)/50))*{255,0,0})),
      Line(
        points={{0,40},{-40,20},{0,-20},{-40,-40}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{40,40},{0,20},{40,-20},{0,-40}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}})}),
    Documentation(revisions="<html>
<ul>
<li>
July 22, 2021 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Mixing volume with water phase change.
</p>
</html>"));
end MixingVolumeEvaporation;
