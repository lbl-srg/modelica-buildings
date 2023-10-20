within Buildings.Fluid.Storage.Examples;
model Stratified "Test model for stratified tank"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Water "Medium model";

  Buildings.Fluid.Storage.Stratified tanSim(
    redeclare package Medium = Medium,
    hTan=3,
    dIns=0.3,
    nSeg=10,
    m_flow_nominal=0.1,
    VTan=3) "Tank"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    Modelica.Blocks.Sources.TimeTable TWat(table=[0,273.15 + 40; 3600,273.15 +
        40; 3600,273.15 + 20; 7200,273.15 + 20]) "Water temperature"
                 annotation (Placement(transformation(extent={{-100,2},{-80,22}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    p=300000 + 5000,
    T=273.15 + 50,
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2)             annotation (Placement(transformation(extent={{-60,-2},
            {-40,18}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    use_p_in=true,
    p=300000,
    nPorts=2)             annotation (Placement(transformation(extent={{90,-18},
            {70,2}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_1(
    from_dp=true,
    redeclare package Medium = Medium,
    dp_nominal=5000,
    m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{34,-18},{54,2}})));
  Buildings.Fluid.Storage.StratifiedEnhanced tanEnh(
    redeclare package Medium = Medium,
    hTan=3,
    dIns=0.3,
    nSeg=10,
    m_flow_nominal=0.1,
    VTan=3) "Tank"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_2(
    from_dp=true,
    redeclare package Medium = Medium,
    dp_nominal=5000,
    m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Fluid.Sensors.EnthalpyFlowRate HOut_flow(redeclare package Medium =
        Medium, m_flow_nominal=0.1) "Enthalpy flow rate"
                                     annotation (Placement(transformation(
          extent={{4,-16},{20,0}})));
  Buildings.Fluid.Sensors.EnthalpyFlowRate HOut_flow1(redeclare package Medium =
        Medium, m_flow_nominal=0.1) "Enthalpy flow rate"
                                     annotation (Placement(transformation(
          extent={{20,-88},{36,-72}})));
  Modelica.Blocks.Continuous.Integrator dH
    "Differenz in enthalpy (should be zero at steady-state)"
    annotation (Placement(transformation(extent={{68,30},{88,50}})));
  Modelica.Blocks.Math.Add add(k2=-1) annotation (Placement(transformation(
          extent={{32,30},{52,50}})));
    Modelica.Blocks.Sources.TimeTable P(table=[0,300000; 4200,300000; 4200,
        305000; 7200,305000; 7200,310000; 10800,310000; 10800,305000])
    "Pressure boundary condition"
                 annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Sources.Sine sine(
    f=1/86400,
    amplitude=10,
    offset=273.15 + 20)
    annotation (Placement(transformation(extent={{-90,62},{-70,82}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCSid2
    "Boundary condition for tank" annotation (Placement(transformation(extent={
            {-40,50},{-28,62}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCSid1
    "Boundary condition for tank" annotation (Placement(transformation(extent={
            {-40,84},{-28,96}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCTop1
    "Boundary condition for tank" annotation (Placement(transformation(extent={
            {-40,66},{-28,78}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCTop2
    "Boundary condition for tank" annotation (Placement(transformation(extent={
            {-40,32},{-28,44}})));
equation
  connect(TWat.y, sou_1.T_in) annotation (Line(
      points={{-79,12},{-62,12}},
      color={0,0,127}));
  connect(tanSim.port_b, HOut_flow.port_a) annotation (Line(points={{-10,0},{
          -10,-8},{4,-8}},           color={0,127,255}));
  connect(HOut_flow.port_b, res_1.port_a)
    annotation (Line(points={{20,-8},{34,-8}}, color={0,127,255}));
  connect(tanEnh.port_b, HOut_flow1.port_a)
    annotation (Line(points={{-10,-70},{-10,-80},{20,-80}},
                                               color={0,127,255}));
  connect(HOut_flow1.port_b, res_2.port_a) annotation (Line(points={{36,-80},{
          40,-80}}, color={0,127,255}));
  connect(add.y, dH.u)
    annotation (Line(points={{53,40},{66,40}},   color={0,0,127}));
  connect(HOut_flow.H_flow, add.u1) annotation (Line(points={{12,0.8},{12,46},{
          30,46}},   color={0,0,127}));
  connect(HOut_flow1.H_flow, add.u2) annotation (Line(points={{28,-71.2},{28,34},
          {30,34}},       color={0,0,127}));
  connect(P.y, sin_1.p_in) annotation (Line(
      points={{41,70},{100,70},{100,0},{92,0}},
      color={0,0,127}));
  connect(sine.y, TBCSid1.T) annotation (Line(points={{-69,72},{-55.5,72},{
          -55.5,90},{-41.2,90}}, color={0,0,127}));
  connect(sine.y, TBCTop1.T) annotation (Line(points={{-69,72},{-41.2,72}},
        color={0,0,127}));
  connect(sine.y, TBCSid2.T) annotation (Line(points={{-69,72},{-56,72},{-56,56},
          {-41.2,56}}, color={0,0,127}));
  connect(sine.y, TBCTop2.T) annotation (Line(points={{-69,72},{-56,72},{-56,38},
          {-41.2,38}}, color={0,0,127}));
  connect(TBCSid2.port, tanEnh.heaPorSid) annotation (Line(points={{-28,56},{
          -24,56},{-24,-12},{-4.4,-12},{-4.4,-60}},        color={191,0,0}));
  connect(TBCTop2.port, tanEnh.heaPorTop) annotation (Line(points={{-28,38},{
          -26,38},{-26,-14},{-8,-14},{-8,-52.6}}, color={191,0,0}));
  connect(sin_1.ports[1], res_1.port_b) annotation (Line(
      points={{70,-9},{64,-9},{64,-8},{54,-8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[2], res_2.port_b) annotation (Line(
      points={{70,-7},{64,-7},{64,-80},{60,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_1.ports[1], tanSim.port_a) annotation (Line(
      points={{-40,7},{-30,7},{-30,20},{-10,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_1.ports[2], tanEnh.port_a) annotation (Line(
      points={{-40,9},{-30,9},{-30,-40},{-10,-40},{-10,-50}},
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
  annotation(experiment(Tolerance=1e-08, StopTime=10800),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Examples/Stratified.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This test model compares two tank models. The only difference between
the two tank models is that one uses the third order upwind discretization
scheme that reduces numerical diffusion that is induced when connecting
volumes in series.
</html>", revisions="<html>
<ul>
<li>
June 7, 2018 by Filip Jorissen:<br/>
Copied model from Buildings and update the model accordingly.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/314\">#314</a>.
</li>
</ul>
</html>"));
end Stratified;
