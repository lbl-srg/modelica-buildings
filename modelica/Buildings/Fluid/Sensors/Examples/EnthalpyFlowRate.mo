within Buildings.Fluid.Sensors.Examples;
model EnthalpyFlowRate "Test model for enthalpy flow rate"
  import Buildings;
    annotation (Commands(file="EnthalpyFlowRate.mos" "run"), Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics));

  package Medium = Modelica.Media.Air.SimpleAir;
  Buildings.Fluid.Sensors.EnthalpyFlowRate senH_flow(redeclare package Medium
      = Medium) "Sensor for enthalpy flow rate" 
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
  Buildings.Fluid.Sources.MassFlowSource_h sou(
    use_m_flow_in=true,
    use_h_in=true,
    redeclare package Medium = Medium,
    nPorts=1) 
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Fluid.Sources.Boundary_ph sin(use_h_in=true, redeclare package
      Medium = Medium,
    nPorts=1)          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-10})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    height=-2,
    offset=1) 
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics));
  Modelica.Blocks.Sources.Constant const(k=10) 
    annotation (Placement(transformation(extent={{-100,-16},{-80,4}})));
  Modelica.Blocks.Sources.Constant const1(k=20) 
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  inner Modelica.Fluid.System system 
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort senH(redeclare package Medium
      = Medium) annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Fluid.Sensors.MassFlowRate senM_flow(redeclare package Medium = 
        Medium) annotation (Placement(transformation(extent={{28,-20},{48,0}})));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality 
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Math.Product product 
    annotation (Placement(transformation(extent={{0,54},{20,74}})));
equation
  connect(ramp.y, sou.m_flow_in) annotation (Line(
      points={{-79,30},{-70,30},{-70,-2},{-60,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, sou.h_in) annotation (Line(
      points={{-79,-6},{-62,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, sin.h_in) annotation (Line(
      points={{81,30},{88,30},{88,-14},{82,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], senH_flow.port_a) annotation (Line(
      points={{-40,-10},{-30,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senH_flow.port_b, senH.port_a) annotation (Line(
      points={{-10,-10},{0,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senH.port_b, senM_flow.port_a) annotation (Line(
      points={{20,-10},{28,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senM_flow.port_b, sin.ports[1]) annotation (Line(
      points={{48,-10},{60,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senH_flow.H_flow, assertEquality.u1) annotation (Line(
      points={{-20,1},{-20,82},{28,82},{28,76},{38,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senH.h_out, product.u1) annotation (Line(
      points={{10,1},{10,28},{-14,28},{-14,70},{-2,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senM_flow.m_flow, product.u2) annotation (Line(
      points={{38,1},{38,36},{-10,36},{-10,58},{-2,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, assertEquality.u2) annotation (Line(
      points={{21,64},{38,64}},
      color={0,0,127},
      smooth=Smooth.None));
end EnthalpyFlowRate;
