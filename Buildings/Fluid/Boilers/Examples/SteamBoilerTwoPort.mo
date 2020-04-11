within Buildings.Fluid.Boilers.Examples;
model SteamBoilerTwoPort
  "Test model for the steam boiler with two fluid ports"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water (
   T_max = 200+273.15)
                      "Water medium";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";

  parameter Modelica.SIunits.AbsolutePressure p_nominal = 861844.7
    "Nominal pressure for the boiler";

  parameter Modelica.SIunits.Temperature TSat_nominal=
    MediumSte.saturationTemperature(p_nominal)
    "Nominal saturation temperature";

  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    MediumSte.dewEnthalpy(MediumSte.setSat_T(TSat_nominal)) -
    MediumSte.bubbleEnthalpy(MediumSte.setSat_T(TSat_nominal))
    "Nominal change in enthalpy";

  parameter Modelica.SIunits.Power Q_flow_nominal=9143815.2
    "Nominal heat flow rate";
//        m_flow_nominal * (dh_nominal + MediumWat.cp_const*(TSat_nominal - MediumWat.T_default))


  Sources.Boundary_pT steSin(
    redeclare package Medium = MediumSte,
    use_p_in=true,
    p(displayUnit="Pa"),
    nPorts=1)            "Steam sink"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant pSet(k=1000000) "Steam pressure setpoint"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  FixedResistances.PressureDrop dp_wat(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    dp_nominal(displayUnit="bar") = 0)
    "Pressure drop in water pipe network"
    annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
  Sources.Boundary_pT watSou(
    redeclare package Medium = MediumWat,
    p(displayUnit="Pa"),
    nPorts=1) "Water source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Movers.FlowControlled_m_flow pum(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)       "Pump"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Fluid.Boilers.SteamBoilerTwoPort boi(
    redeclare package Medium_a = MediumWat,
    redeclare package Medium_b = MediumSte,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    Q_flow_nominal=Q_flow_nominal,
    T_nominal=TSat_nominal,
    fue=Data.Fuels.NaturalGasLowerHeatingValue()) "Steam boiler"
    annotation (Placement(transformation(extent={{20,-10},{40,12}})));
  Modelica.Blocks.Sources.Constant PLR(k=1) "Part load ratio"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
equation
  connect(pSet.y, steSin.p_in) annotation (Line(points={{-19,40},{90,40},{90,8},
          {82,8}}, color={0,0,127}));
  connect(watSou.ports[1], pum.port_a)
    annotation (Line(points={{-60,0},{-50,0}}, color={0,127,255}));
  connect(pum.port_b, dp_wat.port_a)
    annotation (Line(points={{-30,0},{-18,0}}, color={0,127,255}));
  connect(pSet.y, boi.pSte)
    annotation (Line(points={{-19,40},{6,40},{6,6},{19,6}}, color={0,0,127}));
  connect(dp_wat.port_b, boi.port_a)
    annotation (Line(points={{2,0},{20,0}}, color={0,127,255}));
  connect(boi.port_b, steSin.ports[1])
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(PLR.y, boi.y) annotation (Line(points={{-19,80},{12,80},{12,9.8},{19,
          9.8}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
experiment(Tolerance=1e-6, StopTime=100.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Examples/IdealSteamBoiler.mos"
        "Simulate and plot"));
end SteamBoilerTwoPort;
