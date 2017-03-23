within Buildings.Fluid.Storage.Examples;
model Stratified "Test model for stratified tank"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.ConstantPropertyLiquidWater "Medium model";

  Buildings.Fluid.Storage.Stratified tanSim(
    redeclare package Medium = Medium,
    hTan=3,
    dIns=0.3,
    nSeg=10,
    m_flow_nominal=0.1,
    VTan=3) "Tank"             annotation (Placement(transformation(extent={{-20,0},{0,
            20}}, rotation=0)));
    Modelica.Blocks.Sources.TimeTable TWat(table=[0,273.15 + 40; 3600,273.15 +
        40; 3600,273.15 + 20; 7200,273.15 + 20]) "Water temperature"
                 annotation (Placement(transformation(extent={{-100,2},{-80,22}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    p=300000 + 5000,
    T=273.15 + 50,
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2)             annotation (Placement(transformation(extent={{-60,-2},
            {-40,18}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    use_p_in=true,
    p=300000,
    nPorts=2)             annotation (Placement(transformation(extent={{90,-2},
            {70,18}},rotation=0)));
    FixedResistances.FixedResistanceDpM res_1(
    from_dp=true,
    redeclare package Medium = Medium,
    dp_nominal=5000,
    m_flow_nominal=0.1)
             annotation (Placement(transformation(extent={{36,0},{56,20}},
          rotation=0)));
  Buildings.Fluid.Storage.StratifiedEnhanced tanEnh(
    redeclare package Medium = Medium,
    hTan=3,
    dIns=0.3,
    nSeg=10,
    m_flow_nominal=0.1,
    VTan=3) "Tank"             annotation (Placement(transformation(extent={{-18,-38},
            {2,-18}}, rotation=0)));
    FixedResistances.FixedResistanceDpM res_2(
    from_dp=true,
    redeclare package Medium = Medium,
    dp_nominal=5000,
    m_flow_nominal=0.1)
             annotation (Placement(transformation(extent={{38,-38},{58,-18}},
          rotation=0)));
  Buildings.Fluid.Sensors.EnthalpyFlowRate HOut_flow(redeclare package Medium
      = Medium, m_flow_nominal=0.1) "Enthalpy flow rate"
                                     annotation (Placement(transformation(
          extent={{6,2},{22,18}},  rotation=0)));
  Buildings.Fluid.Sensors.EnthalpyFlowRate HOut_flow1(redeclare package Medium
      = Medium, m_flow_nominal=0.1) "Enthalpy flow rate"
                                     annotation (Placement(transformation(
          extent={{18,-36},{34,-20}},rotation=0)));
  Modelica.Blocks.Continuous.Integrator dH
    "Differenz in enthalpy (should be zero at steady-state)"
    annotation (Placement(transformation(extent={{68,30},{88,50}},   rotation=0)));
  Modelica.Blocks.Math.Add add(k2=-1) annotation (Placement(transformation(
          extent={{32,30},{52,50}},   rotation=0)));
    Modelica.Blocks.Sources.TimeTable P(table=[0,300000; 4200,300000; 4200,
        305000; 7200,305000; 7200,310000; 10800,310000; 10800,305000])
    "Pressure boundary condition"
                 annotation (Placement(transformation(extent={{20,60},{40,80}},
          rotation=0)));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/86400,
    amplitude=10,
    offset=273.15 + 20) annotation (Placement(transformation(extent={{-90,62},{
            -70,82}}, rotation=0)));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCSid2
    "Boundary condition for tank" annotation (Placement(transformation(extent={
            {-40,50},{-28,62}}, rotation=0)));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCSid1
    "Boundary condition for tank" annotation (Placement(transformation(extent={
            {-40,84},{-28,96}}, rotation=0)));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCTop1
    "Boundary condition for tank" annotation (Placement(transformation(extent={
            {-40,66},{-28,78}}, rotation=0)));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCTop2
    "Boundary condition for tank" annotation (Placement(transformation(extent={
            {-40,32},{-28,44}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(TWat.y, sou_1.T_in) annotation (Line(
      points={{-79,12},{-62,12}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(tanSim.port_b, HOut_flow.port_a) annotation (Line(points={{
          5.55112e-16,10},{5.55112e-16,10},{6,10}},
                                     color={0,127,255}));
  connect(HOut_flow.port_b, res_1.port_a)
    annotation (Line(points={{22,10},{30,10},{36,10}},
                                               color={0,127,255}));
  connect(tanEnh.port_b, HOut_flow1.port_a)
    annotation (Line(points={{2,-28},{2,-28},{18,-28}},
                                               color={0,127,255}));
  connect(HOut_flow1.port_b, res_2.port_a) annotation (Line(points={{34,-28},{
          38,-28}}, color={0,127,255}));
  connect(add.y, dH.u)
    annotation (Line(points={{53,40},{66,40}},   color={0,0,127}));
  connect(HOut_flow.H_flow, add.u1) annotation (Line(points={{14,18.8},{14,46},
          {30,46}},  color={0,0,127}));
  connect(HOut_flow1.H_flow, add.u2) annotation (Line(points={{26,-19.2},{26,34},
          {30,34}},       color={0,0,127}));
  connect(P.y, sin_1.p_in) annotation (Line(
      points={{41,70},{100,70},{100,16},{92,16}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(sine.y, TBCSid1.T) annotation (Line(points={{-69,72},{-55.5,72},{
          -55.5,90},{-41.2,90}}, color={0,0,127}));
  connect(sine.y, TBCTop1.T) annotation (Line(points={{-69,72},{-41.2,72}},
        color={0,0,127}));
  connect(sine.y, TBCSid2.T) annotation (Line(points={{-69,72},{-56,72},{-56,56},
          {-41.2,56}}, color={0,0,127}));
  connect(sine.y, TBCTop2.T) annotation (Line(points={{-69,72},{-56,72},{-56,38},
          {-41.2,38}}, color={0,0,127}));
  connect(TBCSid2.port, tanEnh.heaPorSid) annotation (Line(points={{-28,56},{
          -24,56},{-24,-12},{-2,-12},{-2,-28},{-2.4,-28}}, color={191,0,0}));
  connect(TBCTop2.port, tanEnh.heaPorTop) annotation (Line(points={{-28,38},{
          -26,38},{-26,-14},{-6,-14},{-6,-20.6}}, color={191,0,0}));
  connect(sin_1.ports[1], res_1.port_b) annotation (Line(
      points={{70,10},{56,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[2], res_2.port_b) annotation (Line(
      points={{70,6},{64,6},{64,-28},{58,-28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_1.ports[1], tanSim.port_a) annotation (Line(
      points={{-40,10},{-20,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_1.ports[2], tanEnh.port_a) annotation (Line(
      points={{-40,6},{-30,6},{-30,-28},{-18,-28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TBCSid1.port, tanSim.heaPorSid) annotation (Line(
      points={{-28,90},{-4.4,90},{-4.4,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TBCTop1.port, tanSim.heaPorTop) annotation (Line(
      points={{-28,72},{-8,72},{-8,17.4}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})),
experiment(StopTime=10800),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Examples/Stratified.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This test model compares two tank models. The only difference between
the two tank models is that one uses the third order upwind discretization
scheme that reduces numerical diffusion that is induced when connecting 
volumes in series.
</html>"));
end Stratified;
