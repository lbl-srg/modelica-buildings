within Buildings.Fluid.Boilers.Examples;
model SteamBoilerTwoPort
  "Test model for the steam boiler with two fluid ports"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water (
   T_max = 200+273.15)
                      "Water medium";

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
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  FixedResistances.PressureDrop dp_wat(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    dp_nominal(displayUnit="bar") = 0)
    "Pressure drop in water pipe network"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Sources.Boundary_pT watSou(
    redeclare package Medium = MediumWat,
    p(displayUnit="Pa"),
    nPorts=1) "Water source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Boilers.SteamBoilerTwoPort boi(
    redeclare package Medium_a = MediumWat,
    redeclare package Medium_b = MediumSte,
    pOut_nominal=pOut_nominal,
    TIn_nominal=TIn_nominal,
    show_T=true,
    Q_flow_nominal=Q_flow_nominal,
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    fue=Data.Fuels.NaturalGasLowerHeatingValue()) "Steam boiler"
    annotation (Placement(transformation(extent={{20,-10},{40,12}})));
  Modelica.Blocks.Sources.Constant PLR(k=1) "Part load ratio"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
equation
  connect(pSet.y, steSin.p_in) annotation (Line(points={{81,40},{90,40},{90,8},{82,8}},
                   color={0,0,127}));
  connect(dp_wat.port_b, boi.port_a)
    annotation (Line(points={{0,0},{20,0}}, color={0,127,255}));
  connect(boi.port_b, steSin.ports[1])
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(PLR.y, boi.y) annotation (Line(points={{1,40},{12,40},{12,11},{19,11}},
        color={0,0,127}));
  connect(watSou.ports[1], dp_wat.port_a)
    annotation (Line(points={{-40,0},{-20,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
experiment(Tolerance=1e-6, StopTime=100.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Examples/SteamBoilerTwoPort.mos"
        "Simulate and plot"));
end SteamBoilerTwoPort;
