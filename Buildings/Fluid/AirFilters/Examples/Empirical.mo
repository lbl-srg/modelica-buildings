within Buildings.Fluid.AirFilters.Examples;
model Empirical "Example for using the empirical air filter model"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"}) "Air";
  Buildings.Fluid.AirFilters.Empirical fil(
    redeclare package Medium = Medium,
    mCon_nominal=10,
    epsFun={0.98,-0.5},
    b=1.2,
    m_flow_nominal=1,
    dp_nominal(displayUnit="Pa") = 100)
    "Air filter"
    annotation (Placement(transformation(extent={{4,-10},{24,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_C_in=true,
    p(displayUnit="Pa") = 101325 + 100,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(
    extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    nPorts=1)
    "Air sink"
    annotation (Placement(transformation(
    extent={{92,-10},{72,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort C_in(
    redeclare package Medium = Medium, m_flow_nominal=1)
    "Trace substance sensor of inlet air"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse repSig(period=60, shift=30)
    "Filter replacement signal"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Modelica.Blocks.Sources.Ramp C_inflow(
    duration=30,
    height=-0.3,
    offset=1,
    startTime=20)
    "Contaminant mass flow rate fraction"
    annotation (Placement(transformation(extent={{-94,12},{-74,32}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort C_out(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
    "Trace substance sensor of outlet air"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(repSig.y, fil.triRep)
    annotation (Line(points={{-28,50},{-4,50},{-4,6},
    {2,6}}, color={255,0,255}));
  connect(C_inflow.y, sou.C_in[1]) annotation (Line(points={{-73,22},{-68,22},{-68,
          -8},{-62,-8}}, color={0,0,127}));
  connect(C_out.port_b, sin.ports[1])
    annotation (Line(points={{60,0},{72,0}}, color={0,127,255}));
  connect(C_out.port_a, fil.port_b)
    annotation (Line(points={{40,0},{24,0}}, color={0,127,255}));
  connect(C_in.port_b, fil.port_a)
    annotation (Line(points={{-10,0},{4,0}}, color={0,127,255}));
  connect(sou.ports[1], C_in.port_a)
    annotation (Line(points={{-40,0},{-30,0}}, color={0,127,255}));
  annotation (experiment(
      StopTime=50,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/Examples/Empirical.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
From 0 to 12 seconds, the testing case is warming-up and the trace substance of the inlet <code>C_inflow</code> is fixed at <i>1</i>.
</p>
<p>
From 20 to 50 seconds, the <code>C_inflow</code> changes from <i>1</i> to <i>0.7kg/kg</i>.
At the 30 seconds, the filter replacement signal <code>repSig</code> changes from <i>false</i> to <i>true</i>.
</p>
<p>
From 12 to 30 seconds, the trace substance of the outlet port <code>C_out</code> doesn't change much;
From 30 to 45 seconds, C_out first decreases and then increases.
</p>
</html>"));
end Empirical;
