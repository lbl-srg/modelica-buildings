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
  parameter Modelica.Units.SI.Temperature TCasHeaEnt_nominal=298.15
    "Design evaporator entering temperature in cascading heating mode";
  parameter Modelica.Units.SI.Temperature TCasCooEnt_nominal=288.15
    "Design condenser entering temperature in cascading cooling mode";
  final parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    dat.TEvaLvg_nominal
    "Design (minimum) CHW supply temperature";
  final parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=
    dat.TConLvg_nominal
    "Design (maximum) HW supply temperature";
  final parameter Modelica.Units.SI.HeatFlowRate QChiWatUni_flow_nominal=
    dat.QEva_flow_nominal
    "Design cooling heat flow rate (each unit, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWatUni_flow_nominal=
    -dat.QEva_flow_nominal * (1 + 1 / dat.COP_nominal * dat.etaMotor)
    "Design heating heat flow rate in direct heat recovery mode (each unit, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.Efficiency COPCasHea_nominal(fixed=false)
    "Coefficient of performance in cascading heating mode";
  final parameter Modelica.Units.SI.Efficiency COPCasCoo_nominal(fixed=false)
    "Coefficient of performance in cascading cooling mode";
  final parameter Modelica.Units.SI.Temperature TCasHeaLvg_nominal(fixed=false)
    "Design value of evaporator leaving temperature in cascading heating mode";
  final parameter Modelica.Units.SI.Temperature TCasCooLvg_nominal(fixed=false)
    "Design value of condenser leaving temperature in cascading cooling mode";
  final parameter Modelica.Units.SI.HeatFlowRate QEvaCasHeaUni_flow_nominal(
    fixed=false,
    start=QChiWatUni_flow_nominal * (1 + 2E-2 * (TCasHeaEnt_nominal -
      (dat.TEvaLvg_nominal - QChiWatUni_flow_nominal / mChiWatUni_flow_nominal / cpCas))))
    "Design evaporator heat flow rate in cascading heating mode (each unit, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QChiWatCasCooUni_flow_nominal(
    fixed=false,
    start=QChiWatUni_flow_nominal * (1 - 2E-2 * (TCasCooEnt_nominal -
      (dat.TConLvg_nominal - QHeaWatUni_flow_nominal / mConWatUni_flow_nominal / cpCas))))
    "Design cooling heat flow rate in cascading cooling mode (each unit, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWatCasHeaUni_flow_nominal=
    -QEvaCasHeaUni_flow_nominal * (1 + 1 / COPCasHea_nominal * dat.etaMotor)
    "Design heating heat flow rate in cascading heating mode (each unit, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QConCasCooUni_flow_nominal=
    -QChiWatCasCooUni_flow_nominal * (1 + 1 / COPCasCoo_nominal * dat.etaMotor)
    "Design condenser heat flow rate in cascading cooling mode (each unit, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QChiWat_flow_nominal=
    nUni * QChiWatUni_flow_nominal
    "Design cooling heat flow rate (all units, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWat_flow_nominal=
    nUni * QHeaWatUni_flow_nominal
    "Design heating heat flow rate (all units, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QEvaCasHea_flow_nominal=
    nUni * QEvaCasHeaUni_flow_nominal
    "Design evaporator heat flow rate in cascading heating mode (all units, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QChiWatCasCoo_flow_nominal=
    nUni * QChiWatCasCooUni_flow_nominal
    "Design cooling heat flow rate in cascading cooling mode (all units, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWatCasHea_flow_nominal=
    nUni * QHeaWatCasHeaUni_flow_nominal
    "Design heating heat flow rate in cascading heating mode (all units, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QConCasCoo_flow_nominal=
    nUni * QConCasCooUni_flow_nominal
    "Design condenser heat flow rate in cascading cooling mode (all units, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWatUni_flow_nominal(
    final min=0)=dat.mEva_flow_nominal
    "Design CHW mass flow rate (each unit)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWatUni_flow_nominal(
    final min=0)=dat.mCon_flow_nominal
    "Design CW mass flow rate (each unit)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)=nUni * mChiWatUni_flow_nominal
    "Design CHW mass flow rate (all units)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal(
    final min=0)=nUni * mConWatUni_flow_nominal
    "Design CW mass flow rate (all units)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(displayUnit="Pa")
    "Design evaporator pressure drop (each unit)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Design condenser pressure drop (each unit)"
    annotation(Dialog(group="Nominal condition"));

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
        origin={-60,-120})));
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
        origin={-80,-120})));
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
        origin={90,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConLvg[nUni](
    each final unit="K", each displayUnit="degC")
    "Chiller condenser leaving temperature" annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={40,160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={70,120})));

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
    each final show_T=show_T) "Chiller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Actuators.Valves.TwoWayLinear valCon[nUni](
    redeclare each final package Medium = Medium,
    each linearized=true,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final m_flow_nominal=mConWatUni_flow_nominal,
    each dpValve_nominal=1E3,
    each final dpFixed_nominal=dpCon_nominal,
    each final allowFlowReversal=allowFlowReversal,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTime,
    each final init=init,
    each final y_start=y_start) "Condenser isolation valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,80})));
  Fluid.Actuators.Valves.TwoWayLinear valEva[nUni](
    redeclare each final package Medium = Medium,
    each linearized=true,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final m_flow_nominal=mChiWatUni_flow_nominal,
    each dpValve_nominal=1E3,
    each final dpFixed_nominal=dpEva_nominal,
    each final allowFlowReversal=allowFlowReversal,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTime,
    each final init=init,
    each final y_start=y_start) "Evaporator isolation valve"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-20,-80})));
  Fluid.FixedResistances.Junction junConWatEvaOut[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mChiWatUni_flow_nominal*{1,-1,1},
    each final dp_nominal=fill(1E3, 3),
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    each final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    each final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering) "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-60})));
  Fluid.FixedResistances.Junction junConWatEvaInl[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mChiWatUni_flow_nominal*{1,-1,-1},
    each final dp_nominal=fill(1E3, 3),
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    each final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    each final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,-6})));
  Fluid.Sensors.TemperatureTwoPort temEvaLvg[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mChiWatUni_flow_nominal,
    each final allowFlowReversal=allowFlowReversal)
    "Chiller evaporator leaving temperature" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-20,-20})));
  Fluid.FixedResistances.Junction junHeaWatConInl[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mConWatUni_flow_nominal*{1,-1,-1},
    each final dp_nominal=fill(1E3, 3),
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    each final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    each final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,60})));
  Fluid.FixedResistances.Junction junHeaWatConOut[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mConWatUni_flow_nominal*{1,-1,1},
    each final dp_nominal=fill(1E3, 3),
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    each final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Bidirectional,
    each final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering) "Fluid junction"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={80,60})));
  Fluid.Sensors.TemperatureTwoPort temConEnt[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mConWatUni_flow_nominal,
    each final allowFlowReversal=allowFlowReversal)
    "Chiller condenser entering temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,20})));
  Fluid.Sensors.TemperatureTwoPort temConLvg[nUni](
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mConWatUni_flow_nominal,
    each final allowFlowReversal=allowFlowReversal)
    "Chiller condenser leaving temperature" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={20,20})));
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
  Fluid.Actuators.Valves.TwoWayLinear valConSwi[nUni](
    redeclare each final package Medium = Medium,
    each linearized=true,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final m_flow_nominal=mConWatUni_flow_nominal,
    each dpValve_nominal=1E3,
    each final dpFixed_nominal=0,
    each final allowFlowReversal=true,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTime,
    each final init=init,
    each final y_start=y_start) "Condenser switchover valve" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,20})));
  Fluid.Actuators.Valves.TwoWayLinear valEvaSwi[nUni](
    redeclare each final package Medium = Medium,
    each linearized=true,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final m_flow_nominal=mChiWatUni_flow_nominal,
    each dpValve_nominal=1E3,
    each final dpFixed_nominal=0,
    each final allowFlowReversal=true,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTime,
    each final init=init,
    each final y_start=y_start) "Evaporator switchover valve" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConEnt[nUni](each final
      unit="K", each displayUnit="degC")
    "Chiller condenser entering temperature" annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={20,160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={50,120})));
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
    QEvaCasHeaUni_flow_nominal / cpCas / mConWatUni_flow_nominal;
  TCasCooLvg_nominal = TCasCooEnt_nominal +
    QConCasCooUni_flow_nominal / cpCas / mConWatUni_flow_nominal;
  QEvaCasHeaUni_flow_nominal = dat.QEva_flow_nominal *
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
    connect(junHeaWatConOut[1:nUni - 1].port_1, junHeaWatConOut[2:nUni].port_2)
      annotation (Line(points={{80,50},{66,50},{66,70},{80,70}}, color={0,127,255}));
    connect(valEvaSwi[1:nUni - 1].port_a, junConWatEvaInl[2:nUni].port_2)
      annotation (Line(points={{60,-50},{40,-50},{40,4},{60,4}}, color={0,127,255}));
    connect(valConSwi[1:nUni - 1].port_a, junHeaWatConInl[2:nUni].port_2)
      annotation (Line(points={{-60,10},{-44,10},{-44,70},{-60,70}}, color={0,127,
            255}));
    connect(junConWatEvaOut[1:nUni - 1].port_1, junConWatEvaOut[2:nUni].port_2)
      annotation (Line(points={{-80,-70},{-60,-70},{-60,-50},{-80,-50}}, color={0,
            127,255}));
  end if;
  connect(port_a4, valEvaSwi[nUni].port_a)
    annotation (Line(points={{100,-80},{60,-80},{60,-50}}, color={0,127,255}));
  connect(yValConSwi, valConSwi.y)
    annotation (Line(points={{-40,160},{-40,20},{-48,20}}, color={0,0,127}));

  connect(y1, chi.on) annotation (Line(points={{-120,120},{-16,120},{-16,3},{-12,
          3}}, color={255,0,255}));
  connect(TSet, chi.TSet) annotation (Line(points={{-120,0},{-20,0},{-20,-3},{-12,
          -3}},      color={0,0,127}));
  connect(y1Coo, chi.coo)
    annotation (Line(points={{-120,100},{-8,100},{-8,14}}, color={255,0,255}));
  connect(yValCon, valCon.y) annotation (Line(points={{0,160},{0,80},{8,80}},
                   color={0,0,127}));
  connect(chi.port_b2, temEvaLvg.port_a)
    annotation (Line(points={{-10,-6},{-20,-6},{-20,-10}}, color={0,127,255}));
  connect(yValEva, valEva.y) annotation (Line(points={{-40,-160},{-40,-120},{-4,
          -120},{-4,-80},{-8,-80}},
                             color={0,0,127}));
  connect(temConEnt.port_b, chi.port_a1)
    annotation (Line(points={{-20,10},{-20,6},{-10,6}}, color={0,127,255}));
  connect(chi.port_b1, temConLvg.port_a)
    annotation (Line(points={{10,6},{20,6},{20,10}}, color={0,127,255}));
  connect(valCon.port_b, junHeaWatConOut.port_3)
    annotation (Line(points={{20,90},{20,100},{60,100},{60,60},{70,60}},
                                                       color={0,127,255}));
  connect(valEva.port_b,junConWatEvaOut. port_3) annotation (Line(points={{-20,-90},
          {-20,-100},{-40,-100},{-40,-60},{-70,-60}},
                                color={0,127,255}));
  connect(chi.P, mulSum.u) annotation (Line(points={{11,9},{64,9},{64,120},{68,120}},
        color={0,0,127}));
  connect(temEvaLvg.port_b, floEva.port_a)
    annotation (Line(points={{-20,-30},{-20,-40}}, color={0,127,255}));
  connect(floEva.port_b, valEva.port_a)
    annotation (Line(points={{-20,-60},{-20,-70}}, color={0,127,255}));
  connect(mulSum.y, P)
    annotation (Line(points={{92,120},{120,120}}, color={0,0,127}));
  connect(floEva.m_flow, mEva_flow)
    annotation (Line(points={{-9,-50},{2,-50},{2,-118},{60,-118},{60,-160}},
                                                           color={0,0,127}));
  connect(temEvaLvg.T, TEvaLvg) annotation (Line(points={{-9,-20},{-2,-20},{-2,-120},
          {40,-120},{40,-160}}, color={0,0,127}));
  connect(temConLvg.port_b, floCon.port_a)
    annotation (Line(points={{20,30},{20,40}}, color={0,127,255}));
  connect(floCon.port_b, valCon.port_a)
    annotation (Line(points={{20,60},{20,70}}, color={0,127,255}));
  connect(temConLvg.T, TConLvg)
    annotation (Line(points={{31,20},{40,20},{40,160}}, color={0,0,127}));
  connect(floCon.m_flow, mCon_flow) annotation (Line(points={{31,50},{62,50},{
          62,140},{60,140},{60,160}}, color={0,0,127}));
  connect(junConWatEvaInl.port_3, chi.port_a2) annotation (Line(points={{50,-6},
          {10,-6}},                  color={0,127,255}));
  connect(yValEvaSwi, valEvaSwi.y)
    annotation (Line(points={{0,-160},{0,-40},{48,-40}}, color={0,0,127}));
  connect(junHeaWatConInl.port_3, temConEnt.port_a)
    annotation (Line(points={{-50,60},{-20,60},{-20,30}}, color={0,127,255}));

  connect(port_a1, junHeaWatConInl[1].port_2)
    annotation (Line(points={{-100,80},{-60,80},{-60,70}}, color={0,127,255}));
  connect(valConSwi.port_b, junHeaWatConInl.port_1)
    annotation (Line(points={{-60,30},{-60,50}}, color={0,127,255}));
  connect(junHeaWatConOut[1].port_2, port_b1)
    annotation (Line(points={{80,70},{80,80},{100,80}}, color={0,127,255}));
  connect(valEvaSwi.port_b, junConWatEvaInl.port_1)
    annotation (Line(points={{60,-30},{60,-16}}, color={0,127,255}));
  connect(port_a2, junConWatEvaInl[1].port_2)
    annotation (Line(points={{100,30},{60,30},{60,4}}, color={0,127,255}));
  connect(junHeaWatConOut[nUni].port_1, port_b3)
    annotation (Line(points={{80,50},{80,-30},{100,-30}}, color={0,127,255}));
  connect(junConWatEvaOut[1].port_2, port_b2) annotation (Line(points={{-80,-50},
          {-80,30},{-100,30}}, color={0,127,255}));
  connect(junConWatEvaOut[nUni].port_1, port_b4) annotation (Line(points={{-80,-70},
          {-80,-80},{-100,-80}}, color={0,127,255}));
  connect(valConSwi[nUni].port_a, port_a3) annotation (Line(points={{-60,10},{
          -60,-32},{-100,-32}},
                            color={0,127,255}));

  connect(temConEnt.T, TConEnt) annotation (Line(points={{-31,20},{-32,20},{-32,
          130},{20,130},{20,160}}, color={0,0,127}));
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
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,52},{-40,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,70},{58,52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,12},{-32,12},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,-10},{-32,-10},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-10},{-40,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,52},{42,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-50},{58,-68}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,24},{62,-18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,24},{22,-8},{58,-8},{40,24}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,52},{-40,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,70},{58,52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,12},{-32,12},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,-10},{-32,-10},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-10},{-40,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,52},{42,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-50},{58,-68}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,24},{62,-18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,24},{22,-8},{58,-8},{40,24}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,140}})),
    Documentation(info="<html>
<p>
This model represents a set of identical heat recovery chillers
that are piped in parallel.
Modulating isolation valves and modulating switchover valves are included
on condenser and evaporator side.
The switchover valves allow indexing the condenser (resp. the evaporator)
either to the CWC loop or to the HW loop (resp. to the CWE loop or to
the CHW loop). Modulating valves are used to allow for sequences of
operation that bleed CWE into the HW return flow to modulate the
condenser entering temperature.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
On/Off command <code>y1</code>:
DO signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Cooling switchover command <code>y1Coo</code>:
DO signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Supply temperature setpoint <code>TSet</code>:
AO signal dedicated to each unit, with a dimensionality of one</br>
The signal corresponds either to the HW supply temperature setpoint when
the unit operates in heating mode, or to the CHW supply temperature setpoint when
the unit operates in cooling mode.
</li>
<li>
Condenser and evaporator isolation valve commanded position <code>yVal(Con|Eva)</code>:
AO signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Condenser and evaporator switchover valve commanded position <code>yVal(Con|Eva)Swi</code>:
AO signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Condenser and evaporator leaving temperature <code>T(Con|Eva)Lvg</code>:
AI signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Condenser entering temperature <code>TConEnt</code>:
AI signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Condenser and evaporator mass flow rate <code>m(Con|Eva)_flow</code>:
AI signal dedicated to each unit, with a dimensionality of one
</li>
</ul>
<h4>
Details
</h4>
<h5>
HRC performance data
</h5>
<p>
The performance data should cover the HRC lift envelope,
that is when the HRC is operating in direct heat recovery mode,
producing CHW and HW at their setpoint value at full load.
In this case, and to allow for cascading heat recovery where
a third fluid circuit is used to generate a cascade of thermodynamic cycles,
two additional parameters <code>TCasEntCoo_nominal</code> and
<code>TCasEntHea_nominal</code> are exposed to specify the
<i>entering</i> temperature of the third fluid circuit when
the HRC is operating in cooling mode and in heating mode,
respectively.
In cooling mode the third fluid circuit is connected to the
condenser barrel.
In heating mode, the third fluid circuit is connected to the
evaporator barrel.
The parameters <code>TCasEnt*_nominal</code> are then used to assess the
design capacity in heating and cooling mode, respectively.
</p>
<h5>
Actuators
</h5>
<p>
By default, linear valve models are used. Those are configured with
a pressure drop varying linearly with the flow rate, as opposed
to the quadratic dependency usually considered for a turbulent flow
regime.
This is because the whole plant model contains large nonlinear systems
of equations and this configuration limits the risk of solver failure
while reducing the time to solution.
This has no significant impact on the operating point of the circulation pumps
when a control loop is used to modulate the valve opening and maintain
the flow rate or the leaving temperature at setpoint.
Then, whatever the modeling assumptions for the valve, the
control loop ensures that the valve creates the adequate pressure drop
and flow, which will simply be reached at a different valve opening
with the above simplification.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerHeatRecoveryGroup;
