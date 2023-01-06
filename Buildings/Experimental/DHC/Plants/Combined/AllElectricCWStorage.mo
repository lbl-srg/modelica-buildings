within Buildings.Experimental.DHC.Plants.Combined;
model AllElectricCWStorage
  "All-electric CHW and HW plant with CW storage"
  extends BaseClasses.PartialPlant(
    final typ=Buildings.Experimental.DHC.Types.DistrictSystemType.CombinedGeneration2to4,
    final have_fan=true,
    final have_pum=true,
    final have_eleHea=true,
    final have_eleCoo=true);

  // CHW loop and cooling-only chillers
  parameter Integer nChi(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="CHW loop and cooling-only chillers"),
      Evaluate=true);
  parameter Integer nPumChiWat(final min=1, start=1)=nChi + nChiCoo
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
    "Chiller CW design mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatSet_max(
    final min=0,
    displayUnit="Pa")
    "Design (maximum) HW differential pressure setpoint"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpEvaChiHea_nominal(
    final min=0,
    displayUnit="Pa")=5E4
    "Chiller evaporator design pressure drop (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpConChiHea_nominal(
    final min=0,
    displayUnit="Pa")=5E4
    "Chiller condenser design pressure drop (each unit)"
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

  // CW loop and heat pumps
  parameter Integer nPumConWatCon(final min=1, start=1)
    "Number of CW pumps serving condenser barrels at design conditions"
    annotation (Dialog(group="CW loop and heat pumps"),
      Evaluate=true);
  parameter Integer nPumConWatEva(final min=1, start=1)=nChiHea
    "Number of CW pumps serving evaporator barrels at design conditions"
    annotation (Dialog(group="CW loop and heat pumps"),
      Evaluate=true);

  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal(
    final min=0)=
    nChi * mConWatChi_flow_nominal + nChiHea * mConWatChiHea_flow_nominal
    "CW design mass flow rate (all units)";

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
        origin={180,120})));
  Fluid.Sensors.RelativePressure dpChiWat(
    redeclare final package Medium=Medium)
    "CHW differential pressure (local sensor hardwired to plant controller)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={220,120})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriRet(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mChiWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal) "Primary CHW return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={140,80})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow(
    redeclare final package Medium =Medium,
    final allowFlowReversal=allowFlowReversal)
    "Primary CHW mass flow rate"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,80})));

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
  Fluid.FixedResistances.Junction junChiHeaCooEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal*{1,-1,-1},
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Fluid junction"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-20,-200})));
  Fluid.FixedResistances.Junction junChiHeaCooLvg(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal*{1,-1,1},
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
        origin={60,-80})));
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
        origin={180,-160})));
  Fluid.Sensors.RelativePressure dpHeaWat(
    redeclare final package Medium =Medium)
    "HW differential pressure (local sensor hardwired to plant controller)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,-160})));
  Fluid.Sensors.TemperatureTwoPort THeaWatriRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "Primary HW return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={140,-200})));
  Fluid.Sensors.MassFlowRate mHeaWatPri_flow(
    redeclare final package Medium =Medium,
    final allowFlowReversal=allowFlowReversal)
    "Primary HW mass flow rate" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,-200})));

  // Components - CW loop and heat pumps
  Fluid.Sources.Boundary_pT tmpConWat(redeclare final package Medium = Medium,
      nPorts=5) "Placeholder for CW "
    annotation (Placement(transformation(extent={{-200,170},{-180,190}})));
  Subsystems.MultiplePumpsDp pumConWatCon(
    redeclare final package Medium = Medium,
    final nPum=nPumConWatCon,
    final have_var=true,
    final have_valve=true,
    final mPum_flow_nominal=mConWat_flow_nominal / nPumConWatCon,
    final dpPum_nominal=fixme,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps serving condenser barrels"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Subsystems.MultiplePumpsDp pumConWatEva(
    redeclare final package Medium = Medium,
    final nPum=nPumConWatEva,
    final have_var=true,
    final have_valve=true,
    final mPum_flow_nominal=chiCoo.mChiWat_flow_nominal / nPumConWatEva,
    final dpPum_nominal=fixme,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps serving evaporator barrels"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Fluid.Actuators.Valves.ThreeWayLinear valChiCooCon(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHeaWat_flow_nominal*{1,-1,1},
    final other_params=fixme,
    final energyDynamics=energyDynamics)
    "Directional valve for direct heat recovery from CHW to HW"
    annotation (Placement(transformation(extent={{-90,-150},{-70,-130}})));
  Fluid.FixedResistances.Junction junConWatCon(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWat_flow_nominal*{1,-1,-1},
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
        origin={-20,-20})));
  Fluid.FixedResistances.Junction junChiCooConLvg(
    redeclare final package Medium = Medium,
    final m_flow_nominal=chiCoo.mConWat_flow_nominal*{1,-1,-1},
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
        origin={60,-110})));

  // Controls
  replaceable Controls.OpenLoop ctl
    constrainedby Controls.BaseClasses.PartialController(
      final nChi=nChi,
      final nPumChiWat=nPumChiWat,
      final nChiHea=nChiHea,
      final nPumHeaWat=nPumHeaWat)
    "Controller"
    annotation (Placement(transformation(extent={{-280,100},{-240,160}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumPHea(nin=2)
    "Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{270,270},{290,290}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumPCoo(nin=2)
    "Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{270,230},{290,250}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumPPum(nin=2)
    "Sum up power drawn from all subsystems"
    annotation (Placement(transformation(extent={{270,150},{290,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tmpPFan(k=0)
    "Placeholder for fan power"
    annotation (Placement(transformation(extent={{-272,210},{-252,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tmpPHea(k=0)
    "Placeholder for electric heating power"
    annotation (Placement(transformation(extent={{-272,250},{-252,270}})));


equation
  connect(junChiWatSup.port_2, port_bSerCoo)
    annotation (Line(points={{190,200},{240,200},{240,-40},{300,-40}},
                                                   color={0,127,255}));
  connect(junChiWatSup.port_3, valChiWatMinByp.port_a)
    annotation (Line(points={{180,190},{180,130}}, color={0,127,255}));
  connect(valChiWatMinByp.port_b, junChiWatRet.port_3)
    annotation (Line(points={{180,110},{180,90}}, color={0,127,255}));
  connect(junChiWatSup.port_2, dpChiWat.port_a) annotation (Line(points={{190,200},
          {220,200},{220,130}}, color={0,127,255}));
  connect(TChiWatPriRet.port_a, junChiWatRet.port_2)
    annotation (Line(points={{150,80},{170,80}}, color={0,127,255}));
  connect(port_aSerCoo, junChiWatRet.port_1) annotation (Line(points={{-300,-40},
          {220,-40},{220,80},{190,80}}, color={0,127,255}));
  connect(dpChiWat.port_b, junChiWatRet.port_1)
    annotation (Line(points={{220,110},{220,80},{190,80}}, color={0,127,255}));
  connect(junHeaWatSup.port_3, valHeaWatMinByp.port_a)
    annotation (Line(points={{180,-90},{180,-150}}, color={0,127,255}));
  connect(valHeaWatMinByp.port_b, junHeaWatRet.port_3)
    annotation (Line(points={{180,-170},{180,-190}}, color={0,127,255}));
  connect(junHeaWatSup.port_2, dpHeaWat.port_a) annotation (Line(points={{190,-80},
          {260,-80},{260,-150}}, color={0,127,255}));
  connect(THeaWatriRet.port_a, junHeaWatRet.port_2)
    annotation (Line(points={{150,-200},{170,-200}}, color={0,127,255}));
  connect(dpHeaWat.port_b, junHeaWatRet.port_1) annotation (Line(points={{260,
          -170},{260,-200},{190,-200}},
                                  color={0,127,255}));
  connect(chi.port_b1, tmpConWat.ports[1]) annotation (Line(points={{10,146},{20,
          146},{20,178.4},{-180,178.4}}, color={0,127,255}));
  connect(junHeaWatSup.port_2, port_bSerHea) annotation (Line(points={{190,-80},
          {290,-80},{290,0},{300,0}}, color={0,127,255}));
  connect(chiHea.port_b2, tmpConWat.ports[2]) annotation (Line(points={{-10,-92},
          {-60,-92},{-60,179.2},{-180,179.2}}, color={0,127,255}));
  connect(ctl.y1Chi, chi.y1Chi) annotation (Line(points={{-238,157.8},{-32,157.8},
          {-32,149},{-12,149}},color={255,0,255}));
  connect(ctl.yValConChi, chi.yValCon) annotation (Line(points={{-238,153.8},{-238,
          74},{-28,74},{-28,158},{-6,158},{-6,152}}, color={0,0,127}));
  connect(ctl.y1ValEvaChi, chi.y1ValEva) annotation (Line(points={{-238,155.8},{
          -68,155.8},{-68,76},{-30,76},{-30,120},{-9,120},{-9,128}},
                                                                color={255,0,255}));
  connect(TChiWatSupSet, chi.TSet) annotation (Line(points={{-320,280},{-24,280},
          {-24,131},{-12,131}}, color={0,0,127}));
  connect(ctl.y1PumChiWat, pumChiWat.y1) annotation (Line(points={{-238,150.8},{
          60,150.8},{60,208},{78,208}},
                                    color={255,0,255}));
  connect(dpChiWatSet, pumChiWat.dp_in) annotation (Line(points={{-320,240},{70,
          240},{70,204},{78,204}}, color={0,0,127}));
  connect(ctl.y1PumHeaWat, pumHeaWat.y1) annotation (Line(points={{-238,134},{60,
          134},{60,-72},{98,-72}},  color={255,0,255}));
  connect(dpHeaWatSet, pumHeaWat.dp_in) annotation (Line(points={{-320,-280},{80,
          -280},{80,-76},{98,-76}}, color={0,0,127}));
  connect(THeaWatSupSet, chiHea.TSet) annotation (Line(points={{-320,-240},{-38,
          -240},{-38,-95},{-12,-95}}, color={0,0,127}));
  connect(ctl.y1ChiHea, chiHea.y1Chi) annotation (Line(points={{-238,142.8},{-40,
          142.8},{-40,-77},{-12,-77}},
                                color={255,0,255}));
  connect(ctl.y1CooChiHea, chiHea.y1Coo) annotation (Line(points={{-238,140.8},{
          -42,140.8},{-42,-86},{-12,-86}},
                                      color={255,0,255}));
  connect(ctl.y1ValEvaChiHea, chiHea.y1ValEva) annotation (Line(points={{-238,138.8},
          {-44,138.8},{-44,-100},{-9,-100},{-9,-98}},color={255,0,255}));
  connect(ctl.yValConChiHea, chiHea.yValCon)
    annotation (Line(points={{-238,136.8},{-6,136.8},{-6,-74}},
                                                             color={0,0,127}));
  connect(ctl.yValChiWatMinByp, valChiWatMinByp.y) annotation (Line(points={{-238,
          145.8},{-220,145.8},{-220,120},{168,120}},
                                                 color={0,0,127}));
  connect(ctl.yValHeaWatMinByp, valHeaWatMinByp.y) annotation (Line(points={{-238,
          129.2},{-230,129.2},{-230,130},{-222,130},{-222,-160},{168,-160}},
                                                   color={0,0,127}));
  connect(THeaWatriRet.port_b, mHeaWatPri_flow.port_a)
    annotation (Line(points={{130,-200},{110,-200}}, color={0,127,255}));
  connect(pumHeaWat.port_b, junHeaWatSup.port_1)
    annotation (Line(points={{120,-80},{170,-80}}, color={0,127,255}));
  connect(TChiWatPriRet.port_b, mChiWatPri_flow.port_a)
    annotation (Line(points={{130,80},{110,80}}, color={0,127,255}));
  connect(mChiWatPri_flow.port_b, chi.port_a2) annotation (Line(points={{90,80},
          {20,80},{20,134},{10,134}}, color={0,127,255}));
  connect(pumChiWat.port_b, junChiWatSup.port_1)
    annotation (Line(points={{100,200},{170,200}}, color={0,127,255}));
  connect(chi.port_b2, junChiWatChiCooSup.port_1) annotation (Line(points={{-10,134},
          {-40,134},{-40,200},{30,200}},      color={0,127,255}));
  connect(junChiWatChiCooSup.port_2, pumChiWat.port_a)
    annotation (Line(points={{50,200},{80,200}}, color={0,127,255}));
  connect(sumPHea.y, PHea)
    annotation (Line(points={{292,280},{320,280}}, color={0,0,127}));
  connect(sumPCoo.y, PCoo)
    annotation (Line(points={{292,240},{320,240}}, color={0,0,127}));
  connect(sumPPum.y, PPum)
    annotation (Line(points={{292,160},{320,160}}, color={0,0,127}));
  connect(pumChiWat.P, sumPPum.u[1]) annotation (Line(points={{102,204},{260,204},
          {260,159.5},{268,159.5}}, color={0,0,127}));
  connect(pumHeaWat.P, sumPPum.u[2]) annotation (Line(points={{122,-76},{260,-76},
          {260,160.5},{268,160.5}}, color={0,0,127}));
  connect(tmpPFan.y, PFan) annotation (Line(points={{-250,220},{280,220},{280,200},
          {320,200}}, color={0,0,127}));
  connect(chi.P, sumPCoo.u[1]) annotation (Line(points={{12,149},{256,149},{256,
          239.5},{268,239.5}}, color={0,0,127}));
  connect(chiCoo.P, sumPCoo.u[2]) annotation (Line(points={{12,-137},{264,-137},
          {264,240.5},{268,240.5}}, color={0,0,127}));
  connect(chiHea.P, sumPHea.u[1]) annotation (Line(points={{12,-77},{30,-77},{30,
          -60},{250,-60},{250,279.5},{268,279.5}}, color={0,0,127}));
  connect(tmpPHea.y, sumPHea.u[2]) annotation (Line(points={{-250,260},{240,260},
          {240,280.5},{268,280.5}}, color={0,0,127}));
  connect(ctl.y1ChiHea, chiCoo.y1Chi) annotation (Line(points={{-238,142.8},{-238,
          64.75},{-40,64.75},{-40,-137},{-12,-137}},
                                              color={255,0,255}));
  connect(ctl.y1CooChiHea, chiCoo.y1Coo) annotation (Line(points={{-238,140.8},{
          -238,62.75},{-42,62.75},{-42,-146},{-12,-146}},
                                                     color={255,0,255}));
  connect(ctl.y1ValEvaChiHea, chiCoo.y1ValEva) annotation (Line(points={{-238,
          138.8},{-238,62.75},{-44,62.75},{-44,-162},{-9,-162},{-9,-158}},
                                                                   color={255,0,
          255}));
  connect(ctl.yValConChiHea, chiCoo.yValCon) annotation (Line(points={{-238,136.8},
          {-6,136.8},{-6,-134}},color={0,0,127}));
  connect(TChiWatSupSet, chiCoo.TSet) annotation (Line(points={{-320,280},{-290,
          280},{-290,-155},{-12,-155}}, color={0,0,127}));
  connect(port_aSerHea, junChiWatChiCooRet.port_1) annotation (Line(points={{-300,0},
          {-280,0},{-280,-170}},    color={0,127,255}));
  connect(junChiWatChiCooRet.port_2, junHeaWatRet.port_1) annotation (Line(
        points={{-280,-190},{-280,-220},{260,-220},{260,-200},{190,-200}},
        color={0,127,255}));
  connect(junChiWatChiCooRet.port_3, chiCoo.port_a2) annotation (Line(points={{-270,
          -180},{20,-180},{20,-152},{10,-152}}, color={0,127,255}));
  connect(chiCoo.port_b2, junChiWatChiCooSup.port_3) annotation (Line(points={{-10,
          -152},{-60,-152},{-60,-120},{40,-120},{40,190}},     color={0,127,255}));
  connect(pumConWatEva.port_b, valChiCooCon.port_1)
    annotation (Line(points={{-120,-140},{-90,-140}}, color={0,127,255}));
  connect(valChiCooCon.port_2, chiCoo.port_a1)
    annotation (Line(points={{-70,-140},{-10,-140}}, color={0,127,255}));
  connect(tmpConWat.ports[3], pumConWatEva.port_a) annotation (Line(points={{-180,
          180},{-180,-140},{-140,-140}},   color={0,127,255}));
  connect(mHeaWatPri_flow.port_b, junChiHeaCooEnt.port_1)
    annotation (Line(points={{90,-200},{-10,-200}}, color={0,127,255}));
  connect(junChiHeaCooEnt.port_2, valChiCooCon.port_3) annotation (Line(points={
          {-30,-200},{-80,-200},{-80,-150}}, color={0,127,255}));
  connect(ctl.yValChiCooHea, valChiCooCon.y)
    annotation (Line(points={{-238,126},{-80,126},{-80,-128}},
                                                            color={0,0,127}));
  connect(junChiHeaCooEnt.port_3, chiHea.port_a1) annotation (Line(points={{-20,
          -190},{-20,-80},{-10,-80}}, color={0,127,255}));
  connect(chiHea.port_b1,junChiHeaCooLvg. port_1)
    annotation (Line(points={{10,-80},{50,-80}}, color={0,127,255}));
  connect(junChiHeaCooLvg.port_2, pumHeaWat.port_a)
    annotation (Line(points={{70,-80},{100,-80}}, color={0,127,255}));
  connect(tmpConWat.ports[4], pumConWatCon.port_a) annotation (Line(points={{-180,
          180.8},{-180,-20},{-140,-20},{-140,-20}}, color={0,127,255}));
  connect(pumConWatCon.port_b, junConWatCon.port_1)
    annotation (Line(points={{-120,-20},{-30,-20}}, color={0,127,255}));
  connect(junConWatCon.port_3, chi.port_a1) annotation (Line(points={{-20,-10},{
          -20,146},{-10,146}}, color={0,127,255}));
  connect(junConWatCon.port_2, chiHea.port_a2) annotation (Line(points={{-10,-20},
          {20,-20},{20,-92},{10,-92}}, color={0,127,255}));
  connect(junChiCooConLvg.port_2, junChiHeaCooLvg.port_3)
    annotation (Line(points={{60,-100},{60,-90}}, color={0,127,255}));
  connect(chiCoo.port_b1, junChiCooConLvg.port_1) annotation (Line(points={{10,-140},
          {60,-140},{60,-120}}, color={0,127,255}));
  connect(junChiCooConLvg.port_3, tmpConWat.ports[5]) annotation (Line(points={{
          50,-110},{-60,-110},{-60,181.6},{-180,181.6}}, color={0,127,255}));
annotation (
  defaultComponentName="pla", Documentation(info="<html>
<p>
Credit \"Discussions with Taylor Engineers\" (Gill, 2021).
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
