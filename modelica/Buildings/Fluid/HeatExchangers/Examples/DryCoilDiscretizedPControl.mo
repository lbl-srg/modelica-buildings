within Buildings.Fluid.HeatExchangers.Examples;
model DryCoilDiscretizedPControl
  import Buildings;

  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{200,200}}), graphics),
                      Commands(file="DryCoilDiscretizedPControl.mos" "run"));
 package Medium1 = Buildings.Media.ConstantPropertyLiquidWater;
 //package Medium2 = Buildings.Media.PerfectGases.MoistAir;
 //package Medium2 = Buildings.Media.GasesPTDecoupled.MoistAir;
 // package Medium2 = Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated;
 package Medium2 = Buildings.Media.GasesPTDecoupled.SimpleAir;
  parameter Modelica.SIunits.Temperature T_a1_nominal = 60+273.15;
  parameter Modelica.SIunits.Temperature T_b1_nominal = 50+273.15;
  parameter Modelica.SIunits.Temperature T_a2_nominal = 20+273.15;
  parameter Modelica.SIunits.Temperature T_b2_nominal = 40+273.15;
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 5
    "Nominal mass flow rate medium 1";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = m1_flow_nominal*4200/1000*(T_a1_nominal-T_b1_nominal)/(T_b2_nominal-T_a2_nominal)
    "Nominal mass flow rate medium 2";

  Buildings.Fluid.Sources.Boundary_pT sin_2(                       redeclare
      package Medium = Medium2,
    nPorts=1,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    T=303.15)             annotation (Placement(transformation(extent={{-52,10},
            {-32,30}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_2(                       redeclare
      package Medium = Medium2,
    nPorts=1,
    use_p_in=false,
    use_T_in=false,
    p(displayUnit="Pa") = 101625,
    T=T_a2_nominal)              annotation (Placement(transformation(extent={{140,10},
            {120,30}},  rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_1(                       redeclare
      package Medium = Medium1,
    p=300000,
    T=293.15,
    nPorts=1,
    use_p_in=true)        annotation (Placement(transformation(extent={{140,50},
            {120,70}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    p=300000 + 9000,
    nPorts=1,
    use_T_in=false,
    T=T_a1_nominal)              annotation (Placement(transformation(extent={{-22,50},
            {-2,70}},  rotation=0)));
    Fluid.FixedResistances.FixedResistanceDpM res_2(
    from_dp=true,
    redeclare package Medium = Medium2,
    dp_nominal=100,
    m_flow_nominal=m2_flow_nominal) 
             annotation (Placement(transformation(extent={{4,10},{-16,30}},
          rotation=0)));
    Fluid.FixedResistances.FixedResistanceDpM res_1(
    from_dp=true,
    redeclare package Medium = Medium1,
    m_flow_nominal=5,
    dp_nominal=3000) 
             annotation (Placement(transformation(extent={{90,50},{110,70}},
          rotation=0)));
    Modelica.Blocks.Sources.Ramp PSin_1(
    duration=60,
    height=5000,
    startTime=240,
    offset=300000) 
                 annotation (Placement(transformation(extent={{140,90},{160,110}},
          rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSen(redeclare package Medium = 
        Medium2) annotation (Placement(transformation(extent={{40,10},{20,30}},
          rotation=0)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium = Medium1,
    l=0.005,
    Kv_SI=5/sqrt(4000),
    m_flow_nominal=m1_flow_nominal) "Valve model" 
             annotation (Placement(transformation(extent={{30,50},{50,70}},
          rotation=0)));
  Modelica.Blocks.Math.Gain P(k=1)    annotation (Placement(transformation(
          extent={{-20,90},{0,110}},    rotation=0)));
  Modelica.Blocks.Math.Feedback fedBac(u1(displayUnit="degC"), u2(displayUnit="degC")) 
                                       annotation (Placement(transformation(
          extent={{-50,90},{-30,110}},  rotation=0)));
  Modelica.Blocks.Sources.TimeTable TSet(table=[0,298.15; 600,298.15; 600,
        303.15; 1200,303.15; 1800,298.15; 2400,298.15; 2400,304.15])
    "Setpoint temperature" 
    annotation (Placement(transformation(extent={{-80,90},{-60,110}},  rotation=
           0)));
  Buildings.Fluid.HeatExchangers.DryCoilDiscretized hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    nPipPar=1,
    nPipSeg=3,
    nReg=4,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    Q_flow_nominal=m1_flow_nominal*4200*(T_a1_nominal-T_b1_nominal),
    dT_nominal=((T_a1_nominal - T_b2_nominal) - (T_b1_nominal - T_a2_nominal))/Modelica.Math.log((T_a1_nominal - T_b2_nominal)/(T_b1_nominal - T_a2_nominal)),
    dp1_nominal(displayUnit="Pa") = 2000,
    dp2_nominal(displayUnit="Pa") = 200) 
                         annotation (Placement(transformation(extent={{60,16},{
            80,36}}, rotation=0)));
  Buildings.Fluid.Actuators.Motors.IdealMotor mot(tOpe=60) "Motor model" 
    annotation (Placement(transformation(extent={{12,90},{32,110}},rotation=0)));
  inner Modelica.Fluid.System system 
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(PSin_1.y, sin_1.p_in) annotation (Line(points={{161,100},{180,100},{
          180,68},{142,68}},
                         color={0,0,127}));
  connect(P.u, fedBac.y)  annotation (Line(points={{-22,100},{-40,100},{-31,100}},
                                                                         color=
          {0,0,127}));
  connect(temSen.T, fedBac.u2)      annotation (Line(points={{30,31},{30,40},{
          -40,40},{-40,92}},    color={0,0,127}));
  connect(hex.port_b1, res_1.port_a) 
    annotation (Line(points={{80,32},{86,32},{86,60},{90,60}},
                                               color={0,127,255}));
  connect(val.port_b, hex.port_a1)                   annotation (Line(points={{50,60},
          {52,60},{52,32},{60,32}},        color={0,127,255}));
  connect(P.y, mot.u) annotation (Line(points={{1,100},{1,100},{10,100}},
                color={0,0,127}));
  connect(sou_1.ports[1], val.port_a) annotation (Line(
      points={{-2,60},{30,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[1], res_1.port_b) annotation (Line(
      points={{120,60},{110,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1], res_2.port_b) annotation (Line(
      points={{-32,20},{-16,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_2.ports[1], hex.port_a2) annotation (Line(
      points={{120,20},{80,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSet.y, fedBac.u1) annotation (Line(
      points={{-59,100},{-48,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mot.y, val.y) annotation (Line(
      points={{33,100},{40,100},{40,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b2, temSen.port_a) annotation (Line(
      points={{60,20},{40,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSen.port_b, res_2.port_a) annotation (Line(
      points={{20,20},{4,20}},
      color={0,127,255},
      smooth=Smooth.None));
end DryCoilDiscretizedPControl;
