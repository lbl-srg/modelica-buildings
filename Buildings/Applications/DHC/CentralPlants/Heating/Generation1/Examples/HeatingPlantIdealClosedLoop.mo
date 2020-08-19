within Buildings.Applications.DHC.CentralPlants.Heating.Generation1.Examples;
model HeatingPlantIdealClosedLoop
  "Example model for the first generation heating plant"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam (
     T_default=179.91+273.15,
     p_default=1000000) "Steam medium";
  package MediumWat = IBPSA.Media.WaterHighTemperature "Water medium";

  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    MediumSte.enthalpyOfVaporization_sat(MediumSte.saturationState_p(pSte))
    "Nominal change in enthalpy";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/dh_nominal
    "Nominal mass flow rate";

  parameter Modelica.SIunits.AbsolutePressure pSte=1000000
    "Steam pressure";

  parameter Modelica.SIunits.Temperature TSte=
    MediumSte.saturationTemperature_p(pSte)
    "Steam temperature";

  // Plant load
  parameter Real Q_flow_profile[:, :]= [0, 9000E3; 6, 9000E3; 6, 500E3; 18, 500E3; 18, 800E3; 24, 800E3]
    "Normalized time series heating load";
  parameter Modelica.SIunits.Power Q_flow_nominal= 9000E3
    "Nominal heat flow rate";

  Buildings.Applications.DHC.CentralPlants.Heating.Generation1.HeatingPlantIdeal
    pla(
    redeclare package Medium_a = MediumWat,
    redeclare package Medium_b = MediumSte,
    mPla_flow_nominal=m_flow_nominal,
    QPla_flow_nominal=Q_flow_nominal,
    pOut_nominal=pSte,
    dp_nominal=6000,
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    a={0.9},
    show_T=true) "Heating plant"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Ramp ramp(duration(displayUnit="min") = 1200,
      startTime(displayUnit="h"))
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Applications.DHC.EnergyTransferStations.Heating.Generation1.Heating1stGenIdeal ets(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    m_flow_nominal=m_flow_nominal,
    Q_flow_nominal=Q_flow_nominal,
    pSte_nominal=pSte) "Energy transfer station"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Fluid.FixedResistances.Pipe pip(
    redeclare package Medium = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    p_start=pSte,
    T_start=TSte,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    nSeg=1,
    thicknessIns=0.01,
    lambdaIns=0.04,
    length=100)
    annotation (Placement(transformation(extent={{20,-80},{0,-60}})));
  Modelica.Blocks.Sources.TimeTable QHea(table=Q_flow_profile, timeScale(
        displayUnit="s") = 3600)           "Heating demand"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Math.Product Q_flow
    annotation (Placement(transformation(extent={{0,26},{20,46}})));
equation
  connect(pla.port_b, ets.port_a)
    annotation (Line(points={{-40,-10},{40,-10}},
                                                color={0,127,255}));
  connect(ets.port_b, pip.port_a) annotation (Line(points={{60,-10},{70,-10},{
          70,-70},{20,-70}},
                          color={0,127,255}));
  connect(pip.port_b, pla.port_a) annotation (Line(points={{0,-70},{-30,-70},{
          -30,-16},{-40,-16}},
                       color={0,127,255}));
  connect(QHea.y, Q_flow.u2)
    annotation (Line(points={{-19,30},{-2,30}}, color={0,0,127}));
  connect(Q_flow.u1, ramp.y) annotation (Line(points={{-2,42},{-8,42},{-8,70},{
          -19,70}}, color={0,0,127}));
  connect(Q_flow.y, ets.Q_flow) annotation (Line(points={{21,36},{30,36},{30,-4},
          {38,-4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/CentralPlants/Heating/Generation1/Examples/HeatingPlantIdealClosedLoop.mos"
    "Simulate and plot"),
  experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end HeatingPlantIdealClosedLoop;
