within Buildings.Fluid.Sensors.Examples;
model MoistAirEnthalpyFlowRate
  "Test model for sensible and latent enthalpy flow rate"
  import Buildings;
    annotation (Commands(file="MoistAirEnthalpyFlowRate.mos" "run"), Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics));

  package Medium = Modelica.Media.Air.MoistAir;
  Buildings.Fluid.Sensors.EnthalpyFlowRate senH_flow(redeclare package Medium
      = Medium) "Sensor for enthalpy flow rate" 
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    use_m_flow_in=true,
    redeclare package Medium = Medium,
    nPorts=1,
    X=Medium.X_default,
    T=293.15) 
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin(               redeclare package
      Medium = Medium,
    nPorts=1,
    T=313.15,
    X={0.02,0.98})     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-70})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    height=-2,
    offset=1) 
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics));
  inner Modelica.Fluid.System system 
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort senH(redeclare package Medium
      = Medium) annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Fluid.Sensors.MassFlowRate senM_flow(redeclare package Medium = 
        Medium) annotation (Placement(transformation(extent={{28,10},{48,30}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu1 
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Math.Product product 
    annotation (Placement(transformation(extent={{0,54},{20,74}})));
  Buildings.Fluid.Sensors.LatentEnthalpyFlowRate senHLat_flow(redeclare package
      Medium =         Medium) "Sensor for latent enthalpy flow rate" 
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate senHSen_flow(redeclare
      package Medium = Medium) "Sensor for sensible enthalpy flow rate" 
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Modelica.Blocks.Math.Add add1 
    annotation (Placement(transformation(extent={{20,-46},{40,-26}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu2 
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
equation
  connect(ramp.y, sou.m_flow_in) annotation (Line(
      points={{-79,70},{-70,70},{-70,28},{-60,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], senH_flow.port_a) annotation (Line(
      points={{-40,20},{-30,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senH_flow.port_b, senH.port_a) annotation (Line(
      points={{-10,20},{0,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senH.port_b, senM_flow.port_a) annotation (Line(
      points={{20,20},{28,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senH_flow.H_flow, assEqu1.u1)        annotation (Line(
      points={{-20,31},{-20,94},{28,94},{28,76},{58,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senH.h_out, product.u1) annotation (Line(
      points={{10,31},{10,40},{-14,40},{-14,70},{-2,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senM_flow.m_flow, product.u2) annotation (Line(
      points={{38,31},{38,48},{-10,48},{-10,58},{-2,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, assEqu1.u2)        annotation (Line(
      points={{21,64},{58,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senHLat_flow.H_flow, add1.u1)               annotation (Line(
      points={{-50,-59},{-50,-30},{18,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senHSen_flow.H_flow, add1.u2)                 annotation (Line(
      points={{-10,-59},{-10,-42},{18,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senM_flow.port_b, senHLat_flow.port_a)           annotation (Line(
      points={{48,20},{60,20},{60,0},{-70,0},{-70,-70},{-60,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senHLat_flow.port_b, senHSen_flow.port_a) 
    annotation (Line(
      points={{-40,-70},{-20,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senH_flow.H_flow, assEqu2.u1) annotation (Line(
      points={{-20,31},{-20,36},{70,36},{70,-24},{78,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add1.y, assEqu2.u2) annotation (Line(
      points={{41,-36},{78,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senHSen_flow.port_b, sin.ports[1]) annotation (Line(
      points={{0,-70},{60,-70}},
      color={0,127,255},
      smooth=Smooth.None));
end MoistAirEnthalpyFlowRate;
