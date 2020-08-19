within Buildings.Applications.DHC.Examples.Heating;
package Generation1 "Package of example models for first generation DH systems"
  extends Modelica.Icons.VariantsPackage;

  model HeatingSystem
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
    parameter Real Q_flow_profile3[:, :]= [0, 1E3; 6, 1E3; 6, 100E3; 12, 50E3; 18, 50E3; 24, 1E3]
      "Time series heating load, building 3";
    parameter Real Q_flow_profile4[:, :]= [0, 300E3; 1, 300E3]
      "Time series heating load, building 4";
    parameter Real Q_flow_profile5[:, :]= [0, 300E3; 6, 300E3; 6, 75E3; 18, 75E3; 18, 100E3; 24, 100E3]
      "Time series heating load, building 5";
    parameter Real Q_flow_profile6[:, :]= [0, 100E3; 1, 100E3]
      "Time series heating load, building 6";
    parameter Real Q_flow_profile7[:, :]= [0, 150E3; 6, 150E3; 6, 45E3; 18, 45E3; 18, 125E3; 24, 125E3]
      "Time series heating load, building 7";
    parameter Real Q_flow_profile8[:, :]= [0, 100E3; 6, 100E3; 6, 200E3; 12, 200E3; 18, 50E3; 24, 50E3]
      "Time series heating load, building 8";
  //  parameter Modelica.SIunits.Time timeScale=3600 "Time scale of first table column";
    //[0, 1; 6, 1; 6, 0.25; 18, 0.25; 18, 0.375; 24, 0.375]
    //[0, 0.5; 6, 0.5; 6, 1; 12, 1; 18, 0.25; 24, 0.25]

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
    parameter Modelica.SIunits.Power QPla_flow_nominal=154778.2344
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
    final parameter Modelica.SIunits.MassFlowRate mConPlaDis_flow_nominal=
      QPla_flow_nominal/dh_nominal
      "Nominal mass flow rate, plant connection, district main";
    final parameter Modelica.SIunits.MassFlowRate mConPlaCon_flow_nominal=
      4*QBld_flow_nominal/dh_nominal
      "Nominal mass flow rate, plant connection, connector branch";
  //  final parameter Modelica.SIunits.MassFlowRate mConPlaCon_flow_nominal=
  //    (QBld18_flow_nominal+QBld27_flow_nominal+QBld36_flow_nominal+QBld45_flow_nominal)/dh_nominal
  //    "Nominal mass flow rate, plant connection, connector branch";

    // Left branch
    // conBld4
    final parameter Modelica.SIunits.MassFlowRate mCon4Dis_flow_nominal=
      mConPlaCon_flow_nominal
      "Nominal mass flow rate, building 4, district main";
    final parameter Modelica.SIunits.MassFlowRate mCon4Con_flow_nominal=
      QBld_flow_nominal/dh_nominal
      "Nominal mass flow rate, building 4, connector branch";
    // conBld3
    final parameter Modelica.SIunits.MassFlowRate mCon3Dis_flow_nominal=
      3*QBld_flow_nominal/dh_nominal
      "Nominal mass flow rate, building 3, district main";
    final parameter Modelica.SIunits.MassFlowRate mCon3Con_flow_nominal=
      QBld_flow_nominal/dh_nominal
      "Nominal mass flow rate, building 3, connector branch";
    // conBld12
    final parameter Modelica.SIunits.MassFlowRate mCon12Dis_flow_nominal=
      2*QBld_flow_nominal/dh_nominal
      "Nominal mass flow rate, buildings 1 & 2, district main";
    final parameter Modelica.SIunits.MassFlowRate mCon12Con_flow_nominal=
      QBld_flow_nominal/dh_nominal
      "Nominal mass flow rate, buildings 1 & 2, connector branch";

     // Right branch
     // conBld8
    final parameter Modelica.SIunits.MassFlowRate mCon8Dis_flow_nominal=
      mConPlaCon_flow_nominal
      "Nominal mass flow rate, building 8, district main";
    final parameter Modelica.SIunits.MassFlowRate mCon8Con_flow_nominal=
      QBld_flow_nominal/dh_nominal
      "Nominal mass flow rate, building 8, connector branch";
    // conBld7
    final parameter Modelica.SIunits.MassFlowRate mCon7Dis_flow_nominal=
      3*QBld_flow_nominal/dh_nominal
      "Nominal mass flow rate, building 7, district main";
    final parameter Modelica.SIunits.MassFlowRate mCon7Con_flow_nominal=
      QBld_flow_nominal/dh_nominal
      "Nominal mass flow rate, building 7, connector branch";
    // conBld56
    final parameter Modelica.SIunits.MassFlowRate mCon56Dis_flow_nominal=
      2*QBld_flow_nominal/dh_nominal
      "Nominal mass flow rate, buildings 5 & 6, district main";
    final parameter Modelica.SIunits.MassFlowRate mCon56Con_flow_nominal=
      QBld_flow_nominal/dh_nominal
      "Nominal mass flow rate, buildings 5 & 6, connector branch";

    // Pipe parameters
    parameter Integer nSeg=3 "Number of volume segments";
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
    mPla_flow_nominal=mConPlaDis_flow_nominal,
    QPla_flow_nominal=QPla_flow_nominal,
    pOut_nominal=pSte,
    dp_nominal=6000,
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    a={0.9},
    show_T=true)
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
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

    Buildings.Applications.DHC.Examples.Heating.Generation1.BaseClasses.BuildingTimeSeriesHeating
      bld3(
      redeclare package Medium_a = MediumSte,
      redeclare package Medium_b = MediumWat,
      tableOnFile=tableOnFile,
      QHeaLoa=Q_flow_profile3,
      Q_flow_nominal=QBld_flow_nominal,
      pSte_nominal=pSte,
      tableName=tableName,
      fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Applications/DHC/Examples/FirstGeneration/HeatingSystem-WP3-DESTEST/HeatingLoadProfiles.csv"),
      columns={4},
      timeScale=timeScale,
      show_T=true)
      annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

    Buildings.Applications.DHC.Examples.Heating.Generation1.BaseClasses.BuildingTimeSeriesHeating
      bld4(
      redeclare package Medium_a = MediumSte,
      redeclare package Medium_b = MediumWat,
      tableOnFile=tableOnFile,
      QHeaLoa=Q_flow_profile4,
      Q_flow_nominal=QBld_flow_nominal,
      pSte_nominal=pSte,
      tableName=tableName,
      fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Applications/DHC/Examples/FirstGeneration/HeatingSystem-WP3-DESTEST/HeatingLoadProfiles.csv"),
      columns={5},
      timeScale=timeScale,
      show_T=true)
      annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

    Networks.Connection1stGen4PipeSections conBld4(
      redeclare package MediumSup = MediumSte,
      redeclare package MediumRet = MediumWat,
      mDis_flow_nominal=mCon4Dis_flow_nominal,
      mCon_flow_nominal=mCon4Con_flow_nominal,
      energyDynamics=energyDynamics,
      p_start=pSte,
      T_start=TSte,
      nSeg=nSeg,
      thicknessInsSup=thicknessIns,
      thicknessInsRet=thicknessIns,
      lambdaIns=lambdaIns,
      lengthDisSup=length,
      lengthDisRet=length,
      lengthConSup=length,
      lengthConRet=length) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-30,-46})));
    Networks.Connection1stGen4PipeSections conBld3(
      redeclare package MediumSup = MediumSte,
      redeclare package MediumRet = MediumWat,
      mDis_flow_nominal=mCon3Dis_flow_nominal,
      mCon_flow_nominal=mCon3Con_flow_nominal,
      energyDynamics=energyDynamics,
      p_start=pSte,
      T_start=TSte,
      nSeg=nSeg,
      thicknessInsSup=thicknessIns,
      thicknessInsRet=thicknessIns,
      lambdaIns=lambdaIns,
      lengthDisSup=1,
      lengthDisRet=1,
      lengthConSup=length,
      lengthConRet=length) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-30,-16})));
    Networks.Connection1stGen6PipeSections conBld12(
      redeclare package MediumSup = MediumSte,
      redeclare package MediumRet = MediumWat,
      mDis_flow_nominal=mCon12Dis_flow_nominal,
      mCon_flow_nominal=mCon12Con_flow_nominal,
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
    BaseClasses.BuildingTimeSeriesHeating bld5(
      redeclare package Medium_a = MediumSte,
      redeclare package Medium_b = MediumWat,
      tableOnFile=tableOnFile,
      QHeaLoa=Q_flow_profile5,
      Q_flow_nominal=QBld_flow_nominal,
      pSte_nominal=pSte,
      tableName=tableName,
      fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Applications/DHC/Examples/FirstGeneration/HeatingSystem-WP3-DESTEST/HeatingLoadProfiles.csv"),
      columns={6},
      timeScale=timeScale,
      show_T=true)
      annotation (Placement(transformation(extent={{20,60},{40,80}})));

    BaseClasses.BuildingTimeSeriesHeating bld6(
      redeclare package Medium_a = MediumSte,
      redeclare package Medium_b = MediumWat,
      tableOnFile=tableOnFile,
      QHeaLoa=Q_flow_profile6,
      Q_flow_nominal=QBld_flow_nominal,
      pSte_nominal=pSte,
      tableName=tableName,
      fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Applications/DHC/Examples/FirstGeneration/HeatingSystem-WP3-DESTEST/HeatingLoadProfiles.csv"),
      columns={7},
      timeScale=timeScale,
      show_T=true)
      annotation (Placement(transformation(extent={{20,30},{40,50}})));

    BaseClasses.BuildingTimeSeriesHeating bld7(
      redeclare package Medium_a = MediumSte,
      redeclare package Medium_b = MediumWat,
      tableOnFile=tableOnFile,
      QHeaLoa=Q_flow_profile7,
      Q_flow_nominal=QBld_flow_nominal,
      pSte_nominal=pSte,
      tableName=tableName,
      fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Applications/DHC/Examples/FirstGeneration/HeatingSystem-WP3-DESTEST/HeatingLoadProfiles.csv"),
      columns={8},
      timeScale=timeScale,
      show_T=true)
      annotation (Placement(transformation(extent={{20,-20},{40,0}})));

    BaseClasses.BuildingTimeSeriesHeating bld8(
      redeclare package Medium_a = MediumSte,
      redeclare package Medium_b = MediumWat,
      tableOnFile=tableOnFile,
      QHeaLoa=Q_flow_profile8,
      Q_flow_nominal=QBld_flow_nominal,
      pSte_nominal=pSte,
      tableName=tableName,
      fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Applications/DHC/Examples/FirstGeneration/HeatingSystem-WP3-DESTEST/HeatingLoadProfiles.csv"),
      columns={9},
      timeScale=timeScale,
      show_T=true)
      annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

    Networks.Connection1stGen4PipeSections conBld8(
      redeclare package MediumSup = MediumSte,
      redeclare package MediumRet = MediumWat,
      mDis_flow_nominal=mCon8Dis_flow_nominal,
      mCon_flow_nominal=mCon8Con_flow_nominal,
      energyDynamics=energyDynamics,
      p_start=pSte,
      T_start=TSte,
      nSeg=nSeg,
      thicknessInsSup=thicknessIns,
      thicknessInsRet=thicknessIns,
      lambdaIns=lambdaIns,
      lengthDisSup=length,
      lengthDisRet=length,
      lengthConSup=length,
      lengthConRet=length) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={90,-46})));
    Networks.Connection1stGen4PipeSections conBld7(
      redeclare package MediumSup = MediumSte,
      redeclare package MediumRet = MediumWat,
      mDis_flow_nominal=mCon7Dis_flow_nominal,
      mCon_flow_nominal=mCon7Con_flow_nominal,
      energyDynamics=energyDynamics,
      p_start=pSte,
      T_start=TSte,
      nSeg=nSeg,
      thicknessInsSup=thicknessIns,
      thicknessInsRet=thicknessIns,
      lambdaIns=lambdaIns,
      lengthDisSup=1,
      lengthDisRet=1,
      lengthConSup=length,
      lengthConRet=length) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={90,-16})));
    Networks.Connection1stGen6PipeSections conBld56(
      redeclare package MediumSup = MediumSte,
      redeclare package MediumRet = MediumWat,
      mDis_flow_nominal=mCon56Dis_flow_nominal,
      mCon_flow_nominal=mCon56Con_flow_nominal,
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
          origin={90,34})));
    Networks.Connection1stGen2PipeSections conPla(
      redeclare package MediumSup = MediumSte,
      redeclare package MediumRet = MediumWat,
      mDis_flow_nominal=mConPlaDis_flow_nominal,
      mCon_flow_nominal=mConPlaCon_flow_nominal,
      energyDynamics=energyDynamics,
      p_start=pSte,
      T_start=TSte,
      nSeg=nSeg,
      thicknessInsSup=thicknessIns,
      thicknessInsRet=thicknessIns,
      lambdaIns=lambdaIns,
      lengthDisSup=length,
      lengthDisRet=length)
      annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  equation
    connect(conPla.port_bDisSup,conBld8. port_aDisSup)
      annotation (Line(points={{-20,-110},{90,-110},{90,-56}}, color={0,127,255}));
    connect(pla.port_b, conPla.port_aDisSup)
      annotation (Line(points={{-60,-110},{-40,-110}}, color={0,127,255}));
    connect(conPla.port_bCon, conBld4.port_aDisSup)
      annotation (Line(points={{-30,-100},{-30,-56}}, color={0,127,255}));
    connect(conPla.port_aCon, conBld4.port_bDisRet)
      annotation (Line(points={{-24,-100},{-24,-56}}, color={0,127,255}));
    connect(pla.port_a, conPla.port_bDisRet)
      annotation (Line(points={{-60,-116},{-40,-116}}, color={0,127,255}));
    connect(conPla.port_aDisRet,conBld8. port_bDisRet)
      annotation (Line(points={{-20,-116},{96,-116},{96,-56}}, color={0,127,255}));
    connect(conBld4.port_bCon, bld4.port_a)
      annotation (Line(points={{-40,-46},{-80,-46}}, color={0,127,255}));
    connect(conBld4.port_aCon, bld4.port_b)
      annotation (Line(points={{-40,-40},{-80,-40}}, color={0,127,255}));
    connect(conBld3.port_bCon, bld3.port_a)
      annotation (Line(points={{-40,-16},{-80,-16}}, color={0,127,255}));
    connect(conBld3.port_aCon, bld3.port_b)
      annotation (Line(points={{-40,-10},{-80,-10}}, color={0,127,255}));
    connect(conBld12.port_bCon, bld2.port_a)
      annotation (Line(points={{-40,34},{-80,34}}, color={0,127,255}));
    connect(conBld12.port_aCon, bld2.port_b)
      annotation (Line(points={{-40,40},{-80,40}}, color={0,127,255}));
    connect(conBld12.port_bDisSup, bld1.port_a)
      annotation (Line(points={{-30,44},{-30,64},{-80,64}}, color={0,127,255}));
    connect(conBld12.port_aDisRet, bld1.port_b)
      annotation (Line(points={{-24,44},{-24,70},{-80,70}}, color={0,127,255}));
    connect(conBld4.port_bDisSup, conBld3.port_aDisSup)
      annotation (Line(points={{-30,-36},{-30,-26}}, color={0,127,255}));
    connect(conBld3.port_bDisSup, conBld12.port_aDisSup)
      annotation (Line(points={{-30,-6},{-30,24}}, color={0,127,255}));
    connect(conBld12.port_bDisRet, conBld3.port_aDisRet)
      annotation (Line(points={{-24,24},{-24,-6}},          color={0,127,255}));
    connect(conBld3.port_bDisRet, conBld4.port_aDisRet)
      annotation (Line(points={{-24,-26},{-24,-36}}, color={0,127,255}));
    connect(conBld8.port_bDisSup,conBld7. port_aDisSup)
      annotation (Line(points={{90,-36},{90,-26}},          color={0,127,255}));
    connect(conBld7.port_bDisSup, conBld56.port_aDisSup)
      annotation (Line(points={{90,-6},{90,24}}, color={0,127,255}));
    connect(conBld56.port_bDisRet, conBld7.port_aDisRet)
      annotation (Line(points={{96,24},{96,-6}},         color={0,127,255}));
    connect(conBld7.port_bDisRet,conBld8. port_aDisRet)
      annotation (Line(points={{96,-26},{96,-36}},          color={0,127,255}));
    connect(conBld8.port_bCon, bld8.port_a)
      annotation (Line(points={{80,-46},{40,-46}}, color={0,127,255}));
    connect(conBld8.port_aCon, bld8.port_b)
      annotation (Line(points={{80,-40},{40,-40}}, color={0,127,255}));
    connect(conBld7.port_bCon, bld7.port_a) annotation (Line(points={{80,-16},{40,
            -16}},              color={0,127,255}));
    connect(bld7.port_b,conBld7. port_aCon)
      annotation (Line(points={{40,-10},{80,-10}}, color={0,127,255}));
    connect(conBld56.port_bCon, bld6.port_a) annotation (Line(points={{80,34},{40,
            34}},                 color={0,127,255}));
    connect(bld6.port_b, conBld56.port_aCon) annotation (Line(points={{40,40},{80,
            40}},                 color={0,127,255}));
    connect(conBld56.port_bDisSup, bld5.port_a)
      annotation (Line(points={{90,44},{90,64},{40,64}}, color={0,127,255}));
    connect(conBld56.port_aDisRet, bld5.port_b)
      annotation (Line(points={{96,44},{96,70},{40,70}}, color={0,127,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
                            Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-150,-150},{150,150}})),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DHC/Examples/Heating/Generation1/HeatingSystem.mos"
        "Simulate and plot"),
    experiment(
        StopTime=86400,
        Tolerance=0001,
        __Dymola_Algorithm="Cvode"));
  end HeatingSystem;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains example models for first generation
district heating systems.
</p>
</html>"));
end Generation1;
