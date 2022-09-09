within Buildings.Templates.ChilledWaterPlants.Components.Validation;
model ChillersToPrimaryPumpsSeries
  "Validation model for hydronic interface between series chillers and primary pumps"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";

  parameter Integer nChi=3
    "Number of chillers";

  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi]=
    fill(30, nChi)
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
    fill(4E4, nChi)
    "CHW pressure drop for each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChiWatEco_nominal=4E4
    "WSE CHW pressure dro"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal[nChi](
    each min=0)=fill(1e6, nChi)
    "Design cooling load for each chiller (>0)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=6+273.15
    "CHW supply temperature";

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  final parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWatChi(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nChi,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal);
  final parameter Buildings.Templates.Components.Data.PumpSingle datPumChiWatEco(
    final typ=Buildings.Templates.Components.Types.Pump.Single,
    final m_flow_nominal=mChiWatEco_flow_nominal,
    final dp_nominal=dpChiWatEco_nominal);
  final parameter Buildings.Templates.Components.Data.Valve datValChiWatEcoByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    final m_flow_nominal=mChiWatEco_flow_nominal,
    final dpValve_nominal=dpChiWatEco_nominal);

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatPri[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Primary CHW pumps Start/Stop signal"
    annotation (Placement(transformation(extent={{-250,370},{-230,390}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatPri(
    k=1) "Primary CHW pumps speed signal"
    annotation (Placement(transformation(extent={{-250,410},{-230,430}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWat[nChi](
    each final k=TChiWatSup_nominal)
    "CHW supply temperature set point"
    annotation (Placement(transformation(extent={{-250,250},{-230,270}})));
  Routing.ChillersToPrimaryPumps rou1(
    redeclare final package Medium = Medium,
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
    redeclare each final package Medium = Medium,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,190})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri1(
    redeclare final package Medium = Medium,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{16,210},{36,230}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri1(
    redeclare final package Medium = Medium,
    final dat=datPumChiWatChi,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt1
                                                [nChi](redeclare each final
      package Medium = Medium, final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,150},{-190,170}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow1
                                            [nChi](redeclare each final package
      Medium = Medium) "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,150},{-150,170}})));
  Fluid.HeatExchangers.HeaterCooler_u loa1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(Q_flow_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{10,150},{-10,170}})));
  Modelica.Blocks.Sources.RealExpression sigModLoa1(y=sum(pumChiWatPri1.sigCon.y)
        /nChi)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-10,164},{10,184}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup1(redeclare final package
      Medium = Medium, final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,220})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow1(redeclare final package Medium =
        Medium)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,210},{110,230}})));
  Fluid.Sources.Boundary_pT bouChiWat1(redeclare final package Medium = Medium,
      final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,140})));
  Fluid.Sources.PropertySource_T coo1
                                    [nChi](redeclare each final package Medium
      = Medium, each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,210},{-160,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiByp[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-250,330},{-230,350}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiBypSer[nChi]
    "CHW bypass valves control bus"
                  annotation (Placement(transformation(extent={{220,250},{260,
            290}}), iconTransformation(extent={{-316,184},{-276,224}})));
  Interfaces.Bus busPla "Plant control bus" annotation (Placement(
        transformation(extent={{220,230},{260,270}}), iconTransformation(extent=
           {{-432,12},{-412,32}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri1
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,250},{220,290}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Routing.ChillersToPrimaryPumps rou2(
    redeclare final package Medium = Medium,
    final nChi=nChi,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final typArrChi=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series,
    final typArrPumChiWatPri=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated,
    final typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.EconomizerWithValve)
    "Series chillers, headered pumps, WSE with CHW bypass valve"
    annotation (Placement(transformation(extent={{-80,-10},{-40,110}})));

  Fluid.FixedResistances.PressureDrop resEva2
                                            [nChi](
    redeclare each final package Medium = Medium,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,50})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri2(
    redeclare final package Medium = Medium,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{16,70},{36,90}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri2(
    redeclare final package Medium = Medium,
    final dat=datPumChiWatChi,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt2
                                                [nChi](redeclare each final
      package Medium = Medium, final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,10},{-190,30}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow2
                                            [nChi](redeclare each final package
      Medium = Medium) "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,10},{-150,30}})));
  Fluid.HeatExchangers.HeaterCooler_u loa2(
    redeclare final package Medium = Medium,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(Q_flow_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{10,10},{-10,30}})));
  Modelica.Blocks.Sources.RealExpression sigModLoa2(y=sum(pumChiWatPri2.sigCon.y)
        /nChi)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-10,24},{10,44}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup2(redeclare final package
      Medium = Medium, final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,80})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow2(
    redeclare final package Medium=Medium)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Fluid.Sources.Boundary_pT bouChiWat2(
    redeclare final package Medium = Medium,
    final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,0})));
  Fluid.Sources.PropertySource_T coo2[nChi](
    redeclare each final package Medium=Medium,
    each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiBypSer1[nChi]
    "CHW bypass valves control bus"
                  annotation (Placement(transformation(extent={{220,110},{260,
            150}}), iconTransformation(extent={{-316,184},{-276,224}})));
  Interfaces.Bus busPla1 "Plant control bus"
    annotation (Placement(
        transformation(extent={{220,90},{260,130}}),    iconTransformation(extent=
           {{-432,12},{-412,32}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri2
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,110},{220,150}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Fluid.FixedResistances.PressureDrop resEco(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChiWatEco_flow_nominal,
    final dp_nominal=dpChiWatEco_nominal)
    "Flow resistance for WSE HX"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,-50})));
  Fluid.Sensors.TemperatureTwoPort TChiWatEcoEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChiWatEco_flow_nominal)
    "WSE entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-90},{-190,-70}})));
  Fluid.Sensors.MassFlowRate mChiWatEco_flow(
    redeclare final package Medium = Medium)
    "WSE CHW flow"
    annotation (Placement(transformation(extent={{-130,-90},{-150,-70}})));
  Fluid.Sources.PropertySource_T cooEco(
    redeclare final package Medium=Medium,  final use_T_in=true)
    "Ideal cooling to input set point (representing WSE)"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Routing.ChillersToPrimaryPumps rou3(
    redeclare final package Medium = Medium,
    final nChi=nChi,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final typArrChi=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series,
    final typArrPumChiWatPri=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated,
    final typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.EconomizerWithPump)
    "Series chillers, headered pumps, WSE with HX pump"
    annotation (Placement(transformation(extent={{-80,-220},{-40,-100}})));

  Fluid.FixedResistances.PressureDrop resEva3[nChi](
    redeclare each final package Medium = Medium,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,-160})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri3(
    redeclare final package Medium = Medium,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{16,-140},{36,-120}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri3(
    redeclare final package Medium = Medium,
    final dat=datPumChiWatChi,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-10,-140},{10,-120}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt3
                                                [nChi](redeclare each final
      package Medium = Medium, final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-200},{-190,-180}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow3
                                            [nChi](redeclare each final package
      Medium = Medium)                          "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,-200},{-150,-180}})));
  Fluid.HeatExchangers.HeaterCooler_u loa3(
    redeclare final package Medium = Medium,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(Q_flow_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{10,-200},{-10,-180}})));
  Modelica.Blocks.Sources.RealExpression sigModLoa3(y=sum(pumChiWatPri3.sigCon.y)
        /nChi)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-10,-186},{10,-166}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup3(redeclare final package
      Medium = Medium, final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,-130})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow3(redeclare final package Medium =
        Medium)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,-140},{110,-120}})));
  Fluid.Sources.Boundary_pT bouChiWat3(redeclare final package Medium = Medium,
      final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,-210})));
  Fluid.Sources.PropertySource_T coo3
                                    [nChi](redeclare each final package Medium
      = Medium, each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,-140},{-160,-120}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri3
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,-100},{220,-60}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Fluid.Sensors.MassFlowRate mChiWatEco_flow1(redeclare final package Medium =
        Medium)
    "WSE CHW flow"
    annotation (Placement(transformation(extent={{-130,-300},{-150,-280}})));
  Fluid.Sources.PropertySource_T cooEco1(redeclare final package Medium =
        Medium, final use_T_in=true)
    "Ideal cooling to input set point (representing WSE)"
    annotation (Placement(transformation(extent={{-180,-240},{-160,-220}})));
  Fluid.FixedResistances.PressureDrop resEco1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChiWatEco_flow_nominal,
    final dp_nominal=dpChiWatEco_nominal)
    "Flow resistance for WSE HX"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,-260})));
  Fluid.Sensors.TemperatureTwoPort TChiWatEcoEnt1(redeclare final package
      Medium = Medium, final m_flow_nominal=mChiWatEco_flow_nominal)
    "WSE entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-300},{-190,-280}})));
  Interfaces.Bus busPla2
    "Plant control bus"
    annotation (Placement(
        transformation(extent={{220,-120},{260,-80}}),  iconTransformation(extent=
           {{-432,12},{-412,32}})));

  Buildings.Templates.Components.Pumps.Single pumEco(
    final dat=datPumChiWatEco,
    typCtrSpe=Buildings.Templates.Components.Types.PumpSingleSpeedControl.Variable)
    "WSE HX pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,-250})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatEco
    "WSE HX pump control bus"
    annotation (Placement(transformation(extent={{180,-160},{220,-120}}),
                                iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiBypSer2[nChi]
    "CHW bypass valves control bus"
                  annotation (Placement(transformation(extent={{220,-100},{260,
            -60}}), iconTransformation(extent={{-316,184},{-276,224}})));
  Fluid.Delays.DelayFirstOrder del(
    redeclare final package Medium = Medium,
    final tau=10,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final prescribedHeatFlowRate=false,
    nPorts=2)
    "Delay for primary CHW flow circulation"
    annotation (Placement(transformation(extent={{50,-190},{70,-170}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatEcoByp
    "WSE CHW bypass valve control bus" annotation (Placement(transformation(
          extent={{180,50},{220,90}}), iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable y1ValChiWatEcoByp(table=[0,
        0; 1,0; 1,1; 2,1], timeScale=1000)
    "WSE CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-250,290},{-230,310}})));
  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatEcoByp1(
      redeclare final package Medium = Medium, final dat=datValChiWatEcoByp)
    "WSE CHW bypass valve" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-120,-50})));
equation
  connect(pumChiWatPri1.ports_b, outPumChiWatPri1.ports_a)
    annotation (Line(points={{10,220},{16,220}}, color={0,127,255}));
  connect(mChiWatChi_flow1.port_a, rou1.ports_bRet[1:nChi])
    annotation (Line(points={{-130,160},{-80,160}}, color={0,127,255}));
  connect(mChiWatChi_flow1.port_b, TChiWatChiEnt1.port_a)
    annotation (Line(points={{-150,160},{-170,160}}, color={0,127,255}));
  connect(TChiWatChiEnt1.port_b, resEva1.port_a) annotation (Line(points={{-190,
          160},{-200,160},{-200,180}}, color={0,127,255}));
  connect(sigModLoa1.y, loa1.u) annotation (Line(points={{11,174},{20,174},{20,
          166},{12,166}}, color={0,0,127}));
  connect(outPumChiWatPri1.port_b, TChiWatPriSup1.port_a)
    annotation (Line(points={{36,220},{50,220}}, color={0,127,255}));
  connect(TChiWatPriSup1.port_b, mChiWatPri_flow1.port_a)
    annotation (Line(points={{70,220},{90,220}},  color={0,127,255}));
  connect(loa1.port_a, mChiWatPri_flow1.port_b) annotation (Line(points={{10,160},
          {120,160},{120,220},{110,220}},      color={0,127,255}));
  connect(loa1.port_b, rou1.port_aRet) annotation (Line(points={{-10,160},{-36,
          160},{-36,159.9},{-40.1,159.9}}, color={0,127,255}));
  connect(bouChiWat1.ports[1], loa1.port_b)
    annotation (Line(points={{-20,150},{-20,160},{-10,160}},
                                                        color={0,127,255}));
  connect(coo1.port_b, rou1.ports_aSup[1:nChi])
    annotation (Line(points={{-160,220},{-80,220}}, color={0,127,255}));
  connect(resEva1.port_b, coo1.port_a) annotation (Line(points={{-200,200},{
          -200,220},{-180,220}}, color={0,127,255}));
  connect(TChiWat.y, coo1.T_in) annotation (Line(points={{-228,260},{-174,260},
          {-174,232}},
                     color={0,0,127}));
  connect(y1ValChiByp.y[1], busValChiBypSer.y1) annotation (Line(points={{-228,
          340},{170,340},{170,290},{240,290},{240,270}},
                                                    color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busPla, rou1.bus)
    annotation (Line(
      points={{240,250},{-60,250}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiBypSer, busPla.valChiBypSer) annotation (Line(
      points={{240,270},{240,250}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumChiWatPri1, pumChiWatPri1.bus) annotation (Line(
      points={{200,270},{200,240},{0,240},{0,230}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatPri.y, busPumChiWatPri1.y)
    annotation (Line(points={{-228,420},{180,420},{180,274},{200,274},{200,270}},
                                                            color={0,0,127}));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri1.y1) annotation (Line(points={{-228,
          380},{160,380},{160,270},{200,270}},   color={255,0,255}));
  connect(pumChiWatPri2.ports_b,outPumChiWatPri2. ports_a)
    annotation (Line(points={{10,80},{16,80}},   color={0,127,255}));
  connect(mChiWatChi_flow2.port_a,rou2. ports_bRet[1:nChi])
    annotation (Line(points={{-130,20},{-80,20}},   color={0,127,255}));
  connect(mChiWatChi_flow2.port_b,TChiWatChiEnt2. port_a)
    annotation (Line(points={{-150,20},{-170,20}},   color={0,127,255}));
  connect(TChiWatChiEnt2.port_b,resEva2. port_a) annotation (Line(points={{-190,20},
          {-200,20},{-200,40}},        color={0,127,255}));
  connect(sigModLoa2.y,loa2. u) annotation (Line(points={{11,34},{20,34},{20,26},
          {12,26}},       color={0,0,127}));
  connect(outPumChiWatPri2.port_b,TChiWatPriSup2. port_a)
    annotation (Line(points={{36,80},{50,80}},   color={0,127,255}));
  connect(TChiWatPriSup2.port_b,mChiWatPri_flow2. port_a)
    annotation (Line(points={{70,80},{90,80}},    color={0,127,255}));
  connect(loa2.port_a,mChiWatPri_flow2. port_b) annotation (Line(points={{10,20},
          {120,20},{120,80},{110,80}},         color={0,127,255}));
  connect(loa2.port_b,rou2. port_aRet) annotation (Line(points={{-10,20},{-36,
          20},{-36,19.9},{-40.1,19.9}},    color={0,127,255}));
  connect(bouChiWat2.ports[1],loa2. port_b)
    annotation (Line(points={{-20,10},{-20,20},{-10,20}},
                                                        color={0,127,255}));
  connect(coo2.port_b,rou2.ports_aSup[1:nChi])
    annotation (Line(points={{-160,80},{-80,80}},   color={0,127,255}));
  connect(resEva2.port_b,coo2. port_a) annotation (Line(points={{-200,60},{-200,
          80},{-180,80}},        color={0,127,255}));
  connect(y1ValChiByp.y[1], busValChiBypSer1.y1) annotation (Line(points={{-228,
          340},{170,340},{170,150},{240,150},{240,130}},
                                                      color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busValChiBypSer1, busPla1.valChiBypSer) annotation (Line(
      points={{240,130},{240,110}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatPri.y,busPumChiWatPri2. y)
    annotation (Line(points={{-228,420},{180,420},{180,134},{200,134},{200,130}},
                                                            color={0,0,127}));
  connect(y1PumChiWatPri.y[1],busPumChiWatPri2. y1) annotation (Line(points={{-228,
          380},{160,380},{160,130},{200,130}},   color={255,0,255}));
  connect(mChiWatEco_flow.port_b, TChiWatEcoEnt.port_a)
    annotation (Line(points={{-150,-80},{-170,-80}},   color={0,127,255}));
  connect(TChiWatEcoEnt.port_b, resEco.port_a) annotation (Line(points={{-190,
          -80},{-200,-80},{-200,-60}},
                                    color={0,127,255}));
  connect(resEco.port_b, cooEco.port_a) annotation (Line(points={{-200,-40},{
          -200,-20},{-180,-20}},
                              color={0,127,255}));
  connect(rou2.ports_bRet[nChi + 1], mChiWatEco_flow.port_a) annotation (Line(
        points={{-80,20},{-100,20},{-100,-80},{-130,-80}},       color={0,127,255}));
  connect(rou2.ports_aSup[nChi + 1], cooEco.port_b) annotation (Line(points={{-80,80},
          {-120,80},{-120,-20},{-160,-20}},           color={0,127,255}));
  connect(busPla1, rou2.bus) annotation (Line(
      points={{240,110},{-60,110}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumChiWatPri2, pumChiWatPri2.bus) annotation (Line(
      points={{200,130},{200,100},{0,100},{0,90}},
      color={255,204,51},
      thickness=0.5));
  connect(rou1.ports_bSup, pumChiWatPri1.ports_a)
    annotation (Line(points={{-40.2,220},{-10,220}}, color={0,127,255}));
  connect(rou2.ports_bSup, pumChiWatPri2.ports_a)
    annotation (Line(points={{-40.2,80},{-10,80}},     color={0,127,255}));
  connect(pumChiWatPri3.ports_b, outPumChiWatPri3.ports_a)
    annotation (Line(points={{10,-130},{16,-130}},
                                                 color={0,127,255}));
  connect(mChiWatChi_flow3.port_a, rou3.ports_bRet[1:nChi])
    annotation (Line(points={{-130,-190},{-80,-190}},
                                                    color={0,127,255}));
  connect(mChiWatChi_flow3.port_b, TChiWatChiEnt3.port_a)
    annotation (Line(points={{-150,-190},{-170,-190}},
                                                     color={0,127,255}));
  connect(TChiWatChiEnt3.port_b, resEva3.port_a) annotation (Line(points={{-190,
          -190},{-200,-190},{-200,-170}},
                                       color={0,127,255}));
  connect(sigModLoa3.y, loa3.u) annotation (Line(points={{11,-176},{20,-176},{
          20,-184},{12,-184}},
                          color={0,0,127}));
  connect(outPumChiWatPri3.port_b, TChiWatPriSup3.port_a)
    annotation (Line(points={{36,-130},{50,-130}},
                                                 color={0,127,255}));
  connect(TChiWatPriSup3.port_b, mChiWatPri_flow3.port_a)
    annotation (Line(points={{70,-130},{90,-130}},
                                                 color={0,127,255}));
  connect(loa3.port_b, rou3.port_aRet) annotation (Line(points={{-10,-190},{-36,
          -190},{-36,-190.1},{-40.1,-190.1}},
                                           color={0,127,255}));
  connect(bouChiWat3.ports[1], loa3.port_b) annotation (Line(points={{-20,-200},
          {-20,-190},{-10,-190}},
                                color={0,127,255}));
  connect(coo3.port_b, rou3.ports_aSup[1:nChi])
    annotation (Line(points={{-160,-130},{-80,-130}},
                                                    color={0,127,255}));
  connect(resEva3.port_b, coo3.port_a) annotation (Line(points={{-200,-150},{
          -200,-130},{-180,-130}},
                                 color={0,127,255}));
  connect(TChiWat.y, coo3.T_in) annotation (Line(points={{-228,260},{-220,260},
          {-220,-100},{-174,-100},{-174,-118}},
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
    annotation (Line(points={{-40.2,-130},{-10,-130}},
                                                     color={0,127,255}));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri3.y1) annotation (Line(points={{-228,
          380},{160,380},{160,-80},{200,-80}},      color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(yPumChiWatPri.y, busPumChiWatPri3.y) annotation (Line(points={{-228,
          420},{180,420},{180,-76},{200,-76},{200,-80}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busPumChiWatPri3, pumChiWatPri3.bus) annotation (Line(
      points={{200,-80},{200,-112},{0,-112},{0,-120}},
      color={255,204,51},
      thickness=0.5));
  connect(TChiWat[1].y, cooEco1.T_in) annotation (Line(points={{-228,260},{-220,
          260},{-220,-210},{-174,-210},{-174,-218}},
                             color={0,0,127}));
  connect(cooEco1.port_b, rou3.ports_aSup[nChi + 1]) annotation (Line(points={{-160,
          -230},{-120,-230},{-120,-130},{-80,-130}}, color={0,127,255}));
  connect(mChiWatEco_flow1.port_b, TChiWatEcoEnt1.port_a)
    annotation (Line(points={{-150,-290},{-170,-290}}, color={0,127,255}));
  connect(TChiWatEcoEnt1.port_b, resEco1.port_a) annotation (Line(points={{-190,
          -290},{-200,-290},{-200,-270}}, color={0,127,255}));
  connect(resEco1.port_b, cooEco1.port_a) annotation (Line(points={{-200,-250},
          {-200,-230},{-180,-230}},color={0,127,255}));
  connect(busPla2, rou3.bus) annotation (Line(
      points={{240,-100},{-60,-100}},
      color={255,204,51},
      thickness=0.5));
  connect(mChiWatEco_flow1.port_a, pumEco.port_b) annotation (Line(points={{-130,
          -290},{-100,-290},{-100,-260}}, color={0,127,255}));
  connect(pumEco.port_a, rou3.ports_bRet[nChi + 1]) annotation (Line(points={{-100,
          -240},{-100,-190},{-80,-190}}, color={0,127,255}));
  connect(busPumChiWatEco, pumEco.bus) annotation (Line(
      points={{200,-140},{200,-250},{-90,-250}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatPri.y, busPumChiWatEco.y) annotation (Line(points={{-228,
          420},{180,420},{180,-126},{200,-126},{200,-140}},
                                                       color={0,0,127}));
  connect(y1PumChiWatPri[1].y[1], busPumChiWatEco.y1) annotation (Line(points={{-228,
          380},{160,380},{160,-140},{200,-140}},      color={255,0,255}));
  connect(y1ValChiByp.y[1],busValChiBypSer2. y1) annotation (Line(points={{-228,
          340},{170,340},{170,-60},{240,-60},{240,-80}},
                                                      color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busPla2.valChiBypSer, busValChiBypSer2) annotation (Line(
      points={{240,-100},{240,-80}},
      color={255,204,51},
      thickness=0.5));
  connect(mChiWatPri_flow3.port_b, del.ports[1]) annotation (Line(points={{110,
          -130},{120,-130},{120,-190},{59,-190}}, color={0,127,255}));
  connect(del.ports[2], loa3.port_a)
    annotation (Line(points={{61,-190},{10,-190}}, color={0,127,255}));
  connect(y1ValChiWatEcoByp.y[1],busValChiWatEcoByp. y) annotation (Line(points={{-228,
          300},{150,300},{150,70},{200,70}},       color={0,0,127}));
  connect(cooEco.port_b, valChiWatEcoByp1.port_b) annotation (Line(points={{-160,
          -20},{-120,-20},{-120,-40}}, color={0,127,255}));
  connect(mChiWatEco_flow.port_a, valChiWatEcoByp1.port_a) annotation (Line(
        points={{-130,-80},{-120,-80},{-120,-60}},    color={0,127,255}));
  connect(busValChiWatEcoByp, valChiWatEcoByp1.bus) annotation (Line(
      points={{200,70},{200,-50},{-110,-50}},
      color={255,204,51},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(extent={{-260,-640},{260,440}})),
  experiment(
      StopTime=2000,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Templates/ChilledWaterPlants/Components/Validation/ChillersToPrimaryPumps.mos"
    "Simulate and plot"));
end ChillersToPrimaryPumpsSeries;
