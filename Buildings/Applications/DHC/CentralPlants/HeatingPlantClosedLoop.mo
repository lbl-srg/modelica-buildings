within Buildings.Applications.DHC.CentralPlants;
model HeatingPlantClosedLoop
  "Example model for the first generation heating plant"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam.Steam "Steam medium";
  package MediumWat = IBPSA.Media.WaterHighTemperature "Water medium";

  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    MediumSte.enthalpyOfVaporization_sat(MediumSte.saturationState_p(pSte))
    "Nominal change in enthalpy";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/dh_nominal
    "Nominal mass flow rate";

//  parameter Modelica.SIunits.Power QPla_flow_small = pla.mPla_flow_small*dh_nominal
//    "Small heat flow rate for normalization";

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

  HeatingPlant1stGen pla(
    redeclare package Medium_a = MediumWat,
    redeclare package Medium_b = MediumSte,
    mPla_flow_nominal=m_flow_nominal,
    QPla_flow_nominal=Q_flow_nominal,
    pOut_nominal=pSte,
    dp_nominal=6000,
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    a={0.9})             "Heating plant"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Ramp PLR(
    height=0.5,
    duration(displayUnit="h") = 3600,
    offset=0.5,
    startTime(displayUnit="h") = 3600)
    annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
  EnergyTransferStations.Heating1stGenIdeal ets(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    m_flow_nominal=m_flow_nominal,
    Q_flow_nominal=Q_flow_nominal,
    pSte_nominal=pSte) "Energy transfer station"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Modelica.Blocks.Sources.RealExpression Q_flow(y=Q_flow_nominal)
    annotation (Placement(transformation(extent={{-4,54},{16,74}})));
  Modelica.Blocks.Math.Product Q_flow_act
    annotation (Placement(transformation(extent={{26,60},{46,80}})));
  Fluid.FixedResistances.Pipe pip(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    nSeg=1,
    thicknessIns=0.01,
    lambdaIns=0.04,
    length=100)
    annotation (Placement(transformation(extent={{40,-30},{20,-10}})));
equation
  connect(PLR.y, pla.y)
    annotation (Line(points={{-59,18},{-41,18}}, color={0,0,127}));
  connect(pla.port_b, ets.port_a)
    annotation (Line(points={{-20,10},{60,10}}, color={0,127,255}));
  connect(PLR.y, Q_flow_act.u1) annotation (Line(points={{-59,18},{-50,18},{-50,
          76},{24,76}}, color={0,0,127}));
  connect(Q_flow.y, Q_flow_act.u2)
    annotation (Line(points={{17,64},{24,64}}, color={0,0,127}));
  connect(Q_flow_act.y, ets.Q_flow) annotation (Line(points={{47,70},{52,70},{
          52,16},{58,16}}, color={0,0,127}));
  connect(ets.port_b, pip.port_a) annotation (Line(points={{80,10},{90,10},{90,
          -20},{40,-20}}, color={0,127,255}));
  connect(pip.port_b, pla.port_a) annotation (Line(points={{20,-20},{0,-20},{0,
          4},{-20,4}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/CentralPlants/HeatingPlantClosedLoop.mos"
    "Simulate and plot"),
  experiment(
    StartTime=0,
    StopTime=10800,
    Tolerance=1e-06));
end HeatingPlantClosedLoop;
