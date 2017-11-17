within Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation;
model PumpParallel "Example that tests the model pump parallels"
  extends Modelica.Icons.Example;

  package MediumW = Buildings.Media.Water "Medium model";
  parameter Integer numPum=2 "The number of pumps";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=6000/3600*1.2
    "Nominal mass flow rate";
  parameter Real thr1=1E-4 "Threshold for shutoff valves in parallel 1";
  parameter Real thr2=thr1*m_flow_nominal "Threshold for shutoff valves in parallel 2";

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.FlowMachine_y pumPar1(
    num=numPum,
    redeclare package Medium = MediumW,
    dpValve_nominal=6000,
    redeclare each Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos32slash1to12 per,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    threshold=thr1,
    tau=1,
    use_inputFilter=false)
    "Pumps with speed controlled"
    annotation (Placement(transformation(extent={{-18,30},{2,50}})));

  Buildings.Fluid.FixedResistances.PressureDrop dp2(
    from_dp=true,
    redeclare package Medium = MediumW,
    dp_nominal=3000,
    m_flow_nominal=6000/3600*1.2)
    "Pressure drop"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp1(
    from_dp=true,
    m_flow_nominal=6000/3600*1.2,
    dp_nominal=300,
    redeclare package Medium = MediumW)
    "Pressure drop"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    use_p_in=false,
    nPorts=2,
    redeclare package Medium = MediumW,
    p=101325,
    T=293.15)
    "Source"
    annotation (Placement(transformation(extent={{-96,28},{-76,48}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    use_p_in=false,
    nPorts=2,
    redeclare package Medium = MediumW,
    p=101325,
    T=293.15)
    "Sink"
    annotation (Placement(transformation(extent={{102,30},{82,50}})));
  Modelica.Blocks.Sources.Pulse y[numPum](
    each amplitude=1,
    each width=50,
    each period=120,
    each offset=0,
    each startTime=0)
    "Input signal"
    annotation (Placement(transformation(extent={{-92,70},{-72,90}})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.FlowMachine_m pumPar2(
    num=numPum,
    redeclare package Medium = MediumW,
    dpValve_nominal=6000,
    redeclare each Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos32slash1to12 per,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    threshold=thr2,
    tau=1)
    "Pumps with m_flow controlled"
    annotation (Placement(transformation(extent={{-18,-50},{2,-30}})));

  Buildings.Fluid.FixedResistances.PressureDrop dp3(
    from_dp=true,
    m_flow_nominal=6000/3600*1.2,
    dp_nominal=300,
    redeclare package Medium = MediumW)
    "Pressure drop"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp4(
    from_dp=true,
    redeclare package Medium = MediumW,
    dp_nominal=3000,
    m_flow_nominal=6000/3600*1.2)
    "Pressure drop"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
equation
  connect(dp2.port_a, pumPar1.port_b)
    annotation (Line(points={{20,40},{2,40}}, color={0,127,255}));
  connect(dp1.port_b, pumPar1.port_a)
    annotation (Line(points={{-40,40},{-18,40}}, color={0,127,255}));
  connect(sou.ports[1], dp1.port_a)
    annotation (Line(points={{-76,40},{-68,40},{-60,40}},
                                                       color={0,127,255}));
  connect(y.y, pumPar1.u) annotation (Line(points={{-71,80},{-28,80},{-28,44},{
          -20,44}},
                color={0,0,127}));
  connect(dp3.port_a, sou.ports[2])
    annotation (Line(points={{-60,-40},{-68,-40},
          {-68,36},{-76,36}}, color={0,127,255}));
  connect(dp3.port_b, pumPar2.port_a)
    annotation (Line(points={{-40,-40},{-29,-40},
          {-18,-40}}, color={0,127,255}));
  connect(pumPar2.port_b, dp4.port_a)
    annotation (Line(points={{2,-40},{11,-40},{20,-40}}, color={0,127,255}));
  connect(dp4.port_b, sin.ports[1])
    annotation (Line(points={{40,-40},{76,-40},{76,42},{82,42}},
                           color={0,127,255}));
  connect(y.y, pumPar2.u) annotation (Line(points={{-71,80},{-28,80},{-28,-36},
          {-20,-36}}, color={0,0,127}));
  connect(dp2.port_b, sin.ports[2])
    annotation (Line(points={{40,40},{82,40},{82,38}}, color={0,127,255}));
  annotation (    __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Equipment/Validation/PumpParallel.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates the use of the flow model with two different configurations.
At steady-state, all flow models have the same mass flow rate and pressure difference.
</p>
</html>", revisions="<html>
<ul>
<li>
July 22, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=360,
      Tolerance=1e-06));
end PumpParallel;
