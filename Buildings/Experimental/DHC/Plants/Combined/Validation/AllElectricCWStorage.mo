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
      EIRFunT={0.0101739374, 0.0607200115, 0.0003348647, 0.003162578, 0.0002388594, -0.0014121289},
      capFunT={0.0387084662, 0.2305017927, 0.0004779504, 0.0178244359, -8.48808e-05, -0.0032406711},
      EIRFunPLR={0.4304252832, -0.0144718912, 5.12039e-05, -0.7562386674, 0.5661683373,
        0.0406987748, 3.0278e-06, -0.3413411197, -0.000469572, 0.0055009208},
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
        origin={-60,-150})));
  Buildings.Experimental.DHC.Plants.Combined.AllElectricCWStorage pla(
    redeclare final package Medium = Medium,
    final datChi=datChi,
    final datChiHea=datChiHea,
    nChi=2,
    dpChiWatSet_max=20E4,
    nChiHea=2,
    dpHeaWatSet_max=20E4,
    nPumConWatCon=2,
    dIns=0.05,
    nCoo=3,
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
        origin={-60,150})));
  Fluid.FixedResistances.PressureDrop disChiWat(
    redeclare final package Medium = Medium,
    m_flow_nominal=pla.mChiWat_flow_nominal,
    dp_nominal=pla.dpChiWatSet_max)
    "CHW distribution system approximated by fixed flow resistance"
    annotation (Placement(transformation(extent={{10,-150},{-10,-130}})));
  Fluid.FixedResistances.PressureDrop disHeaWat(
    redeclare final package Medium = Medium,
    m_flow_nominal=pla.mHeaWat_flow_nominal,
    dp_nominal=pla.dpHeaWatSet_max)
    "HW distribution system approximated by fixed flow resistance"
    annotation (Placement(transformation(extent={{10,130},{-10,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TChiWatSupSet(
    y(final unit="K", displayUnit="degC"),
    height=+3,
    duration=100,
    offset=pla.TChiWatSup_nominal,
    startTime=600) "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp THeaWatSupSet(
    y(final unit="K", displayUnit="degC"),
    height=-5,
    duration=100,
    offset=pla.THeaWatSup_nominal,
    startTime=600) "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dpHeaWatSet_max(
    y(final unit="Pa"),
    height=-0.5*pla.dpHeaWatSet_max,
    duration=100,
    offset=pla.dpHeaWatSet_max,
    startTime=600) "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dpChiWatSet_max(
    y(final unit="Pa"),
    height=-0.5*pla.dpChiWatSet_max,
    duration=100,
    offset=pla.dpChiWatSet_max,
    startTime=600) "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Outdoor conditions"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,100})));
equation
  connect(bouChiWat.ports[1], pla.port_aSerCoo)
    annotation (Line(points={{-61,-140},{-61,-4},{-30,-4}},color={0,127,255}));
  connect(bouHeaWat.ports[1], pla.port_aSerHea)
    annotation (Line(points={{-61,140},{-61,0},{-30,0}},color={0,127,255}));
  connect(disChiWat.port_b, bouChiWat.ports[2])
    annotation (Line(points={{-10,-140},{-59,-140}}, color={0,127,255}));
  connect(disHeaWat.port_b, bouHeaWat.ports[2])
    annotation (Line(points={{-10,140},{-59,140}}, color={0,127,255}));
  connect(TChiWatSupSet.y, pla.TChiWatSupSet) annotation (Line(points={{-138,60},
          {-80,60},{-80,28},{-34,28}}, color={0,0,127}));
  connect(THeaWatSupSet.y, pla.THeaWatSupSet) annotation (Line(points={{-138,-20},
          {-80,-20},{-80,20},{-34,20}}, color={0,0,127}));
  connect(dpChiWatSet_max.y, pla.dpChiWatSet) annotation (Line(points={{-138,20},
          {-82,20},{-82,24},{-34,24}}, color={0,0,127}));
  connect(dpHeaWatSet_max.y, pla.dpHeaWatSet) annotation (Line(points={{-138,-60},
          {-78,-60},{-78,16},{-34,16}}, color={0,0,127}));

  connect(weaDat.weaBus, pla.weaBus) annotation (Line(
      points={{-140,100},{0.1,100},{0.1,26.6}},
      color={255,204,51},
      thickness=0.5));
  connect(pla.port_bSerCoo, disChiWat.port_a) annotation (Line(points={{30,-4},
          {60,-4},{60,-140},{10,-140}}, color={0,127,255}));
  connect(pla.port_bSerHea, disHeaWat.port_a) annotation (Line(points={{30,0},{
          60,0},{60,140},{10,140}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Combined/Validation/AllElectricCWStorage.mos"
      "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
  Diagram(coordinateSystem(extent={{-180,-180},{180,180}})));
end AllElectricCWStorage;
