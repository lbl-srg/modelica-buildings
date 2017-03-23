within Buildings.Fluid.HeatExchangers.Radiators.Examples;
model RadiatorEN442_2 "Test model for radiator"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.ConstantPropertyLiquidWater "Medium model";
 parameter Modelica.SIunits.Temperature TRoo = 20+273.15 "Room temperature"
    annotation (Evaluate=false);
 parameter Modelica.SIunits.Power Q_flow_nominal = 500 "Nominal power";
  parameter Modelica.SIunits.Temperature T_a_nominal=273.15 + 40
    "Radiator inlet temperature at nominal condition"
    annotation (Evaluate=false);
 parameter Modelica.SIunits.Temperature T_b_nominal = 273.15+30
    "Radiator outlet temperature at nominal condition"
    annotation (Evaluate=false);
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    Q_flow_nominal/(T_a_nominal-T_b_nominal)/Medium.cp_const
    "Nominal mass flow rate";
 parameter Modelica.SIunits.Pressure dp_nominal = 3000
    "Pressure drop at m_flow_nominal";

  Buildings.Fluid.Sources.Boundary_pT sou(
    nPorts=2,
    redeclare package Medium = Medium,
    use_p_in=true,
    T=T_a_nominal)
    annotation (Placement(transformation(extent={{-64,-68},{-44,-48}})));
  Fluid.FixedResistances.FixedResistanceDpM res2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal) annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Fluid.FixedResistances.FixedResistanceDpM res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal) annotation (Placement(transformation(extent={{20,-2},{40,18}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=2,
    p(displayUnit="Pa") = 300000,
    T=T_b_nominal) "Sink"
    annotation (Placement(transformation(extent={{90,-68},{70,-48}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad1(redeclare
      package Medium =
               Medium,
    T_a_nominal=T_a_nominal,
    T_b_nominal=T_b_nominal,
    Q_flow_nominal=Q_flow_nominal,
    TAir_nominal=TRoo) "Radiator"
    annotation (Placement(transformation(extent={{-10,-2},{10,18}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad2(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_a_nominal=T_a_nominal,
    T_b_nominal=T_b_nominal,
    Q_flow_nominal=Q_flow_nominal,
    TAir_nominal=TRoo) "Radiator"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TBCCon1(T=TRoo)
    annotation (Placement(transformation(extent={{-32,28},{-20,40}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TBCCon2(T=TRoo)
    annotation (Placement(transformation(extent={{-32,-40},{-20,-28}})));
  Modelica.Blocks.Sources.Step step(
    startTime=3600,
    offset=300000 + dp_nominal,
    height=-dp_nominal)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TBCRad2(T=TRoo)
    annotation (Placement(transformation(extent={{-32,-20},{-20,-8}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TBCRad1(T=TRoo)
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
  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Radiators/Examples/RadiatorEN442_2.mos"
        "Simulate and plot"),
    experiment(StopTime=10800),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
This test model compares the radiator model when 
used as a steady-state and a dynamic model.
</html>"));
end RadiatorEN442_2;
