within Buildings.Fluid.HeatExchangers.Examples.BaseClasses;
partial model EffectivenessNTUMassFlow
  "Partial model of epsilon-NTU coil that tests variable mass flow rates"
  package Medium1 = Buildings.Media.ConstantPropertyLiquidWater;
  package Medium2 = Buildings.Media.PerfectGases.MoistAirUnsaturated;
  parameter Modelica.SIunits.Temperature T_a1_nominal=5 + 273.15;
  parameter Modelica.SIunits.Temperature T_b1_nominal=10 + 273.15;
  parameter Modelica.SIunits.Temperature T_a2_nominal=30 + 273.15;
  parameter Modelica.SIunits.Temperature T_b2_nominal=15 + 273.15;
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = m1_flow_nominal*4200*(T_a1_nominal-T_b1_nominal)
    "Nominal heat transfer";
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=0.1
    "Nominal mass flow rate medium 1";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=m1_flow_nominal*4200/
      1000*(T_a1_nominal - T_b1_nominal)/(T_b2_nominal - T_a2_nominal)
    "Nominal mass flow rate medium 2";
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    T=T_a2_nominal)
              annotation (Placement(transformation(extent={{-42,14},{-22,34}},
          rotation=0)));
  Buildings.Fluid.Sources.MassFlowSource_T sou_2(
    redeclare package Medium = Medium2,
    T=T_a2_nominal,
    X={0.02,1 - 0.02},
    use_T_in=true,
    use_X_in=true,
    m_flow=m2_flow_nominal,
    use_m_flow_in=true)                 annotation (Placement(transformation(
          extent={{138,14},{118,34}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    use_p_in=false,
    p=300000,
    T=T_a1_nominal)
              annotation (Placement(transformation(extent={{140,50},{120,70}},
          rotation=0)));
  Buildings.Fluid.Sources.MassFlowSource_T sou_1(
    redeclare package Medium = Medium1,
    use_m_flow_in=true,
    use_T_in=false,
    T=T_a1_nominal)
                   annotation (Placement(transformation(extent={{-2,52},{18,72}},
                  rotation=0)));

  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Constant const(k=0.8)
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi(use_p_in=false)
    annotation (Placement(transformation(extent={{150,-42},{170,-22}})));
  Modelica.Blocks.Sources.Constant const1(k=T_a2_nominal)
    annotation (Placement(transformation(extent={{100,-38},{120,-18}})));
  Modelica.Blocks.Math.Gain mWat_flow(k=m1_flow_nominal) "Water mass flow rate"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Sources.TimeTable mWatGai(
    table=[0,1; 3600*0.1,1; 3600*0.2,0.01; 3600*0.3,0.01])
    "Gain for water mass flow rate"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}},   rotation=
           0)));
  Modelica.Blocks.Sources.TimeTable mAirGai(
    table=[0,1; 3600*0.5,1; 3600*0.6,-1; 3600*0.7,0; 3600*1,0])
    "Gain for air mass flow rate"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}}, rotation=
           0)));
  Modelica.Blocks.Math.Gain mAir_flow(k=m2_flow_nominal) "Air mass flow rate"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
equation
  connect(x_pTphi.X, sou_2.X_in) annotation (Line(
      points={{171,-32},{178,-32},{178,-34},{186,-34},{186,20},{140,20}},
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
      points={{121,-28},{134,-28},{134,0},{160,0},{160,28},{140,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWat_flow.y, sou_1.m_flow_in) annotation (Line(
      points={{-19,70},{-2,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mAir_flow.y, sou_2.m_flow_in) annotation (Line(
      points={{-19,110},{160,110},{160,32},{138,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mAirGai.y, mAir_flow.u) annotation (Line(
      points={{-59,110},{-52,110},{-52,110},{-42,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWatGai.y, mWat_flow.u) annotation (Line(
      points={{-59,70},{-42,70}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}})));
end EffectivenessNTUMassFlow;
