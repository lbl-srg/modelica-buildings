within Buildings.Experimental.DHC.Plants.Combined.Validation;
model AllElectricCWStorage "Validation of all-electric plant model"
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
      Placement(transformation(extent={{80,140},{100,160}})));
  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic datChiHea=
    datChi
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller parameters (each unit)"
    annotation (
      Dialog(group="HW loop and heat recovery chillers"),
      Placement(transformation(extent={{110,140},{130,160}})));
  replaceable parameter Fluid.HeatPumps.Data.EquationFitReversible.Generic datHeaPum(
    dpHeaLoa_nominal=50000,
    dpHeaSou_nominal=100,
    hea(
      mLoa_flow=datHeaPum.hea.Q_flow / 10 / 4186,
      mSou_flow=1E-4 * datHeaPum.hea.Q_flow,
      Q_flow=1E6,
      P=datHeaPum.hea.Q_flow / 2.2,
      coeQ={-5.64420084,  1.95212447,  9.96663913,  0.23316322, -5.64420084},
      coeP={-3.96682255,  6.8419453,   1.99606939,  0.01393387, -3.96682255},
      TRefLoa=298.15,
      TRefSou=253.15),
    coo(
      mLoa_flow=0,
      mSou_flow=0,
      Q_flow=-1,
      P=0,
      coeQ=fill(0, 5),
      coeP=fill(0, 5),
      TRefLoa=273.15,
      TRefSou=273.15))
    "Heat pump parameters (each unit)"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Buildings.Experimental.DHC.Plants.Combined.AllElectricCWStorage pla(
    allowFlowReversal=true,
    dpConWatCooFri_nominal=1E4,
    mAirCoo_flow_nominal=pla.mConWatCoo_flow_nominal/1.45,
    TWetBulCooEnt_nominal=297.05,
    PFanCoo_nominal=340*pla.mConWatCoo_flow_nominal,
    chi(show_T=true),
    chiHea(show_T=true),
    heaPum(show_T=true),
    redeclare final package Medium = Medium,
    final datChi=datChi,
    final datChiHea=datChiHea,
    final datHeaPum=datHeaPum,
    nChi=2,
    dpChiWatSet_max=20E4,
    nChiHea=2,
    dpHeaWatSet_max=20E4,
    nHeaPum=2,
    nPumConWatCon=2,
    dInsTan=0.05,
    nCoo=3,
    final energyDynamics=energyDynamics)
    "CHW and HW plant"
    annotation (Placement(transformation(extent={{-30,-30},{30,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TChiWatSupSet(
    y(final unit="K", displayUnit="degC"),
    height=+3,
    duration=100,
    offset=pla.TChiWatSup_nominal,
    startTime=2000)
                   "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp THeaWatSupSet(
    y(final unit="K", displayUnit="degC"),
    height=-5,
    duration=100,
    offset=pla.THeaWatSup_nominal,
    startTime=1000)
                   "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpHeaWatSet_max(k=pla.dpHeaWatSet_max,
    y(final unit="Pa")) "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet_max(k=pla.dpChiWatSet_max,
    y(final unit="Pa")) "Source signal for setpoint"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Outdoor conditions"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,100})));
  Fluid.HeatExchangers.SensibleCooler_T disHeaWat(
    redeclare final package Medium = Medium,
    m_flow_nominal=pla.mHeaWat_flow_nominal,
    dp_nominal=pla.dpHeaWatSet_max)
    "HW distribution system approximated by fixed flow resistance and prescribed return temperature"
    annotation (Placement(transformation(extent={{12,130},{-8,150}})));
  Fluid.HeatExchangers.Heater_T disChiWat(
    redeclare final package Medium = Medium,
    m_flow_nominal=pla.mChiWat_flow_nominal,
    dp_nominal=pla.dpChiWatSet_max)
    "CHW distribution system approximated by fixed flow resistance and prescribed return temperature"
    annotation (Placement(transformation(extent={{10,-150},{-10,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatRet(k=pla.THeaWatSup_nominal
         - 10,y(final unit="K", displayUnit="degC"))
    "Source signal for HW return temperature"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatRet(k=pla.TChiWatSup_nominal
         + 5, y(final unit="K", displayUnit="degC"))
    "Source signal for CHW return temperature"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1(
    table=[0,0; 0.1,0; 0.1,1; 0.9,1; 0.9,0; 1,0],
    timeScale=3600,
    period=3600) "Plant enable signal"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
equation
  connect(TChiWatSupSet.y, pla.TChiWatSupSet) annotation (Line(points={{-138,20},
          {-34,20}},                   color={0,0,127}));
  connect(THeaWatSupSet.y, pla.THeaWatSupSet) annotation (Line(points={{-138,
          -20},{-76,-20},{-76,16},{-34,16}},
                                        color={0,0,127}));
  connect(dpChiWatSet_max.y, pla.dpChiWatSet) annotation (Line(points={{-138,
          -60},{-80,-60},{-80,12},{-34,12}},
                                       color={0,0,127}));
  connect(dpHeaWatSet_max.y, pla.dpHeaWatSet) annotation (Line(points={{-138,
          -100},{-72,-100},{-72,8},{-34,8}},
                                        color={0,0,127}));

  connect(weaDat.weaBus, pla.weaBus) annotation (Line(
      points={{-140,100},{0.1,100},{0.1,26.6}},
      color={255,204,51},
      thickness=0.5));
  connect(pla.port_bSerHea, disHeaWat.port_a) annotation (Line(points={{30,0},{
          60,0},{60,140},{12,140}}, color={0,127,255}));
  connect(pla.port_bSerCoo, disChiWat.port_a) annotation (Line(points={{30,-4},
          {60,-4},{60,-140},{10,-140}},color={0,127,255}));
  connect(disChiWat.port_b, pla.port_aSerCoo) annotation (Line(points={{-10,
          -140},{-60,-140},{-60,-4},{-30,-4}},
                                         color={0,127,255}));
  connect(disHeaWat.port_b, pla.port_aSerHea) annotation (Line(points={{-8,140},
          {-60,140},{-60,0},{-30,0}}, color={0,127,255}));
  connect(THeaWatRet.y, disHeaWat.TSet) annotation (Line(points={{-138,160},{20,
          160},{20,148},{14,148}}, color={0,0,127}));
  connect(TChiWatRet.y, disChiWat.TSet) annotation (Line(points={{-138,-160},{
          20,-160},{20,-132},{12,-132}},
                                      color={0,0,127}));
  connect(u1.y[1], pla.u1Coo) annotation (Line(points={{-138,60},{-40,60},{-40,
          28},{-34,28}}, color={255,0,255}));
  connect(u1.y[1], pla.u1Hea) annotation (Line(points={{-138,60},{-40,60},{-40,
          24},{-34,24}}, color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Combined/Validation/AllElectricCWStorage.mos"
      "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
  Diagram(coordinateSystem(extent={{-180,-180},{180,180}})));
end AllElectricCWStorage;
