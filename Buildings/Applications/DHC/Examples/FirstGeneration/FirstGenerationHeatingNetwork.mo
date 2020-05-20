within Buildings.Applications.DHC.Examples.FirstGeneration;
model FirstGenerationHeatingNetwork
  extends Modelica.Icons.Example;
  package MediumSte = IBPSA.Media.Steam.Steam "Steam medium";
  package MediumWat = IBPSA.Media.WaterHighTemperature "Water medium";

  // Building loads
  // Load profiles
  parameter Real Q_flow_profile1[:, :]= [0, 200E3; 6, 200E3; 6, 50E3; 18, 50E3; 18, 75E3; 24, 75E3]
    "Normalized time series heating load, profile 1";
  parameter Real Q_flow_profile2[:, :]= [0, 75E3; 6, 75E3; 6, 150E3; 12, 150E3; 18, 25E3; 24, 25E3]
    "Normalized time series heating load, profile 2";

  // Nominal loads
  parameter Modelica.SIunits.Power QBld1_flow_nominal= 200E3
    "Nominal heat flow rate, building 1";
  parameter Modelica.SIunits.Power QBld2_flow_nominal= 150E3
    "Nominal heat flow rate, building 2";

  // Plant loads
  parameter Modelica.SIunits.Power QPla_flow_nominal= 275E3
    "Nominal heat flow rate of plant";
  parameter Modelica.SIunits.AbsolutePressure pSte=1000000
    "Steam pressure";
  parameter Modelica.SIunits.Temperature TSte=
    MediumSte.saturationTemperature_p(pSte)
    "Steam temperature";
//  parameter Modelica.SIunits.Temperature TRet_nominal=273+50
//    "Nominal condensate return temperature to plant";
//  final parameter Modelica.SIunits.Temperature TSup_nominal=
//    MediumSte.saturationTemperature(pSte_nominal)
//    "Nominal steam supply temperature";
  final parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    MediumSte.enthalpyOfVaporization_sat(MediumSte.saturationState_p(pSte))
    "Nominal change in enthalpy";
  final parameter Modelica.SIunits.MassFlowRate mPla_flow_nominal=
    QPla_flow_nominal/dh_nominal
    "Nominal mass flow rate of plant";

  // Pipe parameters
  parameter Integer nSeg=3 "Number of volume segments";
  parameter Modelica.SIunits.Distance thicknessIns=0.2 "Insulation thickness";
  parameter Modelica.SIunits.ThermalConductivity lambdaIns=0.04
    "Heat conductivity of insulation";
//  parameter Modelica.SIunits.Length diameter=10
//    "Pipe diameter (without insulation)";
  parameter Modelica.SIunits.Length length=50 "Length of the pipe";

  Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingTimeSeries1stGen bld1(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    QHeaLoa=Q_flow_profile1,
    Q_flow_nominal=QBld1_flow_nominal,
    pSte_nominal=pSte)
    annotation (Placement(transformation(extent={{-60,66},{-40,86}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingTimeSeries1stGen bld2(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    QHeaLoa=Q_flow_profile2,
    Q_flow_nominal=QBld2_flow_nominal,
    pSte_nominal=pSte)
    annotation (Placement(transformation(extent={{-60,26},{-40,46}})));
  Networks.Connection1stGen2PipeSections conBld2(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    mDis_flow_nominal=mPla_flow_nominal,
    mCon_flow_nominal=QBld2_flow_nominal/dh_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    nSeg=nSeg,
    thicknessInsSup=thicknessIns,
    thicknessInsRet=thicknessIns,
    lambdaIns=lambdaIns,
    lengthDisSup=length,
    lengthDisRet=length) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,30})));
  Fluid.Sources.Boundary_pT steSou(
    redeclare package Medium = MediumSte,
    p=pSte,
    T=TSte,
    nPorts=1) "Steam source"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Fluid.Sources.Boundary_pT watSin(redeclare package Medium = MediumWat,
    p=pSte,
    T=TSte,                                                              nPorts=
       1) "Water sink"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(conBld2.port_bCon, bld2.port_a)
    annotation (Line(points={{0,30},{-40,30}},   color={0,127,255}));
  connect(conBld2.port_aCon, bld2.port_b)
    annotation (Line(points={{0,36},{-40,36}},   color={0,127,255}));
  connect(conBld2.port_bDisSup, bld1.port_a)
    annotation (Line(points={{10,40},{10,70},{-40,70}},   color={0,127,255}));
  connect(conBld2.port_aDisRet, bld1.port_b)
    annotation (Line(points={{16,40},{16,76},{-40,76}},   color={0,127,255}));
  connect(steSou.ports[1], conBld2.port_aDisSup)
    annotation (Line(points={{-20,0},{10,0},{10,20}}, color={0,127,255}));
  connect(watSin.ports[1], conBld2.port_bDisRet)
    annotation (Line(points={{-20,-30},{16,-30},{16,20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, __Dymola_Algorithm="Cvode"));
end FirstGenerationHeatingNetwork;
