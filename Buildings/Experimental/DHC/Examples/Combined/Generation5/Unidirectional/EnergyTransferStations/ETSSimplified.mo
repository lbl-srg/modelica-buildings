within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.EnergyTransferStations;
model ETSSimplified
  "Simplified model of a substation producing heating hot water (heat pump) and chilled water (HX)"
  extends DHC.EnergyTransferStations.BaseClasses.PartialETS(
    final typ=DHC.Types.DistrictSystemType.CombinedGeneration5,
    final have_weaBus=false,
    final have_chiWat=true,
    final have_heaWat=true,
    have_hotWat=false,
    final have_eleHea=true,
    final have_eleCoo=false,
    final have_pum=true,
    final have_fan=false,
    nPorts_aHeaWat=1,
    nPorts_aChiWat=1);
  outer Data.DesignDataSeries datDes "DHC system design data";
  // SYSTEM GENERAL
  parameter Modelica.SIunits.TemperatureDifference dT_nominal = 5
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature TChiWatSup_nominal=291.15
    "Chilled water supply temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature TChiWatRet_nominal=
    TChiWatSup_nominal + dT_nominal
    "Chilled water return temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature THeaWatSup_nominal=313.15
    "Heating water supply temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature THeaWatRet_nominal=
    THeaWatSup_nominal - dT_nominal
    "Heating water return temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature THotWatSup_nominal=336.15
    "Hot water supply temperature"
    annotation (Dialog(group="Nominal conditions", enable=have_hotWat));
  parameter Modelica.SIunits.Temperature TColWat_nominal=288.15
    "Cold water temperature"
    annotation (Dialog(group="Nominal conditions", enable=have_hotWat));
  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa") = 50000
    "Pressure difference at nominal flow rate (for each flow leg)"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal(min=0)=
    abs(QHeaWat_flow_nominal / cp_default / (THeaWatSup_nominal - THeaWatRet_nominal))
    "Heating water mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal(min=0)=
    abs(QChiWat_flow_nominal / cp_default / (TChiWatSup_nominal - TChiWatRet_nominal))
    "Heating water mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.HeatFlowRate QEvaHotWat_flow_nominal(max=0)=
    if have_hotWat then -QHotWat_flow_nominal * (COPHotWat_nominal - 1) / COPHotWat_nominal
    else 0
    "SHW heat pump evaporator heat flow rate"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.MassFlowRate mEvaHotWat_flow_nominal(min=0)=
    if have_hotWat then abs(QEvaHotWat_flow_nominal / cp_default / dT_nominal)
    else 0
    "SHW heat pump evaporator mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.MassFlowRate mDisWat_flow_nominal(min=0)=
    max(heaPum.m2_flow_nominal + mEvaHotWat_flow_nominal, hexChi.m1_flow_nominal)
    "District water mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    MediumBui.specificHeatCapacityCp(MediumBui.setState_pTX(
      p = MediumBui.p_default,
      T = MediumBui.T_default))
    "Specific heat capacity of the fluid";
  //// Heat pump for heating water production
  parameter Real COP_nominal(final unit="1") = 5
    "COP of heat pump for heating water production"
    annotation (Dialog(group="Nominal conditions"));
  //// Heat pump for hot water production
  parameter Real COPHotWat_nominal(final unit="1") = 2
    "COP of heat pump for hot water production"
    annotation (Dialog(group="Nominal conditions", enable=have_hotWat));
  // District HX
  final parameter Modelica.SIunits.Temperature T1HexChiEnt_nominal=
    datDes.TLooMax
    "CHW HX primary entering temperature"
     annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.Temperature T2HexChiEnt_nominal=
    TChiWatRet_nominal
    "CHW HX secondary entering temperature"
     annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.MassFlowRate m1HexChi_flow_nominal(min=0)=
    abs(QChiWat_flow_nominal / cp_default / dT_nominal)
    "CHW HX primary mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.MassFlowRate m2HexChi_flow_nominal(min=0)=
    abs(QChiWat_flow_nominal / cp_default / (THeaWatSup_nominal - THeaWatRet_nominal))
    "CHW HX secondary mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  // Diagnostics
   parameter Boolean show_T = true
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));
  parameter Modelica.Fluid.Types.Dynamics mixingVolumeEnergyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Formulation of energy balance for mixing volume at inlet and outlet"
     annotation(Dialog(tab="Dynamics"));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(final unit="K",
      displayUnit="degC")
    "Heating water supply temperature set point" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,80}), iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=0,
        origin={-340,80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSupSet(final unit="K",
      displayUnit="degC") if have_hotWat
    "Service hot water supply temperature set point" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,0}), iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=0,
        origin={-340,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TColWat(
    final unit="K",
    displayUnit="degC") if have_hotWat
    "Cold water temperature" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,-40}), iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=0,
        origin={-340,-100})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput loaSHW(final unit="W") if have_hotWat
    "Service hot water load"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,-80}), iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=0,
        origin={-340,-160})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(final unit="K",
      displayUnit="degC")
    "Chilled water supply temperature set point" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,40}), iconTransformation(
        extent={{-40,-40},{40,40}},
        rotation=0,
        origin={-340,20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PCom(final unit="W")
    "Power drawn by compressor"
    annotation (Placement(transformation(extent={{300,-120},{340,-80}}),
      iconTransformation(extent={{300,-120},{380,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mHea_flow(final unit="kg/s")
    "District water mass flow rate used for heating service"
    annotation ( Placement(transformation(extent={{300,-160},{340,-120}}),
      iconTransformation(extent={{300,-160},{380,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mCoo_flow(final unit="kg/s")
    "District water mass flow rate used for cooling service"
    annotation ( Placement(transformation(extent={{300,-200},{340,-160}}),
      iconTransformation(extent={{300,-200},{380,-120}})));
  // COMPONENTS
  Buildings.Fluid.Delays.DelayFirstOrder volMixDis_a(
    redeclare final package Medium = MediumSer,
    final nPorts=if have_hotWat then 4 else 3,
    final m_flow_nominal=mDisWat_flow_nominal,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume to break algebraic loops and to emulate the delay of the substation"
    annotation (Placement(transformation(extent={{-270,-360},{-250,-380}})));
  Buildings.Fluid.Delays.DelayFirstOrder volMixDis_b(
    redeclare final package Medium = MediumSer,
    final nPorts=if have_hotWat then 4 else 3,
    final m_flow_nominal=mDisWat_flow_nominal,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume to break algebraic loops and to emulate the delay of the substation"
    annotation (Placement(transformation(extent={{250,-360},{270,-380}})));
  DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pum1HexChi(
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
    final T_a1_nominal=T1HexChiEnt_nominal,
    final T_a2_nominal=T2HexChiEnt_nominal,
    final allowFlowReversal1=allowFlowReversalSer,
    final allowFlowReversal2=allowFlowReversalBui)
    "Chilled water HX"
    annotation (Placement(transformation(extent={{10,-324},{-10,-344}})));
  Buildings.Fluid.Delays.DelayFirstOrder volHeaWatRet(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=heaPum.m1_flow_nominal,
    final allowFlowReversal=allowFlowReversalBui,
    tau=60,
    final energyDynamics=mixingVolumeEnergyDynamics,
    nPorts=3) "Mixing volume representing building HHW primary"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=90,
      origin={130,180})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2HexChiLvg(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=m2HexChi_flow_nominal,
    tau=1) "CHW HX secondary water leaving temperature (measured)"
    annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={40,-320})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold have_reqHea(
    t=0.01*mHeaWat_flow_nominal)
    "Outputs true in case of heating request from the building"
    annotation (Placement(transformation(extent={{-260,210},{-240,230}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloHeaWat(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui)
    "Heating water mass flow rate"
    annotation (Placement(transformation(extent={{-290,270},{-270,250}})));
  Buildings.Fluid.Delays.DelayFirstOrder volChiWat(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=m1HexChi_flow_nominal,
    final allowFlowReversal=allowFlowReversalBui,
    tau=60,
    final energyDynamics=mixingVolumeEnergyDynamics,
    nPorts=3) "Mixing volume representing building CHW primary"
    annotation (Placement(transformation(extent={{-110,-280},{-90,-260}})));
  DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pum2CooHex(
    redeclare package Medium = MediumBui,
    final m_flow_nominal=m2HexChi_flow_nominal,
    final allowFlowReversal=allowFlowReversalBui)
    "Chilled water HX secondary pump"
    annotation (Placement(transformation(extent={{-70,-330},{-50,-310}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloChiWat(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui)
    "Chilled water mass flow rate"
    annotation (Placement(transformation(extent={{-250,-110},{-230,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold have_reqCoo(
    t=0.01 * mChiWat_flow_nominal)
    "Outputs true in case of cooling request from the building"
    annotation (Placement(transformation(extent={{-230,-190},{-210,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(
    final k=m1HexChi_flow_nominal)
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  DHC.EnergyTransferStations.Combined.Generation5.Controls.PIDWithEnable conTChiWat(
    k=0.1,
    Ti=120,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseActing=false,
    yMin=0)
    "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{-150,-210},{-130,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai4(k=1.1)
    annotation (Placement(transformation(extent={{-140,-250},{-120,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PHeaTot(final nin=2)
    "Total power for space heating (ETS included, building excluded)"
    annotation (Placement(transformation(extent={{230,350},{250,370}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumHeaTot(final nin=2)
    "Total pump power for space heating (ETS included, building excluded)"
    annotation (Placement(transformation(extent={{190,410},{210,430}})));
  Buildings.Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium = MediumBui,
    nPorts=1)
    "Pressure boundary condition representing the expansion vessel"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=-90,
      origin={100,150})));
  Buildings.Fluid.Sources.Boundary_pT bouChiWat(redeclare final package Medium =
        MediumBui, nPorts=1)
    "Pressure boundary condition representing the expansion vessel"
    annotation (Placement(transformation(extent={{-162,-290},{-142,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumCooTot(nin=2)
    "Total pump power for space cooling (ETS included, building excluded)"
    annotation (Placement(transformation(extent={{190,370},{210,390}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumTot(nin=2)
    "Total pump power (ETS included, building excluded)"
    annotation (Placement(transformation(extent={{230,390},{250,410}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(
    redeclare final package Medium=MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=mHeaWat_flow_nominal)
    "Heating water supply temperature"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={200,260})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTChiWatSup(
    redeclare final package Medium=MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled water supply temperature"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={160,-160})));
  SwitchBox swiFlo(
    redeclare final package Medium = MediumSer,
    final have_hotWat=have_hotWat,
    final m_flow_nominal=mDisWat_flow_nominal) "Flow switch box"
    annotation (Placement(transformation(extent={{-10,-390},{10,-370}})));
  Buildings.Controls.OBC.CDL.Continuous.Product swiOff
    "Switch off the pump in case of no cooling request"
    annotation (Placement(transformation(extent={{-110,-190},{-90,-170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{-150,-170},{-130,-150}})));
  Fluid.Sensors.TemperatureTwoPort senT2HexChiEnt(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=m2HexChi_flow_nominal)
    "CHW HX secondary water entering temperature (measured)" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,-320})));
  DHC.EnergyTransferStations.BaseClasses.Junction bypHeaWatSup(
   redeclare final package Medium = MediumBui,
   final m_flow_nominal=heaPum.m1_flow_nominal*{1,-1,-1})
   "Bypass heating water (supply)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={140,260})));
  DHC.EnergyTransferStations.BaseClasses.Junction bypHeaWatRet(
   redeclare final package Medium = MediumBui,
   final m_flow_nominal=heaPum.m1_flow_nominal*{1,-1,1})
   "Bypass heating water (return)"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={140,240})));
  DHC.EnergyTransferStations.BaseClasses.Junction bypChiWatRet(
   redeclare final package Medium = MediumBui,
   final m_flow_nominal=m2HexChi_flow_nominal*{1,-1,1})
   "Bypass chilled water (return)"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-140})));
  DHC.EnergyTransferStations.BaseClasses.Junction bypChiWatSup(
   redeclare final package Medium = MediumBui,
   final m_flow_nominal=m2HexChi_flow_nominal*{1,-1,-1})
   "Bypass chilled water (supply)"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={110,-160})));
  // MISCELLANEOUS VARIABLES
  MediumSer.ThermodynamicState sta_aDis=if allowFlowReversalSer then
    MediumSer.setState_phX(port_aSerAmb.p,
      noEvent(actualStream(port_aSerAmb.h_outflow)),
      noEvent(actualStream(port_aSerAmb.Xi_outflow))) else
    MediumSer.setState_phX(port_aSerAmb.p,
      inStream(port_aSerAmb.h_outflow),
      inStream(port_aSerAmb.Xi_outflow)) if show_T
    "Medium properties in port_aDis";
  MediumSer.ThermodynamicState sta_bDis=if allowFlowReversalSer then
    MediumSer.setState_phX(port_bSerAmb.p,
      noEvent(actualStream(port_bSerAmb.h_outflow)),
      noEvent(actualStream(port_bSerAmb.Xi_outflow))) else
    MediumSer.setState_phX(port_bSerAmb.p,
      port_bSerAmb.h_outflow,
      port_bSerAmb.Xi_outflow) if  show_T
    "Medium properties in port_bDis";
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold enaHea(trueHoldDuration=5*60)
    "Enable heating"
    annotation (Placement(transformation(extent={{-230,210},{-210,230}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold enaCoo(trueHoldDuration=5*60)
    "Enable cooling"
    annotation (Placement(transformation(extent={{-200,-190},{-180,-170}})));
  Subsystems.HeatPump heaPum(
    redeclare final package Medium1 = MediumBui,
    redeclare final package Medium2 = MediumSer,
    final COP_nominal=COP_nominal,
    final Q1_flow_nominal=QHeaWat_flow_nominal,
    final allowFlowReversal1=allowFlowReversalBui,
    final allowFlowReversal2=allowFlowReversalSer,
    final dT1_nominal=dT_nominal,
    final dT2_nominal=-dT_nominal,
    final dp1_nominal=dp_nominal,
    final dp2_nominal=dp_nominal) "Subsystem for heating water production"
    annotation (Placement(transformation(extent={{-10,204},{10,224}})));
  Controls.OBC.CDL.Continuous.MultiSum PCooTot(nin=1)
    "Total power for space cooling (ETS included, building excluded)"
    annotation (Placement(transformation(extent={{230,310},{250,330}})));
  Subsystems.HeatPump heaPumSHW(
    redeclare final package Medium1 = MediumBui,
    redeclare final package Medium2 = MediumSer,
    final have_pumCon=false,
    final COP_nominal=COPHotWat_nominal,
    final Q1_flow_nominal=QHotWat_flow_nominal,
    final allowFlowReversal1=allowFlowReversalBui,
    final allowFlowReversal2=allowFlowReversalSer,
    final dT1_nominal=THotWatSup_nominal-TColWat_nominal,
    final dT2_nominal=-dT_nominal,
    final dp1_nominal=dp_nominal,
    final dp2_nominal=dp_nominal) if have_hotWat
    "Subsystem for service hot water production"
    annotation (Placement(transformation(extent={{-10,24},{10,44}})));
  Fluid.Sources.Boundary_pT sinSHW(
    redeclare final package Medium = MediumBui,
    nPorts=1) if  have_hotWat
    "Sink for service hot water" annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-50,60})));
  Fluid.Sources.MassFlowSource_T souColWat(
    redeclare final package Medium = MediumBui,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) if have_hotWat
    "Source for cold water"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Controls.OBC.CDL.Continuous.Division div1 if have_hotWat
    "Compute mass flow rate from load"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Controls.OBC.CDL.Continuous.Gain gai(final k=cp_default) if  have_hotWat
    "Times Cp"
    annotation (Placement(transformation(extent={{-108,-30},{-88,-10}})));
  Controls.OBC.CDL.Logical.Sources.Constant enaSHW(k=have_hotWat)
    "Enable signal for SHW production"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Controls.OBC.CDL.Continuous.MultiSum masFloHeaTot(final nin=2)
    "Compute district water mass flow rate used for heating service"
    annotation (Placement(transformation(extent={{270,-150},{290,-130}})));
  Modelica.Blocks.Sources.Constant zer(final k=0) if not have_hotWat
    "Replacement variable"
    annotation (Placement(transformation(extent={{140,350},{160,370}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PComTot(final nin=2)
    "Total compressor power"
    annotation (Placement(transformation(extent={{230,270},{250,290}})));
  Fluid.Sensors.TemperatureTwoPort senTHeaWatRet(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=mHeaWat_flow_nominal)
    "Heating water return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={140,300})));
  Fluid.Sensors.TemperatureTwoPort senTChiWatRet(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled water return temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-120})));
  Controls.OBC.CDL.Continuous.Add delT(final k2=-1) if have_hotWat
    "Compute DeltaT"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Fluid.Sensors.MassFlowRate senMasFloHeaWatPri(redeclare final package Medium =
        MediumBui, final allowFlowReversal=allowFlowReversalBui)
    "Primary heating water mass flow rate"
    annotation (Placement(transformation(extent={{40,270},{60,250}})));
equation
  connect(senMasFloHeaWat.m_flow, have_reqHea.u) annotation (Line(points={{-280,
          249},{-280,220},{-262,220}}, color={0,0,127}));
  connect(senMasFloChiWat.m_flow, have_reqCoo.u)
    annotation (Line(points={{-240,-131},{-240,-180},{-232,-180}},
                                                            color={0,0,127}));
  connect(senT2HexChiLvg.T, conTChiWat.u_m) annotation (Line(points={{40,-309},{
          40,-220},{-140,-220},{-140,-212}}, color={0,0,127}));
  connect(TChiWatSupSet, conTChiWat.u_s) annotation (Line(points={{-320,40},{-160,
          40},{-160,-200},{-152,-200}}, color={0,0,127}));
  connect(gai4.y, pum2CooHex.m_flow_in) annotation (Line(points={{-118,-240},{-60,
          -240},{-60,-308}},  color={0,0,127}));
  connect(senMasFloChiWat.m_flow, gai4.u) annotation (Line(points={{-240,-131},{
          -240,-240},{-142,-240}}, color={0,0,127}));
  connect(pum1HexChi.P, PPumCooTot.u[1]) annotation (Line(points={{89,-331},{84,
          -331},{84,-322},{180,-322},{180,381},{188,381}}, color={0,0,127}));
  connect(pum2CooHex.P, PPumCooTot.u[2]) annotation (Line(points={{-49,-311},{-20,
          -311},{-20,-300},{178,-300},{178,379},{188,379}}, color={0,0,127}));
  connect(PPumHeaTot.y, PHeaTot.u[1]) annotation (Line(points={{212,420},{220,420},
          {220,361},{228,361}}, color={0,0,127}));
  connect(PPumHeaTot.y, PPumTot.u[1]) annotation (Line(points={{212,420},{220,420},
          {220,401},{228,401}}, color={0,0,127}));
  connect(PPumCooTot.y, PPumTot.u[2]) annotation (Line(points={{212,380},{216,380},
          {216,399},{228,399}}, color={0,0,127}));
  connect(pum1HexChi.port_b, hexChi.port_a1) annotation (Line(points={{90,-340},
          {10,-340}},                              color={0,127,255}));
  connect(pum2CooHex.port_b, hexChi.port_a2)
    annotation (Line(points={{-50,-320},{-20,-320},{-20,-328},{-10,-328}},
                                                  color={0,127,255}));
  connect(pum1HexChi.m_flow_actual, mCoo_flow) annotation (Line(points={{89,-335},
          {82,-335},{82,-320},{276,-320},{276,-180},{320,-180}}, color={0,0,127}));
  connect(volMixDis_a.ports[1], swiFlo.port_bSup) annotation (Line(points={{-260,
          -360},{-4,-360},{-4,-370}}, color={0,127,255}));
  connect(swiFlo.port_aRet, volMixDis_b.ports[1]) annotation (Line(points={{4,-370},
          {4,-360},{260,-360}}, color={0,127,255}));
  connect(volMixDis_b.ports[2], pum1HexChi.port_a) annotation (Line(points={{260,
          -360},{258,-360},{258,-340},{110,-340}},                       color={
          0,127,255}));
  connect(hexChi.port_b1, volMixDis_a.ports[2]) annotation (Line(points={{-10,-340},
          {-256,-340},{-256,-360},{-260,-360}},                     color={0,127,
          255}));
  connect(pum1HexChi.m_flow_actual, swiFlo.mFreCoo_flow) annotation (Line(
        points={{89,-335},{80,-335},{80,-356},{-20,-356},{-20,-382},{-12,-382}},
        color={0,0,127}));
  connect(booToRea1.y, swiOff.u1) annotation (Line(points={{-128,-160},{-120,-160},
          {-120,-174},{-112,-174}},
                              color={0,0,127}));
  connect(swiOff.y, gai2.u)
    annotation (Line(points={{-88,-180},{-82,-180}},
                                                 color={0,0,127}));
  connect(conTChiWat.y, swiOff.u2) annotation (Line(points={{-128,-200},{-120,-200},
          {-120,-186},{-112,-186}},
                               color={0,0,127}));
  connect(gai2.y, pum1HexChi.m_flow_in)
    annotation (Line(points={{-58,-180},{100,-180},{100,-328}},
                                                          color={0,0,127}));
  connect(PPumTot.y, PPum) annotation (Line(points={{252,400},{276,400},{276,-60},
          {320,-60}}, color={0,0,127}));
  connect(senT2HexChiEnt.port_b, pum2CooHex.port_a)
    annotation (Line(points={{-90,-320},{-70,-320}},   color={0,127,255}));
  connect(ports_aHeaWat[1], senMasFloHeaWat.port_a) annotation (Line(points={{-300,
          260},{-290,260}},                            color={0,127,255}));
  connect(bypHeaWatSup.port_2, senTHeaWatSup.port_a)
    annotation (Line(points={{150,260},{190,260}}, color={0,127,255}));
  connect(senTHeaWatSup.port_b, ports_bHeaWat[1])
    annotation (Line(points={{210,260},{300,260}}, color={0,127,255}));
  connect(bypHeaWatRet.port_2, volHeaWatRet.ports[1]) annotation (Line(points={{130,240},
          {120,240},{120,177.333}},           color={0,127,255}));
  connect(bouHeaWat.ports[1], volHeaWatRet.ports[2]) annotation (Line(points={{100,160},
          {100,180},{120,180}},              color={0,127,255}));
  connect(ports_aChiWat[1], senMasFloChiWat.port_a) annotation (Line(points={{-300,
          200},{-280,200},{-280,-120},{-250,-120}},    color={0,127,255}));
  connect(senT2HexChiLvg.port_a, hexChi.port_b2) annotation (Line(points={{30,-320},
          {20,-320},{20,-328},{10,-328}},       color={0,127,255}));
  connect(volChiWat.ports[1], bypChiWatRet.port_2) annotation (Line(points={{
          -102.667,-280},{60,-280},{60,-140},{100,-140}}, color={0,127,255}));
  connect(volChiWat.ports[2], senT2HexChiEnt.port_a) annotation (Line(points={{-100,
          -280},{-120,-280},{-120,-320},{-110,-320}},      color={0,127,255}));
  connect(bouChiWat.ports[1], volChiWat.ports[3])
    annotation (Line(points={{-142,-280},{-97.3333,-280}}, color={0,127,255}));
  connect(bypChiWatSup.port_2, senTChiWatSup.port_a)
    annotation (Line(points={{120,-160},{150,-160}}, color={0,127,255}));
  connect(senTChiWatSup.port_b, ports_bChiWat[1]) annotation (Line(points={{170,
          -160},{200,-160},{200,200},{300,200}}, color={0,127,255}));
  connect(senT2HexChiLvg.port_b, bypChiWatSup.port_1) annotation (Line(points={{50,-320},
          {80,-320},{80,-160},{100,-160}},         color={0,127,255}));
  connect(bypChiWatSup.port_3, bypChiWatRet.port_3)
    annotation (Line(points={{110,-150},{110,-150}}, color={0,127,255}));
  connect(bypHeaWatRet.port_3, bypHeaWatSup.port_3)
    annotation (Line(points={{140,250},{140,250}}, color={0,127,255}));
  connect(have_reqHea.y, enaHea.u)
    annotation (Line(points={{-238,220},{-232,220}}, color={255,0,255}));
  connect(have_reqCoo.y, enaCoo.u)
    annotation (Line(points={{-208,-180},{-202,-180}}, color={255,0,255}));
  connect(enaCoo.y, booToRea1.u) annotation (Line(points={{-178,-180},{-170,-180},
          {-170,-160},{-152,-160}}, color={255,0,255}));
  connect(enaCoo.y, conTChiWat.uEna) annotation (Line(points={{-178,-180},{-170,
          -180},{-170,-220},{-144,-220},{-144,-212}}, color={255,0,255}));
  connect(volHeaWatRet.ports[3], heaPum.port_a1) annotation (Line(points={{120,
          182.667},{120,180},{-20,180},{-20,208},{-10,208}},      color={0,127,255}));
  connect(heaPum.port_b2, volMixDis_b.ports[3]) annotation (Line(points={{10,220},
          {262,220},{262,-360},{260,-360}},              color={0,127,255}));
  connect(volMixDis_a.ports[3], heaPum.port_a2) annotation (Line(points={{-260,-360},
          {-260,-360},{-260,200},{20,200},{20,208},{10,208}},
        color={0,127,255}));
  connect(enaHea.y, heaPum.uEna) annotation (Line(points={{-208,220},{-40,220},
          {-40,216},{-12,216}}, color={255,0,255}));
  connect(THeaWatSupSet, heaPum.TSupSet) annotation (Line(points={{-320,80},{-40,
          80},{-40,212},{-12,212}}, color={0,0,127}));
  connect(heaPum.PPum, PPumHeaTot.u[1]) annotation (Line(points={{12,214},{100,214},
          {100,421},{188,421}}, color={0,0,127}));
  connect(PHeaTot.y, PHea) annotation (Line(points={{252,360},{280,360},{280,60},
          {320,60}}, color={0,0,127}));
  connect(PPumCooTot.y, PCooTot.u[1]) annotation (Line(points={{212,380},{216,380},
          {216,320},{228,320}}, color={0,0,127}));
  connect(PCooTot.y, PCoo) annotation (Line(points={{252,320},{272,320},{272,20},
          {320,20}}, color={0,0,127}));
  connect(volMixDis_a.ports[4], heaPumSHW.port_a2) annotation (Line(points={{-260,
          -360},{-258,-360},{-258,20},{20,20},{20,28},{10,28}},     color={0,127,
          255}));
  connect(heaPumSHW.port_b2, volMixDis_b.ports[4])
    annotation (Line(points={{10,40},{260,40},{260,-360}},
                                                         color={0,127,255}));
  connect(THotWatSupSet, heaPumSHW.TSupSet) annotation (Line(points={{-320,0},{-150,
          0},{-150,32},{-12,32}}, color={0,0,127}));
  connect(sinSHW.ports[1], heaPumSHW.port_b1) annotation (Line(points={{-40,60},
          {-20,60},{-20,40},{-10,40}},  color={0,127,255}));
  connect(TColWat, souColWat.T_in) annotation (Line(points={{-320,-40},{-66,-40},
          {-66,-36},{-62,-36}}, color={0,0,127}));
  connect(gai.y, div1.u2) annotation (Line(points={{-86,-20},{-80,-20},{-80,-60},
          {-110,-60},{-110,-86},{-102,-86}},          color={0,0,127}));
  connect(loaSHW, div1.u1) annotation (Line(points={{-320,-80},{-120,-80},{-120,
          -74},{-102,-74}}, color={0,0,127}));
  connect(div1.y, souColWat.m_flow_in) annotation (Line(points={{-78,-80},{-70,-80},
          {-70,-32},{-62,-32}},       color={0,0,127}));
  connect(enaSHW.y, heaPumSHW.uEna) annotation (Line(points={{-118,60},{-80,60},
          {-80,36},{-12,36}}, color={255,0,255}));
  connect(masFloHeaTot.y, mHea_flow)
    annotation (Line(points={{292,-140},{320,-140}}, color={0,0,127}));
  connect(heaPumSHW.mEva_flow, masFloHeaTot.u[2]) annotation (Line(points={{12,31},
          {218,31},{218,-141},{268,-141}}, color={0,0,127}));
  connect(zer.y, masFloHeaTot.u[2]) annotation (Line(points={{161,360},{216,360},
          {216,-144},{268,-144},{268,-141}},color={0,0,127}));
  connect(PComTot.y, PCom) annotation (Line(points={{252,280},{268,280},{268,-100},
          {320,-100}}, color={0,0,127}));
  connect(zer.y, PComTot.u[2]) annotation (Line(points={{161,360},{216,360},{216,
          279},{228,279}},color={0,0,127}));
  connect(heaPum.PHea, PComTot.u[1]) annotation (Line(points={{12,217},{80,217},
          {80,282},{228,282},{228,281}}, color={0,0,127}));
  connect(heaPumSHW.PHea, PComTot.u[2]) annotation (Line(points={{12,37},{118,37},
          {224,37},{224,279},{228,279}},         color={0,0,127}));
  connect(heaPumSHW.PPum, PPumHeaTot.u[2]) annotation (Line(points={{12,34},{176,
          34},{176,420},{188,420},{188,419}}, color={0,0,127}));
  connect(heaPum.mEva_flow, masFloHeaTot.u[1]) annotation (Line(points={{12,211},
          {220,211},{220,-139},{268,-139}},
        color={0,0,127}));
  connect(heaPum.mEva_flow, swiFlo.mHeaWat_flow) annotation (Line(points={{12,211},
          {24,211},{24,-352},{-18,-352},{-18,-377.8},{-12,-377.8}}, color={0,0,127}));
  connect(heaPumSHW.mEva_flow, swiFlo.mHotWat_flow) annotation (Line(points={{12,
          31},{26,31},{26,-354},{-16,-354},{-16,-374},{-12,-374}}, color={0,0,127}));
  connect(PComTot.y, PHeaTot.u[2]) annotation (Line(points={{252,280},{260,280},
          {260,300},{220,300},{220,359},{228,359}}, color={0,0,127}));
  connect(zer.y, PPumHeaTot.u[2]) annotation (Line(points={{161,360},{174,360},{
          174,418},{188,418},{188,419}}, color={0,0,127}));
  connect(senMasFloHeaWat.port_b, senTHeaWatRet.port_a) annotation (Line(points=
         {{-270,260},{-260,260},{-260,300},{130,300}}, color={0,127,255}));
  connect(senTHeaWatRet.port_b, bypHeaWatRet.port_1) annotation (Line(points={{150,
          300},{160,300},{160,240},{150,240}}, color={0,127,255}));
  connect(senMasFloChiWat.port_b, senTChiWatRet.port_a)
    annotation (Line(points={{-230,-120},{70,-120}}, color={0,127,255}));
  connect(senTChiWatRet.port_b, bypChiWatRet.port_1) annotation (Line(points={{90,
          -120},{140,-120},{140,-140},{120,-140}}, color={0,127,255}));
  connect(souColWat.ports[1], heaPumSHW.port_a1) annotation (Line(points={{-40,-40},
          {-20,-40},{-20,28},{-10,28}}, color={0,127,255}));
  connect(delT.y, gai.u)
    annotation (Line(points={{-118,-20},{-110,-20}}, color={0,0,127}));
  connect(TColWat, delT.u2) annotation (Line(points={{-320,-40},{-150,-40},{-150,
          -26},{-142,-26}}, color={0,0,127}));
  connect(THotWatSupSet, delT.u1) annotation (Line(points={{-320,0},{-150,0},{-150,
          -14},{-142,-14}}, color={0,0,127}));
  connect(heaPum.port_b1, senMasFloHeaWatPri.port_a) annotation (Line(points={{
          -10,220},{-20,220},{-20,260},{40,260}}, color={0,127,255}));
  connect(senMasFloHeaWatPri.port_b, bypHeaWatSup.port_1)
    annotation (Line(points={{60,260},{130,260}}, color={0,127,255}));
  connect(port_aSerAmb, swiFlo.port_aSup) annotation (Line(points={{-300,-200},{
          -280,-200},{-280,-400},{-4,-400},{-4,-390}}, color={0,127,255}));
  connect(swiFlo.port_bRet, port_bSerAmb) annotation (Line(points={{4,-390},{4,-400},
          {280,-400},{280,-200},{300,-200}}, color={0,127,255}));
  annotation (
  defaultComponentName="ets",
  Documentation(info="<html>
<p>
Heating hot water is produced at low temperature (typically 40°C) with a water-to-water heat pump.
Chilled water is produced at high temperature (typically 19°C) with a heat exchanger.
</p>
<p>
The time series data are interpolated using
Fritsch-Butland interpolation. This uses
cubic Hermite splines such that y preserves the monotonicity and
der(y) is continuous, also if extrapolated.
</p>
<p>
There is a control volume at each of the two fluid ports
that are exposed by this model. These approximate the dynamics
of the substation, and they also generally avoid nonlinear system
of equations if multiple substations are connected to each other.
</p>
</html>",
  revisions="<html>
<ul>
<li>
December 12, 2017, by Michael Wetter:<br/>
Removed call to <code>Modelica.Utilities.Files.loadResource</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1097\">issue 1097</a>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-300,-420},{300,440}})));
end ETSSimplified;
