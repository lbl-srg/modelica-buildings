within Buildings.Experimental.DHC.Plants.Combined;
model AllElectricCWStorage
  "All-electric CHW and HW plant with CW storage"
  extends BaseClasses.PartialPlant(
    final typ=Buildings.Experimental.DHC.Types.DistrictSystemType.CombinedGeneration2to4,
    final have_weaBus=true,
    final have_fan=true,
    final have_pum=true,
    final have_eleHea=true,
    final have_eleCoo=true);

  replaceable package MediumAir=Buildings.Media.Air
    "Air medium";
  replaceable package MediumConWatCoo=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model for cooling tower circuit"
    annotation (choices(
      choice(redeclare package Medium=Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
        property_T=293.15,X_a=0.40)
        "Propylene glycol water, 40% mass fraction")));

  // CHW loop and cooling-only chillers
  parameter Integer nChi(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="CHW loop and cooling-only chillers"),
      Evaluate=true);
  parameter Integer nPumChiWat(final min=1, start=1)=nChi + nChiHea
    "Number of CHW pumps operating at design conditions"
    annotation (Dialog(group="CHW loop and cooling-only chillers"),
      Evaluate=true);
  final parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal(
    final min=0)=datChi.mEva_flow_nominal
    "Chiller CHW design mass flow rate (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_min(
    final min=0)=2.2E-5 * abs(QChiWat_flow_nominal)
    "Chiller CHW minimum mass flow rate (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  final parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal(
    final min=0)=datChi.mCon_flow_nominal
    "Chiller CW design mass flow rate (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpChiWatSet_max(
    final min=0,
    displayUnit="Pa")
    "Design (maximum) CHW differential pressure setpoint"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpEvaChi_nominal(
    final min=0,
    displayUnit="Pa")=5E4
    "Chiller evaporator design pressure drop (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpConChi_nominal(
    final min=0,
    displayUnit="Pa")=5E4
    "Chiller condenser design pressure drop (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpBalEvaChi_nominal(
    final min=0,
    displayUnit="Pa")=0
    "Evaporator-side balancing valve design pressure drop (each valve)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpBalConChi_nominal(
    final min=0,
    displayUnit="Pa")=0
    "Condenser-side balancing valve design pressure drop (each valve)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpPumChiWat_nominal(
    final min=0,
    displayUnit="Pa")=1.1 * (dpChiWatSet_max + max(
    sum({dpEvaChi_nominal, dpBalEvaChi_nominal, chi.dpValveEva_nominal}),
    sum({dpEvaChiHea_nominal, dpBalEvaChiHea_nominal, chiHea.dpValveEva_nominal})))
    "Design head of CHW pump(each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));

  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic datChi
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller parameters (each unit)"
    annotation (
      Dialog(group="CHW loop and cooling-only chillers"),
      Placement(transformation(extent={{80,260},{100,280}})));

  final parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    min(chi.TChiWatSup_nominal, chiHea.TChiWatSup_nominal)
    "Design (minimum) CHW supply temperature"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  final parameter Modelica.Units.SI.HeatFlowRate QChiWat_flow_nominal=
    chi.QChiWat_flow_nominal + chiHea.QChiWatCasCoo_flow_nominal
    "Cooling design heat flow rate (all units)";
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)=
    nChi * mChiWatChi_flow_nominal + nChiHea * mChiWatChiHea_flow_nominal
    "CHW design mass flow rate (all units)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_min=
    max(mChiWatChi_flow_min, mChiWatChiHea_flow_min)
    "Largest chiller minimum CHW mass flow rate"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));

  // HW loop and heat recovery chillers
  parameter Integer nChiHea(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
      Evaluate=true);
  parameter Integer nPumHeaWat(final min=1, start=1) = nChiHea
    "Number of HW pumps operating at design conditions"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
      Evaluate=true);
  parameter Modelica.Units.SI.Temperature TCasEvaEnt_nominal=25 + 273.15
    "Design value of evaporator entering temperature in cascade heating configuration"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.Temperature TCasConEnt_nominal=15 + 273.15
    "Design value of condenser entering temperature in cascade cooling configuration"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWatChiHea_flow_nominal=
    datChiHea.mEva_flow_nominal
    "Chiller CHW design mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChiHea_flow_min(
    final min=0)=1 / 11 / 4186 * abs(chiHea.QChiWatCasCooUni_flow_nominal)
    "Chiller CHW minimum mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mHeaWatChiHea_flow_min(
    final min=0)=1 / 11 / 4186 * abs(chiHea.QHeaWatCasHeaUni_flow_nominal)
    "Chiller HW minimum mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  final parameter Modelica.Units.SI.MassFlowRate mConWatChiHea_flow_nominal=
    datChiHea.mCon_flow_nominal
    "Design chiller CW mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatSet_max(
    final min=0,
    displayUnit="Pa")
    "Design (maximum) HW differential pressure setpoint"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpEvaChiHea_nominal(
    final min=0,
    displayUnit="Pa")=5E4
    "Design chiller evaporator  pressure drop (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpConChiHea_nominal(
    final min=0,
    displayUnit="Pa")=5E4
    "Design chiller condenser pressure drop (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpBalEvaChiHea_nominal(
    final min=0,
    displayUnit="Pa")=0
    "Evaporator-side balancing valve design pressure drop (each valve)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpBalConChiHea_nominal(
    final min=0,
    displayUnit="Pa")=0
    "Condenser-side balancing valve design pressure drop (each valve)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));

  parameter Modelica.Units.SI.PressureDifference dpPumHeaWat_nominal(
    final min=0,
    displayUnit="Pa")=1.1 * (dpHeaWatSet_max +
    sum({dpConChiHea_nominal, dpBalConChiHea_nominal, chiHea.dpValveCon_nominal}))
    "Design head of HW pump(each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));

  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic datChiHea
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller parameters (each unit)"
    annotation (
      Dialog(group="HW loop and heat recovery chillers"),
      Placement(transformation(extent={{120,260},{140,280}})));

  final parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=
    chiHea.THeaWatSup_nominal
    "Design (maximum) HW supply temperature"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWat_flow_nominal=
    chiHea.QHeaWatCasHea_flow_nominal
    "Heating design heat flow rate (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=
    chiHea.mConWat_flow_nominal
    "HW design mass flow rate (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_min=
    mHeaWatChiHea_flow_min
    "Chiller minimum HW mass flow rate"
    annotation (Dialog(group="HW loop and heat recovery chillers"));

  // CW loop, TES tank and heat pumps
  parameter Integer nHeaPum(final min=1, start=1)
    "Number of heat pumps operating at design conditions"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"),
      Evaluate=true);
  parameter Integer nPumConWatCon(final min=1, start=1)
    "Number of CW pumps serving condenser barrels at design conditions"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"),
      Evaluate=true);
  parameter Integer nPumConWatEva(final min=1, start=1)=nChiHea
    "Number of CW pumps serving evaporator barrels at design conditions"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"),
      Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpPumConWatCon_nominal(
    final min=0,
    displayUnit="Pa")=1.1 * max(
    sum({dpConChi_nominal, dpBalConChi_nominal, chi.dpValveCon_nominal}),
    sum({dpConChiHea_nominal, dpBalConChiHea_nominal, chiHea.dpValveCon_nominal}))
    "Design head of CW pump serving condenser barrels (each unit)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.PressureDifference dpPumConWatEva_nominal(
    final min=0,
    displayUnit="Pa")=1.1 *
    sum({dpEvaChiHea_nominal, dpBalEvaChiHea_nominal, chiHea.dpValveEva_nominal})
    "Design head of CW pump serving evaporator barrels (each unit)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  final parameter Modelica.Units.SI.MassFlowRate mConWatCon_flow_nominal(
    final min=0)=chi.mConWat_flow_nominal + chiHea.mConWat_flow_nominal
    "Design total CW mass flow rate through condenser barrels (all units)";
  final parameter Modelica.Units.SI.MassFlowRate mConWatEva_flow_nominal(
    final min=0)=chiHea.mChiWat_flow_nominal
    "Design total CW mass flow rate through evaporator barrels (all units)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal(
    final min=0)=max(mConWatCon_flow_nominal, mConWatEva_flow_nominal)
    "Design total CW mass flow rate"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.Volume VTan=
    QHeaWat_flow_nominal * 2 * 3600 / (max(TTanSet) - min(TTanSet)) / cp_default / rho_default
    "Tank volume"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.Length hTan = (16 * VTan / Modelica.Constants.pi)^(1/3)
    "Height of tank (without insulation)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.Length dInsTan
    "Thickness of insulation"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.ThermalConductivity kInsTan=0.04
    "Specific heat conductivity of insulation"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Integer nSegTan(min=2) = 10
    "Number of volume segments"
    annotation(Dialog(group="CW loop, TES tank and heat pumps", tab="Advanced"));
  parameter Modelica.Units.SI.Temperature TTanSet[3] = {25, 15, 5} + fill(273.15, 3)
    "Tank temperature setpoints: 2 cycles with 1 common setpoint in decreasing order"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  replaceable parameter Fluid.HeatPumps.Data.EquationFitReversible.Generic datHeaPum
    "Heat pump parameters (each unit)"
    annotation (Placement(transformation(extent={{160,260},{180,280}})));

  // Cooling tower loop
  parameter Integer nCoo(final min=1, start=1)
    "Number of cooling tower cells operating at design conditions"
    annotation (Dialog(group="Cooling tower loop"),
      Evaluate=true);
  parameter Modelica.Units.SI.MassFlowRate mConWatCoo_flow_nominal(
    final min=0)=mConWat_flow_nominal / nCoo
    "CT CW design mass flow rate (each unit)"
    annotation(Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.PressureDifference dpConWatCooFri_nominal(
    displayUnit="Pa",
    start=1E4,
    final min=0)
    "CW flow-friction losses through tower and piping only (without elevation head or valve)"
    annotation (Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.MassFlowRate mAirCoo_flow_nominal(
    final min=0,
    start=mConWatCoo_flow_nominal / 1.45)
    "CT design air mass flow rate (each unit)"
    annotation (Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.Temperature TWetBulCooEnt_nominal(
    final min=273.15)
    "CT design entering air wetbulb temperature"
    annotation (Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.Temperature TConWatCooRet_nominal(
    final min=273.15)=TConWatCooSup_nominal +
    abs(QHexCoo_flow_nominal) / mConWat_flow_nominal / cpConWatCoo_default
    "CT CW design return temperature (tower entering)"
    annotation (Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.Temperature TConWatCooSup_nominal(
    final min=273.15)=TWetBulCooEnt_nominal+3
    "CT CW design supply temperature (tower leaving)"
    annotation (Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.Power PFanCoo_nominal(
    final min=0,
    start=340 * mConWatCoo_flow_nominal)
    "CT fan power (each unit)"
    annotation (Dialog(group="Cooling tower loop"));

  parameter Integer nPumConWatCoo(final min=1, start=1)=nCoo
    "Number of CW pumps serving cooling towers at design conditions"
    annotation (Dialog(group="Cooling tower loop"),
      Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpPumConWatCoo_nominal=
    1.1 * (dpHexCoo_nominal + dpConWatCooFri_nominal)
    "Design head of CW pump serving cooling towers (each unit)"
    annotation (Dialog(group="Cooling tower loop"));

  parameter Modelica.Units.SI.TemperatureDifference dTHexCoo_nominal=2
    "Design approach of heat exchanger"
    annotation (Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.PressureDifference dpHexCoo_nominal=3E4
    "Design pressure drop through heat exchanger (same on both sides)"
    annotation (Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.HeatFlowRate QHexCoo_flow_nominal=
    -(chi.QHeaWat_flow_nominal + chiHea.QHeaWatCasCoo_flow_nominal)
    "Design cooling heat flow rate of heat exchanger (<0)"
    annotation (Dialog(group="Cooling tower loop"));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));
  parameter Boolean use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState
    "= true, if control signal is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered signal for actuators and movers"));

  // Outside connectors
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-340,200},{-300,240}}),
        iconTransformation(extent={{-380,160},{-300,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet(
    final unit="Pa",
    final min=0)
    "CHW differential pressure setpoint (for local dp sensor)"
    annotation (Placement(transformation(extent={{-340,140},{-300,180}}),
        iconTransformation(extent={{-380,80},{-300,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K",
    displayUnit="degC")
    "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-340,180},{-300,220}}),
        iconTransformation(extent={{-380,120},{-300,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatSet(
    final unit="Pa",
    final min=0)
    "HW differential pressure setpoint (for local dp sensor)"
    annotation (Placement(transformation(extent={{-340,120},{-300,160}}),
        iconTransformation(extent={{-380,40},{-300,120}})));

  // Components - CHW loop and cooling-only chillers
  Subsystems.ChillerGroup chi(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium,
    final dat=datChi,
    final nUni=nChi,
    final dpEva_nominal=dpEvaChi_nominal,
    final dpCon_nominal=dpConChi_nominal,
    final dpBalEva_nominal=dpBalEvaChi_nominal,
    final dpBalCon_nominal=dpBalConChi_nominal,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal)
    "Cooling-only chillers"
    annotation (Placement(transformation(extent={{-10,76},{10,96}})));
  Subsystems.MultiplePumpsSpeed pumChiWat(
    redeclare final package Medium=Medium,
    final nPum=nPumChiWat,
    final have_var=true,
    final have_valve=true,
    final mPum_flow_nominal=mChiWat_flow_nominal / nPumChiWat,
    final dpPum_nominal=dpPumChiWat_nominal,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final allowFlowReversal=allowFlowReversal)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{110,190},{130,210}})));
  Fluid.FixedResistances.Junction junChiWatSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChiWat_flow_nominal * {1, -1, -1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal
      then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal
      then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal
      then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={180,200})));
  Fluid.FixedResistances.Junction junChiWatRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChiWat_flow_nominal * {1, -1, 1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal
      then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal
      then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal
      then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
       else Modelica.Fluid.Types.PortFlowDirection.Entering)
   "Fluid junction"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={180,80})));
  Fluid.FixedResistances.Junction junChiWatChiHeaRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChiWat_flow_nominal * {1,-1,-1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Fluid junction"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={60,80})));
  Fluid.FixedResistances.Junction junChiWatChiHeaSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChiWat_flow_nominal*{1,-1,1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering) "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,200})));
  // PICV model sized at design flow (instead of minimum flow) for convenience.
  Fluid.Actuators.Valves.TwoWayPressureIndependent valChiWatMinByp(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    final dpValve_nominal=dpEvaChi_nominal,
    final use_inputFilter=use_inputFilter,
    final allowFlowReversal=allowFlowReversal)
    "CHW minimum flow bypass valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={180,140})));
  Fluid.Sensors.RelativePressure dpChiWat(
    redeclare final package Medium=Medium)
    "CHW differential pressure (local sensor hardwired to plant controller)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,140})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriRet(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal) "Primary CHW return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={150,80})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow(
    redeclare final package Medium =Medium,
    final allowFlowReversal=allowFlowReversal)
    "Primary CHW mass flow rate"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={120,80})));
  Fluid.Sensors.TemperatureTwoPort TChiWatSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "CHW supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,200})));

  // Components - HW loop and heat recovery chillers
  Subsystems.ChillerHeatRecoveryGroup chiHea(
    redeclare final package Medium = Medium,
    final dat=datChiHea,
    final nUni=nChiHea,
    final dpEva_nominal=dpEvaChiHea_nominal,
    final dpCon_nominal=dpConChiHea_nominal,
    final dpBalEva_nominal=dpBalEvaChiHea_nominal,
    final dpBalCon_nominal=dpBalConChiHea_nominal,
    final allowFlowReversal=allowFlowReversal,
    final use_inputFilter=use_inputFilter,
    final energyDynamics=energyDynamics)
    "Heat recovery chillers"
    annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));
  Subsystems.MultiplePumpsSpeed pumHeaWat(
    redeclare final package Medium=Medium,
    final nPum=nPumHeaWat,
    final have_var=true,
    final have_valve=true,
    final mPum_flow_nominal=mHeaWat_flow_nominal/nPumHeaWat,
    final dpPum_nominal=dpPumHeaWat_nominal,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final allowFlowReversal=allowFlowReversal)
    "Primary HW pumps"
    annotation (Placement(transformation(extent={{110,-90},{130,-70}})));
  Fluid.FixedResistances.Junction junHeaWatSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal * {1,-1,-1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={180,-80})));
  Fluid.FixedResistances.Junction junHeaWatRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal * {1,-1,1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
       else Modelica.Fluid.Types.PortFlowDirection.Entering) "Fluid junction"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={180,-200})));
  // PICV model sized at design flow (instead of minimum flow) for convenience.
  Fluid.Actuators.Valves.TwoWayPressureIndependent valHeaWatMinByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final dpValve_nominal=dpConChiHea_nominal,
    final use_inputFilter=use_inputFilter,
    final allowFlowReversal=allowFlowReversal) "HW minimum flow bypass valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={180,-140})));
  Fluid.Sensors.RelativePressure dpHeaWat(
    redeclare final package Medium =Medium)
    "HW differential pressure (local sensor hardwired to plant controller)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,-140})));
  Fluid.Sensors.TemperatureTwoPort THeaWatPriRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "Primary HW return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={150,-200})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "HW supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-80})));
  Fluid.Sensors.MassFlowRate mHeaWatPri_flow(
    redeclare final package Medium =Medium,
    final allowFlowReversal=allowFlowReversal)
    "Primary HW mass flow rate" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={120,-200})));

  // Components - CW loop and heat pumps
  Subsystems.MultiplePumpsSpeed pumConWatCon(
    redeclare final package Medium = Medium,
    final nPum=nPumConWatCon,
    final have_var=true,
    final have_valve=true,
    final mPum_flow_nominal=mConWatCon_flow_nominal / nPumConWatCon,
    final dpPum_nominal=dpPumConWatCon_nominal,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps serving condenser barrels"
    annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));
  Subsystems.MultiplePumpsSpeed pumConWatEva(
    redeclare final package Medium = Medium,
    final nPum=nPumConWatEva,
    final have_var=true,
    final have_valve=true,
    final mPum_flow_nominal=mConWatEva_flow_nominal / nPumConWatEva,
    final dpPum_nominal=dpPumConWatEva_nominal,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps serving evaporator barrels"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Fluid.FixedResistances.Junction junConWatEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal*{1,-1,-1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-40,-200})));
  Fluid.Storage.Stratified tan(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWat_flow_nominal,
    final VTan=VTan,
    final hTan=hTan,
    final dIns=dInsTan,
    final kIns=kInsTan,
    final nSeg=nSegTan)
    "TES tank"
    annotation (Placement(transformation(extent={{-150,-130},{-130,-110}})));
  Fluid.Sources.Boundary_pT bouConWat(
    redeclare final package Medium = Medium,
    final p=hTan * rho_default * Modelica.Constants.g_n,
    final nPorts=1)
    "CW boundary pressure condition prescribed by tank operating level"
    annotation (Placement(transformation(extent={{-80,-130},{-100,-110}})));
  Fluid.FixedResistances.Junction junConWatTanEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWat_flow_nominal*{1,-1,-1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Bidirectional)
    "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-180,-20})));
  Fluid.FixedResistances.Junction junConWatLvg(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal*{1,-1,1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering) "Fluid junction"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={20,40})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TTan[nSegTan](
    T(each displayUnit="degC"))
    "TES tank temperature sensor gateway"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-100,-80})));
  HeatTransfer.Sources.PrescribedTemperature out "Outdoor temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-126,-80})));
  Fluid.FixedResistances.Junction junConWatHeaPumEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWat_flow_nominal*{1,-1,-1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-100,40})));
  Fluid.FixedResistances.Junction junConWatHeaPumLvg(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWat_flow_nominal*{1,-1,1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Fluid junction" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-160,40})));
  Subsystems.HeatPumpGroup heaPum(
    redeclare final package Medium = Medium,
    redeclare final package MediumAir = MediumAir,
    final nUni=nHeaPum,
    final dat=datHeaPum,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final allowFlowReversal=allowFlowReversal)
    "Heat pumps"
    annotation (Placement(transformation(extent={{-130,100},{-150,120}})));
  Fluid.FixedResistances.Junction junConWatTanLvg(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal*{1,-1,1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering) "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-120,-160})));
  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hexCoo(
    redeclare final package Medium1=MediumConWatCoo,
    redeclare final package Medium2=Medium,
    final m1_flow_nominal=mConWat_flow_nominal,
    final m2_flow_nominal=mConWat_flow_nominal,
    final dp1_nominal=dpHexCoo_nominal,
    final dp2_nominal=dpHexCoo_nominal,
    final Q_flow_nominal=QHexCoo_flow_nominal,
    final T_a1_nominal=TConWatCooSup_nominal,
    final T_a2_nominal=TConWatCooRet_nominal + dTHexCoo_nominal +
      TConWatCooRet_nominal - TConWatCooSup_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal,
    final configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow)
    "Heat exchanger with cooling tower circuit"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-206,-110})));
  Subsystems.CoolingTowerGroup coo(
    redeclare final package Medium=Medium,
    final nUni=nCoo,
    final mConWatUni_flow_nominal=mConWatCoo_flow_nominal,
    final dpConWatFriUni_nominal=dpConWatCooFri_nominal,
    final mAirUni_flow_nominal=mAirCoo_flow_nominal,
    final TWetBulEnt_nominal=TWetBulCooEnt_nominal,
    final TConWatRet_nominal=TConWatCooRet_nominal,
    final TConWatSup_nominal=TConWatCooSup_nominal,
    final PFanUni_nominal=PFanCoo_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Cooling towers"
    annotation (Placement(transformation(extent={{-230,-10},{-250,10}})));
  Fluid.Actuators.Valves.ThreeWayLinear valBypTan(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    dpValve_nominal=1E3)
    "FIXME (TES tank bypass valve"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-180,-80})));
  Fluid.Sources.Boundary_pT bouConWatCoo(
    redeclare final package Medium = Medium,
    final p=130000,
    nPorts=1)
    "CW boundary pressure condition prescribed by CT elevation head"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-260,-180})));
  Subsystems.MultiplePumpsSpeed pumConWatCoo(
    redeclare final package Medium = Medium,
    final nPum=nPumConWatCoo,
    final have_var=false,
    final have_valve=true,
    final mPum_flow_nominal=mConWatCoo_flow_nominal  * nCoo / nPumConWatCoo,
    final dpPum_nominal=dpPumConWatCoo_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps serving cooling towers"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-240,-140})));
  Fluid.Sensors.TemperatureTwoPort TConWatEvaEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatEva_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "CW evaporator entering temperature" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, rotation=-90,
        origin={20,-50})));

  // Controls
  Buildings.Experimental.DHC.Plants.Combined.Controls.Controller ctl(
    final nChi=nChi,
    final nPumChiWat=nPumChiWat,
    final nChiHea=nChiHea,
    final nPumHeaWat=nPumHeaWat,
    final nHeaPum=nHeaPum,
    final nPumConWatCon=nPumConWatCon,
    final nPumConWatEva=nPumConWatEva,
    final TTanSet=TTanSet,
    final nCoo=nCoo,
    final nPumConWatCoo=nPumConWatCoo,
    final THeaWatSup_nominal=THeaWatSup_nominal,
    final TChiWatSup_nominal=TChiWatSup_nominal,
    final mPumChiWatUni_flow_nominal=pumChiWat.mPum_flow_nominal)
    "Controller"
    annotation (Placement(transformation(extent={{-280,140},{-240,200}})));

  // Miscellaneous
  Modelica.Blocks.Sources.RealExpression sumPHea(y=chiHea.P + heaPum.P)
    "FIXME: Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{270,270},{290,290}})));
  Modelica.Blocks.Sources.RealExpression sumPCoo(y=chi.P + chiHea.P)
    "FIXME: Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{270,230},{290,250}})));
  Modelica.Blocks.Sources.RealExpression sumPFan(y=coo.P)
    "Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{270,190},{290,210}})));
  Modelica.Blocks.Sources.RealExpression sumPPum(
    final y=pumChiWat.P + pumHeaWat.P + pumConWatCon.P + pumConWatEva.P + heaPum.PPum)
    "Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{270,150},{290,170}})));

  Modelica.Blocks.Sources.RealExpression ctlYPumConWatCon(
    final y=ctl.yPumConWatCon)
    "Equation block avoiding graphical connection"
    annotation (Placement(transformation(extent={{-110,-222},{-90,-202}})));
  Modelica.Blocks.Sources.BooleanExpression ctlY1PumConWatCon[nPumConWatCon](
    final y=ctl.y1PumConWatCon)
    "Equation block avoiding graphical connection"
    annotation (Placement(transformation(extent={{-110,-202},{-90,-182}})));

  Fluid.FixedResistances.Junction junConWatChiByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal*{1,-1,-1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-40,0})));
  Fluid.Actuators.Valves.TwoWayLinear     valConWatChiByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal,
    from_dp=true,
    linearized=true,
    final dpValve_nominal=1E3,
    final use_inputFilter=use_inputFilter,
    final allowFlowReversal=allowFlowReversal)
    "CW chiller bypass valve (butterfly valve characteristic)" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-60,20})));
  Fluid.FixedResistances.Junction junConWatChiByp1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWat_flow_nominal*{1,-1,1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
                                                              "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-60,48})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-340,260},{-300,300}}),
        iconTransformation(extent={{-380,240},{-300,320}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea
    "Heating enable signal"
    annotation (Placement(transformation(extent={{-340,240},{-300,280}}),
        iconTransformation(extent={{-380,200},{-300,280}})));
protected
  final parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default)
    "Medium state at default properties";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";
  final parameter Modelica.Units.SI.Density rho_default=
    Medium.density(sta_default)
    "Density of the fluid";
  final parameter MediumConWatCoo.ThermodynamicState staConWatCoo_default=
    MediumConWatCoo.setState_pTX(
    T=MediumConWatCoo.T_default,
    p=MediumConWatCoo.p_default,
    X=MediumConWatCoo.X_default)
    "Medium state at default properties";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpConWatCoo_default=
    MediumConWatCoo.specificHeatCapacityCp(staConWatCoo_default)
    "Specific heat capacity of the fluid";
equation
  connect(junChiWatSup.port_2, port_bSerCoo)
    annotation (Line(points={{190,200},{260,200},{260,-40},{300,-40}},
                                                   color={0,127,255}));
  connect(junChiWatSup.port_3, valChiWatMinByp.port_a)
    annotation (Line(points={{180,190},{180,150}}, color={0,127,255}));
  connect(valChiWatMinByp.port_b, junChiWatRet.port_3)
    annotation (Line(points={{180,130},{180,90}}, color={0,127,255}));
  connect(junChiWatSup.port_2, dpChiWat.port_a) annotation (Line(points={{190,200},
          {240,200},{240,150}}, color={0,127,255}));
  connect(TChiWatPriRet.port_a, junChiWatRet.port_2)
    annotation (Line(points={{160,80},{170,80}}, color={0,127,255}));
  connect(port_aSerCoo, junChiWatRet.port_1) annotation (Line(points={{-300,-40},
          {-280,-40},{-280,60},{240,60},{240,80},{190,80}},
                                        color={0,127,255}));
  connect(dpChiWat.port_b, junChiWatRet.port_1)
    annotation (Line(points={{240,130},{240,80},{190,80}}, color={0,127,255}));
  connect(junHeaWatSup.port_3, valHeaWatMinByp.port_a)
    annotation (Line(points={{180,-90},{180,-130}}, color={0,127,255}));
  connect(valHeaWatMinByp.port_b, junHeaWatRet.port_3)
    annotation (Line(points={{180,-150},{180,-190}}, color={0,127,255}));
  connect(THeaWatPriRet.port_a, junHeaWatRet.port_2)
    annotation (Line(points={{160,-200},{170,-200}}, color={0,127,255}));
  connect(dpHeaWat.port_b, junHeaWatRet.port_1) annotation (Line(points={{240,-150},
          {240,-200},{190,-200}}, color={0,127,255}));
  connect(junHeaWatSup.port_2, port_bSerHea) annotation (Line(points={{190,-80},
          {280,-80},{280,0},{300,0}}, color={0,127,255}));
  connect(ctl.y1Chi, chi.y1) annotation (Line(points={{-238.182,199},{-32,199},
          {-32,95},{-12,95}},  color={255,0,255}));
  connect(ctl.yValConChi, chi.yValCon) annotation (Line(points={{-238.182,195},
          {-30,195},{-30,100},{-6,100},{-6,98}},     color={0,0,127}));
  connect(TChiWatSupSet, chi.TSet) annotation (Line(points={{-320,220},{-34,220},
          {-34,77},{-12,77}},   color={0,0,127}));
  connect(ctl.y1PumChiWat, pumChiWat.y1) annotation (Line(points={{-238.182,193},
          {100,193},{100,208},{108,208}},
                                    color={255,0,255}));
  connect(ctl.y1PumHeaWat, pumHeaWat.y1) annotation (Line(points={{-238.182,172},
          {100,172},{100,-72},{108,-72}},
                                    color={255,0,255}));
  connect(ctl.yValChiWatMinByp, valChiWatMinByp.y) annotation (Line(points={{
          -238.182,189},{-20,189},{-20,160},{200,160},{200,140},{192,140}},
                                                 color={0,0,127}));
  connect(ctl.yValHeaWatMinByp, valHeaWatMinByp.y) annotation (Line(points={{
          -238.182,167},{-198,167},{-198,-60},{200,-60},{200,-140},{192,-140}},
                                                   color={0,0,127}));
  connect(THeaWatPriRet.port_b, mHeaWatPri_flow.port_a)
    annotation (Line(points={{140,-200},{130,-200}}, color={0,127,255}));
  connect(TChiWatPriRet.port_b, mChiWatPri_flow.port_a)
    annotation (Line(points={{140,80},{130,80}}, color={0,127,255}));
  connect(ctl.y1PumConWatEva, pumConWatEva.y1) annotation (Line(points={{
          -238.182,160.2},{-86,160.2},{-86,-12},{-82,-12}},
                                               color={255,0,255}));
  connect(ctl.yPumConWatEva, pumConWatEva.y) annotation (Line(points={{-238.182,
          158.2},{-88,158.2},{-88,-16},{-82,-16}},
                                               color={0,0,127}));
  connect(sumPHea.y, PHea)
    annotation (Line(points={{291,280},{320,280}}, color={0,0,127}));
  connect(sumPCoo.y, PCoo) annotation (Line(points={{291,240},{298.5,240},{
          298.5,240},{320,240}}, color={0,0,127}));
  connect(sumPFan.y, PFan)
    annotation (Line(points={{291,200},{320,200}}, color={0,0,127}));
  connect(sumPPum.y, PPum) annotation (Line(points={{291,160},{300,160},{300,
          160},{320,160}}, color={0,0,127}));
  connect(junHeaWatSup.port_2, dpHeaWat.port_a) annotation (Line(points={{190,-80},
          {240,-80},{240,-130}}, color={0,127,255}));
  connect(pumConWatCon.port_b, junConWatEnt.port_1)
    annotation (Line(points={{-60,-200},{-50,-200}},   color={0,127,255}));
  connect(pumChiWat.port_b, TChiWatSup.port_a)
    annotation (Line(points={{130,200},{140,200}}, color={0,127,255}));
  connect(TChiWatSup.port_b, junChiWatSup.port_1)
    annotation (Line(points={{160,200},{170,200}}, color={0,127,255}));
  connect(junConWatTanEnt.port_3, pumConWatEva.port_a)
    annotation (Line(points={{-170,-20},{-80,-20}},color={0,127,255}));
  connect(tan.heaPorVol, TTan.port)
    annotation (Line(points={{-140,-120},{-140,-96},{-100,-96},{-100,-90}},
                                                      color={191,0,0}));
  connect(out.port, tan.heaPorTop) annotation (Line(points={{-126,-90},{-126,
          -100},{-138,-100},{-138,-112.6}},
                         color={191,0,0}));
  connect(out.port, tan.heaPorSid) annotation (Line(points={{-126,-90},{-126,
          -100},{-134.4,-100},{-134.4,-120}},
                          color={191,0,0}));
  connect(out.port, tan.heaPorBot) annotation (Line(points={{-126,-90},{-126,
          -127.4},{-138,-127.4}},       color={191,0,0}));
  connect(pumHeaWat.port_b, THeaWatSup.port_a)
    annotation (Line(points={{130,-80},{140,-80}}, color={0,127,255}));
  connect(THeaWatSup.port_b, junHeaWatSup.port_1)
    annotation (Line(points={{160,-80},{170,-80}}, color={0,127,255}));
  connect(junConWatHeaPumEnt.port_2, junConWatHeaPumLvg.port_1)
    annotation (Line(points={{-110,40},{-150,40}}, color={0,127,255}));
  connect(junConWatHeaPumLvg.port_2, junConWatTanEnt.port_1) annotation (Line(
        points={{-170,40},{-180,40},{-180,-10}}, color={0,127,255}));
  connect(junConWatHeaPumEnt.port_3, heaPum.port_a) annotation (Line(points={{-100,50},
          {-100,110},{-130,110}},     color={0,127,255}));
  connect(heaPum.port_b, junConWatHeaPumLvg.port_3) annotation (Line(points={{-150,
          110},{-160,110},{-160,50}}, color={0,127,255}));
  connect(weaBus.TDryBul, out.T) annotation (Line(
      points={{1,266},{1,239.545},{-126,239.545},{-126,-68}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, heaPum.weaBus) annotation (Line(
      points={{1,266},{1,260},{-140,260},{-140,120}},
      color={255,204,51},
      thickness=0.5));
  connect(ctl.y1HeaPum, heaPum.y1) annotation (Line(points={{-238.182,155.2},{
          -102,155.2},{-102,116},{-128,116}},
                                       color={255,0,255}));
  connect(ctl.THeaPumSet, heaPum.TSet) annotation (Line(points={{-238.182,153.2},
          {-104,153.2},{-104,104},{-128,104}},
                                            color={0,0,127}));
  connect(bouConWat.ports[1], tan.port_b)
    annotation (Line(points={{-100,-120},{-130,-120}}, color={0,127,255}));
  connect(ctl.yPumChiWat, pumChiWat.y) annotation (Line(points={{-238.182,191},
          {98,191},{98,204},{108,204}},color={0,0,127}));
  connect(ctl.yPumHeaWat, pumHeaWat.y) annotation (Line(points={{-238.182,170},
          {98,170},{98,-76},{108,-76}},color={0,0,127}));
  connect(tan.port_b, junConWatTanLvg.port_1) annotation (Line(points={{-130,
          -120},{-120,-120},{-120,-150}},
                                    color={0,127,255}));
  connect(junConWatTanLvg.port_2, pumConWatCon.port_a) annotation (Line(points={{-120,
          -170},{-120,-200},{-80,-200}},        color={0,127,255}));
  connect(mChiWatPri_flow.port_b,junChiWatChiHeaRet. port_1)
    annotation (Line(points={{110,80},{70,80}},          color={0,127,255}));
  connect(junChiWatChiHeaRet.port_2, chi.port_a2)
    annotation (Line(points={{50,80},{10,80}},            color={0,127,255}));
  connect(port_aSerHea, junHeaWatRet.port_1) annotation (Line(points={{-300,0},
          {-290,0},{-290,-220},{240,-220},{240,-200},{190,-200}},color={0,127,255}));
  connect(junConWatTanEnt.port_2, valBypTan.port_2)
    annotation (Line(points={{-180,-30},{-180,-70}}, color={0,127,255}));
  connect(valBypTan.port_1, tan.port_a) annotation (Line(points={{-180,-90},{
          -180,-120},{-150,-120}},
                              color={0,127,255}));
  connect(valBypTan.port_3, hexCoo.port_a2) annotation (Line(points={{-190,-80},
          {-200,-80},{-200,-100}},color={0,127,255}));
  connect(hexCoo.port_b2, junConWatTanLvg.port_1) annotation (Line(points={{-200,
          -120},{-200,-140},{-120,-140},{-120,-150}},      color={0,127,255}));
  connect(ctl.yValBypTan, valBypTan.y) annotation (Line(points={{-238.182,141},
          {-238.182,141},{-200,141},{-200,-66},{-160,-66},{-160,-80},{-168,-80}},
                                            color={0,0,127}));
  connect(bouConWatCoo.ports[1], pumConWatCoo.port_a)
    annotation (Line(points={{-260,-170},{-260,-140},{-250,-140}},
                                                       color={0,127,255}));
  connect(pumConWatCoo.port_b, hexCoo.port_a1) annotation (Line(points={{-230,
          -140},{-212,-140},{-212,-120}}, color={0,127,255}));
  connect(hexCoo.port_b1, coo.port_a) annotation (Line(points={{-212,-100},{
          -212,0},{-230,0}},
                        color={0,127,255}));
  connect(coo.port_b, pumConWatCoo.port_a) annotation (Line(points={{-250,0},{
          -272,0},{-272,-140},{-250,-140}}, color={0,127,255}));
  connect(weaBus, coo.weaBus) annotation (Line(
      points={{1,266},{1,260},{-140,260},{-140,120},{-240,120},{-240,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ctl.yCoo, coo.y) annotation (Line(points={{-238.182,145.2},{-222,
          145.2},{-222,-6},{-228,-6}},          color={0,0,127}));
  connect(ctl.y1Coo, coo.y1) annotation (Line(points={{-238.182,147.2},{-224,
          147.2},{-224,6},{-228,6}},
                              color={255,0,255}));
  connect(ctl.y1PumConWatCoo, pumConWatCoo.y1) annotation (Line(points={{
          -238.182,143.2},{-230,143.2},{-230,128},{-260,128},{-260,-132},{-252,
          -132}},
        color={255,0,255}));
  connect(ctlY1PumConWatCon.y, pumConWatCon.y1)
    annotation (Line(points={{-89,-192},{-82,-192}},   color={255,0,255}));
  connect(ctlYPumConWatCon.y, pumConWatCon.y) annotation (Line(points={{-89,
          -212},{-86,-212},{-86,-196},{-82,-196}},    color={0,0,127}));
  connect(chi.port_b1, junConWatLvg.port_3)
    annotation (Line(points={{10,92},{20,92},{20,50}},   color={0,127,255}));
  connect(chiHea.port_b1, pumHeaWat.port_a)
    annotation (Line(points={{10,-80},{110,-80}}, color={0,127,255}));
  connect(chiHea.port_b2, junConWatTanLvg.port_3) annotation (Line(points={{-10,-85},
          {-60,-85},{-60,-160},{-110,-160}},   color={0,127,255}));
  connect(mHeaWatPri_flow.port_b, chiHea.port_a1) annotation (Line(points={{110,
          -200},{-14,-200},{-14,-80},{-10,-80}},
                                               color={0,127,255}));
  connect(junChiWatChiHeaRet.port_3, chiHea.port_a4) annotation (Line(points={{60,70},
          {60,-96},{10,-96}},               color={0,127,255}));
  connect(junConWatEnt.port_2, chiHea.port_a3) annotation (Line(points={{-30,
          -200},{-20,-200},{-20,-90},{-10,-90},{-10,-91.2}},
                                             color={0,127,255}));
  connect(chiHea.port_b3, junConWatLvg.port_1) annotation (Line(points={{10,
          -91.1},{40,-91.1},{40,40},{30,40}},
                                       color={0,127,255}));
  connect(ctl.yValEvaChiHea, chiHea.yValEva) annotation (Line(points={{-238.182,
          177},{-32,177},{-32,-102},{-6.2,-102},{-6.2,-100}},
                                                            color={0,0,127}));
  connect(ctl.y1CooChiHea, chiHea.y1Coo) annotation (Line(points={{-238.182,184},
          {-24,184},{-24,-86},{-12,-86},{-12,-87}},
                                                  color={255,0,255}));
  connect(ctl.y1ChiHea, chiHea.y1) annotation (Line(points={{-238.182,186},{-22,
          186},{-22,-82},{-12,-82}},  color={255,0,255}));
  connect(ctl.y1HeaCooChiHea, chiHea.y1HeaCoo) annotation (Line(points={{
          -238.182,182},{-238.182,182},{-26,182},{-26,-88},{-12,-88},{-12,-89}},
        color={255,0,255}));
  connect(ctl.yValConChiHea, chiHea.yValCon) annotation (Line(points={{-238.182,
          175},{-28,175},{-28,-72},{-6,-72},{-6,-76}}, color={0,0,127}));
  connect(ctl.TChiHeaSet, chiHea.TSet) annotation (Line(points={{-238.182,180},
          {-238.182,180},{-30,180},{-30,-94},{-12,-94}},      color={0,0,127}));
  connect(ctl.yValEvaChi, chi.yValEva) annotation (Line(points={{-238.182,197},
          {-28,197},{-28,72},{-5.8,72},{-5.8,74}},    color={0,0,127}));
  connect(junChiWatChiHeaSup.port_2, pumChiWat.port_a)
    annotation (Line(points={{90,200},{110,200}}, color={0,127,255}));
  connect(chi.port_b2, junChiWatChiHeaSup.port_1) annotation (Line(points={{-10,80},
          {-16,80},{-16,200},{70,200}},     color={0,127,255}));
  connect(chiHea.port_b4, junChiWatChiHeaSup.port_3) annotation (Line(points={{-10,
          -96.5},{-10,-110},{80,-110},{80,190}},             color={0,127,255}));
  connect(pumConWatEva.port_b, TConWatEvaEnt.port_a)
    annotation (Line(points={{-60,-20},{20,-20},{20,-40}},
                                               color={0,127,255}));
  connect(TConWatEvaEnt.port_b, chiHea.port_a2) annotation (Line(points={{20,-60},
          {20,-85},{10,-85}},        color={0,127,255}));
  connect(TChiWatSupSet, ctl.TChiWatSupSet) annotation (Line(points={{-320,220},
          {-288,220},{-288,192},{-281.818,192}}, color={0,0,127}));
  connect(dpChiWatSet, ctl.dpChiWatSet) annotation (Line(points={{-320,160},{
          -292,160},{-292,185},{-281.818,185}}, color={0,0,127}));
  connect(THeaWatSupSet, ctl.THeaWatSupSet) annotation (Line(points={{-320,200},
          {-292,200},{-292,189},{-281.818,189}}, color={0,0,127}));
  connect(dpHeaWatSet, ctl.dpHeaWatSet) annotation (Line(points={{-320,140},{
          -288,140},{-288,182},{-281.818,182}}, color={0,0,127}));
  connect(junConWatEnt.port_3, junConWatChiByp.port_1)
    annotation (Line(points={{-40,-190},{-40,-10}}, color={0,127,255}));
  connect(junConWatChiByp.port_2, chi.port_a1)
    annotation (Line(points={{-40,10},{-40,92},{-10,92}}, color={0,127,255}));
  connect(junConWatChiByp.port_3, valConWatChiByp.port_a)
    annotation (Line(points={{-50,0},{-60,0},{-60,10}}, color={0,127,255}));
  connect(ctl.yValConWatChiByp, valConWatChiByp.y) annotation (Line(points={{
          -238.182,150},{-80,150},{-80,20},{-72,20}}, color={0,0,127}));
  connect(valConWatChiByp.port_b, junConWatChiByp1.port_3)
    annotation (Line(points={{-60,30},{-60,38}}, color={0,127,255}));
  connect(junConWatHeaPumEnt.port_1, junConWatChiByp1.port_2) annotation (Line(
        points={{-90,40},{-80,40},{-80,48},{-70,48}}, color={0,127,255}));
  connect(junConWatChiByp1.port_1, junConWatLvg.port_2) annotation (Line(points
        ={{-50,48},{-22,48},{-22,40},{10,40}}, color={0,127,255}));
  connect(u1Coo, ctl.u1Coo) annotation (Line(points={{-320,280},{-284,280},{
          -284,199},{-281.818,199}}, color={255,0,255}));
  connect(u1Hea, ctl.u1Hea) annotation (Line(points={{-320,260},{-286,260},{
          -286,196},{-281.818,196}}, color={255,0,255}));
  connect(mChiWatPri_flow.m_flow, ctl.mChiWatPri_flow) annotation (Line(points={{120,91},
          {120,132},{-286,132},{-286,175},{-281.818,175}},          color={0,0,127}));
  connect(pumChiWat.y1_actual, ctl.y1PumChiWat_actual) annotation (Line(points={{132,208},
          {140,208},{140,224},{-296,224},{-296,178},{-281.818,178}},
        color={255,0,255}));
annotation (
  defaultComponentName="pla", Documentation(info="<html>
<p>
Credit \"Discussions with Taylor Engineers\" (Gill, 2021).
</p>
<p>
Tank assumed to be without pressure separation, i.e.,
the operating level of the tank sets the system pressure.
The operating level is approximated as equal to the tank height.
</p>

<h4>Sizing</h4>
<p>
Tank sized to store <i>2</i> hours of peak heating load with
a &Delta;T of <i>20</i>&nbsp;°C (heels and thermocline neglected).
A default height to diameter ratio of <i>2</i> is also taken into
account
(designers tend to favor a height to diameter ratio above <i>1.5</i>
in order to minimize the volume of the thermocline which is
considered useless).
</p>

<h4>Details</h4>
<h5>Minimum flow bypass valve</h5>
<p>
As per standard practice, the bypass valve (and pipe)
should be sized for the highest chiller minimum flow.
However, the minimum flow is driven by the chiller capacity
in the cascade configuration.
This capacity is evaluted at initialization so the nominal
attribute of the valve mass flow rate and pressure drop
are unknown at compile time, which yields some warnings.
To avoid that behavior, the valve is sized at design flow
and a pressure-independant valve (PICV) model is used.
Using a PICV model also avoids tuning an additional PI
controller.
Note that, while not required, some consulting engineers
specify a pressure independent valve for bypass.
</p>



<h4>References</h4>
<p>
<a name=\"Gill2021\"/>
Brandon Gill, P.E., principal of Taylor Engineers in Alameda, Calif.<br/>
<a href=\"https://tayloreng.egnyte.com/dl/hHl2ZkZRDC/ASHRAE_Journal_-_Solving_the_Large_Building_All-Electric_Heating_Problem.pdf_\">
Solving the large building all-electric heating problem</a>.<br/>
ASHRAE Journal, October 2021.
</p>

</html>"));
end AllElectricCWStorage;
