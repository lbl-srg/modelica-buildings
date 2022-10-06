within Buildings.Obsolete.DistrictHeatingCooling.SubStations.VaporCompression;
model HeatingCoolingHotwaterTimeSeries_dT
  "Substation for heating, cooling and domestic hot water with load as a time series"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model for water"
      annotation (choicesAllMatching = true);

  parameter Real gaiCoo(min=0) = 1 "Gain to scale cooling load";
  parameter Real gaiHea(min=0) = gaiCoo "Gain to scale heating load";
  parameter Real gaiHotWat(min=0) = gaiHea "Gain to scale hot water load";

  parameter Modelica.Units.SI.Temperature TColMin=273.15 + 8
    "Minimum temperature of district cold water supply";
  parameter Modelica.Units.SI.Temperature THotMax=273.15 + 18
    "Maximum temperature of district hot water supply";

  parameter Modelica.Units.SI.TemperatureDifference dTCooCon_nominal(
    min=0.5,
    displayUnit="K") = 4
    "Temperature difference condenser of the chiller (positive)"
    annotation (Dialog(group="Design parameter"));

  parameter Modelica.Units.SI.TemperatureDifference dTHeaEva_nominal(
    max=-0.5,
    displayUnit="K") = -4
    "Temperature difference evaporator of the heat pump for space heating (negative)"
    annotation (Dialog(group="Design parameter"));

  parameter Modelica.Units.SI.TemperatureDifference dTCooEva_nominal=-4
    "Temperature difference evaporator of the chiller";

  parameter String filNam "Name of data file with heating and cooling load"
   annotation (Dialog(
    loadSelector(filter="Load file (*.mos)",
                 caption="Select load file")));

  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(max=-Modelica.Constants.eps)=
       gaiCoo*Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(string=
    "#Peak space cooling load", filNam=filNam) "Design heat flow rate"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal(min=Modelica.Constants.eps)=
       gaiHea*Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(string=
    "#Peak space heating load", filNam=filNam) "Design heat flow rate"
    annotation (Dialog(group="Design parameter"));
  parameter Modelica.Units.SI.HeatFlowRate QHotWat_flow_nominal(min=Modelica.Constants.eps)=
       gaiHotWat*Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak water heating load", filNam=filNam)
    "Design heat flow rate for domestic hot water"
    annotation (Dialog(group="Design parameter"));

  parameter Modelica.Units.SI.Temperature TChiSup_nominal=273.15 + 16
    "Chilled water leaving temperature at the evaporator"
    annotation (Dialog(group="Nominal conditions"));

  parameter Modelica.Units.SI.Temperature THeaSup_nominal=273.15 + 30
    "Supply temperature space heating system at TOut_nominal"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.Temperature THeaRet_nominal=273.15 + 25
    "Return temperature space heating system at TOut_nominal"
    annotation (Dialog(group="Nominal conditions"));

  parameter Modelica.Units.SI.Temperature TOut_nominal
    "Outside design temperature for heating"
    annotation (Dialog(group="Nominal conditions"));

  parameter Modelica.Units.SI.TemperatureDifference dTHotWatCon_nominal(min=0)=
       60 - 40 "Temperature difference condenser of hot water heat pump";

  parameter Modelica.Units.SI.Pressure dp_nominal(displayUnit="Pa") = 30000
    "Pressure difference at nominal flow rate (for each flow leg)"
    annotation (Dialog(group="Design parameter"));

  final parameter Modelica.Units.SI.MassFlowRate mCooCon_flow_nominal(min=0)=
    -QCoo_flow_nominal/cp_default/dTCooCon_nominal
    "Design mass flow rate for cooling at district side"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.Units.SI.MassFlowRate mHeaEva_flow_nominal(min=0)=
    -QHea_flow_nominal/cp_default/dTHeaEva_nominal
    "Design mass flow rate for space heating at district side"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.Units.SI.MassFlowRate mHotWatEva_flow_nominal(min=0)=
       QHotWat_flow_nominal/cp_default/dTHotWatCon_nominal
    "Design mass flow rate for domestic hot water at district side"
    annotation (Dialog(group="Design parameter"));

  // Diagnostics
   parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  parameter Modelica.Fluid.Types.Dynamics mixingVolumeEnergyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Formulation of energy balance for mixing volume at inlet and outlet"
     annotation(Dialog(tab="Dynamics"));

  Modelica.Blocks.Interfaces.RealOutput PHea(unit="W")
    "Electrical power consumed for space heating"
    annotation (Placement(transformation(extent={{280,270},{300,290}})));

  Modelica.Blocks.Interfaces.RealOutput PHotWat(unit="W")
    "Electrical power consumed for hot water"
    annotation (Placement(transformation(extent={{280,230},{300,250}})));

  Modelica.Blocks.Interfaces.RealOutput PCoo(unit="W")
    "Electrical power consumed for space cooling"
    annotation (Placement(transformation(extent={{280,190},{300,210}})));

  Modelica.Blocks.Interfaces.RealOutput QHea_flow(unit="W")
    "Space heating thermal load"
    annotation (Placement(transformation(extent={{280,130},{300,150}})));
  Modelica.Blocks.Interfaces.RealOutput QHotWat_flow(unit="W")
    "Hot water thermal load"
    annotation (Placement(transformation(extent={{280,90},{300,110}})));
  Modelica.Blocks.Interfaces.RealOutput QCoo_flow(unit="W")
    "Space cooling thermal load"
    annotation (Placement(transformation(extent={{280,50},{300,70}})));

  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-20,360},{20,400}}), iconTransformation(extent=
            {{-10,224},{10,244}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default)) "Fluid connector a"
    annotation (Placement(transformation(extent={{-290,-10},{-270,10}}),
        iconTransformation(extent={{-300,-20},{-260,20}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default)) "Fluid connector b"
    annotation (Placement(transformation(extent={{290,-10},{270,10}}),
        iconTransformation(extent={{298,-20},{258,20}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_a
    "Heat port for sensible heat input into volume a"
    annotation (Placement(transformation(extent={{-290,-100},{-270,-80}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_b
    "Heat port for sensible heat input into volume b"
    annotation (Placement(transformation(extent={{270,-100},{290,-80}})));

  Medium.ThermodynamicState staHea_a2=
      Medium.setState_phX(heaPum.port_a2.p,
                          noEvent(actualStream(heaPum.port_a2.h_outflow)),
                          noEvent(actualStream(heaPum.port_a2.Xi_outflow)))
    if show_T "Medium properties in port_a2 of space heating heat pump intake";

  Medium.ThermodynamicState staHea_b2=
      Medium.setState_phX(heaPum.port_b2.p,
                          noEvent(actualStream(heaPum.port_b2.h_outflow)),
                          noEvent(actualStream(heaPum.port_b2.Xi_outflow)))
    if show_T "Medium properties in port_b2 of space heating heat pump outlet";

  Medium.ThermodynamicState staHotWat_a2=
      Medium.setState_phX(heaPumHotWat.port_a2.p,
                          noEvent(actualStream(heaPumHotWat.port_a2.h_outflow)),
                          noEvent(actualStream(heaPumHotWat.port_a2.Xi_outflow)))
    if show_T "Medium properties in port_a2 of hot water heat pump intake";

  Medium.ThermodynamicState staHotWat_b2=
      Medium.setState_phX(heaPumHotWat.port_b2.p,
                          noEvent(actualStream(heaPumHotWat.port_b2.h_outflow)),
                          noEvent(actualStream(heaPumHotWat.port_b2.Xi_outflow)))
    if show_T "Medium properties in port_b2 of hot water heat pump outlet";

  Medium.ThermodynamicState staCoo_a1=
      Medium.setState_phX(chi.port_a1.p,
                          noEvent(actualStream(chi.port_a1.h_outflow)),
                          noEvent(actualStream(chi.port_a1.Xi_outflow)))
    if show_T "Medium properties in port_a1 of chiller intake";

  Medium.ThermodynamicState staCoo_b1=
      Medium.setState_phX(chi.port_b1.p,
                          noEvent(actualStream(chi.port_b1.h_outflow)),
                          noEvent(actualStream(chi.port_b1.Xi_outflow)))
    if show_T "Medium properties in port_b1 of chiller outlet";

  constant Modelica.Units.SI.SpecificHeatCapacity cp_default=4184
    "Specific heat capacity of the fluid";

  Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    dTEva_nominal=dTHeaEva_nominal,
    dTCon_nominal=THeaSup_nominal-THeaRet_nominal,
    allowFlowReversal1=false,
    allowFlowReversal2=allowFlowReversal,
    use_eta_Carnot_nominal=true,
    etaCarnot_nominal=0.3,
    QCon_flow_nominal=QHea_flow_nominal,
    dp1_nominal=dp_nominal,
    dp2_nominal=dp_nominal)                                 "Heat pump"
    annotation (Placement(transformation(extent={{22,212},{42,232}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pumHea(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mHeaEva_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Continuous,
    use_inputFilter=false,
    addPowerToMedium=false) "Pump for space heating heat pump"
    annotation (Placement(transformation(extent={{30,290},{50,310}})));

  Buildings.Controls.SetPoints.SupplyReturnTemperatureReset TSupHeaSet(
    TSup_nominal=THeaSup_nominal,
    TRet_nominal=THeaRet_nominal,
    TOut_nominal=TOut_nominal) "Set points for heating supply temperature"
    annotation (Placement(transformation(extent={{-220,240},{-200,260}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pumHotWat(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=mHotWatEva_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    inputType=Buildings.Fluid.Types.InputType.Continuous,
    use_inputFilter=false,
    addPowerToMedium=false) "Pump"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Fluid.HeatPumps.Carnot_TCon heaPumHotWat(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    dTEva_nominal=dTHeaEva_nominal,
    allowFlowReversal1=false,
    allowFlowReversal2=allowFlowReversal,
    use_eta_Carnot_nominal=true,
    etaCarnot_nominal=0.3,
    dp1_nominal=dp_nominal,
    dp2_nominal=dp_nominal,
    QCon_flow_nominal=QHotWat_flow_nominal,
    dTCon_nominal=dTHotWatCon_nominal)                      "Heat pump"
    annotation (Placement(transformation(extent={{20,-92},{40,-72}})));

  Buildings.Fluid.Chillers.Carnot_TEva chi(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    use_eta_Carnot_nominal=true,
    etaCarnot_nominal=0.3,
    dp1_nominal=dp_nominal,
    dp2_nominal=dp_nominal,
    QEva_flow_nominal=QCoo_flow_nominal,
    dTEva_nominal=dTCooEva_nominal,
    dTCon_nominal=dTCooCon_nominal,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=false)                               "Chiller"
    annotation (Placement(transformation(extent={{-80,-354},{-60,-334}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pumChi(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal,
    inputType=Buildings.Fluid.Types.InputType.Continuous,
    use_inputFilter=false,
    m_flow_nominal=mCooCon_flow_nominal,
    addPowerToMedium=false) "Pump"
    annotation (Placement(transformation(extent={{-122,-304},{-102,-284}})));

protected
  constant Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  final parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi]) "Medium state at default properties";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_default_check=
      Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";

  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns={2,3,4},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Loads"
    annotation (Placement(transformation(extent={{-260,400},{-240,420}})));

  Modelica.Blocks.Routing.DeMultiplex3 deMul "De multiplex"
    annotation (Placement(transformation(extent={{-178,400},{-158,420}})));

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true) "Mass flow source"
    annotation (Placement(transformation(extent={{-40,218},{-20,238}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    nPorts=1)
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={70,230})));
  Modelica.Blocks.Math.Add dTHeaAct(k2=-1) "Temperature difference for heating"
    annotation (Placement(transformation(extent={{-220,160},{-200,180}})));
  Modelica.Blocks.Math.Division mConFlow "Mass flow rate for condenser"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Modelica.Blocks.Math.Gain gainH(k=cp_default) "Gain for heating"
    annotation (Placement(transformation(extent={{-140,154},{-120,174}})));
  Modelica.Blocks.Math.Add QEva_flow(k1=-1) "Heat flow rate at evaporator"
    annotation (Placement(transformation(extent={{-40,320},{-20,340}})));
  Modelica.Blocks.Math.Add PHeaAct "Power consumption for heating"
    annotation (Placement(transformation(extent={{80,310},{100,330}})));

  Modelica.Blocks.Math.Add QEvaHotWat_flow(k1=-1)
    "Heat flow rate at evaporator"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Math.Add PHotWatAct "Power consumption for heating"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

  Buildings.Fluid.Sources.Boundary_pT sinHotWat(
    redeclare package Medium = Medium,
    nPorts=1) "Pressure source" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}}, origin={62,-74})));
  Buildings.Fluid.Sources.MassFlowSource_T souHotWat(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=false,
    T=313.15) "Mass flow source"
    annotation (Placement(transformation(extent={{-22,-86},{-2,-66}})));
  Modelica.Blocks.Math.Division mConHotWatFlow "Mass flow rate for condenser"
    annotation (Placement(transformation(extent={{-60,-78},{-40,-58}})));
  Modelica.Blocks.Sources.Constant gainHotWat(k=dTHotWatCon_nominal*cp_default)
    "Gain for hot water"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium,
    nPorts=1)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-130,-350})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true) "Mass flow source"
    annotation (Placement(transformation(extent={{-18,-360},{-38,-340}})));

  Modelica.Blocks.Math.Gain mPumCoo_flow(k=1/(cp_default*dTCooCon_nominal))
    "Mass flow rate for cooling loop"
    annotation (Placement(transformation(extent={{-180,-280},{-160,-260}})));
  Modelica.Blocks.Math.Add QCon_flow(k1=-1) "Heat flow rate at condenser"
    annotation (Placement(transformation(extent={{-220,-280},{-200,-260}})));
  Modelica.Blocks.Math.Add PCooAct "Power consumption for cooling"
    annotation (Placement(transformation(extent={{80,-310},{100,-290}})));

  Modelica.Blocks.Sources.Constant TChiSup(k=TChiSup_nominal)
    "Supply water temperature set point for chilled water loop"
    annotation (Placement(transformation(extent={{-180,-344},{-160,-324}})));

  Buildings.Utilities.Math.SmoothMax smoothMax(
    deltaX=(THeaSup_nominal - THeaRet_nominal)*0.005)
    annotation (Placement(transformation(extent={{-180,154},{-160,174}})));

  Modelica.Blocks.Sources.Constant dTHeaPumConMin(k=4)
    "Minimum temperature difference over condenser"
    annotation (Placement(transformation(extent={{-220,120},{-200,140}})));
  Modelica.Blocks.Sources.Constant TSetHotWat(k=273.15 + 60)
    "Set point for hot water temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Math.Add THeaPumSup
    "Set point for heat pump outlet temperature. This block avoids TSup=TRet"
    annotation (Placement(transformation(extent={{-140,250},{-120,270}})));

  Modelica.Blocks.Sources.Constant dTChiEvaMin(k=-dTCooEva_nominal)
    "Temperature difference over evaporator"
    annotation (Placement(transformation(extent={{-180,-394},{-160,-374}})));
  Modelica.Blocks.Math.Add TEvaIn "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-100,-384},{-80,-364}})));

  Buildings.Fluid.Delays.DelayFirstOrder del_a(
    redeclare final package Medium = Medium,
    nPorts=4,
    final m_flow_nominal=(mHeaEva_flow_nominal + mCooCon_flow_nominal + mHotWatEva_flow_nominal)/2,
    final allowFlowReversal=true,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume to break algebraic loops and to emulate the delay of the substation"
    annotation (Placement(transformation(extent={{-270,10},{-250,30}})));
  Buildings.Fluid.Delays.DelayFirstOrder del_b(
    redeclare final package Medium = Medium,
    nPorts=4,
    final m_flow_nominal=(mHeaEva_flow_nominal + mCooCon_flow_nominal + mHotWatEva_flow_nominal)/2,
    final allowFlowReversal=true,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume to break algebraic loops and to emulate the delay of the substation"
    annotation (Placement(transformation(extent={{250,10},{270,30}})));

  Modelica.Blocks.Math.Gain gaiLoa[3](final k={gaiCoo, gaiHea, gaiHotWat})
    "Gain that can be used to scale the individual loads up or down. Components are cooling, heating and hot water"
    annotation (Placement(transformation(extent={{-220,400},{-200,420}})));
  Modelica.Blocks.Math.Gain mPumHotWat_flow(
    final k=1/(cp_default*dTHeaEva_nominal))
    "Mass flow rate for hot water loop"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Math.Gain mPumHea_flow(
    final k=1/(cp_default*dTHeaEva_nominal)) "Mass flow rate for heating loop"
    annotation (Placement(transformation(extent={{0,320},{20,340}})));
  Modelica.Blocks.Math.Gain mPumCooEva_flow(
    final k=-1/(cp_default*dTCooCon_nominal))
    "Mass flow rate for chiller evaporator water loop"
    annotation (Placement(transformation(extent={{40,-350},{20,-330}})));
initial equation
  assert(abs((cp_default-cp_default_check)/cp_default) < 0.1, "Wrong cp_default value. Check cp_default constant.");
  assert(QCoo_flow_nominal < 0,
    "Nominal cooling rate must be strictly negative. Obtained QCoo_flow_nominal = "
    + String(QCoo_flow_nominal));
  assert(QHea_flow_nominal > 0,
    "Nominal heating rate must be strictly positive. Obtained QHea_flow_nominal = "
    + String(QHea_flow_nominal));
  assert(QHotWat_flow_nominal > 0,
    "Nominal hot water heating rate must be strictly positive. Obtained QHotWat_flow_nominal = "
    + String(QHotWat_flow_nominal));




equation
  connect(pumHea.port_b, heaPum.port_a2) annotation (Line(points={{50,300},{50,
          300},{100,300},{100,216},{42,216}},
                                            color={0,127,255}));
  connect(dTHeaAct.u1, TSupHeaSet.TSup) annotation (Line(points={{-222,176},{
          -230,176},{-230,192},{-180,192},{-180,256},{-199,256}},
                                              color={0,0,127}));
  connect(TSupHeaSet.TRet, dTHeaAct.u2) annotation (Line(points={{-199,244},{
          -186,244},{-186,214},{-186,200},{-238,200},{-238,164},{-222,164}},
                                                color={0,0,127}));
  connect(mConFlow.u1, deMul.y2[1]) annotation (Line(points={{-82,176},{-100,176},
          {-100,350},{-100,382},{-100,410},{-157,410}}, color={0,0,127}));
  connect(gainH.y, mConFlow.u2) annotation (Line(points={{-119,164},{-119,164},
          {-82,164}},                color={0,0,127}));
  connect(mConFlow.y, sou.m_flow_in) annotation (Line(points={{-59,170},{-50,
          170},{-50,236},{-40,236}},
                              color={0,0,127}));
  connect(sou.ports[1], heaPum.port_a1) annotation (Line(points={{-20,228},{10,
          228},{22,228}},    color={0,127,255}));
  connect(heaPum.port_b1, sin1.ports[1]) annotation (Line(points={{42,228},{42,
          228},{60,228},{60,230}},
                              color={0,127,255}));
  connect(sou.T_in, TSupHeaSet.TRet) annotation (Line(points={{-42,232},{-60,
          232},{-60,244},{-190,244},{-200,244},{-199,244}},
                               color={0,0,127}));
  connect(QEva_flow.u1, deMul.y2[1]) annotation (Line(points={{-42,336},{-100,336},
          {-100,398},{-100,410},{-157,410}}, color={0,0,127}));
  connect(QEva_flow.u2, heaPum.P) annotation (Line(points={{-42,324},{-60,324},{
          -60,280},{-30,280},{48,280},{48,222},{43,222}},
                                                   color={0,0,127}));
  connect(PHeaAct.y, PHea) annotation (Line(points={{101,320},{220,320},{220,
          280},{290,280}},
                      color={0,0,127}));
  connect(PHeaAct.u1, pumHea.P) annotation (Line(points={{78,326},{58,326},{58,309},
          {51,309}},      color={0,0,127}));
  connect(PHeaAct.u2, heaPum.P) annotation (Line(points={{78,314},{60,314},{60,
          280},{48,280},{48,222},{43,222}},
                                      color={0,0,127}));
  connect(QEvaHotWat_flow.u2, heaPumHotWat.P) annotation (Line(points={{-42,34},
          {-50,34},{-50,0},{-50,-20},{48,-20},{48,-82},{41,-82}},      color={0,
          0,127}));
  connect(PHotWatAct.u2, heaPumHotWat.P) annotation (Line(points={{98,14},{60,
          14},{60,-20},{48,-20},{48,-82},{41,-82}}, color={0,0,127}));
  connect(PHotWatAct.u1, pumHotWat.P) annotation (Line(points={{98,26},{58,26},{
          58,9},{51,9}},      color={0,0,127}));
  connect(heaPumHotWat.port_b1, sinHotWat.ports[1]) annotation (Line(points={{40,-76},
          {40,-74},{46,-74},{52,-74}},          color={0,127,255}));
  connect(souHotWat.ports[1], heaPumHotWat.port_a1) annotation (Line(points={{-2,-76},
          {0,-76},{20,-76}},                  color={0,127,255}));
  connect(mConHotWatFlow.y, souHotWat.m_flow_in) annotation (Line(points={{-39,-68},
          {-22,-68}},                        color={0,0,127}));
  connect(gainHotWat.y, mConHotWatFlow.u2) annotation (Line(points={{-79,-90},{
          -80,-90},{-80,-90},{-78,-90},{-70,-90},{-70,-74},{-62,-74}},
                                 color={0,0,127}));
  connect(QEvaHotWat_flow.u1, deMul.y3[1]) annotation (Line(points={{-42,46},{-42,
          44},{-92,44},{-92,403},{-157,403}},       color={0,0,127}));
  connect(PHotWatAct.y, PHotWat) annotation (Line(points={{121,20},{160,20},{
          160,240},{290,240}},
                           color={0,0,127}));
  connect(pumHotWat.port_b, heaPumHotWat.port_a2) annotation (Line(points={{50,0},{
          64,0},{80,0},{80,-88},{40,-88}},        color={0,127,255},
      thickness=0.5));
  connect(mConHotWatFlow.u1, deMul.y3[1]) annotation (Line(points={{-62,-62},{-92,
          -62},{-92,403},{-157,403}},  color={0,0,127}));
  connect(chi.port_b2, sin2.ports[1]) annotation (Line(points={{-80,-350},{-100,
          -350},{-120,-350}},             color={0,127,255}));
  connect(chi.port_a2, sou1.ports[1])
    annotation (Line(points={{-60,-350},{-38,-350}}, color={0,127,255}));
  connect(mPumCoo_flow.y, pumChi.m_flow_in) annotation (Line(points={{-159,-270},
          {-159,-270},{-112,-270},{-112,-276},{-112,-276},{-112,-282}},
                                        color={0,0,127}));
  connect(mPumCoo_flow.u, QCon_flow.y)
    annotation (Line(points={{-182,-270},{-182,-270},{-182,-268},{-182,-270},{-190,
          -270},{-199,-270}},                          color={0,0,127}));
  connect(pumChi.port_b, chi.port_a1) annotation (Line(points={{-102,-294},{-88,
          -294},{-88,-338},{-80,-338}}, color={0,127,255},
      thickness=0.5));
  connect(QCon_flow.u1, deMul.y1[1]) annotation (Line(points={{-222,-264},{-240,
          -264},{-240,-220},{-106,-220},{-106,417},{-157,417}},
                                                          color={0,0,127}));
  connect(QCon_flow.u2, chi.P) annotation (Line(points={{-222,-276},{-240,-276},
          {-240,-314},{-50,-314},{-50,-344},{-59,-344}}, color={0,0,127}));
  connect(PCooAct.y, PCoo) annotation (Line(points={{101,-300},{168,-300},{168,
          200},{290,200}},
                      color={0,0,127}));
  connect(PCooAct.u1, pumChi.P) annotation (Line(points={{78,-294},{66,-294},{66,
          -285},{-101,-285}}, color={0,0,127}));
  connect(PCooAct.u2, chi.P) annotation (Line(points={{78,-306},{66,-306},{66,
          -314},{-50,-314},{-50,-344},{-59,-344}},
                             color={0,0,127}));
  connect(TChiSup.y, chi.TSet) annotation (Line(points={{-159,-334},{-82,-334},
          {-82,-335}},color={0,0,127}));
  connect(dTHeaAct.y, smoothMax.u1) annotation (Line(points={{-199,170},{-199,
          170},{-182,170}},     color={0,0,127}));
  connect(dTHeaPumConMin.y, smoothMax.u2) annotation (Line(points={{-199,130},{
          -190,130},{-190,158},{-182,158}},
                                     color={0,0,127}));
  connect(TSetHotWat.y, heaPumHotWat.TSet) annotation (Line(points={{-59,-30},{
          8,-30},{8,-73},{18,-73}},   color={0,0,127}));
  connect(gainH.u, smoothMax.y)
    annotation (Line(points={{-142,164},{-146,164},{-150,164},{-159,164}},
                                                             color={0,0,127}));
  connect(THeaPumSup.u1, TSupHeaSet.TRet) annotation (Line(points={{-142,266},{
          -170,266},{-170,244},{-199,244}}, color={0,0,127}));
  connect(THeaPumSup.u2, smoothMax.y) annotation (Line(points={{-142,254},{-148,
          254},{-148,164},{-159,164}},
                                     color={0,0,127}));
  connect(THeaPumSup.y, heaPum.TSet) annotation (Line(points={{-119,260},{-106,
          260},{0,260},{0,231},{20,231}},
                                        color={0,0,127}));
  connect(TChiSup.y, TEvaIn.u1) annotation (Line(points={{-159,-334},{-150,-334},
          {-150,-368},{-102,-368}}, color={0,0,127}));
  connect(dTChiEvaMin.y, TEvaIn.u2) annotation (Line(points={{-159,-384},{-130,
          -384},{-130,-380},{-102,-380}}, color={0,0,127}));
  connect(TEvaIn.y, sou1.T_in) annotation (Line(points={{-79,-374},{-40,-374},{
          -10,-374},{-10,-346},{-16,-346}}, color={0,0,127}));
  connect(del_a.ports[1], port_a)
    annotation (Line(points={{-263,10},{-263,0},{-280,0}}, color={0,127,255}));
  connect(pumHea.port_a, del_a.ports[2]) annotation (Line(points={{30,300},{30,
          300},{-242,300},{-242,2},{-262,2},{-262,0},{-262,6},{-261,6},{-261,10}},
                                                        color={0,127,255}));
  connect(pumHotWat.port_a, del_a.ports[3]) annotation (Line(points={{30,0},{
          -94,0},{-258,0},{-259,0},{-259,10}},              color={0,127,255},
      thickness=0.5));
  connect(chi.port_b1, del_a.ports[4]) annotation (Line(points={{-60,-338},{-46,
          -338},{-46,-332},{-46,-240},{-256,-240},{-256,-116},{-257,-116},{-257,
          10}},                                               color={0,127,255},
      thickness=0.5));

  connect(heaPum.port_b2, del_b.ports[1]) annotation (Line(points={{22,216},{18,
          216},{18,180},{200,180},{200,6},{257,6},{257,8},{257,10}},
                                    color={0,127,255}));
  connect(heaPumHotWat.port_b2, del_b.ports[2]) annotation (Line(points={{20,-88},
          {10,-88},{10,-120},{259,-120},{259,10}},  color={0,127,255},
      thickness=0.5));
  connect(pumChi.port_a, del_b.ports[3]) annotation (Line(points={{-122,-294},{
          -134,-294},{-134,-244},{260,-244},{260,10},{261,10}},
                                                           color={0,127,255},
      thickness=0.5));
  connect(port_b, del_b.ports[4])
    annotation (Line(points={{280,0},{263,0},{263,10}}, color={0,127,255}));
  connect(weaBus.TDryBul, TSupHeaSet.TOut) annotation (Line(
      points={{0,380},{-106,380},{-232,380},{-232,256},{-222,256}},
      color={255,204,51},
      thickness=0.5));

  connect(deMul.y2[1], QHea_flow) annotation (Line(points={{-157,410},{-157,408},
          {240,408},{240,140},{290,140}}, color={0,0,127}));
  connect(deMul.y3[1], QHotWat_flow) annotation (Line(points={{-157,403},{-157,404},
          {236,404},{236,100},{290,100}},      color={0,0,127}));
  connect(deMul.y1[1], QCoo_flow) annotation (Line(points={{-157,417},{232,417},
          {232,60},{290,60}}, color={0,0,127}));

  connect(loa.y, gaiLoa.u)
    annotation (Line(points={{-239,410},{-222,410}}, color={0,0,127}));
  connect(gaiLoa.y, deMul.u)
    annotation (Line(points={{-199,410},{-180,410}}, color={0,0,127}));
  connect(del_a.heatPort, heatPort_a) annotation (Line(points={{-270,20},{-276,20},
          {-276,-90},{-280,-90}},       color={191,0,0}));
  connect(del_b.heatPort, heatPort_b) annotation (Line(points={{250,20},{244,20},
          {244,-90},{254,-90},{280,-90}},                     color={191,0,0}));
  connect(QEvaHotWat_flow.y, mPumHotWat_flow.u)
    annotation (Line(points={{-19,40},{-2,40}}, color={0,0,127}));
  connect(mPumHotWat_flow.y, pumHotWat.m_flow_in)
    annotation (Line(points={{21,40},{40,40},{40,12}},     color={0,0,127}));
  connect(QEva_flow.y, mPumHea_flow.u)
    annotation (Line(points={{-19,330},{-2,330},{-2,330}}, color={0,0,127}));
  connect(mPumHea_flow.y, pumHea.m_flow_in) annotation (Line(points={{21,330},{40,
          330},{40,312}},   color={0,0,127}));
  connect(deMul.y1[1], mPumCooEva_flow.u) annotation (Line(points={{-157,417},{-106,
          417},{-106,-220},{50,-220},{50,-340},{42,-340}}, color={0,0,127}));
  connect(mPumCooEva_flow.y, sou1.m_flow_in) annotation (Line(points={{19,-340},
          {-18,-340},{-18,-342}}, color={0,0,127}));
  annotation (
  defaultComponentName="bui",
  Documentation(info="<html>
<p>
Model for a substation with space heating, space cooling and domestic hot water.
</p>
<p>
The model takes as parameters
the temperature lift on the primary side and
and then draws the required amount of water.
The load is specified by a file that contains
time series for the load profiles. This file needs to have
the following format:
</p>
<pre>
#1
#Heating and Cooling Model loads for a SF large office
#First column: Seconds in the year (loads are hourly)
#Second column: cooling loads in Watts (as negative numbers).
#Third column: space heating loads in Watts. Obsolete.DistrictHeatingCooling.SubStations.Heating is a combination of electric space heating, gas space heating
#Gas heaters in the model were 80% efficient where electric heaters were 100% efficient. Here the total watts = electric watts + .80*(gas watts)
#Fourth column: water heating = 0.8 * gas water watts
#Peak space cooling load = -383165.6989 Watts
#Peak space heating load = 893931.4335 Watts
#Peak water heating load = 19496.90012 Watts
double tab1(8760,4)
0,0,5972.314925,16
3600,0,4925.839944,1750.915684
7200,0,7470.393385,1750.971979
[to be continued]
</pre>
<p>
Values at intermediate times are interpolated using cubic Hermite splines.
</p>
<h4>Implementation</h4>
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
</html>", revisions="<html>
<ul>
<li>
December 12, 2017, by Michael Wetter:<br/>
Removed call to <code>Modelica.Utilities.Files.loadResource</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1097\">issue 1097</a>.
</li>
<li>
November 28, 2016, by Michael Wetter:<br/>
Added call to <code>Modelica.Utilities.Files.loadResource</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/585\">#585</a>.
</li>
<li>
August 8, 2016, by Michael Wetter:<br/>
Changed default temperature to compute COP to be the leaving temperature as
use of the entering temperature can violate the 2nd law if the temperature
lift is small.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/497\">
Annex 60, issue 497</a>.
</li>
<li>
June 26, 2016, by Michael Wetter:<br/>
Changed interpolation for combi table with load data
to use cubic hermite splines.
This is because previously, the table did not generate events
when using linear interpolation, which caused the
solver to take too big steps, missing data points in the table.
This is due to Dassault SR00312338.
</li>
<li>
April 21, 2016, by Michael Wetter:<br/>
Added gains to scale loads and peak load.
</li>
<li>
February 23, 2016, by Michael Wetter:<br/>
Removed the wrong attributes <code>port_a.m_flow.min</code> and <code>port_b.m_flow.max</code>,
which were used by the solver and hence caused non-convergence.
This is for Dassault SR 312338.
</li>
<li>
December 1, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-280,-280},{280,280}}, preserveAspectRatio=false),
                                                           graphics={
                                Rectangle(
        extent={{-280,-280},{280,280}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{18,-38},{46,-10}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-169,-344},{131,-384}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{2,8},{282,-8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-278,-8},{2,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
      Rectangle(
          extent={{-180,180},{174,-220}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
      Rectangle(
        extent={{36,42},{108,114}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-124,42},{-52,114}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-126,-122},{-54,-50}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{40,-122},{112,-50}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{0,264},{-218,164},{220,164},{0,264}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95})}),
    Diagram(coordinateSystem(extent={{-280,-460},{280,460}},
          preserveAspectRatio=false)));
end HeatingCoolingHotwaterTimeSeries_dT;
