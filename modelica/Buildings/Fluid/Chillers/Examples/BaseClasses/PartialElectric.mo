within Buildings.Fluid.Chillers.Examples.BaseClasses;
partial model PartialElectric
  "Base class for test model of chiller electric EIR"
  import Buildings;
 package Medium1 = Buildings.Media.ConstantPropertyLiquidWater "Medium model";
 package Medium2 = Buildings.Media.ConstantPropertyLiquidWater "Medium model";

  parameter Modelica.SIunits.Power P_nominal=-per.QEva_flow_nominal/per.COP_nominal
    "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal = 3 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=
     per.mCon_flow_nominal "Nominal mass flow rate at evaporator";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=
     per.mEva_flow_nominal "Nominal mass flow rate at condenser";

  replaceable Buildings.Fluid.Chillers.BaseClasses.PartialElectricSteadyState
    chi constrainedby
    Buildings.Fluid.Chillers.BaseClasses.PartialElectricSteadyState(
       redeclare package Medium1 = Medium1,
       redeclare package Medium2 = Medium2,
       dp1_nominal=6000,
       dp2_nominal=6000) "Chiller model"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(nPorts=1,
    redeclare package Medium = Medium1,
    use_T_in=true,
    m_flow=mEva_flow_nominal,
    T=298.15)
    annotation (Placement(transformation(extent={{-60,6},{-40,26}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(nPorts=1,
    redeclare package Medium = Medium2,
    use_T_in=true,
    m_flow=mCon_flow_nominal,
    T=291.15)
    annotation (Placement(transformation(extent={{60,-6},{40,14}})));
  Buildings.Fluid.Sources.FixedBoundary sin1(nPorts=1, redeclare package Medium
      = Medium1)                                     annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,40})));
  Buildings.Fluid.Sources.FixedBoundary sin2(nPorts=1, redeclare package Medium
      = Medium2)                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-20})));
  Modelica.Blocks.Sources.Ramp TSet(
    duration=60,
    startTime=1800,
    offset=273.15 + 5,
    height=15) "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    duration=60,
    offset=273.15 + 20,
    startTime=60) "Condensor inlet temperature"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    duration=60,
    startTime=900,
    offset=273.15 + 15,
    height=5) "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  replaceable
    Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_589COP_Vanes
    per constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller performance data"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
equation
  connect(sou1.ports[1], chi.port_a1)    annotation (Line(
      points={{-40,16},{-5.55112e-16,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1], chi.port_a2)    annotation (Line(
      points={{40,4},{35,4},{35,4},{30,4},{30,4},{20,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_b1, sin1.ports[1])    annotation (Line(
      points={{20,16},{30,16},{30,40},{60,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin2.ports[1], chi.port_b2)    annotation (Line(
      points={{-40,-20},{-10,-20},{-10,4},{-5.55112e-16,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TCon_in.y, sou1.T_in) annotation (Line(
      points={{-69,20},{-62,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEva_in.y, sou2.T_in) annotation (Line(
      points={{71,-30},{80,-30},{80,8},{62,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet.y, chi.TSet) annotation (Line(
      points={{-39,60},{-10,60},{-10,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None));

end PartialElectric;
