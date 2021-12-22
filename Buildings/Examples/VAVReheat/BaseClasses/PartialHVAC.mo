within Buildings.Examples.VAVReheat.BaseClasses;
partial model PartialHVAC
  "Partial model of variable air volume flow system with terminal reheat that serves five thermal zones"

  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases "Medium model for air";
  replaceable package MediumW = Buildings.Media.Water "Medium model for water";

  constant Integer numZon(min=2)=5 "Total number of served VAV boxes";

  parameter Modelica.Units.SI.Volume VRoo[numZon] "Room volume per zone";
  parameter Modelica.Units.SI.Area AFlo[numZon] "Floor area per zone";

  final parameter Modelica.Units.SI.Area ATot=sum(AFlo)
    "Total floor area for all zone";

  constant Real conv=1.2/3600 "Conversion factor for nominal mass flow rate";


  parameter Modelica.Units.SI.HeatFlowRate QHeaAHU_flow_nominal(min=0) = mHeaAir_flow_nominal * cpAir * (THeaAirSup_nominal-THeaAirMix_nominal)
    "Nominal heating heat flow rate of air handler unit coil";

  parameter Modelica.Units.SI.HeatFlowRate QCooAHU_flow_nominal(max=0) = 1.3 * mCooAir_flow_nominal * cpAir *(TCooAirSup_nominal-TCooAirMix_nominal)
    "Nominal total cooling heat flow rate of air handler unit coil (negative number)";

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

  parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=
      QHeaAHU_flow_nominal/cpWat/10
    "Nominal water mass flow rate for heating coil in AHU"
    annotation (Dialog(group="Nominal mass flow rate"));
  parameter Modelica.Units.SI.MassFlowRate mCooWat_flow_nominal=
      QCooAHU_flow_nominal/cpWat/(-6)
    "Nominal water mass flow rate for cooling coil"
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
  parameter Modelica.Units.SI.VolumeFlowRate Vot_flow_nominal=Vou_flow_nominal/
      effVen "System design outdoor air flow rate";

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
  parameter Real yFanMin = 0.1 "Minimum fan speed";


  parameter Modelica.Units.SI.Temperature TCooAirMix_nominal(displayUnit="degC")=303.15
    "Mixed air temperature during cooling nominal conditions (used to size cooling coil)"
    annotation (Dialog(group="Air handler unit nominal temperatures and humidity"));
  parameter Modelica.Units.SI.Temperature TCooAirSup_nominal(displayUnit="degC")=285.15
    "Supply air temperature during cooling nominal conditions (used to size cooling coil)"
    annotation (Dialog(group="Air handler unit nominal temperatures and humidity"));
  parameter Modelica.Units.SI.MassFraction wCooAirMix_nominal = 0.017
    "Humidity ratio of mixed air at a nominal conditions used to size cooling coil (in kg/kg dry total)"
    annotation (Dialog(group="Air handler unit nominal temperatures and humidity"));
   parameter Modelica.Units.SI.Temperature TCooWatInl_nominal(displayUnit="degC") = 279.15
    "Cooling coil nominal inlet water temperature"
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

  Modelica.Fluid.Interfaces.FluidPort_a port_supAir[numZon](redeclare package
      Medium = MediumA)
    "Supply air to thermal zones"
    annotation (Placement(transformation(extent={{1410,150},{1430,170}}),
        iconTransformation(extent={{432,190},{452,210}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_retAir[numZon](redeclare package
      Medium = MediumA)
    "Return air from thermal zones"
    annotation (Placement(transformation(extent={{1410,110},{1430,130}}),
        iconTransformation(extent={{432,20},{452,40}})));

  Modelica.Blocks.Interfaces.RealInput TRoo[numZon](
   each final unit="K",
   each displayUnit="degC")
   "Room temperatures"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-400,320}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,180})));

  Buildings.Fluid.Sources.Outside amb(
    redeclare package Medium = MediumA,
      nPorts=2) "Ambient conditions"
    annotation (Placement(transformation(extent={{-136,-56},{-114,-34}})));

  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU heaCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    Q_flow_nominal=QHeaAHU_flow_nominal,
    m1_flow_nominal=mHeaWat_flow_nominal,
    m2_flow_nominal=mHeaAir_flow_nominal,
    show_T=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    dp1_nominal=3000,
    dp2_nominal=0,
    allowFlowReversal1=false,
    allowFlowReversal2=allowFlowReversal,
    T_a1_nominal=THeaWatInl_nominal,
    T_a2_nominal=THeaAirMix_nominal)
    "Heating coil"
    annotation (Placement(transformation(extent={{118,-36},{98,-56}})));

  Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    use_Q_flow_nominal=true,
    Q_flow_nominal=QCooAHU_flow_nominal,
    m1_flow_nominal=mCooWat_flow_nominal,
    m2_flow_nominal=mCooAir_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=3000,
    T_a1_nominal=TCooWatInl_nominal,
    T_a2_nominal=TCooAirMix_nominal,
    w_a2_nominal=wCooAirMix_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal1=false,
    allowFlowReversal2=allowFlowReversal,
    show_T=true) "Cooling coil"
    annotation (Placement(transformation(extent={{210,-36},{190,-56}})));
  Buildings.Fluid.FixedResistances.PressureDrop dpRetDuc(
    m_flow_nominal=mAir_flow_nominal,
    redeclare package Medium = MediumA,
    allowFlowReversal=allowFlowReversal,
    dp_nominal=40) "Pressure drop for return duct"
    annotation (Placement(transformation(extent={{400,130},{380,150}})));
  Buildings.Fluid.Movers.SpeedControlled_y fanSup(
    redeclare package Medium = MediumA,
    per(pressure(
      V_flow={0,mAir_flow_nominal/1.2*2},
      dp=2*{780 + 10 + dpBuiStaSet,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
    annotation (Placement(transformation(extent={{300,-50},{320,-30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senSupFlo(redeclare package Medium =
        MediumA, m_flow_nominal=mAir_flow_nominal)
    "Sensor for supply fan flow rate"
    annotation (Placement(transformation(extent={{400,-50},{420,-30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senRetFlo(redeclare package Medium =
        MediumA, m_flow_nominal=mAir_flow_nominal)
    "Sensor for return fan flow rate"
    annotation (Placement(transformation(extent={{360,130},{340,150}})));

  Modelica.Blocks.Routing.RealPassThrough TOut(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0))
    annotation (Placement(transformation(extent={{-300,170},{-280,190}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{330,-50},{350,-30}})));
  Buildings.Fluid.Sensors.RelativePressure dpDisSupFan(redeclare package Medium =
        MediumA) "Supply fan static discharge pressure" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={320,0})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-320,-220},{-300,-200}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TRet(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Return air temperature sensor"
    annotation (Placement(transformation(extent={{110,130},{90,150}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TMix(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Fluid.Sensors.VolumeFlowRate VOut1(redeclare package Medium =
        MediumA, m_flow_nominal=mAir_flow_nominal)
    "Outside air volume flow rate"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-330,170},{-310,190}}),
        iconTransformation(extent={{-168,134},{-148,154}})));

  Results res(
    final A=ATot,
    PFan=fanSup.P + 0,
    PPum=pumHeaCoi.P + pumCooCoi.P,
    PHea=heaCoi.Q2_flow + sum(VAVBox.terHea.Q2_flow),
    PCooSen=cooCoi.QSen2_flow,
    PCooLat=cooCoi.QLat2_flow) "Results of the simulation";

  Fluid.Actuators.Dampers.Exponential damRet(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    from_dp=false,
    riseTime=15,
    dpDamper_nominal=5,
    dpFixed_nominal=5) "Return air damper" annotation (Placement(transformation(
        origin={0,-10},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  Fluid.Actuators.Dampers.Exponential damOut(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    from_dp=false,
    riseTime=15,
    dpDamper_nominal=5,
    dpFixed_nominal=5) "Outdoor air damper"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Fluid.FixedResistances.Junction splCooSup(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCooWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={220,-170})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valCooCoi(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCooWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0) "Valve for cooling coil"    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,-210})));
  Fluid.FixedResistances.Junction splCooRet(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCooWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,-170})));
  Fluid.Movers.SpeedControlled_y pumCooCoi(
    redeclare package Medium = MediumW,
    per(pressure(V_flow={0,mCooWat_flow_nominal/1000*2}, dp=2*{3000,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={180,-120})));
  Fluid.Movers.SpeedControlled_y pumHeaCoi(
    redeclare package Medium = MediumW,
    per(pressure(V_flow={0,mHeaWat_flow_nominal/1000*2}, dp=2*{3000,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Pump for heating coil" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={128,-120})));

  Fluid.Actuators.Valves.TwoWayEqualPercentage valHeaCoi(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0) "Valve for heating coil" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={128,-210})));
  Fluid.FixedResistances.Junction splHeaRet(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={88,-170})));
  Fluid.FixedResistances.Junction splHeaSup(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={128,-170})));


  Modelica.Fluid.Interfaces.FluidPort_a portHeaCoiSup(redeclare package Medium =
        MediumW) "Heating coil loop supply"
    annotation (Placement(transformation(extent={{70,-310},{90,-290}}),
        iconTransformation(extent={{-30,-150},{-10,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_b portHeaCoiRet(redeclare package Medium =
        MediumW) "Heating coil loop return" annotation (Placement(
        transformation(extent={{110,-310},{130,-290}}),
                                                      iconTransformation(extent={{30,-150},
            {50,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_a portHeaTerSup(redeclare package Medium =
        MediumW) "Terminal heat loop supply"
    annotation (Placement(transformation(extent={{450,-310},{470,-290}}),
        iconTransformation(extent={{250,-150},{270,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_b portHeaTerRet(redeclare package Medium =
        MediumW) "Terminal heat loop return" annotation (Placement(
        transformation(extent={{490,-310},{510,-290}}),
                                                      iconTransformation(extent={{310,
            -150},{330,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_a portCooCoiSup(redeclare package Medium =
        MediumW) "Cooling coil loop supply"
    annotation (Placement(transformation(extent={{190,-310},{210,-290}}),
        iconTransformation(extent={{110,-150},{130,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_b portCooCoiRet(redeclare package Medium =
        MediumW)
    "Coolin coil loop return"
    annotation (Placement(transformation(extent={{230,-310},{250,-290}}),
        iconTransformation(extent={{170,-150},{190,-130}})));
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
    each THeaAirDis_nominal=301.15) "VAV boxes"
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

  Fluid.FixedResistances.PressureDrop dpSupDuc(
    m_flow_nominal=mAir_flow_nominal,
    redeclare package Medium = MediumA,
    allowFlowReversal=allowFlowReversal,
    dp_nominal=200 + 200 + 100 + 40) "Pressure drop for supply duct"
    annotation (Placement(transformation(extent={{250,-50},{270,-30}})));

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
      points={{320,-40},{320,-10}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(TSup.port_a, fanSup.port_b) annotation (Line(
      points={{330,-40},{320,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
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
  connect(TSup.port_b, senSupFlo.port_a)
    annotation (Line(points={{350,-40},{400,-40}}, color={0,127,255}));
  connect(dpDisSupFan.port_b, amb.ports[2]) annotation (Line(
      points={{320,10},{320,14},{-106,14},{-106,-48},{-110,-48},{-110,-43.9},{
          -114,-43.9}},
      color={0,0,0},
      pattern=LinePattern.Dot));
  connect(senRetFlo.port_b, TRet.port_a) annotation (Line(points={{340,140},{
          226,140},{110,140}}, color={0,127,255}));
  connect(TMix.port_b, heaCoi.port_a2) annotation (Line(
      points={{50,-40},{98,-40}},
      color={0,127,255},
      thickness=0.5));
  connect(heaCoi.port_b2, cooCoi.port_a2)
    annotation (Line(
      points={{118,-40},{190,-40}},
      color={0,127,255},
      thickness=0.5));
  connect(VOut1.port_b, damOut.port_a)
    annotation (Line(points={{-70,-40},{-50,-40}}, color={0,127,255}));
  connect(damOut.port_b, TMix.port_a)
    annotation (Line(points={{-30,-40},{30,-40}}, color={0,127,255}));
  connect(damRet.port_a, TRet.port_b)
    annotation (Line(points={{0,0},{0,140},{90,140}}, color={0,127,255}));
  connect(damRet.port_b, TMix.port_a)
    annotation (Line(points={{0,-20},{0,-40},{30,-40}}, color={0,127,255}));
  connect(pumHeaCoi.port_b, heaCoi.port_a1) annotation (Line(points={{128,-110},
          {128,-52},{118,-52}}, color={0,127,255}));
  connect(cooCoi.port_b1,pumCooCoi. port_a) annotation (Line(points={{190,-52},{
          180,-52},{180,-110}}, color={0,127,255}));
  connect(splCooSup.port_2, cooCoi.port_a1) annotation (Line(points={{220,-160},
          {220,-52},{210,-52}}, color={0,127,255}));
  connect(splCooRet.port_3,splCooSup. port_3)
    annotation (Line(points={{190,-170},{210,-170}}, color={0,127,255}));
  connect(pumCooCoi.port_b, splCooRet.port_2)
    annotation (Line(points={{180,-130},{180,-160}}, color={0,127,255}));
  connect(splHeaSup.port_2, pumHeaCoi.port_a)
    annotation (Line(points={{128,-160},{128,-130}}, color={0,127,255}));
  connect(heaCoi.port_b1, splHeaRet.port_2)
    annotation (Line(points={{98,-52},{88,-52},{88,-160}}, color={0,127,255}));
  connect(splHeaRet.port_3, splHeaSup.port_3)
    annotation (Line(points={{98,-170},{118,-170}}, color={0,127,255}));
  connect(splHeaSup.port_1, valHeaCoi.port_b)
    annotation (Line(points={{128,-180},{128,-200}}, color={0,127,255}));
  connect(splCooSup.port_1, valCooCoi.port_b)
    annotation (Line(points={{220,-180},{220,-200}}, color={0,127,255}));
  connect(portHeaCoiSup, valHeaCoi.port_a) annotation (Line(points={{80,-300},{80,
          -262},{128,-262},{128,-220}},    color={0,127,255}));
  connect(portHeaCoiRet, splHeaRet.port_1) annotation (Line(points={{120,-300},
          {120,-240},{88,-240},{88,-180}}, color={0,127,255}));
  connect(portCooCoiSup, valCooCoi.port_a) annotation (Line(points={{200,-300},
          {200,-260},{220,-260},{220,-220}}, color={0,127,255}));
  connect(portCooCoiRet, splCooRet.port_1) annotation (Line(points={{240,-300},
          {240,-240},{180,-240},{180,-180}}, color={0,127,255}));

  connect(VAVBox.port_bAir, port_supAir) annotation (Line(points={{740,60},{740,
          160},{1420,160}}, color={0,127,255}));

  for i in 1:numZon loop
    connect(VAVBox[i].port_aHeaWat, portHeaTerSup)
      annotation (Line(points={{720,40},{638,40},{638,-240},{460,-240},{460,-300}},
      color={0,127,255}));
    connect(VAVBox[i].port_bHeaWat, portHeaTerRet)
      annotation (Line(points={{720,28},{660,28},{660,-262},{496,-262},{496,-280},
            {500,-280},{500,-300}},
      color={0,127,255}));
  end for;

  connect(splSupRoo[1].port_1, senSupFlo.port_b)
    annotation (Line(points={{730,-40},{420,-40}}, color={0,127,255}));
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
          annotation (Line(points={{750,-40},{580,-40},{580,-40},{730,-40}},
    color={0,127,255}));
      connect(splRetRoo[i].port_2, splRetRoo[i+1].port_1)
          annotation (Line(points={{850,100},{854,100},{854,80},{824,80},{824,
            100},{830,100}},
    color={0,127,255}));
  end for;
  connect(splSupRoo[numZon-1].port_2, VAVBox[numZon].port_aAir);
  connect(splRetRoo[numZon-1].port_2, port_retAir[numZon]);

  connect(cooCoi.port_b2, dpSupDuc.port_a)
    annotation (Line(points={{210,-40},{250,-40}}, color={0,127,255}));
  connect(dpSupDuc.port_b, fanSup.port_a)
    annotation (Line(points={{270,-40},{300,-40}}, color={0,127,255}));
  annotation (
  Diagram(
    coordinateSystem(
    preserveAspectRatio=false,
    extent={{-380,-300},{1420,360}})),
    Documentation(info="<html>
<p>
This partial model consist of an HVAC system that serves multiple thermal zones.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the zone inlet branches.
The figure below shows the schematic diagram of an HVAC system that supplies 5 zones:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavSchematics.png\" border=\"1\"/>
</p>
<p>
The control sequences for this HVAC system are added in
the two models that extend this model, namely
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>
and
<a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">
Buildings.Examples.VAVReheat.Guideline36</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 9, 2021, by Baptiste:<br/>
Vectorized the terminal boxes to be expanded to any number of zones.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2735\">issue #2735</a>.
</li>
<li>
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
<li>
September 3, 2021, by Michael Wetter:<br/>
Updated documentation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2600\">issue #2600</a>.
</li>
<li>
August 24, 2021, by Michael Wetter:<br/>
Changed model to include the hydraulic configurations of the cooling coil,
heating coil and VAV terminal box.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2594\">issue #2594</a>.
</li>
<li>
June 30, 2021, by Antoine Gautier:<br/>
Changed cooling coil model. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2549\">issue #2549</a>.
</li>
<li>
May 6, 2021, by David Blum:<br/>
Change to <code>from_dp=false</code> for all mixing box dampers.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2485\">issue #2485</a>.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class and introduced floor areas in base class
to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
April 16, 2021, by Michael Wetter:<br/>
Refactored model to implement the economizer dampers directly in
<code>Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</code> rather than through the
model of a mixing box. Since the version of the Guideline 36 model has no exhaust air damper,
this leads to simpler equations.
<br/> This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2454\">issue #2454</a>.
</li>
<li>
March 11, 2021, by Michael Wetter:<br/>
Set parameter in weather data reader to avoid computation of wet bulb temperature which is need needed for this model.
</li>
<li>
February 03, 2021, by Baptiste Ravache:<br/>
Refactored the sizing of the heating coil in the <code>VAVBranch</code> (renamed <code>VAVReheatBox</code>) class.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2059\">#2024</a>.
</li>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Added design parameters for outdoor air flow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2019\">#2019</a>
</li>
<li>
November 25, 2019, by Milica Grahovac:<br/>
Declared the floor model as replaceable.
</li>
<li>
September 26, 2017, by Michael Wetter:<br/>
Separated physical model from control to facilitate implementation of alternate control
sequences.
</li>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&deg;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
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
end PartialHVAC;
