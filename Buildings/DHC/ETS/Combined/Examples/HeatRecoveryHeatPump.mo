within Buildings.DHC.ETS.Combined.Examples;
model HeatRecoveryHeatPump
  "Example of the ETS model with heat recovery heat pump"
  extends Modelica.Icons.Example;

  package Medium=Buildings.Media.Water "Medium model";
  parameter String filNam="modelica://Buildings/Resources/Data/DHC/Loads/Examples/MediumOffice-90.1-2010-5A.mos"
    "File name with thermal loads as time series";
  parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=0.9*datHeaPum.mCon_flow_nominal
    "Nominal heating water mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal=0.9*datHeaPum.mEva_flow_nominal
    "Nominal chilled water mass flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(max=-Modelica.Constants.eps)=
    Buildings.DHC.Loads.BaseClasses.getPeakLoad(
      string="#Peak space cooling load",
      filNam=Modelica.Utilities.Files.loadResource(filNam))
      "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal(min=Modelica.Constants.eps)=
    Buildings.DHC.Loads.BaseClasses.getPeakLoad(
      string="#Peak space heating load",
      filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design heat heating flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.Units.SI.ThermodynamicTemperature TChiWatSup_nominal(
     displayUnit="degC") = 7+273.15
    "Nominal chilled water supply temperature"
    annotation (Dialog(group="Chilled water"));
  parameter Modelica.Units.SI.TemperatureDifference dTChiWat_nominal = 5
    "Nominal chilled water temperature difference"
    annotation (Dialog(group="Chilled water"));
  parameter Modelica.Units.SI.ThermodynamicTemperature THeaWatSup_nominal(
     displayUnit="degC") = 45+273.15
    "Nominal heating hot water supply temperature"
    annotation (Dialog(group="Heating hot water"));
  parameter Modelica.Units.SI.TemperatureDifference dTHeaWat_nominal = 10
    "Nominal heating hot water temperature difference"
    annotation (Dialog(group="Heating hot water"));

  parameter Buildings.DHC.ETS.Combined.Data.HeatPump datHeaPum(
    PLRMin=0.2,
    QHeaDes_flow_nominal=max(QHea_flow_nominal, abs(QCoo_flow_nominal)*1.2),
    QCooDes_flow_nominal=QCoo_flow_nominal,
    dTCon_nominal=dTHeaWat_nominal,
    dTEva_nominal=dTChiWat_nominal,
    THeaConLvg_nominal=THeaWatSup_nominal,
    THeaEvaLvg_nominal=TChiWatSup_nominal,
    TCooConLvg_nominal=273.15+31,
    TCooEvaLvg_nominal=TChiWatSup_nominal)
    "Heat recovery heat pump parameters"
    annotation (Placement(transformation(extent={{20,180},{40,200}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(
    k=THeaWatSup_nominal,
    y(final unit="K",
      displayUnit="degC"))
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-200,-38},{-180,-18}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(
    k=TChiWatSup_nominal,
    y(final unit="K",
      displayUnit="degC"))
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-200,-70},{-180,-50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(redeclare package
      Medium = Medium, m_flow_nominal=datHeaPum.mCon_flow_nominal)
    "Heating water supply temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-60,40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTChiWatSup(redeclare package
      Medium = Medium, m_flow_nominal=datHeaPum.mEva_flow_nominal)
    "Chilled water supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,40})));
  Buildings.DHC.ETS.Combined.HeatRecoveryHeatPump ets(
    have_hotWat=false,
    QChiWat_flow_nominal=QCoo_flow_nominal,
    QHeaWat_flow_nominal=QHea_flow_nominal,
    QHotWat_flow_nominal=0,
    dp1Hex_nominal=40E3,
    dp2Hex_nominal=40E3,
    QHex_flow_nominal=QHea_flow_nominal,
    T_a1Hex_nominal=283.65,
    T_b1Hex_nominal=279.65,
    T_a2Hex_nominal=276.65,
    T_b2Hex_nominal=282.65,
    QWSE_flow_nominal=QCoo_flow_nominal,
    VTanHeaWat=datHeaPum.mCon_flow_nominal*dTHeaWat_nominal*5*60/1000,
    VTanChiWat=datHeaPum.mEva_flow_nominal*dTChiWat_nominal*5*60/1000,
    datDhw=datDhw,
    TCon_start=THeaWatSup_nominal,
    TEva_start=TChiWatSup_nominal,
    datHeaPum=datHeaPum) "ETS"
    annotation (Placement(transformation(extent={{-10,-84},{50,-24}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHeaWatRet(
    redeclare final package Medium = Medium,
    m_flow_nominal=datHeaPum.mCon_flow_nominal)
    "Heating water return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-28})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTChiWatRet(
    redeclare final package Medium = Medium,
    m_flow_nominal=datHeaPum.mEva_flow_nominal)
    "Chilled water return temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,0})));
  Buildings.Fluid.Sources.Boundary_pT disWat(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2) "District water boundary conditions" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-140})));
  DHC.ETS.BaseClasses.Pump_m_flow pumChiWat(
    redeclare package Medium = Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    dp_nominal=100E3) "Chilled water distribution pump"
    annotation (Placement(transformation(extent={{110,30},{130,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai2(final k=
        mChiWat_flow_nominal) "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{220,90},{200,110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(final k=
        mHeaWat_flow_nominal) "Scale to nominal mass flow rate"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  DHC.ETS.BaseClasses.Pump_m_flow pumHeaWat(
    redeclare package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    dp_nominal=100E3) "Heating water distribution pump"
    annotation (Placement(transformation(extent={{-10,30},{-30,50}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volHeaWat(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=45 + 273.15,
    final prescribedHeatFlowRate=true,
    redeclare package Medium = Medium,
    V=10,
    final mSenFac=1,
    final m_flow_nominal=mHeaWat_flow_nominal,
    nPorts=2) "Volume for heating water distribution circuit" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-111,0})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai3(final k=-ets.QHeaWat_flow_nominal)
    "Scale to nominal heat flow rate"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow loaHea
    "Heating load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volChiWat(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=7 + 273.15,
    final prescribedHeatFlowRate=true,
    redeclare package Medium = Medium,
    V=10,
    final mSenFac=1,
    final m_flow_nominal=mChiWat_flow_nominal,
    nPorts=2) "Volume for chilled water distribution circuit" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={149,0})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai4(final k=-ets.QChiWat_flow_nominal)
    "Scale to nominal heat flow rate"
    annotation (Placement(transformation(extent={{220,50},{200,70}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow loaCoo
    "Cooling load as prescribed heat flow rate"
    annotation (Placement(transformation(extent={{182,50},{162,70}})));

Modelica.Blocks.Sources.CombiTimeTable TDisWatSup(
    tableName="tab1",
    table=[
        0,11;
        1,12;
        2,13;
        3,14;
        4,15;
        5,16;
        6,17;
        7,18;
        8,20;
        9,18;
        10,16;
        11,13;
        12,11],
    timeScale=2592000,
    offset={273.15},
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-200,-146},{-180,-126}})));

  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(filNam),
    timeScale=1,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0,0},
    columns={2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-330,150},{-310,170}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisWatSup(redeclare final
      package Medium = Medium, final m_flow_nominal=ets.hex.m1_flow_nominal)
    "District water supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-74})));
  Modelica.Blocks.Continuous.Integrator EChi(
    y(unit="J"))
    "Chiller electricity use"
    annotation (Placement(transformation(extent={{300,-70},{320,-50}})));
  Fluid.Sensors.TemperatureTwoPort senTDisWatRet(redeclare final package Medium =
        Medium, final m_flow_nominal=ets.hex.m1_flow_nominal)
    "District water return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={100,-74})));
  parameter
    Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger
    datDhw(
    VTan=datHeaPum.mCon_flow_nominal*dTHeaWat_nominal*5*60/1000,
    mDom_flow_nominal=datDhw.QHex_flow_nominal/4200/(datDhw.TDom_nominal -
        datDhw.TCol_nominal),
    QHex_flow_nominal=if ets.have_hotWat then ets.QHotWat_flow_nominal else ets.QHeaWat_flow_nominal,
    TDom_nominal=323.15)
    "Performance data of the domestic hot water component"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter loaNorHea(
    k=1/ets.QHeaWat_flow_nominal)
    "Normalize by nominal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-270,100})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter loaNorCoo(
    k=1/ets.QChiWat_flow_nominal) "Normalize by nominal" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={290,100})));

equation
  connect(TChiWatSupSet.y,ets.TChiWatSupSet)
    annotation (Line(points={{-178,-60},{-14,-60}},                    color={0,0,127}));
  connect(THeaWatSupSet.y,ets.THeaWatSupSet)
    annotation (Line(points={{-178,-28},{-160,-28},{-160,-56},{-14,-56}},
                                                                       color={0,0,127}));
  connect(pumChiWat.port_a,senTChiWatSup.port_b)
    annotation (Line(points={{110,40},{100,40}},color={0,127,255}));
  connect(gai2.y,pumChiWat.m_flow_in)
    annotation (Line(points={{198,100},{120,100},{120,52}},color={0,0,127}));
  connect(pumHeaWat.port_b,senTHeaWatSup.port_a)
    annotation (Line(points={{-30,40},{-50,40}},color={0,127,255}));
  connect(gai1.y,pumHeaWat.m_flow_in)
    annotation (Line(points={{-158,100},{-20,100},{-20,52}},
                                                      color={0,0,127}));
  connect(gai3.y,loaHea.Q_flow)
    annotation (Line(points={{-158,60},{-140,60}},color={0,0,127}));
  connect(loaHea.port,volHeaWat.heatPort)
    annotation (Line(points={{-120,60},{-112,60},{-112,10},{-111,10}},color={191,0,0}));
  connect(pumChiWat.port_b,volChiWat.ports[1])
    annotation (Line(points={{130,40},{139,40},{139,1}},color={0,127,255}));
  connect(volChiWat.ports[2],senTChiWatRet.port_a)
    annotation (Line(points={{139,-1},{139,0},{100,0}},color={0,127,255}));
  connect(senTHeaWatSup.port_b,volHeaWat.ports[1])
    annotation (Line(points={{-70,40},{-101,40},{-101,1}},color={0,127,255}));
  connect(gai4.y,loaCoo.Q_flow)
    annotation (Line(points={{198,60},{182,60}},color={0,0,127}));
  connect(loaCoo.port,volChiWat.heatPort)
    annotation (Line(points={{162,60},{149,60},{149,10}},color={191,0,0}));
  connect(volHeaWat.ports[2],senTHeaWatRet.port_a)
    annotation (Line(points={{-101,-1},{-101,-28},{-70,-28}},color={0,127,255}));
  connect(TDisWatSup.y[1],disWat.T_in)
    annotation (Line(points={{-179,-136},{-122,-136}},                        color={0,0,127}));
  connect(disWat.ports[1],senTDisWatSup.port_a)
    annotation (Line(points={{-100,-141},{-100,-74},{-70,-74}},color={0,127,255}));
  connect(senTDisWatSup.port_b, ets.port_aSerAmb)
   annotation (Line(points={{-50,-74},{-10,-74}},color={0,127,255}));
  connect(ets.ports_bChiWat[1],senTChiWatSup.port_a)
    annotation (Line(points={{50,-38},{70,-38},{70,40},{80,40}},color={0,127,255}));
  connect(ets.ports_bHeaWat[1],pumHeaWat.port_a)
    annotation (Line(points={{50,-28},{60,-28},{60,40},{-10,40}},
                                                                color={0,127,255}));
  connect(senTHeaWatRet.port_b,ets.ports_aHeaWat[1])
    annotation (Line(points={{-50,-28},{-10,-28}},color={0,127,255}));
  connect(senTChiWatRet.port_b,ets.ports_aChiWat[1])
    annotation (Line(points={{80,0},{-40,0},{-40,-38},{-10,-38}},color={0,127,255}));
  connect(ets.PCoo, EChi.u)
    annotation (Line(points={{54,-50},{60,-50},{60,-60},{298,-60}},color={0,0,127}));
  connect(ets.port_bSerAmb, senTDisWatRet.port_a)
    annotation (Line(points={{50,-74},{90,-74}}, color={0,127,255}));
  connect(senTDisWatRet.port_b, disWat.ports[2])
   annotation (Line(points={{110,-74},{160,-74},{160,-140},{-100,-140},{-100,-139}},color={0,127,255}));
  connect(loa.y[2],loaNorHea.u)
    annotation (Line(points={{-309,160},{-300,160},{-300,100},{-282,100}},
                                                                        color={0,0,127}));
  connect(loa.y[1],loaNorCoo.u)
    annotation (Line(points={{-309,160},{320,160},{320,100},{302,100}},
                                                                     color={0,0,127}));
  connect(loaNorHea.y, gai3.u) annotation (Line(points={{-258,100},{-220,100},{-220,
          60},{-182,60}}, color={0,0,127}));
  connect(loaNorHea.y, gai1.u)
    annotation (Line(points={{-258,100},{-182,100}}, color={0,0,127}));
  connect(loaNorCoo.y, gai4.u) annotation (Line(points={{278,100},{254,100},{254,
          60},{222,60}}, color={0,0,127}));
  connect(loaNorCoo.y, gai2.u)
    annotation (Line(points={{278,100},{222,100}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/ETS/Combined/Examples/HeatRecoveryHeatPump.mos" "Simulate and plot"),
    experiment(
      StartTime=6500000,
      StopTime=7000000,
      Tolerance=1e-06),
    Documentation(
      revisions="<html>
<ul>
<li>
November 4, 2025, by Michael Wetter:<br/>
Refactored model.
</li>
<li>
September 15, 2025, by Hongxiang Fu:<br/>
Updated the ETS component with modular heat pump model.
</li>
<li>
November 22, 2024, by Michael Wetter:<br/>
Removed duplicate connection.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.DHC.ETS.Combined.HeatRecoveryHeatPump\">
Buildings.DHC.ETS.Combined.HeatRecoveryHeatPump</a>
in a system configuration with no geothermal borefield.
</p>
<p>
A load profile based on a whole building energy simulation is used to
represent realistic operating conditions.
The district water supply temperature varies on a monthly basis, with
a minimum in January and a maximum in August.
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-340,-200},{340,220}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end HeatRecoveryHeatPump;
