within Buildings.Fluid.Movers.Examples;
model MoverStages "Example model of mover using stages"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=2
    "Nominal mass flow rate";

  FlowControlled_m_flow pump_m_flow(
    redeclare package Medium = Medium,
    dynamicBalance=false,
    inputType=Buildings.Fluid.Types.InputType.Stages,
    m_flow_nominal=m_flow_nominal,
    filteredSpeed=false,
    normalizedMassFlowRates={0,0.5,1})
    "Pump with stages input for mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=4) "Pressure source"
              annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium,
      nPorts=4) "Pressure sink"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.IntegerTable integerTable(table=[0,1; 0.3,2; 0.6,3])
    "Integer step input, 1 is off, 2 is on"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  SpeedControlled_y pump_y(
    redeclare package Medium = Medium,
    inputType=Buildings.Fluid.Types.InputType.Stages,
    normalized_speeds={0,0.5,1},
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4 per,
    dynamicBalance=false,
    filteredSpeed=false) "Pump with stages input for normalised speed"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  FlowControlled_dp pump_dp(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Stages,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4 per,
    dynamicBalance=false,
    filteredSpeed=false,
    normalizedHeads={0,0.5,1},
    dp_nominal=dp_nominal) "Pump with stages input for pressure head"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{26,-90},{46,-70}})));
  SpeedControlled_Nrpm pump_Nrpm(
    redeclare package Medium = Medium,
    dynamicBalance=false,
    inputType=Buildings.Fluid.Types.InputType.Stages,
    filteredSpeed=false,
    speeds={0,1000,2000},
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4 per)
    "Pump with stages input for speed"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  parameter Modelica.SIunits.Pressure dp_nominal=10000 "Nominal pressure raise";
equation
  connect(sou.ports[1], pump_m_flow.port_a) annotation (Line(
      points={{-60,3},{-60,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_m_flow.port_b, sin.ports[1]) annotation (Line(
      points={{10,0},{60,0},{60,3}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(integerTable.y, pump_m_flow.stage) annotation (Line(
      points={{-39,80},{0,80},{0,12}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(res.port_a, pump_dp.port_b)
    annotation (Line(points={{26,-80},{18,-80},{10,-80}}, color={0,127,255}));
  connect(pump_y.port_b, sin.ports[2])
    annotation (Line(points={{10,-40},{60,-40},{60,1}}, color={0,127,255}));
  connect(res.port_b, sin.ports[3])
    annotation (Line(points={{46,-80},{60,-80},{60,-1}}, color={0,127,255}));
  connect(pump_dp.port_a, sou.ports[2])
    annotation (Line(points={{-10,-80},{-60,-80},{-60,1}}, color={0,127,255}));
  connect(pump_y.port_a, sou.ports[3]) annotation (Line(points={{-10,-40},{-20,
          -40},{-60,-40},{-60,-1}}, color={0,127,255}));
  connect(pump_y.stage, pump_m_flow.stage)
    annotation (Line(points={{0,-28},{0,-8},{0,12}}, color={255,127,0}));
  connect(pump_dp.stage, pump_y.stage)
    annotation (Line(points={{0,-68},{0,-68},{0,-28}}, color={255,127,0}));
  connect(integerTable.y, pump_Nrpm.stage) annotation (Line(points={{-39,80},{
          -40,80},{0,80},{0,52}}, color={255,127,0}));
  connect(sou.ports[4], pump_Nrpm.port_a) annotation (Line(points={{-60,-3},{
          -60,-3},{-60,34},{-60,40},{-10,40}}, color={0,127,255}));
  connect(pump_Nrpm.port_b, sin.ports[4]) annotation (Line(points={{10,40},{24,
          40},{60,40},{60,-3}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}})),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/MoverStages.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
<!-- 
fixme: There also need to be a unit test for 
inputType==Buildings.Fluid.Types.InputType.Constant
and similar tests for Buildings.Fluid.Movers.FlowControlled_dp
-->
This example demonstrates the use of the <code>Integer</code> 
stage connector for a mover model.
Note that integer input <i>1</i> refers to the first stage, whereas
input <i>0</i> switches the mover off.
</p>
</html>", revisions="<html>
<ul>
<li>
April 2, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-06));
end MoverStages;
