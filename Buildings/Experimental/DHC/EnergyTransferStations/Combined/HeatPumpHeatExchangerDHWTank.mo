within Buildings.Experimental.DHC.EnergyTransferStations.Combined;
model HeatPumpHeatExchangerDHWTank
  "Model of a substation with heat pump and compressor-less cooling with domestic hot water served by a heat pump with storage tank"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialETS(
    final typ=Buildings.Experimental.DHC.Types.DistrictSystemType.CombinedGeneration5,
    final have_weaBus=false,
    final have_chiWat=true,
    final have_heaWat=true,
    final have_hotWat=true,
    final have_eleHea=true,
    final nFue=0,
    final have_eleCoo=false,
    final have_pum=true,
    final have_fan=false,
    nPorts_aHeaWat=1,
    nPorts_aChiWat=1);
  // SYSTEM GENERAL
  parameter Boolean have_varFloCon = true
    "Set to true for heat pumps with variable condenser flow"
    annotation(Evaluate=true);
  parameter Boolean have_varFloEva = true
    "Set to true for heat pumps with variable evaporator flow"
    annotation(Evaluate=true);
  parameter Real ratFloMin(
    final unit="1",
    final min=0,
    final max=1)=0.3
    "Minimum condenser or evaporator mass flow rate (ratio to nominal)"
    annotation (Dialog(enable=have_varFloCon or have_varFloEva));
  parameter Modelica.Units.SI.Temperature TDisWatMin
    "District water minimum temperature" annotation (Dialog(group="DHC system"));
  parameter Modelica.Units.SI.Temperature TDisWatMax
    "District water maximum temperature" annotation (Dialog(group="DHC system"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(min=0) = 5
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=291.15
    "Chilled water supply temperature"
    annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.Units.SI.Temperature TChiWatRet_nominal=
      TChiWatSup_nominal + dT_nominal "Chilled water return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=313.15
    "Heating water supply temperature"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.Temperature THeaWatRet_nominal=
      THeaWatSup_nominal - dT_nominal "Heating water return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THotWatSup_nominal=datWatHea.TTan_nominal
    "Hot water supply temperature"
    annotation (Dialog(group="Nominal condition", enable=have_hotWat));
  parameter Modelica.Units.SI.Temperature TColWat_nominal=288.15
    "Cold water temperature (for hot water production)"
    annotation (Dialog(group="Nominal condition", enable=have_hotWat));
  parameter Modelica.Units.SI.Pressure dp_nominal(displayUnit="Pa") = 50000
    "Pressure difference at nominal flow rate (for each flow leg)"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal(min=0)=
    abs(QHeaWat_flow_nominal/cpBui_default/(THeaWatSup_nominal -
    THeaWatRet_nominal)) "Heating water mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(min=0)=
    abs(QChiWat_flow_nominal/cpBui_default/(TChiWatSup_nominal -
    TChiWatRet_nominal)) "Chilled water mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.Units.SI.MassFlowRate mEvaHotWat_flow_nominal(min=0)=proHotWat.heaPumTan.mDH_flow_nominal
    "Evaporator water mass flow rate of heat pump for hot water production"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mSerWat_flow_nominal(min=0)=
    max(proHeaWat.m2_flow_nominal + mEvaHotWat_flow_nominal, hexChi.m1_flow_nominal)
    "Service water mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  constant Modelica.Units.SI.SpecificHeatCapacity cpBui_default=
      MediumBui.specificHeatCapacityCp(MediumBui.setState_pTX(p=MediumBui.p_default,
      T=MediumBui.T_default)) "Specific heat capacity of the fluid";
  constant Modelica.Units.SI.SpecificHeatCapacity cpSer_default=
      MediumBui.specificHeatCapacityCp(MediumSer.setState_pTX(p=MediumSer.p_default,
      T=MediumSer.T_default)) "Specific heat capacity of the fluid";
  // Heat pump for heating water production
  parameter Real COPHeaWat_nominal(final unit="1")
    "COP of heat pump for heating water production"
    annotation (Dialog(group="Nominal condition"));
  // Heat pump for hot water production
  parameter Real COPHotWat_nominal(final unit="1")
    "COP of heat pump for hot water production"
    annotation (Dialog(group="Nominal condition", enable=have_hotWat));
  // District HX
  final parameter Modelica.Units.SI.MassFlowRate m1HexChi_flow_nominal(min=0)=
       abs(QChiWat_flow_nominal/cpSer_default/dT_nominal)
    "CHW HX primary mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate m2HexChi_flow_nominal(min=0)=
       abs(QChiWat_flow_nominal/cpSer_default/(THeaWatSup_nominal -
    THeaWatRet_nominal)) "CHW HX secondary mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics mixingVolumeEnergyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Formulation of energy balance for mixing volume at inlet and outlet"
     annotation(Dialog(tab="Dynamics"));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-340,
            100},{-300,140}}), iconTransformation(extent={{-380,20},{-300,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating enable signal"
    annotation (Placement(transformation(extent={{-340,
            140},{-300,180}}), iconTransformation(extent={{-380,60},{-300,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSHW if have_hotWat
    "SHW production enable signal"
    annotation (Placement(transformation(extent=
            {{-340,60},{-300,100}}), iconTransformation(extent={{-380,-20},{-300,
            60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Heating water supply temperature set point"
    annotation (Placement(
        transformation(
        extent={{-340,20},{-300,60}}),
        iconTransformation(
        extent={{-380,-60},{-300,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSupSet(
    final unit="K",
    displayUnit="degC") if have_hotWat
    "Service hot water supply temperature set point"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,-40}),
        iconTransformation(
        extent={{-380,-140},{-300,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TColWat(
    final unit="K",
    displayUnit="degC") if have_hotWat
    "Cold water temperature" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,-80}), iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=0,
        origin={-340,-140})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput loaSHW(
    final unit="W") if have_hotWat "Service hot water load"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,-120}),iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=0,
        origin={-340,-180})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(final unit="K",
      displayUnit="degC")
    "Chilled water supply temperature set point" annotation (Placement(
        transformation(
        extent={{-340,-20},{-300,20}}),
        iconTransformation(
        extent={{-380,-100},{-300,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mHea_flow(final unit="kg/s")
    "District water mass flow rate used for heating service"
    annotation ( Placement(transformation(extent={{300,-160},{340,-120}}),
      iconTransformation(extent={{300,-160},{380,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mCoo_flow(final unit="kg/s")
    "District water mass flow rate used for cooling service"
    annotation ( Placement(transformation(extent={{300,-200},{340,-160}}),
      iconTransformation(extent={{300,-200},{380,-120}})));
  // COMPONENTS
  Buildings.Fluid.Delays.DelayFirstOrder volMix_a(
    redeclare final package Medium = MediumSer,
    final nPorts=if have_hotWat then 4 else 3,
    final m_flow_nominal=mSerWat_flow_nominal,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume to break algebraic loops and to emulate the delay of the substation"
    annotation (Placement(transformation(extent={{-270,-360},{-250,-380}})));
  Buildings.Fluid.Delays.DelayFirstOrder volMix_b(
    redeclare final package Medium = MediumSer,
    final nPorts=if have_hotWat then 4 else 3,
    final m_flow_nominal=mSerWat_flow_nominal,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume to break algebraic loops and to emulate the delay of the substation"
    annotation (Placement(transformation(extent={{250,-360},{270,-380}})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pum1HexChi(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal=m1HexChi_flow_nominal,
    final allowFlowReversal=allowFlowReversalSer)
    "Chilled water HX primary pump"
    annotation (Placement(transformation(extent={{110,-350},{90,-330}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexChi(
    redeclare final package Medium1 = MediumSer,
    redeclare final package Medium2 = MediumBui,
    final m1_flow_nominal=m1HexChi_flow_nominal,
    final m2_flow_nominal=m2HexChi_flow_nominal,
    final dp1_nominal=dp_nominal/2,
    final dp2_nominal=dp_nominal/2,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final Q_flow_nominal=QChiWat_flow_nominal,
    final T_a1_nominal=TDisWatMax,
    final T_a2_nominal=TChiWatRet_nominal,
    final allowFlowReversal1=allowFlowReversalSer,
    final allowFlowReversal2=allowFlowReversalBui)
    "Chilled water HX"
    annotation (Placement(transformation(extent={{10,-324},{-10,-344}})));
  Buildings.Fluid.Delays.DelayFirstOrder volHeaWatRet(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=proHeaWat.m1_flow_nominal,
    tau=60,
    final energyDynamics=mixingVolumeEnergyDynamics,
    T_start=THeaWatSup_nominal,
    nPorts=3) "Mixing volume representing building HHW primary" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={90,180})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloHeaWat(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui)
    "Heating water mass flow rate"
    annotation (Placement(transformation(extent={{-250,250},{-230,270}})));
  Buildings.Fluid.Delays.DelayFirstOrder volChiWat(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=m1HexChi_flow_nominal,
    tau=60,
    final energyDynamics=mixingVolumeEnergyDynamics,
    T_start=TChiWatSup_nominal,
    nPorts=3) "Mixing volume representing building CHW primary"
    annotation (Placement(transformation(extent={{-110,-280},{-90,-260}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloChiWat(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui)
    "Chilled water mass flow rate"
    annotation (Placement(transformation(extent={{-250,-130},{-230,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(final k=
        m1HexChi_flow_nominal)
    annotation (Placement(transformation(extent={{-108,-210},{-88,-190}})));
  Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls.PIDWithEnable conTChiWat(
    k=0.05,
    Ti=120,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseActing=false,
    yMin=0) "PI controller for district HX primary side"
    annotation (Placement(transformation(extent={{-150,-210},{-130,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumHeaTot(final nin=2)
    "Total pump power for heating applications"
    annotation (Placement(transformation(extent={{190,410},{210,430}})));
  Buildings.Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium = MediumBui,
    nPorts=1)
    "Pressure boundary condition representing the expansion vessel"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=-90,
      origin={60,150})));
  Buildings.Fluid.Sources.Boundary_pT bouChiWat(
    redeclare final package Medium = MediumBui,
    nPorts=1)
    "Pressure boundary condition representing the expansion vessel"
    annotation (Placement(transformation(extent={{-162,-290},{-142,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumCooTot(nin=1)
    "Total pump power for space cooling"
    annotation (Placement(transformation(extent={{190,370},{210,390}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumTot(nin=2)
    "Total pump power"
    annotation (Placement(transformation(extent={{220,390},{240,410}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(
    redeclare final package Medium=MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=mHeaWat_flow_nominal)
    "Heating water supply temperature"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={140,260})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTChiWatSup(
    redeclare final package Medium=MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled water supply temperature"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={140,-280})));
  Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.SwitchBox
    swiFlo(
    redeclare final package Medium = MediumSer,
    final m_flow_nominal=mSerWat_flow_nominal) "Flow switch box"
    annotation (Placement(transformation(extent={{-10,-390},{10,-370}})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Junction bypHeaWatSup(redeclare
      final package Medium =
                       MediumBui, final m_flow_nominal=proHeaWat.m1_flow_nominal
        *{1,-1,-1}) "Bypass heating water (supply)" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={100,260})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Junction bypHeaWatRet(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=proHeaWat.m1_flow_nominal*{1,-1,1})
    "Bypass heating water (return)"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={100,240})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold enaHea(
    trueHoldDuration=15*60) "Enable heating"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.HeatPump proHeaWat(
    redeclare final package Medium1 = MediumBui,
    redeclare final package Medium2 = MediumSer,
    final have_varFloCon=have_varFloCon,
    final have_varFloEva=have_varFloEva,
    final COP_nominal=COPHeaWat_nominal,
    final TCon_nominal=THeaWatSup_nominal,
    final TEva_nominal=TDisWatMin-dT_nominal,
    final Q1_flow_nominal=QHeaWat_flow_nominal,
    final allowFlowReversal1=allowFlowReversalBui,
    final allowFlowReversal2=allowFlowReversalSer,
    final dT1_nominal=dT_nominal,
    final dT2_nominal=-dT_nominal,
    final dp1_nominal=dp_nominal,
    final dp2_nominal=dp_nominal) "Subsystem for heating water production"
    annotation (Placement(transformation(extent={{-10,204},{10,224}})));
  Subsystems.HeatPumpDHWTank                                                     proHotWat(
    redeclare final package Medium1 = MediumBui,
    redeclare final package Medium2 = MediumSer,
    final have_varFloEva=have_varFloEva,
    final COP_nominal=COPHotWat_nominal,
    final allowFlowReversal1=allowFlowReversalBui,
    final allowFlowReversal2=allowFlowReversalSer,
    mHw_flow_nominal=QHotWat_flow_nominal/cpBui_default/(THotWatSup_nominal -
        TColWat_nominal),
    datWatHea=datWatHea)
    "Subsystem for hot water production"
    annotation (Placement(transformation(extent={{-10,24},{10,44}})));
  Fluid.Sources.Boundary_pT souDCW(
    redeclare final package Medium = MediumBui,
    use_T_in=true,
    nPorts=1)  if have_hotWat "Source for domestic cold water"
                                 annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-40,-10})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div1 if have_hotWat
    "Compute mass flow rate from load"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(final k=
        cpBui_default) if have_hotWat "Times Cp"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum masFloHeaTot(final nin=2)
    "Compute district water mass flow rate used for heating service"
    annotation (Placement(transformation(extent={{270,-150},{290,-130}})));
  Modelica.Blocks.Sources.Constant zer(final k=0) if not have_hotWat
    "Replacement variable"
    annotation (Placement(transformation(extent={{140,350},{160,370}})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatRet(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=mHeaWat_flow_nominal)
    "Heating water return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={20,300})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatRet(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled water return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-120})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract delT if have_hotWat
    "Compute DeltaT needed on condenser side"
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}})));
  Fluid.Sensors.MassFlowRate senMasFloHeaWatPri(redeclare final package Medium =
        MediumBui, final allowFlowReversal=allowFlowReversalBui)
    "Primary heating water mass flow rate"
    annotation (Placement(transformation(extent={{30,270},{50,250}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold enaSHW(trueHoldDuration=15*
        60) if have_hotWat "Enable SHW production"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Modelica.Blocks.Sources.Constant zer1(k=0) if not have_hotWat
    "Replacement variable"
    annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Add masFloHea
    "Service water mass flow rate for heating applications"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-264})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PHeaTot(final nin=2)
    "Total power used for heating and hot water production"
    annotation (Placement(transformation(extent={{270,70},{290,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add heaFloEvaSHW if have_hotWat and have_varFloEva
    "Heat flow rate at evaporator"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dTHHW
    "Heating hot water DeltaT"
    annotation (Placement(transformation(extent={{0,310},{-20,330}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter capFloHHW(
    final k=cpBui_default) if have_varFloEva or have_varFloCon "Capacity flow rate"
    annotation (Placement(transformation(extent={{-220,310},{-200,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Add heaFloEvaHHW if have_varFloEva
    "Heat flow rate at evaporator"
    annotation (Placement(transformation(extent={{-100,230},{-80,250}})));
  Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls.PrimaryVariableFlow conFloEvaSHW(
    final Q_flow_nominal=-QHotWat_flow_nominal*(1 + 1/COPHotWat_nominal),
    final dT_nominal=-dT_nominal,
    final ratFloMin=ratFloMin,
    final cp=cpSer_default) if have_hotWat and have_varFloEva
    "Mass flow rate control"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls.PrimaryVariableFlow conFloConHHW(
    final Q_flow_nominal=QHeaWat_flow_nominal,
    final dT_nominal=dT_nominal,
    final ratFloMin=ratFloMin,
    final cp=cpBui_default) if have_varFloCon
    "Mass flow rate control"
    annotation (Placement(transformation(extent={{-100,270},{-80,290}})));
  Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls.PrimaryVariableFlow conFloEvaHHW(
    final Q_flow_nominal=-QHeaWat_flow_nominal*(1 + 1/COPHeaWat_nominal),
    final dT_nominal=-dT_nominal,
    final ratFloMin=ratFloMin,
    final cp=cpSer_default) if have_varFloEva
    "Mass flow rate control"
    annotation (Placement(transformation(extent={{-60,230},{-40,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Max priOve if have_varFloCon
    "Ensure primary overflow"
    annotation (Placement(transformation(extent={{-60,270},{-40,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply loaHHW
    if have_varFloEva or have_varFloCon "Heating load"
    annotation (Placement(transformation(extent={{-140,270},{-120,290}})));

  Fluid.Sources.MassFlowSource_T sinDHW(
    redeclare final package Medium = MediumBui,
    use_m_flow_in=true,
    nPorts=1) if have_hotWat "Sink for domestic hot water"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter toSin(final k=-1)
    if have_hotWat "Convert to sink"
    annotation (Placement(transformation(extent={{-98,50},{-78,70}})));
  parameter Loads.Heating.DHW.Data.GenericHeatPumpWaterHeater                            datWatHea
    "Performance data"
    annotation (Placement(transformation(extent={{-6,6},{6,18}})));
equation
  connect(TChiWatSupSet, conTChiWat.u_s) annotation (Line(points={{-320,0},{-200,
          0},{-200,-200},{-152,-200}},  color={0,0,127}));
  connect(pum1HexChi.P, PPumCooTot.u[1]) annotation (Line(points={{89,-331},{84,
          -331},{84,-322},{180,-322},{180,380},{188,380}}, color={0,0,127}));
  connect(PPumHeaTot.y, PPumTot.u[1]) annotation (Line(points={{212,420},{216,
          420},{216,399.5},{218,399.5}},
                                color={0,0,127}));
  connect(PPumCooTot.y, PPumTot.u[2]) annotation (Line(points={{212,380},{216,
          380},{216,400.5},{218,400.5}},
                                color={0,0,127}));
  connect(pum1HexChi.port_b, hexChi.port_a1) annotation (Line(points={{90,-340},
          {10,-340}},                              color={0,127,255}));
  connect(pum1HexChi.m_flow_actual, mCoo_flow) annotation (Line(points={{89,-335},
          {82,-335},{82,-320},{276,-320},{276,-180},{320,-180}}, color={0,0,127}));
  connect(volMix_a.ports[1], swiFlo.port_bSup) annotation (Line(points={{-260,-360},
          {-6,-360},{-6,-370}}, color={0,127,255}));
  connect(swiFlo.port_aRet, volMix_b.ports[1]) annotation (Line(points={{6,-370},
          {6,-360},{260,-360}}, color={0,127,255}));
  connect(volMix_b.ports[2], pum1HexChi.port_a) annotation (Line(points={{260,-360},
          {258,-360},{258,-340},{110,-340}}, color={0,127,255}));
  connect(hexChi.port_b1, volMix_a.ports[2]) annotation (Line(points={{-10,-340},
          {-256,-340},{-256,-360},{-260,-360}}, color={0,127,255}));
  connect(pum1HexChi.m_flow_actual, swiFlo.mRev_flow) annotation (Line(points={
          {89,-335},{80,-335},{80,-356},{-20,-356},{-20,-384},{-12,-384}},
        color={0,0,127}));
  connect(gai2.y, pum1HexChi.m_flow_in)
    annotation (Line(points={{-86,-200},{100,-200},{100,-328}},
                                                          color={0,0,127}));
  connect(PPumTot.y, PPum) annotation (Line(points={{242,400},{244,400},{244,-40},
          {320,-40}}, color={0,0,127}));
  connect(ports_aHeaWat[1], senMasFloHeaWat.port_a) annotation (Line(points={{-300,
          260},{-250,260}},                            color={0,127,255}));
  connect(bypHeaWatSup.port_2, senTHeaWatSup.port_a)
    annotation (Line(points={{110,260},{130,260}}, color={0,127,255}));
  connect(senTHeaWatSup.port_b, ports_bHeaWat[1])
    annotation (Line(points={{150,260},{300,260}}, color={0,127,255}));
  connect(bypHeaWatRet.port_2, volHeaWatRet.ports[1]) annotation (Line(points={{90,240},
          {80,240},{80,178.667}},             color={0,127,255}));
  connect(bouHeaWat.ports[1], volHeaWatRet.ports[2]) annotation (Line(points={{60,160},
          {60,180},{80,180}},                color={0,127,255}));
  connect(ports_aChiWat[1], senMasFloChiWat.port_a) annotation (Line(points={{-300,
          200},{-280,200},{-280,-120},{-250,-120}},    color={0,127,255}));
  connect(senTChiWatSup.port_b, ports_bChiWat[1]) annotation (Line(points={{150,
          -280},{200,-280},{200,200},{300,200}}, color={0,127,255}));
  connect(bypHeaWatRet.port_3, bypHeaWatSup.port_3)
    annotation (Line(points={{100,250},{100,250}}, color={0,127,255}));
  connect(volHeaWatRet.ports[3], proHeaWat.port_a1) annotation (Line(points={{80,
          181.333},{80,180},{-20,180},{-20,208},{-10,208}}, color={0,127,255}));
  connect(proHeaWat.port_b2, volMix_b.ports[3]) annotation (Line(points={{10,
          220},{262,220},{262,-360},{260,-360}}, color={0,127,255}));
  connect(volMix_a.ports[3], proHeaWat.port_a2) annotation (Line(points={{-260,
          -360},{-260,200},{14,200},{14,208},{10,208}}, color={0,127,255}));
  connect(enaHea.y, proHeaWat.uEna) annotation (Line(points={{-118,160},{-48,160},
          {-48,223},{-12,223}}, color={255,0,255}));
  connect(THeaWatSupSet, proHeaWat.TSupSet) annotation (Line(points={{-320,40},{
          -200,40},{-200,217},{-12,217}},
                                        color={0,0,127}));
  connect(proHeaWat.PPum, PPumHeaTot.u[1]) annotation (Line(points={{12,214},{
          172,214},{172,419.5},{188,419.5}},
                                     color={0,0,127}));
  connect(volMix_a.ports[4], proHotWat.port_a2) annotation (Line(points={{-260,
          -360},{-258,-360},{-258,20},{14,20},{14,28},{10,28}}, color={0,127,
          255}));
  connect(proHotWat.port_b2, volMix_b.ports[4])
    annotation (Line(points={{10,40},{260,40},{260,-360}}, color={0,127,255}));
  connect(THotWatSupSet, proHotWat.TSupSet) annotation (Line(points={{-320,-40},
          {-160,-40},{-160,37},{-12,37}}, color={0,0,127}));
  connect(gai.y, div1.u2) annotation (Line(points={{-98,0},{-80,0},{-80,-20},{-120,
          -20},{-120,-46},{-102,-46}},                color={0,0,127}));
  connect(loaSHW, div1.u1) annotation (Line(points={{-320,-120},{-290,-120},{-290,
          -34},{-102,-34}}, color={0,0,127}));
  connect(masFloHeaTot.y, mHea_flow)
    annotation (Line(points={{292,-140},{320,-140}}, color={0,0,127}));
  connect(proHotWat.mEva_flow, masFloHeaTot.u[2]) annotation (Line(points={{12,31},
          {218,31},{218,-139.5},{268,-139.5}},
                                           color={0,0,127}));
  connect(zer.y, masFloHeaTot.u[2]) annotation (Line(points={{161,360},{216,360},
          {216,-144},{268,-144},{268,-139.5}},
                                            color={0,0,127}));
  connect(proHotWat.PPum, PPumHeaTot.u[2]) annotation (Line(points={{12,34},{
          176,34},{176,420},{188,420},{188,420.5}},
                                              color={0,0,127}));
  connect(proHeaWat.mEva_flow, masFloHeaTot.u[1]) annotation (Line(points={{12,211},
          {220,211},{220,-140.5},{268,-140.5}},
                                            color={0,0,127}));
  connect(zer.y, PPumHeaTot.u[2]) annotation (Line(points={{161,360},{174,360},
          {174,418},{188,418},{188,420.5}},
                                         color={0,0,127}));
  connect(senMasFloHeaWat.port_b, senTHeaWatRet.port_a) annotation (Line(points={{-230,
          260},{-220,260},{-220,300},{10,300}},        color={0,127,255}));
  connect(senTHeaWatRet.port_b, bypHeaWatRet.port_1) annotation (Line(points={{30,300},
          {120,300},{120,240},{110,240}},      color={0,127,255}));
  connect(senMasFloChiWat.port_b, senTChiWatRet.port_a)
    annotation (Line(points={{-230,-120},{30,-120}}, color={0,127,255}));
  connect(delT.y, gai.u)
    annotation (Line(points={{-128,0},{-122,0}},     color={0,0,127}));
  connect(TColWat, delT.u2) annotation (Line(points={{-320,-80},{-156,-80},{-156,
          -6},{-152,-6}},   color={0,0,127}));
  connect(THotWatSupSet, delT.u1) annotation (Line(points={{-320,-40},{-160,-40},
          {-160,6},{-152,6}},
                            color={0,0,127}));
  connect(proHeaWat.port_b1, senMasFloHeaWatPri.port_a) annotation (Line(points=
         {{-10,220},{-20,220},{-20,260},{30,260}}, color={0,127,255}));
  connect(senMasFloHeaWatPri.port_b, bypHeaWatSup.port_1)
    annotation (Line(points={{50,260},{90,260}},  color={0,127,255}));
  connect(port_aSerAmb, swiFlo.port_aSup) annotation (Line(points={{-300,-200},{
          -272,-200},{-272,-344},{-280,-344},{-280,-400},{-6,-400},{-6,-390}},
                                                       color={0,127,255}));
  connect(swiFlo.port_bRet, port_bSerAmb) annotation (Line(points={{6,-390},{6,
          -400},{280,-400},{280,-200},{300,-200}},
                                             color={0,127,255}));
  connect(uHea, enaHea.u) annotation (Line(points={{-320,160},{-142,160}},
                       color={255,0,255}));
  connect(conTChiWat.y, gai2.u)
    annotation (Line(points={{-128,-200},{-110,-200}}, color={0,0,127}));
  connect(uCoo, conTChiWat.uEna) annotation (Line(points={{-320,120},{-180,120},
          {-180,-220},{-144,-220},{-144,-212}}, color={255,0,255}));
  connect(uSHW, enaSHW.u)
    annotation (Line(points={{-320,80},{-142,80}}, color={255,0,255}));
  connect(enaSHW.y, proHotWat.uEna) annotation (Line(points={{-118,80},{-114,80},
          {-114,43},{-12,43}},color={255,0,255}));
  connect(senTChiWatRet.port_b, volChiWat.ports[1]) annotation (Line(points={{50,-120},
          {60,-120},{60,-280},{-101.333,-280}},          color={0,127,255}));
  connect(volChiWat.ports[2], hexChi.port_a2) annotation (Line(points={{-100,
          -280},{-120,-280},{-120,-320},{-20,-320},{-20,-328},{-10,-328}},
        color={0,127,255}));
  connect(hexChi.port_b2, senTChiWatSup.port_a) annotation (Line(points={{10,
          -328},{20,-328},{20,-320},{80,-320},{80,-280},{130,-280}}, color={0,
          127,255}));
  connect(bouChiWat.ports[1], volChiWat.ports[3])
    annotation (Line(points={{-142,-280},{-98.6667,-280}}, color={0,127,255}));
  connect(senTChiWatSup.T, conTChiWat.u_m) annotation (Line(points={{140,-269},
          {140,-220},{-140,-220},{-140,-212}}, color={0,0,127}));
  connect(zer1.y, masFloHea.u2) annotation (Line(points={{-19,-240},{-8,-240},{
          -8,-252},{-6,-252}}, color={0,0,127}));
  connect(proHotWat.mEva_flow, masFloHea.u2) annotation (Line(points={{12,31},{18,
          31},{18,-240},{-6,-240},{-6,-252}}, color={0,0,127}));
  connect(proHeaWat.mEva_flow, masFloHea.u1) annotation (Line(points={{12,211},{
          20,211},{20,-246},{6,-246},{6,-252}}, color={0,0,127}));
  connect(masFloHea.y, swiFlo.mPos_flow) annotation (Line(points={{0,-276},{0,
          -320},{-16,-320},{-16,-376},{-12,-376}}, color={0,0,127}));
  connect(proHeaWat.PHea, PHeaTot.u[1]) annotation (Line(points={{12,217},{240,
          217},{240,79.5},{268,79.5}},  color={0,0,127}));
  connect(proHotWat.PHea, PHeaTot.u[2]) annotation (Line(points={{12,37},{240,
          37},{240,80.5},{268,80.5}},
                              color={0,0,127}));
  connect(zer.y, PHeaTot.u[2]) annotation (Line(points={{161,360},{242,360},{
          242,78},{268,78},{268,80.5}},color={0,0,127}));
  connect(PHeaTot.y, PHea)
    annotation (Line(points={{292,80},{320,80}}, color={0,0,127}));
  connect(loaSHW, heaFloEvaSHW.u1) annotation (Line(points={{-320,-120},{-288,
          -120},{-288,-36},{-164,-36},{-164,106},{-102,106}},
                                                       color={0,0,127}));
  connect(proHotWat.PHea, heaFloEvaSHW.u2) annotation (Line(points={{12,37},{18,
          37},{18,80},{-108,80},{-108,94},{-102,94}},
                                                   color={0,0,127}));
  connect(senTHeaWatRet.T, dTHHW.u2)
    annotation (Line(points={{20,311},{20,314},{2,314}}, color={0,0,127}));
  connect(senTHeaWatSup.T, dTHHW.u1)
    annotation (Line(points={{140,271},{140,326},{2,326}}, color={0,0,127}));
  connect(senMasFloHeaWat.m_flow, capFloHHW.u) annotation (Line(points={{-240,271},
          {-240,320},{-222,320}}, color={0,0,127}));
  connect(proHeaWat.PHea, heaFloEvaHHW.u2) annotation (Line(points={{12,217},{
          20,217},{20,226},{-110,226},{-110,234},{-102,234}},
                                                           color={0,0,127}));
  connect(conFloEvaSHW.m_flow, proHotWat.m2_flow) annotation (Line(points={{-38,100},
          {-16,100},{-16,31},{-12,31}},               color={0,0,127}));
  connect(conFloEvaHHW.m_flow, proHeaWat.m2_flow) annotation (Line(points={{-38,240},
          {-28,240},{-28,211},{-12,211}},      color={0,0,127}));
  connect(senMasFloHeaWat.m_flow, priOve.u1) annotation (Line(points={{-240,271},
          {-240,296},{-70,296},{-70,286},{-62,286}}, color={0,0,127}));
  connect(conFloConHHW.m_flow, priOve.u2) annotation (Line(points={{-78,280},{-70,
          280},{-70,274},{-62,274}}, color={0,0,127}));
  connect(priOve.y, proHeaWat.m1_flow) annotation (Line(points={{-38,280},{-24,280},
          {-24,214},{-12,214}}, color={0,0,127}));
  connect(heaFloEvaSHW.y, conFloEvaSHW.loa)
    annotation (Line(points={{-78,100},{-62,100}}, color={0,0,127}));
  connect(heaFloEvaHHW.y, conFloEvaHHW.loa)
    annotation (Line(points={{-78,240},{-62,240}}, color={0,0,127}));
  connect(capFloHHW.y, loaHHW.u2) annotation (Line(points={{-198,320},{-180,320},
          {-180,274},{-142,274}}, color={0,0,127}));
  connect(dTHHW.y, loaHHW.u1) annotation (Line(points={{-22,320},{-160,320},{
          -160,286},{-142,286}}, color={0,0,127}));
  connect(loaHHW.y, conFloConHHW.loa)
    annotation (Line(points={{-118,280},{-102,280}}, color={0,0,127}));
  connect(loaHHW.y, heaFloEvaHHW.u1) annotation (Line(points={{-118,280},{-110,
          280},{-110,246},{-102,246}}, color={0,0,127}));
  connect(toSin.y, sinDHW.m_flow_in) annotation (Line(points={{-76,60},{-72,60},
          {-72,68},{-62,68}}, color={0,0,127}));
  connect(div1.y, toSin.u) annotation (Line(points={{-78,-40},{-70,-40},{-70,32},
          {-108,32},{-108,60},{-100,60}}, color={0,0,127}));
  connect(souDCW.T_in, delT.u2) annotation (Line(points={{-52,-14},{-60,-14},{
          -60,-80},{-156,-80},{-156,-6},{-152,-6}}, color={0,0,127}));
  connect(souDCW.ports[1], proHotWat.port_a1) annotation (Line(points={{-30,-10},
          {-20,-10},{-20,28},{-10,28}}, color={0,127,255}));
  connect(sinDHW.ports[1], proHotWat.port_b1) annotation (Line(points={{-40,60},
          {-20,60},{-20,40},{-10,40}}, color={0,127,255}));
  annotation (
  defaultComponentName="ets",
  Documentation(info="<html>
<p>
This model represents an energy transfer station as described in Sommer (2020).
</p>
<ul>
<li>
The cooling function is provided in a compressor-less mode by a heat exchanger
connected to the service line.
The chilled water is typically produced at high temperature and distributed
to radiant cooling systems, for instance at 19&deg;C.
</li>
<li>
The heating functions are provided by water-to-water heat pumps.
<ul>
<li>
By default the condenser and evaporator loops are operated
with variable mass flow rate, with a lower limit specified by the ratio
<code>ratFloMin</code>.
The model can also represent constant flow condenser and evaporator loops
by setting <code>have_varFloCon</code> and <code>have_varFloEva</code>
to <code>false</code>.
</li>
<li>
The evaporator water is supplied by mixing the flow rate from the direct connection
to the service line to the flow rate from the primary side of the cooling
heat exchanger.
The hydronic arrangement modeled in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.SwitchBox\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.SwitchBox</a>
ensures that the resulting fluid stream in the service line always flows
in the same direction.
</li>
<li>
The heating hot water is typically produced at low temperature,
for instance 40&deg;C.
</li>
</ul>
</li>
</ul>
<h4>Controls</h4>
<p>
Heating (resp. cooling) is enabled based on the input signal <code>uHea</code>
(resp. <code>uCoo</code>) which is held for <i>15</i> minutes, meaning that,
when enabled, the mode remains active for at least <i>15</i> minutes and,
when disabled, the mode cannot be enabled again for at least <i>15</i> minutes.
The heating and cooling enable signals should be computed externally based
on a schedule (to lock out the system during off-hours), ideally in conjunction
with the number of requests yielded by the terminal unit controllers, or any
other signal representative of the load.
</p>
<p>
When enabled,
</p>
<ul>
<li>
the heat pumps and the evaporator and condenser water pumps are controlled
based on the principles described in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.HeatPump\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.HeatPump</a>.
The evaporator and condenser water mass flow rates are computed based on the
logic described in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls.PrimaryVariableFlow\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls.PrimaryVariableFlow</a>.
</li>
<li>
the cooling heat exchanger primary pump is modulated based on a PI control
loop tracking the chilled water supply temperature at the outlet of the heat exchanger
secondary side.
</li>
</ul>
<h4>Modeling considerations</h4>
<p>
There is a control volume at each of the two fluid ports that serve as inlet and outlet
of the heating and cooling systems. These approximate the dynamics
of the substation, and they also generally avoid nonlinear systems
of equations if multiple substations are connected to each other.
</p>
<h4>References</h4>
<p>
Sommer T., Sulzer M., Wetter M., Sotnikov A., Mennel S., Stettler C.
<i>The reservoir network: A new network topology for district heating
and cooling.</i>
Energy, Volume 199, 15 May 2020, 117418.
</p>
</html>",
  revisions="<html>
<ul>
<li>
February 23, 2021, by Antoine Gautier:<br/>
Refactored with subsystem models and partial ETS base class.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1769\">
issue 1769</a>.
</li>
<li>
December 12, 2017, by Michael Wetter:<br/>
Removed call to <code>Modelica.Utilities.Files.loadResource</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1097\">issue 1097</a>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-300,-420},{300,440}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-300,-300},{300,300}})));
end HeatPumpHeatExchangerDHWTank;
