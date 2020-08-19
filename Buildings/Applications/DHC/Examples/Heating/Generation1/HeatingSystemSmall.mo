within Buildings.Applications.DHC.Examples.Heating.Generation1;
model HeatingSystemSmall
  "Generic first generation district heating system"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam (
     T_default=179.91+273.15,
     p_default=1000000) "Steam medium";
  package MediumWat = IBPSA.Media.WaterHighTemperature (
     T_default=179.91+273.15,
     p_default=1000000) "Water medium";

  // Building loads
  // Read in tables
  parameter Boolean tableOnFile=true
    "= true, if table is defined on file or in function usertab";
  parameter String tableName="HeatingLoadProfiles"
    "Table name on file or in function usertab";
  parameter Modelica.SIunits.Time timeScale=1 "Time scale of first table column";

  // Tabular load profiles
  parameter Real Q_flow_profile1[:, :]= [0, 200E3; 6, 200E3; 6, 50E3; 18, 50E3; 18, 125E3; 24, 125E3]
    "Time series heating load, building 1";
  parameter Real Q_flow_profile2[:, :]= [0, 75E3; 6, 75E3; 6, 150E3; 12, 150E3; 18, 35E3; 24, 35E3]
    "Time series heating load, building 2";


  // Nominal loads
  parameter Modelica.SIunits.Power QBld_flow_nominal= 19347.2793
    "Nominal heat flow rate, Project 1 WP3 DESTEST";
/*    
  parameter Modelica.SIunits.Power QBld1_flow_nominal= 200E3
    "Nominal heat flow rate, building 1";
  parameter Modelica.SIunits.Power QBld2_flow_nominal= 150E3
    "Nominal heat flow rate, building 2";
  parameter Modelica.SIunits.Power QBld3_flow_nominal= 100E3
    "Nominal heat flow rate, building 3";
  parameter Modelica.SIunits.Power QBld4_flow_nominal= 300E3
    "Nominal heat flow rate, building 4";
  parameter Modelica.SIunits.Power QBld5_flow_nominal= 200E3
    "Nominal heat flow rate, building 5";
  parameter Modelica.SIunits.Power QBld6_flow_nominal= 150E3
    "Nominal heat flow rate, building 6";
  parameter Modelica.SIunits.Power QBld7_flow_nominal= 100E3
    "Nominal heat flow rate, building 7";
  parameter Modelica.SIunits.Power QBld8_flow_nominal= 300E3
    "Nominal heat flow rate, building 8";
*/
  // Plant loads
  parameter Modelica.SIunits.Power QPla_flow_nominal=QBld_flow_nominal*2
    "Nominal heat flow rate of plant";
    //(QBld18_flow_nominal+QBld27_flow_nominal+QBld36_flow_nominal+QBld45_flow_nominal)*2
  parameter Modelica.SIunits.AbsolutePressure pSte=1000000
    "Nominal steam pressure leaving plant";
  final parameter Modelica.SIunits.Temperature TSte=
    MediumSte.saturationTemperature_p(pSte)
    "Nominal steam supply temperature";
  final parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    MediumSte.enthalpyOfVaporization_sat(MediumSte.saturationState_p(pSte))
    "Nominal change in enthalpy";

  // Connection mass flow rates
  // conPla
  final parameter Modelica.SIunits.MassFlowRate mConPla_flow_nominal=
    QPla_flow_nominal/dh_nominal
    "Nominal mass flow rate, plant connection, district main";
  final parameter Modelica.SIunits.MassFlowRate mConBld_flow_nominal=
    QBld_flow_nominal/dh_nominal
    "Nominal mass flow rate, plant connection, connector branch";

  // Pipe parameters
  parameter Integer nSeg=1 "Number of volume segments";
  parameter Modelica.SIunits.Distance thicknessIns=0.2 "Insulation thickness";
  parameter Modelica.SIunits.ThermalConductivity lambdaIns=0.04
    "Heat conductivity of insulation";
//  parameter Modelica.SIunits.Length diameter=10
//    "Pipe diameter (without insulation)";
  parameter Modelica.SIunits.Length length=50 "Length of the pipe";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: steady state";

  Buildings.Applications.DHC.CentralPlants.Heating.Generation1.HeatingPlantIdeal
    pla(
    redeclare package Medium_a = MediumWat,
    redeclare package Medium_b = MediumSte,
    mPla_flow_nominal=mConPla_flow_nominal,
    QPla_flow_nominal=QPla_flow_nominal,
    pOut_nominal=pSte,
    dp_nominal=6000,
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    a={0.9},
    show_T=true)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Applications.DHC.Examples.Heating.Generation1.BaseClasses.BuildingTimeSeriesHeating
    bld1(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    tableOnFile=tableOnFile,
    QHeaLoa=Q_flow_profile1,
    Q_flow_nominal=QBld_flow_nominal,
    pSte_nominal=pSte,
    tableName=tableName,
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Applications/DHC/Examples/FirstGeneration/HeatingSystem-WP3-DESTEST/HeatingLoadProfiles.csv"),
    columns={2},
    timeScale=timeScale,
    show_T=true)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Buildings.Applications.DHC.Examples.Heating.Generation1.BaseClasses.BuildingTimeSeriesHeating
    bld2(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    tableOnFile=tableOnFile,
    QHeaLoa=Q_flow_profile2,
    Q_flow_nominal=QBld_flow_nominal,
    pSte_nominal=pSte,
    tableName=tableName,
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Applications/DHC/Examples/FirstGeneration/HeatingSystem-WP3-DESTEST/HeatingLoadProfiles.csv"),
    columns={3},
    timeScale=timeScale,
    show_T=true)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

  Networks.Connection1stGen6PipeSections con(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    mDis_flow_nominal=mConPla_flow_nominal,
    mCon_flow_nominal=mConBld_flow_nominal,
    energyDynamics=energyDynamics,
    p_start=pSte,
    T_start=TSte,
    nSeg=nSeg,
    thicknessInsSup=thicknessIns,
    thicknessInsRet=thicknessIns,
    lambdaIns=lambdaIns,
    lengthDisSup_a=length,
    lengthDisRet_b=length,
    lengthDisSup_b=length,
    lengthDisRet_a=length,
    lengthConSup=length,
    lengthConRet=length) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,34})));

equation
  connect(con.port_bCon, bld2.port_a)
    annotation (Line(points={{-40,34},{-80,34}}, color={0,127,255}));
  connect(con.port_aCon, bld2.port_b)
    annotation (Line(points={{-40,40},{-80,40}}, color={0,127,255}));
  connect(con.port_bDisSup, bld1.port_a)
    annotation (Line(points={{-30,44},{-30,64},{-80,64}}, color={0,127,255}));
  connect(con.port_aDisRet, bld1.port_b)
    annotation (Line(points={{-24,44},{-24,70},{-80,70}}, color={0,127,255}));
  connect(pla.port_b, con.port_aDisSup) annotation (Line(points={{-60,-10},{-30,
          -10},{-30,24}}, color={0,127,255}));
  connect(pla.port_a, con.port_bDisRet) annotation (Line(points={{-60,-16},{-24,
          -16},{-24,24}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-150,-150},{150,150}})),
  __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/Examples/Heating/Generation1/HeatingSystemSmall.mos"
    "Simulate and plot"),
  experiment(
      StopTime=86400,
      Tolerance=0001,
      __Dymola_Algorithm="Cvode"));
end HeatingSystemSmall;
