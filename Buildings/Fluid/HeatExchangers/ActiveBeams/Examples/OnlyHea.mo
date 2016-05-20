within Buildings.Fluid.HeatExchangers.ActiveBeams.Examples;
model OnlyHea
  import Buildings;
  extends Modelica.Icons.Example;

  Buildings.Fluid.Sources.FixedBoundary sin_1(redeclare package Medium =
        Buildings.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{100,90},{80,110}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou_3(
    redeclare package Medium = Buildings.Media.Air,
    m_flow=0.0792,
    use_m_flow_in=false,
    T=285.85,
    nPorts=1) annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Buildings.Fluid.Sources.FixedBoundary bou(redeclare package Medium =
        Buildings.Media.Air, nPorts=1)
    annotation (Placement(transformation(extent={{100,-110},{80,-90}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=200)
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaFlo
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 22)
    annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=301.15)
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  Buildings.Controls.Continuous.LimPID conPID(
    yMax=0.094,
    Td=0,
    reverseAction=false,
    Ti=100,
    k=0.1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
         annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));
  Buildings.Fluid.Sources.FixedBoundary sou_1(
    redeclare package Medium = Buildings.Media.Water,
    T=288.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Buildings.Media.Water,
    m_flow_nominal=0.094,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Modelica.Blocks.Math.Gain gain(k=1200)
    annotation (Placement(transformation(extent={{-68,-70},{-48,-50}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTem
    annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  Buildings.Fluid.Sources.FixedBoundary sou_2(
    redeclare package Medium = Buildings.Media.Water,
    nPorts=1,
    T=320.95) annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Fluid.Sources.FixedBoundary sin_2(redeclare package Medium =
        Buildings.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{100,50},{80,70}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/86400,
    amplitude=1,
    phase=-1.5707963267949)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(nPorts=2,
    redeclare package Medium = Buildings.Media.Air,
    m_flow_nominal=0.1,
    V=30,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15)
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Fluid.HeatExchangers.ActiveBeams.ActiveBeamCooHea beaCooHea(
    redeclare package Medium1 = Buildings.Media.Water,
    redeclare package Medium2 = Buildings.Media.Air,
    redeclare
      Buildings.Fluid.HeatExchangers.ActiveBeams.Data.TroxDID632A_nozzleH_lenght6ft_coo
      per_coo,
    redeclare
      Buildings.Fluid.HeatExchangers.ActiveBeams.Data.TroxDID632A_nozzleH_lenght6ft_hea
      per_hea,
    conCoo(hex(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)),
    conHea(hex(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)),
    mWatCoo_flow_nominal=0.094,
    mAir_flow_nominal=0.0792,
    mWatHea_flow_nominal=0.094)
    annotation (Placement(transformation(extent={{30,50},{50,70}})));

equation
  connect(fixedTemperature.port,thermalConductor. port_a)
    annotation (Line(points={{-90,-100},{-60,-100}},         color={191,0,0}));
  connect(gain.y, heaFlo.Q_flow)
    annotation (Line(points={{-47,-60},{-30,-60}}, color={0,0,127}));
  connect(const.y, conPID.u_s)
    annotation (Line(points={{-89,-10},{-72,-10}},
                                                 color={0,0,127}));
  connect(senTem.T, conPID.u_m) annotation (Line(points={{-40,-30},{-50,-30},{-60,
          -30},{-60,-22}}, color={0,0,127}));
  connect(conPID.y, pum.m_flow_in) annotation (Line(points={{-49,-10},{-40,-10},
          {-40,80},{-10.2,80},{-10.2,72}}, color={0,0,127}));
  connect(sou_2.ports[1], pum.port_a)
    annotation (Line(points={{-60,60},{-20,60}}, color={0,127,255}));
  connect(sine.y, gain.u)
    annotation (Line(points={{-89,-60},{-70,-60}}, color={0,0,127}));
  connect(bou.ports[1], vol.ports[1]) annotation (Line(points={{80,-100},{58,-100},
          {58,-70}}, color={0,127,255}));
  connect(thermalConductor.port_b, vol.heatPort) annotation (Line(points={{-40,-100},
          {-2,-100},{40,-100},{40,-60},{50,-60}}, color={191,0,0}));
  connect(heaFlo.port, vol.heatPort)
    annotation (Line(points={{-10,-60},{20,-60},{50,-60}}, color={191,0,0}));
  connect(senTem.port, vol.heatPort) annotation (Line(points={{-20,-30},{40,-30},
          {40,-60},{50,-60}}, color={191,0,0}));
  connect(sou_1.ports[1], beaCooHea.watCoo_a) annotation (Line(points={{-60,100},
          {-20,100},{20,100},{20,66},{30,66}}, color={0,127,255}));
  connect(beaCooHea.watCoo_b, sin_1.ports[1]) annotation (Line(points={{50,66},{
          60,66},{60,100},{80,100}}, color={0,127,255}));
  connect(beaCooHea.watHea_a, pum.port_b)
    annotation (Line(points={{30,60},{16,60},{0,60}}, color={0,127,255}));
  connect(beaCooHea.watHea_b, sin_2.ports[1])
    annotation (Line(points={{50,60},{65,60},{80,60}}, color={0,127,255}));
  connect(beaCooHea.air_a, sou_3.ports[1]) annotation (Line(points={{50,54},{60,
          54},{60,20},{80,20}}, color={0,127,255}));
  connect(beaCooHea.air_b, vol.ports[2]) annotation (Line(points={{30,54},{20,54},
          {20,-80},{62,-80},{62,-70}}, color={0,127,255}));
  connect(beaCooHea.heaPor, vol.heatPort)
    annotation (Line(points={{40,50},{40,-60},{50,-60}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}})),experiment(StopTime=172800),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ActiveBeams/Examples/OnlyHea.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-120,-120},{120,120}})),
     Documentation(info="<html>
<p>
The example tests the implementation of <a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.ActiveBeamCooHea\">
Buildings.Fluid.HeatExchangers.ActiveBeams.ActiveBeamCooHea</a> only in heating mode. An air volume is maintained at a temperature above 22 degree Celsius by a controller regulating the water flow in the active beam. 



 <p>

</html>"));
end OnlyHea;
