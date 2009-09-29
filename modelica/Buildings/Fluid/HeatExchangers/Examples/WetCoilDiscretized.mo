within Buildings.Fluid.HeatExchangers.Examples;
model WetCoilDiscretized
  import Buildings;

  annotation(Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      Commands(file="WetCoilDiscretized.mos" "run"));
 package Medium1 = Buildings.Media.ConstantPropertyLiquidWater;
 //package Medium2 = Buildings.Media.PerfectGases.MoistAir;
 //package Medium2 = Buildings.Media.GasesPTDecoupled.MoistAir;
 package Medium2 = Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid;
 //package Medium2 = Buildings.Media.PerfectGases.MoistAirNonsaturated;
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
    Q_flow_nominal=m1_flow_nominal*4200*(T_b1_nominal-T_a1_nominal),
    dT_nominal=((T_a2_nominal - T_b1_nominal) - (T_b2_nominal - T_a1_nominal))/Modelica.Math.log((T_a2_nominal - T_b1_nominal)/(
        T_b2_nominal - T_a1_nominal)),
    dp2_nominal(displayUnit="Pa") = 200,
    nPipPar=1,
    nPipSeg=3,
    nReg=2,
    dp1_nominal(displayUnit="Pa") = 3000) 
                         annotation (Placement(transformation(extent={{8,-4},{
            28,16}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_2(                       redeclare
      package Medium = Medium2,
    nPorts=1,
    use_p_in=false,
    p=101325,
    T=303.15)             annotation (Placement(transformation(extent={{-58,-10},
            {-38,10}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp PIn(
    duration=60,
    height=-200,
    offset=101725,
    startTime=120) 
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
    Fluid.FixedResistances.FixedResistanceDpM res_2(
    from_dp=true,
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal,
    dp_nominal=200) annotation (Placement(transformation(extent={{-8,-10},{-28,10}},
          rotation=0)));
    Fluid.FixedResistances.FixedResistanceDpM res_1(
    from_dp=true,
    redeclare package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    dp_nominal=2000) 
             annotation (Placement(transformation(extent={{40,30},{60,50}},
          rotation=0)));
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
  connect(res_2.port_a, hex.port_b2) annotation (Line(points={{-8,0},{-8,0},{8,
          0}},                                                 color={0,127,255}));
  connect(TWat.y, sou_1.T_in) 
    annotation (Line(points={{-69,44},{-69,44},{-62,44}},
                                                 color={0,0,127}));
  connect(PSin_1.y, sin_1.p_in) annotation (Line(points={{61,72},{100,72},{100,
          48},{92,48}}, color={0,0,127}));
  connect(sou_1.ports[1], hex.port_a1) annotation (Line(
      points={{-40,40},{8,40},{8,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res_1.port_b, sin_1.ports[1]) annotation (Line(
      points={{60,40},{70,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1], res_2.port_b) annotation (Line(
      points={{-38,0},{-28,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_2.ports[1], hex.port_a2) annotation (Line(
      points={{70,0},{28,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PIn.y, sou_2.p_in) annotation (Line(
      points={{81,-30},{96,-30},{96,8},{92,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b1, res_1.port_a) annotation (Line(
      points={{28,12},{28,40},{40,40}},
      color={0,127,255},
      smooth=Smooth.None));
end WetCoilDiscretized;
