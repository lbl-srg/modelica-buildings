within Buildings.Fluids.HeatExchangers.Examples;
model WetCoilDiscretizedPControl
  import Buildings;

  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{200,200}}), graphics),
                      Commands(file="WetCoilDiscretizedPControl.mos" "run"));
 package Medium1 = Buildings.Media.ConstantPropertyLiquidWater;
 //package Medium2 = Buildings.Media.PerfectGases.MoistAir;
 package Medium2 = Modelica.Media.Air.MoistAir;
 //package Medium2 = Buildings.Media.GasesPTDecoupled.MoistAir;
 // package Medium2 = Buildings.Media.PerfectGases.MoistAirNonsaturated;
 //package Medium2 = Buildings.Media.PerfectGases.MoistAir;

  parameter Modelica.SIunits.Temperature T_a1_nominal = 5+273.15;
  parameter Modelica.SIunits.Temperature T_b1_nominal = 10+273.15;
  parameter Modelica.SIunits.Temperature T_a2_nominal = 30+273.15;
  parameter Modelica.SIunits.Temperature T_b2_nominal = 10+273.15;
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 5
    "Nominal mass flow rate medium 1";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = m1_flow_nominal*4200/1000*(T_a1_nominal-T_b1_nominal)/(T_b2_nominal-T_a2_nominal)
    "Nominal mass flow rate medium 2";

 Modelica_Fluid.Sources.Boundary_pT sin_2(                       redeclare
      package Medium = Medium2,
    nPorts=1,
    use_p_in=false,
    p=101325,
    T=303.15)             annotation (Placement(transformation(extent={{-58,-26},
            {-38,-6}}, rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sou_2(                       redeclare
      package Medium = Medium2,
    nPorts=1,
    use_p_in=false,
    use_T_in=true,
    p(displayUnit="Pa") = 101725,
    T=293.15)             annotation (Placement(transformation(extent={{160,8},
            {140,28}},  rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sin_1(                       redeclare
      package Medium = Medium1,
    p=300000,
    T=293.15,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{160,40},
            {140,60}}, rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    p=300000 + 9000,
    nPorts=1,
    use_T_in=true,
    T=278.15)             annotation (Placement(transformation(extent={{-24,38},
            {-4,58}},  rotation=0)));
    Fluids.FixedResistances.FixedResistanceDpM res_2(
    from_dp=true,
    redeclare package Medium = Medium2,
    dp_nominal=200,
    m_flow_nominal=m2_flow_nominal) 
             annotation (Placement(transformation(extent={{-2,-26},{-22,-6}},
          rotation=0)));
    Fluids.FixedResistances.FixedResistanceDpM res_1(
    from_dp=true,
    redeclare package Medium = Medium1,
    dp_nominal=2000,
    m_flow_nominal=m1_flow_nominal) 
             annotation (Placement(transformation(extent={{100,40},{120,60}},
          rotation=0)));
    Modelica.Blocks.Sources.Ramp PSin(
    duration=60,
    height=5000,
    startTime=240,
    offset=300000) 
                 annotation (Placement(transformation(extent={{140,80},{160,100}},
          rotation=0)));
  Modelica_Fluid.Sensors.TemperatureTwoPort temSen(redeclare package Medium = 
        Medium2) annotation (Placement(transformation(extent={{40,-26},{20,-6}},
          rotation=0)));
  Buildings.Fluids.Actuators.Valves.TwoWayLinear val(
    redeclare package Medium = Medium1,
    l=0.005,
    Kv_SI=m1_flow_nominal/sqrt(5000),
    m_flow_nominal=m1_flow_nominal) 
             annotation (Placement(transformation(extent={{18,38},{38,58}},
          rotation=0)));
  Modelica.Blocks.Math.Gain P(k=-10)  annotation (Placement(transformation(
          extent={{2,120},{22,140}},    rotation=0)));
  Modelica.Blocks.Math.Feedback fedBac(u1(displayUnit="degC"), u2(displayUnit="degC")) 
                                       annotation (Placement(transformation(
          extent={{-38,120},{-18,140}}, rotation=0)));
  Modelica.Blocks.Sources.TimeTable TSet(table=[0,293.15; 600,293.15; 600,
        288.15; 1200,288.15; 1800,288.15; 2400,295.15; 2400,295.15])
    "Setpoint temperature" 
    annotation (Placement(transformation(extent={{-80,120},{-60,140}}, rotation=
           0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMin=0) 
    annotation (Placement(transformation(extent={{40,120},{60,140}},rotation=0)));
  Buildings.Fluids.HeatExchangers.WetCoilDiscretized hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    nPipPar=1,
    nPipSeg=3,
    nReg=4,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    Q_flow_nominal=m1_flow_nominal*4200*(T_b1_nominal-T_a1_nominal),
    dT_nominal=((T_a2_nominal - T_b1_nominal) - (T_b2_nominal - T_a1_nominal))/Modelica.Math.log((T_a2_nominal - T_b1_nominal)/(
        T_b2_nominal - T_a1_nominal)),
    dp_nominal_1(displayUnit="Pa") = 2000,
    dp_nominal_2(displayUnit="Pa") = 200) 
                         annotation (Placement(transformation(extent={{60,16},{
            80,36}}, rotation=0)));
  inner Modelica_Fluid.System system 
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Step TSou_2(
    startTime=3000,
    offset=T_a2_nominal,
    height=-3) 
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  Modelica.Blocks.Sources.Step TSou_1(
    startTime=3000,
    height=10,
    offset=T_a1_nominal) 
    annotation (Placement(transformation(extent={{-60,42},{-40,62}})));
equation
  connect(PSin.y, sin_1.p_in)   annotation (Line(points={{161,90},{180,90},{180,
          58},{162,58}}, color={0,0,127}));
  connect(P.u, fedBac.y)  annotation (Line(points={{0,130},{-19,130}},   color=
          {0,0,127}));
  connect(temSen.T, fedBac.u2)      annotation (Line(points={{30,-5},{30,10},{
          -80,10},{-80,100},{-28,100},{-28,122}},
                                color={0,0,127}));
  connect(P.y, limiter.u) 
    annotation (Line(points={{23,130},{38,130}},  color={0,0,127}));
  connect(hex.port_b1, res_1.port_a) 
    annotation (Line(points={{80,32},{86,32},{86,50},{100,50}},
                                               color={0,127,255}));
  connect(sin_2.ports[1], res_2.port_b) annotation (Line(
      points={{-38,-16},{-22,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[1], res_1.port_b) annotation (Line(
      points={{140,50},{120,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_2.ports[1], hex.port_a2) annotation (Line(
      points={{140,18},{140,20},{80,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b2, temSen.port_a)      annotation (Line(
      points={{60,20},{48,20},{48,-16},{40,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSen.port_b, res_2.port_a)      annotation (Line(
      points={{20,-16},{-2,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val.port_b, hex.port_a1) annotation (Line(
      points={{38,48},{42,48},{42,32},{60,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSet.y, fedBac.u1) annotation (Line(
      points={{-59,130},{-36,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou_1.ports[1], val.port_a) annotation (Line(
      points={{-4,48},{18,48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSou_2.y, sou_2.T_in) annotation (Line(
      points={{161,-30},{178,-30},{178,22},{162,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSou_1.y, sou_1.T_in) annotation (Line(
      points={{-39,52},{-26,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limiter.y, val.y) annotation (Line(
      points={{61,130},{80,130},{80,80},{28,80},{28,56}},
      color={0,0,127},
      smooth=Smooth.None));
end WetCoilDiscretizedPControl;
