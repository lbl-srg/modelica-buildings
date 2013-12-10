within Buildings.Fluid.HeatExchangers.Examples;
model WetCoilDiscretized
  "Model that demonstrates use of a finite volume model of a heat exchanger with condensation"
  extends Modelica.Icons.Example;

  package Medium1 = Buildings.Media.ConstantPropertyLiquidWater;
  package Medium2 = Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated;
  parameter Modelica.SIunits.Temperature T_a1_nominal = 5+273.15;
  parameter Modelica.SIunits.Temperature T_b1_nominal = 10+273.15;
  parameter Modelica.SIunits.Temperature T_a2_nominal = 30+273.15;
  parameter Modelica.SIunits.Temperature T_b2_nominal = 10+273.15;
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 5
    "Nominal mass flow rate medium 1";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = m1_flow_nominal*4200/1000*(T_a1_nominal-T_b1_nominal)/(T_b2_nominal-T_a2_nominal)
    "Nominal mass flow rate medium 2";

  Buildings.Fluid.HeatExchangers.WetCoilDiscretized hex(
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
    show_T=true)         annotation (Placement(transformation(extent={{8,-4},{
            28,16}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_2(                       redeclare
      package Medium = Medium2,
    use_p_in=false,
    p=101325,
    T=303.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-58,-10},
            {-38,10}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp PIn(
    duration=60,
    height=-200,
    startTime=120,
    offset=101525)
                 annotation (Placement(transformation(extent={{60,-40},{80,-20}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_2(                       redeclare
      package Medium = Medium2,
    use_p_in=true,
    nPorts=1,
    use_T_in=false,
    T=293.15)             annotation (Placement(transformation(extent={{90,-10},
            {70,10}},  rotation=0)));
    Modelica.Blocks.Sources.Ramp TWat(
    duration=60,
    height=15,
    offset=273.15 + 5,
    startTime=120) "Water temperature"
                 annotation (Placement(transformation(extent={{-90,34},{-70,54}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_1(                       redeclare
      package Medium = Medium1,
    p=300000,
    T=293.15,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{90,30},
            {70,50}},rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    p=300000 + 5000,
    use_T_in=true,
    T=293.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-60,30},
            {-40,50}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp PSin_1(
    duration=60,
    height=5000,
    startTime=240,
    offset=300000)
                 annotation (Placement(transformation(extent={{40,62},{60,82}},
          rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(TWat.y, sou_1.T_in)
    annotation (Line(points={{-69,44},{-69,44},{-62,44}},
                                                 color={0,0,127}));
  connect(PSin_1.y, sin_1.p_in) annotation (Line(points={{61,72},{100,72},{100,
          48},{92,48}}, color={0,0,127}));
  connect(sou_1.ports[1], hex.port_a1) annotation (Line(
      points={{-40,40},{8,40},{8,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_2.ports[1], hex.port_a2) annotation (Line(
      points={{70,6.66134e-16},{59.5,6.66134e-16},{59.5,1.22125e-15},{49,
          1.22125e-15},{49,5.55112e-16},{28,5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PIn.y, sou_2.p_in) annotation (Line(
      points={{81,-30},{96,-30},{96,8},{92,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b1, sin_1.ports[1]) annotation (Line(
      points={{28,12},{50,12},{50,40},{70,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b2, sin_2.ports[1]) annotation (Line(
      points={{8,5.55112e-16},{-16,5.55112e-16},{-16,6.66134e-16},{-38,
          6.66134e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                     graphics),
experiment(StopTime=360),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/WetCoilDiscretized.mos"
        "Simulate and plot"));
end WetCoilDiscretized;
