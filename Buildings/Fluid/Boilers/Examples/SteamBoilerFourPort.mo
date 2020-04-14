within Buildings.Fluid.Boilers.Examples;
model SteamBoilerFourPort
  "Test model for the steam boiler with four fluid ports"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water (T_max = 200+273.15)
    "Water medium";
  package MediumAir = Modelica.Media.IdealGases.MixtureGases.CombustionAir
    "Fresh air for combustion (N2,O2)";
  package MediumFlu =
      Modelica.Media.IdealGases.MixtureGases.FlueGasLambdaOnePlus (
      reference_X={0.718,0.009,0.182,0.091})
    "Flue gas with excess air (N2,O2,H2O,CO2)";

//  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
//    "Nominal mass flow rate";

  parameter Modelica.SIunits.AbsolutePressure pOut_nominal = 861844.7
    "Nominal pressure for the boiler";

  parameter Modelica.SIunits.Temperature TIn_nominal = 20+273.15
    "Nominal temperature of inflowing water";

//  parameter Modelica.SIunits.Temperature TSat_nominal=
//    MediumSte.saturationTemperature(p_nominal)
//    "Nominal saturation temperature";

//  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
//    MediumSte.dewEnthalpy(MediumSte.setSat_T(TSat_nominal)) -
//    MediumSte.bubbleEnthalpy(MediumSte.setSat_T(TSat_nominal))
//    "Nominal change in enthalpy";

  parameter Modelica.SIunits.Power Q_flow_nominal=9143815.2
    "Nominal heat flow rate";
//        m_flow_nominal * (dh_nominal + MediumWat.cp_const*(TSat_nominal - MediumWat.T_default))

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=Q_flow_nominal/dh_nominal
    "Nominal mass flow rate";

  parameter Modelica.SIunits.Temperature TOut_nominal = MediumSte.saturationTemperature(pOut_nominal)
    "Nominal temperature leaving the boiler";

  parameter Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp_default=
    MediumWat.specificHeatCapacityCp(MediumWat.setState_pTX(
      T=MediumWat.T_default, p=MediumWat.p_default, X=MediumWat.X_default))
    "Default value for specific heat";

  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    cp_default*(TOut_nominal - TIn_nominal) +
    MediumSte.dewEnthalpy(MediumSte.setSat_p(pOut_nominal)) -
    MediumSte.bubbleEnthalpy(MediumSte.setSat_p(pOut_nominal))
   "Nominal change in enthalpy of boiler";

  Sources.Boundary_pT steSin(
    redeclare package Medium = MediumSte,
    use_p_in=true,
    p(displayUnit="Pa"),
    nPorts=1)            "Steam sink"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant pSet(k=pOut_nominal)
                                                   "Steam pressure setpoint"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  FixedResistances.PressureDrop dp_wat(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    dp_nominal(displayUnit="Pa") = 6000)
    "Pressure drop in water pipe network"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Sources.Boundary_pT watSou(
    redeclare package Medium = MediumWat,
    p(displayUnit="Pa"),
    nPorts=1) "Water source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Movers.FlowControlled_m_flow pum(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true) "Pump"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Sources.RealExpression mMax_flow(y=m_flow_nominal)
    "Maximum (nominal) mass flow rate"
    annotation (Placement(transformation(extent={{-80,34},{-60,54}})));
  Modelica.Blocks.Math.Product mAct_flow "Actual mass flow rate"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.TimeTable y(table=[0,0; 1800,1; 1800,0; 2400,0; 2400,
        1; 3600,1])
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Sources.Boundary_pT fluGasSin(redeclare package Medium = MediumSte, p(
        displayUnit="Pa"),
    nPorts=1)              "Flue gas sink"
    annotation (Placement(transformation(extent={{80,-70},{60,-50}})));
  Sources.Boundary_pT airSou(
    redeclare package Medium = MediumWat,
    p(displayUnit="Pa"),
    nPorts=1) "Air source"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Fluid.Boilers.SteamBoilerFourPort boi(
    redeclare package Medium_a1 = MediumWat,
    redeclare package Medium_b1 = MediumSte,
    redeclare package Medium_a2 = MediumAir,
    redeclare package Medium_b2 = MediumFlu) "Steam boiler"
    annotation (Placement(transformation(extent={{20,-12},{40,10}})));
equation
  connect(pSet.y, steSin.p_in) annotation (Line(points={{81,50},{90,50},{90,8},{
          82,8}},  color={0,0,127}));
  connect(watSou.ports[1], pum.port_a)
    annotation (Line(points={{-60,0},{-50,0}}, color={0,127,255}));
  connect(pum.port_b, dp_wat.port_a)
    annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
  connect(mMax_flow.y, mAct_flow.u2)
    annotation (Line(points={{-59,44},{-42,44}}, color={0,0,127}));
  connect(mAct_flow.y, pum.m_flow_in) annotation (Line(points={{-19,50},{-10,50},
          {-10,20},{-40,20},{-40,12}}, color={0,0,127}));
  connect(y.y, mAct_flow.u1) annotation (Line(points={{-59,70},{-52,70},{-52,56},
          {-42,56}}, color={0,0,127}));
  connect(dp_wat.port_b, boi.port_a1)
    annotation (Line(points={{0,0},{20,0}}, color={0,127,255}));
  connect(boi.port_b1, steSin.ports[1])
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(boi.port_b2, fluGasSin.ports[1]) annotation (Line(points={{40,-8},{50,
          -8},{50,-60},{60,-60}}, color={0,127,255}));
  connect(airSou.ports[1], boi.port_a2) annotation (Line(points={{-60,-60},{10,
          -60},{10,-8},{20,-8}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
experiment(Tolerance=1e-6, StopTime=100.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Examples/SteamBoilerTwoPort.mos"
        "Simulate and plot"));
end SteamBoilerFourPort;
