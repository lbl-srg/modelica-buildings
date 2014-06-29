within Buildings.Fluid.HeatExchangers.Examples.BaseClasses;
partial model WetCoilDiscretized
  "Model that demonstrates use of a finite volume model of a heat exchanger with condensation"

  package Medium1 = Buildings.Media.ConstantPropertyLiquidWater
    "Medium for water-side";
  replaceable package Medium2 = Modelica.Media.Interfaces.PartialMedium
    "Medium for air-side"
      annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.Temperature T_a1_nominal = 5+273.15
    "Water inlet temperature";
  parameter Modelica.SIunits.Temperature T_b1_nominal = 10+273.15
    "Water outlet temperature";
  parameter Modelica.SIunits.Temperature T_a2_nominal = 30+273.15
    "Air inlet temperature";
  parameter Modelica.SIunits.Temperature T_b2_nominal = 10+273.15
    "Air inlet temperature";
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 5
    "Nominal mass flow rate water-side";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=
    m1_flow_nominal*4200/1000*(T_a1_nominal-T_b1_nominal)/(T_b2_nominal-T_a2_nominal)
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
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Coil with fixed initial conditions" annotation (Placement(transformation(
          extent={{-10,40},{10,60}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    use_p_in=false,
    p=101325,
    T=303.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-50,30},
            {-30,50}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp PIn(
    duration=60,
    height=-200,
    startTime=120,
    offset=101525)
                 annotation (Placement(transformation(extent={{90,38},{70,58}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    use_p_in=true,
    nPorts=1,
    use_T_in=false,
    T=293.15)             annotation (Placement(transformation(extent={{50,30},
            {30,50}},  rotation=0)));
    Modelica.Blocks.Sources.Ramp TWat(
    duration=60,
    height=15,
    offset=273.15 + 5,
    startTime=120) "Water temperature"
                 annotation (Placement(transformation(extent={{-92,64},{-72,84}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    p=300000,
    T=293.15,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{50,60},
            {30,80}},rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    p=300000 + 5000,
    use_T_in=true,
    T=293.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-50,60},
            {-30,80}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp PSin_1(
    duration=60,
    height=5000,
    startTime=240,
    offset=300000)
                 annotation (Placement(transformation(extent={{90,68},{70,88}},
          rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
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
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Coil with fixed initial conditions" annotation (Placement(transformation(
          extent={{-10,-20},{10,0}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_3(
    redeclare package Medium = Medium2,
    use_p_in=false,
    p=101325,
    T=303.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-70,-26},
            {-50,-6}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_3(
    redeclare package Medium = Medium2,
    use_p_in=true,
    nPorts=1,
    use_T_in=false,
    T=293.15)             annotation (Placement(transformation(extent={{50,-30},
            {30,-10}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_4(
    redeclare package Medium = Medium1,
    p=300000,
    T=293.15,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{50,0},{
            30,20}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_4(
    redeclare package Medium = Medium1,
    p=300000 + 5000,
    use_T_in=true,
    T=293.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-50,0},
            {-30,20}}, rotation=0)));
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
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Coil with fixed initial conditions" annotation (Placement(transformation(
          extent={{-10,-80},{10,-60}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_5(
    redeclare package Medium = Medium2,
    use_p_in=false,
    p=101325,
    T=303.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-50,-86},
            {-30,-66}},rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_5(
    redeclare package Medium = Medium2,
    use_p_in=true,
    nPorts=1,
    use_T_in=false,
    T=293.15)             annotation (Placement(transformation(extent={{50,-90},
            {30,-70}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_6(
    redeclare package Medium = Medium1,
    p=300000,
    T=293.15,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{50,-60},
            {30,-40}},
                     rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_6(
    redeclare package Medium = Medium1,
    p=300000 + 5000,
    use_T_in=true,
    T=293.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-50,-60},
            {-30,-40}},rotation=0)));
  FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = Medium2,
    m_flow_nominal=0.01,
    dp_nominal=100)
    "Resistance, used to decouple the pressure state from the heat exchanger with the pressure of the fixed boundary"
    annotation (Placement(transformation(extent={{-20,-26},{-40,-6}})));
equation
  connect(TWat.y, sou_1.T_in)
    annotation (Line(points={{-71,74},{-71,74},{-52,74}},
                                                 color={0,0,127}));
  connect(PSin_1.y, sin_1.p_in) annotation (Line(points={{69,78},{69,78},{52,78}},
                        color={0,0,127}));
  connect(sou_1.ports[1], hexFixIni.port_a1) annotation (Line(
      points={{-30,70},{-20,70},{-20,56},{-10,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_2.ports[1], hexFixIni.port_a2) annotation (Line(
      points={{30,40},{20,40},{20,44},{10,44}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PIn.y, sou_2.p_in) annotation (Line(
      points={{69,48},{52,48}},
      color={0,0,127},
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
    annotation (Line(points={{-71,74},{-71,14},{-52,14}},
                                                 color={0,0,127}));
  connect(PSin_1.y,sin_4. p_in) annotation (Line(points={{69,78},{58,78},{58,18},
          {52,18},{52,18}},
                        color={0,0,127}));
  connect(sou_4.ports[1], hexSteStaIni.port_a1) annotation (Line(
      points={{-30,10},{-20,10},{-20,-4},{-10,-4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_3.ports[1], hexSteStaIni.port_a2) annotation (Line(
      points={{30,-20},{20,-20},{20,-16},{10,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PIn.y,sou_3. p_in) annotation (Line(
      points={{69,48},{64,48},{64,-12},{52,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hexSteStaIni.port_b1, sin_4.ports[1]) annotation (Line(
      points={{10,-4},{20,-4},{20,10},{30,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TWat.y,sou_6. T_in)
    annotation (Line(points={{-71,74},{-71,-46},{-52,-46}},
                                                 color={0,0,127}));
  connect(PSin_1.y,sin_6. p_in) annotation (Line(points={{69,78},{58,78},{58,
          -42},{52,-42}},
                        color={0,0,127}));
  connect(sou_6.ports[1], hexSteSta.port_a1) annotation (Line(
      points={{-30,-50},{-20,-50},{-20,-64},{-10,-64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_5.ports[1], hexSteSta.port_a2) annotation (Line(
      points={{30,-80},{20,-80},{20,-76},{10,-76}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PIn.y,sou_5. p_in) annotation (Line(
      points={{69,48},{64,48},{64,-72},{52,-72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hexSteSta.port_b1, sin_6.ports[1]) annotation (Line(
      points={{10,-64},{20,-64},{20,-50},{30,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_a, hexSteStaIni.port_b2) annotation (Line(
      points={{-20,-16},{-10,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, sin_3.ports[1]) annotation (Line(
      points={{-40,-16},{-50,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexSteSta.port_b2, sin_5.ports[1]) annotation (Line(
      points={{-10,-76},{-30,-76}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<p>
This is the base model that is used to test the initialization of the coil model.
There are three instances of the coil model, each having different settings
for the initial conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
June 28, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end WetCoilDiscretized;
