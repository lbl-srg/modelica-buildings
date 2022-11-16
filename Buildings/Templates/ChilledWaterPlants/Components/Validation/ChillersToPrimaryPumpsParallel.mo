within Buildings.Templates.ChilledWaterPlants.Components.Validation;
model ChillersToPrimaryPumpsParallel
  "Validation model for hydronic interface between parallel chillers and primary pumps"
  extends Modelica.Icons.Example;

  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";

  parameter Integer nChi=3
    "Number of chillers";

  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi]=
    capChi_nominal/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/
    (TChiWatRet_nominal-TChiWatSup_nominal)
    "CHW mass flow rate - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWatPri_flow_nominal=
    sum(mChiWatChi_flow_nominal)
    "Primary CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatEco_flow_nominal=
    sum(mChiWatChi_flow_nominal)
    "WSE CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChiWatChi_nominal[nChi]=
    fill(Buildings.Templates.Data.Defaults.dpChiWatChi, nChi)
    "CHW pressure drop - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChiWatEco_nominal=
    Buildings.Templates.Data.Defaults.dpChiWatEco
    "WSE CHW pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi](
    each min=0)=fill(1e6, nChi)
    "Cooling capacity - Each chiller (>0)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    Buildings.Templates.Data.Defaults.TChiWatSup
    "CHW supply temperature";
  parameter Modelica.Units.SI.Temperature TChiWatRet_nominal=
    Buildings.Templates.Data.Defaults.TChiWatRet
    "CHW return temperature";

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWatPri(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nChi,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    dp_nominal=1.5*dpChiWatChi_nominal)
    "Parameter record for primary CHW pumps";
  parameter Buildings.Templates.Components.Data.PumpSingle datPumChiWatEco(
    final typ=Buildings.Templates.Components.Types.Pump.Single,
    final m_flow_nominal=mChiWatEco_flow_nominal,
    dp_nominal=1.5*dpChiWatEco_nominal)
    "Parameter record for WSE CHW pump";
  parameter Buildings.Templates.Components.Data.Valve datValChiWatEcoByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    final m_flow_nominal=mChiWatEco_flow_nominal,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso)
    "Parameter record for WSE CHW bypass valve";
  parameter Buildings.Templates.Components.Data.Valve datValChiWatChiByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso)
    "Parameter record for chiller CHW bypass valve";

  Routing.ChillersToPrimaryPumps rou(
    redeclare final package MediumChiWat = MediumChiWat,
    final nChi=nChi,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final datValChiWatChiByp=datValChiWatChiByp,
    typDisChiWat=Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only,
    typArrChi=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel,
    typArrPumChiWatPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None)
    "Parallel chillers, dedicated pumps, no WSE"
    annotation (Placement(transformation(extent={{-80,-30},{-40,230}})));

  Fluid.FixedResistances.PressureDrop resEva[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,10})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{20,210},{40,230}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final dat=datPumChiWatPri,
    final nPum=nChi,
    final have_var=true,
    final have_varCom=true,
    final energyDynamics=energyDynamics)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,180},{220,220}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-30},{-190,-10}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow[nChi](
    redeclare each final package Medium=MediumChiWat) "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,-30},{-150,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatPri[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Primary CHW pumps Start/Stop signal"
    annotation (Placement(transformation(extent={{-220,270},{-200,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatPri(
    k=1) "Primary CHW pump speed signal"
    annotation (Placement(transformation(extent={{-250,290},{-230,310}})));
  Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{30,-30},{10,-10}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,220})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow(
    redeclare final package Medium=MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,210},{110,230}})));
  Fluid.Sources.Boundary_pT bouChiWat(
    redeclare final package Medium=MediumChiWat,
    final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-40})));
  Fluid.Sources.PropertySource_T coo[nChi](
    redeclare each final package Medium=MediumChiWat,
    each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,210},{-160,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWat[nChi](
    each final k=TChiWatSup_nominal) "CHW supply temperature set point"
    annotation (Placement(transformation(extent={{-250,70},{-230,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatChiByp(
    table=[0,0; 1.8,0; 1.8,1; 2,1],
    timeScale=1000,
    period=2000) "CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-192,250},{-172,270}})));

  Routing.ChillersToPrimaryPumps rou1(
    redeclare final package MediumChiWat = MediumChiWat,
    final nChi=nChi,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final datValChiWatChiByp=datValChiWatChiByp,
    typDisChiWat=Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only,
    typArrChi=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel,
    typArrPumChiWatPri=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve)
    "Parallel chillers, headered pumps, WSE with CHW bypass valve"
    annotation (Placement(transformation(extent={{-80,-330},{-40,-70}})));

  Fluid.FixedResistances.PressureDrop resEva1[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,-110})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri1(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri1(
    redeclare final package Medium=MediumChiWat,
    final dat=datPumChiWatPri,
    final nPum=nChi,
    final have_var=true,
    final have_varCom=true,
    final energyDynamics=energyDynamics)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt1[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-150},{-190,-130}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow1[nChi](
    redeclare each final package Medium=MediumChiWat)
    "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,-150},{-150,-130}})));
  Fluid.HeatExchangers.HeaterCooler_u loa1(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{30,-330},{10,-310}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup1(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,-80})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow1(
    redeclare final package Medium=MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Fluid.Sources.Boundary_pT bouChiWat1(
    redeclare final package Medium=MediumChiWat,
    final nPorts=1) "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-340})));
  Fluid.Sources.PropertySource_T coo1[nChi](
    redeclare each final package Medium=MediumChiWat,
    each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri1
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,-120},{220,-80}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Fluid.FixedResistances.PressureDrop resEco(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatEco_flow_nominal,
    final dp_nominal=dpChiWatEco_nominal)
    "Flow resistance for WSE HX"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,-290})));
  Fluid.Sensors.TemperatureTwoPort TChiWatEcoEnt(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatEco_flow_nominal)
    "WSE entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-330},{-190,-310}})));
  Fluid.Sensors.MassFlowRate mChiWatEco_flow(
    redeclare final package Medium=MediumChiWat)
    "WSE CHW flow"
    annotation (Placement(transformation(extent={{-130,-330},{-150,-310}})));
  Fluid.Sources.PropertySource_T cooEco(
    redeclare final package Medium=MediumChiWat,
    final use_T_in=true)
    "Ideal cooling to input set point (representing WSE)"
    annotation (Placement(transformation(extent={{-180,-270},{-160,-250}})));
  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatEcoByp(
    redeclare final package Medium=MediumChiWat,
    final dat=datValChiWatEcoByp)
    "WSE CHW bypass valve" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-120,-290})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatEcoByp
    "WSE CHW bypass valve control bus"
    annotation (Placement(transformation(
          extent={{180,-300},{220,-260}}),
                                       iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable yValChiWatEcoByp(table=[0,
        1; 1.5,1; 1.5,0; 2,0], timeScale=1000)
    "WSE CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-160,230},{-140,250}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiByp
    "CHW bypass valves control bus"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
                                  iconTransformation(extent={{-316,184},{-276,
            224}})));
  .Buildings.Templates.ChilledWaterPlants.Interfaces.Bus busPla
    "Plant control bus" annotation (Placement(transformation(extent={{180,-80},{
            220,-40}}), iconTransformation(extent={{-432,12},{-412,32}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert pump return signal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,70})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum comSigLoa(k=fill(1/nChi, nChi),
      nin=nChi) "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,40})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
                                                               [nChi]
    "Convert pump return signal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,-170})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum comSigLoa1(k=fill(1/nChi, nChi),
      nin=nChi) "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,-200})));
  Buildings.Templates.Components.Routing.PassThroughFluid pas(
    redeclare final package Medium=MediumChiWat)
    "Direct fluid pass-through for no WSE" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,30})));
equation
  connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation (Line(points={{10,220},{20,220}},  color={0,127,255}));
  connect(mChiWatChi_flow.port_a, rou.ports_bRet[1:nChi])
    annotation (Line(points={{-130,-20},{-80,-20}},color={0,127,255}));
  connect(mChiWatChi_flow.port_b, TChiWatChiEnt.port_a)
    annotation (Line(points={{-150,-20},{-170,-20}},
                                                   color={0,127,255}));
  connect(TChiWatChiEnt.port_b, resEva.port_a) annotation (Line(points={{-190,-20},
          {-200,-20},{-200,0}}, color={0,127,255}));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri.y1) annotation (Line(points={{-198,
          280},{160,280},{160,200},{200,200}}, color={255,0,255}));
  connect(yPumChiWatPri.y, busPumChiWatPri.y) annotation (Line(points={{-228,300},
          {180,300},{180,220},{200,220},{200,200}}, color={0,0,127}));
  connect(busPumChiWatPri, pumChiWatPri.bus) annotation (Line(
      points={{200,200},{200,190},{0,190},{0,230}},
      color={255,204,51},
      thickness=0.5));
  connect(outPumChiWatPri.port_b, TChiWatPriSup.port_a)
    annotation (Line(points={{40,220},{50,220}}, color={0,127,255}));
  connect(TChiWatPriSup.port_b, mChiWatPri_flow.port_a)
    annotation (Line(points={{70,220},{90,220}}, color={0,127,255}));
  connect(loa.port_a, mChiWatPri_flow.port_b) annotation (Line(points={{30,-20},
          {120,-20},{120,220},{110,220}},
                                        color={0,127,255}));
  connect(loa.port_b, rou.port_aRet) annotation (Line(points={{10,-20},{-40,-20}},
                                    color={0,127,255}));
  connect(bouChiWat.ports[1], loa.port_b)
    annotation (Line(points={{0,-30},{0,-20},{10,-20}},
                                                     color={0,127,255}));
  connect(coo.port_b, rou.ports_aSup[1:nChi])
    annotation (Line(points={{-160,220},{-80,220}},color={0,127,255}));
  connect(resEva.port_b, coo.port_a) annotation (Line(points={{-200,20},{-200,220},
          {-180,220}}, color={0,127,255}));
  connect(TChiWat.y, coo.T_in) annotation (Line(points={{-228,80},{-220,80},{-220,
          240},{-174,240},{-174,232}},
                 color={0,0,127}));
  connect(rou.ports_bSup, pumChiWatPri.ports_a)
    annotation (Line(points={{-40,220},{-10,220}},   color={0,127,255}));
  connect(pumChiWatPri1.ports_b, outPumChiWatPri1.ports_a)
    annotation (Line(points={{10,-80},{20,-80}},
                                               color={0,127,255}));
  connect(mChiWatChi_flow1.port_a, rou1.ports_bRet[1:nChi])
    annotation (Line(points={{-130,-140},{-100,-140},{-100,-320},{-80,-320}},
                                                    color={0,127,255}));
  connect(mChiWatChi_flow1.port_b, TChiWatChiEnt1.port_a)
    annotation (Line(points={{-150,-140},{-170,-140}},
                                                     color={0,127,255}));
  connect(TChiWatChiEnt1.port_b, resEva1.port_a) annotation (Line(points={{-190,
          -140},{-200,-140},{-200,-120}},
                                       color={0,127,255}));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri1.y1) annotation (Line(points={{-198,
          280},{160,280},{160,-100},{200,-100}},
                                             color={255,0,255}));
  connect(busPumChiWatPri1, pumChiWatPri1.bus) annotation (Line(
      points={{200,-100},{200,-104},{0,-104},{0,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(outPumChiWatPri1.port_b, TChiWatPriSup1.port_a)
    annotation (Line(points={{40,-80},{50,-80}},
                                               color={0,127,255}));
  connect(TChiWatPriSup1.port_b, mChiWatPri_flow1.port_a)
    annotation (Line(points={{70,-80},{90,-80}},
                                               color={0,127,255}));
  connect(loa1.port_a, mChiWatPri_flow1.port_b) annotation (Line(points={{30,-320},
          {120,-320},{120,-80},{110,-80}},
                                        color={0,127,255}));
  connect(loa1.port_b, rou1.port_aRet) annotation (Line(points={{10,-320},{-40,-320}},
                                      color={0,127,255}));
  connect(bouChiWat1.ports[1], loa1.port_b) annotation (Line(points={{0,-330},{0,
          -320},{10,-320}},    color={0,127,255}));
  connect(coo1.port_b, rou1.ports_aSup[1:nChi])
    annotation (Line(points={{-160,-80},{-80,-80}},
                                                  color={0,127,255}));
  connect(resEva1.port_b, coo1.port_a) annotation (Line(points={{-200,-100},{-200,
          -80},{-180,-80}},
                          color={0,127,255}));
  connect(TChiWat.y, coo1.T_in) annotation (Line(points={{-228,80},{-220,80},{-220,
          -60},{-174,-60},{-174,-68}},   color={0,0,127}));
  connect(rou1.ports_bSup, pumChiWatPri1.ports_a)
    annotation (Line(points={{-40,-80},{-10,-80}}, color={0,127,255}));
  connect(mChiWatEco_flow.port_b,TChiWatEcoEnt. port_a)
    annotation (Line(points={{-150,-320},{-170,-320}}, color={0,127,255}));
  connect(TChiWatEcoEnt.port_b,resEco. port_a) annotation (Line(points={{-190,-320},
          {-200,-320},{-200,-300}}, color={0,127,255}));
  connect(resEco.port_b,cooEco. port_a) annotation (Line(points={{-200,-280},{-200,
          -260},{-180,-260}}, color={0,127,255}));
  connect(TChiWat[1].y, cooEco.T_in) annotation (Line(points={{-228,80},{-220,80},
          {-220,-170},{-174,-170},{-174,-248}},
                                             color={0,0,127}));
  connect(cooEco.port_b, rou1.ports_aSup[nChi + 1]) annotation (Line(points={{-160,
          -260},{-120,-260},{-120,-80},{-80,-80}},
                                               color={0,127,255}));
  connect(busValChiWatEcoByp, valChiWatEcoByp.bus) annotation (Line(
      points={{200,-280},{200,-290},{-110,-290}},
      color={255,204,51},
      thickness=0.5));
  connect(yValChiWatEcoByp.y[1], busValChiWatEcoByp.y) annotation (Line(points={{-138,
          240},{150,240},{150,-280},{200,-280}},    color={0,0,127}));
  connect(busPla, rou1.bus) annotation (Line(
      points={{200,-60},{-60,-60},{-60,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatPri.y, busPumChiWatPri1.y) annotation (Line(points={{-228,300},
          {180,300},{180,-96},{190,-96},{190,-100},{200,-100}},
                                                          color={0,0,127}));
  connect(y1ValChiWatChiByp.y[1], busValChiWatChiByp.y1) annotation (Line(
        points={{-170,260},{170,260},{170,-40},{200,-40}}, color={255,0,255}));
  connect(rou1.ports_bRet[nChi + 1], mChiWatEco_flow.port_a) annotation (Line(
        points={{-80,-320},{-130,-320}},                       color={0,127,255}));
  connect(mChiWatEco_flow.port_a, valChiWatEcoByp.port_a) annotation (Line(
        points={{-130,-320},{-120,-320},{-120,-300}}, color={0,127,255}));
  connect(valChiWatEcoByp.port_b, cooEco.port_b) annotation (Line(points={{-120,
          -280},{-120,-260},{-160,-260}},
                                       color={0,127,255}));
  connect(busValChiWatChiByp, busPla.valChiWatChiByp) annotation (Line(
      points={{200,-40},{200,-60}},
      color={255,204,51},
      thickness=0.5));
  connect(booToRea.y,comSigLoa. u)
    annotation (Line(points={{240,58},{240,52}},     color={0,0,127}));
  connect(busPumChiWatPri.y1_actual, booToRea.u) annotation (Line(
      points={{200,200},{240,200},{240,82}},
      color={255,204,51},
      thickness=0.5));
  connect(comSigLoa.y, loa.u)
    annotation (Line(points={{240,28},{240,-14},{32,-14}},  color={0,0,127}));
  connect(booToRea1.y, comSigLoa1.u)
    annotation (Line(points={{240,-182},{240,-188}},
                                                 color={0,0,127}));
  connect(comSigLoa1.y, loa1.u)
    annotation (Line(points={{240,-212},{240,-314},{32,-314}},
                                                           color={0,0,127}));
  connect(busPumChiWatPri1.y1_actual, booToRea1.u) annotation (Line(
      points={{200,-100},{240,-100},{240,-158}},
      color={255,204,51},
      thickness=0.5));
  connect(rou.ports_bRet[nChi + 1], pas.port_a) annotation (Line(points={{-80,-20},
          {-100,-20},{-100,20}},  color={0,127,255}));
  connect(pas.port_b, rou.ports_aSup[nChi + 1]) annotation (Line(points={{-100,40},
          {-100,220},{-80,220}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-260,-400},{260,320}})),
  experiment(
    StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Templates/ChilledWaterPlants/Components/Validation/ChillersToPrimaryPumpsParallel.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates the hydronic interface model
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Routing.ChillersToPrimaryPumps\">
Buildings.Templates.ChilledWaterPlants.Components.Routing.ChillersToPrimaryPumps</a>
for various plant configurations where the chillers are connected
in parallel.
The validation uses open-loop controls.
</p>
<ul>
<li>
The first configuration has no waterside economizer.
</li>
<li>
The second configuration has a waterside economizer with a heat exchanger
bypass valve to control the CHW flow rate.
</li>
</ul>
</html>"));
end ChillersToPrimaryPumpsParallel;
