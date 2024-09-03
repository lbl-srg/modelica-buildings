within Buildings.Fluid.HeatExchangers.Examples.BaseClasses;
partial model WetCoilDiscretized
  "Model that demonstrates use of a finite volume model of a heat exchanger with condensation"

  package Medium1 = Buildings.Media.Water "Medium for water-side";
  replaceable package Medium2 = Modelica.Media.Interfaces.PartialMedium
    "Medium for air-side"
      annotation (choicesAllMatching = true);

  parameter Modelica.Units.SI.Temperature T_a1_nominal=5 + 273.15
    "Water inlet temperature";
  parameter Modelica.Units.SI.Temperature T_b1_nominal=10 + 273.15
    "Water outlet temperature";
  parameter Modelica.Units.SI.Temperature T_a2_nominal=30 + 273.15
    "Air inlet temperature";
  parameter Modelica.Units.SI.Temperature T_b2_nominal=10 + 273.15
    "Air inlet temperature";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=5
    "Nominal mass flow rate water-side";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=m1_flow_nominal*4200
      /1000*(T_a1_nominal - T_b1_nominal)/(T_b2_nominal - T_a2_nominal)
    "Nominal mass flow rate air-side";

  Buildings.Fluid.HeatExchangers.WetCoilDiscretized hexFixIni(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal(displayUnit="Pa") = 200,
    nPipPar=1,
    nPipSeg=3,
    nReg=2,
    dp1_nominal(displayUnit="Pa") = 5000,
    UA_nominal=m1_flow_nominal*4200*(T_a1_nominal - T_b1_nominal)/
        Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1_nominal,
        T_b1_nominal,
        T_a2_nominal,
        T_b2_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true) "Coil with fixed initial conditions"
                                         annotation (Placement(transformation(
          extent={{-10,40},{10,60}})));
  Sources.MassFlowSource_T            sin_2(
    redeclare package Medium = Medium2,
    nPorts=1,
    use_m_flow_in=true,
    T=303.15)             annotation (Placement(transformation(extent={{-50,30},
            {-30,50}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    nPorts=1,
    T=293.15)             annotation (Placement(transformation(extent={{50,30},
            {30,50}})));
    Modelica.Blocks.Sources.Ramp TWat(
    duration=60,
    height=15,
    offset=273.15 + 5,
    startTime=0) "Water temperature"
                 annotation (Placement(transformation(extent={{-100,64},{-80,84}})));
  Sources.MassFlowSource_T            sin_1(
    redeclare package Medium = Medium1,
    nPorts=1,
    use_m_flow_in=true,
    T=293.15)             annotation (Placement(transformation(extent={{50,60},
            {30,80}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    p=300000 + 5000,
    use_T_in=true,
    T=293.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-50,60},
            {-30,80}})));
  Buildings.Fluid.HeatExchangers.WetCoilDiscretized hexSteStaIni(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal(displayUnit="Pa") = 200,
    nPipPar=1,
    nPipSeg=3,
    nReg=2,
    dp1_nominal(displayUnit="Pa") = 5000,
    UA_nominal=m1_flow_nominal*4200*(T_a1_nominal - T_b1_nominal)/
        Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1_nominal,
        T_b1_nominal,
        T_a2_nominal,
        T_b2_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    show_T=true) "Coil with fixed initial conditions"
                                         annotation (Placement(transformation(
          extent={{-10,-20},{10,0}})));
  Sources.MassFlowSource_T            sin_3(
    redeclare package Medium = Medium2,
    nPorts=1,
    use_m_flow_in=true,
    T=303.15)             annotation (Placement(transformation(extent={{-50,-28},
            {-30,-8}})));
  Buildings.Fluid.Sources.Boundary_pT sou_3(
    redeclare package Medium = Medium2,
    nPorts=1,
    T=293.15)             annotation (Placement(transformation(extent={{50,-30},
            {30,-10}})));
  Sources.MassFlowSource_T            sin_4(
    redeclare package Medium = Medium1,
    nPorts=1,
    use_m_flow_in=true,
    T=293.15)             annotation (Placement(transformation(extent={{50,0},{
            30,20}})));
  Buildings.Fluid.Sources.Boundary_pT sou_4(
    redeclare package Medium = Medium1,
    p=300000 + 5000,
    use_T_in=true,
    T=293.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-50,0},
            {-30,20}})));
  Buildings.Fluid.HeatExchangers.WetCoilDiscretized hexSteSta(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal(displayUnit="Pa") = 200,
    nPipPar=1,
    nPipSeg=3,
    nReg=2,
    dp1_nominal(displayUnit="Pa") = 5000,
    UA_nominal=m1_flow_nominal*4200*(T_a1_nominal - T_b1_nominal)/
        Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1_nominal,
        T_b1_nominal,
        T_a2_nominal,
        T_b2_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    show_T=true) "Coil with fixed initial conditions"
                                         annotation (Placement(transformation(
          extent={{-10,-80},{10,-60}})));
  Sources.MassFlowSource_T            sin_5(
    redeclare package Medium = Medium2,
    nPorts=1,
    use_m_flow_in=true,
    T=303.15)             annotation (Placement(transformation(extent={{-50,-86},
            {-30,-66}})));
  Buildings.Fluid.Sources.Boundary_pT sou_5(
    redeclare package Medium = Medium2,
    nPorts=1,
    T=293.15)             annotation (Placement(transformation(extent={{50,-90},
            {30,-70}})));
  Sources.MassFlowSource_T            sin_6(
    redeclare package Medium = Medium1,
    nPorts=1,
    use_m_flow_in=true,
    T=293.15)             annotation (Placement(transformation(extent={{50,-60},
            {30,-40}})));
  Buildings.Fluid.Sources.Boundary_pT sou_6(
    redeclare package Medium = Medium1,
    p=300000 + 5000,
    use_T_in=true,
    T=293.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-50,-60},
            {-30,-40}})));
    Modelica.Blocks.Sources.Ramp m2_flow(
    duration=60,
    startTime=60,
    height=1.1*m2_flow_nominal,
    offset=-m2_flow_nominal) "Air mass flow rate" annotation (Placement(
        transformation(extent={{-100,30},{-80,50}})));
    Modelica.Blocks.Sources.Ramp m1_flow(
    duration=60,
    startTime=180,
    height=1.1*m1_flow_nominal,
    offset=-m1_flow_nominal) "Water mass flow rate" annotation (Placement(
        transformation(extent={{90,68},{70,88}})));
    Modelica.Blocks.Sources.Ramp m1_flow1(
    duration=60,
    startTime=180,
    height=1.1*m1_flow_nominal,
    offset=-m1_flow_nominal) "Water mass flow rate" annotation (Placement(
        transformation(extent={{90,8},{70,28}})));
    Modelica.Blocks.Sources.Ramp m1_flow2(
    duration=60,
    startTime=180,
    height=1.1*m1_flow_nominal,
    offset=-m1_flow_nominal) "Water mass flow rate" annotation (Placement(
        transformation(extent={{90,-52},{70,-32}})));
equation
  connect(TWat.y, sou_1.T_in)
    annotation (Line(points={{-79,74},{-79,74},{-52,74}},
                                                 color={0,0,127}));
  connect(sou_1.ports[1], hexFixIni.port_a1) annotation (Line(
      points={{-30,70},{-20,70},{-20,56},{-10,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_2.ports[1], hexFixIni.port_a2) annotation (Line(
      points={{30,40},{20,40},{20,44},{10,44}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexFixIni.port_b1, sin_1.ports[1]) annotation (Line(
      points={{10,56},{20,56},{20,70},{30,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexFixIni.port_b2, sin_2.ports[1]) annotation (Line(
      points={{-10,44},{-20,44},{-20,40},{-30,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TWat.y,sou_4. T_in)
    annotation (Line(points={{-79,74},{-78,74},{-82,74},{-68,74},{-68,14},{-52,
          14}},                                  color={0,0,127}));
  connect(sou_4.ports[1], hexSteStaIni.port_a1) annotation (Line(
      points={{-30,10},{-20,10},{-20,-4},{-10,-4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_3.ports[1], hexSteStaIni.port_a2) annotation (Line(
      points={{30,-20},{20,-20},{20,-16},{10,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexSteStaIni.port_b1, sin_4.ports[1]) annotation (Line(
      points={{10,-4},{20,-4},{20,10},{30,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TWat.y,sou_6. T_in)
    annotation (Line(points={{-79,74},{-78,74},{-74,74},{-68,74},{-68,-46},{-52,
          -46}},                                 color={0,0,127}));
  connect(sou_6.ports[1], hexSteSta.port_a1) annotation (Line(
      points={{-30,-50},{-20,-50},{-20,-64},{-10,-64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_5.ports[1], hexSteSta.port_a2) annotation (Line(
      points={{30,-80},{20,-80},{20,-76},{10,-76}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexSteSta.port_b1, sin_6.ports[1]) annotation (Line(
      points={{10,-64},{20,-64},{20,-50},{30,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexSteSta.port_b2, sin_5.ports[1]) annotation (Line(
      points={{-10,-76},{-30,-76}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexSteStaIni.port_b2, sin_3.ports[1]) annotation (Line(
      points={{-10,-16},{-20,-16},{-20,-18},{-30,-18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(m2_flow.y, sin_2.m_flow_in) annotation (Line(
      points={{-79,40},{-60,40},{-60,48},{-50,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m2_flow.y, sin_3.m_flow_in) annotation (Line(
      points={{-79,40},{-60,40},{-60,-10},{-50,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m2_flow.y, sin_5.m_flow_in) annotation (Line(
      points={{-79,40},{-60,40},{-60,-68},{-50,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m1_flow.y, sin_1.m_flow_in) annotation (Line(
      points={{69,78},{50,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m1_flow1.y, sin_4.m_flow_in)
    annotation (Line(points={{69,18},{50,18}}, color={0,0,127}));
  connect(m1_flow2.y, sin_6.m_flow_in)
    annotation (Line(points={{69,-42},{50,-42},{50,-42}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This is the base model that is used to test the initialization of the coil model.
There are three instances of the coil model, each having different settings
for the initial conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
September 24, 2015 by Michael Wetter:<br/>
Changed the signal s <code>start</code> attributes in <code>SimpleRoom</code> so
that
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Validation.WetCoilDiscretizedInitializationPerfectGases\">
Buildings.Fluid.HeatExchangers.Validation.WetCoilDiscretizedInitializationPerfectGases</a>
translates when using the pedantic mode in Dymola 2016.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">#426</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
June 28, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end WetCoilDiscretized;
