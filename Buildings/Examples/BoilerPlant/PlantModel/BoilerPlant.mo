within Buildings.Examples.BoilerPlant.PlantModel;
model BoilerPlant
    "Boiler plant model for closed loop testing"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;

  replaceable package MediumW =
      Buildings.Media.Water
    "Medium model";

  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal = V*1.2*6/3600
    "Nominal mass flow rate"
    annotation(dialog(group="Zone parameters"));

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = boiEff1[1]*boiCap1 + boiEff2[1]*boiCap2
    "Nominal heat flow rate of radiator"
    annotation(dialog(group="Radiator parameters"));

  parameter Modelica.SIunits.HeatFlowRate boiCap1= 15000
    "Boiler capacity for boiler-1"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.SIunits.HeatFlowRate boiCap2= 15000
    "Boiler capacity for boiler-2"
    annotation(dialog(group="Boiler parameters"));

  parameter Real boiEff1[1] = {0.8}
    "Efficiency for boiler-1"
    annotation(dialog(group="Boiler parameters"));

  parameter Real boiEff2[1] = {0.8}
    "Efficiency for boiler-2"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.SIunits.Temperature TRadSup_nominal = 273.15+70
    "Radiator nominal supply water temperature"
    annotation(dialog(group="Radiator parameters"));

  parameter Modelica.SIunits.Temperature TRadRet_nominal = 273.15+50
    "Radiator nominal return water temperature"
    annotation(dialog(group="Radiator parameters"));

  parameter Modelica.SIunits.MassFlowRate mRad_flow_nominal=0.000604*1000
    "Radiator nominal mass flow rate"
    annotation(dialog(group="Radiator parameters"));

  parameter Modelica.SIunits.Temperature TBoiSup_nominal = 273.15+70
    "Boiler nominal supply water temperature"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.SIunits.Temperature TBoiRet_min = 273.15+60
    "Boiler minimum return water temperature"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.SIunits.MassFlowRate mBoi_flow_nominal1=boiCap1/4200/(TBoiSup_nominal-TBoiRet_min)
    "Boiler-1 nominal mass flow rate"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.SIunits.MassFlowRate mBoi_flow_nominal2=boiCap2/4200/(TBoiSup_nominal-TBoiRet_min)
    "Boiler-2 nominal mass flow rate"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.SIunits.Volume V=1200
    "Room volume"
    annotation(dialog(group="Zone parameters"));

  parameter Modelica.SIunits.Temperature TAir_nominal=273.15 + 23.9
    "Air temperature at nominal condition"
    annotation(dialog(group="Zone parameters"));

  parameter Real zonTheCap = 2*V*1.2*1500
    "Zone thermal capacitance"
    annotation(dialog(group="Zone parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiSta[2]
    "Boiler status signal"
    annotation (Placement(transformation(extent={{-360,100},{-320,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumSta[2]
    "Pump status signal"
    annotation (Placement(transformation(extent={{-360,20},{-320,60}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHotIsoVal[2](
    final unit="1",
    displayUnit="1")
    "Hot water isolation valve signal"
    annotation (Placement(transformation(extent={{-360,60},{-320,100}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe[2](
    final unit="1",
    displayUnit="1")
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-360,-20},{-320,20}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBypValSig(
    final unit="1",
    displayUnit="1")
    "Bypass valve signal"
    annotation (Placement(transformation(extent={{-360,-60},{-320,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput QRooInt_flowrate(
    final unit="W",
    displayUnit="W",
    final quantity="EnergyFlowRate")
    "Room internal load flowrate"
    annotation (Placement(transformation(extent={{-360,190},{-320,230}}),
      iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRadIsoVal(
    final unit="1",
    displayUnit="1")
    "Radiator isolation valve signal"
    annotation (Placement(transformation(extent={{-360,150},{-320,190}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutAir(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-360,-100},{-320,-60}}),
      iconTransformation(extent={{-140,70},{-100,110}},
      rotation=90)));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yZonTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{320,120},{360,160}}),
      iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply temperature"
    annotation (Placement(transformation(extent={{320,80},{360,120}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured return temperature"
    annotation (Placement(transformation(extent={{320,20},{360,60}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatDp[1](
    final unit="Pa",
    displayUnit="Pa")
    "Hot water differential pressure between supply and return"
    annotation (Placement(transformation(extent={{320,-20},{360,20}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VHotWat_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured flowrate in primary circuit"
    annotation (Placement(transformation(extent={{320,-50},{360,-10}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mA_flow_nominal,
    final V=1.2*V,
    final nPorts=1)
    annotation (Placement(transformation(extent={{140,150},{160,170}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(
    final G=20000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{100,170},{120,190}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{100,200},{120,220}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(
    final C=zonTheCap)
    "Heat capacity for furniture and walls"
    annotation (Placement(transformation(extent={{140,180},{160,200}})));

  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mRad_flow_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a_nominal=TRadSup_nominal,
    final T_b_nominal=TRadRet_nominal,
    final TAir_nominal=TAir_nominal,
    final dp_nominal=20000)
    "Radiator"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));

  Buildings.Fluid.Boilers.BoilerPolynomial boi(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mBoi_flow_nominal1,
    final dp_nominal=5000,
    final Q_flow_nominal=boiCap1,
    final T_nominal=TBoiSup_nominal,
    final effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    final a=boiEff1,
    final fue=Fluid.Data.Fuels.NaturalGasHigherHeatingValue(),
    final UA=boiCap1/39.81)
    "Boiler"
    annotation (Placement(transformation(extent={{90,-160},{70,-140}})));

  Buildings.Fluid.Sources.Boundary_pT preSou(
    redeclare package Medium = MediumW,
    final nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{260,-210},{240,-190}})));

  Buildings.Fluid.Boilers.BoilerPolynomial           boi1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=mBoi_flow_nominal2,
    final dp_nominal=5000,
    final Q_flow_nominal=boiCap2,
    final T_nominal=TBoiSup_nominal,
    final effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    final a=boiEff2,
    final fue=Buildings.Fluid.Data.Fuels.HeatingOilLowerHeatingValue(),
    final UA=boiCap2/39.81)
    "Boiler"
    annotation (Placement(transformation(extent={{90,-220},{70,-200}})));

  Buildings.Fluid.Movers.SpeedControlled_y pum(
    redeclare package Medium = Media.Water,
    final allowFlowReversal=true,
    redeclare Fluid.Movers.Data.Pumps.Wilo.customPumpCurves per,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=false,
    final riseTime=120)
    "Hot water primary pump-1"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-70,-70})));

  Buildings.Fluid.FixedResistances.Junction spl1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mBoi_flow_nominal2,-mRad_flow_nominal,mBoi_flow_nominal1},
    final dp_nominal={0,0,-200})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-150})));

  Buildings.Fluid.Movers.SpeedControlled_y pum1(
    redeclare package Medium =Media.Water,
    final allowFlowReversal=true,
    redeclare Fluid.Movers.Data.Pumps.Wilo.customPumpCurves per,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=false,
    final riseTime=120)
    "Hot water primary pump-2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={10,-70})));

  Buildings.Fluid.FixedResistances.Junction spl2(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mRad_flow_nominal,-mBoi_flow_nominal1,-mBoi_flow_nominal2},
    final dp_nominal={0,0,-200})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-100})));

  Buildings.Fluid.FixedResistances.Junction spl3(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mBoi_flow_nominal1,-mRad_flow_nominal,mBoi_flow_nominal2},
    final dp_nominal={0,0,-200})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,0})));

  Buildings.Fluid.FixedResistances.Junction spl4(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mRad_flow_nominal,-mRad_flow_nominal,-mRad_flow_nominal},
    final dp_nominal={0,0,-200})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,40})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=mRad_flow_nominal,
    final dpValve_nominal=0.1)
    "Minimum flow bypass valve"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));

  Buildings.Fluid.FixedResistances.Junction spl5(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mRad_flow_nominal,mRad_flow_nominal,-mRad_flow_nominal},
    final dp_nominal={0,0,-200})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=270,
      origin={210,40})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=0.0003,
    final dpValve_nominal=0.1)
    "Isolation valve for boiler-2"
    annotation (Placement(transformation(extent={{20,-220},{40,-200}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=0.0003,
    final dpValve_nominal=0.1)
    "Isolation valve for boiler-1"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[2]
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-300,30},{-280,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro[2]
    "Element-wise product"
    annotation (Placement(transformation(extent={{-240,10},{-220,30}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[2]
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-300,110},{-280,130}})));

  Buildings.Fluid.FixedResistances.Junction spl6(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mRad_flow_nominal,-mBoi_flow_nominal1,-mBoi_flow_nominal2},
    final dp_nominal={0,0,-200})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={140,-150})));

  Buildings.Fluid.Sensors.Temperature zonTem(
    redeclare package Medium = Media.Air)
    annotation (Placement(transformation(extent={{40,150},{60,170}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val3(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=mRad_flow_nominal,
    final dpValve_nominal=0.1)
    "Isolation valve for radiator"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare package Medium = Media.Water)
    "Differential pressure sensor between hot water supply and return"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo(
    redeclare package Medium = Media.Water,
    final m_flow_nominal=mRad_flow_nominal)
    "Volume flow-rate through primary circuit"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-280,-90},{-260,-70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Media.Water, m_flow_nominal=1000*0.0006)
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium =
        Media.Water, m_flow_nominal=1000*0.0006)
    annotation (Placement(transformation(extent={{160,110},{180,130}})));

  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(nout=1)
    annotation (Placement(transformation(extent={{260,-10},{280,10}})));

  Buildings.Fluid.FixedResistances.CheckValve cheVal(
    redeclare package Medium = Media.Water,
    m_flow_nominal=mRad_flow_nominal/2,
    dpValve_nominal=10,
    dpFixed_nominal=2)
    "Check valve to prevent reverse-flow through disabled pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-70,-40})));

  Buildings.Fluid.FixedResistances.CheckValve cheVal1(
    redeclare package Medium = Media.Water,
    m_flow_nominal=mRad_flow_nominal/2,
    dpValve_nominal=10,
    dpFixed_nominal=2)
    "Check valve to prevent reverse-flow through disabled pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={10,-40})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre1(redeclare package Medium =
        Media.Water)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=90,
        origin={-88,-40})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre2(redeclare package Medium =
        Media.Water)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=90,
        origin={40,-40})));

equation
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{120,180},{130,180},{130,160},{140,160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{120,210},{130,210},{130,160},{140,160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCap.port, vol.heatPort) annotation (Line(
      points={{150,180},{130,180},{130,160},{140,160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortCon, vol.heatPort) annotation (Line(
      points={{88,127.2},{88,160},{140,160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortRad, vol.heatPort) annotation (Line(
      points={{92,127.2},{92,160},{140,160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(spl1.port_2, spl2.port_1)
    annotation (Line(points={{-30,-140},{-30,-110}},   color={0,127,255}));
  connect(spl4.port_3, val.port_a)
    annotation (Line(points={{-20,40},{80,40}},     color={0,127,255}));
  connect(val.port_b, spl5.port_3)
    annotation (Line(points={{100,40},{200,40}},  color={0,127,255}));
  connect(val2.port_b, boi.port_b)
    annotation (Line(points={{40,-150},{70,-150}},   color={0,127,255}));
  connect(val1.port_b, boi1.port_b)
    annotation (Line(points={{40,-210},{70,-210}},   color={0,127,255}));
  connect(val2.port_a, spl1.port_3)
    annotation (Line(points={{20,-150},{-20,-150}},   color={0,127,255}));
  connect(val1.port_a, spl1.port_1) annotation (Line(points={{20,-210},{-30,-210},
          {-30,-160}},        color={0,127,255}));
  connect(uPumSta, booToRea.u)
    annotation (Line(points={{-340,40},{-302,40}},   color={255,0,255}));
  connect(booToRea.y, pro.u1) annotation (Line(points={{-278,40},{-260,40},{-260,
          26},{-242,26}},          color={0,0,127}));
  connect(uPumSpe, pro.u2) annotation (Line(points={{-340,0},{-260,0},{-260,14},
          {-242,14}},              color={0,0,127}));
  connect(pro[1].y, pum.y) annotation (Line(points={{-218,20},{-100,20},{-100,-70},
          {-82,-70}},              color={0,0,127}));
  connect(pro[2].y, pum1.y) annotation (Line(points={{-218,20},{-100,20},{-100,-16},
          {-20,-16},{-20,-70},{-2,-70}},                  color={0,0,127}));

  connect(uBypValSig, val.y) annotation (Line(points={{-340,-40},{-120,-40},{-120,
          60},{90,60},{90,52}},       color={0,0,127}));

  connect(uHotIsoVal[1], val1.y) annotation (Line(points={{-340,70},{-340,80},{-140,
          80},{-140,-190},{30,-190},{30,-198}},          color={0,0,127}));

  connect(uHotIsoVal[2], val2.y) annotation (Line(points={{-340,90},{-340,80},{-140,
          80},{-140,-130},{30,-130},{30,-138}},          color={0,0,127}));

  connect(uBoiSta, booToRea1.u)
    annotation (Line(points={{-340,120},{-302,120}}, color={255,0,255}));

  connect(booToRea1[1].y, boi1.y) annotation (Line(points={{-278,120},{-160,120},
          {-160,-180},{110,-180},{110,-202},{92,-202}},
                                                      color={0,0,127}));

  connect(booToRea1[2].y, boi.y) annotation (Line(points={{-278,120},{-160,120},
          {-160,-120},{110,-120},{110,-142},{92,-142}},
                                                      color={0,0,127}));

  connect(QRooInt_flowrate, preHea.Q_flow)
    annotation (Line(points={{-340,210},{100,210}},
                                                 color={0,0,127}));

  connect(spl6.port_1, boi.port_a)
    annotation (Line(points={{130,-150},{90,-150}},color={0,127,255}));

  connect(spl6.port_3, boi1.port_a) annotation (Line(points={{140,-160},{140,-210},
          {90,-210}}, color={0,127,255}));

  connect(zonTem.port, vol.ports[1]) annotation (Line(points={{50,150},{50,144},
          {150,144},{150,150}},
                            color={0,127,255}));

  connect(zonTem.T, yZonTem) annotation (Line(points={{57,160},{60,160},{60,140},
          {340,140}},color={0,0,127}));

  connect(val3.port_b, rad.port_a)
    annotation (Line(points={{40,120},{80,120}},   color={0,127,255}));

  connect(uRadIsoVal, val3.y)
    annotation (Line(points={{-340,170},{30,170},{30,132}},
                                                          color={0,0,127}));

  connect(spl4.port_2, senRelPre.port_a) annotation (Line(points={{-30,50},{-30,
          80},{80,80}},    color={0,127,255}));

  connect(senRelPre.port_b, spl5.port_1) annotation (Line(points={{100,80},{210,
          80},{210,50}},   color={0,127,255}));

  connect(spl3.port_2, senVolFlo.port_a) annotation (Line(points={{-30,10},{-30,
          16},{30,16},{30,0},{40,0}},              color={0,127,255}));

  connect(senVolFlo.port_b, spl4.port_1) annotation (Line(points={{60,0},{70,0},
          {70,22},{-30,22},{-30,30}},                color={0,127,255}));

  connect(senVolFlo.V_flow, VHotWat_flow) annotation (Line(points={{50,11},{50,16},
          {80,16},{80,-30},{340,-30}},             color={0,0,127}));

  connect(spl6.port_2, spl5.port_2) annotation (Line(points={{150,-150},{210,-150},
          {210,30}},   color={0,127,255}));

  connect(spl6.port_2, preSou.ports[1]) annotation (Line(points={{150,-150},{210,
          -150},{210,-200},{240,-200}}, color={0,127,255}));

  connect(TOutAir, TOut.T)
    annotation (Line(points={{-340,-80},{-282,-80}},   color={0,0,127}));

  connect(TOut.port, theCon.port_a) annotation (Line(points={{-260,-80},{-180,-80},
          {-180,180},{100,180}},
                              color={191,0,0}));

  connect(senTem.port_b, val3.port_a)
    annotation (Line(points={{0,120},{20,120}},    color={0,127,255}));

  connect(spl4.port_2, senTem.port_a) annotation (Line(points={{-30,50},{-30,120},
          {-20,120}},       color={0,127,255}));

  connect(senTem.T, ySupTem) annotation (Line(points={{-10,131},{-10,140},{10,
          140},{10,100},{340,100}},                 color={0,0,127}));

  connect(rad.port_b, senTem1.port_a)
    annotation (Line(points={{100,120},{160,120}},
                                                 color={0,127,255}));

  connect(senTem1.port_b, spl5.port_1) annotation (Line(points={{180,120},{210,120},
          {210,50}},       color={0,127,255}));

  connect(senTem1.T, yRetTem) annotation (Line(points={{170,131},{170,150},{280,
          150},{280,40},{340,40}},
                                color={0,0,127}));

  connect(reaRep.y, yHotWatDp)
    annotation (Line(points={{282,0},{340,0}},       color={0,0,127}));

  connect(senRelPre.p_rel, reaRep.u) annotation (Line(points={{90,71},{90,64},{240,
          64},{240,0},{258,0}},             color={0,0,127}));

  connect(pum.port_b, cheVal.port_a)
    annotation (Line(points={{-70,-60},{-70,-50}},
                                                 color={0,127,255}));

  connect(cheVal.port_b, spl3.port_1) annotation (Line(points={{-70,-30},{-70,
          -20},{-30,-20},{-30,-10}},
                                color={0,127,255}));

  connect(spl2.port_2, pum.port_a) annotation (Line(points={{-30,-90},{-30,-86},
          {-70,-86},{-70,-80}}, color={0,127,255}));

  connect(pum1.port_b, cheVal1.port_a)
    annotation (Line(points={{10,-60},{10,-50}}, color={0,127,255}));

  connect(cheVal1.port_b, spl3.port_3)
    annotation (Line(points={{10,-30},{10,0},{-20,0}}, color={0,127,255}));

  connect(spl2.port_3, pum1.port_a) annotation (Line(points={{-20,-100},{10,
          -100},{10,-80}}, color={0,127,255}));

  connect(senRelPre1.port_a, cheVal.port_a)
    annotation (Line(points={{-88,-50},{-70,-50}}, color={0,127,255}));

  connect(senRelPre1.port_b, cheVal.port_b)
    annotation (Line(points={{-88,-30},{-70,-30}}, color={0,127,255}));

  connect(cheVal1.port_b, senRelPre2.port_b)
    annotation (Line(points={{10,-30},{40,-30}}, color={0,127,255}));

  connect(cheVal1.port_a, senRelPre2.port_a)
    annotation (Line(points={{10,-50},{40,-50}}, color={0,127,255}));

  annotation (Documentation(info="<html>
<p>
This model implements the schematic for a primary-only, condensing boiler 
plant with headered, variable-speed primary pumps, as defined in ASHRAE RP-1711,
March 2020 draft.
</p>
</html>", revisions="<html>
<ul>
<li>
October 28, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-320,-240},{320,
            240}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/Boiler/System6.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=172800),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end BoilerPlant;
