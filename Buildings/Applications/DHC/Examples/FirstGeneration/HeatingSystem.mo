within Buildings.Applications.DHC.Examples.FirstGeneration;
model HeatingSystem "Generic first generation district heating system"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.WaterHighTemperature "Water medium";

  // Building loads
  // Load profiles
  parameter Real Q_flow_profile1[:, :]= [0, 1; 6, 1; 6, 0.25; 18, 0.25; 18, 0.375; 24, 0.375]
    "Normalized time series heating load, profile 1";
  parameter Real Q_flow_profile2[:, :]= [0, 0.5; 6, 0.5; 6, 1; 12,1; 18, 0.25; 24, 0.25]
    "Normalized time series heating load, profile 2";

  // Nominal loads
  parameter Modelica.SIunits.Power QBld1_flow_nominal= 200E3
    "Nominal heat flow rate, building 1";
  parameter Modelica.SIunits.Power QBld2_flow_nominal= 150E3
    "Nominal heat flow rate, building 2";
  parameter Modelica.SIunits.Power QBld3_flow_nominal= 100E3
    "Nominal heat flow rate, building 3";
  parameter Modelica.SIunits.Power QBld4_flow_nominal= 300E3
    "Nominal heat flow rate, building 4";

  // Plant loads
  parameter Modelica.SIunits.Power QPla_flow_nominal= 550E3
    "Nominal heat flow rate of plant";
  parameter Modelica.SIunits.AbsolutePressure pSte_nominal=1000000
    "Nominal steam pressure leaving plant";
//  parameter Modelica.SIunits.Temperature TRet_nominal=273+50
//    "Nominal condensate return temperature to plant";
//  final parameter Modelica.SIunits.Temperature TSup_nominal=
//    MediumSte.saturationTemperature(pSte_nominal)
//    "Nominal steam supply temperature";
  final parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    MediumSte.dewEnthalpy(MediumSte.setSat_p(pSte_nominal)) -
    MediumSte.bubbleEnthalpy(MediumSte.setSat_p(pSte_nominal))
    "Nominal change in enthalpy";
  final parameter Modelica.SIunits.MassFlowRate mPla_flow_nominal=
    QPla_flow_nominal/dh_nominal
    "Nominal mass flow rate of plant";

  // Pipe parameters
  parameter Real nSeg=3 "Number of volume segments";
  parameter Modelica.SIunits.Distance thicknessIns=0.2 "Insulation thickness";
  parameter Modelica.SIunits.ThermalConductivity lambdaIns=0.04
    "Heat conductivity of insulation";
//  parameter Modelica.SIunits.Length diameter=10
//    "Pipe diameter (without insulation)";
  parameter Modelica.SIunits.Length length=50 "Length of the pipe";

  Buildings.Applications.DHC.CentralPlants.HeatingPlant1stGen pla(
    redeclare package Medium_a = MediumWat,
    redeclare package Medium_b = MediumSte,
    mPla_flow_nominal=mPla_flow_nominal,
    QPla_flow_nominal=QPla_flow_nominal,
    pOut_nominal=pSte_nominal)
    annotation (Placement(transformation(extent={{-30,-120},{-10,-100}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingTimeSeries1stGen bld1(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    timSer_norHeaLoa=Q_flow_profile1,
    QPea_flow_real=QBld1_flow_nominal,
    pSte_nominal=pSte_nominal)
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingTimeSeries1stGen bld2(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    timSer_norHeaLoa=Q_flow_profile1,
    QPea_flow_real=QBld2_flow_nominal,
    pSte_nominal=pSte_nominal)
    annotation (Placement(transformation(extent={{-20,60},{-40,80}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingTimeSeries1stGen bld3(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    timSer_norHeaLoa=Q_flow_profile2,
    QPea_flow_real=QBld3_flow_nominal,
    pSte_nominal=pSte_nominal)
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingTimeSeries1stGen bld4(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    timSer_norHeaLoa=Q_flow_profile2,
    QPea_flow_real=QBld4_flow_nominal,
    pSte_nominal=pSte_nominal)
    annotation (Placement(transformation(extent={{-20,0},{-40,20}})));
  Buildings.Applications.DHC.Controls.HeatingSystemControl plaCon(nu=4,
      QPla_flow_nominal=QPla_flow_nominal)
    annotation (Placement(transformation(extent={{-80,100},{-100,120}})));
equation
  connect(plaCon.y, pla.y) annotation (Line(points={{-101,110},{-130,110},{-130,
          -102},{-31,-102}}, color={0,0,127}));
  connect(plaCon.QBld_flow[1], bld1.Q_flow) annotation (Line(points={{-80,108.5},
          {-80,110},{-60,110},{-60,78},{-99,78}}, color={0,0,127}));
  connect(bld2.Q_flow, plaCon.QBld_flow[2]) annotation (Line(points={{-41,78},{-60,
          78},{-60,110},{-80,110},{-80,109.5}}, color={0,0,127}));
  connect(bld3.Q_flow, plaCon.QBld_flow[3]) annotation (Line(points={{-99,18},{-60,
          18},{-60,110.5},{-80,110.5}}, color={0,0,127}));
  connect(bld4.Q_flow, plaCon.QBld_flow[4]) annotation (Line(points={{-41,18},{-60,
          18},{-60,110},{-80,110},{-80,111.5}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-150,-150},{150,150}})));
end HeatingSystem;
