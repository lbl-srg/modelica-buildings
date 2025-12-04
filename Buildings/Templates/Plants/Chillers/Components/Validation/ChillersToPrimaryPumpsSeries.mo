within Buildings.Templates.Plants.Chillers.Components.Validation;
model ChillersToPrimaryPumpsSeries
  "Validation model for hydronic interface between series chillers and primary pumps"
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
    dp_nominal=fill(1.5*sum(dpChiWatChi_nominal), nChi))
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

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatPri[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Primary CHW pumps Start/Stop signal"
    annotation (Placement(transformation(extent={{-250,290},{-230,310}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yPumChiWatPri(
    k=1) "Primary CHW pump speed signal"
    annotation (Placement(transformation(extent={{-250,330},{-230,350}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWat[nChi](
    each final k=TChiWatSup_nominal)
    "CHW supply temperature set point"
    annotation (Placement(transformation(extent={{-250,210},{-230,230}})));
  Plants.Chillers.Components.Routing.ChillersToPrimaryPumps rou1(
    redeclare final package MediumChiWat = MediumChiWat,
    final nChi=nChi,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final datValChiWatChiByp=datValChiWatChiByp,
    typDisChiWat=Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only,
    typArrChi=Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series,
    typArrPumChiWatPri=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    typEco=Buildings.Templates.Plants.Chillers.Types.Economizer.None)
    "Series chillers, headered pumps, no WSE"
    annotation (Placement(transformation(extent={{-80,90},{-40,210}})));

  Fluid.FixedResistances.PressureDrop resEva1[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,150})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri1(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{16,170},{36,190}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri1(
    redeclare final package Medium=MediumChiWat,
    final dat=datPumChiWatPri,
    final nPum=nChi,
    final have_var=true,
    final have_varCom=true,
    final energyDynamics=energyDynamics)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-30,170},{-10,190}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt1[nChi](
    redeclare each final package  Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,110},{-190,130}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow1[nChi](
    redeclare each final package Medium=MediumChiWat)
    "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,110},{-150,130}})));
  Fluid.HeatExchangers.HeaterCooler_u loa1(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{10,110},{-10,130}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup1(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,180})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow1(
    redeclare final package Medium=MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,170},{110,190}})));
  Fluid.Sources.Boundary_pT bouChiWat1(
    redeclare final package Medium=MediumChiWat,
    final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,100})));
  Fluid.Sources.PropertySource_T coo1[nChi](
    redeclare each final package Medium=MediumChiWat,
    each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,170},{-160,190}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri1
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,200},{220,240}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Plants.Chillers.Components.Routing.ChillersToPrimaryPumps rou2(
    redeclare final package MediumChiWat = MediumChiWat,
    final nChi=nChi,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final datValChiWatChiByp=datValChiWatChiByp,
    typDisChiWat=Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only,
    typArrChi=Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series,
    typArrPumChiWatPri=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    typEco=Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithValve)
    "Series chillers, headered pumps, WSE with CHW bypass valve"
    annotation (Placement(transformation(extent={{-80,-50},{-40,70}})));

  Fluid.FixedResistances.PressureDrop resEva2[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,10})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri2(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{16,30},{36,50}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri2(
    redeclare final package Medium=MediumChiWat,
    final dat=datPumChiWatPri,
    final nPum=nChi,
    final have_var=true,
    final have_varCom=true,
    final energyDynamics=energyDynamics)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt2[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-30},{-190,-10}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow2[nChi](
    redeclare each final package Medium=MediumChiWat) "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,-30},{-150,-10}})));
  Fluid.HeatExchangers.HeaterCooler_u loa2(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{10,-30},{-10,-10}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup2(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,40})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow2(
    redeclare final package Medium=MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Fluid.Sources.Boundary_pT bouChiWat2(
    redeclare final package Medium=MediumChiWat,
    final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,-40})));
  Fluid.Sources.PropertySource_T coo2[nChi](
    redeclare each final package Medium=MediumChiWat,
    each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri2
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,80},{220,120}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Fluid.FixedResistances.PressureDrop resEco(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatEco_flow_nominal,
    final dp_nominal=dpChiWatEco_nominal)
    "Flow resistance for WSE HX"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,-90})));
  Fluid.Sensors.TemperatureTwoPort TChiWatEcoEnt(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatEco_flow_nominal)
    "WSE entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-130},{-190,-110}})));
  Fluid.Sensors.MassFlowRate mChiWatEco_flow(
    redeclare final package Medium=MediumChiWat)
    "WSE CHW flow"
    annotation (Placement(transformation(extent={{-130,-130},{-150,-110}})));
  Fluid.Sources.PropertySource_T cooEco(
    redeclare final package Medium=MediumChiWat,  final use_T_in=true)
    "Ideal cooling to input set point (representing WSE)"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}})));
  Plants.Chillers.Components.Routing.ChillersToPrimaryPumps rou3(
    redeclare final package MediumChiWat = MediumChiWat,
    final nChi=nChi,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final datValChiWatChiByp=datValChiWatChiByp,
    typDisChiWat=Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only,
    typArrChi=Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series,
    typArrPumChiWatPri=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    typEco=Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithPump)
    "Series chillers, headered pumps, WSE with HX pump"
    annotation (Placement(transformation(extent={{-80,-250},{-40,-130}})));

  Fluid.FixedResistances.PressureDrop resEva3[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,-190})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri3(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{16,-170},{36,-150}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri3(
    redeclare final package Medium=MediumChiWat,
    final dat=datPumChiWatPri,
    final nPum=nChi,
    final have_var=true,
    final have_varCom=true,
    final energyDynamics=energyDynamics)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-30,-170},{-10,-150}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt3[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-230},{-190,-210}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow3[nChi](
    redeclare each final package Medium=MediumChiWat)
    "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,-230},{-150,-210}})));
  Fluid.HeatExchangers.HeaterCooler_u loa3(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{10,-230},{-10,-210}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup3(redeclare final package
      Medium=MediumChiWat, final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,-160})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow3(
    redeclare final package Medium=MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,-170},{110,-150}})));
  Fluid.Sources.Boundary_pT bouChiWat3(
    redeclare final package Medium=MediumChiWat,
      final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,-240})));
  Fluid.Sources.PropertySource_T coo3[nChi](
    redeclare each final package Medium=MediumChiWat,
    each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri3
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,-120},{220,-80}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Fluid.Sensors.MassFlowRate mChiWatEco_flow1(
    redeclare final package Medium=MediumChiWat)
    "WSE CHW flow"
    annotation (Placement(transformation(extent={{-130,-330},{-150,-310}})));
  Fluid.Sources.PropertySource_T cooEco1(
    redeclare final package Medium=MediumChiWat,
    final use_T_in=true)
    "Ideal cooling to input set point (representing WSE)"
    annotation (Placement(transformation(extent={{-180,-270},{-160,-250}})));
  Fluid.FixedResistances.PressureDrop resEco1(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatEco_flow_nominal,
    final dp_nominal=dpChiWatEco_nominal)
    "Flow resistance for WSE HX"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,-290})));
  Fluid.Sensors.TemperatureTwoPort TChiWatEcoEnt1(redeclare final package
      Medium=MediumChiWat, final m_flow_nominal=mChiWatEco_flow_nominal)
    "WSE entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-330},{-190,-310}})));

  Buildings.Templates.Components.Pumps.Single pumEco(
    final dat=datPumChiWatEco,
    final have_var=true,
    final energyDynamics=energyDynamics)
    "WSE HX pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,-280})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatEco
    "WSE HX pump control bus"
    annotation (Placement(transformation(extent={{180,-180},{220,-140}}),
                                iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatEcoByp
    "WSE CHW bypass valve control bus" annotation (Placement(transformation(
          extent={{180,20},{220,60}}), iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable yValChiWatEcoByp(table=[0,
        1; 1.5,1; 1.5,0; 2,0], timeScale=1000)
    "WSE CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-250,250},{-230,270}})));
  Buildings.Templates.Components.Actuators.Valve valChiWatEcoByp1(
    redeclare final package Medium=MediumChiWat,
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    final dat=datValChiWatEcoByp)
    "WSE CHW bypass valve" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-120,-90})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert pump return signal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={220,180})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum comSigLoa(k=fill(1/nChi, nChi),
      nin=nChi) "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={220,150})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
                                                               [nChi]
    "Convert pump return signal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,40})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum comSigLoa1(k=fill(1/nChi, nChi),
      nin=nChi) "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,10})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
                                                               [nChi]
    "Convert pump return signal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,-160})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum comSigLoa2(k=fill(1/nChi, nChi),
      nin=nChi) "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,-190})));
  Buildings.Templates.Components.Routing.PassThroughFluid pas(redeclare final
      package Medium = MediumChiWat)
    "Direct fluid pass-through for no WSE" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,150})));
equation
  connect(pumChiWatPri1.ports_b, outPumChiWatPri1.ports_a)
    annotation (Line(points={{-10,180},{16,180}},color={0,127,255}));
  connect(mChiWatChi_flow1.port_a, rou1.ports_bRet[1:nChi])
    annotation (Line(points={{-130,120},{-100,120},{-100,91.791},{-80,91.791}},
                                                    color={0,127,255}));
  connect(mChiWatChi_flow1.port_b, TChiWatChiEnt1.port_a)
    annotation (Line(points={{-150,120},{-170,120}}, color={0,127,255}));
  connect(TChiWatChiEnt1.port_b, resEva1.port_a) annotation (Line(points={{-190,
          120},{-200,120},{-200,140}}, color={0,127,255}));
  connect(outPumChiWatPri1.port_b, TChiWatPriSup1.port_a)
    annotation (Line(points={{36,180},{50,180}}, color={0,127,255}));
  connect(TChiWatPriSup1.port_b, mChiWatPri_flow1.port_a)
    annotation (Line(points={{70,180},{90,180}},  color={0,127,255}));
  connect(loa1.port_a, mChiWatPri_flow1.port_b) annotation (Line(points={{10,120},
          {120,120},{120,180},{110,180}},      color={0,127,255}));
  connect(loa1.port_b, rou1.port_aRet) annotation (Line(points={{-10,120},{-36,
          120},{-36,91.791},{-40,91.791}}, color={0,127,255}));
  connect(bouChiWat1.ports[1], loa1.port_b)
    annotation (Line(points={{-20,110},{-20,120},{-10,120}},
                                                        color={0,127,255}));
  connect(coo1.port_b, rou1.ports_aSup[1:nChi])
    annotation (Line(points={{-160,180},{-100,180},{-100,208.209},{-80,208.209}},
                                                    color={0,127,255}));
  connect(resEva1.port_b, coo1.port_a) annotation (Line(points={{-200,160},{-200,
          180},{-180,180}},      color={0,127,255}));
  connect(TChiWat.y, coo1.T_in) annotation (Line(points={{-228,220},{-174,220},{
          -174,192}},color={0,0,127}));
  connect(busPumChiWatPri1, pumChiWatPri1.bus) annotation (Line(
      points={{200,220},{200,200},{-20,200},{-20,190}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatPri.y, busPumChiWatPri1.y)
    annotation (Line(points={{-228,340},{180,340},{180,244},{200,244},{200,220}},
                                                            color={0,0,127}));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri1.y1) annotation (Line(points={{-228,
          300},{160,300},{160,220},{200,220}},   color={255,0,255}));
  connect(pumChiWatPri2.ports_b,outPumChiWatPri2. ports_a)
    annotation (Line(points={{-10,40},{16,40}},  color={0,127,255}));
  connect(mChiWatChi_flow2.port_a,rou2. ports_bRet[1:nChi])
    annotation (Line(points={{-130,-20},{-100,-20},{-100,-48.209},{-80,-48.209}},
                                                    color={0,127,255}));
  connect(mChiWatChi_flow2.port_b,TChiWatChiEnt2. port_a)
    annotation (Line(points={{-150,-20},{-170,-20}}, color={0,127,255}));
  connect(TChiWatChiEnt2.port_b,resEva2. port_a) annotation (Line(points={{-190,
          -20},{-200,-20},{-200,0}},   color={0,127,255}));
  connect(outPumChiWatPri2.port_b,TChiWatPriSup2. port_a)
    annotation (Line(points={{36,40},{50,40}},   color={0,127,255}));
  connect(TChiWatPriSup2.port_b,mChiWatPri_flow2. port_a)
    annotation (Line(points={{70,40},{90,40}},    color={0,127,255}));
  connect(loa2.port_a,mChiWatPri_flow2. port_b) annotation (Line(points={{10,-20},
          {120,-20},{120,40},{110,40}},        color={0,127,255}));
  connect(loa2.port_b,rou2. port_aRet) annotation (Line(points={{-10,-20},{-36,
          -20},{-36,-48.209},{-40,-48.209}},
                                           color={0,127,255}));
  connect(bouChiWat2.ports[1],loa2. port_b)
    annotation (Line(points={{-20,-30},{-20,-20},{-10,-20}},
                                                        color={0,127,255}));
  connect(coo2.port_b,rou2.ports_aSup[1:nChi])
    annotation (Line(points={{-160,40},{-120,40},{-120,68.209},{-80,68.209}},
                                                    color={0,127,255}));
  connect(resEva2.port_b,coo2. port_a) annotation (Line(points={{-200,20},{-200,
          40},{-180,40}},        color={0,127,255}));
  connect(yPumChiWatPri.y,busPumChiWatPri2. y)
    annotation (Line(points={{-228,340},{180,340},{180,104},{200,104},{200,100}},
                                                            color={0,0,127}));
  connect(y1PumChiWatPri.y[1],busPumChiWatPri2. y1) annotation (Line(points={{-228,
          300},{160,300},{160,100},{200,100}},   color={255,0,255}));
  connect(mChiWatEco_flow.port_b, TChiWatEcoEnt.port_a)
    annotation (Line(points={{-150,-120},{-170,-120}}, color={0,127,255}));
  connect(TChiWatEcoEnt.port_b, resEco.port_a) annotation (Line(points={{-190,-120},
          {-200,-120},{-200,-100}}, color={0,127,255}));
  connect(resEco.port_b, cooEco.port_a) annotation (Line(points={{-200,-80},{-200,
          -60},{-180,-60}},   color={0,127,255}));
  connect(rou2.ports_bRet[nChi + 1], mChiWatEco_flow.port_a) annotation (Line(
        points={{-80,-48.209},{-100,-48.209},{-100,-120},{-130,-120}},
                                                                 color={0,127,255}));
  connect(rou2.ports_aSup[nChi + 1], cooEco.port_b) annotation (Line(points={{-80,
          68.209},{-120,68.209},{-120,-60},{-160,-60}},
                                                      color={0,127,255}));
  connect(busPumChiWatPri2, pumChiWatPri2.bus) annotation (Line(
      points={{200,100},{200,60},{-20,60},{-20,50}},
      color={255,204,51},
      thickness=0.5));
  connect(rou1.ports_bSup, pumChiWatPri1.ports_a)
    annotation (Line(points={{-40,208.209},{-36,208.209},{-36,180},{-30,180}},
                                                     color={0,127,255}));
  connect(rou2.ports_bSup, pumChiWatPri2.ports_a)
    annotation (Line(points={{-40,68.209},{-36,68.209},{-36,40},{-30,40}},
                                                       color={0,127,255}));
  connect(pumChiWatPri3.ports_b, outPumChiWatPri3.ports_a)
    annotation (Line(points={{-10,-160},{16,-160}},
                                                 color={0,127,255}));
  connect(mChiWatChi_flow3.port_a, rou3.ports_bRet[1:nChi])
    annotation (Line(points={{-130,-220},{-100,-220},{-100,-248.209},{-80,
          -248.209}},                               color={0,127,255}));
  connect(mChiWatChi_flow3.port_b, TChiWatChiEnt3.port_a)
    annotation (Line(points={{-150,-220},{-170,-220}},
                                                     color={0,127,255}));
  connect(TChiWatChiEnt3.port_b, resEva3.port_a) annotation (Line(points={{-190,
          -220},{-200,-220},{-200,-200}},
                                       color={0,127,255}));
  connect(outPumChiWatPri3.port_b, TChiWatPriSup3.port_a)
    annotation (Line(points={{36,-160},{50,-160}},
                                                 color={0,127,255}));
  connect(TChiWatPriSup3.port_b, mChiWatPri_flow3.port_a)
    annotation (Line(points={{70,-160},{90,-160}},
                                                 color={0,127,255}));
  connect(loa3.port_b, rou3.port_aRet) annotation (Line(points={{-10,-220},{-36,
          -220},{-36,-248.209},{-40,-248.209}},
                                           color={0,127,255}));
  connect(bouChiWat3.ports[1], loa3.port_b) annotation (Line(points={{-20,-230},
          {-20,-220},{-10,-220}},
                                color={0,127,255}));
  connect(coo3.port_b, rou3.ports_aSup[1:nChi])
    annotation (Line(points={{-160,-160},{-120,-160},{-120,-131.791},{-80,
          -131.791}},                               color={0,127,255}));
  connect(resEva3.port_b, coo3.port_a) annotation (Line(points={{-200,-180},{-200,
          -160},{-180,-160}},    color={0,127,255}));
  connect(TChiWat.y, coo3.T_in) annotation (Line(points={{-228,220},{-220,220},{
          -220,-180},{-174,-180},{-174,-148}},
                       color={0,0,127}));
  connect(TChiWat.y, coo1.T_in) annotation (Line(points={{-228,220},{-174,220},{
          -174,192}},color={0,0,127}));
  connect(TChiWat.y,coo2. T_in) annotation (Line(points={{-228,220},{-220,220},{
          -220,60},{-174,60},{-174,52}},
                     color={0,0,127}));
  connect(TChiWat[1].y, cooEco.T_in) annotation (Line(points={{-228,220},{-220,220},
          {-220,-40},{-174,-40},{-174,-48}},
                        color={0,0,127}));
  connect(rou3.ports_bSup, pumChiWatPri3.ports_a)
    annotation (Line(points={{-40,-131.791},{-36,-131.791},{-36,-160},{-30,-160}},
                                                     color={0,127,255}));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri3.y1) annotation (Line(points={{-228,
          300},{160,300},{160,-100},{200,-100}},    color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(yPumChiWatPri.y, busPumChiWatPri3.y) annotation (Line(points={{-228,340},
          {180,340},{180,-136},{200,-136},{200,-100}},   color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busPumChiWatPri3, pumChiWatPri3.bus) annotation (Line(
      points={{200,-100},{200,-140},{-20,-140},{-20,-150}},
      color={255,204,51},
      thickness=0.5));
  connect(TChiWat[1].y, cooEco1.T_in) annotation (Line(points={{-228,220},{-220,
          220},{-220,-280},{-174,-280},{-174,-248}},
                             color={0,0,127}));
  connect(cooEco1.port_b, rou3.ports_aSup[nChi + 1]) annotation (Line(points={{-160,
          -260},{-120,-260},{-120,-131.791},{-80,-131.791}},
                                                     color={0,127,255}));
  connect(mChiWatEco_flow1.port_b, TChiWatEcoEnt1.port_a)
    annotation (Line(points={{-150,-320},{-170,-320}}, color={0,127,255}));
  connect(TChiWatEcoEnt1.port_b, resEco1.port_a) annotation (Line(points={{-190,
          -320},{-200,-320},{-200,-300}}, color={0,127,255}));
  connect(resEco1.port_b, cooEco1.port_a) annotation (Line(points={{-200,-280},{
          -200,-260},{-180,-260}}, color={0,127,255}));
  connect(mChiWatEco_flow1.port_a, pumEco.port_b) annotation (Line(points={{-130,
          -320},{-100,-320},{-100,-290}}, color={0,127,255}));
  connect(pumEco.port_a, rou3.ports_bRet[nChi + 1]) annotation (Line(points={{-100,
          -270},{-100,-248.209},{-80,-248.209}},
                                         color={0,127,255}));
  connect(busPumChiWatEco, pumEco.bus) annotation (Line(
      points={{200,-160},{200,-280},{-90,-280}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatPri.y, busPumChiWatEco.y) annotation (Line(points={{-228,340},
          {180,340},{180,-196},{200,-196},{200,-160}}, color={0,0,127}));
  connect(y1PumChiWatPri[1].y[1], busPumChiWatEco.y1) annotation (Line(points={{-228,
          300},{160,300},{160,-160},{200,-160}},      color={255,0,255}));
  connect(yValChiWatEcoByp.y[1], busValChiWatEcoByp.y) annotation (Line(points={{-228,
          260},{150,260},{150,40},{200,40}},        color={0,0,127}));
  connect(cooEco.port_b, valChiWatEcoByp1.port_b) annotation (Line(points={{-160,
          -60},{-120,-60},{-120,-80}}, color={0,127,255}));
  connect(mChiWatEco_flow.port_a, valChiWatEcoByp1.port_a) annotation (Line(
        points={{-130,-120},{-120,-120},{-120,-100}}, color={0,127,255}));
  connect(busValChiWatEcoByp, valChiWatEcoByp1.bus) annotation (Line(
      points={{200,40},{200,-90},{-110,-90}},
      color={255,204,51},
      thickness=0.5));
  connect(booToRea.y,comSigLoa. u)
    annotation (Line(points={{220,168},{220,162}},   color={0,0,127}));
  connect(busPumChiWatPri1.y1_actual, booToRea.u) annotation (Line(
      points={{200,220},{220,220},{220,192}},
      color={255,204,51},
      thickness=0.5));
  connect(comSigLoa.y, loa1.u)
    annotation (Line(points={{220,138},{220,126},{12,126}}, color={0,0,127}));
  connect(booToRea1.y, comSigLoa1.u)
    annotation (Line(points={{240,28},{240,22}}, color={0,0,127}));
  connect(comSigLoa1.y, loa2.u)
    annotation (Line(points={{240,-2},{240,-14},{12,-14}},
                                                         color={0,0,127}));
  connect(busPumChiWatPri2.y1_actual, booToRea1.u) annotation (Line(
      points={{200,100},{220,100},{220,60},{240,60},{240,52}},
      color={255,204,51},
      thickness=0.5));
  connect(booToRea2.y, comSigLoa2.u)
    annotation (Line(points={{240,-172},{240,-178}}, color={0,0,127}));
  connect(busPumChiWatPri3.y1_actual, booToRea2.u) annotation (Line(
      points={{200,-100},{220,-100},{220,-140},{240,-140},{240,-148}},
      color={255,204,51},
      thickness=0.5));
  connect(mChiWatPri_flow3.port_b, loa3.port_a) annotation (Line(points={{110,-160},
          {120,-160},{120,-220},{10,-220}},       color={0,127,255}));
  connect(comSigLoa2.y, loa3.u) annotation (Line(points={{240,-202},{240,-214},{
          12,-214}},  color={0,0,127}));
  connect(pas.port_b, rou1.ports_aSup[nChi + 1]) annotation (Line(points={{-100,
          160},{-100,208.209},{-80,208.209}},
                                      color={0,127,255}));
  connect(rou1.ports_bRet[nChi + 1], pas.port_a) annotation (Line(points={{-80,
          91.791},{-100,91.791},{-100,140}},
                                       color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-260,-360},{260,360}})),
  experiment(
      StopTime=2000,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Chillers/Components/Validation/ChillersToPrimaryPumpsSeries.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates the hydronic interface model
<a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.Routing.ChillersToPrimaryPumps\">
Buildings.Templates.Plants.Chillers.Components.Routing.ChillersToPrimaryPumps</a>
for various plant configurations where the chillers are connected
in series.
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
<li>
The third configuration has a waterside economizer with a heat exchanger
pump to control the CHW flow rate.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 17, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillersToPrimaryPumpsSeries;
