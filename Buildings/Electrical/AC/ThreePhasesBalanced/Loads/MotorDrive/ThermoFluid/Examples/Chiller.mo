within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.ThermoFluid.Examples;
model Chiller "This example shows how to use the chiller with mechanical interface"
  extends Modelica.Icons.Example;
  package MediumW = Buildings.Media.Water;
  parameter Modelica.Units.SI.Torque tau=20
    "Provided torque";
  parameter Modelica.Units.SI.Inertia JLoad=10
    "Load inertia";

  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = MediumW,
    use_T_in=true,
    m_flow=2,
    T=298.15,
    nPorts=1)
    "Source 1"
    annotation (Placement(transformation(extent={{-60,-4},{-40,16}})));
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=0,
    duration=60,
    offset=273.15 + 20,
    startTime=60)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = MediumW,
    use_T_in=true,
    m_flow=1.5,
    T=291.15,
    nPorts=1)
    "Source 2"
    annotation (Placement(transformation(extent={{60,-16},{40,4}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=0,
    duration=60,
    startTime=900,
    offset=273.15 + 15)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.ThermoFluid.Chiller chi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
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
    dp1_nominal=3000,
    dp2_nominal=3000,
    chi(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial))
    "Chiller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Rotational.Sources.ConstantTorque torSou(
    useSupport=false,
    tau_constant=tau)
    "Torque input"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(redeclare package Medium = MediumW,
    nPorts=1)
    "Sink 2"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(redeclare package Medium = MediumW,
    nPorts=1)
    "Sink 1"
    annotation (Placement(transformation(extent={{60,20},{40,40}})));

equation
  connect(TCon_in.y,sou1. T_in) annotation (Line(points={{-79,10},{-62,10}},
          color={0,0,127}, smooth=Smooth.None));
  connect(TEva_in.y,sou2. T_in) annotation (Line(points={{61,-50},{70,-50},
          {70,-2},{62,-2}}, color={0,0,127}, smooth=Smooth.None));
  connect(sou1.ports[1],chi. port_a1) annotation (Line(points={{-40,6},{-10,6}},
          color={0,127,255}));
  connect(chi.port_a2, sou2.ports[1]) annotation (Line(points={{10,-6},{40,-6}},
          color={0,127,255}));
  connect(sin2.ports[1],chi. port_b2) annotation (Line(points={{-40,-30},{-20,-30},
          {-20,-6},{-10,-6}}, color={0,127,255}));
  connect(chi.port_b1, sin1.ports[1]) annotation (Line(points={{10,6},{20,6},
          {20,30},{40,30}}, color={0,127,255}));
  connect(torSou.flange,chi. shaft) annotation (Line(points={{-20,70},{0,70},
          {0,10}}, color={0,0,0}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/ThermoFluid/Examples/Chiller.mos"
        "Simulate and plot"),
        Documentation(info="<html>
<p>
Example that simulates a chiler using the torque as input signal.
</p>
</html>", revisions="<html>
<ul>
<li>
October 15, 2021, by Mingzhe Liu:<br/>
First implementation. 
</li>
</ul>
</html>"));
end Chiller;
