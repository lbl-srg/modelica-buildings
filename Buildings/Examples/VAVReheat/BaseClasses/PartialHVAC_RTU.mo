within Buildings.Examples.VAVReheat.BaseClasses;
partial model PartialHVAC_RTU
  "Partial model of variable air volume flow system with terminal reheat that serves five thermal zones"

  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases
      "Medium model for air";
  replaceable package MediumW = Buildings.Media.Water
      "Medium model for water";

  constant Integer numZon(min=2)=5
    "Total number of served VAV boxes";

  parameter Modelica.Units.SI.Volume VRoo[numZon]
    "Room volume per zone";
  parameter Modelica.Units.SI.Area AFlo[numZon]
    "Floor area per zone";

  final parameter Modelica.Units.SI.Area ATot=sum(AFlo)
    "Total floor area for all zone";

  parameter Modelica.Units.SI.HeatFlowRate QHeaAHU_flow_nominal(min=0) = mHeaAir_flow_nominal * cpAir * (THeaAirSup_nominal-THeaAirMix_nominal)
    "Nominal total heating heat flow rate of rooftop unit coil"
    annotation (Dialog(group="Nominal heat flow rate"));

  parameter Modelica.Units.SI.HeatFlowRate QCooAHU_flow_nominal(max=0) = 1.3 * mCooAir_flow_nominal * cpAir *(TCooAirSup_nominal-TCooAirMix_nominal)
    "Nominal total cooling heat flow rate of rooftop unit coil (negative number)"
    annotation (Dialog(group="Nominal heat flow rate"));

  parameter Modelica.Units.SI.HeatFlowRate QAuxHea_flow_nominal=3000
    "Nominal heat flow rate of auxiliary heating coil"
    annotation (Dialog(group="Nominal heat flow rate"));

  parameter Modelica.Units.SI.MassFlowRate mCooVAV_flow_nominal[numZon]
    "Design mass flow rate per zone for cooling"
    annotation (Dialog(group="Nominal mass flow rate"));

  parameter Modelica.Units.SI.MassFlowRate mHeaVAV_flow_nominal[numZon] = 0.3*mCooVAV_flow_nominal
    "Design mass flow rate per zone for heating"
    annotation (Dialog(group="Nominal mass flow rate"));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=mCooAir_flow_nominal
    "Nominal mass flow rate for fan"
    annotation (Dialog(group="Nominal mass flow rate"));

  parameter Modelica.Units.SI.MassFlowRate mCooAir_flow_nominal=0.7*sum(mCooVAV_flow_nominal)
    "Nominal mass flow rate for fan"
    annotation (Dialog(group="Nominal mass flow rate"));

  parameter Modelica.Units.SI.MassFlowRate mHeaAir_flow_nominal = 0.7*sum(mHeaVAV_flow_nominal)
    "Nominal mass flow rate for fan"
    annotation (Dialog(group="Nominal mass flow rate"));

  parameter Real ratOAFlo_A(final unit="m3/(s.m2)") = 0.3e-3
    "Outdoor airflow rate required per unit area";

  parameter Real ratOAFlo_P = 2.5e-3
    "Outdoor airflow rate required per person";

  parameter Real ratP_A = 5e-2
    "Occupant density";
  parameter Real effZ(final unit="1") = 0.8
    "Zone air distribution effectiveness (limiting value)";

  parameter Real divP(final unit="1") = 0.7
    "Occupant diversity ratio";

  parameter Modelica.Units.SI.VolumeFlowRate VZonOA_flow_nominal[numZon]=(
      ratOAFlo_P*ratP_A + ratOAFlo_A)*AFlo/effZ
    "Zone outdoor air flow rate of each VAV box";

  parameter Modelica.Units.SI.VolumeFlowRate Vou_flow_nominal=(divP*ratOAFlo_P*
      ratP_A + ratOAFlo_A)*sum(AFlo) "System uncorrected outdoor air flow rate";
  parameter Real effVen(final unit="1") = if divP < 0.6 then
    0.88 * divP + 0.22 else 0.75
    "System ventilation efficiency";

  parameter Modelica.Units.SI.VolumeFlowRate Vot_flow_nominal=Vou_flow_nominal/effVen
    "System design outdoor air flow rate";

  parameter Modelica.Units.SI.Temperature THeaOn=293.15
    "Heating setpoint during on"
    annotation (Dialog(group="Room temperature setpoints"));

  parameter Modelica.Units.SI.Temperature THeaOff=285.15
    "Heating setpoint during off"
    annotation (Dialog(group="Room temperature setpoints"));

  parameter Modelica.Units.SI.Temperature TCooOn=297.15
    "Cooling setpoint during on"
    annotation (Dialog(group="Room temperature setpoints"));

  parameter Modelica.Units.SI.Temperature TCooOff=303.15
    "Cooling setpoint during off"
    annotation (Dialog(group="Room temperature setpoints"));

  parameter Modelica.Units.SI.PressureDifference dpBuiStaSet(min=0) = 12
    "Building static pressure";

  parameter Real yFanMin = 0.1
    "Minimum fan speed";

  parameter Modelica.Units.SI.Temperature TCooAirMix_nominal(displayUnit="degC")=303.15
    "Mixed air temperature during cooling nominal conditions (used to size cooling coil)"
    annotation (Dialog(group="Air handler unit nominal temperatures and humidity"));

  parameter Modelica.Units.SI.Temperature TCooAirSup_nominal(displayUnit="degC")=285.15
    "Supply air temperature during cooling nominal conditions (used to size cooling coil)"
    annotation (Dialog(group="Air handler unit nominal temperatures and humidity"));

  parameter Modelica.Units.SI.MassFraction wCooAirMix_nominal = 0.017
    "Humidity ratio of mixed air at a nominal conditions used to size cooling coil (in kg/kg dry total)"
    annotation (Dialog(group="Air handler unit nominal temperatures and humidity"));

  parameter Modelica.Units.SI.Temperature THeaAirMix_nominal(displayUnit="degC")=277.15
    "Mixed air temperature during heating nominal conditions (used to size heating coil)"
    annotation (Dialog(group="Air handler unit nominal temperatures and humidity"));

  parameter Modelica.Units.SI.Temperature THeaAirSup_nominal(displayUnit="degC")=285.15
    "Supply air temperature during heating nominal conditions (used to size heating coil)"
    annotation (Dialog(group="Air handler unit nominal temperatures and humidity"));

  parameter Modelica.Units.SI.Temperature THeaWatInl_nominal(displayUnit="degC")
    "Reheat coil nominal inlet water temperature"
    annotation (Dialog(group="Air handler unit nominal temperatures and humidity"));

  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Evaluate=true);

  parameter Integer nCoi(min=1) = 3
    "Number of DX coils";

  parameter Modelica.Units.SI.PressureDifference dpDXCoi_nominal=1000
    "Pressure drop at mAir_flow_nominal for DX coils";

  parameter Modelica.Units.SI.PressureDifference dpAuxHea_nominal=6000
    "Pressure drop at mAir_flow_nominal for auxiliary coil";

  replaceable parameter Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.DXCoil datHeaCoi
    "Performance data of DX heating coil"
    annotation (Placement(transformation(extent={{-4,-142},{16,-122}})));

  replaceable parameter Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.DXCoil datCooCoi
    "Performance data of DX cooling coil"
    annotation (Placement(transformation(extent={{42,-142},{62,-122}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_supAir[numZon](
    redeclare package Medium = MediumA)
    "Supply air to thermal zones"
    annotation (Placement(transformation(extent={{1410,150},{1430,170}}),
      iconTransformation(extent={{432,190},{452,210}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_retAir[numZon](
    redeclare package Medium = MediumA)
    "Return air from thermal zones"
    annotation (Placement(transformation(extent={{1410,110},{1430,130}}),
      iconTransformation(extent={{432,20},{452,40}})));

  Modelica.Blocks.Interfaces.RealInput TRoo[numZon](
    each final unit="K",
    each displayUnit="degC")
    "Room temperatures"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}}, rotation=0, origin={-400,320}),
      iconTransformation(extent={{-20,-20},{20,20}}, rotation=0, origin={-220,180})));

  Buildings.Fluid.Sources.Outside amb(
    redeclare package Medium = MediumA,
    nPorts=2)
    "Ambient conditions"
    annotation (Placement(transformation(extent={{-136,-56},{-114,-34}})));

  Buildings.Fluid.DXSystems.Heating.AirSource.SingleSpeed HeaCoi[nCoi](
    redeclare each final package Medium = MediumA,
    each final dp_nominal=dpDXCoi_nominal,
    each final datCoi=datHeaCoi,
    each final T_start=datHeaCoi.sta[1].nomVal.TConIn_nominal,
    each final show_T=true,
    each final from_dp=true,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final dTHys=1e-6)
    "Single speed DX heating coil"
    annotation (Placement(transformation(extent={{100,-30},{120,-50}})));

  Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed CooCoi[nCoi](
    redeclare each final package Medium = MediumA,
    each final dp_nominal=dpDXCoi_nominal,
    each final datCoi=datCooCoi,
    each final minSpeRat=datCooCoi.minSpeRat,
    each final T_start=datCooCoi.sta[1].nomVal.TEvaIn_nominal,
    each final from_dp=true,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Variable speed DX cooling coil"
    annotation (Placement(transformation(extent={{240,-30},{260,-50}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u AuxHeaCoi(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=dpAuxHea_nominal,
    final Q_flow_nominal=QAuxHea_flow_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Auxiliary heating coil"
    annotation (Placement(transformation(extent={{460,-50},{480,-30}})));

  Buildings.Fluid.FixedResistances.PressureDrop dpRetDuc(
    m_flow_nominal=mAir_flow_nominal,
    redeclare package Medium = MediumA,
    allowFlowReversal=allowFlowReversal,
    dp_nominal=40)
    "Pressure drop for return duct"
    annotation (Placement(transformation(extent={{400,130},{380,150}})));

  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y fanSup(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=780 + 10 + dpBuiStaSet,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Supply air fan"
    annotation (Placement(transformation(extent={{400,-50},{420,-30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senSupFlo(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal)
    "Sensor for supply fan flow rate"
    annotation (Placement(transformation(extent={{560,-50},{580,-30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senRetFlo(
    redeclare package Medium = MediumA, m_flow_nominal=mAir_flow_nominal)
    "Sensor for return fan flow rate"
    annotation (Placement(transformation(extent={{360,130},{340,150}})));

  Modelica.Blocks.Routing.RealPassThrough TOut(y(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0))
    annotation (Placement(transformation(extent={{-300,170},{-280,190}})));

  Buildings.Fluid.Sensors.RelativePressure dpDisSupFan(
    redeclare package Medium = MediumA)
    "Supply fan static discharge pressure"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=90, origin={420,0})));

  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-320,-220},{-300,-200}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TRet(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    allowFlowReversal=allowFlowReversal)
    "Return air temperature sensor"
    annotation (Placement(transformation(extent={{110,130},{90,150}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TMix(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    transferHeat=true)
    "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate VOut1(
    redeclare package Medium =MediumA,
    m_flow_nominal=mAir_flow_nominal)
    "Outside air volume flow rate"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

  BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-330,170},{-310,190}}),
      iconTransformation(extent={{-168,134},{-148,154}})));

  Fluid.Actuators.Dampers.Exponential damRet(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    from_dp=false,
    riseTime=15,
    dpDamper_nominal=5,
    dpFixed_nominal=5)
    "Return air damper"
    annotation (Placement(transformation(origin={0,-10}, extent={{10,-10},{-10,10}}, rotation=90)));

  Fluid.Actuators.Dampers.Exponential damOut(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    from_dp=false,
    riseTime=15,
    dpDamper_nominal=5,
    dpFixed_nominal=5)
    "Outdoor air damper"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));

  Modelica.Fluid.Interfaces.FluidPort_a portHeaTerSup(
    redeclare package Medium = MediumW)
    "Terminal heat loop supply"
    annotation (Placement(transformation(extent={{450,-310},{470,-290}}),
      iconTransformation(extent={{250,-150},{270,-130}})));

  Modelica.Fluid.Interfaces.FluidPort_b portHeaTerRet(
    redeclare package Medium = MediumW)
    "Terminal heat loop return"
    annotation (Placement( transformation(extent={{490,-310},{510,-290}}),
      iconTransformation(extent={{310,-150},{330,-130}})));

  Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox VAVBox[numZon](
    redeclare each package MediumA = MediumA,
    redeclare each package MediumW = MediumW,
    mCooAir_flow_nominal=mCooVAV_flow_nominal,
    mHeaAir_flow_nominal=mHeaVAV_flow_nominal,
    VRoo=VRoo,
    each allowFlowReversal=allowFlowReversal,
    each THeaWatInl_nominal=THeaWatInl_nominal,
    each THeaWatOut_nominal=THeaWatInl_nominal - 10,
    each THeaAirInl_nominal=285.15,
    each THeaAirDis_nominal=301.15)
    "VAV boxes"
    annotation (Placement(transformation(extent={{720,20},{760,60}})));

  Buildings.Fluid.FixedResistances.Junction splRetRoo[numZon - 1](
    redeclare each package Medium = MediumA,
    each from_dp=false,
    each linearized=true,
    m_flow_nominal={{sum(mCooVAV_flow_nominal[i:numZon]),sum(
        mCooVAV_flow_nominal[(i + 1):numZon]),mCooVAV_flow_nominal[i]} for i in
            1:(numZon - 1)},
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each dp_nominal(each displayUnit="Pa") = {0,0,0},
    each portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Splitter for room return air"
    annotation (Placement(transformation(extent={{830,110},{850,90}})));

  Buildings.Fluid.FixedResistances.Junction splSupRoo[numZon - 1](
    redeclare each package Medium = MediumA,
    each from_dp=true,
    each linearized=true,
    m_flow_nominal={{sum(mCooVAV_flow_nominal[i:numZon]),sum(
        mCooVAV_flow_nominal[(i + 1):numZon]),mCooVAV_flow_nominal[i]} for i in
            1:(numZon - 1)},
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each dp_nominal(each displayUnit="Pa") = {0,0,0},
    each portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply air"
    annotation (Placement(transformation(extent={{730,-30},{750,-50}})));

  Buildings.Fluid.FixedResistances.PressureDrop dpSupDuc(
    m_flow_nominal=mAir_flow_nominal,
    redeclare package Medium = MediumA,
    allowFlowReversal=allowFlowReversal,
    dp_nominal=200 + 200 + 100 + 40)
    "Pressure drop for supply duct"
    annotation (Placement(transformation(extent={{350,-50},{370,-30}})));

  Buildings.Fluid.FixedResistances.Junction splRetOut(
    redeclare package Medium = MediumA,
    tau=15,
    m_flow_nominal=mAir_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    linearized=true)
    "Flow splitter"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}}, rotation=0, origin={0,-40})));

  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi
    "Calculate humidity ratio from outdoor air temperature and relative humidity"
    annotation (Placement(transformation(extent={{-300,90},{-280,110}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    allowFlowReversal=allowFlowReversal)
    "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{508,-50},{528,-30}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort THeaCoi(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    allowFlowReversal=allowFlowReversal)
    "Heating coil outlet air temperature sensor"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TCooCoi(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    allowFlowReversal=allowFlowReversal)
    "Cooling coil outlet air temperature sensor"
    annotation (Placement(transformation(extent={{310,-50},{330,-30}})));

  Modelica.Blocks.Routing.RealPassThrough Phi(y(
    final unit="1"))
    "Outdoor air relative humidity"
    annotation (Placement(transformation(extent={{-300,130},{-280,150}})));

protected
  constant Modelica.Units.SI.SpecificHeatCapacity cpAir=Buildings.Utilities.Psychrometrics.Constants.cpAir
    "Air specific heat capacity";
  constant Modelica.Units.SI.SpecificHeatCapacity cpWat=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Water specific heat capacity";
  model Results "Model to store the results of the simulation"
    parameter Modelica.Units.SI.Area A "Floor area";
    input Modelica.Units.SI.Power PFan "Fan energy";
    input Modelica.Units.SI.Power PPum "Pump energy";
    input Modelica.Units.SI.Power PHea "Heating energy";
    input Modelica.Units.SI.Power PCooSen "Sensible cooling energy";
    input Modelica.Units.SI.Power PCooLat "Latent cooling energy";

    Real EFan(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Fan energy";
    Real EPum(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Pump energy";
    Real EHea(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Heating energy";
    Real ECooSen(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Sensible cooling energy";
    Real ECooLat(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Latent cooling energy";
    Real ECoo(unit="J/m2") "Total cooling energy";
  equation

    A*der(EFan) = PFan;
    A*der(EPum) = PPum;
    A*der(EHea) = PHea;
    A*der(ECooSen) = PCooSen;
    A*der(ECooLat) = PCooLat;
    ECoo = ECooSen + ECooLat;

  end Results;
equation
  connect(fanSup.port_b, dpDisSupFan.port_a) annotation (Line(
      points={{420,-40},{420,-10}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(amb.ports[1], VOut1.port_a) annotation (Line(
      points={{-114,-46.1},{-94,-46.1},{-94,-40},{-90,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{-320,180},{-302,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(amb.weaBus, weaBus) annotation (Line(
      points={{-136,-44.78},{-320,-44.78},{-320,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

  connect(senRetFlo.port_a, dpRetDuc.port_b)
    annotation (Line(points={{360,140},{380,140}}, color={0,127,255}));
  connect(dpDisSupFan.port_b, amb.ports[2]) annotation (Line(
      points={{420,10},{420,20},{-114,20},{-114,-43.9}},
      color={0,0,0},
      pattern=LinePattern.Dot));
  connect(senRetFlo.port_b, TRet.port_a) annotation (Line(points={{340,140},{
          226,140},{110,140}}, color={0,127,255}));
  connect(VOut1.port_b, damOut.port_a)
    annotation (Line(points={{-70,-40},{-50,-40}}, color={0,127,255}));
  connect(damRet.port_a, TRet.port_b)
    annotation (Line(points={{0,0},{0,140},{90,140}}, color={0,127,255}));

  connect(VAVBox.port_bAir, port_supAir) annotation (Line(points={{740,60},{740,
          160},{1420,160}}, color={0,127,255}));

  for i in 1:numZon loop
    connect(VAVBox[i].port_aHeaWat, portHeaTerSup)
      annotation (Line(points={{720,40},{638,40},{638,-240},{460,-240},{460,-300}},
      color={0,127,255}));
    connect(VAVBox[i].port_bHeaWat, portHeaTerRet)
      annotation (Line(points={{720,28},{660,28},{660,-262},{500,-262},{500,-300}},
      color={0,127,255}));
  end for;

  connect(splSupRoo[1].port_1, senSupFlo.port_b)
    annotation (Line(points={{730,-40},{580,-40}}, color={0,127,255}));
  connect(splRetRoo[1].port_1, dpRetDuc.port_a)
    annotation (Line(points={{830,100},{580,100},{580,140},{400,140}},
    color={0,127,255}));
  connect(splSupRoo.port_3, VAVBox[1:(numZon-1)].port_aAir)
    annotation (Line(points={{740,-30},{740,20}}, color={0,127,255}));
  connect(splRetRoo.port_3, port_retAir[1:(numZon-1)])
    annotation (Line(points={{840,110},{840,128},{1384,128},{1384,120},{1420,
          120}},
    color={0,127,255}));

  for i in 1:(numZon - 2) loop
      connect(splSupRoo[i].port_2, splSupRoo[i+1].port_1)
          annotation (Line(points={{750,-40},{730,-40}},
    color={0,127,255}));
      connect(splRetRoo[i].port_2, splRetRoo[i+1].port_1)
          annotation (Line(points={{850,100},{854,100},{854,80},{824,80},{824,
            100},{830,100}},
    color={0,127,255}));
  end for;
  connect(splSupRoo[numZon-1].port_2, VAVBox[numZon].port_aAir);
  connect(splRetRoo[numZon-1].port_2, port_retAir[numZon]);

  connect(dpSupDuc.port_b, fanSup.port_a)
    annotation (Line(points={{370,-40},{400,-40}}, color={0,127,255}));
  connect(damOut.port_b, splRetOut.port_1)
    annotation (Line(points={{-30,-40},{-10,-40}}, color={0,127,255}));
  connect(splRetOut.port_2, TMix.port_a)
    annotation (Line(points={{10,-40},{30,-40}}, color={0,127,255}));
  connect(damRet.port_b, splRetOut.port_3) annotation (Line(points={{-5.55112e-16,
          -20},{-5.55112e-16,-25},{0,-25},{0,-30}}, color={0,127,255}));
  connect(weaBus.pAtm, x_pTphi.p_in) annotation (Line(
      points={{-320,180},{-320,106},{-302,106}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TDryBul, x_pTphi.T) annotation (Line(
      points={{-320,180},{-320,100},{-302,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.relHum, x_pTphi.phi) annotation (Line(
      points={{-320,180},{-320,94},{-302,94}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSup.port_b, senSupFlo.port_a)
    annotation (Line(points={{528,-40},{560,-40}}, color={0,127,255}));
  connect(TSup.port_a, AuxHeaCoi.port_b)
    annotation (Line(points={{508,-40},{480,-40}}, color={0,127,255}));
  connect(AuxHeaCoi.port_a, fanSup.port_b)
    annotation (Line(points={{460,-40},{420,-40}}, color={0,127,255}));
  connect(dpSupDuc.port_a, TCooCoi.port_b)
    annotation (Line(points={{350,-40},{330,-40}}, color={0,127,255}));
  for i in 1:nCoi loop
  connect(THeaCoi.port_a, HeaCoi[i].port_b)
    annotation (Line(points={{160,-40},{120,-40}}, color={0,127,255}));
  connect(TMix.port_b, HeaCoi[i].port_a)
    annotation (Line(points={{50,-40},{100,-40}}, color={0,127,255}));
  connect(THeaCoi.port_b,CooCoi [i].port_a)
    annotation (Line(points={{180,-40},{240,-40}}, color={0,127,255}));
  connect(CooCoi[i].port_b, TCooCoi.port_a)
    annotation (Line(points={{260,-40},{310,-40}}, color={0,127,255}));
  end for;
  connect(weaBus.relHum, Phi.u) annotation (Line(
      points={{-320,180},{-320,140},{-302,140}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  annotation (Diagram(
    coordinateSystem(
    preserveAspectRatio=false,
    extent={{-380,-300},{1420,360}})),
    Documentation(info="<html>
  <p>
  This partial model replaced an air handler unit (AHU) within a variable air flow (VAV) system,
  as reported in 
  <a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC\">
  Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</a>, 
  with a rooftop unit (RTU). 
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  August 28, 2023, by Junke Wang and Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"),
    Icon(coordinateSystem(extent={{-200,-140},{440,220}}),graphics={
        Text(
          extent={{56,226},{168,290}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-200,222},{440,-140}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end PartialHVAC_RTU;
