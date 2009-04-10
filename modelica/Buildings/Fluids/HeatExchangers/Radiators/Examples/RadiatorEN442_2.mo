within Buildings.Fluids.HeatExchangers.Radiators.Examples;
model RadiatorEN442_2 "Test model for radiator"
  import Buildings;
 package Medium = Buildings.Media.ConstantPropertyLiquidWater "Medium model";
  annotation (
          Commands(file=
          "RadiatorEN442_2.mos" "run"),
    experiment(StopTime=3600),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics));
 parameter Modelica.SIunits.Power Q_flow_nominal = 1000 "Nominal power";
 parameter Modelica.SIunits.Temperature dT_nominalWat = 20
    "Nominal temperature difference";
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/dT_nominalWat/Medium.cp_const
    "Nominal mass flow rate";
 parameter Modelica.SIunits.Pressure dp_nominal = 3000
    "Pressure drop at m_flow_nominal";

  Modelica_Fluid.Sources.Boundary_pT sou(
    nPorts=2,
    redeclare package Medium = Medium,
    use_p_in=true,
    T=353.15) 
    annotation (Placement(transformation(extent={{-64,-68},{-44,-48}})));
  Fluids.FixedResistances.FixedResistanceDpM res2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal) annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Fluids.FixedResistances.FixedResistanceDpM res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal) annotation (Placement(transformation(extent={{20,-2},{40,18}})));
  Modelica_Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=2,
    p(displayUnit="Pa") = 300000,
    T=333.15) "Sink" 
    annotation (Placement(transformation(extent={{90,-68},{70,-48}})));
  inner Modelica_Fluid.System system 
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Fluids.HeatExchangers.Radiators.RadiatorEN442_2 rad1(redeclare
      package Medium = 
               Medium, Q_flow_nominal=1000,
    nEle=5,
    m_flow_nominal=m_flow_nominal) "Radiator" 
    annotation (Placement(transformation(extent={{-10,-2},{10,18}})));
  Buildings.Fluids.HeatExchangers.Radiators.RadiatorEN442_2 rad2(
    redeclare package Medium = Medium,
    Q_flow_nominal=1000,
    energyDynamics=Modelica_Fluid.Types.Dynamics.SteadyState,
    nEle=5,
    m_flow_nominal=m_flow_nominal) "Radiator" 
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBCCon1(T=293.15) 
    annotation (Placement(transformation(extent={{-32,28},{-20,40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBCCon2(T=293.15) 
    annotation (Placement(transformation(extent={{-32,-40},{-20,-28}})));
  Modelica.Blocks.Sources.Step step(
    startTime=3600,
    offset=300000 + dp_nominal,
    height=-dp_nominal) 
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBCRad2(T=293.15) 
    annotation (Placement(transformation(extent={{-32,-20},{-20,-8}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBCRad1(T=293.15) 
    annotation (Placement(transformation(extent={{-32,48},{-20,60}})));
equation
  connect(sou.ports[1], rad1.port_a) annotation (Line(
      points={{-44,-56},{-40,-56},{-40,8},{-10,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], rad2.port_a) annotation (Line(
      points={{-44,-60},{-10,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rad1.port_b, res1.port_a) annotation (Line(
      points={{10,8},{20,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rad2.port_b, res2.port_a) annotation (Line(
      points={{10,-60},{20,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, sin.ports[1]) annotation (Line(
      points={{40,8},{56,8},{56,-56},{70,-56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_b, sin.ports[2]) annotation (Line(
      points={{40,-60},{70,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(step.y, sou.p_in) annotation (Line(
      points={{-79,-50},{-66,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TBCRad2.port, rad2.heatPortRad) annotation (Line(
      points={{-20,-14},{2,-14},{2,-52.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TBCRad1.port, rad1.heatPortRad) annotation (Line(
      points={{-20,54},{2,54},{2,15.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TBCCon2.port, rad2.heatPortCon) annotation (Line(
      points={{-20,-34},{-2,-34},{-2,-52.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TBCCon1.port, rad1.heatPortCon) annotation (Line(
      points={{-20,34},{-2,34},{-2,15.2}},
      color={191,0,0},
      smooth=Smooth.None));
end RadiatorEN442_2;
