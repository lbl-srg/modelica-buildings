within Buildings.Fluid.HeatExchangers.Examples;
model WetEffectivenessNTUPControl
  import Buildings;
 package Medium1 = Buildings.Media.ConstantPropertyLiquidWater;
 //package Medium2 = Buildings.Media.PerfectGases.MoistAir;
 //package Medium2 = Buildings.Media.GasesPTDecoupled.MoistAir;
  package Medium2 = Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated;
 //package Medium2 = Buildings.Media.GasesConstantDensity.MoistAir;
  parameter Modelica.SIunits.Temperature T_a1_nominal = 5+273.15;
  parameter Modelica.SIunits.Temperature T_b1_nominal = 10+273.15;
  parameter Modelica.SIunits.Temperature T_a2_nominal = 30+273.15;
  parameter Modelica.SIunits.Temperature T_b2_nominal = 15+273.15;
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 0.05
    "Nominal mass flow rate medium 1";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = m1_flow_nominal*4200/1000*(T_a1_nominal-T_b1_nominal)/(T_b2_nominal-T_a2_nominal)
    "Nominal mass flow rate medium 2";
  Buildings.Fluid.Sources.Boundary_pT sin_2(                       redeclare
      package Medium = Medium2,
    nPorts=1,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    T=303.15)             annotation (Placement(transformation(extent={{-80,10},
            {-60,30}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_2(                       redeclare
      package Medium = Medium2,
    nPorts=1,
    use_p_in=false,
    p(displayUnit="Pa") = 101625,
    T=T_a2_nominal,
    X={0.02,1 - 0.02},
    use_T_in=true,
    use_X_in=true)               annotation (Placement(transformation(extent={{140,10},
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
    T=T_a1_nominal)              annotation (Placement(transformation(extent={{-80,50},
            {-60,70}}, rotation=0)));
    Fluid.FixedResistances.FixedResistanceDpM res_2(
    from_dp=true,
    redeclare package Medium = Medium2,
    dp_nominal=100,
    m_flow_nominal=m2_flow_nominal)
             annotation (Placement(transformation(extent={{-20,10},{-40,30}},
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
        Medium2) annotation (Placement(transformation(extent={{20,10},{0,30}},
          rotation=0)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium = Medium1,
    l=0.005,
    Kv_SI=5/sqrt(4000),
    m_flow_nominal=m1_flow_nominal) "Valve model"
             annotation (Placement(transformation(extent={{30,50},{50,70}},
          rotation=0)));
  Modelica.Blocks.Sources.TimeTable TSet(table=[0,288.15; 600,288.15; 600,
        293.15; 1200,293.15; 1800,283.15; 2400,283.15; 2400,288.15])
    "Setpoint temperature"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}}, rotation=
           0)));
  Buildings.Fluid.HeatExchangers.WetEffectivenessNTU hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal(displayUnit="Pa") = 2000,
    dp2_nominal(displayUnit="Pa") = 200,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    T_a1_nominal=T_a1_nominal,
    T_a2_nominal=T_a2_nominal,
    T_b2_nominal=T_b2_nominal,
    XW_a2_nominal=0.015,
    XW_b2_nominal=0.01)  annotation (Placement(transformation(extent={{60,16},{
            80,36}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Constant const(k=0.8)
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi(use_p_in=false, redeclare
      package Medium = Medium2)
    annotation (Placement(transformation(extent={{150,-42},{170,-22}})));
  Modelica.Blocks.Sources.Constant const1(k=T_a2_nominal)
    annotation (Placement(transformation(extent={{100,-38},{120,-18}})));
  Buildings.Controls.Continuous.LimPID limPID(
    Ti=1,
    Td=1,
    reverseAction=true,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMin=0)
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Modelica.Blocks.Sources.Constant fixme(k=1)
    annotation (Placement(transformation(extent={{0,140},{20,160}})));
equation
  connect(PSin_1.y, sin_1.p_in) annotation (Line(points={{161,100},{180,100},{
          180,68},{142,68}},
                         color={0,0,127}));
  connect(hex.port_b1, res_1.port_a)
    annotation (Line(points={{80,32},{86,32},{86,60},{90,60}},
                                               color={0,127,255}));
  connect(val.port_b, hex.port_a1)                   annotation (Line(points={{50,60},
          {52,60},{52,32},{60,32}},        color={0,127,255}));
  connect(sou_1.ports[1], val.port_a) annotation (Line(
      points={{-60,60},{30,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[1], res_1.port_b) annotation (Line(
      points={{120,60},{110,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1], res_2.port_b) annotation (Line(
      points={{-60,20},{-40,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_2.ports[1], hex.port_a2) annotation (Line(
      points={{120,20},{80,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b2, temSen.port_a) annotation (Line(
      points={{60,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSen.port_b, res_2.port_a) annotation (Line(
      points={{-5.55112e-16,20},{-20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(x_pTphi.X, sou_2.X_in) annotation (Line(
      points={{171,-32},{178,-32},{178,-34},{186,-34},{186,16},{142,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, x_pTphi.phi) annotation (Line(
      points={{121,-60},{136,-60},{136,-38},{148,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, x_pTphi.T) annotation (Line(
      points={{121,-28},{134,-28},{134,-32},{148,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y, sou_2.T_in) annotation (Line(
      points={{121,-28},{134,-28},{134,0},{160,0},{160,24},{142,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet.y, limPID.u_s) annotation (Line(
      points={{-39,110},{-2,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.T, limPID.u_m) annotation (Line(
      points={{10,31},{10,98}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{200,200}}), graphics),
                      Commands(file="WetEffectivenessNTUPControl.mos" "run"));
  connect(limPID.y, val.y) annotation (Line(
      points={{21,110},{40,110},{40,68}},
      color={0,0,127},
      smooth=Smooth.None));
end WetEffectivenessNTUPControl;
