within Buildings.Fluid.Movers.Examples;
model PumpCrossValidation "Comparison between 3 pump types"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Fluid.Movers.FlowMachine_Nrpm pump_Nrpm(redeclare package Medium =
        Medium, redeclare Buildings.Fluid.Movers.Data.Pumps.Stratos30slash1to8
      per,
    filteredSpeed=false)
           annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Fluid.Movers.FlowMachine_dp  pump_dp(
    redeclare package Medium = Medium,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Stratos30slash1to8 per,
    filteredSpeed=false,
    m_flow_nominal=5)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow pump_m_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Stratos30slash1to8 per,
    filteredSpeed=false)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Fluid.Sources.Boundary_pT bou(nPorts=3, redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-102,10},{-82,30}})));
  package Medium = Buildings.Media.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=3
    "Nominal mass flow rate";
  Buildings.Fluid.FixedResistances.FixedResistanceDpM[3] res(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each dp_nominal=40000)
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Fluid.Sources.Boundary_pT sink(
                                          nPorts=3, redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=100,
    startTime=10,
    height=1000,
    offset=2400)
    annotation (Placement(transformation(extent={{22,70},{2,90}})));
  Modelica.Blocks.Sources.RealExpression dpSet(y=pump_Nrpm.port_b.p - pump_Nrpm.port_a.p)
    annotation (Placement(transformation(extent={{82,30},{6,50}})));
  Modelica.Blocks.Sources.RealExpression m_flowSet(y=pump_Nrpm.port_a.m_flow)
    annotation (Placement(transformation(extent={{82,-10},{6,10}})));
  Modelica.Blocks.Routing.Multiplex3 result
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
equation
  connect(bou.ports[1], pump_Nrpm.port_a) annotation (Line(
      points={{-82,22.6667},{-82,60},{-60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_dp.port_a, bou.ports[2]) annotation (Line(
      points={{-60,20},{-82,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_m_flow.port_a, bou.ports[3]) annotation (Line(
      points={{-60,-20},{-82,-20},{-82,17.3333}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_Nrpm.port_b, res[1].port_a) annotation (Line(
      points={{-40,60},{0,60},{0,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_dp.port_b, res[2].port_a) annotation (Line(
      points={{-40,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_m_flow.port_b, res[3].port_a) annotation (Line(
      points={{-40,-20},{0,-20},{0,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sink.ports[1:3], res.port_b) annotation (Line(
      points={{80,17.3333},{60,17.3333},{60,20},{40,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ramp.y, pump_Nrpm.Nrpm) annotation (Line(
      points={{1,80},{-50,80},{-50,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flowSet.y, pump_m_flow.m_flow_in) annotation (Line(
      points={{2.2,0},{-50.2,0},{-50.2,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(result.u1[1], pump_Nrpm.P) annotation (Line(
      points={{18,-43},{-30,-43},{-30,68},{-39,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(result.u2[1], pump_dp.P) annotation (Line(
      points={{18,-50},{-30,-50},{-30,28},{-39,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(result.u3[1], pump_m_flow.P) annotation (Line(
      points={{18,-57},{-30,-57},{-30,-12},{-39,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dpSet.y, pump_dp.dp_in) annotation (Line(
      points={{2.2,40},{-50.2,40},{-50.2,32}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=200),
    __Dymola_experimentSetupOutput);
end PumpCrossValidation;
