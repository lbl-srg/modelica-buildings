within Buildings.Templates.ChilledWaterPlants.Components.Validation;
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
    "CHW mass flow rate for each chiller"
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
    "CHW pressure drop for each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChiWatEco_nominal=
    Buildings.Templates.Data.Defaults.dpChiWatEco
    "WSE CHW pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi](
    each min=0)=fill(1e6, nChi)
    "Cooling capacity for each chiller (>0)"
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

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatPri[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Primary CHW pumps Start/Stop signal"
    annotation (Placement(transformation(extent={{-250,370},{-230,390}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatPri(
    k=1) "Primary CHW pump speed signal"
    annotation (Placement(transformation(extent={{-250,410},{-230,430}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWat[nChi](
    each final k=TChiWatSup_nominal)
    "CHW supply temperature set point"
    annotation (Placement(transformation(extent={{-250,250},{-230,270}})));
  Routing.ChillersToPrimaryPumps rou1(
    redeclare final package MediumChiWat=MediumChiWat,
    final nChi=nChi,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final typArrChi=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series,
    final typArrPumChiWatPri=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated,
    final typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None)
    "Series chillers, headered pumps, no WSE"
    annotation (Placement(transformation(extent={{-80,130},{-40,250}})));
  Fluid.FixedResistances.PressureDrop resEva1[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,190})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri1(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{16,210},{36,230}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri1(
    redeclare final package Medium=MediumChiWat,
    final dat=datPumChiWatPri,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon,
    final energyDynamics=energyDynamics)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-30,210},{-10,230}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt1[nChi](
    redeclare each final package  Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,150},{-190,170}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow1[nChi](
    redeclare each final package Medium=MediumChiWat)
    "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,150},{-150,170}})));
  Fluid.HeatExchangers.HeaterCooler_u loa1(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{10,150},{-10,170}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup1(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,220})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow1(
    redeclare final package Medium=MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,210},{110,230}})));
  Fluid.Sources.Boundary_pT bouChiWat1(
    redeclare final package Medium=MediumChiWat,
    final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,140})));
  Fluid.Sources.PropertySource_T coo1[nChi](
    redeclare each final package Medium=MediumChiWat,
    each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,210},{-160,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatChiByp[nChi](
    each table=[0,1; 1.1,1; 1.1,0; 2,0],
    each timeScale=1000,
    each period=2000) "CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-250,330},{-230,350}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiByp[nChi]
    "CHW bypass valves control bus" annotation (Placement(transformation(extent=
           {{220,260},{260,300}}), iconTransformation(extent={{-316,184},{-276,224}})));
  .Buildings.Templates.ChilledWaterPlants.Interfaces.Bus busPla
    "Plant control bus" annotation (Placement(transformation(extent={{220,240},
            {260,280}}), iconTransformation(extent={{-432,12},{-412,32}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri1
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,240},{220,280}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Routing.ChillersToPrimaryPumps rou2(
    redeclare final package MediumChiWat=MediumChiWat,
    final nChi=nChi,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final typArrChi=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series,
    final typArrPumChiWatPri=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated,
    final typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve)
    "Series chillers, headered pumps, WSE with CHW bypass valve"
    annotation (Placement(transformation(extent={{-80,-10},{-40,110}})));

  Fluid.FixedResistances.PressureDrop resEva2[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,50})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri2(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{16,70},{36,90}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri2(
    redeclare final package Medium=MediumChiWat,
    final dat=datPumChiWatPri,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon,
    final energyDynamics=energyDynamics)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt2[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,10},{-190,30}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow2[nChi](
    redeclare each final package Medium=MediumChiWat) "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,10},{-150,30}})));
  Fluid.HeatExchangers.HeaterCooler_u loa2(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{10,10},{-10,30}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup2(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,80})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow2(
    redeclare final package Medium=MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Fluid.Sources.Boundary_pT bouChiWat2(
    redeclare final package Medium=MediumChiWat,
    final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,0})));
  Fluid.Sources.PropertySource_T coo2[nChi](
    redeclare each final package Medium=MediumChiWat,
    each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiByp1[nChi]
    "CHW bypass valves control bus" annotation (Placement(transformation(extent=
           {{220,120},{260,160}}), iconTransformation(extent={{-316,184},{-276,224}})));
  .Buildings.Templates.ChilledWaterPlants.Interfaces.Bus busPla1
    "Plant control bus" annotation (Placement(transformation(extent={{220,100},
            {260,140}}), iconTransformation(extent={{-432,12},{-412,32}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri2
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,120},{220,160}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Fluid.FixedResistances.PressureDrop resEco(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatEco_flow_nominal,
    final dp_nominal=dpChiWatEco_nominal)
    "Flow resistance for WSE HX"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,-50})));
  Fluid.Sensors.TemperatureTwoPort TChiWatEcoEnt(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatEco_flow_nominal)
    "WSE entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-90},{-190,-70}})));
  Fluid.Sensors.MassFlowRate mChiWatEco_flow(
    redeclare final package Medium=MediumChiWat)
    "WSE CHW flow"
    annotation (Placement(transformation(extent={{-130,-90},{-150,-70}})));
  Fluid.Sources.PropertySource_T cooEco(
    redeclare final package Medium=MediumChiWat,  final use_T_in=true)
    "Ideal cooling to input set point (representing WSE)"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Routing.ChillersToPrimaryPumps rou3(
    redeclare final package MediumChiWat=MediumChiWat,
    final nChi=nChi,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final typArrChi=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series,
    final typArrPumChiWatPri=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated,
    final typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithPump)
    "Series chillers, headered pumps, WSE with HX pump"
    annotation (Placement(transformation(extent={{-80,-210},{-40,-90}})));

  Fluid.FixedResistances.PressureDrop resEva3[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,-150})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri3(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{16,-130},{36,-110}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri3(
    redeclare final package Medium=MediumChiWat,
    final dat=datPumChiWatPri,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon,
    final energyDynamics=energyDynamics)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-30,-130},{-10,-110}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt3
                                                [nChi](redeclare each final
      package Medium=MediumChiWat, final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-190},{-190,-170}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow3
                                            [nChi](redeclare each final package
      Medium=MediumChiWat)                          "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,-190},{-150,-170}})));
  Fluid.HeatExchangers.HeaterCooler_u loa3(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{10,-190},{-10,-170}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup3(redeclare final package
      Medium=MediumChiWat, final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,-120})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow3(
    redeclare final package Medium=MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,-130},{110,-110}})));
  Fluid.Sources.Boundary_pT bouChiWat3(
    redeclare final package Medium=MediumChiWat,
      final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,-200})));
  Fluid.Sources.PropertySource_T coo3[nChi](
    redeclare each final package Medium=MediumChiWat,
    each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri3
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,-80},{220,-40}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Fluid.Sensors.MassFlowRate mChiWatEco_flow1(
    redeclare final package Medium=MediumChiWat)
    "WSE CHW flow"
    annotation (Placement(transformation(extent={{-130,-290},{-150,-270}})));
  Fluid.Sources.PropertySource_T cooEco1(
    redeclare final package Medium=MediumChiWat,
    final use_T_in=true)
    "Ideal cooling to input set point (representing WSE)"
    annotation (Placement(transformation(extent={{-180,-230},{-160,-210}})));
  Fluid.FixedResistances.PressureDrop resEco1(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatEco_flow_nominal,
    final dp_nominal=dpChiWatEco_nominal)
    "Flow resistance for WSE HX"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,-250})));
  Fluid.Sensors.TemperatureTwoPort TChiWatEcoEnt1(redeclare final package
      Medium=MediumChiWat, final m_flow_nominal=mChiWatEco_flow_nominal)
    "WSE entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-290},{-190,-270}})));
  .Buildings.Templates.ChilledWaterPlants.Interfaces.Bus busPla2
    "Plant control bus" annotation (Placement(transformation(extent={{220,-100},
            {260,-60}}), iconTransformation(extent={{-432,12},{-412,32}})));

  Buildings.Templates.Components.Pumps.Single pumEco(
    final dat=datPumChiWatEco,
    typCtrSpe=Buildings.Templates.Components.Types.PumpSingleSpeedControl.Variable,
    final energyDynamics=energyDynamics)
    "WSE HX pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,-240})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatEco
    "WSE HX pump control bus"
    annotation (Placement(transformation(extent={{180,-140},{220,-100}}),
                                iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiByp2[nChi]
    "CHW bypass valves control bus" annotation (Placement(transformation(extent=
           {{220,-80},{260,-40}}), iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatEcoByp
    "WSE CHW bypass valve control bus" annotation (Placement(transformation(
          extent={{180,60},{220,100}}),iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable yValChiWatEcoByp(table=[0,
        1; 1.5,1; 1.5,0; 2,0], timeScale=1000)
    "WSE CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-250,290},{-230,310}})));
  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatEcoByp1(
      redeclare final package Medium=MediumChiWat, final dat=datValChiWatEcoByp)
    "WSE CHW bypass valve" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-120,-50})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert pump return signal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={220,220})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum comSigLoa(k=fill(1/nChi, nChi),
      nin=nChi) "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={220,190})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
                                                               [nChi]
    "Convert pump return signal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,80})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum comSigLoa1(k=fill(1/nChi, nChi),
      nin=nChi) "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,50})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
                                                               [nChi]
    "Convert pump return signal to real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,-120})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum comSigLoa2(k=fill(1/nChi, nChi),
      nin=nChi) "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,-150})));
equation
  connect(pumChiWatPri1.ports_b, outPumChiWatPri1.ports_a)
    annotation (Line(points={{-10,220},{16,220}},color={0,127,255}));
  connect(mChiWatChi_flow1.port_a, rou1.ports_bRet[1:nChi])
    annotation (Line(points={{-130,160},{-106,160},{-106,140},{-80,140}},
                                                    color={0,127,255}));
  connect(mChiWatChi_flow1.port_b, TChiWatChiEnt1.port_a)
    annotation (Line(points={{-150,160},{-170,160}}, color={0,127,255}));
  connect(TChiWatChiEnt1.port_b, resEva1.port_a) annotation (Line(points={{-190,
          160},{-200,160},{-200,180}}, color={0,127,255}));
  connect(outPumChiWatPri1.port_b, TChiWatPriSup1.port_a)
    annotation (Line(points={{36,220},{50,220}}, color={0,127,255}));
  connect(TChiWatPriSup1.port_b, mChiWatPri_flow1.port_a)
    annotation (Line(points={{70,220},{90,220}},  color={0,127,255}));
  connect(loa1.port_a, mChiWatPri_flow1.port_b) annotation (Line(points={{10,160},
          {120,160},{120,220},{110,220}},      color={0,127,255}));
  connect(loa1.port_b, rou1.port_aRet) annotation (Line(points={{-10,160},{-36,160},
          {-36,139.9},{-40.1,139.9}},      color={0,127,255}));
  connect(bouChiWat1.ports[1], loa1.port_b)
    annotation (Line(points={{-20,150},{-20,160},{-10,160}},
                                                        color={0,127,255}));
  connect(coo1.port_b, rou1.ports_aSup[1:nChi])
    annotation (Line(points={{-160,220},{-120,220},{-120,240},{-80,240}},
                                                    color={0,127,255}));
  connect(resEva1.port_b, coo1.port_a) annotation (Line(points={{-200,200},{
          -200,220},{-180,220}}, color={0,127,255}));
  connect(TChiWat.y, coo1.T_in) annotation (Line(points={{-228,260},{-174,260},
          {-174,232}},
                     color={0,0,127}));
  connect(y1ValChiWatChiByp.y[1], busValChiWatChiByp.y1) annotation (Line(
        points={{-228,340},{170,340},{170,280},{240,280}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busPla, rou1.bus)
    annotation (Line(
      points={{240,260},{240,250},{-60,250}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatChiByp, busPla.valChiWatChiByp) annotation (Line(
      points={{240,280},{240,260}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumChiWatPri1, pumChiWatPri1.bus) annotation (Line(
      points={{200,260},{200,240},{-20,240},{-20,230}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatPri.y, busPumChiWatPri1.y)
    annotation (Line(points={{-228,420},{180,420},{180,284},{200,284},{200,260}},
                                                            color={0,0,127}));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri1.y1) annotation (Line(points={{-228,
          380},{160,380},{160,260},{200,260}},   color={255,0,255}));
  connect(pumChiWatPri2.ports_b,outPumChiWatPri2. ports_a)
    annotation (Line(points={{-10,80},{16,80}},  color={0,127,255}));
  connect(mChiWatChi_flow2.port_a,rou2. ports_bRet[1:nChi])
    annotation (Line(points={{-130,20},{-106,20},{-106,0},{-80,0}},
                                                    color={0,127,255}));
  connect(mChiWatChi_flow2.port_b,TChiWatChiEnt2. port_a)
    annotation (Line(points={{-150,20},{-170,20}},   color={0,127,255}));
  connect(TChiWatChiEnt2.port_b,resEva2. port_a) annotation (Line(points={{-190,20},
          {-200,20},{-200,40}},        color={0,127,255}));
  connect(outPumChiWatPri2.port_b,TChiWatPriSup2. port_a)
    annotation (Line(points={{36,80},{50,80}},   color={0,127,255}));
  connect(TChiWatPriSup2.port_b,mChiWatPri_flow2. port_a)
    annotation (Line(points={{70,80},{90,80}},    color={0,127,255}));
  connect(loa2.port_a,mChiWatPri_flow2. port_b) annotation (Line(points={{10,20},
          {120,20},{120,80},{110,80}},         color={0,127,255}));
  connect(loa2.port_b,rou2. port_aRet) annotation (Line(points={{-10,20},{-36,20},
          {-36,-0.1},{-40.1,-0.1}},        color={0,127,255}));
  connect(bouChiWat2.ports[1],loa2. port_b)
    annotation (Line(points={{-20,10},{-20,20},{-10,20}},
                                                        color={0,127,255}));
  connect(coo2.port_b,rou2.ports_aSup[1:nChi])
    annotation (Line(points={{-160,80},{-120,80},{-120,100},{-80,100}},
                                                    color={0,127,255}));
  connect(resEva2.port_b,coo2. port_a) annotation (Line(points={{-200,60},{-200,
          80},{-180,80}},        color={0,127,255}));
  connect(y1ValChiWatChiByp.y[1], busValChiWatChiByp1.y1) annotation (Line(
        points={{-228,340},{170,340},{170,160},{240,160},{240,140}}, color={255,
          0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busValChiWatChiByp1, busPla1.valChiWatChiByp) annotation (Line(
      points={{240,140},{240,120}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatPri.y,busPumChiWatPri2. y)
    annotation (Line(points={{-228,420},{180,420},{180,144},{200,144},{200,140}},
                                                            color={0,0,127}));
  connect(y1PumChiWatPri.y[1],busPumChiWatPri2. y1) annotation (Line(points={{-228,
          380},{160,380},{160,140},{200,140}},   color={255,0,255}));
  connect(mChiWatEco_flow.port_b, TChiWatEcoEnt.port_a)
    annotation (Line(points={{-150,-80},{-170,-80}},   color={0,127,255}));
  connect(TChiWatEcoEnt.port_b, resEco.port_a) annotation (Line(points={{-190,
          -80},{-200,-80},{-200,-60}},
                                    color={0,127,255}));
  connect(resEco.port_b, cooEco.port_a) annotation (Line(points={{-200,-40},{
          -200,-20},{-180,-20}},
                              color={0,127,255}));
  connect(rou2.ports_bRet[nChi + 1], mChiWatEco_flow.port_a) annotation (Line(
        points={{-80,0},{-100,0},{-100,-80},{-130,-80}},         color={0,127,255}));
  connect(rou2.ports_aSup[nChi + 1], cooEco.port_b) annotation (Line(points={{-80,100},
          {-120,100},{-120,-20},{-160,-20}},          color={0,127,255}));
  connect(busPla1, rou2.bus) annotation (Line(
      points={{240,120},{240,110},{-60,110}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumChiWatPri2, pumChiWatPri2.bus) annotation (Line(
      points={{200,140},{200,100},{-20,100},{-20,90}},
      color={255,204,51},
      thickness=0.5));
  connect(rou1.ports_bSup, pumChiWatPri1.ports_a)
    annotation (Line(points={{-40,240},{-36,240},{-36,220},{-30,220}},
                                                     color={0,127,255}));
  connect(rou2.ports_bSup, pumChiWatPri2.ports_a)
    annotation (Line(points={{-40,100},{-36,100},{-36,80},{-30,80}},
                                                       color={0,127,255}));
  connect(pumChiWatPri3.ports_b, outPumChiWatPri3.ports_a)
    annotation (Line(points={{-10,-120},{16,-120}},
                                                 color={0,127,255}));
  connect(mChiWatChi_flow3.port_a, rou3.ports_bRet[1:nChi])
    annotation (Line(points={{-130,-180},{-106,-180},{-106,-200},{-80,-200}},
                                                    color={0,127,255}));
  connect(mChiWatChi_flow3.port_b, TChiWatChiEnt3.port_a)
    annotation (Line(points={{-150,-180},{-170,-180}},
                                                     color={0,127,255}));
  connect(TChiWatChiEnt3.port_b, resEva3.port_a) annotation (Line(points={{-190,
          -180},{-200,-180},{-200,-160}},
                                       color={0,127,255}));
  connect(outPumChiWatPri3.port_b, TChiWatPriSup3.port_a)
    annotation (Line(points={{36,-120},{50,-120}},
                                                 color={0,127,255}));
  connect(TChiWatPriSup3.port_b, mChiWatPri_flow3.port_a)
    annotation (Line(points={{70,-120},{90,-120}},
                                                 color={0,127,255}));
  connect(loa3.port_b, rou3.port_aRet) annotation (Line(points={{-10,-180},{-36,
          -180},{-36,-200.1},{-40.1,-200.1}},
                                           color={0,127,255}));
  connect(bouChiWat3.ports[1], loa3.port_b) annotation (Line(points={{-20,-190},
          {-20,-180},{-10,-180}},
                                color={0,127,255}));
  connect(coo3.port_b, rou3.ports_aSup[1:nChi])
    annotation (Line(points={{-160,-120},{-120,-120},{-120,-100},{-80,-100}},
                                                    color={0,127,255}));
  connect(resEva3.port_b, coo3.port_a) annotation (Line(points={{-200,-140},{-200,
          -120},{-180,-120}},    color={0,127,255}));
  connect(TChiWat.y, coo3.T_in) annotation (Line(points={{-228,260},{-220,260},{
          -220,-100},{-174,-100},{-174,-108}},
                       color={0,0,127}));
  connect(TChiWat.y, coo1.T_in) annotation (Line(points={{-228,260},{-174,260},
          {-174,232}},
                     color={0,0,127}));
  connect(TChiWat.y,coo2. T_in) annotation (Line(points={{-228,260},{-220,260},
          {-220,100},{-174,100},{-174,92}},
                     color={0,0,127}));
  connect(TChiWat[1].y, cooEco.T_in) annotation (Line(points={{-228,260},{-220,
          260},{-220,0},{-174,0},{-174,-8}},
                        color={0,0,127}));
  connect(rou3.ports_bSup, pumChiWatPri3.ports_a)
    annotation (Line(points={{-40,-100},{-36,-100},{-36,-120},{-30,-120}},
                                                     color={0,127,255}));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri3.y1) annotation (Line(points={{-228,
          380},{160,380},{160,-60},{200,-60}},      color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(yPumChiWatPri.y, busPumChiWatPri3.y) annotation (Line(points={{-228,420},
          {180,420},{180,-56},{200,-56},{200,-60}},      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busPumChiWatPri3, pumChiWatPri3.bus) annotation (Line(
      points={{200,-60},{200,-100},{-20,-100},{-20,-110}},
      color={255,204,51},
      thickness=0.5));
  connect(TChiWat[1].y, cooEco1.T_in) annotation (Line(points={{-228,260},{-220,
          260},{-220,-200},{-174,-200},{-174,-208}},
                             color={0,0,127}));
  connect(cooEco1.port_b, rou3.ports_aSup[nChi + 1]) annotation (Line(points={{-160,
          -220},{-120,-220},{-120,-100},{-80,-100}}, color={0,127,255}));
  connect(mChiWatEco_flow1.port_b, TChiWatEcoEnt1.port_a)
    annotation (Line(points={{-150,-280},{-170,-280}}, color={0,127,255}));
  connect(TChiWatEcoEnt1.port_b, resEco1.port_a) annotation (Line(points={{-190,
          -280},{-200,-280},{-200,-260}}, color={0,127,255}));
  connect(resEco1.port_b, cooEco1.port_a) annotation (Line(points={{-200,-240},{
          -200,-220},{-180,-220}}, color={0,127,255}));
  connect(busPla2, rou3.bus) annotation (Line(
      points={{240,-80},{240,-90},{-60,-90}},
      color={255,204,51},
      thickness=0.5));
  connect(mChiWatEco_flow1.port_a, pumEco.port_b) annotation (Line(points={{-130,
          -280},{-100,-280},{-100,-250}}, color={0,127,255}));
  connect(pumEco.port_a, rou3.ports_bRet[nChi + 1]) annotation (Line(points={{-100,
          -230},{-100,-200},{-80,-200}}, color={0,127,255}));
  connect(busPumChiWatEco, pumEco.bus) annotation (Line(
      points={{200,-120},{200,-240},{-90,-240}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatPri.y, busPumChiWatEco.y) annotation (Line(points={{-228,420},
          {180,420},{180,-116},{200,-116},{200,-120}}, color={0,0,127}));
  connect(y1PumChiWatPri[1].y[1], busPumChiWatEco.y1) annotation (Line(points={{-228,
          380},{160,380},{160,-120},{200,-120}},      color={255,0,255}));
  connect(y1ValChiWatChiByp.y[1], busValChiWatChiByp2.y1) annotation (Line(
        points={{-228,340},{170,340},{170,-40},{240,-40},{240,-60}}, color={255,
          0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busPla2.valChiWatChiByp, busValChiWatChiByp2) annotation (Line(
      points={{240,-80},{240,-60}},
      color={255,204,51},
      thickness=0.5));
  connect(yValChiWatEcoByp.y[1], busValChiWatEcoByp.y) annotation (Line(points=
          {{-228,300},{150,300},{150,80},{200,80}}, color={0,0,127}));
  connect(cooEco.port_b, valChiWatEcoByp1.port_b) annotation (Line(points={{-160,
          -20},{-120,-20},{-120,-40}}, color={0,127,255}));
  connect(mChiWatEco_flow.port_a, valChiWatEcoByp1.port_a) annotation (Line(
        points={{-130,-80},{-120,-80},{-120,-60}},    color={0,127,255}));
  connect(busValChiWatEcoByp, valChiWatEcoByp1.bus) annotation (Line(
      points={{200,80},{200,-50},{-110,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(booToRea.y,comSigLoa. u)
    annotation (Line(points={{220,208},{220,202}},   color={0,0,127}));
  connect(busPumChiWatPri1.y1_actual, booToRea.u) annotation (Line(
      points={{200,260},{220,260},{220,232}},
      color={255,204,51},
      thickness=0.5));
  connect(comSigLoa.y, loa1.u)
    annotation (Line(points={{220,178},{220,166},{12,166}}, color={0,0,127}));
  connect(booToRea1.y, comSigLoa1.u)
    annotation (Line(points={{240,68},{240,62}}, color={0,0,127}));
  connect(comSigLoa1.y, loa2.u)
    annotation (Line(points={{240,38},{240,26},{12,26}}, color={0,0,127}));
  connect(busPumChiWatPri2.y1_actual, booToRea1.u) annotation (Line(
      points={{200,140},{220,140},{220,100},{240,100},{240,92}},
      color={255,204,51},
      thickness=0.5));
  connect(booToRea2.y, comSigLoa2.u)
    annotation (Line(points={{240,-132},{240,-138}}, color={0,0,127}));
  connect(busPumChiWatPri3.y1_actual, booToRea2.u) annotation (Line(
      points={{200,-60},{220,-60},{220,-100},{240,-100},{240,-108}},
      color={255,204,51},
      thickness=0.5));
  connect(mChiWatPri_flow3.port_b, loa3.port_a) annotation (Line(points={{110,
          -120},{120,-120},{120,-180},{10,-180}}, color={0,127,255}));
  connect(comSigLoa2.y, loa3.u) annotation (Line(points={{240,-162},{240,-174},
          {12,-174}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-260,-640},{260,440}})),
  experiment(
      StopTime=2000,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Templates/ChilledWaterPlants/Components/Validation/ChillersToPrimaryPumpsSeries.mos"
    "Simulate and plot"));
end ChillersToPrimaryPumpsSeries;
