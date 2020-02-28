within Buildings.Applications.DHC.EnergyTransferStations.Examples;
model ETS_ClosedLoop
  "ETS example using EIRchiller and constant speed pumps"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=datChi.mEva_flow_nominal
    "Evaporator heat exchanger nominal mass flow rate"
    annotation (Dialog(group="EIR Chiller system"));
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=datChi.mCon_flow_nominal
    "Condenser heat exchanger nominal mass flow rate"
    annotation (Dialog(group="EIR Chiller system"));
  parameter Modelica.SIunits.PressureDifference dpCon_nominal=33530
    "Pressure difference accross the condenser"
      annotation (Dialog(group="EIR Chiller system"));
  parameter Modelica.SIunits.PressureDifference dpEva_nominal=32460
    "Pressure difference accross the evaporator"
      annotation (Dialog(group="EIR Chiller system"));
  parameter Modelica.SIunits.MassFlowRate mSecHea_flow_nominal=15
   "Secondary(building side) heatig water nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mSecCoo_flow_nominal=8
   "Secondary(building side) cooling water nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal = 3
   "Ambient(district) circuit water mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mSecHea=15
   "Secondary(building side) heatig water actual mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mSecCoo=7
   "Secondary(building side) cooling water actual mass flow rate";

  Buildings.Applications.DHC.EnergyTransferStations.Substation ETS(
    datChi=datChi,
    mCon_flow_nominal=mCon_flow_nominal,
    mEva_flow_nominal=mEva_flow_nominal,
    dpCon_nominal=dpCon_nominal,
    dpEva_nominal=dpEva_nominal,
    mSecHea_flow_nominal=mSecHea_flow_nominal,
    mSecCoo_flow_nominal=mSecCoo_flow_nominal,
    dTChi=2,
    dTGeo=2,
    dTHex=5,
    xBorFie=datGeo.lBorFie[1],
    yBorFie=datGeo.wBorFie[1],
    dpBorFie_nominal=datGeo.dpBor_nominal,
    THys=1.5)
    "Energy transfer station for the 5th generation of district heating and cooling"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Fluid.Sources.MassFlowSource_T disPum(
    m_flow=mDis_flow_nominal,
    use_T_in=true,
    redeclare package Medium = Medium,
    nPorts=1) "District system water pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,-50})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDisEnt(k=16 + 273.15)
    "District heat exchanger entering water temperature"
      annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Applications.DHC.EnergyTransferStations.Data.DesignDataGeothermal datGeo(
    lBorFie={70,90,40,70,120}*0.5,
    wBorFie={44,50,40,40,40})
    "Borfield system performance data"
      annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_816kW_6_74COP_Vanes datChi
    "EIR performance data."
      annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Fluid.Movers.FlowControlled_m_flow pumCoo(
    redeclare package Medium = Medium,
    m_flow_nominal=mSecCoo,
    addPowerToMedium=false,
    show_T=true,
    allowFlowReversal=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=true,
    riseTime=180,
    dp_nominal=500000)
    "Cooling water pump-secondary circuit"
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse mSecCooRet(
    amplitude=mSecCoo,
    width=0.75,
    period=2*3600,
    offset=0,
    startTime=2*3600)
    "Secondary (building side) cooling water flow rate"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Fluid.MixingVolumes.MixingVolume cooVol(
    redeclare package Medium = Medium,
    T_start=285.15,
    m_flow_nominal=mSecCoo,
    V=mSecCoo/1000*60*60,
    nPorts=2)
    "Mixing volume mimics a room to be cooled"
      annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-30,-10})));
  Modelica.Blocks.Math.Gain Q_flow_Coo(k=1*4200)
    "Heat added to the volume"
      annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  HeatTransfer.Sources.PrescribedHeatFlow heaFloPos
    "Prescribed added heat flow rate(positive)"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Fluid.Movers.FlowControlled_m_flow pumHea(
    redeclare package Medium = Medium,
    m_flow_nominal=mSecHea,
    addPowerToMedium=false,
    show_T=true,
    allowFlowReversal=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=true,
    riseTime=30,
    dp_nominal=500000)
    "Heating pump-secondary circuit"
      annotation (Placement(transformation(extent={{100,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse mSecHeaRet(
    amplitude=mSecHea,
    width=0.3,
    period=3*3600,
    offset=0)
    "Secondary (building side) heating water flow rate"
      annotation (Placement(transformation(extent={{160,60},{140,80}})));
  Fluid.MixingVolumes.MixingVolume heaVol(
    redeclare package Medium = Medium,
    T_start=298.15,
    m_flow_nominal=mSecHea,
    V=mSecHea/1000*60*60,
    nPorts=2)
    "Mixing volume mimics zones to be heated"
      annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={30,-10})));
  Modelica.Blocks.Math.Gain Q_flow_Hea(k=-1*4200)
    "Heat extracted from the volume" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-10})));
  HeatTransfer.Sources.PrescribedHeatFlow heaFloNeg
    "Prescribed extracted heat flow rate (negative)"
    annotation (Placement(transformation(extent={{80,-20},{60,0}})));
    Fluid.Sensors.TemperatureTwoPort retChiWat(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mEva_flow_nominal,
    tau=30)
    "Evaporator entering water temperature"
      annotation (Placement(transformation(extent={{-80,10},{-100,30}})));
    Fluid.Sensors.TemperatureTwoPort supChiWat(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mEva_flow_nominal,
    tau=30)
    "Evaporator leaving water temperature"
       annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-18,30})));
    Fluid.Sensors.TemperatureTwoPort retHeaWat(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mEva_flow_nominal,
    tau=30)
    "Condenser entering water temperature"
      annotation (Placement(transformation(extent={{100,10},{120,30}})));
    Fluid.Sensors.TemperatureTwoPort supHeaWat(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mEva_flow_nominal,
    tau=30)
    "Condenser leaving water temperature"
      annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={14,30})));
  Fluid.Sources.Boundary_pT disLoa(
    redeclare package Medium = Medium,
    nPorts=1)
    "Sink for the district system"
      annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
  Fluid.FixedResistances.PressureDrop disPD(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    final m_flow_nominal=mDis_flow_nominal,
    homotopyInitialization=false,
    final deltaM=0.3,
    final show_T=false,
    final dp_nominal=5000)
   "Flow resistance"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  BaseClasses.Constants mulCon(
    k={29 + 273.15,10 + 273.15,5 + 273.15,12 + 273.15,17 + 273.15,40 + 273.15},
    conNam={"TSetHea","TSetCoo","TSetCooMin","TMinConEnt","TMaxEvaEnt",
        "TBorMaxEnt"},
    nCon=6)
    "Multiple constant functions"
    annotation (Placement(transformation(extent={{6,98},{-14,118}})));

  Modelica.Fluid.Sources.FixedBoundary pre(
    redeclare package Medium = Medium,
    nPorts=1)
    "Pressure source"
   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,50})));
equation
  connect(TDisEnt.y, disPum.T_in)
    annotation (Line(points={{-98,-50},{-70,-50},{-70,-54},{-42,-54}},
                                                  color={0,0,127}));
  connect(disPum.ports[1], ETS.disWatSup)
    annotation (Line(points={{-20,-50},{-2,-50},{-2,50}},
                            color={0,127,255}));
  connect(heaFloPos.port, cooVol.heatPort)
    annotation (Line(points={{-60,-10},{-40,-10}}, color={191,0,0}));
  connect(Q_flow_Coo.y, heaFloPos.Q_flow)
    annotation (Line(points={{-99,-10},{-80,-10}},  color={0,0,127}));
  connect(mSecCooRet.y, Q_flow_Coo.u)
    annotation (Line(points={{-138,70},{-128,
          70},{-128,-10},{-122,-10}},  color={0,0,127}));
  connect(heaVol.heatPort, heaFloNeg.port)
    annotation (Line(points={{40,-10},{60,-10}}, color={191,0,0}));
  connect(heaFloNeg.Q_flow, Q_flow_Hea.y)
    annotation (Line(points={{80,-10},{99,-10}}, color={0,0,127}));
  connect(mSecHeaRet.y, Q_flow_Hea.u)
    annotation (Line(points={{138,70},{126,70},
          {126,-10},{122,-10}}, color={0,0,127}));
  connect(mSecHeaRet.y, pumHea.m_flow_in)
    annotation (Line(points={{138,70},{126,70},{126,84},{90,84},{90,82}},
                                                           color={0,0,127}));
  connect(retChiWat.port_b, pumCoo.port_a)
    annotation (Line(points={{-100,20},{
          -100,70},{-80,70}},  color={0,127,255}));
  connect(retChiWat.port_a, cooVol.ports[1])
    annotation (Line(points={{-80,20},{
          -40,20},{-40,0},{-32,0}},       color={0,127,255}));
  connect(supChiWat.port_b, cooVol.ports[2])
    annotation (Line(points={{-18,20},
          {-18,0},{-28,0}},     color={0,127,255}));
  connect(ETS.heaWatSup, supHeaWat.port_a)
    annotation (Line(points={{10,52.2},{14,52.2},{14,40}},
                              color={0,127,255}));
  connect(heaVol.ports[1], supHeaWat.port_b)
    annotation (Line(points={{32,0},{14,0},{14,20}},      color={0,127,255}));
  connect(pumCoo.m_flow_in, mSecCooRet.y)
    annotation (Line(points={{-70,82},{-70,86},{-128,86},{-128,70},{-138,70}},
                                                           color={0,0,127}));
  connect(ETS.chiWatSup, supChiWat.port_a)
    annotation (Line(points={{-10,52.2},{-18,52.2},{-18,40}},
                                 color={0,127,255}));
  connect(heaVol.ports[2], retHeaWat.port_a)
    annotation (Line(points={{28,0},{40,
          0},{40,20},{100,20}},        color={0,127,255}));
  connect(retHeaWat.port_b, pumHea.port_a)
    annotation (Line(points={{120,20},{120,70},{100,70}}, color={0,127,255}));
  connect(pumHea.port_b,ETS.heaWatRet)
    annotation (Line(points={{80,70},{40,70},{40,56},{10,56}},
                                color={0,127,255}));
  connect(pumCoo.port_b, ETS.chiWatRet)
    annotation (Line(points={{-60,70},{-40,70},{-40,56},{-10,56}},
                                  color={0,127,255}));
  connect(disLoa.ports[1],disPD. port_b)
    annotation (Line(points={{60,-50},{40,
          -50}},                      color={0,127,255}));
  connect(ETS.disWatRet,disPD. port_a)
    annotation (Line(points={{2,50},{2,-50},{20,-50}},
                      color={0,127,255}));
  connect(mulCon.y[1], ETS.TSetHea)
    annotation (Line(points={{-15,107.167},{-24,107.167},{-24,66},{-11,66}},
                                             color={0,0,127}));
  connect(mulCon.y[2], ETS.TSetCoo)
    annotation (Line(points={{-15,107.5},{-24,107.5},{-24,67.8},{-11,67.8}},
                                           color={0,0,127}));
  connect(mulCon.y[3], ETS.TSetCooMin)
    annotation (Line(points={{-15,107.833},{-24,107.833},{-24,64},{-11,64}},
                                                 color={0,0,127}));
  connect(mulCon.y[4], ETS.TMinConEnt)
    annotation (Line(points={{-15,108.167},{-24,108.167},{-24,62},{-11,62}},
                                                 color={0,0,127}));
  connect(mulCon.y[5], ETS.TMaxEvaEnt)
    annotation (Line(points={{-15,108.5},{-24,108.5},{-24,60},{-11,60}},
                                               color={0,0,127}));
  connect(mulCon.y[6], ETS.TMaxBorEnt)
    annotation (Line(points={{-15,108.833},{-24,108.833},{-24,58},{-11,58}},
                                             color={0,0,127}));
  connect(ETS.heaWatSup, pre.ports[1])
    annotation (Line(points={{10,52.2},{32,52.2},{32,50},{60,50}},
                                  color={0,127,255}));
annotation (
      Diagram(coordinateSystem(
                preserveAspectRatio=false,
                extent={{-180,-100},{180,140}}),
                graphics={Line(points={{-22,22}}, color={28,108,200}),
      Text(extent={{134,-20},{174,-40}},
              lineColor={238,46,47},
              textString="Heating Side"),
      Text(extent={{-160,-20},{-122,-40}},
            lineColor={28,108,200},
            textString="Cooling Side"),
      Text(extent={{-20,-72},{22,-84}},
           lineColor={217,67,180},
           textString="District Side")}),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Examples/ETS_ClosedLoop.mos"
    "Simulate and plot"),
     experiment(StopTime=18000,Tolerance=1e-06,
     __Dymola_Algorithm="Cvode"),
Documentation(info="<html>
<p>
Example that simulates the performance of the energy transfer station 
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Substation\">
Buildings.Applications.DHC.EnergyTransferStations.Substation</a>
connected to chilled, hot and ambient water circuits.
</p>
</html>", revisions="<html>
<ul>
<li>
January 15, 2020, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end ETS_ClosedLoop;
