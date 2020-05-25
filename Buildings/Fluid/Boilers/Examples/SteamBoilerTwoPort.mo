within Buildings.Fluid.Boilers.Examples;
model SteamBoilerTwoPort "Test model for the steam boiler with two fluid ports"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam (
     T_default=173.5+273.15,
     p_default=861844.7) "Steam medium";
  package MediumWat = IBPSA.Media.WaterHighTemperature (
     T_default=173.5+273.15,
     p_default=861844.7) "Water medium";

  parameter Modelica.SIunits.AbsolutePressure pOut_nominal = 861844.7
    "Nominal pressure for the boiler";

  parameter Modelica.SIunits.Temperature TIn_nominal = 20+273.15
    "Nominal temperature of inflowing water";

  parameter Modelica.SIunits.Power Q_flow_nominal=9143815.2
    "Nominal heat flow rate";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=Q_flow_nominal/dh_nominal
    "Nominal mass flow rate";

  parameter Modelica.SIunits.Temperature TOut_nominal = MediumSte.saturationTemperature_p(pOut_nominal)
    "Nominal temperature leaving the boiler";

  parameter Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp_default=
    MediumWat.specificHeatCapacityCp(MediumWat.setState_pTX(
      T=MediumWat.T_default, p=MediumWat.p_default, X=MediumWat.X_default))
    "Default value for specific heat";

  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    cp_default*(TOut_nominal - TIn_nominal) +
    MediumSte.enthalpyOfSaturatedVapor_sat(MediumSte.saturationState_p(pOut_nominal)) -
    MediumSte.enthalpyOfSaturatedLiquid_sat(MediumSte.saturationState_p(pOut_nominal))
   "Nominal change in enthalpy of boiler";

  Sources.Boundary_pT steSin(
    redeclare package Medium = MediumSte,
    use_p_in=true,
    p(displayUnit="Pa"),
    nPorts=1) "Steam sink"
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
  Buildings.Fluid.Boilers.SteamBoilerTwoPort boi(
    redeclare package Medium_a = MediumWat,
    redeclare package Medium_b = MediumSte,
    m_flow_nominal=m_flow_nominal,
    pOut_nominal=pOut_nominal,
    show_T=true,
    Q_flow_nominal=Q_flow_nominal,
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    fue=Data.Fuels.NaturalGasLowerHeatingValue()) "Steam boiler"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
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

equation
  connect(pSet.y, steSin.p_in) annotation (Line(points={{81,50},{90,50},{90,8},{
          82,8}},  color={0,0,127}));
  connect(dp_wat.port_b, boi.port_a)
    annotation (Line(points={{0,0},{20,0}}, color={0,127,255}));
  connect(boi.port_b, steSin.ports[1])
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
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
  connect(y.y, boi.y) annotation (Line(points={{-59,70},{10,70},{10,9},{19,9}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
experiment(Tolerance=1e-6, StopTime=100.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Examples/SteamBoilerTwoPort.mos"
        "Simulate and plot"));
end SteamBoilerTwoPort;
