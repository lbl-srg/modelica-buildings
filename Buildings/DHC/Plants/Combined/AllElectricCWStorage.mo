within Buildings.DHC.Plants.Combined;
model AllElectricCWStorage
  "All-electric CHW and HW plant with CW storage"
  extends BaseClasses.PartialPlant(
    final typ=Buildings.DHC.Types.DistrictSystemType.CombinedGeneration2to4,
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
  parameter Integer nPumChiWat(final min=1, start=1)=max(nChi, nChiHea)
    "Number of CHW pumps operating at design conditions"
    annotation (Dialog(group="CHW loop and cooling-only chillers"),
      Evaluate=true);
  final parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal(
    final min=0)=datChi.mEva_flow_nominal
    "Design chiller CHW mass flow rate (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_min(
    final min=0)=0.6 * mChiWatChi_flow_nominal
    "Chiller CHW minimum mass flow rate (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  final parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal(
    final min=0)=datChi.mCon_flow_nominal
    "Design chiller CW mass flow rate (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpChiWatSet_max(
    final min=0,
    displayUnit="Pa")
    "Design (maximum) CHW differential pressure setpoint"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpEvaChi_nominal(
    final min=0,
    displayUnit="Pa")=5E4
    "Design evaporator pressure drop (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpConChi_nominal(
    final min=0,
    displayUnit="Pa")=5E4
    "Design condenser pressure drop (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpPumChiWat_nominal(
    final min=0,
    displayUnit="Pa")=1.1 * (dpChiWatSet_max + max(
      dpEvaChi_nominal + chi.valEva.dpValve_nominal,
      dpEvaChiHea_nominal + max(chiHea.valEva.dpValve_nominal) + sum(chiHea.valEvaSwi.dpValve_nominal)))
    "Design head of CHW pump(each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));

  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic datChi
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller parameters (each unit)"
    annotation (
      Dialog(group="CHW loop and cooling-only chillers"),
      Placement(transformation(extent={{80,340},{100,360}})));

  final parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    max(chi.TChiWatSup_nominal, chiHea.TChiWatSup_nominal)
    "Design (minimum) CHW supply temperature"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  final parameter Modelica.Units.SI.Temperature TChiWatRet_nominal=
    TChiWatSup_nominal - QChiWat_flow_nominal / mChiWat_flow_nominal / cp_default
    "Design (maximum) CHW return temperature"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  // Plant capacity computed with HRCs in direct heat recovery mode, see
  // Buildings.DHC.Plants.Combined.Controls.BaseClasses.StagingPlant.
  final parameter Modelica.Units.SI.HeatFlowRate QChiWat_flow_nominal=
    chi.QChiWat_flow_nominal + chiHea.QChiWat_flow_nominal
    "Design plant cooling heat flow rate (all units)";
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)=
    nChi * mChiWatChi_flow_nominal + nChiHea * mChiWatChiHea_flow_nominal
    "Design CHW mass flow rate (all units)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));

  parameter Modelica.Units.SI.TemperatureDifference dTLifChi_min=10
    "Minimum chiller lift at minimum load"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.TemperatureDifference dTLifChi_nominal=
    TTanSet[1, 2] + 5 - TChiWatSup_nominal
    "Design chiller lift"
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
  final parameter Modelica.Units.SI.MassFlowRate mChiWatChiHea_flow_nominal=
    datChiHea.mEva_flow_nominal
    "Design HRC CHW mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChiHea_flow_min(
    final min=0)=0.6 * mChiWatChiHea_flow_nominal
    "HRC CHW minimum mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mHeaWatChiHea_flow_min(
    final min=0)=0.6 * mConWatChiHea_flow_nominal
    "HRC HW minimum mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  final parameter Modelica.Units.SI.MassFlowRate mConWatChiHea_flow_nominal=
    datChiHea.mCon_flow_nominal
    "Design HRC CW mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatSet_max(
    final min=0,
    displayUnit="Pa")
    "Design (maximum) HW differential pressure setpoint"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpEvaChiHea_nominal(
    final min=0,
    displayUnit="Pa")=5E4
    "Design evaporator  pressure drop (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpConChiHea_nominal(
    final min=0,
    displayUnit="Pa")=5E4
    "Design condenser pressure drop (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));

  parameter Modelica.Units.SI.PressureDifference dpPumHeaWat_nominal(
    final min=0,
    displayUnit="Pa")=1.1 * (dpHeaWatSet_max +
      dpConChiHea_nominal + max(chiHea.valCon.dpValve_nominal) +
      sum(chiHea.valConSwi.dpValve_nominal))
    "Design head of HW pump(each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));

  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic datChiHea
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "HRC parameters (each unit)"
    annotation (
      Dialog(group="HW loop and heat recovery chillers"),
      Placement(transformation(extent={{120,340},{140,360}})));

  final parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=
    chiHea.THeaWatSup_nominal
    "Design (maximum) HW supply temperature"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  final parameter Modelica.Units.SI.Temperature THeaWatRet_nominal=
    THeaWatSup_nominal - QHeaWat_flow_nominal / mHeaWat_flow_nominal / cp_default
    "Design (minimum) HW return temperature"
    annotation (Dialog(group="HW loop and heat recovery chillers"));

  // TCasHeaEnt_nominal computed in second cycle of TES tank.
  final parameter Modelica.Units.SI.Temperature TCasHeaEnt_nominal=
    TTanSet[2, 2]
    "Design evaporator entering temperature in cascading heating mode"
    annotation(Evaluate=true);
  // TCasCooEnt_nominal computed in Heat Rejection mode.
  final parameter Modelica.Units.SI.Temperature TCasCooEnt_nominal=
    TConWatCooSup_nominal + dTHexCoo_nominal
    "Design condenser entering temperature in cascading cooling mode"
    annotation(Evaluate=true);
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWat_flow_nominal=
    chiHea.QHeaWat_flow_nominal
    "Design heating heat flow rate (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=
    chiHea.mConWat_flow_nominal
    "Design HW mass flow rate (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));

  // CW loop, TES tank and heat pumps
  parameter Integer nHeaPum(final min=1, start=1)
    "Number of heat pumps operating at design conditions"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"),
      Evaluate=true);
  parameter Integer nPumConWatCon(final min=1, start=1)=max(nChi, nChiHea)
    "Number of CW pumps serving condenser barrels at design conditions"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"),
      Evaluate=true);
  parameter Integer nPumConWatEva(final min=1, start=1)=nChiHea
    "Number of CW pumps serving evaporator barrels at design conditions"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"),
      Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpConWatConSet_max(
    final min=0,
    displayUnit="Pa")=max(
     dpConChi_nominal + chi.valCon.dpValve_nominal,
     dpConChiHea_nominal + max(chiHea.valCon.dpValve_nominal) + sum(chiHea.valConSwi.dpValve_nominal))
    "Design (maximum) CW condenser loop differential pressure setpoint"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.PressureDifference dpConWatEvaSet_max(
    final min=0,
    displayUnit="Pa")=
    dpEvaChiHea_nominal + max(chiHea.valEva.dpValve_nominal) + sum(chiHea.valEvaSwi.dpValve_nominal)
    "Design (maximum) CW evaporator loop differential pressure setpoint"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.PressureDifference dpPumConWatCon_nominal(
    final min=0,
    displayUnit="Pa")=1.1 * (dpConWatConSet_max + max(dpHexCoo_nominal, dpTan_nominal))
    "Design head of CW pump serving condenser barrels (each unit)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.PressureDifference dpPumConWatEva_nominal(
    final min=0,
    displayUnit="Pa")=1.1 * (dpConWatEvaSet_max + dpTan_nominal)
    "Design head of CW pump serving evaporator barrels (each unit)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  final parameter Modelica.Units.SI.MassFlowRate mConWatCon_flow_nominal(
    final min=0)=chi.mConWat_flow_nominal + chiHea.mConWat_flow_nominal
    "Design total CW mass flow rate through condenser barrels (all units)";
  final parameter Modelica.Units.SI.MassFlowRate mConWatEva_flow_nominal(
    final min=0)=chiHea.mChiWat_flow_nominal
    "Design total CW mass flow rate through evaporator barrels (all units)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.Volume VTan=
    -chiHea.QEvaCasHea_flow_nominal * 3 * 3600 / (max(TTanSet) - min(TTanSet)) /
    cp_default / rho_default
    "Tank volume"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.Length hTan = (16 * VTan / Modelica.Constants.pi)^(1/3)
    "Height of tank (without insulation)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  // Default considering 1 m high thermmocline and 1 m high section below and above diffusers.
  // Thermocline only useless during last tank cycle, hence the scale factor.
  parameter Real fraUslTan(final unit="1", final min=0, final max=1, start=0.1) =
    ((max(TTanSet[2]) - min(TTanSet)) / (max(TTanSet) - min(TTanSet)) * 1 + 1) / hTan
    "Useless fraction of TES"
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
  parameter Modelica.Units.SI.Temperature TTanSet[2, 2] = {
    {15 + 273.15, 25 + 273.15},
    {TChiWatSup_nominal, 15 + 273.15}}
    "Tank temperature setpoints: 2 cycles with 2 setpoints"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  // Default TES tank pressure drop without PSV, otherwise ~ 20E3
  parameter Modelica.Units.SI.PressureDifference dpTan_nominal(displayUnit="Pa")=1E3
    "Design pressure drop through TES tank"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"));
  replaceable parameter Fluid.HeatPumps.Data.EquationFitReversible.Generic datHeaPum
    "Heat pump parameters (each unit)"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"),
    Placement(transformation(extent={{160,340},{180,360}})));

  // Buildings.DHC.Plants.Cooling tower loop
  parameter Integer nCoo(final min=1, start=1)
    "Number of cooling tower cells operating at design conditions"
    annotation (Dialog(group="Cooling tower loop"),
      Evaluate=true);
  parameter Modelica.Units.SI.MassFlowRate mConWatCoo_flow_nominal(
    final min=0)=mConWatCon_flow_nominal
    "Design CT CW mass flow rate (all units)"
    annotation(Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.PressureDifference dpConWatCooFri_nominal(
    displayUnit="Pa",
    start=1E4,
    final min=0)
    "Design CW flow-friction losses through tower and piping only (without elevation head or valve)"
    annotation (Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.MassFlowRate mAirCooUni_flow_nominal(
    final min=0,
    start=mConWatCoo_flow_nominal / nCoo / 1.45)
    "Design CT air mass flow rate (each unit)"
    annotation (Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.Temperature TWetBulCooEnt_nominal(
    final min=273.15)
    "Design CT entering air wetbulb temperature"
    annotation (Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.Temperature TConWatCooRet_nominal(
    final min=273.15)=TConWatCooSup_nominal +
    abs(QHexCoo_flow_nominal) / mConWatCoo_flow_nominal / cpConWatCoo_default
    "Design CT CW return temperature (tower entering)"
    annotation (Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.Temperature TConWatCooSup_nominal(
    final min=273.15)=TWetBulCooEnt_nominal + 3
    "Design CT CW supply temperature (tower leaving)"
    annotation (Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.Power PFanCoo_nominal(
    final min=0,
    start=340 * mConWatCoo_flow_nominal / nCoo)
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
    "Design heat exchanger approach"
    annotation (Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.PressureDifference dpHexCoo_nominal=3E4
    "Design pressure drop through heat exchanger (same on both sides)"
    annotation (Dialog(group="Cooling tower loop"));

  // HX sized with all HRCs in cascading cooling mode.
  parameter Modelica.Units.SI.HeatFlowRate QHexCoo_flow_nominal=
    -(chi.QConWat_flow_nominal + chiHea.QConCasCoo_flow_nominal)
    "Design cooling heat flow rate of heat exchanger (<0)"
    annotation (Dialog(group="Cooling tower loop"));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));
  parameter Boolean use_strokeTime=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState
    "= true, if control signal is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered signal for actuators and movers"));

  // Outside connectors
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-420,260},{-380,300}}),
        iconTransformation(extent={{-380,240},{-300,320}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea
    "Heating enable signal"
    annotation (Placement(transformation(extent={{-420,240},{-380,280}}),
        iconTransformation(extent={{-380,200},{-300,280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-420,200},{-380,240}}),
        iconTransformation(extent={{-380,160},{-300,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet(
    final unit="Pa",
    final min=0)
    "CHW differential pressure setpoint (for local dp sensor)"
    annotation (Placement(transformation(extent={{-420,140},{-380,180}}),
        iconTransformation(extent={{-380,80},{-300,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K",
    displayUnit="degC")
    "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-420,180},{-380,220}}),
        iconTransformation(extent={{-380,120},{-300,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatSet(
    final unit="Pa",
    final min=0)
    "HW differential pressure setpoint (for local dp sensor)"
    annotation (Placement(transformation(extent={{-420,120},{-380,160}}),
        iconTransformation(extent={{-380,40},{-300,120}})));

  // Components - CHW loop and cooling-only chillers
  Subsystems.ChillerGroup chi(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium,
    final dat=datChi,
    final nUni=nChi,
    final dpEva_nominal=dpEvaChi_nominal,
    final dpCon_nominal=dpConChi_nominal,
    final energyDynamics=energyDynamics,
    final use_strokeTime=use_strokeTime,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal)
    "Cooling-only chillers"
    annotation (Placement(transformation(extent={{50,76},{70,96}})));
  Subsystems.MultiplePumpsSpeed pumChiWat(
    redeclare final package Medium=Medium,
    final nPum=nPumChiWat,
    final have_var=true,
    final have_valve=true,
    final mPum_flow_nominal=mChiWat_flow_nominal / nPumChiWat,
    final dpPum_nominal=dpPumChiWat_nominal,
    final energyDynamics=energyDynamics,
    final use_strokeTime=use_strokeTime,
    final allowFlowReversal=allowFlowReversal)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{170,190},{190,210}})));
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
        origin={240,200})));
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
        origin={240,80})));
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
        origin={120,80})));
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
        origin={140,200})));
  // PICV model sized at design flow (instead of minimum flow) for convenience.
  Fluid.Actuators.Valves.TwoWayLinear valChiWatMinByp(
    redeclare final package Medium=Medium,
    final m_flow_nominal=max(mChiWatChi_flow_min, mChiWatChiHea_flow_min),
    from_dp=true,
    linearized=true,
    dpValve_nominal=1E3,
    final use_strokeTime=use_strokeTime,
    final allowFlowReversal=allowFlowReversal)
    "CHW minimum flow bypass valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,140})));
  Fluid.Sensors.RelativePressure dpChiWat(
    redeclare final package Medium=Medium)
    "CHW differential pressure (local sensor hardwired to plant controller)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={300,140})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriRet(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal) "Primary CHW return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={220,80})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow(
    redeclare final package Medium =Medium,
    final allowFlowReversal=allowFlowReversal) "Primary CHW mass flow rate"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={180,80})));
  Fluid.Sensors.TemperatureTwoPort TChiWatSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "CHW supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={210,200})));

  // Components - HW loop and heat recovery chillers
  Subsystems.ChillerHeatRecoveryGroup chiHea(
    redeclare final package Medium = Medium,
    final dat=datChiHea,
    final nUni=nChiHea,
    final TCasCooEnt_nominal=TCasCooEnt_nominal,
    final TCasHeaEnt_nominal=TCasHeaEnt_nominal,
    final dpEva_nominal=dpEvaChiHea_nominal,
    final dpCon_nominal=dpConChiHea_nominal,
    final allowFlowReversal=allowFlowReversal,
    final use_strokeTime=use_strokeTime,
    final energyDynamics=energyDynamics)
    "Heat recovery chillers"
    annotation (Placement(transformation(extent={{50,-158},{70,-138}})));

  Subsystems.MultiplePumpsSpeed pumHeaWat(
    redeclare final package Medium=Medium,
    final nPum=nPumHeaWat,
    final have_var=true,
    final have_valve=true,
    final mPum_flow_nominal=mHeaWat_flow_nominal/nPumHeaWat,
    final dpPum_nominal=dpPumHeaWat_nominal,
    final energyDynamics=energyDynamics,
    final use_strokeTime=use_strokeTime,
    final allowFlowReversal=allowFlowReversal)
    "Primary HW pumps"
    annotation (Placement(transformation(extent={{170,-150},{190,-130}})));
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
        origin={240,-140})));
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
        origin={240,-260})));
  // PICV model sized at design flow (instead of minimum flow) for convenience.
  Fluid.Actuators.Valves.TwoWayLinear valHeaWatMinByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWatChiHea_flow_min,
    from_dp=true,
    linearized=true,
    dpValve_nominal=1E3,
    final use_strokeTime=use_strokeTime,
    final allowFlowReversal=allowFlowReversal) "HW minimum flow bypass valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,-200})));
  Fluid.Sensors.RelativePressure dpHeaWat(
    redeclare final package Medium =Medium)
    "HW differential pressure (local sensor hardwired to plant controller)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={300,-200})));
  Fluid.Sensors.TemperatureTwoPort THeaWatPriRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "Primary HW return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={200,-260})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "HW supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={210,-140})));
  Fluid.Sensors.MassFlowRate mHeaWatPri_flow(
    redeclare final package Medium =Medium,
    final allowFlowReversal=allowFlowReversal)
    "Primary HW mass flow rate" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={180,-260})));

  // Components - CW loop and heat pumps
  Subsystems.MultiplePumpsSpeed pumConWatCon(
    redeclare final package Medium = Medium,
    final nPum=nPumConWatCon,
    final have_var=true,
    final have_valve=true,
    final mPum_flow_nominal=mConWatCon_flow_nominal / nPumConWatCon,
    final dpPum_nominal=dpPumConWatCon_nominal,
    final energyDynamics=energyDynamics,
    final use_strokeTime=use_strokeTime,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps serving condenser barrels"
    annotation (Placement(transformation(extent={{-90,-350},{-70,-330}})));
  Subsystems.MultiplePumpsSpeed pumConWatEva(
    redeclare final package Medium = Medium,
    final nPum=nPumConWatEva,
    final have_var=true,
    final have_valve=true,
    final mPum_flow_nominal=mConWatEva_flow_nominal / nPumConWatEva,
    final dpPum_nominal=dpPumConWatEva_nominal,
    final energyDynamics=energyDynamics,
    final use_strokeTime=use_strokeTime,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps serving evaporator barrels"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
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
        origin={20,-340})));
  Fluid.Storage.Stratified tan(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal,
    final VTan=VTan,
    final hTan=hTan,
    final dIns=dInsTan,
    final kIns=kInsTan,
    final nSeg=nSegTan)
    "TES tank"
    annotation (Placement(transformation(extent={{-130,-190},{-110,-170}})));
  Fluid.Sources.Boundary_pT bouConWat(
    redeclare final package Medium = Medium,
    final p=hTan * rho_default * Modelica.Constants.g_n,
    final nPorts=1)
    "CW pressure boundary condition prescribed by tank operating level"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-110,-210})));
  Fluid.FixedResistances.Junction junConWatTanEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal*{1,-1,-1},
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
        origin={-160,-40})));
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
        origin={80,40})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TTan[nSegTan](
    T(each displayUnit="degC"))
    "TES tank temperature sensor gateway"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-120,-140})));
  HeatTransfer.Sources.PrescribedTemperature out "Outdoor temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,-140})));
  Fluid.FixedResistances.Junction junConWatHeaPumEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal*{1,-1,-1},
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
        origin={-80,40})));
  Fluid.FixedResistances.Junction junConWatHeaPumLvg(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal*{1,-1,1},
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
        origin={-120,40})));
  Subsystems.HeatPumpGroup heaPum(
    redeclare final package Medium = Medium,
    redeclare final package MediumAir = MediumAir,
    final nUni=nHeaPum,
    final dat=datHeaPum,
    final energyDynamics=energyDynamics,
    final use_strokeTime=use_strokeTime,
    final allowFlowReversal=allowFlowReversal)
    "Heat pumps"
    annotation (Placement(transformation(extent={{-90,150},{-110,170}})));
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
        origin={-120,-280})));
  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hexCoo(
    redeclare final package Medium1=MediumConWatCoo,
    redeclare final package Medium2=Medium,
    final m1_flow_nominal=mConWatCoo_flow_nominal,
    final m2_flow_nominal=mConWatCon_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    final Q_flow_nominal=QHexCoo_flow_nominal,
    final T_a1_nominal=TConWatCooSup_nominal,
    final T_a2_nominal=TConWatCooRet_nominal + dTHexCoo_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal,
    final configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow)
    "Heat exchanger with cooling tower circuit"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-206,-170})));
  Subsystems.CoolingTowerGroup coo(
    redeclare final package Medium=Medium,
    final nUni=nCoo,
    final mConWatUni_flow_nominal=mConWatCoo_flow_nominal / nCoo,
    final dpConWatFriUni_nominal=dpConWatCooFri_nominal + dpHexCoo_nominal,
    final mAirUni_flow_nominal=mAirCooUni_flow_nominal,
    final TWetBulEnt_nominal=TWetBulCooEnt_nominal,
    final TConWatRet_nominal=TConWatCooRet_nominal,
    final TConWatSup_nominal=TConWatCooSup_nominal,
    final PFanUni_nominal=PFanCoo_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Cooling towers"
    annotation (Placement(transformation(extent={{-250,-90},{-270,-70}})));
  Fluid.Actuators.Valves.ThreeWayLinear valBypTan(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal,
    final energyDynamics=energyDynamics,
    dpValve_nominal=1E3,
    dpFixed_nominal={dpTan_nominal,dpHexCoo_nominal})
    "TES tank bypass valve"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-160,-100})));
  Fluid.Sources.Boundary_pT bouConWatCoo(
    redeclare final package Medium = Medium,
    final p=130000,
    nPorts=1)
    "CW pressure boundary condition prescribed by CT elevation head"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-300,-250})));
  Subsystems.MultiplePumpsSpeed pumConWatCoo(
    redeclare final package Medium = Medium,
    final nPum=nPumConWatCoo,
    final have_var=true,
    have_valve=false,
    final mPum_flow_nominal=mConWatCoo_flow_nominal / nPumConWatCoo,
    final dpPum_nominal=dpPumConWatCoo_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal) "Cooling tower pumps"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-250,-220})));
  Fluid.Sensors.TemperatureTwoPort TConWatEvaEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatEva_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "HRC evaporator entering CW temperature"
    annotation (Placement(transformation(
          extent={{-10,10},{10,-10}}, rotation=-90,
        origin={80,-60})));

  // Controls
  Buildings.DHC.Plants.Combined.Controls.Controller ctl(
    final nChi=nChi,
    final nPumChiWat=nPumChiWat,
    final QHeaPum_flow_nominal=datHeaPum.hea.Q_flow*nHeaPum,
    final dTLifChi_min=dTLifChi_min,
    final dTLifChi_nominal=dTLifChi_nominal,
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
    final mChiWat_flow_nominal=mChiWat_flow_nominal,
    final mHeaWat_flow_nominal=mHeaWat_flow_nominal,
    final mConWatCon_flow_nominal=mConWatCon_flow_nominal,
    final mConWatEva_flow_nominal=mConWatEva_flow_nominal,
    final mChiWatChi_flow_nominal=mChiWatChi_flow_nominal,
    final mChiWatChi_flow_min=mChiWatChi_flow_min,
    final mConWatChi_flow_nominal=mConWatChi_flow_nominal,
    final mChiWatChiHea_flow_nominal=mChiWatChiHea_flow_nominal,
    final mChiWatChiHea_flow_min=mChiWatChiHea_flow_min,
    final mConWatChiHea_flow_nominal=mConWatChiHea_flow_nominal,
    final mHeaWatChiHea_flow_min=mHeaWatChiHea_flow_min,
    final dpChiWatSet_max=dpChiWatSet_max,
    final dpHeaWatSet_max=dpHeaWatSet_max,
    final dpConWatConSet_max=dpConWatConSet_max,
    final dpConWatEvaSet_max=dpConWatEvaSet_max,
    final dpEvaChi_nominal=dpEvaChi_nominal,
    final dpValEvaChi_nominal=chi.valEva.dpValve_nominal,
    final dpEvaChiHea_nominal=dpEvaChiHea_nominal,
    final dpValEvaChiHea_nominal=max(chiHea.valEva.dpValve_nominal),
    final QChiWatChi_flow_nominal=chi.QChiWat_flow_nominal,
    final QChiWatCasCoo_flow_nominal=chiHea.QChiWatCasCoo_flow_nominal,
    final QChiWatCasCoo_flow_nominal_approx=chiHea.QChiWat_flow_nominal,
    final QHeaWat_flow_nominal=QHeaWat_flow_nominal,
    final cp_default=cp_default,
    final fraUslTan=fraUslTan,
    final dTHexCoo_nominal=dTHexCoo_nominal,
    final nTTan=nSegTan)
    "Controller"
    annotation (Placement(transformation(extent={{-342,246},{-298,322}})));

  // Miscellaneous
  Modelica.Blocks.Sources.RealExpression sumPHea(
    final y=heaPum.P + sum({
      if ctl.y1CooChiHea[i] or ctl.y1HeaCooChiHea[i] then 0 else chiHea.chi[i].P
      for i in 1:nChiHea}))
    "Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{340,270},{360,290}})));
  Modelica.Blocks.Sources.RealExpression sumPCoo(
    final y=chi.P + sum({
      if ctl.y1CooChiHea[i] or ctl.y1HeaCooChiHea[i] then chiHea.chi[i].P else 0
      for i in 1:nChiHea}))
    "Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{340,230},{360,250}})));
  Modelica.Blocks.Sources.RealExpression sumPFan(y=coo.P)
    "Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{340,190},{360,210}})));
  Modelica.Blocks.Sources.RealExpression sumPPum(
    final y=pumChiWat.P + pumHeaWat.P + pumConWatCon.P + pumConWatEva.P + pumConWatCoo.P + heaPum.PPum)
    "Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{340,150},{360,170}})));

  Fluid.Sensors.RelativePressure dpConWatEva(redeclare final package Medium =
        Medium) "CW evaporator loop differential pressure " annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={0,-70})));
  Fluid.Sensors.RelativePressure dpConWatCon(redeclare final package Medium =
        Medium) "CW condenser loop differential pressure " annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,-310})));
  Fluid.Sensors.MassFlowRate mConWatEva_flow(redeclare final package Medium =
        Medium, final allowFlowReversal=allowFlowReversal)
    "CW evaporator loop mass flow rate" annotation (Placement(transformation(
        extent={{40,-50},{60,-30}},
        rotation=0)));
  Fluid.Sensors.MassFlowRate mConWatCon_flow(redeclare final package Medium =
        Medium, final allowFlowReversal=allowFlowReversal)
    "CW condenser loop mass flow rate" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-120,-320})));
  Fluid.Sensors.MassFlowRate mConWatOutTan_flow(redeclare final package Medium =
        Medium, final allowFlowReversal=allowFlowReversal)
    "Mass flow rate out of lower port of TES tank (>0 when charging)"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-80,-240})));
  Fluid.Sensors.TemperatureTwoPort TConWatConChiLvg(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "Chiller and HRC leaving CW temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-50,40})));
  Fluid.Sensors.TemperatureTwoPort TConWatConChiEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "Chiller and HRC entering CW temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-340})));
  Fluid.Sensors.TemperatureTwoPort TConWatCooSup(
    redeclare final package Medium = MediumConWatCoo,
    final m_flow_nominal=mConWatCoo_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "Cooling tower loop CW supply temperature" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-212,-204})));
  Fluid.Sensors.TemperatureTwoPort TConWatCooRet(
    redeclare final package Medium = MediumConWatCoo,
    final m_flow_nominal=mConWatCoo_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "Cooling tower loop CW return temperature" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-212,-136})));
  Fluid.Sensors.TemperatureTwoPort TConWatHexCooEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal) "HX entering CW temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-200,-140})));
  Fluid.Sensors.TemperatureTwoPort TConWatHexCooLvg(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal) "HX leaving CW temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-200,-200})));
  Fluid.Actuators.Valves.ThreeWayLinear valConWatEvaMix(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatEva_flow_nominal,
    final energyDynamics=energyDynamics,
    dpValve_nominal=1E3,
    final dpFixed_nominal=fill(0, 2)) "HRC evaporator CW mixing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-120,-40})));
  Fluid.FixedResistances.Junction junConWatEvaLvg(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatEva_flow_nominal*{1,-1,-1},
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
        origin={0,-146})));
  Fluid.Sensors.TemperatureTwoPort TConWatConRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "Condenser loop CW return temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-160,20})));
  Fluid.Sensors.TemperatureTwoPort TConWatHeaPumEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal) "HP entering CW temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-80,90})));
  Fluid.Sensors.TemperatureTwoPort TConWatHeaPumLvg(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal) "HP leaving CW temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-120,90})));
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
public
  Fluid.Sensors.MassFlowRate mConWatHexCoo_flow(redeclare final package Medium =
        Medium, final allowFlowReversal=allowFlowReversal)
    "CW mass flow rate through secondary (plant) side of HX" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-200,-240})));
  Fluid.Actuators.Valves.TwoWayLinear valConWatByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatCon_flow_nominal,
    from_dp=true,
    linearized=true,
    dpValve_nominal=1E3,
    final use_strokeTime=use_strokeTime,
    final allowFlowReversal=allowFlowReversal)
    "CW chiller bypass valve" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-120})));
equation
  connect(junChiWatSup.port_2, port_bSerCoo)
    annotation (Line(points={{250,200},{320,200},{320,-40},{380,-40}},
                                                   color={0,127,255}));
  connect(junChiWatSup.port_3, valChiWatMinByp.port_a)
    annotation (Line(points={{240,190},{240,150}}, color={0,127,255}));
  connect(valChiWatMinByp.port_b, junChiWatRet.port_3)
    annotation (Line(points={{240,130},{240,90}}, color={0,127,255}));
  connect(junChiWatSup.port_2, dpChiWat.port_a) annotation (Line(points={{250,200},
          {300,200},{300,150}}, color={0,127,255}));
  connect(TChiWatPriRet.port_a, junChiWatRet.port_2)
    annotation (Line(points={{230,80},{230,80}}, color={0,127,255}));
  connect(port_aSerCoo, junChiWatRet.port_1) annotation (Line(points={{-380,-40},
          {-340,-40},{-340,8},{300,8},{300,80},{250,80}},
                                        color={0,127,255}));
  connect(dpChiWat.port_b, junChiWatRet.port_1)
    annotation (Line(points={{300,130},{300,80},{250,80}}, color={0,127,255}));
  connect(junHeaWatSup.port_3, valHeaWatMinByp.port_a)
    annotation (Line(points={{240,-150},{240,-190}},color={0,127,255}));
  connect(valHeaWatMinByp.port_b, junHeaWatRet.port_3)
    annotation (Line(points={{240,-210},{240,-250}}, color={0,127,255}));
  connect(THeaWatPriRet.port_a, junHeaWatRet.port_2)
    annotation (Line(points={{210,-260},{230,-260}}, color={0,127,255}));
  connect(dpHeaWat.port_b, junHeaWatRet.port_1) annotation (Line(points={{300,
          -210},{300,-260},{250,-260}},
                                  color={0,127,255}));
  connect(junHeaWatSup.port_2, port_bSerHea) annotation (Line(points={{250,-140},
          {340,-140},{340,0},{380,0}},color={0,127,255}));
  connect(ctl.y1Chi, chi.y1) annotation (Line(points={{-296,313},{28,313},{28,
          95},{48,95}},        color={255,0,255}));
  connect(ctl.yValConChi, chi.yValCon) annotation (Line(points={{-296,309},{30,
          309},{30,100},{54,100},{54,98}},           color={0,0,127}));
  connect(TChiWatSupSet, chi.TSet) annotation (Line(points={{-400,220},{40,220},
          {40,77},{48,77}},     color={0,0,127}));
  connect(ctl.y1PumChiWat, pumChiWat.y1) annotation (Line(points={{-296,307},{
          166,307},{166,208},{168,208}},
                                    color={255,0,255}));
  connect(ctl.y1PumHeaWat, pumHeaWat.y1) annotation (Line(points={{-296,282},{
          160,282},{160,-132},{168,-132}},
                                    color={255,0,255}));
  connect(ctl.yValChiWatMinByp, valChiWatMinByp.y) annotation (Line(points={{-296,
          303},{40,303},{40,180},{260,180},{260,140},{252,140}},
                                                 color={0,0,127}));
  connect(ctl.yValHeaWatMinByp, valHeaWatMinByp.y) annotation (Line(points={{-296,
          278},{264,278},{264,-200},{252,-200}},   color={0,0,127}));
  connect(THeaWatPriRet.port_b, mHeaWatPri_flow.port_a)
    annotation (Line(points={{190,-260},{190,-260}}, color={0,127,255}));
  connect(TChiWatPriRet.port_b, mChiWatPri_flow.port_a)
    annotation (Line(points={{210,80},{190,80}}, color={0,127,255}));
  connect(ctl.y1PumConWatEva, pumConWatEva.y1) annotation (Line(points={{-296,
          271},{38,271},{38,-26},{-82,-26},{-82,-32}},
                                               color={255,0,255}));
  connect(ctl.yPumConWatEva, pumConWatEva.y) annotation (Line(points={{-296,269},
          {34,269},{34,-24},{-84,-24},{-84,-36},{-82,-36}},
                                               color={0,0,127}));
  connect(sumPHea.y, PHea)
    annotation (Line(points={{361,280},{400,280}}, color={0,0,127}));
  connect(sumPCoo.y, PCoo) annotation (Line(points={{361,240},{400,240}},
                                 color={0,0,127}));
  connect(sumPFan.y, PFan)
    annotation (Line(points={{361,200},{400,200}}, color={0,0,127}));
  connect(sumPPum.y, PPum) annotation (Line(points={{361,160},{400,160}},
                           color={0,0,127}));
  connect(junHeaWatSup.port_2, dpHeaWat.port_a) annotation (Line(points={{250,
          -140},{300,-140},{300,-190}},
                                 color={0,127,255}));
  connect(pumChiWat.port_b, TChiWatSup.port_a)
    annotation (Line(points={{190,200},{200,200}}, color={0,127,255}));
  connect(TChiWatSup.port_b, junChiWatSup.port_1)
    annotation (Line(points={{220,200},{230,200}}, color={0,127,255}));
  connect(tan.heaPorVol, TTan.port)
    annotation (Line(points={{-120,-180},{-120,-150}},color={191,0,0}));
  connect(out.port, tan.heaPorTop) annotation (Line(points={{-100,-150},{-100,
          -160},{-118,-160},{-118,-172.6}},
                         color={191,0,0}));
  connect(out.port, tan.heaPorSid) annotation (Line(points={{-100,-150},{-100,
          -160},{-114.4,-160},{-114.4,-180}},
                          color={191,0,0}));
  connect(out.port, tan.heaPorBot) annotation (Line(points={{-100,-150},{-100,
          -187.4},{-118,-187.4}},       color={191,0,0}));
  connect(pumHeaWat.port_b, THeaWatSup.port_a)
    annotation (Line(points={{190,-140},{200,-140}},
                                                   color={0,127,255}));
  connect(THeaWatSup.port_b, junHeaWatSup.port_1)
    annotation (Line(points={{220,-140},{230,-140}},
                                                   color={0,127,255}));
  connect(junConWatHeaPumEnt.port_2, junConWatHeaPumLvg.port_1)
    annotation (Line(points={{-90,40},{-110,40}},  color={0,127,255}));
  connect(weaBus.TDryBul, out.T) annotation (Line(
      points={{0,380},{0,120},{-100,120},{-100,-128}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, heaPum.weaBus) annotation (Line(
      points={{0,380},{0,180},{-100,180},{-100,170}},
      color={255,204,51},
      thickness=0.5));
  connect(ctl.y1HeaPum, heaPum.y1) annotation (Line(points={{-296,266},{-42,266},
          {-42,166},{-88,166}},        color={255,0,255}));
  connect(ctl.THeaPumSet, heaPum.TSet) annotation (Line(points={{-296,264},{-44,
          264},{-44,154},{-88,154}},        color={0,0,127}));
  connect(bouConWat.ports[1], tan.port_b)
    annotation (Line(points={{-110,-200},{-110,-180}}, color={0,127,255}));
  connect(ctl.yPumChiWat, pumChiWat.y) annotation (Line(points={{-296,305},{162,
          305},{162,204},{168,204}},   color={0,0,127}));
  connect(ctl.yPumHeaWat, pumHeaWat.y) annotation (Line(points={{-296,280},{158,
          280},{158,-136},{168,-136}}, color={0,0,127}));
  connect(mChiWatPri_flow.port_b,junChiWatChiHeaRet. port_1)
    annotation (Line(points={{170,80},{130,80}},         color={0,127,255}));
  connect(junChiWatChiHeaRet.port_2, chi.port_a2)
    annotation (Line(points={{110,80},{70,80}},           color={0,127,255}));
  connect(port_aSerHea, junHeaWatRet.port_1) annotation (Line(points={{-380,0},
          {310,0},{310,-260},{250,-260}},                        color={0,127,255}));
  connect(junConWatTanEnt.port_2, valBypTan.port_2)
    annotation (Line(points={{-160,-50},{-160,-90}}, color={0,127,255}));
  connect(valBypTan.port_1, tan.port_a) annotation (Line(points={{-160,-110},{
          -160,-180},{-130,-180}},
                              color={0,127,255}));
  connect(ctl.yValBypTan, valBypTan.y) annotation (Line(points={{-296,252},{
          -180,252},{-180,-86},{-146,-86},{-146,-100},{-148,-100}},
                                            color={0,0,127}));
  connect(bouConWatCoo.ports[1], pumConWatCoo.port_a)
    annotation (Line(points={{-300,-240},{-300,-220},{-260,-220}},
                                                       color={0,127,255}));
  connect(coo.port_b, pumConWatCoo.port_a) annotation (Line(points={{-270,-80},
          {-300,-80},{-300,-220},{-260,-220}},
                                            color={0,127,255}));
  connect(weaBus, coo.weaBus) annotation (Line(
      points={{0,380},{0,120},{-260,120},{-260,-70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ctl.yCoo, coo.y) annotation (Line(points={{-296,255},{-222,255},{-222,
          -86},{-248,-86}},                     color={0,0,127}));
  connect(ctl.y1PumConWatCoo, pumConWatCoo.y1) annotation (Line(points={{-296,
          261},{-278,261},{-278,-212},{-262,-212}},
        color={255,0,255}));
  connect(chi.port_b1, junConWatLvg.port_3)
    annotation (Line(points={{70,92},{80,92},{80,50}},   color={0,127,255}));
  connect(chiHea.port_b1, pumHeaWat.port_a)
    annotation (Line(points={{70,-140},{170,-140}},
                                                  color={0,127,255}));
  connect(mHeaWatPri_flow.port_b, chiHea.port_a1) annotation (Line(points={{170,
          -260},{44,-260},{44,-140},{50,-140}},color={0,127,255}));
  connect(junChiWatChiHeaRet.port_3, chiHea.port_a4) annotation (Line(points={{120,70},
          {120,-156},{70,-156}},            color={0,127,255}));
  connect(junConWatEnt.port_2, chiHea.port_a3) annotation (Line(points={{30,-340},
          {40,-340},{40,-151.2},{50,-151.2}},color={0,127,255}));
  connect(chiHea.port_b3, junConWatLvg.port_1) annotation (Line(points={{70,
          -151.1},{100,-151.1},{100,40},{90,40}},
                                       color={0,127,255}));
  connect(ctl.yValEvaChiHea, chiHea.yValEva) annotation (Line(points={{-296,292},
          {32,292},{32,-162},{52,-162},{52,-160}},          color={0,0,127}));
  connect(ctl.y1CooChiHea, chiHea.y1Coo) annotation (Line(points={{-296,298},{
          36,298},{36,-146},{48,-146},{48,-148}}, color={255,0,255}));
  connect(ctl.y1ChiHea, chiHea.y1) annotation (Line(points={{-296,300},{38,300},
          {38,-142},{48,-142}},       color={255,0,255}));
  connect(ctl.yValConChiHea, chiHea.yValCon) annotation (Line(points={{-296,290},
          {32,290},{32,-122},{52,-122},{52,-136}},     color={0,0,127}));
  connect(ctl.TChiHeaSet, chiHea.TSet) annotation (Line(points={{-296,294},{30,
          294},{30,-154},{48,-154}},                          color={0,0,127}));
  connect(ctl.yValEvaChi, chi.yValEva) annotation (Line(points={{-296,311},{32,
          311},{32,72},{54.2,72},{54.2,74}},          color={0,0,127}));
  connect(junChiWatChiHeaSup.port_2, pumChiWat.port_a)
    annotation (Line(points={{150,200},{170,200}},color={0,127,255}));
  connect(chi.port_b2, junChiWatChiHeaSup.port_1) annotation (Line(points={{50,80},
          {44,80},{44,200},{130,200}},      color={0,127,255}));
  connect(chiHea.port_b4, junChiWatChiHeaSup.port_3) annotation (Line(points={{50,
          -156.5},{50,-156},{48,-156},{48,-170},{140,-170},{140,190}},
                                                             color={0,127,255}));
  connect(TConWatEvaEnt.port_b, chiHea.port_a2) annotation (Line(points={{80,-70},
          {80,-145},{70,-145}},      color={0,127,255}));
  connect(TChiWatSupSet, ctl.TChiWatSupSet) annotation (Line(points={{-400,220},
          {-356,220},{-356,316},{-344,316}},     color={0,0,127}));
  connect(dpChiWatSet, ctl.dpChiWatSet) annotation (Line(points={{-400,160},{
          -360,160},{-360,312},{-344,312}},     color={0,0,127}));
  connect(THeaWatSupSet, ctl.THeaWatSupSet) annotation (Line(points={{-400,200},
          {-360,200},{-360,314},{-344,314}},     color={0,0,127}));
  connect(dpHeaWatSet, ctl.dpHeaWatSet) annotation (Line(points={{-400,140},{
          -356,140},{-356,310},{-344,310}},     color={0,0,127}));
  connect(u1Coo, ctl.u1Coo) annotation (Line(points={{-400,280},{-372,280},{
          -372,320},{-344,320}},     color={255,0,255}));
  connect(u1Hea, ctl.u1Hea) annotation (Line(points={{-400,260},{-362,260},{
          -362,318},{-344,318}},     color={255,0,255}));
  connect(mChiWatPri_flow.m_flow, ctl.mChiWatPri_flow) annotation (Line(points={{180,91},
          {180,132},{-354,132},{-354,266},{-344,266}},              color={0,0,127}));
  connect(dpChiWat.p_rel, ctl.dpChiWat) annotation (Line(points={{291,140},{280,
          140},{280,124},{-372,124},{-372,254},{-344,254}},     color={0,0,127}));
  connect(mHeaWatPri_flow.m_flow, ctl.mHeaWatPri_flow) annotation (Line(points={{180,
          -271},{180,-294},{-366,-294},{-366,264},{-344,264}},          color={0,
          0,127}));
  connect(dpHeaWat.p_rel, ctl.dpHeaWat) annotation (Line(points={{291,-200},{
          280,-200},{280,62},{-366,62},{-366,252},{-344,252}},     color={0,0,127}));
  connect(pumConWatEva.port_b, dpConWatEva.port_a) annotation (Line(points={{-60,-40},
          {1.77636e-15,-40},{1.77636e-15,-60}},
                                     color={0,127,255}));
  connect(pumConWatEva.port_b, mConWatEva_flow.port_a)
    annotation (Line(points={{-60,-40},{40,-40}},   color={0,127,255}));
  connect(mConWatEva_flow.port_b, TConWatEvaEnt.port_a)
    annotation (Line(points={{60,-40},{80,-40},{80,-50}}, color={0,127,255}));
  connect(junConWatTanLvg.port_2, mConWatCon_flow.port_a)
    annotation (Line(points={{-120,-290},{-120,-310}}, color={0,127,255}));
  connect(mConWatCon_flow.port_b, pumConWatCon.port_a) annotation (Line(points={{-120,
          -330},{-120,-340},{-90,-340}},         color={0,127,255}));
  connect(mConWatCon_flow.m_flow, ctl.mConWatCon_flow) annotation (Line(points={{-131,
          -320},{-360,-320},{-360,262},{-344,262}},            color={0,0,127}));
  connect(mConWatEva_flow.m_flow, ctl.mConWatEva_flow) annotation (Line(points={{50,-29},
          {50,66},{-364,66},{-364,260},{-344,260}},            color={0,0,127}));
  connect(dpConWatEva.p_rel, ctl.dpConWatEva) annotation (Line(points={{9,-70},
          {22,-70},{22,64},{-352,64},{-352,248},{-344,248}},           color={0,
          0,127}));
  connect(dpConWatCon.p_rel, ctl.dpConWatCon) annotation (Line(points={{-29,
          -310},{-368,-310},{-368,250},{-344,250}},
                                                 color={0,0,127}));
  connect(TChiWatPriRet.T, ctl.TChiWatPriRet) annotation (Line(points={{220,91},
          {220,130},{-348,130},{-348,306},{-344,306}},     color={0,0,127}));
  connect(THeaWatPriRet.T, ctl.THeaWatPriRet) annotation (Line(points={{200,
          -249},{200,64},{-368,64},{-368,290},{-344,290}},
        color={0,0,127}));
  connect(TTan.T, ctl.TTan) annotation (Line(points={{-120,-129},{-120,-120},{
          -374,-120},{-374,288},{-344,288}},              color={0,0,127}));
  connect(tan.port_b, mConWatOutTan_flow.port_a) annotation (Line(points={{-110,
          -180},{-80,-180},{-80,-230}},   color={0,127,255}));
  connect(mConWatHexCoo_flow.m_flow, ctl.mConWatHexCoo_flow) annotation (Line(
        points={{-211,-240},{-230,-240},{-230,-202},{-358,-202},{-358,258},{
          -344,258}},
        color={0,0,127}));
  connect(mConWatOutTan_flow.m_flow, ctl.mConWatOutTan_flow) annotation (Line(
        points={{-91,-240},{-100,-240},{-100,-298},{-362,-298},{-362,-74},{
          -349.818,-74},{-349.818,256},{-344,256}},          color={0,0,127}));
  connect(junConWatEnt.port_3, chi.port_a1) annotation (Line(points={{20,-330},
          {20,92},{50,92}},   color={0,127,255}));
  connect(chi.mCon_flow, ctl.mConChi_flow) annotation (Line(points={{68,98},{68,
          124},{-344,124},{-344,272}},                color={0,0,127}));
  connect(chi.mEva_flow, ctl.mEvaChi_flow) annotation (Line(points={{68,74},{68,
          68},{-346,68},{-346,274},{-344,274}},     color={0,0,127}));
  connect(chiHea.mCon_flow, ctl.mConChiHea_flow) annotation (Line(points={{69,-136},
          {69,54},{-366,54},{-366,268},{-344,268}},                   color={0,
          0,127}));
  connect(chiHea.mEva_flow, ctl.mEvaChiHea_flow) annotation (Line(points={{68,-160},
          {68,-168},{24,-168},{24,52},{-352,52},{-352,270},{-344,270}},
                 color={0,0,127}));
  connect(ctl.yValConSwiChiHea, chiHea.yValConSwi) annotation (Line(points={{-296,
          286},{28,286},{28,-120},{54,-120},{54,-136}},         color={0,0,127}));
  connect(ctl.yValEvaSwiHea, chiHea.yValEvaSwi) annotation (Line(points={{-296,
          288},{30,288},{30,-164},{54,-164},{54,-160}},
        color={0,0,127}));
  connect(TChiWatSup.T, ctl.TChiWatSup) annotation (Line(points={{210,211},{210,
          218},{-346,218},{-346,308},{-344,308}},     color={0,0,127}));
  connect(chiHea.TEvaLvg, ctl.TEvaLvgChiHea) annotation (Line(points={{66,-160},
          {66,-166},{26,-166},{26,52},{-372,52},{-372,296},{-344,296}},
        color={0,0,127}));
  connect(junConWatLvg.port_2, TConWatConChiLvg.port_a)
    annotation (Line(points={{70,40},{-40,40}}, color={0,127,255}));
  connect(TConWatConChiLvg.port_b, junConWatHeaPumEnt.port_1)
    annotation (Line(points={{-60,40},{-70,40}}, color={0,127,255}));
  connect(THeaWatSup.T, ctl.THeaWatSup) annotation (Line(points={{210,-129},{
          210,128},{-346,128},{-346,292},{-344,292}},         color={0,0,127}));
  connect(TConWatConChiEnt.port_b, junConWatEnt.port_1)
    annotation (Line(points={{10,-340},{10,-340}},   color={0,127,255}));
  connect(pumConWatCoo.port_b, TConWatCooSup.port_a) annotation (Line(points={{-240,
          -220},{-212,-220},{-212,-214}},      color={0,127,255}));
  connect(TConWatCooSup.port_b, hexCoo.port_a1)
    annotation (Line(points={{-212,-194},{-212,-180}}, color={0,127,255}));
  connect(hexCoo.port_b1, TConWatCooRet.port_a)
    annotation (Line(points={{-212,-160},{-212,-146}},color={0,127,255}));
  connect(TConWatCooRet.port_b, coo.port_a) annotation (Line(points={{-212,-126},
          {-212,-80},{-250,-80}},
                              color={0,127,255}));
  connect(valBypTan.port_3, TConWatHexCooEnt.port_a) annotation (Line(points={{-170,
          -100},{-200,-100},{-200,-130}},   color={0,127,255}));
  connect(TConWatHexCooEnt.port_b, hexCoo.port_a2)
    annotation (Line(points={{-200,-150},{-200,-160}}, color={0,127,255}));
  connect(hexCoo.port_b2, TConWatHexCooLvg.port_a)
    annotation (Line(points={{-200,-180},{-200,-190}}, color={0,127,255}));
  connect(TConWatHexCooLvg.port_b, mConWatHexCoo_flow.port_a) annotation (Line(
        points={{-200,-210},{-200,-230}},             color={0,127,255}));
  connect(TConWatConChiLvg.T, ctl.TConWatConChiLvg) annotation (Line(points={{-50,51},
          {-50,62},{-352,62},{-352,284},{-344,284}},                 color={0,0,
          127}));
  connect(TConWatConChiEnt.T, ctl.TConWatConChiEnt) annotation (Line(points={{0,-329},
          {0,-292},{-364,-292},{-364,286},{-344,286}},
        color={0,0,127}));
  connect(TConWatCooSup.T, ctl.TConWatCooSup) annotation (Line(points={{-223,
          -204},{-356,-204},{-356,282},{-344,282}},       color={0,0,127}));
  connect(TConWatCooRet.T, ctl.TConWatCooRet) annotation (Line(points={{-223,
          -136},{-350,-136},{-350,280},{-344,280}},
                                                 color={0,0,127}));
  connect(TConWatHexCooEnt.T, ctl.TConWatHexCooEnt) annotation (Line(points={{-211,
          -140},{-350,-140},{-350,278},{-344,278}},           color={0,0,127}));
  connect(TConWatHexCooLvg.T, ctl.TConWatHexCooLvg) annotation (Line(points={{-211,
          -200},{-354,-200},{-354,276},{-344,276}},             color={0,0,127}));
  connect(ctl.yPumConWatCoo, pumConWatCoo.y) annotation (Line(points={{-296,259},
          {-280,259},{-280,-216},{-262,-216}},
        color={0,0,127}));
  connect(chiHea.TConLvg, ctl.TConLvgChiHea) annotation (Line(points={{67,-136},
          {67,58},{-370,58},{-370,298},{-344,298}},
        color={0,0,127}));
  connect(chiHea.TConEnt, ctl.TConEntChiHea) annotation (Line(points={{65,-136},
          {65,56},{-362,56},{-362,300},{-344,300}},                     color={
          0,0,127}));
  connect(junConWatTanEnt.port_3, valConWatEvaMix.port_1)
    annotation (Line(points={{-150,-40},{-130,-40}},
                                                 color={0,127,255}));
  connect(valConWatEvaMix.port_2, pumConWatEva.port_a)
    annotation (Line(points={{-110,-40},{-80,-40}},
                                                 color={0,127,255}));
  connect(junConWatEvaLvg.port_3, valConWatEvaMix.port_3) annotation (Line(
        points={{0,-136},{0,-100},{-120,-100},{-120,-50}},  color={0,127,255}));
  connect(junConWatEvaLvg.port_3, dpConWatEva.port_b)
    annotation (Line(points={{0,-136},{0,-80},{-1.77636e-15,-80}},
                                                   color={0,127,255}));
  connect(chiHea.port_b2, junConWatEvaLvg.port_1) annotation (Line(points={{50,-145},
          {50,-146},{10,-146}},      color={0,127,255}));
  connect(junConWatEvaLvg.port_2, junConWatTanLvg.port_3) annotation (Line(
        points={{-10,-146},{-30,-146},{-30,-280},{-110,-280}},
                                                   color={0,127,255}));
  connect(TConWatEvaEnt.T, ctl.TConWatEvaEnt) annotation (Line(points={{69,-60},
          {64,-60},{64,60},{-358,60},{-358,302},{-344,302}},           color={0,
          0,127}));
  connect(ctl.yValConWatEvaMix, valConWatEvaMix.y) annotation (Line(points={{-296,
          284},{26,284},{26,-20},{-120,-20},{-120,-28}},           color={0,0,
          127}));
  connect(junConWatHeaPumLvg.port_2, TConWatConRet.port_a)
    annotation (Line(points={{-130,40},{-160,40},{-160,30}},
                                                   color={0,127,255}));
  connect(TConWatConRet.port_b, junConWatTanEnt.port_1)
    annotation (Line(points={{-160,10},{-160,-30}},color={0,127,255}));
  connect(TConWatConRet.T, ctl.TConWatConRet) annotation (Line(points={{-171,20},
          {-178,20},{-178,54},{-362,54},{-362,194},{-354,194},{-354,304},{-344,
          304}},
        color={0,0,127}));
  connect(chi.TConLvg, ctl.TConLvgChi) annotation (Line(points={{66,98},{66,134},
          {-348,134},{-348,294},{-344,294}},            color={0,0,127}));
  connect(junConWatHeaPumEnt.port_3, TConWatHeaPumEnt.port_a)
    annotation (Line(points={{-80,50},{-80,80}},   color={0,127,255}));
  connect(TConWatHeaPumEnt.port_b, heaPum.port_a) annotation (Line(points={{-80,100},
          {-80,160},{-90,160}},       color={0,127,255}));
  connect(heaPum.port_b, TConWatHeaPumLvg.port_a) annotation (Line(points={{-110,
          160},{-120,160},{-120,100}},color={0,127,255}));
  connect(TConWatHeaPumLvg.port_b, junConWatHeaPumLvg.port_3)
    annotation (Line(points={{-120,80},{-120,50}}, color={0,127,255}));
  connect(ctl.y1Coo, coo.y1) annotation (Line(points={{-296,257},{-220,257},{
          -220,-74},{-248,-74}},
                             color={255,0,255}));
  connect(mConWatHexCoo_flow.port_b, junConWatTanLvg.port_1) annotation (Line(
        points={{-200,-250},{-200,-260},{-120,-260},{-120,-270}},
                                                                color={0,127,
          255}));
  connect(mConWatOutTan_flow.port_b, junConWatTanLvg.port_1)
    annotation (Line(points={{-80,-250},{-80,-260},{-120,-260},{-120,-270}},
                                                     color={0,127,255}));
  connect(ctl.yPumConWatCon, pumConWatCon.y) annotation (Line(points={{-296,273},
          {-276,273},{-276,-336},{-92,-336}}, color={0,0,127}));
  connect(ctl.y1PumConWatCon, pumConWatCon.y1) annotation (Line(points={{-296,
          275},{-284,275},{-284,254},{-274,254},{-274,-332},{-92,-332}}, color=
          {255,0,255}));
  connect(pumConWatCon.port_b, valConWatByp.port_b) annotation (Line(points={{
          -70,-340},{-40,-340},{-40,-130}}, color={0,127,255}));
  connect(ctl.yValConWatByp, valConWatByp.y) annotation (Line(points={{-296,248},
          {28,248},{28,-120},{-28,-120}}, color={0,0,127}));
  connect(pumConWatCon.port_b, TConWatConChiEnt.port_a)
    annotation (Line(points={{-70,-340},{-10,-340}}, color={0,127,255}));
  connect(pumConWatCon.port_b, dpConWatCon.port_a) annotation (Line(points={{
          -70,-340},{-20,-340},{-20,-320}}, color={0,127,255}));
  connect(valConWatByp.port_a, TConWatConChiLvg.port_a)
    annotation (Line(points={{-40,-110},{-40,40}}, color={0,127,255}));
  connect(dpConWatCon.port_b, TConWatConChiLvg.port_a) annotation (Line(points=
          {{-20,-300},{-20,40},{-40,40}}, color={0,127,255}));
annotation (
  defaultComponentName="pla", Documentation(info="<html>
<p>
This model represents a combined heating and cooling plant where chilled
water is produced by cooling-only chillers and heat recovery chillers,
hot water is produced by heat recovery chillers, and a thermal energy storage
tank is integrated in the condenser water circuit to maximize heat recovery
(\"Tank Charge/Discharge\" operating mode).
Cooling towers allow rejecting excess heat from the condenser loop
(\"Heat Rejection\" operating mode).
Air-source heat pumps allow injecting heat into the condenser loop
(\"Charge Assist\" operating mode).
</p>
<p>
This model has been developed based on the publication by <a href=\"#Gill2021\">B. Gill (2021)</a>
and further discussions with Taylor Engineers.
</p>
<h4>Abbreviations and naming conventions</h4>
<p>
The following abbreviations are used in the documentation of this
model and of its components.<br/>
</p>
<table summary=\"log levels\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><th>Abbreviation</th><th>Description</th></tr>
<tr><td>AI</td><td>Analog input (integer or real)</td></tr>
<tr><td>AO</td><td>Analog output (integer or real)</td></tr>
<tr><td>CHW</td><td>Chilled water</td></tr>
<tr><td>CT</td><td>Cooling tower</td></tr>
<tr><td>CW</td><td>Condenser water</td></tr>
<tr><td>CWC</td><td>Condenser water circuit serving chiller and HRC condenser barrel</td></tr>
<tr><td>CWE</td><td>Condenser water circuit serving HRC evaporator barrel</td></tr>
<tr><td>DI</td><td>Digital input (Boolean)</td></tr>
<tr><td>DO</td><td>Digital output (Boolean)</td></tr>
<tr><td>HP</td><td>Heat pump</td></tr>
<tr><td>HR</td><td>Heat recovery</td></tr>
<tr><td>HRC</td><td>Heat recovery chiller</td></tr>
<tr><td>HW</td><td>Hot water</td></tr>
<tr><td>VFD</td><td>Variable frequency drive</td></tr>
</table>
<p>
To clearly distinguish cooling-only chillers from heat recovery chillers,
the term \"chiller\" is used systematically to refer to cooling-only chillers
whereas the abbreviation \"HRC\" is used systematically to refer to heat recovery chillers.
</p>
<p>
Each HRC can operate under the following modes.
In <b>cascading heating</b> mode, the condenser barrel is connected to the
HW loop and the evaporator barrel is connected to the CW loop (CWE circuit).
The onboard controller controls the HRC to track a HW
supply temperature setpoint at condenser outlet.
In <b>cascading cooling</b> mode, the condenser barrel is connected to the CW
loop (CWC circuit) and the evaporator barrel is connected to the CHW
loop. The onboard controller controls the HRC to track a CHW
supply temperature setpoint at evaporator outlet.
In <b>direct heat recovery</b> mode, the condenser barrel is connected to the HW
loop and the evaporator barrel is connected to the CHW
loop. The onboard controller controls the HRC to track a HW
supply temperature setpoint at condenser outlet while the plant supervisory
controller maintains the CHW supply temperature at setpoint by
modulating the evaporator flow rate or the condenser entering temperature.
</p>
<h4>System schematic</h4>
<p>
The schematic below represents a configuration of the system with two chillers
and three HRCs.
The equipment tags correspond to the component names in the plant model.
The control points used by each control function are represented at the intersection
of the gray area that describes the function and the four bus lines corresponding
to the different control point categories (AI, DI, AO, DO).
For the sake of clarity, control logic that is duplicated between multiple
units (for instance the chiller isolation valve control) is only illustrated for
one unit.
The detailed description of each control function is available in the documentation
of
<a href=\"modelica://Buildings.DHC.Plants.Combined.Controls.Controller\">
Buildings.DHC.Plants.Combined.Controls.Controller</a>.
For an overview of the different operating modes and the design principles of such
a system, the user may refer to the article by <a href=\"#Gill2021\">B. Gill (2021)</a>.
</p>
<p align=\"left\">
<img alt=\"System schematic\"
src=\"modelica://Buildings/Resources/Images/DHC/Plants/Combined/AllElectricCWStorage.png\"/>
</p>
<h4>Control points</h4>
<h5>Cooling and heating Enable signals</h5>
<p>
The cooling and heating Enable signals <code>u1Coo</code> and <code>u1Hea</code>
shall be computed outside of the plant model, for instance based on a time schedule.
</p>
<h5>CHW and HW supply temperature and differential pressure setpoint</h5>
<p>
Those setpoints are provided as control inputs.
Ideally, a reset logic based on consumer valve requests should be implemented to adapt
those setpoints to the demand.
</p>
<h4>Details</h4>
<h5>Sizing considerations</h5>
<p>
Sizing the TES tank and the heat pumps is a joint optimization problem
under the constraint that on a design heating day, heating loads can be
met using both the recovered heat and the heat added to the tank by
the heat pumps.
As stated by <a href=\"#Gill2021\">B. Gill (2021)</a>, increasing the tank
capacity generally improves plant efficiency by providing more opportunity
for heat recovery. Tank capacity should therefore be maximized under the limit
corresponding to the amount of heat that can be recovered over the day.
</p>
<p>
The model is configured by default with a tank that is sized to store
the heat needed to operate the HRCs during <i>3&nbsp;</i>h at peak heating
load with a <i>&Delta;T</i> covering the two temperature cycles specified
with the parameter <code>TTanSet</code> (heels and thermocline neglected).
This default can be overwritten.
</p>
<h5>TES tank</h5>
<p>
The tank is assumed to be integrated without pressure separation, i.e.,
the operating level of the tank sets the system pressure and no pressure
sustaining valve or discharge pump is included.
The operating level is approximated as equal to the tank height.
A default height to diameter ratio of <i>2</i> is also taken into
account
(designers tend to favor a height to diameter ratio above <i>1.5</i>
in order to minimize the volume of the thermocline which is
considered useless).
No high limit is considered for the tank mass flow rate.
</p>
<h5>CHW and HW minimum flow bypass valve</h5>
<p>
As per standard practice, the bypass valve is sized for the highest
chiller minimum flow.
The bypass valve model is configured with
a pressure drop varying linearly with the flow rate, as opposed
to a quadratic dependency usually considered for a turbulent flow
regime.
This is because the whole plant model contains large nonlinear systems
of equations, and this configuration limits the risk of solver failure
while reducing the time to solution.
This has no significant impact on the operating point of the circulation pumps
due to the control loop that modulates the valve opening to generate
enough pressure differential at the chiller boundaries to allow for
minimum flow circulation.
So whatever the modeling assumptions for the bypass valve, the
control loop ensures that the valve creates the adequate pressure drop
and bypass flow, which will simply be reached at a different valve opening
with the above simplification.
</p>
<h5>Cooling tower circuit</h5>
<p>
The design heat flow rate used to size the cooling towers and the intermediary
heat exchanger corresponds to the heat flow rate rejected by all HRCs operating in
cascading cooling mode and all chillers operating at design conditions.
The cooling towers are sized with a default approach of <i>3&nbsp;</i>K to the
design wetbulb temperature.
The intermediary heat exchanger is sized with a default approach of <i>2&nbsp;</i>K.
</p>
<h5>Chiller and HRC performance data</h5>
<p>
The chiller performance data should cover the CW temperature levels
reached when the plant is operating in Heat Rejection mode.
The parameter <code>TCasConEnt_nominal</code> (set with a final assignment)
provides the maximum CW supply (condenser entering) temperature in this
operating mode.
The HRC performance data should cover the HRC lift envelope,
that is when the HRC is operating in direct heat recovery mode,
producing CHW and HW at their setpoint value at full load.
</p>
<h4>References</h4>
<p>
<a name=\"Gill2021\"/>
Brandon Gill, P.E., Taylor Engineers, Alameda, CA, USA.<br/>
<a href=\"https://tayloreng.egnyte.com/dl/hHl2ZkZRDC/ASHRAE_Journal_-_Solving_the_Large_Building_All-Electric_Heating_Problem.pdf_\">
Solving the large building all-electric heating problem</a>.<br/>
ASHRAE Journal, October 2021.
</p>

</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end AllElectricCWStorage;
