within Buildings.ChillerWSE.Validation;
model PumpParallel "Example that tests the model pump parallels"

  extends Modelica.Icons.Example;

  package MediumW = Buildings.Media.Water "Medium model";
  parameter Integer nPum=2 "The number of pumps";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=6000/3600*1.2
    "Nominal mass flow rate";

  Buildings.ChillerWSE.SpeedControlledPumpParallel pumPar1(
    nPum=nPum,
    redeclare package Medium = MediumW,
    dpValve_nominal=6000,
    redeclare each Fluid.Movers.Data.Pumps.Wilo.Stratos32slash1to12 per,
    m_flow_nominal=m_flow_nominal) "Pumps with speed controlled"
    annotation (Placement(transformation(extent={{-18,30},{2,50}})));

  Buildings.Fluid.FixedResistances.PressureDrop
                                dp2(
    from_dp=true,
    dp_nominal=50000,
    m_flow_nominal=0.006,
    redeclare package Medium = MediumW)
                      "Pressure drop"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Fluid.FixedResistances.PressureDrop
                                dp1(
    from_dp=true,
    m_flow_nominal=6000/3600*1.2,
    dp_nominal=300,
    redeclare package Medium = MediumW)
                      "Pressure drop"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Fluid.Sources.Boundary_pT           sou(
    use_p_in=false,
    nPorts=2,
    redeclare package Medium = MediumW,
    p=101325,
    T=293.15) "Source"
              annotation (Placement(transformation(extent={{-96,28},{-76,48}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    use_p_in=false,
    nPorts=2,
    redeclare package Medium = MediumW,
    p=101325,
    T=293.15) "Sink"
    annotation (Placement(transformation(extent={{102,30},{82,50}})));
  Modelica.Blocks.Sources.Pulse y[nPum](
    each amplitude=1,
    each width=50,
    each period=120,
    each offset=0,
    each startTime=0)
              "Input signal"
    annotation (Placement(transformation(extent={{-92,70},{-72,90}})));
  MassflowControlledPumpParallel pumPar2(
    nPum=nPum,
    redeclare package Medium = MediumW,
    dpValve_nominal=6000,
    redeclare each Fluid.Movers.Data.Pumps.Wilo.Stratos32slash1to12 per,
    m_flow_nominal=m_flow_nominal) "Pumps with m_flow controlled"
    annotation (Placement(transformation(extent={{-18,-50},{2,-30}})));

  Buildings.Fluid.FixedResistances.PressureDrop
                                dp3(
    from_dp=true,
    m_flow_nominal=6000/3600*1.2,
    dp_nominal=300,
    redeclare package Medium = MediumW)
                      "Pressure drop"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Fluid.FixedResistances.PressureDrop
                                dp4(
    from_dp=true,
    dp_nominal=50000,
    m_flow_nominal=0.006,
    redeclare package Medium = MediumW)
                      "Pressure drop"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = MediumW)
    annotation (Placement(transformation(extent={{54,30},{74,50}})));
  Modelica.Blocks.Math.Gain gain(k=1/nPum)
    annotation (Placement(transformation(extent={{20,-10},{0,10}})));
equation
  connect(dp2.port_a, pumPar1.port_b)
    annotation (Line(points={{20,40},{2,40}}, color={0,127,255}));
  connect(dp1.port_b, pumPar1.port_a)
    annotation (Line(points={{-40,40},{-18,40}}, color={0,127,255}));
  connect(sou.ports[1], dp1.port_a)
    annotation (Line(points={{-76,40},{-68,40},{-60,40}},
                                                       color={0,127,255}));
  connect(y.y, pumPar1.u) annotation (Line(points={{-71,80},{-28,80},{-28,45},{-19,
          45}}, color={0,0,127}));
  connect(dp3.port_a, sou.ports[2]) annotation (Line(points={{-60,-40},{-68,-40},
          {-68,36},{-76,36}}, color={0,127,255}));
  connect(dp3.port_b, pumPar2.port_a) annotation (Line(points={{-40,-40},{-29,-40},
          {-18,-40}}, color={0,127,255}));
  connect(pumPar2.port_b, dp4.port_a)
    annotation (Line(points={{2,-40},{11,-40},{20,-40}}, color={0,127,255}));
  connect(dp4.port_b, sin.ports[1]) annotation (Line(points={{40,-40},{76,-40},{
          76,42},{82,42}}, color={0,127,255}));
  connect(dp2.port_b, senMasFlo.port_a)
    annotation (Line(points={{40,40},{54,40}},
                                             color={0,127,255}));
  connect(senMasFlo.port_b, sin.ports[2])
    annotation (Line(points={{74,40},{82,40},{82,38}},
                                                     color={0,127,255}));

  connect(senMasFlo.m_flow, gain.u) annotation (Line(points={{64,51},{64,60},{46,
          60},{46,0},{22,0}}, color={0,0,127}));
 for i in 1:nPum loop
  connect(gain.y, pumPar2.u[i]) annotation (Line(points={{-1,0},{-28,0},{-28,-35},
          {-19,-35}}, color={0,0,127}));
 end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file="Resources/Scripts/Dymola/ChillerWSE/Validation/PumpParallel.mos"
        "Simulate and Plot"));
end PumpParallel;
