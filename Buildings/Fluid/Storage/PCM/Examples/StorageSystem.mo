within Buildings.Fluid.Storage.PCM.Examples;
model StorageSystem "PCM HX for TES implementation"
  replaceable package Medium = Buildings.Media.Water "Medium for water flow";
  parameter Modelica.Units.SI.MassFlowRate mTes_flow_nominal = 1 "Nominal mass flow rate through TES device";
  parameter Modelica.Units.SI.ThermalConductivity k "Thermal conductivity of PCM";
  parameter Modelica.Units.SI.SpecificHeatCapacity c "Specific heat capacity of PCM";
  parameter Modelica.Units.SI.Density d(displayUnit="kg/m3") "Mass density of PCM";
  parameter Modelica.Units.SI.Temperature TSol "Solidus temperature of PCM.";
  parameter Modelica.Units.SI.Temperature TLiq "Liquidus temperature of PCM";
  parameter Modelica.Units.SI.SpecificInternalEnergy LHea "Latent heat of phase change";
  parameter Modelica.Units.SI.Energy TesNominal=TesNominal "Design capacity (factor * 1kWh)";
  Buildings.Fluid.Movers.FlowControlled_m_flow pumTes(
    redeclare package Medium = Medium,
    m_flow_nominal=mTes_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    riseTime=180,
    dp_nominal=0) "TES pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,20})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemTes(
    redeclare package Medium = Medium,
    m_flow_nominal=mTes_flow_nominal)
           "Temperature for leaving water of TES" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-60,20})));
  Modelica.Blocks.Math.Gain gai(k=mTes_flow_nominal)
    "Gain for control signal controlling tes pumps"
    annotation (Placement(transformation(extent={{-62,76},{-54,84}})));
  Modelica.Blocks.Interfaces.RealInput uTes
    "Control signal for tes charging [-1-0] and discharging [0-1]"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valCha(
    redeclare package Medium = Medium,
    m_flow_nominal=mTes_flow_nominal,
    dpValve_nominal=1000,
    dpFixed_nominal=1000) "Valve for charging" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={60,50})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valDis(
    redeclare package Medium = Medium,
    m_flow_nominal=mTes_flow_nominal,
    dpValve_nominal=1000,
    dpFixed_nominal=1000) "Valve for discharge" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={60,-10})));
  Buildings.Fluid.FixedResistances.Junction splTes(
    redeclare package Medium = Medium,
    m_flow_nominal=mTes_flow_nominal*{-1,1,1},
    dp_nominal={0,0,0}) "Flow splitter for tes" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,20})));
  Modelica.Blocks.Logical.GreaterThreshold gre "Greater than zero"
    annotation (Placement(transformation(extent={{-6,80},{6,92}})));
  Modelica.Blocks.Logical.Not not1 "Not" annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={28,50})));
  Modelica.Blocks.Math.BooleanToReal booRea
    annotation (Placement(transformation(extent={{36,46},{44,54}})));
  Modelica.Blocks.Math.BooleanToReal booRea3
    annotation (Placement(transformation(extent={{36,-14},{44,-6}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
        Medium)
    "Fluid connector for charging supply water (typically from supply side of plant)"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium =
        Medium)
    "Fluid connector for discharging supply water (typically from return side of plant)"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    "Fluid connector for return water (typically to return side of plant)"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupCha(
    redeclare package Medium = Medium,
    m_flow_nominal=mTes_flow_nominal)
           "Temperature for supply water to TES from supply port" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={80,80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupDis(
    redeclare package Medium = Medium,
    m_flow_nominal=mTes_flow_nominal)
           "Temperature for supply water to TES from return port" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={80,-40})));
  Modelica.Blocks.Math.Abs absFlo "Absolute value of flow" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,66})));
  Modelica.Blocks.Interfaces.RealOutput TTes "Outlet fluid temperature of TES"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Fluid.Storage.PCM.CoilRegisterFourPort coilRegisterFourPort(
    m1_flow_nominal=mTes_flow_nominal/2,
    m2_flow_nominal=mTes_flow_nominal/2,
    TStart_pcm=TSol,
    Design(TesNominal=TesNominal, PCM(
        k=k,
        c=c,
        d=d,
        TSol=TSol,
        TLiq=TLiq,
        LHea=LHea)),
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.Blocks.Interfaces.RealOutput SOC "state of charge of PCM"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=mTes_flow_nominal, uMin=1e-4*
        mTes_flow_nominal) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,46})));
equation
  connect(valCha.port_b, splTes.port_1)
    annotation (Line(points={{60,40},{60,30}}, color={0,127,255}));
  connect(uTes, gai.u)
    annotation (Line(points={{-110,80},{-62.8,80}},   color={0,0,127}));
  connect(gai.y, gre.u)
    annotation (Line(points={{-53.6,80},{-40,80},{-40,86},{-7.2,86}},
                                                     color={0,0,127}));
  connect(valCha.y, booRea.y)
    annotation (Line(points={{48,50},{44.4,50}}, color={0,0,127}));
  connect(valDis.y, booRea3.y)
    annotation (Line(points={{48,-10},{44.4,-10}}, color={0,0,127}));
  connect(valDis.port_b, splTes.port_2)
    annotation (Line(points={{60,0},{60,10}},    color={0,127,255}));
  connect(pumTes.port_a, splTes.port_3)
    annotation (Line(points={{10,20},{50,20}},
                                             color={0,127,255}));
  connect(senTemTes.port_b, port_b) annotation (Line(points={{-70,20},{-100,20}},
                             color={0,127,255}));
  connect(valCha.port_a, senTemSupCha.port_b)
    annotation (Line(points={{60,60},{60,80},{70,80}}, color={0,127,255}));
  connect(senTemSupCha.port_a, port_a1)
    annotation (Line(points={{90,80},{100,80}}, color={0,127,255}));
  connect(valDis.port_a, senTemSupDis.port_b)
    annotation (Line(points={{60,-20},{60,-40},{70,-40}}, color={0,127,255}));
  connect(senTemSupDis.port_a, port_a2)
    annotation (Line(points={{90,-40},{100,-40}}, color={0,127,255}));
  connect(gai.y, absFlo.u) annotation (Line(points={{-53.6,80},{-40,80},{-40,
          73.2},{1.33227e-15,73.2}},    color={0,0,127}));
  connect(gre.y, not1.u) annotation (Line(points={{6.6,86},{18,86},{18,50},{
          23.2,50}}, color={255,0,255}));
  connect(not1.y, booRea.u)
    annotation (Line(points={{32.4,50},{35.2,50}}, color={255,0,255}));
  connect(gre.y, booRea3.u) annotation (Line(points={{6.6,86},{18,86},{18,-10},
          {35.2,-10}}, color={255,0,255}));
  connect(senTemTes.T, TTes) annotation (Line(points={{-60,9},{-60,-80},{110,
          -80}},               color={0,0,127}));
  connect(pumTes.port_b, coilRegisterFourPort.port_a1) annotation (Line(points={{-10,20},
          {-16,20},{-16,34},{-40,34},{-40,24.2}},         color={0,127,255}));
  connect(pumTes.port_b, coilRegisterFourPort.port_a2) annotation (Line(points={{-10,20},
          {-16,20},{-16,15.8},{-20,15.8}},       color={0,127,255}));
  connect(senTemTes.port_a, coilRegisterFourPort.port_b1) annotation (Line(
        points={{-50,20},{-44,20},{-44,6},{-14,6},{-14,24.2},{-20,24.2}},
                                                                      color={0,
          127,255}));
  connect(coilRegisterFourPort.port_b2, coilRegisterFourPort.port_b1)
    annotation (Line(points={{-40,15.8},{-42,15.8},{-42,16},{-44,16},{-44,6},{
          -14,6},{-14,24.2},{-20,24.2}},
                              color={0,127,255}));
  connect(coilRegisterFourPort.SOC, SOC) annotation (Line(points={{-19,11},{-19,
          -60},{110,-60}},            color={0,0,127}));
  connect(absFlo.y, limiter.u) annotation (Line(points={{-1.11022e-15,59.4},{
          -1.11022e-15,56.1},{1.33227e-15,56.1},{1.33227e-15,53.2}}, color={0,0,
          127}));
  connect(limiter.y, pumTes.m_flow_in) annotation (Line(points={{-1.22125e-15,
          39.4},{-2.22045e-15,35.5},{0,35.5},{0,32}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end StorageSystem;
