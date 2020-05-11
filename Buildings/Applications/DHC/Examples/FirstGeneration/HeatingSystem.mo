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
  parameter Integer nSeg=3 "Number of volume segments";
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
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingTimeSeries1stGen bld1(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    timSer_norHeaLoa=Q_flow_profile1,
    QPea_flow_real=QBld1_flow_nominal,
    pSte_nominal=pSte_nominal)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingTimeSeries1stGen bld2(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    timSer_norHeaLoa=Q_flow_profile1,
    QPea_flow_real=QBld2_flow_nominal,
    pSte_nominal=pSte_nominal)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingTimeSeries1stGen bld3(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    timSer_norHeaLoa=Q_flow_profile2,
    QPea_flow_real=QBld3_flow_nominal,
    pSte_nominal=pSte_nominal)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingTimeSeries1stGen bld4(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    timSer_norHeaLoa=Q_flow_profile2,
    QPea_flow_real=QBld4_flow_nominal,
    pSte_nominal=pSte_nominal)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Applications.DHC.Controls.HeatingSystemControl plaCon(nu=8,
      QPla_flow_nominal=QPla_flow_nominal)
    annotation (Placement(transformation(extent={{-80,100},{-100,120}})));
  Networks.Connection1stGen4PipeSections conBld4(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
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
        origin={-30,-56})));
  Networks.Connection1stGen4PipeSections conBld3(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
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
        origin={-30,-16})));
  Networks.Connection1stGen6PipeSections conBld2(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
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
        origin={-30,24})));
  Loads.Examples.BaseClasses.BuildingTimeSeries1stGen bld5(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    timSer_norHeaLoa=Q_flow_profile1,
    QPea_flow_real=QBld1_flow_nominal,
    pSte_nominal=pSte_nominal)
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Loads.Examples.BaseClasses.BuildingTimeSeries1stGen bld6(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    timSer_norHeaLoa=Q_flow_profile1,
    QPea_flow_real=QBld2_flow_nominal,
    pSte_nominal=pSte_nominal)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Loads.Examples.BaseClasses.BuildingTimeSeries1stGen bld7(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    timSer_norHeaLoa=Q_flow_profile2,
    QPea_flow_real=QBld3_flow_nominal,
    pSte_nominal=pSte_nominal)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Loads.Examples.BaseClasses.BuildingTimeSeries1stGen bld8(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    timSer_norHeaLoa=Q_flow_profile2,
    QPea_flow_real=QBld4_flow_nominal,
    pSte_nominal=pSte_nominal)
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Networks.Connection1stGen4PipeSections conBld1(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
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
        origin={90,-56})));
  Networks.Connection1stGen4PipeSections conBld5(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
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
        origin={90,-16})));
  Networks.Connection1stGen6PipeSections conBld6(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
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
        origin={90,24})));
  Networks.Connection1stGen2PipeSections conPla(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    nSeg=nSeg,
    thicknessInsSup=thicknessIns,
    thicknessInsRet=thicknessIns,
    lambdaIns=lambdaIns,
    lengthDisSup=length,
    lengthDisRet=length)
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
equation
  connect(plaCon.y, pla.y) annotation (Line(points={{-101,110},{-120,110},{-120,-102},
          {-81,-102}},       color={0,0,127}));
  connect(plaCon.QBld_flow[1], bld1.Q_flow) annotation (Line(points={{-80,108.25},{-80,
          110},{-60,110},{-60,78},{-79,78}},      color={0,0,127}));
  connect(bld2.Q_flow, plaCon.QBld_flow[2]) annotation (Line(points={{-79,38},{-60,38},
          {-60,110},{-80,110},{-80,108.75}},    color={0,0,127}));
  connect(bld3.Q_flow, plaCon.QBld_flow[3]) annotation (Line(points={{-79,-2},{-60,-2},
          {-60,110},{-80,110},{-80,109.25}},
                                        color={0,0,127}));
  connect(bld4.Q_flow, plaCon.QBld_flow[4]) annotation (Line(points={{-79,-42},{-60,
          -42},{-60,110},{-80,110},{-80,109.75}},
                                                color={0,0,127}));
  connect(conPla.port_bDisSup, conBld1.port_aDisSup)
    annotation (Line(points={{-20,-110},{90,-110},{90,-66}}, color={0,127,255}));
  connect(pla.port_b, conPla.port_aDisSup)
    annotation (Line(points={{-60,-110},{-40,-110}}, color={0,127,255}));
  connect(conPla.port_bCon, conBld4.port_aDisSup)
    annotation (Line(points={{-30,-100},{-30,-66}}, color={0,127,255}));
  connect(conPla.port_aCon, conBld4.port_bDisRet)
    annotation (Line(points={{-24,-100},{-24,-66}}, color={0,127,255}));
  connect(pla.port_a, conPla.port_bDisRet)
    annotation (Line(points={{-60,-116},{-40,-116}}, color={0,127,255}));
  connect(conPla.port_aDisRet, conBld1.port_bDisRet)
    annotation (Line(points={{-20,-116},{96,-116},{96,-66}}, color={0,127,255}));
  connect(conBld4.port_bCon, bld4.port_a)
    annotation (Line(points={{-40,-56},{-80,-56}}, color={0,127,255}));
  connect(conBld4.port_aCon, bld4.port_b)
    annotation (Line(points={{-40,-50},{-80,-50}}, color={0,127,255}));
  connect(conBld3.port_bCon, bld3.port_a)
    annotation (Line(points={{-40,-16},{-80,-16}}, color={0,127,255}));
  connect(conBld3.port_aCon, bld3.port_b)
    annotation (Line(points={{-40,-10},{-80,-10}}, color={0,127,255}));
  connect(conBld2.port_bCon, bld2.port_a)
    annotation (Line(points={{-40,24},{-80,24}}, color={0,127,255}));
  connect(conBld2.port_aCon, bld2.port_b)
    annotation (Line(points={{-40,30},{-80,30}}, color={0,127,255}));
  connect(conBld2.port_bDisSup, bld1.port_a)
    annotation (Line(points={{-30,34},{-30,64},{-80,64}}, color={0,127,255}));
  connect(conBld2.port_aDisRet, bld1.port_b)
    annotation (Line(points={{-24,34},{-24,70},{-80,70}}, color={0,127,255}));
  connect(conBld4.port_bDisSup, conBld3.port_aDisSup)
    annotation (Line(points={{-30,-46},{-30,-26}}, color={0,127,255}));
  connect(conBld3.port_bDisSup, conBld2.port_aDisSup)
    annotation (Line(points={{-30,-6},{-30,14}}, color={0,127,255}));
  connect(conBld2.port_bDisRet, conBld3.port_aDisRet)
    annotation (Line(points={{-24,14},{-24,14},{-24,-6}}, color={0,127,255}));
  connect(conBld3.port_bDisRet, conBld4.port_aDisRet)
    annotation (Line(points={{-24,-26},{-24,-46}}, color={0,127,255}));
  connect(conBld1.port_bDisSup, conBld5.port_aDisSup)
    annotation (Line(points={{90,-46},{90,-46},{90,-26}}, color={0,127,255}));
  connect(conBld5.port_bDisSup, conBld6.port_aDisSup)
    annotation (Line(points={{90,-6},{90,14}}, color={0,127,255}));
  connect(conBld6.port_bDisRet, conBld5.port_aDisRet)
    annotation (Line(points={{96,14},{96,14},{96,-6}}, color={0,127,255}));
  connect(conBld5.port_bDisRet, conBld1.port_aDisRet)
    annotation (Line(points={{96,-26},{96,-26},{96,-46}}, color={0,127,255}));
  connect(conBld1.port_bCon, bld8.port_a)
    annotation (Line(points={{80,-56},{40,-56}}, color={0,127,255}));
  connect(conBld1.port_aCon, bld8.port_b)
    annotation (Line(points={{80,-50},{40,-50}}, color={0,127,255}));
  connect(conBld5.port_bCon, bld7.port_a) annotation (Line(points={{80,-16},{60,-16},
          {60,-16},{40,-16}}, color={0,127,255}));
  connect(bld7.port_b, conBld5.port_aCon)
    annotation (Line(points={{40,-10},{80,-10}}, color={0,127,255}));
  connect(conBld6.port_bCon, bld6.port_a)
    annotation (Line(points={{80,24},{60,24},{60,24},{40,24}}, color={0,127,255}));
  connect(bld6.port_b, conBld6.port_aCon)
    annotation (Line(points={{40,30},{60,30},{60,30},{80,30}}, color={0,127,255}));
  connect(conBld6.port_bDisSup, bld5.port_a)
    annotation (Line(points={{90,34},{90,64},{40,64}}, color={0,127,255}));
  connect(conBld6.port_aDisRet, bld5.port_b)
    annotation (Line(points={{96,34},{96,70},{40,70}}, color={0,127,255}));
  connect(bld5.Q_flow, plaCon.QBld_flow[5]) annotation (Line(points={{41,78},{60,78},
          {60,110.25},{-80,110.25}}, color={0,0,127}));
  connect(bld6.Q_flow, plaCon.QBld_flow[6]) annotation (Line(points={{41,38},{60,38},
          {60,110},{-80,110},{-80,110.75}}, color={0,0,127}));
  connect(bld7.Q_flow, plaCon.QBld_flow[7]) annotation (Line(points={{41,-2},{60,-2},
          {60,110},{-80,110},{-80,111.25}}, color={0,0,127}));
  connect(bld8.Q_flow, plaCon.QBld_flow[8]) annotation (Line(points={{41,-42},{60,-42},
          {60,110},{-80,110},{-80,111.75}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-150,-150},{150,150}})));
end HeatingSystem;
