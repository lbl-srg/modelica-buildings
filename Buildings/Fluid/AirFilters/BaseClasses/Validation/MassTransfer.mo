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
    "air source"
    annotation (Placement(transformation(
          extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1)
    "air sink"
    annotation (Placement(transformation(
          extent={{82,-10},{62,10}})));
  Buildings.Fluid.AirFilters.BaseClasses.MassTransfer masTra(
    redeclare package Medium = Medium,
    allowFlowReversal=true,
    m_flow_nominal=1) "mass transfer"
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
   Modelica.Blocks.Sources.Ramp eps(
    duration=1,
    height=-0.7,
    offset=1)
    "mass transfer efficiency"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.RealExpression traceSubstancesFlow(
    y=inStream(masTra.port_a.C_outflow[1]))
    "trace substances flow rate"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Fluid.Sensors.TraceSubstances C_out(redeclare package Medium = Medium)
    "trace substance sensor of outlet air"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Buildings.Fluid.Sensors.TraceSubstances C_in(redeclare package Medium = Medium)
    "trace substance sensor of inlet air"
    annotation (Placement(transformation(extent={{-38,-40},{-18,-20}})));
equation
  connect(eps.y, masTra.eps) annotation (Line(points={{-39,50},{-24,50},{-24,6},
          {6,6}}, color={0,0,127}));
  connect(traceSubstancesFlow.y, masTra.m_flow_in[1])
    annotation (Line(points={{1,60},{18,60},{18,12}}, color={0,0,127}));
  connect(C_out.port, masTra.port_b)
    annotation (Line(points={{40,10},{40,0},{28,0}}, color={0,127,255}));
  connect(C_in.port, masTra.port_a) annotation (Line(points={{-28,-40},{-28,-50},
          {0,-50},{0,0},{8,0}}, color={0,127,255}));
  connect(sin.ports[1], masTra.port_b)
    annotation (Line(points={{62,0},{28,0}}, color={0,127,255}));
  connect(masTra.port_a, sou.ports[1])
    annotation (Line(points={{8,0},{-40,0}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/BaseClasses/MassTransfer.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
The input mass transfer efficiency <code>eps</code> changes from <i>1</i> to <i>0.3</i> from 0 to 1 second;
The trace substance concentration of the inlet port is fixed as <i>1</i>.
</p>
<p>
The trace substance concentration of the outlet port is <i>0</i> at the 0 second when the <code>eps</code> is 1, 
meaning all the trace substance has been removed.
As the <code>eps</code> decreases, the trace substance concentration of the outlet port increases to <i>0.7</i>. 
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
