within Buildings.Applications.DHC.Loads.Validation;
model EffectivenessNTU
  "Model that demonstrates use of a heat exchanger without condensation that uses the epsilon-NTU relation"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water;
  package Medium2 = Buildings.Media.Air;
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 2
   "Nominal mass flow rate medium 1";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=
   10
    "Nominal mass flow rate medium 2";
  parameter Modelica.SIunits.Temperature T_a1_nominal = 273.15+45;
  parameter Modelica.SIunits.Temperature T_a2_nominal = 273.15+20;
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 1000
    "Nominal heat flow rate";
  final parameter Modelica.SIunits.Temperature T_b1_nominal=
    T_a1_nominal - Q_flow_nominal / cp1 / m1_flow_nominal;
  Modelica.Blocks.Sources.Ramp T1(
    height=-10,
    duration=60,
    offset=T_a1_nominal,
    startTime=60)
    "Water temperature"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexCou(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dp1_nominal=500,
    dp2_nominal=10,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    Q_flow_nominal=Q_flow_nominal,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    show_T=true,
    T_a1_nominal=T_a1_nominal,
    T_a2_nominal=T_a2_nominal)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Buildings.Applications.DHC.Loads.BaseClasses.EffectivenessNTUUniform heaFloEffCst(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    Q_flow_nominal=Q_flow_nominal,
    T_a1_nominal=T_a1_nominal,
    T_a2_nominal=T_a2_nominal)
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Fluid.Sources.MassFlowSource_T masFloSou1(
    redeclare package Medium = Medium1,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{-62,10},{-42,30}})));
  Fluid.Sources.MassFlowSource_T masFloSou2(
    redeclare package Medium = Medium2,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Fluid.Sources.Boundary_pT sinPri(
    redeclare package Medium = Medium1,
    nPorts=2)
    "Sink for primary stream" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,40})));
  Fluid.Sources.Boundary_pT sinSec(
    redeclare package Medium = Medium2,
    nPorts=1)
    "Sink for secondary stream"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-20})));
    Modelica.Blocks.Sources.Ramp m1_flow(
    height=m1_flow_nominal,
    duration=60,
    offset=0,
    startTime=0) "Water flow rate"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
    Modelica.Blocks.Sources.Ramp m2_flow(
    height=-m2_flow_nominal,
    duration=60,
    offset=m2_flow_nominal,
    startTime=200) "Water flow rate"
    annotation (Placement(transformation(extent={{120,60},{100,80}})));
  Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = Medium1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    Q_flow_nominal=Q_flow_nominal,
    T_a_nominal=T_a1_nominal,
    T_b_nominal=T_b1_nominal,
    TAir_nominal=T_a2_nominal,
    TRad_nominal=T_a2_nominal)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Fluid.Sources.MassFlowSource_T masFloSou3(
    redeclare package Medium = Medium1,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  HeatTransfer.Sources.PrescribedTemperature prescribedTemperature
    annotation (Placement(transformation(extent={{60,70},{40,90}})));
    Modelica.Blocks.Sources.Ramp T2(
    height=10,
    duration=60,
    offset=T_a2_nominal,
    startTime=120) "Air temperature"
    annotation (Placement(transformation(extent={{120,30},{100,50}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp1=
   Medium1.specificHeatCapacityCp(
      Medium1.setState_pTX(Medium1.p_default, Medium1.T_default, Medium1.X_default))
   "Specific heat capacity of medium 2";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2=
   Medium2.specificHeatCapacityCp(
      Medium2.setState_pTX(Medium2.p_default, Medium2.T_default, Medium2.X_default))
   "Specific heat capacity of medium 2";
equation
  connect(T1.y, heaFloEffCst.T_in1) annotation (Line(points={{-99,40},{-90,40},{
          -90,-50},{-12,-50}},   color={0,0,127}));
  connect(masFloSou1.ports[1], hexCou.port_a1)
    annotation (Line(points={{-42,20},{-20,20},{-20,16},{-10,16}},
                                                 color={0,127,255}));
  connect(masFloSou2.ports[1], hexCou.port_a2)
    annotation (Line(points={{40,0},{20,0},{20,4},{10,4}}, color={0,127,255}));
  connect(hexCou.port_b1, sinPri.ports[1])
    annotation (Line(points={{10,16},{20,16},{20,42},{40,42}},
                                               color={0,127,255}));
  connect(sinSec.ports[1], hexCou.port_b2)
    annotation (Line(points={{-40,-20},{-20,-20},{-20,4},{-10,4}},
                                               color={0,127,255}));
  connect(T1.y, masFloSou1.T_in) annotation (Line(points={{-99,40},{-90,40},{-90,
          24},{-64,24}}, color={0,0,127}));
  connect(m1_flow.y, masFloSou1.m_flow_in) annotation (Line(points={{-99,80},{-80,
          80},{-80,28},{-64,28}}, color={0,0,127}));
  connect(m2_flow.y, masFloSou2.m_flow_in) annotation (Line(points={{99,70},{80,
          70},{80,8},{62,8}},   color={0,0,127}));
  connect(m1_flow.y, heaFloEffCst.m1_flow) annotation (Line(points={{-99,80},{-80,
          80},{-80,-46},{-12,-46}}, color={0,0,127}));
  connect(rad.port_b, sinPri.ports[2]) annotation (Line(points={{10,60},{20,60},
          {20,38},{40,38}}, color={0,127,255}));
  connect(masFloSou3.ports[1], rad.port_a)
    annotation (Line(points={{-40,60},{-10,60}}, color={0,127,255}));
  connect(m1_flow.y, masFloSou3.m_flow_in) annotation (Line(points={{-99,80},{-80,
          80},{-80,68},{-62,68}}, color={0,0,127}));
  connect(T1.y, masFloSou3.T_in) annotation (Line(points={{-99,40},{-90,40},{-90,
          64},{-62,64}}, color={0,0,127}));
  connect(prescribedTemperature.port, rad.heatPortRad)
    annotation (Line(points={{40,80},{2,80},{2,67.2}}, color={191,0,0}));
  connect(prescribedTemperature.port, rad.heatPortCon)
    annotation (Line(points={{40,80},{-2,80},{-2,67.2}}, color={191,0,0}));
  connect(T2.y, masFloSou2.T_in)
    annotation (Line(points={{99,40},{90,40},{90,4},{62,4}}, color={0,0,127}));
  connect(T2.y, prescribedTemperature.T) annotation (Line(points={{99,40},{90,40},
          {90,80},{62,80}}, color={0,0,127}));
  connect(T2.y, heaFloEffCst.T_in2) annotation (Line(points={{99,40},{90,40},{90,
          -80},{-20,-80},{-20,-54},{-12,-54}}, color={0,0,127}));
  annotation(experiment(
      StopTime=360,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/Loads/Validation/EffectivenessNTU.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU</a>
for different inlet conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
February 12, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})));
end EffectivenessNTU;
