within Buildings.Fluid.Boilers.Examples;
model BoilerTable
  "Boilers with efficiency described by table"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  parameter Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501 per
    "Record containing a table that describes the efficiency curves"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.Boilers.BoilerTable boi1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    T_start=293.15,
    per=per) "Boiler with transient computation"
    annotation (Placement(transformation(extent={{10,36},{30,56}})));
  Buildings.Fluid.Boilers.BoilerTable boi2(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    T_start=293.15,
    per=per) "Boiler with steady-state computation"
    annotation (Placement(transformation(extent={{10,-44},{30,-24}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 300000,
    T=sou.T,
    nPorts=2) "Sink"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p=300000 + per.dp_nominal,
    use_T_in=true,
    nPorts=2) "Source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TAmb(T=288.15)
    "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Modelica.Blocks.Sources.TimeTable y(table=[0,0; 1800,1; 1800,0; 2400,0; 2400,1;
        6000,1]) "Firing rate"
    annotation (Placement(transformation(extent={{-90,44},{-70,64}})));
  Modelica.Blocks.Sources.TimeTable TIn(table=[0,303.15; 3000,303.15; 4200,293.15;
        4800,293.15; 5400,303.15; 6000,303.15])
        "Inlet temperature"
    annotation (Placement(transformation(extent={{-90,-6},{-70,14}})));

equation
  connect(TAmb.port,boi1. heatPort) annotation (Line(points={{-20,80},{20,80},{20,
          53.2}},               color={191,0,0}));
  connect(y.y,boi1. y) annotation (Line(points={{-69,54},{8,54}},
        color={0,0,127}));
  connect(TIn.y, sou.T_in)
    annotation (Line(points={{-69,4},{-62,4}}, color={0,0,127}));
  connect(y.y,boi2. y) annotation (Line(points={{-69,54},{-10,54},{-10,-26},{8,-26}},
                 color={0,0,127}));
  connect(TAmb.port,boi2. heatPort) annotation (Line(points={{-20,80},{0,80},{0,
          0},{20,0},{20,-26.8}},         color={191,0,0}));
  connect(sou.ports[1],boi1. port_a) annotation (Line(points={{-40,-1},{-20,-1},
          {-20,46},{10,46}},  color={0,127,255}));
  connect(sou.ports[2],boi2. port_a) annotation (Line(points={{-40,1},{-20,1},{
          -20,-34},{10,-34}}, color={0,127,255}));
  connect(boi1.port_b, sin.ports[1]) annotation (Line(points={{30,46},{54,46},{
          54,-1},{60,-1}},    color={0,127,255}));
  connect(boi2.port_b, sin.ports[2]) annotation (Line(points={{30,-34},{54,-34},
          {54,1},{60,1}},     color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Examples/BoilerTable.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=6000),
    Documentation(info="<html>
<p>
Similar to
<a href=\"Buildings.Fluid.Boilers.Examples.BoilerPolynomial\">
Buildings.Fluid.Boilers.Examples.BoilerPolynomial</a>,
this example demonstrates the open loop response of the boiler model
with <code>boi1</code> a dynamic model and
<code>boi2</code> a steady-state model.
In addition to the control signal,
the inlet temperature is also varied.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, 2021, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"));
end BoilerTable;
