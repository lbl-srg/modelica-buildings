within Buildings.Fluid.HeatExchangers.Examples;
model DryCoilDiscretized
  "Model that demonstrates use of a finite volume model of a heat exchanger without condensation"
  extends Modelica.Icons.Example;

  package Medium1 = Buildings.Media.Water;
  package Medium2 = Buildings.Media.Air;

  parameter Modelica.Units.SI.Temperature T_a1_nominal=60 + 273.15;
  parameter Modelica.Units.SI.Temperature T_b1_nominal=40 + 273.15;
  parameter Modelica.Units.SI.Temperature T_a2_nominal=5 + 273.15;
  parameter Modelica.Units.SI.Temperature T_b2_nominal=20 + 273.15;
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=5
    "Nominal mass flow rate medium 1";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=m1_flow_nominal*4200
      /1000*(T_a1_nominal - T_b1_nominal)/(T_b2_nominal - T_a2_nominal)
    "Nominal mass flow rate medium 2";

  Buildings.Fluid.HeatExchangers.DryCoilDiscretized hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    nPipPar=1,
    nPipSeg=3,
    nReg=2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    UA_nominal=m1_flow_nominal*4200*(T_a1_nominal-T_b1_nominal)/
      Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1_nominal,
        T_b1_nominal,
        T_a2_nominal,
        T_b2_nominal),
    dp2_nominal=200,
    dp1_nominal=5000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp1=true,
    from_dp2=true)             annotation (Placement(transformation(extent={{8,-4},{
            28,16}})));
  Sources.MassFlowSource_T            sin_2(
    redeclare package Medium = Medium2,
    nPorts=1,
    use_m_flow_in=true,
    T=303.15)             annotation (Placement(transformation(extent={{-58,-10},
            {-38,10}})));
    Modelica.Blocks.Sources.Ramp PIn(
    offset=101525,
    height=-199,
    duration=60,
    startTime=120)
                 annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    use_p_in=true,
    use_T_in=true,
    T=283.15,
    nPorts=1)             annotation (Placement(transformation(extent={{40,-70},
            {60,-50}})));
    Modelica.Blocks.Sources.Ramp TWat(
    duration=60,
    startTime=60,
    height=5,
    offset=273.15 + 60) "Water temperature"
                 annotation (Placement(transformation(extent={{-100,44},{-80,64}})));
  Modelica.Blocks.Sources.Constant TDb(k=273.15 + 5) "Drybulb temperature"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    p=300000,
    T=293.15,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{84,2},{
            64,22}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    p=300000 + 5000,
    use_T_in=true,
    T=293.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-60,40},
            {-40,60}})));
    Modelica.Blocks.Sources.Ramp PSin_1(
    startTime=240,
    offset=300000,
    height=4990,
    duration=60) annotation (Placement(transformation(extent={{40,60},{60,80}})));
    Modelica.Blocks.Sources.Ramp m_flow_2(
    duration=60,
    startTime=120,
    height=28 - 0.124,
    offset=-28) "Mass flow rate on air side" annotation (Placement(
        transformation(extent={{-100,-2},{-80,18}})));
equation
  connect(PIn.y,sou_2. p_in) annotation (Line(
      points={{1,-40},{20,-40},{20,-52},{38,-52}},
      color={0,0,127}));
  connect(TDb.y, sou_2.T_in) annotation (Line(points={{1,-80},{20,-80},{20,-56},
          {38,-56}}, color={0,0,127}));
  connect(TWat.y, sou_1.T_in)
    annotation (Line(points={{-79,54},{-70.5,54},{-62,54}},
                                                 color={0,0,127}));
  connect(PSin_1.y, sin_1.p_in) annotation (Line(points={{61,70},{100,70},{100,
          20},{86,20}}, color={0,0,127}));
  connect(sou_1.ports[1], hex.port_a1) annotation (Line(
      points={{-40,50},{-16,50},{-16,12},{8,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_2.ports[1], hex.port_a2) annotation (Line(
      points={{60,-60},{70,-60},{70,-20},{36,-20},{36,5.55112e-16},{28,
          5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1], hex.port_b2) annotation (Line(
      points={{-38,6.66134e-16},{-16,6.66134e-16},{-16,5.55112e-16},{8,
          5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b1, sin_1.ports[1]) annotation (Line(
      points={{28,12},{64,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(m_flow_2.y, sin_2.m_flow_in) annotation (Line(
      points={{-79,8},{-58,8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(experiment(Tolerance=1e-6, StopTime=360),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/DryCoilDiscretized.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
July 3, 2014, by Michael Wetter:<br/>
Changed pressure sink to mass flow rate sink to avoid an overdetermined
by consistent set of initial conditions.
</li>
<li>
March 25, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilDiscretized\">
Buildings.Fluid.HeatExchangers.DryCoilDiscretized</a>
for different inlet conditions.
</p>
</html>"));
end DryCoilDiscretized;
