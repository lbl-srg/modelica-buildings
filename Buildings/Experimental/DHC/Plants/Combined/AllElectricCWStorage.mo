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
    final min=0)=0.6 * mChiWatChi_flow_nominal
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
  parameter Modelica.Units.SI.PressureDifference dpPumChiWat_nominal(
    final min=0,
    displayUnit="Pa")=1.1 * (dpChiWatSet_max + max(
      dpEvaChi_nominal + chi.dpValveEva_nominal,
      dpEvaChiHea_nominal + chiHea.dpValveEva_nominal))
    "Design head of CHW pump(each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));

  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic datChi
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller parameters (each unit)"
    annotation (
      Dialog(group="CHW loop and cooling-only chillers"),
      Placement(transformation(extent={{80,260},{100,280}})));

  final parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    max(chi.TChiWatSup_nominal, chiHea.TChiWatSup_nominal)
    "Design (minimum) CHW supply temperature"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  final parameter Modelica.Units.SI.Temperature TChiWatRet_nominal=
    TChiWatSup_nominal - QChiWat_flow_nominal / mChiWat_flow_nominal / cp_default
    "Design (maximum) CHW return temperature"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  final parameter Modelica.Units.SI.HeatFlowRate QChiWat_flow_nominal=
    chi.QChiWat_flow_nominal + chiHea.QChiWatCasCoo_flow_nominal
    "Design plant cooling heat flow rate (all units)";
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)=
    nChi * mChiWatChi_flow_nominal + nChiHea * mChiWatChiHea_flow_nominal
    "Design CHW mass flow rate (all units)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_min=
    max(mChiWatChi_flow_min, mChiWatChiHea_flow_min)
    "Largest chiller minimum CHW mass flow rate"
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
    final min=0)=0.6 * mChiWatChiHea_flow_nominal
    "Chiller CHW minimum mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mHeaWatChiHea_flow_min(
    final min=0)=0.6 * mConWatChiHea_flow_nominal
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

  parameter Modelica.Units.SI.PressureDifference dpPumHeaWat_nominal(
    final min=0,
    displayUnit="Pa")=1.1 * (dpHeaWatSet_max +
      dpConChiHea_nominal + chiHea.dpValveCon_nominal)
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
  final parameter Modelica.Units.SI.Temperature THeaWatRet_nominal=
    THeaWatSup_nominal - QHeaWat_flow_nominal / mHeaWat_flow_nominal / cp_default
    "Design (minimum) HW return temperature"
    annotation (Dialog(group="HW loop and heat recovery chillers"));

  // TCasHeaEnt_nominal computed in second cycle of TES tank.
  final parameter Modelica.Units.SI.Temperature TCasHeaEnt_nominal=
    TTanSet[2, 2]
    "Design value of chiller evaporator entering temperature in cascading heating mode"
    annotation(Evaluate=true);
  // TCasCooEnt_nominal computed in heat rejection mode.
  final parameter Modelica.Units.SI.Temperature TCasCooEnt_nominal=
    max(TTanSet) - (TConWatCooRet_nominal - TConWatCooSup_nominal)
    "Design value of chiller condenser entering temperature in cascading cooling mode"
    annotation(Evaluate=true);
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
  parameter Modelica.Units.SI.PressureDifference dpConWatConSet_max(
    final min=0,
    displayUnit="Pa")=max(
     dpConChi_nominal + chi.dpValveCon_nominal,
     dpConChiHea_nominal + chiHea.dpValveCon_nominal)
    "Design (maximum) CW condenser loop differential pressure setpoint"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.PressureDifference dpConWatEvaSet_max(
    final min=0,
    displayUnit="Pa")=dpEvaChiHea_nominal + chiHea.dpValveEva_nominal
    "Design (maximum) CW evaporator loop differential pressure setpoint"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.PressureDifference dpPumConWatCon_nominal(
    final min=0,
    displayUnit="Pa")=1.1 * (dpConWatConSet_max + max(
      dpHexCoo_nominal, dpTan_nominal))
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
  // Default considering 1 m high thermmocline and 1 m high section below and above diffusers.
  // Thermocline only useless during last tank cycle, hence the scale factor.
  parameter Real fraUslTan(final unit="1", final min=0, final max=1, start=0.1) =
    ((TTanSet[2, 2] - TTanSet[2, 1]) / (TTanSet[1, 2] - TTanSet[2, 1]) * 1 + 1) / hTan
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
  parameter Modelica.Units.SI.PressureDifference dpTan_nominal=1E3
    "Design pressure drop through TES tank"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"));
  replaceable parameter Fluid.HeatPumps.Data.EquationFitReversible.Generic datHeaPum
    "Heat pump parameters (each unit)"
    annotation (Dialog(group="CW loop, TES tank and heat pumps"),
    Placement(transformation(extent={{160,260},{180,280}})));

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
    final min=273.15)=TWetBulCooEnt_nominal + 3
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
    "Design heat exchanger approach"
    annotation (Dialog(group="Cooling tower loop"));
  parameter Modelica.Units.SI.PressureDifference dpHexCoo_nominal=3E4
    "Design pressure drop through heat exchanger (same on both sides)"
    annotation (Dialog(group="Cooling tower loop"));

  /* Stricly, QHexCoo_flow_nominal should be computed based on chiHea.QHeaWatCasCoo_flow_nominal.
  However, some Modelica tools reject this as chiHea.QHeaWatCasCoo_flow_nominal depends
  on QHexCoo_flow_nominal due to the way TCasCooEnt_nominal is computed, which creates a coupled
  system of equations within the parameter bindings of chiHea.
  Hence, we use a sizing factor of 20 % above chiHea.QHeaWat_flow_nominal.
  */
  parameter Modelica.Units.SI.HeatFlowRate QHexCoo_flow_nominal=
    -(chi.QHeaWat_flow_nominal + 1.2 * chiHea.QHeaWat_flow_nominal)
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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-340,260},{-300,300}}),
        iconTransformation(extent={{-380,240},{-300,320}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea
    "Heating enable signal"
    annotation (Placement(transformation(extent={{-340,240},{-300,280}}),
        iconTransformation(extent={{-380,200},{-300,280}})));
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
    final allowFlowReversal=allowFlowReversal) "Primary CHW mass flow rate"
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
    final TCasCooEnt_nominal=TCasCooEnt_nominal,
    final TCasHeaEnt_nominal=TCasHeaEnt_nominal,
    final dpEva_nominal=dpEvaChiHea_nominal,
    final dpCon_nominal=dpConChiHea_nominal,
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
        origin={140,-200})));
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
        extent={{10,10},{-10,-10}},
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
    annotation (Placement(transformation(extent={{-120,-250},{-100,-230}})));
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
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
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
        origin={-40,-240})));
  Fluid.Storage.Stratified tan(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWat_flow_nominal,
    final VTan=VTan,
    final hTan=hTan,
    final dIns=dInsTan,
    final kIns=kInsTan,
    final nSeg=nSegTan)
    "TES tank"
    annotation (Placement(transformation(extent={{-164,-130},{-144,-110}})));
  Fluid.Sources.Boundary_pT bouConWat(
    redeclare final package Medium = Medium,
    final p=hTan * rho_default * Modelica.Constants.g_n,
    final nPorts=1)
    "CW boundary pressure condition prescribed by tank operating level"
    annotation (Placement(transformation(extent={{-90,-130},{-110,-110}})));
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
        origin={-180,0})));
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
        origin={-154,-90})));
  HeatTransfer.Sources.PrescribedTemperature out "Outdoor temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-120,-80})));
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
        origin={-140,-180})));
  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hexCoo(
    redeclare final package Medium1=MediumConWatCoo,
    redeclare final package Medium2=Medium,
    final m1_flow_nominal=mConWat_flow_nominal,
    final m2_flow_nominal=mConWat_flow_nominal,
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
        origin={-206,-114})));
  Subsystems.CoolingTowerGroup coo(
    redeclare final package Medium=Medium,
    final nUni=nCoo,
    final mConWatUni_flow_nominal=mConWatCoo_flow_nominal,
    final dpConWatFriUni_nominal=dpConWatCooFri_nominal + dpHexCoo_nominal,
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
    dpValve_nominal=1E3,
    dpFixed_nominal={dpTan_nominal,dpHexCoo_nominal})
    "TES tank bypass valve"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-180,-52})));
  Fluid.Sources.Boundary_pT bouConWatCoo(
    redeclare final package Medium = Medium,
    final p=130000,
    nPorts=1)
    "CW boundary pressure condition prescribed by CT elevation head"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-260,-240})));
  Subsystems.MultiplePumpsSpeed pumConWatCoo(
    redeclare final package Medium = Medium,
    final nPum=nPumConWatCoo,
    final have_var=true,
    have_valve=false,
    final mPum_flow_nominal=mConWatCoo_flow_nominal  * nCoo / nPumConWatCoo,
    final dpPum_nominal=dpPumConWatCoo_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal) "Cooling tower pums"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-240,-160})));
  Fluid.Sensors.TemperatureTwoPort TConWatEvaEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatEva_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "HRC evaporator entering CW temperature"
                                         annotation (Placement(transformation(
          extent={{-10,10},{10,-10}}, rotation=-90,
        origin={20,-20})));

  // Controls
  Buildings.Experimental.DHC.Plants.Combined.Controls.Controller ctl(
    final nChi=nChi,
    final nPumChiWat=nPumChiWat,
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
    final dpChiWatSet_max=dpChiWatSet_max,
    final dpHeaWatSet_max=dpHeaWatSet_max,
    final dpConWatConSet_max=dpConWatConSet_max,
    final dpConWatEvaSet_max=dpConWatEvaSet_max,
    final QChiWatChi_flow_nominal=chi.QChiWat_flow_nominal,
    final QChiWatCasCoo_flow_nominal=chiHea.QChiWatCasCoo_flow_nominal,
    final QHeaWat_flow_nominal=QHeaWat_flow_nominal,
    final cp_default=cp_default,
    final fraUslTan=fraUslTan,
    final dTHexCoo_nominal=dTHexCoo_nominal,
    final nTTan=nSegTan)
    "Controller"
    annotation (Placement(transformation(extent={{-280,140},{-240,206}})));

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
    annotation (Placement(transformation(extent={{-180,-262},{-160,-242}})));
  Modelica.Blocks.Sources.BooleanExpression ctlY1PumConWatCon[nPumConWatCon](
    final y=ctl.y1PumConWatCon)
    "Equation block avoiding graphical connection"
    annotation (Placement(transformation(extent={{-180,-246},{-160,-226}})));

  Fluid.Sensors.RelativePressure dpConWatEva(redeclare final package Medium =
        Medium) "CW evaporator loop differential pressure " annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,-20})));
  Fluid.Sensors.RelativePressure dpConWatCon(redeclare final package Medium =
        Medium) "CW condenser loop differential pressure " annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-80,-200})));
  Fluid.Sensors.MassFlowRate mConWatEva_flow(redeclare final package Medium =
        Medium, final allowFlowReversal=allowFlowReversal)
    "CW evaporator loop mass flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Fluid.Sensors.MassFlowRate mConWatCon_flow(redeclare final package Medium =
        Medium, final allowFlowReversal=allowFlowReversal)
    "CW condenser loop mass flow rate" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-140,-220})));
  Fluid.Sensors.MassFlowRate mConWatHexCoo_flow(redeclare final package Medium =
        Medium, final allowFlowReversal=allowFlowReversal)
    "CW mass flow rate through secondary (plant) side of HX" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-180,-160})));
  Fluid.Sensors.MassFlowRate mConWatOutTan_flow(redeclare final package Medium =
        Medium, final allowFlowReversal=allowFlowReversal)
    "Mass flow rate out of lower port of TES tank (>0 when charging)"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-140,-140})));
  Fluid.Sensors.TemperatureTwoPort TConWatChiLvg(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "CW chiller and HRC leaving temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-60,40})));
  Fluid.Sensors.TemperatureTwoPort TConWatChiEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "CW chiller and HRC entering temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-240})));
  Fluid.Sensors.TemperatureTwoPort TConWatCooSup(
    redeclare final package Medium = MediumConWatCoo,
    final m_flow_nominal=mConWatCoo_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "Cooling tower loop CW supply temperature" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-212,-148})));
  Fluid.Sensors.TemperatureTwoPort TConWatCooRet(
    redeclare final package Medium = MediumConWatCoo,
    final m_flow_nominal=mConWatCoo_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "Cooling tower loop CW return temperature" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-212,-76})));
  Fluid.Sensors.TemperatureTwoPort TConWatHexCooEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal) "HX entering CW temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-200,-90})));
  Fluid.Sensors.TemperatureTwoPort TConWatHexCooLvg(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal) "HX leaving CW temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-200,-140})));
  Fluid.Actuators.Valves.ThreeWayLinear valConWatEvaMix(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatEva_flow_nominal,
    final energyDynamics=energyDynamics,
    dpValve_nominal=1E3,
    final dpFixed_nominal=fill(0, 2)) "HRC evaporator CW mixing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-140,0})));
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
        origin={-60,-86})));
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
    annotation (Line(points={{150,-200},{170,-200}}, color={0,127,255}));
  connect(dpHeaWat.port_b, junHeaWatRet.port_1) annotation (Line(points={{240,-150},
          {240,-200},{190,-200}}, color={0,127,255}));
  connect(junHeaWatSup.port_2, port_bSerHea) annotation (Line(points={{190,-80},
          {280,-80},{280,0},{300,0}}, color={0,127,255}));
  connect(ctl.y1Chi, chi.y1) annotation (Line(points={{-238.182,199.583},{-32,
          199.583},{-32,95},{-12,95}},
                               color={255,0,255}));
  connect(ctl.yValConChi, chi.yValCon) annotation (Line(points={{-238.182,
          195.917},{-30,195.917},{-30,100},{-6,100},{-6,98}},
                                                     color={0,0,127}));
  connect(TChiWatSupSet, chi.TSet) annotation (Line(points={{-320,220},{-34,220},
          {-34,77},{-12,77}},   color={0,0,127}));
  connect(ctl.y1PumChiWat, pumChiWat.y1) annotation (Line(points={{-238.182,
          194.083},{100,194.083},{100,208},{108,208}},
                                    color={255,0,255}));
  connect(ctl.y1PumHeaWat, pumHeaWat.y1) annotation (Line(points={{-238.182,
          171.167},{100,171.167},{100,-72},{108,-72}},
                                    color={255,0,255}));
  connect(ctl.yValChiWatMinByp, valChiWatMinByp.y) annotation (Line(points={{
          -238.182,190.417},{-20,190.417},{-20,160},{200,160},{200,140},{192,
          140}},                                 color={0,0,127}));
  connect(ctl.yValHeaWatMinByp, valHeaWatMinByp.y) annotation (Line(points={{
          -238.182,167.5},{-198,167.5},{-198,-60},{200,-60},{200,-140},{192,
          -140}},                                  color={0,0,127}));
  connect(THeaWatPriRet.port_b, mHeaWatPri_flow.port_a)
    annotation (Line(points={{130,-200},{130,-200}}, color={0,127,255}));
  connect(TChiWatPriRet.port_b, mChiWatPri_flow.port_a)
    annotation (Line(points={{140,80},{130,80}}, color={0,127,255}));
  connect(ctl.y1PumConWatEva, pumConWatEva.y1) annotation (Line(points={{
          -238.182,161.083},{-124,161.083},{-124,8},{-112,8}},
                                               color={255,0,255}));
  connect(ctl.yPumConWatEva, pumConWatEva.y) annotation (Line(points={{-238.182,
          159.25},{-126,159.25},{-126,4},{-112,4}},
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
  connect(pumChiWat.port_b, TChiWatSup.port_a)
    annotation (Line(points={{130,200},{140,200}}, color={0,127,255}));
  connect(TChiWatSup.port_b, junChiWatSup.port_1)
    annotation (Line(points={{160,200},{170,200}}, color={0,127,255}));
  connect(tan.heaPorVol, TTan.port)
    annotation (Line(points={{-154,-120},{-154,-100}},color={191,0,0}));
  connect(out.port, tan.heaPorTop) annotation (Line(points={{-120,-90},{-120,
          -100},{-152,-100},{-152,-112.6}},
                         color={191,0,0}));
  connect(out.port, tan.heaPorSid) annotation (Line(points={{-120,-90},{-120,
          -100},{-148.4,-100},{-148.4,-120}},
                          color={191,0,0}));
  connect(out.port, tan.heaPorBot) annotation (Line(points={{-120,-90},{-120,
          -127.4},{-152,-127.4}},       color={191,0,0}));
  connect(pumHeaWat.port_b, THeaWatSup.port_a)
    annotation (Line(points={{130,-80},{140,-80}}, color={0,127,255}));
  connect(THeaWatSup.port_b, junHeaWatSup.port_1)
    annotation (Line(points={{160,-80},{170,-80}}, color={0,127,255}));
  connect(junConWatHeaPumEnt.port_2, junConWatHeaPumLvg.port_1)
    annotation (Line(points={{-110,40},{-150,40}}, color={0,127,255}));
  connect(junConWatHeaPumEnt.port_3, heaPum.port_a) annotation (Line(points={{-100,50},
          {-100,110},{-130,110}},     color={0,127,255}));
  connect(heaPum.port_b, junConWatHeaPumLvg.port_3) annotation (Line(points={{-150,
          110},{-160,110},{-160,50}}, color={0,127,255}));
  connect(weaBus.TDryBul, out.T) annotation (Line(
      points={{1,266},{1,260},{-140,260},{-140,120},{-120,120},{-120,-68}},
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
  connect(ctl.y1HeaPum, heaPum.y1) annotation (Line(points={{-238.182,156.5},{
          -102,156.5},{-102,116},{-128,116}},
                                       color={255,0,255}));
  connect(ctl.THeaPumSet, heaPum.TSet) annotation (Line(points={{-238.182,
          154.667},{-104,154.667},{-104,104},{-128,104}},
                                            color={0,0,127}));
  connect(bouConWat.ports[1], tan.port_b)
    annotation (Line(points={{-110,-120},{-144,-120}}, color={0,127,255}));
  connect(ctl.yPumChiWat, pumChiWat.y) annotation (Line(points={{-238.182,
          192.25},{98,192.25},{98,204},{108,204}},
                                       color={0,0,127}));
  connect(ctl.yPumHeaWat, pumHeaWat.y) annotation (Line(points={{-238.182,
          169.333},{98,169.333},{98,-76},{108,-76}},
                                       color={0,0,127}));
  connect(mChiWatPri_flow.port_b,junChiWatChiHeaRet. port_1)
    annotation (Line(points={{110,80},{70,80}},          color={0,127,255}));
  connect(junChiWatChiHeaRet.port_2, chi.port_a2)
    annotation (Line(points={{50,80},{10,80}},            color={0,127,255}));
  connect(port_aSerHea, junHeaWatRet.port_1) annotation (Line(points={{-300,0},{
          -290,0},{-290,-260},{240,-260},{240,-200},{190,-200}}, color={0,127,255}));
  connect(junConWatTanEnt.port_2, valBypTan.port_2)
    annotation (Line(points={{-180,-10},{-180,-42}}, color={0,127,255}));
  connect(valBypTan.port_1, tan.port_a) annotation (Line(points={{-180,-62},{
          -180,-120},{-164,-120}},
                              color={0,127,255}));
  connect(ctl.yValBypTan, valBypTan.y) annotation (Line(points={{-238.182,
          143.667},{-200,143.667},{-200,-38},{-160,-38},{-160,-52},{-168,-52}},
                                            color={0,0,127}));
  connect(bouConWatCoo.ports[1], pumConWatCoo.port_a)
    annotation (Line(points={{-260,-230},{-260,-160},{-250,-160}},
                                                       color={0,127,255}));
  connect(coo.port_b, pumConWatCoo.port_a) annotation (Line(points={{-250,0},{-272,
          0},{-272,-160},{-250,-160}},      color={0,127,255}));
  connect(weaBus, coo.weaBus) annotation (Line(
      points={{1,266},{1,260},{-140,260},{-140,120},{-240,120},{-240,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ctl.yCoo, coo.y) annotation (Line(points={{-238.182,146.417},{-222,
          146.417},{-222,-6},{-228,-6}},        color={0,0,127}));
  connect(ctl.y1Coo, coo.y1) annotation (Line(points={{-238.182,148.25},{-224,
          148.25},{-224,6},{-228,6}},
                              color={255,0,255}));
  connect(ctl.y1PumConWatCoo, pumConWatCoo.y1) annotation (Line(points={{
          -238.182,151.917},{-230,151.917},{-230,128},{-260,128},{-260,-152},{
          -252,-152}},
        color={255,0,255}));
  connect(ctlY1PumConWatCon.y, pumConWatCon.y1)
    annotation (Line(points={{-159,-236},{-128,-236},{-128,-232},{-122,-232}},
                                                       color={255,0,255}));
  connect(ctlYPumConWatCon.y, pumConWatCon.y) annotation (Line(points={{-159,
          -252},{-126,-252},{-126,-236},{-122,-236}}, color={0,0,127}));
  connect(chi.port_b1, junConWatLvg.port_3)
    annotation (Line(points={{10,92},{20,92},{20,50}},   color={0,127,255}));
  connect(chiHea.port_b1, pumHeaWat.port_a)
    annotation (Line(points={{10,-80},{110,-80}}, color={0,127,255}));
  connect(mHeaWatPri_flow.port_b, chiHea.port_a1) annotation (Line(points={{110,
          -200},{-16,-200},{-16,-80},{-10,-80}},
                                               color={0,127,255}));
  connect(junChiWatChiHeaRet.port_3, chiHea.port_a4) annotation (Line(points={{60,70},
          {60,-96},{10,-96}},               color={0,127,255}));
  connect(junConWatEnt.port_2, chiHea.port_a3) annotation (Line(points={{-30,-240},
          {-20,-240},{-20,-91.2},{-10,-91.2}},
                                             color={0,127,255}));
  connect(chiHea.port_b3, junConWatLvg.port_1) annotation (Line(points={{10,
          -91.1},{40,-91.1},{40,40},{30,40}},
                                       color={0,127,255}));
  connect(ctl.yValEvaChiHea, chiHea.yValEva) annotation (Line(points={{-238.182,
          180.333},{-28,180.333},{-28,-102},{-8,-102},{-8,-100}},
                                                            color={0,0,127}));
  connect(ctl.y1CooChiHea, chiHea.y1Coo) annotation (Line(points={{-238.182,
          185.833},{-24,185.833},{-24,-86},{-12,-86},{-12,-88}},
                                                  color={255,0,255}));
  connect(ctl.y1ChiHea, chiHea.y1) annotation (Line(points={{-238.182,187.667},
          {-22,187.667},{-22,-82},{-12,-82}},
                                      color={255,0,255}));
  connect(ctl.yValConChiHea, chiHea.yValCon) annotation (Line(points={{-238.182,
          178.5},{-28,178.5},{-28,-74},{-8,-74},{-8,-76}},
                                                       color={0,0,127}));
  connect(ctl.TChiHeaSet, chiHea.TSet) annotation (Line(points={{-238.182,
          182.167},{-30,182.167},{-30,-94},{-12,-94}},        color={0,0,127}));
  connect(ctl.yValEvaChi, chi.yValEva) annotation (Line(points={{-238.182,
          197.75},{-28,197.75},{-28,72},{-5.8,72},{-5.8,74}},
                                                      color={0,0,127}));
  connect(junChiWatChiHeaSup.port_2, pumChiWat.port_a)
    annotation (Line(points={{90,200},{110,200}}, color={0,127,255}));
  connect(chi.port_b2, junChiWatChiHeaSup.port_1) annotation (Line(points={{-10,80},
          {-16,80},{-16,200},{70,200}},     color={0,127,255}));
  connect(chiHea.port_b4, junChiWatChiHeaSup.port_3) annotation (Line(points={{-10,
          -96.5},{-10,-96},{-12,-96},{-12,-110},{80,-110},{80,190}},
                                                             color={0,127,255}));
  connect(TConWatEvaEnt.port_b, chiHea.port_a2) annotation (Line(points={{20,-30},
          {20,-85},{10,-85}},        color={0,127,255}));
  connect(TChiWatSupSet, ctl.TChiWatSupSet) annotation (Line(points={{-320,220},
          {-288,220},{-288,200.5},{-281.818,200.5}},
                                                 color={0,0,127}));
  connect(dpChiWatSet, ctl.dpChiWatSet) annotation (Line(points={{-320,160},{
          -292,160},{-292,196.833},{-281.818,196.833}},
                                                color={0,0,127}));
  connect(THeaWatSupSet, ctl.THeaWatSupSet) annotation (Line(points={{-320,200},
          {-292,200},{-292,198.667},{-281.818,198.667}},
                                                 color={0,0,127}));
  connect(dpHeaWatSet, ctl.dpHeaWatSet) annotation (Line(points={{-320,140},{
          -288,140},{-288,195},{-281.818,195}}, color={0,0,127}));
  connect(u1Coo, ctl.u1Coo) annotation (Line(points={{-320,280},{-284,280},{
          -284,204.167},{-281.818,204.167}},
                                     color={255,0,255}));
  connect(u1Hea, ctl.u1Hea) annotation (Line(points={{-320,260},{-286,260},{
          -286,202.333},{-281.818,202.333}},
                                     color={255,0,255}));
  connect(mChiWatPri_flow.m_flow, ctl.mChiWatPri_flow) annotation (Line(points={{120,91},
          {120,132},{-286,132},{-286,158.333},{-281.818,158.333}},  color={0,0,127}));
  connect(dpChiWat.p_rel, ctl.dpChiWat) annotation (Line(points={{231,140},{220,
          140},{220,126},{-290,126},{-290,147.333},{-281.818,147.333}},
                                                                color={0,0,127}));
  connect(mHeaWatPri_flow.m_flow, ctl.mHeaWatPri_flow) annotation (Line(points={{120,
          -211},{120,-278},{-294,-278},{-294,156.5},{-281.818,156.5}},  color={0,
          0,127}));
  connect(dpHeaWat.p_rel, ctl.dpHeaWat) annotation (Line(points={{231,-140},{
          220,-140},{220,-280},{-292,-280},{-292,145.5},{-281.818,145.5}},
                                                                   color={0,0,127}));
  connect(pumConWatEva.port_b, dpConWatEva.port_a) annotation (Line(points={{-90,0},
          {-60,0},{-60,-10}},        color={0,127,255}));
  connect(pumConWatCon.port_b, dpConWatCon.port_a) annotation (Line(points={{-100,
          -240},{-80,-240},{-80,-210}}, color={0,127,255}));
  connect(pumConWatEva.port_b, mConWatEva_flow.port_a)
    annotation (Line(points={{-90,0},{-10,0}},      color={0,127,255}));
  connect(mConWatEva_flow.port_b, TConWatEvaEnt.port_a)
    annotation (Line(points={{10,0},{20,0},{20,-10}},     color={0,127,255}));
  connect(junConWatHeaPumLvg.port_2, junConWatTanEnt.port_1) annotation (Line(
        points={{-170,40},{-180,40},{-180,10}},  color={0,127,255}));
  connect(junConWatTanLvg.port_2, mConWatCon_flow.port_a)
    annotation (Line(points={{-140,-190},{-140,-210}}, color={0,127,255}));
  connect(mConWatCon_flow.port_b, pumConWatCon.port_a) annotation (Line(points={{-140,
          -230},{-140,-240},{-120,-240}},        color={0,127,255}));
  connect(mConWatCon_flow.m_flow, ctl.mConWatCon_flow) annotation (Line(points={{-151,
          -220},{-296,-220},{-296,154.667},{-281.818,154.667}},color={0,0,127}));
  connect(mConWatEva_flow.m_flow, ctl.mConWatEva_flow) annotation (Line(points={{0,11},{
          0,66},{-298,66},{-298,152.833},{-281.818,152.833}},  color={0,0,127}));
  connect(dpConWatEva.p_rel, ctl.dpConWatEva) annotation (Line(points={{-69,-20},
          {-286,-20},{-286,141.833},{-281.818,141.833}},               color={0,
          0,127}));
  connect(dpConWatCon.p_rel, ctl.dpConWatCon) annotation (Line(points={{-89,
          -200},{-287.818,-200},{-287.818,143.667},{-281.818,143.667}},
                                                 color={0,0,127}));
  connect(TChiWatPriRet.T, ctl.TChiWatPriRet) annotation (Line(points={{150,91},
          {150,130},{-288,130},{-288,191.333},{-281.818,191.333}},
                                                           color={0,0,127}));
  connect(THeaWatPriRet.T, ctl.THeaWatPriRet) annotation (Line(points={{140,
          -189},{140,122},{-290,122},{-290,180.333},{-281.818,180.333}},
        color={0,0,127}));
  connect(TTan.T, ctl.TTan) annotation (Line(points={{-154,-79},{-154,-60},{
          -284,-60},{-284,178.5},{-281.818,178.5}},       color={0,0,127}));
  connect(mConWatHexCoo_flow.port_b, junConWatTanLvg.port_1) annotation (Line(
        points={{-170,-160},{-140,-160},{-140,-170}}, color={0,127,255}));
  connect(tan.port_b, mConWatOutTan_flow.port_a) annotation (Line(points={{-144,
          -120},{-140,-120},{-140,-130}}, color={0,127,255}));
  connect(mConWatOutTan_flow.port_b, junConWatTanLvg.port_1)
    annotation (Line(points={{-140,-150},{-140,-170}}, color={0,127,255}));
  connect(mConWatHexCoo_flow.m_flow, ctl.mConWatHexCoo_flow) annotation (Line(
        points={{-180,-149},{-180,-144},{-292,-144},{-292,151},{-281.818,151}},
        color={0,0,127}));
  connect(mConWatOutTan_flow.m_flow, ctl.mConWatOutTan_flow) annotation (Line(
        points={{-151,-140},{-164,-140},{-164,-142},{-298,-142},{-298,6},{
          -285.818,6},{-285.818,149.167},{-281.818,149.167}},color={0,0,127}));
  connect(junConWatEnt.port_3, chi.port_a1) annotation (Line(points={{-40,-230},
          {-40,92},{-10,92}}, color={0,127,255}));
  connect(dpConWatCon.port_b, junConWatHeaPumEnt.port_1) annotation (Line(
        points={{-80,-190},{-80,40},{-90,40}}, color={0,127,255}));
  connect(chi.mCon_flow, ctl.mConChi_flow) annotation (Line(points={{8,98},{8,
          124},{-296,124},{-296,163.833},{-281.818,163.833}},
                                                      color={0,0,127}));
  connect(chi.mEva_flow, ctl.mEvaChi_flow) annotation (Line(points={{8,74},{8,
          68},{-286,68},{-286,165.667},{-281.818,165.667}},
                                                    color={0,0,127}));
  connect(chiHea.mCon_flow, ctl.mConChiHea_flow) annotation (Line(points={{9,-76},
          {9,-62},{-288,-62},{-288,160.167},{-281.818,160.167}},      color={0,
          0,127}));
  connect(chiHea.mEva_flow, ctl.mEvaChiHea_flow) annotation (Line(points={{8,-100},
          {8,-108},{-34,-108},{-34,-64},{-296,-64},{-296,162},{-281.818,162}},
                 color={0,0,127}));
  connect(ctl.yValConSwiChiHea, chiHea.yValConSwi) annotation (Line(points={{
          -238.182,174.833},{-32,174.833},{-32,-72},{-6,-72},{-6,-76}},
                                                                color={0,0,127}));
  connect(ctl.yValEvaSwiHea, chiHea.yValEvaSwi) annotation (Line(points={{
          -238.182,176.667},{-30,176.667},{-30,-104},{-6,-104},{-6,-100}},
        color={0,0,127}));
  connect(TChiWatSup.T, ctl.TChiWatSup) annotation (Line(points={{150,211},{150,
          218},{-294,218},{-294,193.167},{-281.818,193.167}},
                                                      color={0,0,127}));
  connect(chiHea.TEvaLvg, ctl.TEvaLvgChiHea) annotation (Line(points={{6,-100},
          {6,-106},{-32,-106},{-32,-62},{-286,-62},{-286,184},{-281.818,184}},
        color={0,0,127}));
  connect(junConWatLvg.port_2, TConWatChiLvg.port_a)
    annotation (Line(points={{10,40},{-50,40}}, color={0,127,255}));
  connect(TConWatChiLvg.port_b, junConWatHeaPumEnt.port_1)
    annotation (Line(points={{-70,40},{-90,40}}, color={0,127,255}));
  connect(THeaWatSup.T, ctl.THeaWatSup) annotation (Line(points={{150,-69},{150,
          -62},{-294,-62},{-294,182.167},{-281.818,182.167}}, color={0,0,127}));
  connect(pumConWatCon.port_b, TConWatChiEnt.port_a)
    annotation (Line(points={{-100,-240},{-70,-240}}, color={0,127,255}));
  connect(TConWatChiEnt.port_b, junConWatEnt.port_1)
    annotation (Line(points={{-50,-240},{-50,-240}}, color={0,127,255}));
  connect(pumConWatCoo.port_b, TConWatCooSup.port_a) annotation (Line(points={{
          -230,-160},{-212,-160},{-212,-158}}, color={0,127,255}));
  connect(TConWatCooSup.port_b, hexCoo.port_a1)
    annotation (Line(points={{-212,-138},{-212,-124}}, color={0,127,255}));
  connect(hexCoo.port_b1, TConWatCooRet.port_a)
    annotation (Line(points={{-212,-104},{-212,-86}}, color={0,127,255}));
  connect(TConWatCooRet.port_b, coo.port_a) annotation (Line(points={{-212,-66},
          {-212,0},{-230,0}}, color={0,127,255}));
  connect(valBypTan.port_3, TConWatHexCooEnt.port_a) annotation (Line(points={{-190,
          -52},{-200,-52},{-200,-80}},      color={0,127,255}));
  connect(TConWatHexCooEnt.port_b, hexCoo.port_a2)
    annotation (Line(points={{-200,-100},{-200,-104}}, color={0,127,255}));
  connect(hexCoo.port_b2, TConWatHexCooLvg.port_a)
    annotation (Line(points={{-200,-124},{-200,-130}}, color={0,127,255}));
  connect(TConWatHexCooLvg.port_b, mConWatHexCoo_flow.port_a) annotation (Line(
        points={{-200,-150},{-200,-160},{-190,-160}}, color={0,127,255}));
  connect(TConWatChiLvg.T, ctl.TConWatChiLvg) annotation (Line(points={{-60,51},
          {-60,62},{-292,62},{-292,174.833},{-281.818,174.833}}, color={0,0,127}));
  connect(TConWatChiEnt.T, ctl.TConWatChiEnt) annotation (Line(points={{-60,
          -229},{-60,-204},{-296,-204},{-296,176.667},{-281.818,176.667}},
                                                                     color={0,0,
          127}));
  connect(TConWatCooSup.T, ctl.TConWatCooSup) annotation (Line(points={{-223,
          -148},{-292,-148},{-292,173},{-281.818,173}},   color={0,0,127}));
  connect(TConWatCooRet.T, ctl.TConWatCooRet) annotation (Line(points={{-223,
          -76},{-286,-76},{-286,171.167},{-281.818,171.167}},
                                                 color={0,0,127}));
  connect(TConWatHexCooEnt.T, ctl.TConWatHexCooEnt) annotation (Line(points={{-211,
          -90},{-286,-90},{-286,169.333},{-281.818,169.333}}, color={0,0,127}));
  connect(TConWatHexCooLvg.T, ctl.TConWatHexCooLvg) annotation (Line(points={{-211,
          -140},{-290,-140},{-290,167.5},{-281.818,167.5}},     color={0,0,127}));
  connect(ctl.yPumConWatCoo, pumConWatCoo.y) annotation (Line(points={{-238.182,
          150.083},{-232,150.083},{-232,134},{-262,134},{-262,-156},{-252,-156}},
        color={0,0,127}));
  connect(chiHea.TConLvg, ctl.TConLvgChiHea) annotation (Line(points={{7,-76},{
          7,-62},{-294,-62},{-294,186},{-281.818,186},{-281.818,185.833}},
        color={0,0,127}));
  connect(chiHea.TConEnt, ctl.TConEntChiHea) annotation (Line(points={{5,-76},{
          4,-76},{4,-64},{-296,-64},{-296,187.667},{-281.818,187.667}}, color={
          0,0,127}));
  connect(junConWatTanEnt.port_3, valConWatEvaMix.port_1)
    annotation (Line(points={{-170,0},{-150,0}}, color={0,127,255}));
  connect(valConWatEvaMix.port_2, pumConWatEva.port_a)
    annotation (Line(points={{-130,0},{-110,0}}, color={0,127,255}));
  connect(junConWatEvaLvg.port_3, valConWatEvaMix.port_3) annotation (Line(
        points={{-60,-76},{-60,-40},{-140,-40},{-140,-10}}, color={0,127,255}));
  connect(junConWatEvaLvg.port_3, dpConWatEva.port_b)
    annotation (Line(points={{-60,-76},{-60,-30}}, color={0,127,255}));
  connect(chiHea.port_b2, junConWatEvaLvg.port_1) annotation (Line(points={{-10,
          -85},{-10,-86},{-50,-86}}, color={0,127,255}));
  connect(junConWatEvaLvg.port_2, junConWatTanLvg.port_3) annotation (Line(
        points={{-70,-86},{-70,-180},{-130,-180}}, color={0,127,255}));
  connect(TConWatEvaEnt.T, ctl.TConWatEvaEnt) annotation (Line(points={{9,-20},
          {-10,-20},{-10,64},{-298,64},{-298,189.5},{-281.818,189.5}}, color={0,
          0,127}));
  connect(ctl.yValConWatEvaMix, valConWatEvaMix.y) annotation (Line(points={{
          -238.182,173},{-196,173},{-196,58},{-140,58},{-140,12}}, color={0,0,
          127}));
annotation (
  defaultComponentName="pla", Documentation(info="<html>
FIXME:
* TCasCooEnt_nominal to be updated to take into account offset for enabling Excess Heat Rejection Mode.
<p>
NOTES:
* TCasHeaEnt_nominal set for last TES tank cycle.
* No (high) limit considered for tank flow rate.
* No (low) limit considered for HP siupply temperature setpoint.
</p>
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