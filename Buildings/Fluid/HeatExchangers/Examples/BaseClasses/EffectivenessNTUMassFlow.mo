within Buildings.Fluid.HeatExchangers.Examples.BaseClasses;
partial model EffectivenessNTUMassFlow
  "Partial model of epsilon-NTU coil that tests variable mass flow rates"
  package Medium1 = Buildings.Media.Water "Medium model for water";
  package Medium2 = Buildings.Media.Air
    "Medium model for air";
  parameter Modelica.Units.SI.Temperature T_a1_nominal=5 + 273.15
    "Nominal water inlet temperature";
  parameter Modelica.Units.SI.Temperature T_b1_nominal=10 + 273.15
    "Nominal water outlet temperature";
  parameter Modelica.Units.SI.Temperature T_a2_nominal=30 + 273.15
    "Nominal air inlet temperature";
  parameter Modelica.Units.SI.Temperature T_b2_nominal=15 + 273.15
    "Nominal air outlet temperature";
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=m1_flow_nominal*4200*
      (T_a1_nominal - T_b1_nominal) "Nominal heat transfer";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=0.1
    "Nominal mass flow rate medium 1";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=m1_flow_nominal*4200
      /1000*(T_a1_nominal - T_b1_nominal)/(T_b2_nominal - T_a2_nominal)
    "Nominal mass flow rate medium 2";
  Buildings.Fluid.Sources.MassFlowSource_T sin_2(
    redeclare package Medium = Medium2,
    T=T_a2_nominal,
    use_m_flow_in=true) "Sink for air"
    annotation (Placement(transformation(extent={{0,14},{20,34}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    T=T_a2_nominal,
    X={0.02,1 - 0.02},
    use_T_in=true,
    use_X_in=true) "Source for air"
    annotation (Placement(transformation(extent={{138,14},{118,34}})));
  Buildings.Fluid.Sources.MassFlowSource_T sin_1(
    redeclare package Medium = Medium1,
    T=T_a1_nominal,
    use_m_flow_in=true) "Sink for water"
    annotation (Placement(transformation(extent={{140,50},{120,70}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    use_T_in=false,
    T=T_a1_nominal) "Source for water"
    annotation (Placement(transformation(extent={{-2,52},{18,72}})));

  Modelica.Blocks.Sources.Constant relHum(k=0.8) "Relative humidity"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi(use_p_in=false)
    annotation (Placement(transformation(extent={{150,-42},{170,-22}})));
  Modelica.Blocks.Sources.Constant temSou_2(k=T_a2_nominal)
    "Temperature boundary condition"
    annotation (Placement(transformation(extent={{100,-38},{120,-18}})));
  Modelica.Blocks.Math.Gain mWat_flow(k=-m1_flow_nominal)
    "Water mass flow rate"
    annotation (Placement(transformation(extent={{-42,100},{-22,120}})));
  Modelica.Blocks.Sources.TimeTable mWatGai(
    table=[0,1; 0.1,1; 0.2,0.01; 0.3,0.01],
    timeScale=3600)
    "Gain for water mass flow rate"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Modelica.Blocks.Sources.TimeTable mAirGai(
    table=[0,1; 0.5,1; 0.6,-1; 0.7,0; 1,0],
    timeScale=3600)
    "Gain for air mass flow rate"
    annotation (Placement(transformation(extent={{-80,22},{-60,42}})));
  Modelica.Blocks.Math.Gain mAir_flow(k=-m2_flow_nominal) "Air mass flow rate"
    annotation (Placement(transformation(extent={{-40,22},{-20,42}})));
equation
  connect(x_pTphi.X, sou_2.X_in) annotation (Line(
      points={{171,-32},{178,-32},{178,-34},{186,-34},{186,20},{140,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relHum.y, x_pTphi.phi) annotation (Line(
      points={{121,-60},{136,-60},{136,-38},{148,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSou_2.y, x_pTphi.T) annotation (Line(
      points={{121,-28},{134,-28},{134,-32},{148,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSou_2.y, sou_2.T_in) annotation (Line(
      points={{121,-28},{134,-28},{134,0},{160,0},{160,28},{140,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWatGai.y, mWat_flow.u) annotation (Line(
      points={{-59,110},{-44,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWat_flow.y, sin_1.m_flow_in) annotation (Line(
      points={{-21,110},{160,110},{160,68},{140,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mAirGai.y, mAir_flow.u) annotation (Line(
      points={{-59,32},{-42,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mAir_flow.y, sin_2.m_flow_in) annotation (Line(
      points={{-19,32},{0,32}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{200,200}}), graphics));
end EffectivenessNTUMassFlow;
