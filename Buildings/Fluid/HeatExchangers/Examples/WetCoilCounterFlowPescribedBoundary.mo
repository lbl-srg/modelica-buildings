within Buildings.Fluid.HeatExchangers.Examples;
model WetCoilCounterFlowPescribedBoundary
  "Model that tests a heat exchanger with prescribed boundary conditions, in terms of properties of inlet water and inlet air"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water
   "Medium model for water";
  package Medium2 = Buildings.Media.Air
   "Medium model for air";
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource(
      "modelica://Buildings//Resources/Data/Fluid/HeatExchangers/Examples/WetCoilCounterFlowPescribedBoundary.dat"),
    columns=2:6,
    tableName="WetCoilCounterFlow")
    "Reader for boundary conditions"
    annotation(Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow
    hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=447.32114,
    m2_flow_nominal=658.44,
    dp2_nominal(displayUnit="Pa") = 200,
    dp1_nominal(displayUnit="Pa") = 3000,
    UA_nominal=1161730,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooling coil"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou_w(
    use_T_in=true,
    nPorts=1,
    redeclare package Medium = Medium1,
    use_m_flow_in=true)
    "Source for water"
    annotation (Placement(transformation(extent={{-58,10},{-38,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin_w(
    redeclare package Medium = Medium1,
    use_p_in=false,
    T=293.15,
    nPorts=1)
    "sink for water"
    annotation (Placement(transformation(extent={{66,16},{46,36}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou_a(
    use_Xi_in=true,
    use_T_in=true,
    nPorts=1,
    redeclare package Medium = Medium2,
    use_m_flow_in=true)
    "Source for air"
    annotation (Placement(transformation(extent={{68,-54},{48,-34}})));
  Buildings.Fluid.Sources.Boundary_pT sin_a(
    redeclare package Medium = Medium2,
    use_p_in=false,
    T=293.15,
    nPorts=1)
    "sink for air"
    annotation (Placement(transformation(extent={{-62,-52},{-42,-32}})));
equation
  connect(sou_w.ports[1], hex.port_a1) annotation (Line(points={{-38,20},{-20,20},
          {-20,6},{-10,6}}, color={0,127,255}));
  connect(sin_w.ports[1], hex.port_b1) annotation (Line(points={{46,26},{20,26},
          {20,6},{10,6}}, color={0,127,255}));
  connect(sou_a.ports[1], hex.port_a2) annotation (Line(points={{48,-44},{20,-44},
          {20,-6},{10,-6}}, color={0,127,255}));
  connect(sin_a.ports[1], hex.port_b2) annotation (Line(points={{-42,-42},{-20,-42},
          {-20,-6},{-10,-6}}, color={0,127,255}));
  connect(datRea.y[1], sou_a.T_in) annotation (Line(points={{-59,70},{86,70},{86,
          -40},{70,-40}}, color={0,0,127}));
  connect(sou_a.m_flow_in, datRea.y[2]) annotation (Line(points={{70,-36},{80,-36},
          {80,70},{-59,70}}, color={0,0,127}));
  connect(sou_a.Xi_in[1], datRea.y[3]) annotation (Line(points={{70,-48},{94,-48},
          {94,70},{-59,70}}, color={0,0,127}));
  connect(sou_w.T_in, datRea.y[4]) annotation (Line(points={{-60,24},{-80,24},{-80,
          46},{-40,46},{-40,70},{-59,70}}, color={0,0,127}));
  connect(sou_w.m_flow_in, datRea.y[5]) annotation (Line(points={{-60,28},{-74,28},
          {-74,56},{-44,56},{-44,70},{-59,70}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StartTime=8640000,
      StopTime=9849600,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/WetCoilCounterFlowPescribedBoundary.mos"
        "Simulate and plot"));
end WetCoilCounterFlowPescribedBoundary;
