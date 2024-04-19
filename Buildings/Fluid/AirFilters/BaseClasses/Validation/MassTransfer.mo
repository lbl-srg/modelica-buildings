within Buildings.Fluid.AirFilters.BaseClasses.Validation;
model MassTransfer
  "Validation model for the MassTransfer model"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"})
    "Air";
  Buildings.Fluid.Sources.TraceSubstancesFlowSource sou(
    redeclare package Medium = Medium,
    m_flow=1,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium, nPorts=1)
    "Air sink"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Buildings.Fluid.AirFilters.BaseClasses.MassTransfer masTra(
    redeclare package Medium = Medium,
    allowFlowReversal=true,
    m_flow_nominal=1)
    "Mass transfer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp eps(
    duration=20,
    height=-0.7,
    offset=0.9,
    startTime=5)
    "Mass transfer efficiency"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.RealExpression traceSubstancesFlow(
    y=inStream(masTra.port_a.C_outflow[1]))
    "Trace substances flow rate"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort C_out(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
    "Trace substance sensor of outlet air"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort C_in(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
    "Trace substance sensor of inlet air"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(eps.y, masTra.eps)
    annotation (Line(points={{-39,50},{-20,50},{-20,6},{-12,6}},
    color={0,0,127}));
  connect(traceSubstancesFlow.y, masTra.C_inflow[1])
    annotation (Line(points={{-39,80},{0,80},{0,12}}, color={0,0,127}));
  connect(C_out.port_b, sin.ports[1])
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(C_out.port_a, masTra.port_b)
    annotation (Line(points={{20,0},{10,0}}, color={0,127,255}));
  connect(C_in.port_b, masTra.port_a)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  connect(C_in.port_a, sou.ports[1])
    annotation (Line(points={{-50,0},{-60,0}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=30),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/BaseClasses/Validation/MassTransfer.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
From 0 to 5 seconds, the testing case is warming-up and the input mass transfer
efficiency <code>eps</code> is fixed at <i>0.9</i>.
</p>
<p>
From 5 to 25 seconds, the input mass transfer efficiency <code>eps</code> changes
from <i>0.9</i> to <i>0.2</i>. After 25 seconds, the input mass transfer efficiency
<code>eps</code> is fixed at <i>0.2</i>.
</p>
<p>
The trace substance of the outlet port changes from <i>0.1</i> to <i>0.8kg/kg</i>
during the period from 
5 seconds to 30 seconds.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end MassTransfer;
