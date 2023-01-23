within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model ChillerHeatRecoveryGroup
  "Model of multiple identical heat recovery chillers in parallel"
  extends Buildings.Fluid.Interfaces.PartialEightPortInterface(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium,
    redeclare final package Medium3=Medium,
    redeclare final package Medium4=Medium,
    final m1_flow_nominal = mConWat_flow_nominal,
    final m2_flow_nominal = mChiWat_flow_nominal,
    final m3_flow_nominal = mConWat_flow_nominal,
    final m4_flow_nominal = mChiWat_flow_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal,
    final allowFlowReversal3=allowFlowReversal,
    final allowFlowReversal4=allowFlowReversal);

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model for all four fluid circuits"
    annotation (choices(
      choice(redeclare package Medium=Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
        property_T=293.15,X_a=0.40)
        "Propylene glycol water, 40% mass fraction")));

  parameter Integer nUni(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.Temperature TCasHeaEnt_nominal=25 + 273.15
    "Design value of chiller evaporator entering temperature in cascading heating mode";
  parameter Modelica.Units.SI.Temperature TCasCooEnt_nominal=15 + 273.15
    "Design value of chiller condenser entering temperature in cascading cooling mode";
  final parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    dat.TEvaLvg_nominal
    "Design (minimum) CHW supply temperature";
  final parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=
    dat.TConLvg_nominal
    "Design (maximum) HW supply temperature";
  final parameter Modelica.Units.SI.HeatFlowRate QChiWatUni_flow_nominal=
    dat.QEva_flow_nominal
    "Cooling design heat flow rate (each unit, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWatUni_flow_nominal=
    -dat.QEva_flow_nominal * (1 + 1 / dat.COP_nominal * dat.etaMotor)
    "Heating design heat flow rate in direct heat recovery mode (each unit, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.Efficiency COPCasHea_nominal(fixed=false)
    "Coefficient of performance in cascading heating mode";
  final parameter Modelica.Units.SI.Efficiency COPCasCoo_nominal(fixed=false)
    "Coefficient of performance in cascading cooling mode";
  final parameter Modelica.Units.SI.Temperature TCasHeaLvg_nominal(fixed=false)
    "Design value of chiller evaporator leaving temperature in cascading heating mode";
  final parameter Modelica.Units.SI.Temperature TCasCooLvg_nominal(fixed=false)
    "Design value of chiller condenser leaving temperature in cascading cooling mode";
  final parameter Modelica.Units.SI.HeatFlowRate QChiWatCasHeaUni_flow_nominal(
    fixed=false,
    start=QChiWatUni_flow_nominal * (1 + 2E-2 * (TCasHeaEnt_nominal -
      (dat.TEvaLvg_nominal - QChiWatUni_flow_nominal / mChiWatUni_flow_nominal / cpCas))))
    "Cooling design heat flow rate in cascading heating mode (each unit, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QChiWatCasCooUni_flow_nominal(
    fixed=false,
    start=QChiWatUni_flow_nominal * (1 - 2E-2 * (TCasCooEnt_nominal -
      (dat.TConLvg_nominal - QHeaWatUni_flow_nominal / mConWatUni_flow_nominal / cpCas))))
    "Cooling design heat flow rate in cascading cooling mode (each unit, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWatCasHeaUni_flow_nominal=
    -QChiWatCasHeaUni_flow_nominal * (1 + 1 / COPCasHea_nominal * dat.etaMotor)
    "Heating design heat flow rate in cascading heating mode (each unit, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWatCasCooUni_flow_nominal=
    -QChiWatCasCooUni_flow_nominal * (1 + 1 / COPCasCoo_nominal * dat.etaMotor)
    "Heating design heat flow rate in cascading cooling mode (each unit, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QChiWat_flow_nominal=
    nUni * QChiWatUni_flow_nominal
    "Cooling design heat flow rate (all units, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWat_flow_nominal=
    nUni * QHeaWatUni_flow_nominal
    "Heating design heat flow rate (all units, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QChiWatCasHea_flow_nominal=
    nUni * QChiWatCasHeaUni_flow_nominal
    "Cooling design heat flow rate in cascading heating mode (all units, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QChiWatCasCoo_flow_nominal=
    nUni * QChiWatCasCooUni_flow_nominal
    "Cooling design heat flow rate in cascading cooling mode (all units, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWatCasHea_flow_nominal=
    nUni * QHeaWatCasHeaUni_flow_nominal
    "Heating design heat flow rate in cascading heating mode (all units, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWatCasCoo_flow_nominal=
    nUni * QHeaWatCasCooUni_flow_nominal
    "Heating design heat flow rate in cascading cooling mode (all units, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWatUni_flow_nominal(
    final min=0)=dat.mEva_flow_nominal
    "Chiller CHW design mass flow rate (each unit)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWatUni_flow_nominal(
    final min=0)=dat.mCon_flow_nominal
    "Chiller CW design mass flow rate (each unit)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)=nUni * mChiWatUni_flow_nominal
    "CHW design mass flow rate (all units)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal(
    final min=0)=nUni * mConWatUni_flow_nominal
    "CW design mass flow rate (all units)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(
    final min=0,
    displayUnit="Pa")
    "Chiller evaporator design pressure drop (each unit)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(
    final min=0,
    displayUnit="Pa")
    "Chiller condenser design pressure drop (each unit)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpBalEva_nominal(
    final min=0,
    displayUnit="Pa")=0
    "Evaporator-side balancing valve design pressure drop (each valve)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpBalCon_nominal(
    final min=0,
    displayUnit="Pa")=0
    "Condenser-side balancing valve design pressure drop (each valve)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.PressureDifference dpValveEva_nominal(
    final min=0,
    displayUnit="Pa") = max(valEva.dpValve_nominal) + max(valEvaSwi.dpValve_nominal)
    "Total valve pressure drop on chiller evaporator circuit (each unit)"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.PressureDifference dpValveCon_nominal(
    final min=0,
    displayUnit="Pa") = max(valCon.dpValve_nominal) + max(valConSwi.dpValve_nominal)
    "Total valve pressure drop on chiller condenser circuit (each unit)"
    annotation (Dialog(group="Nominal condition"));

  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic dat
    "Chiller parameters (each unit)"
    annotation (Placement(transformation(extent={{-90,-120},{-70,-100}})));

  // Assumptions
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Boolean use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Modelica.Units.SI.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  parameter Real y_start=1 "Initial position of actuator"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1[nUni]
    "Chiller On/Off command"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1Coo[nUni]
    "Cooling switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
      iconTransformation(extent={{-20,-20},{20,20}}, rotation=0,  origin={-120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet[nUni](
    each final unit="K", each displayUnit="degC")
    "Supply temperature setpoint"
    annotation (Placement(
      transformation(extent={{-140,-20},{-100,20}}),   iconTransformation(
        extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(
    final unit="W") "Power drawn"
    annotation (Placement(transformation(extent={{100,100},{140,140}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValCon[nUni](
    each final unit="1", each final min=0, each final max=1)
    "Chiller condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,160}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-80,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValEva[nUni](
    each final unit="1", each final min=0, each final max=1)
    "Chiller evaporator isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-40,-160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-82,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mEva_flow[nUni](each final
      unit="kg/s") "Chiller evaporator barrel mass flow rate" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={60,-160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={80,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TEvaLvg[nUni](
    each final unit="K", each displayUnit="degC")
    "Chiller evaporator leaving temperature" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,-160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mCon_flow[nUni](
    each final unit="kg/s")
    "Chiller condenser barrel mass flow rate" annotation (
      Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={60,160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={80,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConLvg[nUni](
    each final unit="K", each displayUnit="degC")
    "Chiller condenser leaving temperature" annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={40,160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,120})));

  Fluid.Chillers.ElectricReformulatedEIR chi[nUni](
    PLR1(each start=0),
    each final per=dat,
    redeclare each final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    each final have_switchover=true,
    each final dp1_nominal=0,
    each final dp2_nominal=0,
    each final allowFlowReversal1=allowFlowReversal,
    each final allowFlowReversal2=allowFlowReversal,
    each final energyDynamics=energyDynamics,
    each final show_T=show_T)
    "Chiller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.FixedResistances.Junction junConWatEvaInl[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mChiWatUni_flow_nominal*{1,-1,-1},
    each final dp_nominal=fill(0, 3),
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Fluid junction"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,20})));
  Fluid.FixedResistances.Junction junConWatEvaOut[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mChiWatUni_flow_nominal*{1,-1,1},
    each final dp_nominal={0,0,1E3},
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering) "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,20})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valCon[nUni](
    redeclare each final package Medium = Medium,
    each linearized=true,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final m_flow_nominal=mConWatUni_flow_nominal,
    each dpValve_nominal=1E3,
    each final dpFixed_nominal=dpCon_nominal + dpBalCon_nominal,
    each final allowFlowReversal=allowFlowReversal,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTime,
    each final init=init,
    each final y_start=y_start)
    "Condenser isolation valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,80})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valEva[nUni](
    redeclare each final package Medium = Medium,
    each linearized=true,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final m_flow_nominal=mChiWatUni_flow_nominal,
    each dpValve_nominal=1E3,
    each final dpFixed_nominal=dpEva_nominal + dpBalEva_nominal,
    each final allowFlowReversal=allowFlowReversal,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTime,
    each final init=init,
    each final y_start=y_start)
    "Evaporator isolation valve"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,-80})));
  Fluid.FixedResistances.Junction junChiWatEvaOut[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mChiWatUni_flow_nominal*{1,-1,1},
    each final dp_nominal={0,0,1E3},
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering) "Fluid junction"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,-60})));
  Fluid.FixedResistances.Junction junChiWatEvaInl[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mChiWatUni_flow_nominal*{1,-1,-1},
    each final dp_nominal=fill(0, 3),
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={80,-60})));
  Fluid.Sensors.TemperatureTwoPort temEvaLvg[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mChiWatUni_flow_nominal,
    each final allowFlowReversal=allowFlowReversal)
    "Chiller evaporator leaving temperature" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-20,-20})));
  Fluid.Actuators.Valves.ThreeWayLinear valConSwi[nUni](
    redeclare each final package Medium = Medium,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final m_flow_nominal=mConWatUni_flow_nominal,
    each dpValve_nominal=1E3,
    each final dpFixed_nominal={0,0},
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTime,
    each final init=init,
    each final y_start=y_start,
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each linearized={true,true})
    "Condenser switchover valve: direct connected to HW, bypass connected to CW condenser circuit"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Fluid.FixedResistances.Junction junHeaWatConInl[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mConWatUni_flow_nominal*{1,-1,-1},
    each final dp_nominal=fill(0, 3),
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Fluid junction"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,60})));
  Fluid.FixedResistances.Junction junHeaWatConOut[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mConWatUni_flow_nominal*{1,-1,1},
    each final dp_nominal={0,0,1E3},
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering) "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={80,60})));
  Fluid.Actuators.Valves.ThreeWayLinear valEvaSwi[nUni](
    redeclare each final package Medium = Medium,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final m_flow_nominal=mChiWatUni_flow_nominal,
    each dpValve_nominal=1E3,
    each final dpFixed_nominal={0,0},
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTime,
    each final init=init,
    each final y_start=y_start,
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each linearized={true,true})
    "Evaporator switchover valve: bypass connected to CHW, direct connected to CW evaporator circuit"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={40,-60})));
  Fluid.FixedResistances.Junction junConWatConInl[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mConWatUni_flow_nominal*{1,-1,-1},
    each final dp_nominal=fill(0, 3),
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-20})));
  Fluid.FixedResistances.Junction junConWatConOut[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mConWatUni_flow_nominal*{1,-1,1},
    each final dp_nominal={0,0,1E3},
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering) "Fluid junction"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,-20})));
  Fluid.Sensors.TemperatureTwoPort temConEnt[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mConWatUni_flow_nominal,
    each final allowFlowReversal=allowFlowReversal)
    "Chiller condenser entering temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,30})));
  Fluid.Sensors.TemperatureTwoPort temConLvg[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mConWatUni_flow_nominal,
    each final allowFlowReversal=allowFlowReversal)
    "Chiller condenser leaving temperature" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={20,20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValConSwi[nUni](
    each final unit="1",
    each final min=0,
    each final max=1) "Chiller condenser switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-60,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValEvaSwi[nUni](
    each final unit="1",
    each final min=0,
    each final max=1) "Chiller evaporator switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={0,-160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-62,-120})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=nUni)
    "Sum up power of all units"
    annotation (Placement(transformation(extent={{70,110},{90,130}})));
  Fluid.Sensors.MassFlowRate floEva[nUni](
    redeclare each final package Medium =Medium,
    each final allowFlowReversal=allowFlowReversal)
    "Chiller evaporator barrel mass flow rate" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-20,-50})));
  Fluid.Sensors.MassFlowRate floCon[nUni](
    redeclare each final package Medium =Medium,
    each final allowFlowReversal=allowFlowReversal)
    "Chiller condenser barrel mass flow rate" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={20,50})));
protected
  parameter Medium.ThermodynamicState staCas=Medium.setState_pTX(
    T=(TCasHeaEnt_nominal + TCasCooEnt_nominal) / 2,
    p=Medium.p_default,
    X=Medium.X_default)
    "State of source medium in cascading mode (at mean source temperature)";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCas=
    Medium.specificHeatCapacityCp(state=staCas)
    "Heat capacity of source medium in cascading mode";
initial equation
  TCasHeaLvg_nominal = TCasHeaEnt_nominal +
    QChiWatCasHeaUni_flow_nominal / cpCas / mConWatUni_flow_nominal;
  TCasCooLvg_nominal = TCasCooEnt_nominal +
    QHeaWatCasCooUni_flow_nominal / cpCas / mConWatUni_flow_nominal;
  QChiWatCasHeaUni_flow_nominal = dat.QEva_flow_nominal *
    Buildings.Utilities.Math.Functions.biquadratic(
      a=dat.capFunT,
      x1=Modelica.Units.Conversions.to_degC(TCasHeaLvg_nominal),
      x2=Modelica.Units.Conversions.to_degC(THeaWatSup_nominal));
  QChiWatCasCooUni_flow_nominal = dat.QEva_flow_nominal *
    Buildings.Utilities.Math.Functions.biquadratic(
      a=dat.capFunT,
      x1=Modelica.Units.Conversions.to_degC(TChiWatSup_nominal),
      x2=Modelica.Units.Conversions.to_degC(TCasCooLvg_nominal));
  COPCasHea_nominal = dat.COP_nominal /
    Buildings.Utilities.Math.Functions.biquadratic(
      a=dat.EIRFunT,
      x1=Modelica.Units.Conversions.to_degC(TCasCooLvg_nominal),
      x2=Modelica.Units.Conversions.to_degC(THeaWatSup_nominal));
  COPCasCoo_nominal = dat.COP_nominal /
    Buildings.Utilities.Math.Functions.biquadratic(
      a=dat.EIRFunT,
      x1=Modelica.Units.Conversions.to_degC(TChiWatSup_nominal),
      x2=Modelica.Units.Conversions.to_degC(TCasCooLvg_nominal));
equation
  if nUni > 1 then
    for i in 1:(nUni - 1) loop
      connect(junConWatEvaOut[i].port_1, junConWatEvaOut[i + 1].port_2);
      connect(junConWatEvaInl[i].port_2, junConWatEvaInl[i + 1].port_1);
      connect(junConWatConOut[i].port_1, junConWatConOut[i + 1].port_2);
      connect(junConWatConInl[i].port_2, junConWatConInl[i + 1].port_1);
      connect(junHeaWatConOut[i].port_1, junHeaWatConOut[i+1].port_2);
      connect(junHeaWatConInl[i].port_2, junHeaWatConInl[i+1].port_1);
      connect(junChiWatEvaOut[i].port_1, junChiWatEvaOut[i + 1].port_2);
      connect(junChiWatEvaInl[i].port_2, junChiWatEvaInl[i + 1].port_1);
    end for;
  end if;

  connect(y1, chi.on) annotation (Line(points={{-120,120},{-16,120},{-16,3},{-12,
          3}}, color={255,0,255}));
  connect(TSet, chi.TSet) annotation (Line(points={{-120,0},{-20,0},{-20,-3},{-12,
          -3}},      color={0,0,127}));
  connect(y1Coo, chi.coo)
    annotation (Line(points={{-120,100},{-8,100},{-8,14}}, color={255,0,255}));
  connect(yValCon, valCon.y) annotation (Line(points={{0,160},{0,80},{8,80}},
                   color={0,0,127}));
  connect(junChiWatEvaOut[1].port_2, port_b4)
    annotation (Line(points={{-80,-70},{-80,-80},{-100,-80}},
                                                    color={0,127,255}));
  connect(port_a4, junChiWatEvaInl[1].port_1)
    annotation (Line(points={{100,-80},{80,-80},{80,-70}},
                                                  color={0,127,255}));
  connect(junChiWatEvaInl.port_3, valEvaSwi.port_3)
    annotation (Line(points={{70,-60},{50,-60}}, color={0,127,255}));
  connect(junHeaWatConInl.port_3, valConSwi.port_1)
    annotation (Line(points={{-70,60},{-50,60}}, color={0,127,255}));
  connect(port_a1, junHeaWatConInl[1].port_1)
    annotation (Line(points={{-100,80},{-80,80},{-80,70}},
                                                  color={0,127,255}));
  connect(junHeaWatConOut[1].port_2, port_b1)
    annotation (Line(points={{80,70},{80,80},{100,80}},
                                                color={0,127,255}));
  connect(port_a2, junConWatEvaInl[1].port_1)
    annotation (Line(points={{100,30},{80,30}}, color={0,127,255}));
  connect(junConWatConOut[1].port_2, port_b3)
    annotation (Line(points={{80,-30},{100,-30}}, color={0,127,255}));
  connect(port_a3, junConWatConInl[1].port_1) annotation (Line(points={{-100,-32},
          {-80,-32},{-80,-30}}, color={0,127,255}));
  connect(junConWatConInl.port_3, valConSwi.port_3) annotation (Line(points={{-70,-20},
          {-40,-20},{-40,50}},      color={0,127,255}));
  connect(chi.port_b2, temEvaLvg.port_a)
    annotation (Line(points={{-10,-6},{-20,-6},{-20,-10}}, color={0,127,255}));
  connect(junConWatEvaInl.port_3, valEvaSwi.port_1)
    annotation (Line(points={{70,20},{40,20},{40,-50}}, color={0,127,255}));
  connect(junConWatEvaOut[1].port_2, port_b2)
    annotation (Line(points={{-80,30},{-100,30}}, color={0,127,255}));
  connect(yValEva, valEva.y) annotation (Line(points={{-40,-160},{-40,-80},{-32,
          -80}},             color={0,0,127}));
  connect(temConEnt.port_b, chi.port_a1)
    annotation (Line(points={{-20,20},{-20,6},{-10,6}}, color={0,127,255}));
  connect(chi.port_b1, temConLvg.port_a)
    annotation (Line(points={{10,6},{20,6},{20,10}}, color={0,127,255}));
  connect(valCon.port_b, junHeaWatConOut.port_3)
    annotation (Line(points={{20,90},{20,100},{60,100},{60,60},{70,60}},
                                                       color={0,127,255}));
  connect(valCon.port_b, junConWatConOut.port_3) annotation (Line(points={{20,90},
          {20,100},{60,100},{60,-20},{70,-20}},
                                              color={0,127,255}));
  connect(valEva.port_b, junChiWatEvaOut.port_3) annotation (Line(points={{-20,-90},
          {-20,-100},{-60,-100},{-60,-60},{-70,-60}},
                                color={0,127,255}));
  connect(valEva.port_b, junConWatEvaOut.port_3) annotation (Line(points={{-20,-90},
          {-20,-100},{-60,-100},{-60,20},{-70,20}},
                                                  color={0,127,255}));
  connect(valEvaSwi.port_2, chi.port_a2) annotation (Line(points={{40,-70},{40,-80},
          {20,-80},{20,-6},{10,-6}},        color={0,127,255}));
  connect(yValConSwi, valConSwi.y)
    annotation (Line(points={{-40,160},{-40,72}}, color={0,0,127}));
  connect(chi.P, mulSum.u) annotation (Line(points={{11,9},{64,9},{64,120},{68,120}},
        color={0,0,127}));
  connect(yValEvaSwi, valEvaSwi.y)
    annotation (Line(points={{0,-160},{0,-60},{28,-60}}, color={0,0,127}));
  connect(temEvaLvg.port_b, floEva.port_a)
    annotation (Line(points={{-20,-30},{-20,-40}}, color={0,127,255}));
  connect(floEva.port_b, valEva.port_a)
    annotation (Line(points={{-20,-60},{-20,-70}}, color={0,127,255}));
  connect(mulSum.y, P)
    annotation (Line(points={{92,120},{120,120}}, color={0,0,127}));
  connect(floEva.m_flow, mEva_flow)
    annotation (Line(points={{-9,-50},{60,-50},{60,-160}}, color={0,0,127}));
  connect(temEvaLvg.T, TEvaLvg) annotation (Line(points={{-9,-20},{12,-20},{12,-120},
          {40,-120},{40,-160}}, color={0,0,127}));
  connect(temConLvg.port_b, floCon.port_a)
    annotation (Line(points={{20,30},{20,40}}, color={0,127,255}));
  connect(floCon.port_b, valCon.port_a)
    annotation (Line(points={{20,60},{20,70}}, color={0,127,255}));
  connect(temConEnt.port_a, valConSwi.port_2)
    annotation (Line(points={{-20,40},{-20,60},{-30,60}}, color={0,127,255}));
  connect(temConLvg.T, TConLvg)
    annotation (Line(points={{31,20},{40,20},{40,160}}, color={0,0,127}));
  connect(floCon.m_flow, mCon_flow) annotation (Line(points={{31,50},{62,50},{
          62,140},{60,140},{60,160}}, color={0,0,127}));
  annotation (
    defaultComponentName="chi",
    Icon(coordinateSystem(preserveAspectRatio=false),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,140}})),
    Documentation(info="<html>
    <p>
    TODO: Update doc.
This model represents a set of identical chillers in parallel.
If the parameter <code>have_switchover</code> is <code>true</code>
then an additional operating mode signal <code>y1Coo</code> is used
to switch <i>On/Off</i> the chillers and actuate the chiller isolation
valves based on the following logic.
</p>
<ul>
<li>
If the parameter <code>is_cooling</code> is <code>true</code>
(resp. <code>false</code>)
then the chiller <code>#i</code> is commanded <i>On</i> if
<code>y1[i]</code> is <code>true</code> and <code>y1Coo[i]</code>
is <code>true</code> (resp. <code>false</code>).
</li>
<li>
When the chiller <code>#i</code> is commanded <i>On</i>
the isolation valve input signal <code>y*Val*[i]</code> is used to
control the valve opening.
Otherwise the valve is closed whatever the value of
<code>y*Val*[i]</code>.
</li>
<li>
Configured this way, the model represents the set of heat
recovery chillers operating in cooling mode
(resp. heating mode), i.e., tracking the CHW (resp. HW) supply
temperature setpoint.
</li>
</ul>
<p>
Note that the input signal <code>y1Coo</code> is different
from the input signal <code>coo</code> that is used in the model
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricReformulatedEIR\">
Buildings.Fluid.Chillers.ElectricReformulatedEIR</a>
where it allows switching the chiller operating mode from cooling
to heating.
The current chiller group model rather represents a set of chillers
that are <i>all</i> operating in the same mode, either cooling or heating.
The mode is fixed as specified by the parameter <code>is_cooling</code>
and each chiller which is commanded to operate in a different mode
is considered <i>Off</i>.
</p>
<h4>
Chiller performance data
</h4>
<p>
The chiller performance data should cover the chiller lift envelope,
that is when the chiller is operating in \"direct\" heat recovery mode,
i.e., producing CHW and HW at their setpoint value at full load.
In this case, and to allow for \"cascading\" heat recovery where
a third fluid circuit is used to generate a cascade of thermodynamic cycles,
two additional parameters <code>TCasEntCoo_nominal</code> and
<code>TCasEntHea_nominal</code> are exposed to specify the chiller 
<i>entering</i> temperature of the third fluid circuit when
the chiller is operating in cooling mode and in heating mode,
respectively.
In cooling mode the third fluid circuit is connected to the chiller 
condenser barrel.
In heating mode, the third fluid circuit is connected to the chiller 
evaporator barrel.
The parameters <code>TCasEnt*_nominal</code> are then used to assess the
design chiller capacity in heating and cooling mode, respectively.
The value of that parameter should typically differ when configuring
this model for heating (<code>is_cooling=false</code>) or
cooling (<code>is_cooling=true</code>).
</p>
<h4>
Details
</h4>
<h5>
Actuators
</h5>
<p>
By default linear valve models are used. Those are configured with 
a pressure drop varying linearily with the flow rate, as opposed
to the quadratic dependency usually considered for a turbulent flow
regime.
This is because the whole plant model contains large nonlinear systems 
of equations, and this configuration limits the risk of solver failure 
while reducing the time to solution.
This yields an overestimation of the pump power at variable flow which
is considered as acceptable as it mainly affects the CW 
pumps, which have a much lower head than the CHW and HW distribution 
pumps.
</p>
</html>"));
end ChillerHeatRecoveryGroup;
