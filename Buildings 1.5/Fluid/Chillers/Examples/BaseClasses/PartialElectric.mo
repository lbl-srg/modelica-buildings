within Buildings.Fluid.Chillers.Examples.BaseClasses;
partial model PartialElectric
  "Base class for test model of chiller electric EIR"
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
     per.mEva_flow_nominal "Nominal mass flow rate at evaporator";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=
     per.mCon_flow_nominal "Nominal mass flow rate at condenser";

  replaceable Buildings.Fluid.Chillers.BaseClasses.PartialElectric chi
        constrainedby Buildings.Fluid.Chillers.BaseClasses.PartialElectric(
       redeclare package Medium1 = Medium1,
       redeclare package Medium2 = Medium2,
       energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
       dp1_nominal=6000,
       dp2_nominal=6000) "Chiller model"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(nPorts=1,
    redeclare package Medium = Medium1,
    use_T_in=true,
    m_flow=mCon_flow_nominal,
    T=298.15)
    annotation (Placement(transformation(extent={{-60,6},{-40,26}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(nPorts=1,
    redeclare package Medium = Medium2,
    use_T_in=true,
    m_flow=mEva_flow_nominal,
    T=291.15)
    annotation (Placement(transformation(extent={{60,-6},{40,14}})));
  Buildings.Fluid.Sources.FixedBoundary sin1(
    redeclare package Medium = Medium1,
    nPorts=1)                           annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,40})));
  Buildings.Fluid.Sources.FixedBoundary sin2(
    redeclare package Medium = Medium2,
    nPorts=1)                           annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-20})));
  Modelica.Blocks.Sources.Ramp TSet(
    duration=3600,
    startTime=3*3600,
    offset=273.15 + 10,
    height=8) "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    offset=273.15 + 20,
    duration=3600,
    startTime=2*3600) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    offset=273.15 + 15,
    height=5,
    startTime=3600,
    duration=3600) "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  replaceable parameter Buildings.Fluid.Chillers.Data.BaseClasses.Chiller per
  constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Base class for performance data"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Modelica.Blocks.Sources.Pulse pulse(period=3600/2)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=0.5)
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(
    redeclare package Medium = Medium1,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{32,30},{52,50}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res2(
    dp_nominal=6000,
    redeclare package Medium = Medium2,
    m_flow_nominal=mEva_flow_nominal) "Flow resistance"
    annotation (Placement(transformation(extent={{-20,-30},{-40,-10}})));
equation
  connect(sou1.ports[1], chi.port_a1)    annotation (Line(
      points={{-40,16},{-5.55112e-16,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1], chi.port_a2)    annotation (Line(
      points={{40,4},{20,4}},
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
      points={{-59,60},{-10,60},{-10,7},{-2,7}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(greaterThreshold.u, pulse.y) annotation (Line(
      points={{-42,90},{-59,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(greaterThreshold.y, chi.on) annotation (Line(
      points={{-19,90},{-8,90},{-8,13},{-2,13}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(chi.port_b1, res1.port_a) annotation (Line(
      points={{20,16},{26,16},{26,40},{32,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, sin1.ports[1]) annotation (Line(
      points={{52,40},{60,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_b2, res2.port_a) annotation (Line(
      points={{-5.55112e-16,4},{-10,4},{-10,-20},{-20,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_b, sin2.ports[1]) annotation (Line(
      points={{-40,-20},{-60,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end PartialElectric;
