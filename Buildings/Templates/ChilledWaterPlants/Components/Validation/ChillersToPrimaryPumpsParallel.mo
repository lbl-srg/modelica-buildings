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
    "CHW supply temperature";

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWatChi(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nChi,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    dp_nominal=1.5*dpChiWatChi_nominal);
  parameter Buildings.Templates.Components.Data.PumpSingle datPumChiWatEco(
    final typ=Buildings.Templates.Components.Types.Pump.Single,
    final m_flow_nominal=mChiWatEco_flow_nominal,
    dp_nominal=1.5*dpChiWatEco_nominal);
  parameter Buildings.Templates.Components.Data.Valve datValChiWatEcoByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    final m_flow_nominal=mChiWatEco_flow_nominal,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso);

  Routing.ChillersToPrimaryPumps rou(
    redeclare final package Medium=MediumChiWat,
    final nChi=nChi,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final typArrChi=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel,
    final typArrPumChiWatPri=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated,
    final typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None)
    "Parallel chillers, dedicated pumps, no WSE"
    annotation (Placement(transformation(extent={{-80,90},{-40,210}})));
  Fluid.FixedResistances.PressureDrop resEva[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,150})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{16,170},{36,190}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final dat=datPumChiWatChi,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,200},{220,240}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,110},{-190,130}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow[nChi](
    redeclare each final package Medium=MediumChiWat) "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,110},{-150,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatPri[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Primary CHW pumps Start/Stop signal"
    annotation (Placement(transformation(extent={{-250,310},{-230,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatPri(
    k=1) "Primary CHW pumps speed signal"
    annotation (Placement(transformation(extent={{-250,350},{-230,370}})));
  Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{10,110},{-10,130}})));
  Modelica.Blocks.Sources.RealExpression sigModLoa(
    y=sum(pumChiWatPri.sigCon.y)/nChi)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-10,124},{10,144}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,180})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow(
    redeclare final package Medium=MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,170},{110,190}})));
  Fluid.Sources.Boundary_pT bouChiWat(
    redeclare final package Medium=MediumChiWat,
    final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,100})));
  Fluid.Sources.PropertySource_T coo[nChi](
    redeclare each final package Medium=MediumChiWat,
    each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,170},{-160,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWat[nChi](
    each final k=TChiWatSup_nominal)
    "CHW supply temperature set point"
    annotation (Placement(transformation(extent={{-250,190},{-230,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatChiByp(
    table=[0,0; 1.8,0; 1.8,1; 2,1],
    timeScale=1000,
    period=2000) "CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-250,270},{-230,290}})));

  Routing.ChillersToPrimaryPumps rou1(
    redeclare final package Medium=MediumChiWat,
    final nChi=nChi,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final typArrChi=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel,
    final typArrPumChiWatPri=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered,
    final typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve)
    "Parallel chillers, headered pumps, WSE with CHW bypass valve"
    annotation (Placement(transformation(extent={{-80,-50},{-40,70}})));

  Fluid.FixedResistances.PressureDrop resEva1[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,10})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri1(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{16,30},{36,50}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri1(
    redeclare final package Medium=MediumChiWat,
    final dat=datPumChiWatChi,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt1[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-30},{-190,-10}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow1[nChi](
    redeclare each final package Medium=MediumChiWat)
    "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,-30},{-150,-10}})));
  Fluid.HeatExchangers.HeaterCooler_u loa1(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{10,-30},{-10,-10}})));
  Modelica.Blocks.Sources.RealExpression sigModLoa1(
    y=sum(pumChiWatPri.sigCon.y)/nChi)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-10,-16},{10,4}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup1(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,40})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow1(
    redeclare final package Medium=MediumChiWat)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Fluid.Sources.Boundary_pT bouChiWat1(
    redeclare final package Medium=MediumChiWat,
    final nPorts=1) "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,-40})));
  Fluid.Sources.PropertySource_T coo1[nChi](
    redeclare each final package Medium=MediumChiWat,
    each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri1
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,60},{220,100}}),
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
    redeclare final package Medium=MediumChiWat,
    final use_T_in=true)
    "Ideal cooling to input set point (representing WSE)"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}})));
  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatEcoByp(
    redeclare final package Medium=MediumChiWat,
    final dat=datValChiWatEcoByp)
    "WSE CHW bypass valve" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-120,-90})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatEcoByp
    "WSE CHW bypass valve control bus"
    annotation (Placement(transformation(
          extent={{180,20},{220,60}}), iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable yValChiWatEcoByp(table=[0,
        1; 1.5,1; 1.5,0; 2,0], timeScale=1000)
    "WSE CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-250,230},{-230,250}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiByp
    "CHW bypass valves control bus"
    annotation (Placement(transformation(extent=
           {{220,80},{260,120}}), iconTransformation(extent={{-316,184},{-276,
            224}})));
  Interfaces.Bus busPla "Plant control bus"
  annotation (Placement(
        transformation(extent={{220,60},{260,100}}),iconTransformation(extent={{
            -432,12},{-412,32}})));
equation
  connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation (Line(points={{10,180},{16,180}},  color={0,127,255}));
  connect(mChiWatChi_flow.port_a, rou.ports_bRet[1:nChi])
    annotation (Line(points={{-130,120},{-80,120}},color={0,127,255}));
  connect(mChiWatChi_flow.port_b, TChiWatChiEnt.port_a)
    annotation (Line(points={{-150,120},{-170,120}},
                                                   color={0,127,255}));
  connect(TChiWatChiEnt.port_b, resEva.port_a) annotation (Line(points={{-190,
          120},{-200,120},{-200,140}},
                                color={0,127,255}));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri.y1) annotation (Line(points={{-228,
          320},{160,320},{160,220},{200,220}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(yPumChiWatPri.y, busPumChiWatPri.y) annotation (Line(points={{-228,360},
          {180,360},{180,240},{200,240},{200,220}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busPumChiWatPri, pumChiWatPri.bus) annotation (Line(
      points={{200,220},{200,210},{0,210},{0,190}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigModLoa.y, loa.u)
    annotation (Line(points={{11,134},{20,134},{20,126},{12,126}},
                                                               color={0,0,127}));
  connect(outPumChiWatPri.port_b, TChiWatPriSup.port_a)
    annotation (Line(points={{36,180},{50,180}}, color={0,127,255}));
  connect(TChiWatPriSup.port_b, mChiWatPri_flow.port_a)
    annotation (Line(points={{70,180},{90,180}}, color={0,127,255}));
  connect(loa.port_a, mChiWatPri_flow.port_b) annotation (Line(points={{10,120},
          {120,120},{120,180},{110,180}},
                                        color={0,127,255}));
  connect(loa.port_b, rou.port_aRet) annotation (Line(points={{-10,120},{-36,
          120},{-36,119.9},{-40.1,119.9}},
                                    color={0,127,255}));
  connect(bouChiWat.ports[1], loa.port_b)
    annotation (Line(points={{-20,110},{-20,120},{-10,120}},
                                                     color={0,127,255}));
  connect(coo.port_b, rou.ports_aSup[1:nChi])
    annotation (Line(points={{-160,180},{-80,180}},color={0,127,255}));
  connect(resEva.port_b, coo.port_a) annotation (Line(points={{-200,160},{-200,
          180},{-180,180}},
                       color={0,127,255}));
  connect(TChiWat.y, coo.T_in) annotation (Line(points={{-228,200},{-174,200},{
          -174,192}},
                 color={0,0,127}));
  connect(rou.ports_bSup, pumChiWatPri.ports_a)
    annotation (Line(points={{-40.2,180},{-10,180}}, color={0,127,255}));
  connect(pumChiWatPri1.ports_b, outPumChiWatPri1.ports_a)
    annotation (Line(points={{10,40},{16,40}}, color={0,127,255}));
  connect(mChiWatChi_flow1.port_a, rou1.ports_bRet[1:nChi])
    annotation (Line(points={{-130,-20},{-80,-20}}, color={0,127,255}));
  connect(mChiWatChi_flow1.port_b, TChiWatChiEnt1.port_a)
    annotation (Line(points={{-150,-20},{-170,-20}}, color={0,127,255}));
  connect(TChiWatChiEnt1.port_b, resEva1.port_a) annotation (Line(points={{-190,
          -20},{-200,-20},{-200,0}},   color={0,127,255}));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri1.y1) annotation (Line(points={{-228,
          320},{160,320},{160,80},{200,80}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busPumChiWatPri1, pumChiWatPri1.bus) annotation (Line(
      points={{200,80},{200,60},{0,60},{0,50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigModLoa1.y, loa1.u) annotation (Line(points={{11,-6},{20,-6},{20,
          -14},{12,-14}},
                     color={0,0,127}));
  connect(outPumChiWatPri1.port_b, TChiWatPriSup1.port_a)
    annotation (Line(points={{36,40},{50,40}}, color={0,127,255}));
  connect(TChiWatPriSup1.port_b, mChiWatPri_flow1.port_a)
    annotation (Line(points={{70,40},{90,40}}, color={0,127,255}));
  connect(loa1.port_a, mChiWatPri_flow1.port_b) annotation (Line(points={{10,-20},
          {120,-20},{120,40},{110,40}}, color={0,127,255}));
  connect(loa1.port_b, rou1.port_aRet) annotation (Line(points={{-10,-20},{-36,
          -20},{-36,-20.1},{-40.1,-20.1}},
                                      color={0,127,255}));
  connect(bouChiWat1.ports[1], loa1.port_b) annotation (Line(points={{-20,-30},
          {-20,-20},{-10,-20}},color={0,127,255}));
  connect(coo1.port_b, rou1.ports_aSup[1:nChi])
    annotation (Line(points={{-160,40},{-80,40}}, color={0,127,255}));
  connect(resEva1.port_b, coo1.port_a) annotation (Line(points={{-200,20},{-200,
          40},{-180,40}}, color={0,127,255}));
  connect(TChiWat.y, coo1.T_in) annotation (Line(points={{-228,200},{-220,200},
          {-220,60},{-174,60},{-174,52}},color={0,0,127}));
  connect(rou1.ports_bSup, pumChiWatPri1.ports_a)
    annotation (Line(points={{-40.2,40},{-10,40}}, color={0,127,255}));
  connect(mChiWatEco_flow.port_b,TChiWatEcoEnt. port_a)
    annotation (Line(points={{-150,-120},{-170,-120}}, color={0,127,255}));
  connect(TChiWatEcoEnt.port_b,resEco. port_a) annotation (Line(points={{-190,
          -120},{-200,-120},{-200,-100}},
                                    color={0,127,255}));
  connect(resEco.port_b,cooEco. port_a) annotation (Line(points={{-200,-80},{
          -200,-60},{-180,-60}},
                              color={0,127,255}));
  connect(TChiWat[1].y, cooEco.T_in) annotation (Line(points={{-228,200},{-220,
          200},{-220,-50},{-174,-50},{-174,-48}},
                                             color={0,0,127}));
  connect(cooEco.port_b, rou1.ports_aSup[nChi + 1]) annotation (Line(points={{-160,
          -60},{-120,-60},{-120,40},{-80,40}}, color={0,127,255}));
  connect(busValChiWatEcoByp, valChiWatEcoByp.bus) annotation (Line(
      points={{200,40},{200,-90},{-110,-90}},
      color={255,204,51},
      thickness=0.5));
  connect(yValChiWatEcoByp.y[1], busValChiWatEcoByp.y) annotation (Line(points=
          {{-228,240},{150,240},{150,40},{200,40}}, color={0,0,127}));
  connect(busPla, rou1.bus) annotation (Line(
      points={{240,80},{240,70},{-60,70}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatPri.y, busPumChiWatPri1.y) annotation (Line(points={{-228,360},
          {180,360},{180,84},{190,84},{190,80},{200,80}}, color={0,0,127}));
  connect(y1ValChiWatChiByp.y[1], busValChiWatChiByp.y1) annotation (Line(
        points={{-228,280},{170,280},{170,100},{240,100}}, color={255,0,255}));
  connect(rou1.ports_bRet[nChi + 1], mChiWatEco_flow.port_a) annotation (Line(
        points={{-80,-20},{-100,-20},{-100,-120},{-130,-120}}, color={0,127,255}));
  connect(mChiWatEco_flow.port_a, valChiWatEcoByp.port_a) annotation (Line(
        points={{-130,-120},{-120,-120},{-120,-100}}, color={0,127,255}));
  connect(valChiWatEcoByp.port_b, cooEco.port_b) annotation (Line(points={{-120,
          -80},{-120,-60},{-160,-60}}, color={0,127,255}));
  connect(busValChiWatChiByp, busPla.valChiWatChiByp) annotation (Line(
      points={{240,100},{240,80}},
      color={255,204,51},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(extent={{-260,-640},{260,440}})),
  experiment(
    StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Templates/ChilledWaterPlants/Components/Validation/ChillersToPrimaryPumpsParallel.mos"
    "Simulate and plot"));
end ChillersToPrimaryPumpsParallel;
