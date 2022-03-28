within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.ThermoFluid.Examples;
model HeatPump "This example shows how to use the heat pump with mechanical interface"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water;
  package Medium2 = Buildings.Media.Water;
  parameter Modelica.Units.SI.Torque tau=20
  "Provided torque";
  parameter Modelica.Units.SI.Inertia JLoad=10
  "Load inertia";

  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium1,
    use_T_in=true,
    m_flow=2,
    T=298.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=0,
    duration=60,
    offset=273.15 + 20,
    startTime=60) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium2,
    use_T_in=true,
    m_flow=1.5,
    T=291.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=0,
    duration=60,
    startTime=900,
    offset=273.15 + 15) "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  ThermoFluid.HeatPump Hea(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=2,
    m2_flow_nominal=1.5,
    QEva_flow_nominal=-3*1000,
    QCon_flow_nominal=1000 - (-3*1000),
    dTEva_nominal=-5,
    dTCon_nominal=5,
    P_nominal=1000,
    Nrpm_nominal=1800,
    loaIne=JLoad,
    use_eta_Carnot_nominal=true,
    etaCarnot_nominal=0.5,
    dp1_nominal=1000,
    dp2_nominal=1000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Rotational.Sources.ConstantTorque torSou(useSupport=false,
      tau_constant=tau)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(redeclare package Medium = Medium2,
      nPorts=1)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(redeclare package Medium = Medium1,
      nPorts=1) annotation (Placement(transformation(extent={{60,20},{40,40}})));

equation
  connect(TCon_in.y,sou1. T_in) annotation (Line(
      points={{-79,10},{-70,10},{-70,14},{-62,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEva_in.y,sou2. T_in) annotation (Line(
      points={{61,-50},{70,-50},{70,-6},{62,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou1.ports[1], Hea.port_a1) annotation (Line(points={{-40,10},{-26,10},
          {-26,6},{-10,6}}, color={0,127,255}));
  connect(Hea.port_a2, sou2.ports[1]) annotation (Line(points={{10,-6},{26,-6},
          {26,-10},{40,-10}}, color={0,127,255}));
  connect(Hea.port_b2, sin2.ports[1]) annotation (Line(points={{-10,-6},{-26,-6},
          {-26,-30},{-40,-30}}, color={0,127,255}));
  connect(Hea.port_b1, sin1.ports[1]) annotation (Line(points={{10,6},{26,6},{
          26,30},{40,30}}, color={0,127,255}));
  connect(torSou.flange, Hea.shaft)
    annotation (Line(points={{-60,70},{0,70},{0,10}}, color={0,0,0}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/MotorDrive/ThermoFluid/Examples/HeatPump.mos"
        "Simulate and plot"),
        Documentation(info="<html>
<p>Example that simulates a heat pump using the torque as input signal.</p>
</html>",
revisions="<html>
<ul>
<li>October 15, 2021, by Mingzhe Liu:<br>First implementation. </li>
</ul>
</html>"));
end HeatPump;
