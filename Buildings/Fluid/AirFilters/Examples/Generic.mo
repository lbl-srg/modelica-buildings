within Buildings.Fluid.AirFilters.Examples;
model Generic
  "Example model for the generic air filter model"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"}) "Medium model";
  Buildings.Fluid.AirFilters.Generic filter(
    redeclare package Medium = Medium,
    mCon_nominal=1,
    epsFun={0.98,-0.1},
    b=1.2,
    m_flow_nominal=1,
    dp_nominal(displayUnit="Pa") = 100)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_C_in=true,
    p(displayUnit="Pa") = 101325 + 100,
    nPorts=1)
    "air source"
    annotation (Placement(transformation(
          extent={{-58,-10},{-38,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    nPorts=1)
    "air sink"
    annotation (Placement(transformation(
          extent={{80,-10},{60,10}})));
  Buildings.Fluid.Sensors.TraceSubstances C_in(
    redeclare package Medium = Medium)
    "Trace substance sensor of inlet air"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Fluid.Sensors.TraceSubstances C_out(
    redeclare package Medium = Medium)
    "Trace substance sensor of outlet air"
    annotation (Placement(transformation(extent={{30,28},{50,48}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse RepSig(
     period=1,
     shift=0.5)
    "filter replacement signal"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Modelica.Blocks.Sources.Ramp mCon_flow(
    duration=1,
    height=1.2,
    offset=0) "contaminant mass flow rate"
    annotation (Placement(transformation(extent={{-96,-30},{-76,-10}})));
equation
  connect(filter.port_b, sin.ports[1])
    annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));
  connect(RepSig.y, filter.triRep) annotation (Line(points={{-28,50},{-20,50},{-20,
          6},{-12,6}}, color={255,0,255}));
  connect(C_in.port, filter.port_a) annotation (Line(points={{-30,-50},{-30,-60},
          {-14,-60},{-14,0},{-10,0}}, color={0,127,255}));
  connect(C_out.port, filter.port_b)
    annotation (Line(points={{40,28},{40,0},{10,0}}, color={0,127,255}));
  connect(sou.ports[1], filter.port_a)
    annotation (Line(points={{-38,0},{-10,0}}, color={0,127,255}));
  connect(mCon_flow.y, sou.C_in[1]) annotation (Line(points={{-75,-20},{-66,-20},
          {-66,-8},{-60,-8}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
        __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/Examples/Generic.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
