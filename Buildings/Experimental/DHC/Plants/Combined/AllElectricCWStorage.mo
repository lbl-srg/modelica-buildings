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

  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic datChi
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller parameters (each unit)"
    annotation (
      Dialog(group="CHW loop and cooling-only chillers"),
      Placement(transformation(extent={{60,260},{80,280}})));

  final parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    min(chi.TChiWatSup_nominal, chiHea.TChiWatSup_nominal)
    "Design (minimum) CHW supply temperature";
  final parameter Modelica.Units.SI.HeatFlowRate QChiWat_flow_nominal=
    chi.QChiWat_flow_nominal + chiCoo.QChiWatCas_flow_nominal
    "Cooling design heat flow rate (all units)";
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)=
    nChi * mChiWatChi_flow_nominal + nChiHea * mChiWatChiHea_flow_nominal
    "CHW design mass flow rate (all units)";
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_min=
    max(mChiWatChi_flow_min, mChiWatChiCoo_flow_min)
    "Largest chiller minimum CHW mass flow rate";

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
  parameter Modelica.Units.SI.MassFlowRate mChiWatChiCoo_flow_min(
    final min=0)=1 / 11 / 4186 * abs(chiCoo.QChiWatCas_flow_nominal)
    "Chiller CHW minimum mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mHeaWatChiHea_flow_min(
    final min=0)=1 / 11 / 4186 * abs(chiHea.QHeaWatCas_flow_nominal)
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

  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic datChiHea
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller parameters (each unit)"
    annotation (
      Dialog(group="HW loop and heat recovery chillers"),
      Placement(transformation(extent={{160,260},{180,280}})));

  final parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=
    chiHea.THeaWatSup_nominal
    "Design (maximum) HW supply temperature";
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWat_flow_nominal=
    chiHea.QHeaWatCas_flow_nominal
    "Heating design heat flow rate (all units)";
  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=
    chiHea.mConWat_flow_nominal
    "HW design mass flow rate (all units)";
  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_min=
    mHeaWatChiHea_flow_min
    "Chiller minimum HW mass flow rate";

  // CW loop, TES tank and heat pumps
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
    displayUnit="Pa")=max(
    sum({dpConChi_nominal, dpBalConChi_nominal, chi.dpValveCon_nominal}),
    sum({dpConChiHea_nominal, dpBalConChiHea_nominal, chiCoo.dpValveCon_nominal}))
    "Design head of CW pump serving condenser barrels (each unit)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.PressureDifference dpPumConWatEva_nominal(
    final min=0,
    displayUnit="Pa")=
    sum({dpEvaChiHea_nominal, dpBalEvaChiHea_nominal, chiHea.dpValveEva_nominal})
    "Design head of CW pump serving evaporator barrels (each unit)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  final parameter Modelica.Units.SI.MassFlowRate mConWatCon_flow_nominal(
    final min=0)=chi.mConWat_flow_nominal + chiCoo.mConWat_flow_nominal
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
    QHeaWat_flow_nominal * 2 * 3600 / dTStoTan / 4186 / 1000
    "FIXME (use rho_default, cp_default): Tank volume"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  final parameter Modelica.Units.SI.TemperatureDifference dTStoTan = 20
    "FIXME (use TConWat_min, TConWat_max): Tank maximum deltaT"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.Length hTan = (VTan / Modelica.Constants.pi)^0.33
    "Height of tank (without insulation)"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.Length dIns
    "Thickness of insulation"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Modelica.Units.SI.ThermalConductivity kIns=0.04
    "Specific heat conductivity of insulation"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Integer nSeg(min=2) = 20
    "Number of volume segments"
    annotation(Dialog(group="CW loop, TES tank and heat pumps", tab="Advanced"));

  // Cooling tower loop
  parameter Integer nCoo(final min=1, start=1)
    "Number of cooling tower cells operating at design conditions"
    annotation (Dialog(group="Cooling tower loop"),
      Evaluate=true);

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  // Outside connectors
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-340,260},{-300,300}}),
        iconTransformation(extent={{-380,240},{-300,320}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet(
    final unit="Pa",
    final min=0)
    "CHW differential pressure setpoint (for local dp sensor)"
    annotation (Placement(transformation(extent={{-340,220},{-300,260}}),
        iconTransformation(extent={{-380,200},{-300,280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K",
    displayUnit="degC")
    "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-340,-260},{-300,-220}}),
        iconTransformation(extent={{-380,160},{-300,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatSet(
    final unit="Pa",
    final min=0)
    "HW differential pressure setpoint (for local dp sensor)"
    annotation (Placement(transformation(extent={{-340,-300},{-300,-260}}),
        iconTransformation(extent={{-380,120},{-300,200}})));

  // Components - CHW loop and cooling-only chillers
  Subsystems.ChillerGroup chi(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium,
    final have_switchOver=false,
    final is_cooling=true,
    final typValEva=Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition,
    final typValCon=Buildings.Experimental.DHC.Types.Valve.TwoWayModulating,
    final dat=datChi,
    final nUni=nChi,
    final dpEva_nominal=dpEvaChi_nominal,
    final dpCon_nominal=dpConChi_nominal,
    final dpBalEva_nominal=dpBalEvaChi_nominal,
    final dpBalCon_nominal=dpBalConChi_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal)
    "Cooling-only chillers"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Subsystems.MultiplePumpsDp pumChiWat(
    redeclare final package Medium=Medium,
    final nPum=nPumChiWat,
    final have_var=true,
    final have_valve=true,
    final mPum_flow_nominal=mChiWat_flow_nominal / nPumChiWat,
    final dpPum_nominal=dpChiWatSet_max,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{80,190},{100,210}})));
  Fluid.FixedResistances.Junction junChiWatChiCooSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal={mChiWat_flow_nominal,-mChiWat_flow_nominal,chiCoo.mChiWat_flow_nominal},
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
        origin={40,200})));
  Fluid.FixedResistances.Junction junChiWatChiCooRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal={mChiWat_flow_nominal,-mChiWat_flow_nominal,-chiCoo.mChiWat_flow_nominal},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-280,-180})));
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
  // PICV model sized at design flow (instead of minimum flow) for convenience.
  Fluid.Actuators.Valves.TwoWayPressureIndependent valChiWatMinByp(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    final dpValve_nominal=dpEvaChi_nominal,
    final allowFlowReversal=allowFlowReversal)
    "CHW minimum flow bypass valve"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
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
        origin={140,200})));

  // Components - HW loop and heat recovery chillers
  Subsystems.ChillerGroup chiHea(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final have_switchOver=true,
    final is_cooling=false,
    final typValEva=Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition,
    final typValCon=Buildings.Experimental.DHC.Types.Valve.TwoWayModulating,
    final dat=datChiHea,
    final nUni=nChiHea,
    final TCasEnt_nominal=TCasEvaEnt_nominal,
    final dpEva_nominal=dpEvaChiHea_nominal,
    final dpCon_nominal=dpConChiHea_nominal,
    final dpBalEva_nominal=dpBalEvaChiHea_nominal,
    final dpBalCon_nominal=dpBalConChiHea_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal)
    "Heat recovery chillers operating in heating mode"
    annotation (Placement(transformation(extent={{-10,-96},{10,-76}})));
  Subsystems.ChillerGroup chiCoo(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final have_switchOver=true,
    final is_cooling=true,
    final typValEva=Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition,
    final typValCon=Buildings.Experimental.DHC.Types.Valve.TwoWayModulating,
    final dat=datChiHea,
    final nUni=nChiHea,
    final TCasEnt_nominal=TCasConEnt_nominal,
    final dpEva_nominal=dpEvaChiHea_nominal,
    final dpCon_nominal=dpConChiHea_nominal,
    final dpBalEva_nominal=dpBalEvaChiHea_nominal,
    final dpBalCon_nominal=dpBalConChiHea_nominal,
    final energyDynamics=energyDynamics)
    "Heat recovery chillers operating in cooling mode"
    annotation (Placement(transformation(extent={{-10,-156},{10,-136}})));
  Subsystems.MultiplePumpsDp pumHeaWat(
    redeclare final package Medium=Medium,
    final nPum=nPumHeaWat,
    final have_var=true,
    final have_valve=true,
    final mPum_flow_nominal=mHeaWat_flow_nominal/nPumHeaWat,
    final dpPum_nominal=dpHeaWatSet_max,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal) "Primary HW pumps"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
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
    final allowFlowReversal=allowFlowReversal)
    "HW minimum flow bypass valve"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={180,-140})));
  Fluid.Sensors.RelativePressure dpHeaWat(
    redeclare final package Medium =Medium)
    "HW differential pressure (local sensor hardwired to plant controller)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,-140})));
  Fluid.Sensors.TemperatureTwoPort THeaWatPriRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal) "Primary HW return temperature"
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
    final allowFlowReversal=allowFlowReversal)
    "CW pumps serving condenser barrels"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Subsystems.MultiplePumpsSpeed pumConWatEva(
    redeclare final package Medium = Medium,
    final nPum=nPumConWatEva,
    final have_var=true,
    final have_valve=true,
    final mPum_flow_nominal=mConWatEva_flow_nominal / nPumConWatEva,
    final dpPum_nominal=dpPumConWatEva_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps serving evaporator barrels"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
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
        origin={-80,-140})));
  Fluid.Storage.Stratified tan(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWat_flow_nominal,
    final VTan=VTan,
    final hTan=hTan,
    final dIns=dIns,
    final kIns=kIns,
    final nSeg=nSeg)
    "TES tank"
    annotation (Placement(transformation(extent={{-190,-110},{-170,-90}})));
  Fluid.FixedResistances.Junction junConWatTanEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWat_flow_nominal*{1,-1,-1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Bidirectional) "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-200,40})));
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
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={60,60})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TTan[nSeg]
    "TES tank temperature sensor gateway"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-180,-70})));
  HeatTransfer.Sources.PrescribedTemperature out "Outdoor temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-160,-70}})));

  // Controls
  replaceable Controls.OpenLoop ctl
    constrainedby Controls.BaseClasses.PartialController(
      final nChi=nChi,
      final nPumChiWat=nPumChiWat,
      final nChiHea=nChiHea,
      final nPumHeaWat=nPumHeaWat,
      final nPumConWatCon=nPumConWatCon,
      final nPumConWatEva=nPumConWatEva,
      final nCoo=nCoo)
    "Controller"
    annotation (Placement(transformation(extent={{-280,100},{-240,160}})));

  Modelica.Blocks.Sources.RealExpression sumPHea(y=chiHea.P + 0)
    "Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{270,270},{290,290}})));
  Modelica.Blocks.Sources.RealExpression sumPCoo(y=chi.P + chiCoo.P)
    "Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{270,230},{290,250}})));
  Modelica.Blocks.Sources.RealExpression sumPFan(y=0)
    "Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{270,190},{290,210}})));
  Modelica.Blocks.Sources.RealExpression sumPPum(y=pumChiWat.P + pumHeaWat.P +
        pumConWatCon.P + pumConWatEva.P + 0)
    "Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{270,150},{290,170}})));


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
          {240,-40},{240,80},{190,80}}, color={0,127,255}));
  connect(dpChiWat.port_b, junChiWatRet.port_1)
    annotation (Line(points={{240,130},{240,80},{190,80}}, color={0,127,255}));
  connect(junHeaWatSup.port_3, valHeaWatMinByp.port_a)
    annotation (Line(points={{180,-90},{180,-130}}, color={0,127,255}));
  connect(valHeaWatMinByp.port_b, junHeaWatRet.port_3)
    annotation (Line(points={{180,-150},{180,-190}}, color={0,127,255}));
  connect(THeaWatPriRet.port_a, junHeaWatRet.port_2)
    annotation (Line(points={{160,-200},{170,-200}}, color={0,127,255}));
  connect(dpHeaWat.port_b, junHeaWatRet.port_1) annotation (Line(points={{260,
          -150},{260,-200},{190,-200}},
                                  color={0,127,255}));
  connect(junHeaWatSup.port_2, port_bSerHea) annotation (Line(points={{190,-80},
          {290,-80},{290,0},{300,0}}, color={0,127,255}));
  connect(ctl.y1Chi, chi.y1Chi) annotation (Line(points={{-238,159},{-32,159},{-32,
          149},{-12,149}},     color={255,0,255}));
  connect(ctl.yValConChi, chi.yValCon) annotation (Line(points={{-238,155},{-238,
          156},{-6,156},{-6,152}},                   color={0,0,127}));
  connect(ctl.y1ValEvaChi, chi.y1ValEva) annotation (Line(points={{-238,157},{-34,
          157},{-34,128},{-9,128}},                             color={255,0,255}));
  connect(TChiWatSupSet, chi.TSet) annotation (Line(points={{-320,280},{-24,280},
          {-24,131},{-12,131}}, color={0,0,127}));
  connect(ctl.y1PumChiWat, pumChiWat.y1) annotation (Line(points={{-238,152},{60,
          152},{60,208},{78,208}},  color={255,0,255}));
  connect(dpChiWatSet, pumChiWat.dp_in) annotation (Line(points={{-320,240},{70,
          240},{70,204},{78,204}}, color={0,0,127}));
  connect(ctl.y1PumHeaWat, pumHeaWat.y1) annotation (Line(points={{-238,137},{-226,
          137},{-226,116},{80,116},{80,-72},{98,-72}},
                                    color={255,0,255}));
  connect(dpHeaWatSet, pumHeaWat.dp_in) annotation (Line(points={{-320,-280},{80,
          -280},{80,-76},{98,-76}}, color={0,0,127}));
  connect(THeaWatSupSet, chiHea.TSet) annotation (Line(points={{-320,-240},{-38,
          -240},{-38,-95},{-12,-95}}, color={0,0,127}));
  connect(ctl.y1ChiHea, chiHea.y1Chi) annotation (Line(points={{-238,146},{-40,146},
          {-40,-77},{-12,-77}}, color={255,0,255}));
  connect(ctl.y1CooChiHea, chiHea.y1Coo) annotation (Line(points={{-238,144},{-42,
          144},{-42,-86},{-12,-86}},  color={255,0,255}));
  connect(ctl.y1ValEvaChiHea, chiHea.y1ValEva) annotation (Line(points={{-238,142},
          {-44,142},{-44,-100},{-9,-100},{-9,-98}},  color={255,0,255}));
  connect(ctl.yValConChiHea, chiHea.yValCon)
    annotation (Line(points={{-238,140},{-60,140},{-60,-60},{-6,-60},{-6,-74}},
                                                             color={0,0,127}));
  connect(ctl.yValChiWatMinByp, valChiWatMinByp.y) annotation (Line(points={{-238,
          149},{-222,149},{-222,160},{160,160},{160,140},{168,140}},
                                                 color={0,0,127}));
  connect(ctl.yValHeaWatMinByp, valHeaWatMinByp.y) annotation (Line(points={{-238,
          134},{-220,134},{-220,-160},{160,-160},{160,-140},{168,-140}},
                                                   color={0,0,127}));
  connect(THeaWatPriRet.port_b, mHeaWatPri_flow.port_a)
    annotation (Line(points={{140,-200},{130,-200}}, color={0,127,255}));
  connect(TChiWatPriRet.port_b, mChiWatPri_flow.port_a)
    annotation (Line(points={{140,80},{130,80}}, color={0,127,255}));
  connect(mChiWatPri_flow.port_b, chi.port_a2) annotation (Line(points={{110,80},
          {20,80},{20,134},{10,134}}, color={0,127,255}));
  connect(chi.port_b2, junChiWatChiCooSup.port_1) annotation (Line(points={{-10,134},
          {-40,134},{-40,200},{30,200}},      color={0,127,255}));
  connect(junChiWatChiCooSup.port_2, pumChiWat.port_a)
    annotation (Line(points={{50,200},{80,200}}, color={0,127,255}));
  connect(ctl.y1ChiHea, chiCoo.y1Chi) annotation (Line(points={{-238,146},{-140,
          146},{-140,144},{-40,144},{-40,-137},{-12,-137}},
                                              color={255,0,255}));
  connect(ctl.y1CooChiHea, chiCoo.y1Coo) annotation (Line(points={{-238,144},{-42,
          144},{-42,-146},{-12,-146}},               color={255,0,255}));
  connect(ctl.y1ValEvaChiHea, chiCoo.y1ValEva) annotation (Line(points={{-238,142},
          {-44,142},{-44,-162},{-9,-162},{-9,-158}},               color={255,0,
          255}));
  connect(ctl.yValConChiHea, chiCoo.yValCon) annotation (Line(points={{-238,140},
          {-60,140},{-60,-120},{-6,-120},{-6,-134}},
                                color={0,0,127}));
  connect(TChiWatSupSet, chiCoo.TSet) annotation (Line(points={{-320,280},{-290,
          280},{-290,-158},{-16,-158},{-16,-155},{-12,-155}},
                                        color={0,0,127}));
  connect(port_aSerHea, junChiWatChiCooRet.port_1) annotation (Line(points={{-300,0},
          {-280,0},{-280,-170}},    color={0,127,255}));
  connect(junChiWatChiCooRet.port_2, junHeaWatRet.port_1) annotation (Line(
        points={{-280,-190},{-280,-220},{260,-220},{260,-200},{190,-200}},
        color={0,127,255}));
  connect(junChiWatChiCooRet.port_3, chiCoo.port_a2) annotation (Line(points={{-270,
          -180},{20,-180},{20,-152},{10,-152}}, color={0,127,255}));
  connect(chiCoo.port_b2, junChiWatChiCooSup.port_3) annotation (Line(points={{-10,
          -152},{-60,-152},{-60,-128},{40,-128},{40,190}},     color={0,127,255}));
  connect(ctl.y1PumConWatCon, pumConWatCon.y1) annotation (Line(points={{-238,131},
          {-230,131},{-230,-132},{-142,-132}},          color={255,0,255}));
  connect(ctl.y1PumConWatEva, pumConWatEva.y1) annotation (Line(points={{-238,127},
          {-164,127},{-164,48},{-162,48}},     color={255,0,255}));
  connect(ctl.yPumConWatCon, pumConWatCon.y) annotation (Line(points={{-238,129},
          {-232,129},{-232,-136},{-142,-136}},
                                             color={0,0,127}));
  connect(ctl.yPumConWatEva, pumConWatEva.y) annotation (Line(points={{-238,125},
          {-168,125},{-168,44},{-162,44}},     color={0,0,127}));
  connect(sumPHea.y, PHea)
    annotation (Line(points={{291,280},{320,280}}, color={0,0,127}));
  connect(sumPCoo.y, PCoo) annotation (Line(points={{291,240},{298.5,240},{
          298.5,240},{320,240}}, color={0,0,127}));
  connect(sumPFan.y, PFan)
    annotation (Line(points={{291,200},{320,200}}, color={0,0,127}));
  connect(sumPPum.y, PPum) annotation (Line(points={{291,160},{300,160},{300,
          160},{320,160}}, color={0,0,127}));
  connect(junHeaWatSup.port_2, dpHeaWat.port_a) annotation (Line(points={{190,-80},
          {260,-80},{260,-130}}, color={0,127,255}));
  connect(mHeaWatPri_flow.port_b, chiHea.port_a1) annotation (Line(points={{110,
          -200},{-20,-200},{-20,-80},{-10,-80}},
                                           color={0,127,255}));
  connect(pumConWatEva.port_b, chiHea.port_a2) annotation (Line(points={{-140,40},
          {20,40},{20,-92},{10,-92}},  color={0,127,255}));
  connect(pumConWatCon.port_b, junConWatEnt.port_1)
    annotation (Line(points={{-120,-140},{-90,-140}},  color={0,127,255}));
  connect(junConWatEnt.port_2, chiCoo.port_a1)
    annotation (Line(points={{-70,-140},{-10,-140}}, color={0,127,255}));
  connect(chiHea.port_b1, pumHeaWat.port_a)
    annotation (Line(points={{10,-80},{100,-80}}, color={0,127,255}));
  connect(junConWatEnt.port_3, chi.port_a1) annotation (Line(points={{-80,-130},
          {-80,146},{-10,146}},  color={0,127,255}));
  connect(pumChiWat.port_b, TChiWatSup.port_a)
    annotation (Line(points={{100,200},{130,200}}, color={0,127,255}));
  connect(TChiWatSup.port_b, junChiWatSup.port_1)
    annotation (Line(points={{150,200},{170,200}}, color={0,127,255}));
  connect(junConWatTanEnt.port_2, tan.port_a)
    annotation (Line(points={{-200,30},{-200,-100},{-190,-100}},
                                                           color={0,127,255}));
  connect(junConWatTanEnt.port_3, pumConWatEva.port_a)
    annotation (Line(points={{-190,40},{-160,40}}, color={0,127,255}));
  connect(chi.port_b1, junConWatLvg.port_1) annotation (Line(points={{10,146},{100,
          146},{100,60},{70,60}}, color={0,127,255}));
  connect(chiCoo.port_b1, junConWatLvg.port_3)
    annotation (Line(points={{10,-140},{60,-140},{60,50}}, color={0,127,255}));
  connect(junConWatLvg.port_2, junConWatTanEnt.port_1)
    annotation (Line(points={{50,60},{-200,60},{-200,50}}, color={0,127,255}));
  connect(tan.port_b, pumConWatCon.port_a) annotation (Line(points={{-170,-100},
          {-160,-100},{-160,-140},{-140,-140}}, color={0,127,255}));
  connect(tan.heaPorVol, TTan.port)
    annotation (Line(points={{-180,-100},{-180,-80}}, color={191,0,0}));
  connect(out.port, tan.heaPorTop) annotation (Line(points={{-160,-80},{-178,-80},
          {-178,-92.6}}, color={191,0,0}));
  connect(out.port, tan.heaPorSid) annotation (Line(points={{-160,-80},{-174.4,-80},
          {-174.4,-100}}, color={191,0,0}));
  connect(out.port, tan.heaPorBot) annotation (Line(points={{-160,-80},{-166,-80},
          {-166,-107.4},{-178,-107.4}}, color={191,0,0}));
  connect(weaBus.TDryBul, out.T) annotation (Line(
      points={{1,266},{0,266},{0,260},{-120,260},{-120,-80},{-138,-80}},
      color={255,204,51},
      thickness=0.5));
  connect(pumHeaWat.port_b, THeaWatSup.port_a)
    annotation (Line(points={{120,-80},{140,-80}}, color={0,127,255}));
  connect(THeaWatSup.port_b, junHeaWatSup.port_1)
    annotation (Line(points={{160,-80},{170,-80}}, color={0,127,255}));
annotation (
  defaultComponentName="pla", Documentation(info="<html>
<p>
Credit \"Discussions with Taylor Engineers\" (Gill, 2021).
</p>

<h4>Sizing</h4>
<p>
Tank sized to store <i>2</i> hours of peak heating load with 
a &Delta;T of <i>20</i>&nbsp;°C (heels and thermocline neglected).
A default heigth to diameter ratio of <i>2</i> is also taken into
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
