within Buildings.Fluids.HeatExchangers.Examples;
model DryCoilDiscretized

  annotation(Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      Commands(file="DryCoilDiscretized.mos" "run"));
 package Medium_1 = Buildings.Media.ConstantPropertyLiquidWater;
 //package Medium_2 = Buildings.Media.PerfectGases.MoistAir;
 //package Medium_2 = Buildings.Media.GasesPTDecoupled.SimpleAir;
 package Medium_2 = Buildings.Media.GasesPTDecoupled.MoistAir;
 //package Medium_2 = Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid;
//package Medium_2 = Buildings.Media.IdealGases.SimpleAir;
  parameter Modelica.SIunits.Temperature T0_a1 = 60+273.15;
  parameter Modelica.SIunits.Temperature T0_b1 = 40+273.15;
  parameter Modelica.SIunits.Temperature T0_a2 =  5+273.15;
  parameter Modelica.SIunits.Temperature T0_b2 = 20+273.15;
  parameter Modelica.SIunits.MassFlowRate m0_flow_1 = 5
    "Nominal mass flow rate medium 1";
  parameter Modelica.SIunits.MassFlowRate m0_flow_2 = m0_flow_1*4200/1000*(T0_a1-T0_b1)/(T0_b2-T0_a2)
    "Nominal mass flow rate medium 2";

  Buildings.Fluids.HeatExchangers.DryCoilDiscretized hex(
    redeclare package Medium_1 = Medium_1,
    redeclare package Medium_2 = Medium_2,
    nPipPar=1,
    nPipSeg=3,
    nReg=2,
    m0_flow_1=m0_flow_1,
    m0_flow_2=m0_flow_2,
    Q0_flow=m0_flow_1*4200*(T0_a1-T0_b1),
    dT0=((T0_a1 - T0_b2) - (T0_b1 - T0_a2))/Modelica.Math.log((T0_a1 - T0_b2)/(T0_b1 - T0_a2)),
    dp0_1=2000,
    dp0_2=200)           annotation (Placement(transformation(extent={{8,-4},{
            28,16}}, rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sin_2(                       redeclare
      package Medium = Medium_2, T=303.15,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{-58,-10},
            {-38,10}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp PIn(
    offset=101525,
    height=-199,
    duration=60,
    startTime=120) 
                 annotation (Placement(transformation(extent={{-20,-50},{0,-30}},
          rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sou_2(                       redeclare
      package Medium = Medium_2,
    use_p_in=true,
    use_T_in=true,
    T=283.15,
    nPorts=1)             annotation (Placement(transformation(extent={{40,-70},
            {60,-50}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp TWat(
    duration=60,
    startTime=60,
    height=5,
    offset=273.15 + 60) "Water temperature" 
                 annotation (Placement(transformation(extent={{-100,44},{-80,64}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant TDb(k=273.15 + 5) "Drybulb temperature" 
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}}, rotation=0)));
    Modelica.Blocks.Sources.Constant POut(k=101325) 
      annotation (Placement(transformation(extent={{-100,-2},{-80,18}},
          rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sin_1(                       redeclare
      package Medium = Medium_1,
    p=300000,
    T=293.15,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{84,2},{
            64,22}}, rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium_1,
    p=300000 + 5000,
    use_T_in=true,
    T=293.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-60,40},
            {-40,60}}, rotation=0)));
    Fluids.FixedResistances.FixedResistanceDpM res_2(
    from_dp=true,
    redeclare package Medium = Medium_2,
    m0_flow=m0_flow_2,
    dp0=200) annotation (Placement(transformation(extent={{-2,-10},{-22,10}},
          rotation=0)));
    Fluids.FixedResistances.FixedResistanceDpM res_1(
    from_dp=true,
    redeclare package Medium = Medium_1,
    m0_flow=m0_flow_1,
    dp0=5000) 
             annotation (Placement(transformation(extent={{34,2},{54,22}},
          rotation=0)));
    Modelica.Blocks.Sources.Ramp PSin_1(
    startTime=240,
    offset=300000,
    height=4990,
    duration=60) annotation (Placement(transformation(extent={{40,60},{60,80}},
          rotation=0)));
  inner Modelica_Fluid.System system 
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(PIn.y,sou_2. p_in) annotation (Line(
      points={{1,-40},{20,-40},{20,-52},{38,-52}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(res_2.port_a, hex.port_b2) annotation (Line(points={{-2,0},{4,0},{8,0}},
                                                               color={0,127,255}));
  connect(hex.port_b1, res_1.port_a) annotation (Line(points={{28,12},{31,12},{
          34,12}},         color={0,127,255}));
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
  connect(sin_2.ports[1], res_2.port_b) annotation (Line(
      points={{-38,0},{-22,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[1], res_1.port_b) annotation (Line(
      points={{64,12},{54,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_2.ports[1], hex.port_a2) annotation (Line(
      points={{60,-60},{70,-60},{70,-20},{36,-20},{36,0},{28,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(POut.y, sin_2.p_in) annotation (Line(
      points={{-79,8},{-60,8}},
      color={0,0,127},
      smooth=Smooth.None));
end DryCoilDiscretized;
