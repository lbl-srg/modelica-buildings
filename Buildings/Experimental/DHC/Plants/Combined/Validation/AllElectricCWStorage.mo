within Buildings.Experimental.DHC.Plants.Combined.Validation;
model AllElectricCWStorage "Validation of the all-electric plant with CW storage model"
  extends Modelica.Icons.Example;

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Main medium (common to CHW, HW and CW)";
  replaceable package MediumCoo=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in cooler circuit";

  replaceable parameter
    Fluid.Chillers.Data.ElectricReformulatedEIR.ReformEIRChiller_Carrier_19XR_1403kW_7_09COP_VSD datChi(
      EIRFunT={0.0102183573, 0.0609952315, 0.000378345, 0.0030687392, 0.0002409478, -0.0014270486},
      capFunT={0.0463224798, 0.2784471296, 0.0004621597, -0.0060446448, 0.000291609, -0.0039960856},
      EIRFunPLR={-0.466382549, 0.0461035091, -0.0013098646, -0.2357674875, 0.4153191238,
        0.0146733483, 1.28175e-05, -0.2627343101, -0.0001503581, 0.0048562928},
      QEva_flow_nominal=-1E6,
      COP_nominal=2.5,
      mEva_flow_nominal=20,
      mCon_flow_nominal=22,
      TEvaLvg_nominal=279.15,
      TEvaLvgMin=277.15,
      TEvaLvgMax=308.15,
      TConLvg_nominal=333.15,
      TConLvgMin=296.15,
      TConLvgMax=336.15)
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller parameters (each unit)"
    annotation (
      Dialog(group="CHW loop and cooling-only chillers"),
      Placement(transformation(extent={{80,110},{100,130}})));
  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic datChiHea=
    datChi
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller parameters (each unit)"
    annotation (
      Dialog(group="HW loop and heat recovery chillers"),
      Placement(transformation(extent={{110,110},{130,130}})));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Fluid.Sources.Boundary_pT bouChiWat(
    T=285.15,
    nPorts=2,
    redeclare final package Medium = Medium,
    p=200000) "Boundary conditions for CHW"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-60,-110})));
  Buildings.Experimental.DHC.Plants.Combined.AllElectricCWStorage pla(
    redeclare final package Medium = Medium,
    final datChi=datChi,
    final datChiHea=datChiHea,
    nChi=2,
    dpChiWatSet_max=20E4,
    nChiHea=2,
    dpHeaWatSet_max=20E4,
    final energyDynamics=energyDynamics)
    "CHW and HW plant"
    annotation (Placement(transformation(extent={{-30,-30},{30,30}})));
  Fluid.Sources.Boundary_pT bouHeaWat(
    T=318.15,
    nPorts=2,
    redeclare final package Medium = Medium,
    p=200000) "Boundary conditions for HW" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,110})));
  Fluid.FixedResistances.PressureDrop disChiWat(
    redeclare final package Medium = Medium,
    m_flow_nominal=pla.mChiWat_flow_nominal,
    dp_nominal=pla.dpChiWatSet_max)
    "CHW distribution system approximated by fixed flow resistance"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));
  Fluid.FixedResistances.PressureDrop disHeaWat(
    redeclare final package Medium = Medium,
    m_flow_nominal=pla.mHeaWat_flow_nominal,
    dp_nominal=pla.dpHeaWatSet_max)
    "HW distribution system approximated by fixed flow resistance"
    annotation (Placement(transformation(extent={{10,90},{-10,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TChiWatSupSet(
    y(final unit="K", displayUnit="degC"),
    height=+3,
    duration=100,
    offset=pla.TChiWatSup_nominal,
    startTime=600) "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp THeaWatSupSet(
    y(final unit="K", displayUnit="degC"),
    height=-5,
    duration=100,
    offset=pla.THeaWatSup_nominal,
    startTime=600) "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dpHeaWatSet_max(
    y(final unit="Pa"),
    height=-0.5*pla.dpHeaWatSet_max,
    duration=100,
    offset=pla.dpHeaWatSet_max,
    startTime=600) "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dpChiWatSet_max(
    y(final unit="Pa"),
    height=-0.5*pla.dpChiWatSet_max,
    duration=100,
    offset=pla.dpChiWatSet_max,
    startTime=600) "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=pla.mChiWat_flow_nominal)
    "CHW supply temperature"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-50})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=pla.mHeaWat_flow_nominal)
    "HW supply temperature"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,50})));
equation
  connect(bouChiWat.ports[1], pla.port_aSerCoo)
    annotation (Line(points={{-61,-100},{-61,-4},{-30,-4}},color={0,127,255}));
  connect(bouHeaWat.ports[1], pla.port_aSerHea)
    annotation (Line(points={{-61,100},{-61,0},{-30,0}},color={0,127,255}));
  connect(disChiWat.port_b, bouChiWat.ports[2])
    annotation (Line(points={{-10,-100},{-59,-100}}, color={0,127,255}));
  connect(disHeaWat.port_b, bouHeaWat.ports[2])
    annotation (Line(points={{-10,100},{-59,100}}, color={0,127,255}));
  connect(TChiWatSupSet.y, pla.TChiWatSupSet) annotation (Line(points={{-98,60},
          {-40,60},{-40,28},{-34,28}}, color={0,0,127}));
  connect(THeaWatSupSet.y, pla.THeaWatSupSet) annotation (Line(points={{-98,-20},
          {-40,-20},{-40,20},{-34,20}}, color={0,0,127}));
  connect(dpChiWatSet_max.y, pla.dpChiWatSet) annotation (Line(points={{-98,20},
          {-42,20},{-42,24},{-34,24}}, color={0,0,127}));
  connect(dpHeaWatSet_max.y, pla.dpHeaWatSet) annotation (Line(points={{-98,-60},
          {-38,-60},{-38,16},{-34,16}}, color={0,0,127}));

  connect(pla.port_bSerCoo, TChiWatSup.port_a)
    annotation (Line(points={{30,-4},{60,-4},{60,-40}}, color={0,127,255}));
  connect(TChiWatSup.port_b, disChiWat.port_a) annotation (Line(points={{60,-60},
          {60,-100},{10,-100}}, color={0,127,255}));
  connect(pla.port_bSerHea, THeaWatSup.port_a)
    annotation (Line(points={{30,0},{60,0},{60,40}}, color={0,127,255}));
  connect(THeaWatSup.port_b, disHeaWat.port_a)
    annotation (Line(points={{60,60},{60,100},{10,100}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Combined/Validation/AllElectricCWStorage.mos"
      "Simulate and plot"),
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
  Diagram(coordinateSystem(extent={{-140,-140},{140,140}})));
end AllElectricCWStorage;
