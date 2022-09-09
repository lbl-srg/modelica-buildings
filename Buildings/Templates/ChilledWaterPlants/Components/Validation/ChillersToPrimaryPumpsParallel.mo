within Buildings.Templates.ChilledWaterPlants.Components.Validation;
model ChillersToPrimaryPumpsParallel
  "Validation model for hydronic interface between parallel chillers and primary pumps"
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

  Routing.ChillersToPrimaryPumps rou(
    redeclare final package Medium=Medium,
    final nChi=nChi,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final typArrChi=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel,
    final typArrPumChiWatPri=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated,
    final typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None)
    "Parallel chillers, dedicated pumps, no WSE"
    annotation (Placement(transformation(extent={{-80,80},{-40,200}})));
  Fluid.FixedResistances.PressureDrop resEva[nChi](
    redeclare each final package Medium = Medium,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,140})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium = Medium,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{16,160},{36,180}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri(
    redeclare final package Medium=Medium,
    final dat=datPumChiWatChi,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-10,160},{10,180}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,200},{220,240}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt[nChi](
    redeclare each final package Medium = Medium,
    final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,100},{-190,120}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow[nChi](
    redeclare each final package Medium=Medium) "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,100},{-150,120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatPri[nChi](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000) "Primary CHW pumps Start/Stop signal"
    annotation (Placement(transformation(extent={{-250,310},{-230,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yPumChiWatPri(
    k=1) "Primary CHW pumps speed signal"
    annotation (Placement(transformation(extent={{-250,350},{-230,370}})));
  Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare final package Medium = Medium,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(Q_flow_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{10,100},{-10,120}})));
  Modelica.Blocks.Sources.RealExpression sigModLoa(
    y=sum(pumChiWatPri.sigCon.y)/nChi)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-10,114},{10,134}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup(
    redeclare final package Medium =Medium,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,170})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow(
    redeclare final package Medium = Medium)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,160},{110,180}})));
  Fluid.Sources.Boundary_pT bouChiWat(
    redeclare final package Medium=Medium,
    final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,90})));
  Fluid.Sources.PropertySource_T coo[nChi](
    redeclare each final package Medium=Medium,
    each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,160},{-160,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWat[nChi](
    each final k=TChiWatSup_nominal)
    "CHW supply temperature set point"
    annotation (Placement(transformation(extent={{-250,180},{-230,200}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiByp(
    table=[0,0; 1,0; 1,1; 2,1],
    timeScale=1000,
    period=2000)
    "CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-250,270},{-230,290}})));

  Routing.ChillersToPrimaryPumps rou1(
    redeclare final package Medium = Medium,
    final nChi=nChi,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final typArrChi=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel,
    final typArrPumChiWatPri=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered,
    final typEco=Buildings.Templates.ChilledWaterPlants.Types.Economizer.EconomizerWithValve)
    "Parallel chillers, headered pumps, WSE with CHW bypass valve"
    annotation (Placement(transformation(extent={{-80,-60},{-40,60}})));

  Fluid.FixedResistances.PressureDrop resEva1
                                            [nChi](
    redeclare each final package Medium = Medium,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dp_nominal=dpChiWatChi_nominal)
    "Flow resistance for chiller evaporator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,0})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri1(
    redeclare final package Medium = Medium,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{16,20},{36,40}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri1(
    redeclare final package Medium = Medium,
    final dat=datPumChiWatChi,
    final nPum=nChi,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatChiEnt1
                                                [nChi](redeclare each final
      package Medium = Medium, final m_flow_nominal=mChiWatChi_flow_nominal)
    "Chiller entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-40},{-190,-20}})));
  Fluid.Sensors.MassFlowRate mChiWatChi_flow1
                                            [nChi](redeclare each final package
      Medium = Medium)                          "Chiller CHW flow"
    annotation (Placement(transformation(extent={{-130,-40},{-150,-20}})));
  Fluid.HeatExchangers.HeaterCooler_u loa1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(Q_flow_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation (Placement(transformation(extent={{10,-40},{-10,-20}})));
  Modelica.Blocks.Sources.RealExpression sigModLoa1(y=sum(pumChiWatPri.sigCon.y)
        /nChi)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-10,-26},{10,-6}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup1(redeclare final package
      Medium = Medium, final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,30})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow1(redeclare final package Medium =
        Medium)
    "Primary CHW flow"
    annotation (Placement(transformation(extent={{90,20},{110,40}})));
  Fluid.Sources.Boundary_pT bouChiWat1(redeclare final package Medium = Medium,
      final nPorts=1)
    "CHW pressure boundary condition"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,-50})));
  Fluid.Sources.PropertySource_T coo1
                                    [nChi](redeclare each final package Medium
      = Medium, each final use_T_in=true)
    "Ideal cooling to input set point (representing chiller evaporator)"
    annotation (Placement(transformation(extent={{-180,20},{-160,40}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri1
    "Primary CHW pumps control bus"
    annotation (Placement(transformation(extent={{180,60},{220,100}}),
        iconTransformation(extent={{-316,184},{-276,224}})));
  Fluid.FixedResistances.PressureDrop resEco(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChiWatEco_flow_nominal,
    final dp_nominal=dpChiWatEco_nominal)
    "Flow resistance for WSE HX"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,-100})));
  Fluid.Sensors.TemperatureTwoPort TChiWatEcoEnt(redeclare final package Medium
      = Medium, final m_flow_nominal=mChiWatEco_flow_nominal)
    "WSE entering CHW return temperature"
    annotation (Placement(transformation(extent={{-170,-140},{-190,-120}})));
  Fluid.Sensors.MassFlowRate mChiWatEco_flow(redeclare final package Medium =
        Medium)
    "WSE CHW flow"
    annotation (Placement(transformation(extent={{-130,-140},{-150,-120}})));
  Fluid.Sources.PropertySource_T cooEco(redeclare final package Medium = Medium,
      final use_T_in=true)
    "Ideal cooling to input set point (representing WSE)"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatEcoByp(
    redeclare final package Medium = Medium,
    final dat=datValChiWatEcoByp)
    "WSE CHW bypass valve" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-120,-100})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatEcoByp
    "WSE CHW bypass valve control bus" annotation (Placement(transformation(
          extent={{180,10},{220,50}}), iconTransformation(extent={{-316,184},{-276,
            224}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable y1ValChiWatEcoByp(
    table=[0,0; 1,0; 1,1; 2,1],
    timeScale=1000)
    "WSE CHW bypass valve opening signal"
    annotation (Placement(transformation(extent={{-250,230},{-230,250}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiBypPar
    "CHW bypass valves control bus" annotation (Placement(transformation(extent=
           {{220,60},{260,100}}), iconTransformation(extent={{-316,184},{-276,224}})));
  Interfaces.Bus busPla "Plant control bus" annotation (Placement(
        transformation(extent={{220,40},{260,80}}), iconTransformation(extent={{
            -432,12},{-412,32}})));
equation
  connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation (Line(points={{10,170},{16,170}},  color={0,127,255}));
  connect(mChiWatChi_flow.port_a, rou.ports_bRet[1:nChi])
    annotation (Line(points={{-130,110},{-80,110}},color={0,127,255}));
  connect(mChiWatChi_flow.port_b, TChiWatChiEnt.port_a)
    annotation (Line(points={{-150,110},{-170,110}},
                                                   color={0,127,255}));
  connect(TChiWatChiEnt.port_b, resEva.port_a) annotation (Line(points={{-190,110},
          {-200,110},{-200,130}},
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
      points={{200,220},{200,200},{0,200},{0,180}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigModLoa.y, loa.u)
    annotation (Line(points={{11,124},{20,124},{20,116},{12,116}},
                                                               color={0,0,127}));
  connect(outPumChiWatPri.port_b, TChiWatPriSup.port_a)
    annotation (Line(points={{36,170},{50,170}}, color={0,127,255}));
  connect(TChiWatPriSup.port_b, mChiWatPri_flow.port_a)
    annotation (Line(points={{70,170},{90,170}}, color={0,127,255}));
  connect(loa.port_a, mChiWatPri_flow.port_b) annotation (Line(points={{10,110},
          {120,110},{120,170},{110,170}},
                                        color={0,127,255}));
  connect(loa.port_b, rou.port_aRet) annotation (Line(points={{-10,110},{-36,110},
          {-36,109.9},{-40.1,109.9}},
                                    color={0,127,255}));
  connect(bouChiWat.ports[1], loa.port_b)
    annotation (Line(points={{-20,100},{-20,110},{-10,110}},
                                                     color={0,127,255}));
  connect(coo.port_b, rou.ports_aSup[1:nChi])
    annotation (Line(points={{-160,170},{-80,170}},color={0,127,255}));
  connect(resEva.port_b, coo.port_a) annotation (Line(points={{-200,150},{-200,170},
          {-180,170}}, color={0,127,255}));
  connect(TChiWat.y, coo.T_in) annotation (Line(points={{-228,190},{-174,190},{-174,
          182}}, color={0,0,127}));
  connect(rou.ports_bSup, pumChiWatPri.ports_a)
    annotation (Line(points={{-40.2,170},{-10,170}}, color={0,127,255}));
  connect(pumChiWatPri1.ports_b, outPumChiWatPri1.ports_a)
    annotation (Line(points={{10,30},{16,30}}, color={0,127,255}));
  connect(mChiWatChi_flow1.port_a, rou1.ports_bRet[1:nChi])
    annotation (Line(points={{-130,-30},{-80,-30}}, color={0,127,255}));
  connect(mChiWatChi_flow1.port_b, TChiWatChiEnt1.port_a)
    annotation (Line(points={{-150,-30},{-170,-30}}, color={0,127,255}));
  connect(TChiWatChiEnt1.port_b, resEva1.port_a) annotation (Line(points={{-190,
          -30},{-200,-30},{-200,-10}}, color={0,127,255}));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri1.y1) annotation (Line(points={{-228,
          320},{160,320},{160,80},{200,80}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busPumChiWatPri1, pumChiWatPri1.bus) annotation (Line(
      points={{200,80},{200,50},{0,50},{0,40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigModLoa1.y, loa1.u) annotation (Line(points={{11,-16},{20,-16},{20,-24},
          {12,-24}}, color={0,0,127}));
  connect(outPumChiWatPri1.port_b, TChiWatPriSup1.port_a)
    annotation (Line(points={{36,30},{50,30}}, color={0,127,255}));
  connect(TChiWatPriSup1.port_b, mChiWatPri_flow1.port_a)
    annotation (Line(points={{70,30},{90,30}}, color={0,127,255}));
  connect(loa1.port_a, mChiWatPri_flow1.port_b) annotation (Line(points={{10,-30},
          {120,-30},{120,30},{110,30}}, color={0,127,255}));
  connect(loa1.port_b, rou1.port_aRet) annotation (Line(points={{-10,-30},{-36,-30},
          {-36,-30.1},{-40.1,-30.1}}, color={0,127,255}));
  connect(bouChiWat1.ports[1], loa1.port_b) annotation (Line(points={{-20,-40},{
          -20,-30},{-10,-30}}, color={0,127,255}));
  connect(coo1.port_b, rou1.ports_aSup[1:nChi])
    annotation (Line(points={{-160,30},{-80,30}}, color={0,127,255}));
  connect(resEva1.port_b, coo1.port_a) annotation (Line(points={{-200,10},{-200,
          30},{-180,30}}, color={0,127,255}));
  connect(TChiWat.y, coo1.T_in) annotation (Line(points={{-228,190},{-220,190},{
          -220,50},{-174,50},{-174,42}}, color={0,0,127}));
  connect(rou1.ports_bSup, pumChiWatPri1.ports_a)
    annotation (Line(points={{-40.2,30},{-10,30}}, color={0,127,255}));
  connect(mChiWatEco_flow.port_b,TChiWatEcoEnt. port_a)
    annotation (Line(points={{-150,-130},{-170,-130}}, color={0,127,255}));
  connect(TChiWatEcoEnt.port_b,resEco. port_a) annotation (Line(points={{-190,-130},
          {-200,-130},{-200,-110}}, color={0,127,255}));
  connect(resEco.port_b,cooEco. port_a) annotation (Line(points={{-200,-90},{-200,
          -70},{-180,-70}},   color={0,127,255}));
  connect(TChiWat[1].y, cooEco.T_in) annotation (Line(points={{-228,190},{-220,190},
          {-220,-50},{-174,-50},{-174,-58}}, color={0,0,127}));
  connect(cooEco.port_b, rou1.ports_aSup[nChi + 1]) annotation (Line(points={{-160,
          -70},{-120,-70},{-120,30},{-80,30}}, color={0,127,255}));
  connect(busValChiWatEcoByp, valChiWatEcoByp.bus) annotation (Line(
      points={{200,30},{200,-100},{-110,-100}},
      color={255,204,51},
      thickness=0.5));
  connect(y1ValChiWatEcoByp.y[1], busValChiWatEcoByp.y) annotation (Line(points=
         {{-228,240},{150,240},{150,30},{200,30}}, color={0,0,127}));
  connect(busPla, rou1.bus) annotation (Line(
      points={{240,60},{-60,60}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatPri.y, busPumChiWatPri1.y) annotation (Line(points={{-228,360},
          {180,360},{180,84},{190,84},{190,80},{200,80}}, color={0,0,127}));
  connect(busValChiBypPar, busPla.valChiBypPar) annotation (Line(
      points={{240,80},{240,60}},
      color={255,204,51},
      thickness=0.5));
  connect(y1ValChiByp.y[1], busValChiBypPar.y1) annotation (Line(points={{-228,280},
          {170,280},{170,100},{240,100},{240,80}}, color={255,0,255}));
  connect(rou1.ports_bRet[nChi + 1], mChiWatEco_flow.port_a) annotation (Line(
        points={{-80,-30},{-100,-30},{-100,-130},{-130,-130}}, color={0,127,255}));
  connect(mChiWatEco_flow.port_a, valChiWatEcoByp.port_a) annotation (Line(
        points={{-130,-130},{-120,-130},{-120,-110}}, color={0,127,255}));
  connect(valChiWatEcoByp.port_b, cooEco.port_b) annotation (Line(points={{-120,
          -90},{-120,-70},{-160,-70}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-260,-640},{260,440}})),
  experiment(
    StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Templates/ChilledWaterPlants/Components/Validation/ChillersToPrimaryPumps.mos"
    "Simulate and plot"));
end ChillersToPrimaryPumpsParallel;
