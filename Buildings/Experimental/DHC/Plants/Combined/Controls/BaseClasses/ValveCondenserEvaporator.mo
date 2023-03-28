within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block ValveCondenserEvaporator
  "Controller for chiller and HRC condenser and evaporator valves"

  parameter Integer nChi(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="CHW loop and cooling-only chillers"),
      Evaluate=true);
  parameter Integer nChiHea(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
      Evaluate=true);
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal
    "Chiller CHW design mass flow rate (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_min
    "Chiller CHW minimum mass flow rate (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal
    "Chiller CW design mass flow rate (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpEvaChi_nominal(displayUnit="Pa")
    "Chiller evaporator design pressure drop (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.PressureDifference dpValEvaChi_nominal(
      displayUnit="Pa")
    "Chiller evaporator isolation valve design pressure drop (each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChiHea_flow_nominal
    "HRC CHW design mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChiHea_flow_min
    "HRC CHW minimum mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mConWatChiHea_flow_nominal
    "HRC CW design mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mHeaWatChiHea_flow_min
    "Chiller HW minimum mass flow rate (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpEvaChiHea_nominal(
      displayUnit="Pa")
    "Design chiller evaporator  pressure drop (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.PressureDifference dpValEvaChiHea_nominal(
      displayUnit="Pa")
    "HRC evaporator isolation valve design pressure drop (each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.Temperature TTanSet[2, 2]
    "Tank temperature setpoints: 2 cycles with 2 setpoints"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));
  parameter Real k(min=0)=0.01
    "Gain of controller"
    annotation (Dialog(group="Control parameters"));
  parameter Modelica.Units.SI.Time Ti=60
    "Time constant of integrator block"
    annotation (Dialog(group="Control parameters"));
  parameter Real yMin=0.1
    "Lower limit of valve opening when control loop enabled"
    annotation (Dialog(group="Control parameters"));
  parameter Real y_reset=1
    "Value to which the controller output is reset if the boolean trigger has a rising edge"
    annotation (Dialog(group="Control parameters"));
  parameter Real y_neutral=0
    "Value to which the controller output is reset when the controller is disabled"
    annotation (Dialog(group="Control parameters"));
  parameter Real yBalEvaChi = if dpEvaChiHea_nominal + dpValEvaChiHea_nominal - dpEvaChi_nominal <= 0
    then 1 else (dpValEvaChi_nominal / (dpEvaChiHea_nominal + dpValEvaChiHea_nominal - dpEvaChi_nominal))^0.5
    "Chiller evaporator isolation valve opening for flow balancing with HRC";
  parameter Real yBalEvaChiHea = if dpEvaChi_nominal + dpValEvaChi_nominal - dpEvaChiHea_nominal <= 0
    then 1 else (dpValEvaChiHea_nominal / (dpEvaChi_nominal + dpValEvaChi_nominal - dpEvaChiHea_nominal))^0.5
    "HRC evaporator isolation valve opening for flow balancing with chiller";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput idxCycTan(final min=1,
      final max=2)
    "Index of active tank cycle"
    annotation (Placement(transformation(extent={{-280,80},{-240,120}}),
    iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode(final min=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.tankCharge,
      final max=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.heatRejection)
    "Condenser loop operating mode"
    annotation (Placement(transformation(extent={{-280,160},{-240,200}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Chi[nChi]
    "Cooling-only chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-260,360}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,180})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiHea[nChiHea]
    "HRC On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-260,-60}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,160})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooChiHea[nChiHea]
    "HRC cooling mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-260,-80}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,140})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaCooChiHea[nChiHea]
    "HRC direct heat recovery switchover command: true for direct HR, false for cascading"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-260,-100}),
                           iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaLvgChiHea[nChiHea](each final
            unit="K", each displayUnit="degC")
    "HRC evaporator barrel leaving temperature"
                                               annotation (Placement(
        transformation(extent={{-280,20},{-240,60}}),   iconTransformation(
          extent={{-140,-160},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChiSet_flow(final
      unit="kg/s") "Chiller evaporator flow setpoint" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-260,400}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChiHeaSet_flow(final
            unit="kg/s") "HRC evaporator flow setpoint" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-260,0}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChi_flow[nChi](
    each final unit="kg/s")
    "Chiller evaporator mass flow rate" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-260,300}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConChi_flow[nChi](
    each final unit="kg/s")
    "Chiller condenser mass flow rate" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-260,280}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChiHea_flow[nChiHea](
    each final unit="kg/s")
    "HRC evaporator mass flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-260,-20}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatEvaEnt(final unit="K",
      displayUnit="degC") "HRC evaporator entering CW temperature " annotation (
     Placement(transformation(extent={{-280,-500},{-240,-460}}),
        iconTransformation(extent={{-140,-200},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConChiHea_flow[nChiHea](
    each final unit="kg/s")
    "HRC condenser mass flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-260,-140}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConEntChiHeaSet(final unit="K",
      displayUnit="degC") "HRC condenser entering temperature setpoint"
     annotation (Placement(
        transformation(extent={{-280,-420},{-240,-380}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConEntChiHea[nChiHea](each final
      unit="K", each displayUnit="degC") "HRC condenser entering temperature"
    annotation (Placement(transformation(extent={{-280,-460},{-240,-420}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConLvgChiHea[nChiHea](each final
            unit="K", each displayUnit="degC")
    "HRC condenser barrel leaving temperature" annotation (Placement(
        transformation(extent={{-280,200},{-240,240}}), iconTransformation(
          extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConLvgChi[nChi](each final
      unit="K", each displayUnit="degC")
    "Chiller condenser barrel leaving temperature" annotation (Placement(
        transformation(extent={{-280,220},{-240,260}}), iconTransformation(
          extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatConRet(final unit=
       "K", displayUnit="degC") "CWC return temperature"
    annotation (Placement(transformation(extent={{-280,120},{-240,160}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWat
    "Enable signal for lead CHW pump"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,340}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,180})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWat
    "Enable signal for lead HW pump"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,-340}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,160})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatCon
    "Enable signal for lead CW pump serving evaporator loop"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,300}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,140})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatEva
    "Enable signal for lead CW pump serving evaporator loop"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,-300}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaChi[nChi]
    "Cooling-only chiller evaporator isolation valve commanded position"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,-20}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConChi[nChi](each final
      unit="1")
    "Cooling-only chiller condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,-40}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaChiHea[nChiHea](each final
            unit="1") "HRC evaporator isolation valve commanded position"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,-80}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConChiHea[nChiHea](each final
            unit="1") "HRC condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,-100}),
                          iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaSwiChiHea[nChiHea](
      each final unit="1") "HRC evaporator switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,-200}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConSwiChiHea[nChiHea](
      each final unit="1") "HRC condenser switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,-240}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConWatEvaMix
    "HRC evaporator CW mixing valve commanded position" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,-440}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-100})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValChiWatMinByp(final unit=
        "1") "CHW minimum flow bypass valve control signal" annotation (
      Placement(transformation(extent={{240,440},{280,480}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValHeaWatMinByp(final unit=
        "1") "HW minimum flow bypass valve control signal" annotation (
      Placement(transformation(extent={{240,400},{280,440}}),
        iconTransformation(extent={{100,40},{140,80}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valEvaChi[nChi](
    each k=k,
    each Ti=Ti,
    each final yMin=yMin,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=y_reset,
    each final y_neutral=y_neutral)
    "Chiller evaporator isolation valve control when HRC in direct HR"
    annotation (Placement(transformation(extent={{-110,390},{-90,410}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valConChi[nChi](
    each k=k,
    each Ti=Ti,
    each final yMin=yMin,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=y_reset,
    each final y_neutral=y_neutral) "Chiller condenser isolation valve control"
    annotation (Placement(transformation(extent={{70,350},{90,370}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valEvaChiHea[nChiHea](
    each k=4*k,
    each Ti=Ti/3,
    each final yMin=yMin,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=y_reset,
    each final y_neutral=y_neutral) "HRC evaporator isolation valve control"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valConChiHea[nChiHea](
    each k=k,
    each Ti=Ti,
    each final yMin=yMin,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=y_reset,
    each final y_neutral=y_neutral)
    "HRC condenser isolation valve control"
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yValConSwi[nChiHea]
    "HRC condenser switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,-240})));
  Buildings.Controls.OBC.CDL.Logical.Not hea[nChiHea] "Return true if heating"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-190,-240})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nChiHea](
    each final integerTrue=1,
    each final integerFalse=0) "Convert"
    annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numHeaAndOn(nin=nChiHea)
    "Number of HRC connected to HW loop and On"
    annotation (Placement(transformation(extent={{-50,-250},{-30,-230}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes[nChiHea]
    "Return true if switchover valve to be open for heating operation"
    annotation (Placement(transformation(extent={{30,-250},{50,-230}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(
    final nout=nChiHea)
    "Replicate"
    annotation (Placement(transformation(extent={{-24,-250},{-4,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaOrCooCon[nChiHea]
    "Return true if switchover valve to be open for heating or cooling operation"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-240})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndOn[nChiHea]
    "Return true if heating AND On" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-240})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idx[nChiHea](final k={i
        for i in 1:nChiHea}) "HRC index"
    annotation (Placement(transformation(extent={{-24,-290},{-4,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Or cooOrDir[nChiHea]
    "Return true if cooling OR direct HR" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-190,-200})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yValEvaSwi[nChiHea]
    "HRC evaporator switchover valve commanded position" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={180,-200})));
  Buildings.Controls.OBC.CDL.Logical.Not heaAndCas[nChiHea]
    "Return true if cascading heating" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-154,-200})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nChiHea]
    "Convert"
    annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numHeaAndCasAndOn(nin=nChiHea)
    "Number of HRC in cascading heating AND On"
    annotation (Placement(transformation(extent={{-52,-210},{-32,-190}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep1(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-24,-210},{-4,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes1[nChiHea]
    "Return true if switchover valve to be open for heating operation"
    annotation (Placement(transformation(extent={{30,-210},{50,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaOrCooEva[nChiHea]
    "Return true if switchover valve to be open for heating or cooling operation"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,-200})));
  Buildings.Controls.OBC.CDL.Logical.And cooOrDirAndOn[nChiHea]
    "Return true if (cooling OR direct HR) AND On"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-160})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndCasAndOn[nChiHea]
    "Return true if cascading heating AND On"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-200})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe[nChiHea](each t=0.1,
      each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{190,-90},{170,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe1[nChiHea](each t=
       0.1, each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{190,-130},{170,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe2[nChi](each t=0.1,
      each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{190,-30},{170,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe3[nChi](each t=0.1,
      each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{150,-50},{130,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And cooOrDirAndOnAndOpe[nChiHea]
    "Return true if HRC (cooling OR direct HR) AND On AND isolation valve open"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={130,380})));
  Buildings.Controls.OBC.CDL.Logical.And onAndOpe[nChi]
    "Return true if On AND isolation valve open" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,340})));
  Buildings.Controls.OBC.CDL.Logical.And onAndOpe1[nChi]
    "Return true if On AND isolation valve open" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,300})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumChiWat(nin=nChi+nChiHea)
    "Enable signal for lead CHW pump"
                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={180,340})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumConWatCon(nin=nChi+nChiHea+1)
    "Enable signal for lead CW pump serving condenser loop"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={180,300})));
  Buildings.Controls.OBC.CDL.Logical.And cooAndOpe[nChiHea]
    "Return true if cooling (necessarily cascading) AND isolation valve open"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,270})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumHeaWat(nin=nChiHea)
    "Enable signal for lead HW pump"
                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={220,-340})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumConWatEva(nin=nChiHea)
    "Enable signal for lead CW pump serving evaporator loop"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={180,-300})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndOnAndOpe[nChiHea]
    "Return true if heating AND On AND isolation valve open" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={180,-340})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndCasAndOnAndOpe[nChiHea]
    "Return true if cascading heating AND On AND isolation valve open"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,-300})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep2(final nout=nChi)
    "Replicate"
    annotation (Placement(transformation(extent={{-220,390},{-200,410}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep3(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-210,-10},{-190,10}})));
  Buildings.Controls.OBC.CDL.Logical.And dirHeaCooAndOn[nChiHea]
    "Return true if direct HR AND On"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-380})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyDirHeaCooAndOn(nin=nChiHea)
    "Return true if any HRC in direct HR AND On" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-380})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valConSwi(
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC"),
    k=k,
    Ti=Ti,
    final yMin=0,
    final yMax=1,
    final reverseActing=false,
    final y_reset=0,
    final y_neutral=0)
    "Condenser switchover valve control"
    annotation (Placement(transformation(extent={{-80,-410},{-60,-390}})));
  Modelica.Blocks.Sources.IntegerExpression idxHig(final y=max({if
        dirHeaCooAndOn[i].y then i else 1 for i in 1:nChiHea}))
    "Highest index of HRC in direct HR (defaulted to 1 if all false)"
    annotation (Placement(transformation(extent={{-220,-470},{-200,-450}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep4(final nout=
        nChiHea) "Replicate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-400})));
  Buildings.Controls.OBC.CDL.Integers.Equal equIdx[nChiHea]
    "Return true if index equals highest index of HRC in direct HR"
    annotation (Placement(transformation(extent={{20,-378},{40,-358}})));
  Modelica.Blocks.Sources.IntegerExpression idxChiHea[nChiHea](final y={i for i in
            1:nChiHea}) "HRC index"
    annotation (Placement(transformation(extent={{-50,-386},{-30,-366}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch selCtl[nChiHea]
    "Select control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-400})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer[nChiHea](each final
            k=0) "Constant" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-420})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1[nChiHea]
    "Take into account entering CW temperature control in direct HR mode"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={180,-240})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extT(final nin=nChiHea)
    "Extract value at given index"
    annotation (Placement(transformation(extent={{-180,-450},{-160,-430}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep5(final nout=
        nChiHea) "Replicate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-360})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlTConWatEvaLvg[nChiHea](
    u_s(each final unit="K", each displayUnit="degC"),
    u_m(each final unit="K", each displayUnit="degC"),
    each final k=k/2,
    each Ti=Ti,
    each final yMin=0,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=0.75,
    each final y_neutral=0.75) "HRC evaporator leaving temperature control"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor TConWatEvaLvgSet(final nin=2)
    "Extract value at given index"
    annotation (Placement(transformation(extent={{-170,50},{-150,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TConWatEvaLvgSetCst[2](
    final k=TTanSet[:, 1])
    "HRC evaporator leaving CW temperature setpoint"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-200,60})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep6(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Line valConWatEvaMix[nChiHea]
    "Mixing valve opening reset: 1 means no bypass flow"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant xVal[nChiHea,2](final
      k=fill({0,0.5}, nChiHea)) "x-value for mixing valve opening reset"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yVal[nChiHea,2](final k=
        fill({0,1}, nChiHea))
    "y-value for mixing valve opening reset: 1 means no bypass flow"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Line floEva[nChiHea]
    "HRC evaporator flow reset when On AND cascading heating"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant xFlo[nChiHea,2](final
      k=fill({0.5,1}, nChiHea)) "x-value for evaporator flow reset"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFlo[nChiHea,2](final
      k=fill({mChiWatChiHea_flow_min,mChiWatChiHea_flow_nominal}, nChiHea))
    "y-value for evaporator flow reset"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch selFloSet[nChiHea]
    "Select HRC evaporator flow setpoint based on operating mode"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlTConWatEvaEnt(
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"),
    k=k,
    Ti=Ti,
    final yMin=0,
    final yMax=1,
    final reverseActing=true,
    final y_reset=1,
    final y_neutral=1)
    "HRC evaporator entering temperature control: 1 means no bypass flow"
    annotation (Placement(transformation(extent={{-10,-470},{10,-450}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyHeaAndCasAndOn(nin=nChiHea)
    "Return true if ANY HRC cascading heating AND On" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-500})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TConWatEvaEntSet(final k=
        max(TTanSet))      "HRC evaporator entering CW temperature setpoint"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-460})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin(nin=nChiHea+1)
    "Combine outputs from evaporator entering and leaving temperature control"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={210,-440})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TConWatConRetSetCst[2](final
      k=TTanSet[:, 2]) "CW condenser loop return temperature setpoint"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-200,100})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor TConWatConRetSet(final nin=2)
    "Extract value at given index"
    annotation (Placement(transformation(extent={{-170,90},{-150,110}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlTConWatConRet(
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"),
    k=k,
    Ti=Ti,
    final yMin=0,
    final yMax=1,
    final reverseActing=false,
    final y_reset=0.2,
    final y_neutral=0.0)
    "Condenser loop CW return temperature control"
    annotation (Placement(transformation(extent={{-90,170},{-70,190}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isChaAss
    "Check if charge assist mode is active"
    annotation (Placement(transformation(extent={{-170,150},{-150,170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chaAss(final k=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.chargeAssist)
    "Charge assist mode index"
    annotation (Placement(transformation(extent={{-210,150},{-190,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Line floCon[nChi + nChiHea]
    "Condenser flow reset (normalized output)"
    annotation (Placement(transformation(extent={{130,190},{150,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant xFloCon[nChi + nChiHea,
    2](final k=fill({0,1}, nChi + nChiHea)) "x-value for flow reset"
    annotation (Placement(transformation(extent={{60,210},{80,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFloCon[nChi + nChiHea,
    2](final k=fill({0.1,1}, nChi + nChiHea))
    "y-value for condenser flow reset"
    annotation (Placement(transformation(extent={{60,170},{80,190}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter scaFloConChi[nChi](
      each final k=mConWatChi_flow_nominal) "Scale flow reset signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,360})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter scaFloConChiHea[nChiHea](
      each final k=mConWatChiHea_flow_nominal) "Scale flow reset signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-40})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlTConLvgChi[nChi +
    nChiHea](
    u_s(each final unit="K", each displayUnit="degC"),
    u_m(each final unit="K", each displayUnit="degC"),
    each k=k,
    each Ti=Ti,
    each final yMin=0,
    each final yMax=1,
    each final reverseActing=false,
    each final y_reset=0.5,
    each final y_neutral=0) "Condenser leaving temperature control"
    annotation (Placement(transformation(extent={{-70,250},{-50,270}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant tanCha(final k=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.tankCharge)
    "Tank charge/discharge mode index"
    annotation (Placement(transformation(extent={{-210,190},{-190,210}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isTanCha
    "Check if tank charge/discharge mode is active"
    annotation (Placement(transformation(extent={{-170,190},{-150,210}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator
                                                          rep9(final nout=nChi +
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep10(final nout=nChi +
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-100,250},{-80,270}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep11(final nout=nChi +
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-50,170},{-30,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one[nChi + nChiHea](
      each final k=1) "Constant" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,220})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiFloSet[nChi + nChiHea]
    "Switch condenser flow setpoint based on condenser loop operating mode"
    annotation (Placement(transformation(extent={{30,190},{50,210}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator
                                                          rep12(final nout=nChi +
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-10,190},{10,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiFloSet1[nChi + nChiHea]
    "Switch condenser flow setpoint based on condenser loop operating mode"
    annotation (Placement(transformation(extent={{-10,230},{10,250}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valChiWatMinByp[nChi +
    nChiHea](
    each k=0.01,
    each Ti=Ti,
    each final yMin=0,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=0,
    each final y_neutral=0) "CHW minimum flow bypass valve control"
    annotation (Placement(transformation(extent={{144,450},{164,470}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valHeaWatMinByp[nChiHea](
    each k=0.01,
    each Ti=Ti,
    each final yMin=0,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=0,
    each final y_neutral=0) "HW minimum flow bypass valve control"
    annotation (Placement(transformation(extent={{170,410},{190,430}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floChiWatMin[nChi +
    nChiHea](final k=1.1*cat(
        1,
        fill(mChiWatChi_flow_min, nChi),
        fill(mChiWatChiHea_flow_min, nChiHea))) "Minimum flow setpoint"
    annotation (Placement(transformation(extent={{100,450},{120,470}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floHeaWatMin[nChiHea](final k=
        1.1*fill(mHeaWatChiHea_flow_min, nChiHea))   "Minimum flow setpoint"
    annotation (Placement(transformation(extent={{100,410},{120,430}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax max2(nin=nChi + nChiHea)
    "Maximum control signal"
    annotation (Placement(transformation(extent={{200,450},{220,470}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax max3(nin=nChiHea)
    "Maximum control signal"
    annotation (Placement(transformation(extent={{200,410},{220,430}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator
                                                          rep7(final nout=nChi)
    "Replicate"
    annotation (Placement(transformation(extent={{-150,370},{-130,390}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi[nChi]
    "Condition to enable evaporator flow control loop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,500})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1[nChi](final k=
        fill(0, nChi)) "Constant"
    annotation (Placement(transformation(extent={{-70,490},{-50,510}})));
  Buildings.Controls.OBC.CDL.Logical.Not noHeaAndCooAndOn
    "Return true if NO HRC in direct HR AND On"
    annotation (Placement(transformation(extent={{-220,430},{-200,450}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyCooAndOn(nin=nChiHea)
    "Return true if ANY HRC in cascading cooling AND On"
    annotation (Placement(transformation(extent={{-220,470},{-200,490}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Condition to switch to fixed valve opening (balancing)" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,460})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator
                                                          rep8(final nout=nChi)
    "Replicate"
    annotation (Placement(transformation(extent={{-150,450},{-130,470}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1[nChi]
    "Condition to enable evaporator flow control loop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,470})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yBalChi[nChi](final k=
        fill(yBalEvaChi, nChi)) "Constant"
    annotation (Placement(transformation(extent={{-150,490},{-130,510}})));
  Buildings.Controls.OBC.CDL.Logical.Not fulOpe[nChi]
    "Condition to switch to fixed full opening"
    annotation (Placement(transformation(extent={{-110,430},{-90,450}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2[nChi]
    "Condition to enable evaporator flow control loop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,440})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one1[nChi](final k=
        fill(1, nChi)) "Constant"
    annotation (Placement(transformation(extent={{-110,490},{-90,510}})));
  Buildings.Controls.OBC.CDL.Logical.And cooAndOn[nChiHea]
    "Return true if HRC in cascading cooling AND On" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Switch selValPos[nChiHea]
    "Select HRC evaporator isolation valve command signal"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yBalChiHea[nChiHea](
      final k=fill(yBalEvaChiHea, nChiHea)) "Constant"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyCooOrDirAndOn(nin=nChiHea)
    "Return true if any HRC in (cooling OR direct HR) AND On" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-170,420})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep13(final nout=nChi)
    "Replicate"
    annotation (Placement(transformation(extent={{-150,410},{-130,430}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChiHea]
    "Convert"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max4[nChiHea] "Convert"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConWatByp(final unit="1")
    "CW chiller bypass valve control signal" annotation (Placement(
        transformation(extent={{240,80},{280,120}}, rotation=0),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-140})));
  Buildings.Controls.OBC.CDL.Logical.Not isCloConChi[nChi]
    "Check if valve closed"
    annotation (Placement(transformation(extent={{80,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allCloAndChaAndEna(nin=nChi+2)
    "Check if all valves closed AND Charge Assist mode is active"
    annotation (Placement(transformation(extent={{40,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch enaCtlValConWatByp
    "Enable CW bypass valve control"
    annotation (Placement(transformation(extent={{170,90},{190,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer2(final k=0)
    "Constant" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={140,80})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe4(t=0.1, h=5E-2)
                   "Check if valve open"
    annotation (Placement(transformation(extent={{190,130},{170,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooOrHea
    "Plant Enable signal: either cooling or heating is enabled" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-260,-40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-78,220})));
equation
  connect(u1Chi, valConChi.uEna) annotation (Line(points={{-260,360},{-220,360},
          {-220,340},{76,340},{76,348}},color={255,0,255}));
  connect(valConChi.y, yValConChi) annotation (Line(points={{92,360},{226,360},
          {226,-40},{260,-40}},
                            color={0,0,127}));
  connect(rep.y,intLes. u2) annotation (Line(points={{-2,-240},{10,-240},{10,-248},
          {28,-248}}, color={255,127,0}));
  connect(intLes.y, heaOrCooCon.u2) annotation (Line(points={{52,-240},{56,-240},
          {56,-248},{68,-248}}, color={255,0,255}));
  connect(heaOrCooCon.y, yValConSwi.u)
    annotation (Line(points={{92,-240},{118,-240}},color={255,0,255}));
  connect(numHeaAndOn.y, rep.u)
    annotation (Line(points={{-28,-240},{-26,-240}}, color={255,127,0}));
  connect(u1CooChiHea, hea.u) annotation (Line(points={{-260,-80},{-220,-80},{
          -220,-240},{-202,-240}},
                              color={255,0,255}));
  connect(u1ChiHea, heaAndOn.u1) annotation (Line(points={{-260,-60},{-216,-60},
          {-216,-220},{-130,-220},{-130,-240},{-122,-240}},
                                                      color={255,0,255}));
  connect(hea.y, heaAndOn.u2) annotation (Line(points={{-178,-240},{-134,-240},
          {-134,-248},{-122,-248}},color={255,0,255}));
  connect(heaAndOn.y, booToInt.u)
    annotation (Line(points={{-98,-240},{-82,-240}},   color={255,0,255}));
  connect(idx.y, intLes.u1) annotation (Line(points={{-2,-280},{20,-280},{20,-240},
          {28,-240}},        color={255,127,0}));
  connect(cooOrDir.y,heaAndCas. u) annotation (Line(points={{-178,-200},{-166,
          -200}},                                           color={255,0,255}));
  connect(booToInt1.y, numHeaAndCasAndOn.u)
    annotation (Line(points={{-58,-200},{-54,-200}}, color={255,127,0}));
  connect(numHeaAndCasAndOn.y, rep1.u)
    annotation (Line(points={{-30,-200},{-26,-200}}, color={255,127,0}));
  connect(rep1.y,intLes1. u2) annotation (Line(points={{-2,-200},{10,-200},{10,-208},
          {28,-208}},        color={255,127,0}));
  connect(intLes1.y, heaOrCooEva.u2) annotation (Line(points={{52,-200},{80,
          -200},{80,-208},{118,-208}},color={255,0,255}));
  connect(heaOrCooEva.y, yValEvaSwi.u)
    annotation (Line(points={{142,-200},{168,-200}},
                                                   color={255,0,255}));
  connect(u1CooChiHea, cooOrDir.u1) annotation (Line(points={{-260,-80},{-220,-80},
          {-220,-200},{-202,-200}}, color={255,0,255}));
  connect(u1HeaCooChiHea, cooOrDir.u2) annotation (Line(points={{-260,-100},{-224,
          -100},{-224,-208},{-202,-208}},color={255,0,255}));
  connect(cooOrDir.y, cooOrDirAndOn.u2) annotation (Line(points={{-178,-200},{-170,
          -200},{-170,-168},{-122,-168}}, color={255,0,255}));
  connect(u1ChiHea, cooOrDirAndOn.u1) annotation (Line(points={{-260,-60},{-216,
          -60},{-216,-160},{-122,-160}},                    color={255,0,255}));
  connect(heaAndCas.y, heaAndCasAndOn.u2) annotation (Line(points={{-142,-200},
          {-134,-200},{-134,-208},{-122,-208}},color={255,0,255}));
  connect(u1ChiHea, heaAndCasAndOn.u1) annotation (Line(points={{-260,-60},{
          -216,-60},{-216,-180},{-130,-180},{-130,-200},{-122,-200}},
                                                            color={255,0,255}));
  connect(heaAndCasAndOn.y, booToInt1.u)
    annotation (Line(points={{-98,-200},{-82,-200}}, color={255,0,255}));
  connect(booToInt.y, numHeaAndOn.u)
    annotation (Line(points={{-58,-240},{-52,-240}}, color={255,127,0}));
  connect(idx.y, intLes1.u1) annotation (Line(points={{-2,-280},{20,-280},{20,-200},
          {28,-200}},       color={255,127,0}));
  connect(cooOrDirAndOn.y, heaOrCooEva.u1)
    annotation (Line(points={{-98,-160},{100,-160},{100,-200},{118,-200}},
                                                    color={255,0,255}));
  connect(yValEvaChi, isOpe2.u) annotation (Line(points={{260,-20},{192,-20}},
                         color={0,0,127}));
  connect(yValConChi, isOpe3.u) annotation (Line(points={{260,-40},{152,-40}},
                     color={0,0,127}));
  connect(yValEvaChiHea, isOpe.u) annotation (Line(points={{260,-80},{192,-80}},
                               color={0,0,127}));
  connect(yValConChiHea, isOpe1.u) annotation (Line(points={{260,-100},{220,
          -100},{220,-120},{192,-120}},
                                color={0,0,127}));
  connect(isOpe.y, cooOrDirAndOnAndOpe.u1) annotation (Line(points={{168,-80},{
          108,-80},{108,380},{118,380}},
                                       color={255,0,255}));
  connect(cooOrDirAndOn.y, cooOrDirAndOnAndOpe.u2) annotation (Line(points={{-98,
          -160},{100,-160},{100,388},{118,388}},   color={255,0,255}));
  connect(isOpe2.y, onAndOpe.u2) annotation (Line(points={{168,-20},{116,-20},{
          116,332},{118,332}},
                         color={255,0,255}));
  connect(u1Chi, onAndOpe.u1) annotation (Line(points={{-260,360},{-220,360},{
          -220,340},{118,340}},                color={255,0,255}));
  connect(isOpe3.y, onAndOpe1.u2) annotation (Line(points={{128,-40},{112,-40},
          {112,292},{118,292}},
                         color={255,0,255}));
  connect(u1Chi, onAndOpe1.u1) annotation (Line(points={{-260,360},{-220,360},{-220,
          340},{92,340},{92,300},{118,300}}, color={255,0,255}));
  connect(onAndOpe[1:nChi].y, enaPumChiWat.u[1:nChi])
    annotation (Line(points={{142,340},{168,340}}, color={255,0,255}));
  connect(cooOrDirAndOnAndOpe[1:nChiHea].y, enaPumChiWat.u[nChi+1:nChi+nChiHea]) annotation (Line(points={{142,380},
          {160,380},{160,340},{168,340}},  color={255,0,255}));
  connect(onAndOpe1[1:nChi].y, enaPumConWatCon.u[1:nChi])
    annotation (Line(points={{142,300},{168,300}},
                                                color={255,0,255}));
  connect(u1CooChiHea, cooAndOpe.u1) annotation (Line(points={{-260,-80},{88,-80},
          {88,270},{118,270}},     color={255,0,255}));
  connect(isOpe1.y, cooAndOpe.u2) annotation (Line(points={{168,-120},{92,-120},
          {92,262},{118,262}},   color={255,0,255}));
  connect(cooAndOpe[1:nChiHea].y, enaPumConWatCon.u[nChi+1:nChi+nChiHea]) annotation (Line(points={{142,270},
          {160,270},{160,300},{168,300}},
                                   color={255,0,255}));
  connect(heaAndOn.y, heaAndOnAndOpe.u1) annotation (Line(points={{-98,-240},{
          -84,-240},{-84,-340},{168,-340}}, color={255,0,255}));
  connect(isOpe1.y, heaAndOnAndOpe.u2) annotation (Line(points={{168,-120},{160,
          -120},{160,-348},{168,-348}}, color={255,0,255}));
  connect(heaAndOnAndOpe.y, enaPumHeaWat.u)
    annotation (Line(points={{192,-340},{208,-340}}, color={255,0,255}));
  connect(heaAndCasAndOn.y, heaAndCasAndOnAndOpe.u1) annotation (Line(points={{-98,
          -200},{-90,-200},{-90,-300},{118,-300}},color={255,0,255}));
  connect(isOpe.y, heaAndCasAndOnAndOpe.u2) annotation (Line(points={{168,-80},
          {108,-80},{108,-308},{118,-308}},
                                        color={255,0,255}));
  connect(heaAndCasAndOnAndOpe.y, enaPumConWatEva.u)
    annotation (Line(points={{142,-300},{168,-300}},
                                                   color={255,0,255}));
  connect(enaPumChiWat.y, y1PumChiWat)
    annotation (Line(points={{192,340},{260,340}}, color={255,0,255}));
  connect(enaPumConWatCon.y, y1PumConWatCon)
    annotation (Line(points={{192,300},{260,300}},
                                                 color={255,0,255}));
  connect(enaPumHeaWat.y, y1PumHeaWat) annotation (Line(points={{232,-340},{260,
          -340}},                       color={255,0,255}));
  connect(rep3.u, mEvaChiHeaSet_flow)
    annotation (Line(points={{-212,0},{-260,0}},   color={0,0,127}));
  connect(yValEvaSwi.y, yValEvaSwiChiHea) annotation (Line(points={{192,-200},{
          260,-200}},                       color={0,0,127}));
  connect(enaPumConWatEva.y, y1PumConWatEva)
    annotation (Line(points={{192,-300},{260,-300}}, color={255,0,255}));
  connect(u1ChiHea, dirHeaCooAndOn.u1) annotation (Line(points={{-260,-60},{
          -216,-60},{-216,-380},{-182,-380}},
                                        color={255,0,255}));
  connect(u1HeaCooChiHea, dirHeaCooAndOn.u2) annotation (Line(points={{-260,
          -100},{-224,-100},{-224,-388},{-182,-388}},
                                              color={255,0,255}));
  connect(dirHeaCooAndOn.y, anyDirHeaCooAndOn.u)
    annotation (Line(points={{-158,-380},{-142,-380}}, color={255,0,255}));
  connect(TConEntChiHeaSet, valConSwi.u_s)
    annotation (Line(points={{-260,-400},{-82,-400}}, color={0,0,127}));
  connect(anyDirHeaCooAndOn.y, valConSwi.uEna) annotation (Line(points={{-118,
          -380},{-100,-380},{-100,-420},{-74,-420},{-74,-412}}, color={255,0,
          255}));
  connect(valConSwi.y, rep4.u)
    annotation (Line(points={{-58,-400},{-42,-400}}, color={0,0,127}));
  connect(equIdx.y, selCtl.u2) annotation (Line(points={{42,-368},{50,-368},{50,
          -400},{58,-400}}, color={255,0,255}));
  connect(rep4.y, selCtl.u1) annotation (Line(points={{-18,-400},{40,-400},{40,-392},
          {58,-392}},       color={0,0,127}));
  connect(zer.y, selCtl.u3) annotation (Line(points={{42,-420},{50,-420},{50,-408},
          {58,-408}},       color={0,0,127}));
  connect(yValConSwi.y, max1.u1) annotation (Line(points={{142,-240},{150,-240},
          {150,-234},{168,-234}}, color={0,0,127}));
  connect(max1.y, yValConSwiChiHea) annotation (Line(points={{192,-240},{260,
          -240}},                     color={0,0,127}));
  connect(selCtl.y, max1.u2) annotation (Line(points={{82,-400},{150,-400},{150,
          -246},{168,-246}}, color={0,0,127}));
  connect(TConEntChiHea, extT.u)
    annotation (Line(points={{-260,-440},{-182,-440}}, color={0,0,127}));
  connect(idxHig.y, extT.index) annotation (Line(points={{-199,-460},{-170,-460},
          {-170,-452}},                         color={255,127,0}));
  connect(extT.y, valConSwi.u_m) annotation (Line(points={{-158,-440},{-70,-440},
          {-70,-412}}, color={0,0,127}));
  connect(idxHig.y, rep5.u)
    annotation (Line(points={{-199,-460},{-110,-460},{-110,-360},{-82,-360}},
                                                      color={255,127,0}));
  connect(idxChiHea.y, equIdx.u2)
    annotation (Line(points={{-29,-376},{18,-376}},  color={255,127,0}));
  connect(rep5.y, equIdx.u1) annotation (Line(points={{-58,-360},{-20,-360},{-20,
          -368},{18,-368}},      color={255,127,0}));
  connect(heaAndCasAndOn.y, ctlTConWatEvaLvg.uEna) annotation (Line(points={{-98,
          -200},{-90,-200},{-90,20},{-104,20},{-104,48}},  color={255,0,255}));
  connect(TEvaLvgChiHea, ctlTConWatEvaLvg.u_m) annotation (Line(points={{-260,40},
          {-100,40},{-100,48}},   color={0,0,127}));
  connect(TConWatEvaLvgSetCst.y, TConWatEvaLvgSet.u)
    annotation (Line(points={{-188,60},{-172,60}},   color={0,0,127}));
  connect(idxCycTan, TConWatEvaLvgSet.index) annotation (Line(points={{-260,100},
          {-230,100},{-230,44},{-160,44},{-160,48}},    color={255,127,0}));
  connect(rep6.y, ctlTConWatEvaLvg.u_s)
    annotation (Line(points={{-118,60},{-112,60}},   color={0,0,127}));
  connect(TConWatEvaLvgSet.y, rep6.u)
    annotation (Line(points={{-148,60},{-142,60}},   color={0,0,127}));
  connect(yVal[:, 2].y, valConWatEvaMix.f2) annotation (Line(points={{-58,90},{-46,
          90},{-46,92},{-42,92}},     color={0,0,127}));
  connect(yVal[:, 1].y, valConWatEvaMix.f1) annotation (Line(points={{-58,90},{-46,
          90},{-46,104},{-42,104}},     color={0,0,127}));
  connect(xVal[:, 1].y, valConWatEvaMix.x1) annotation (Line(points={{-58,120},{
          -48,120},{-48,108},{-42,108}},  color={0,0,127}));
  connect(xVal[:, 2].y, valConWatEvaMix.x2) annotation (Line(points={{-58,120},{
          -48,120},{-48,96},{-42,96}},  color={0,0,127}));
  connect(yFlo[:, 2].y, floEva.f2) annotation (Line(points={{-58,10},{-46,10},{-46,
          12},{-42,12}},        color={0,0,127}));
  connect(yFlo[:, 1].y, floEva.f1) annotation (Line(points={{-58,10},{-46,10},{-46,
          24},{-42,24}},        color={0,0,127}));
  connect(xFlo[:, 1].y, floEva.x1) annotation (Line(points={{-58,40},{-48,40},{-48,
          28},{-42,28}},        color={0,0,127}));
  connect(xFlo[:, 2].y, floEva.x2) annotation (Line(points={{-58,40},{-48,40},{-48,
          16},{-42,16}},        color={0,0,127}));
  connect(heaAndCasAndOn.y, selFloSet.u2) annotation (Line(points={{-98,-200},{-90,
          -200},{-90,-24},{-168,-24},{-168,0},{-162,0}},    color={255,0,255}));
  connect(rep3.y, selFloSet.u3) annotation (Line(points={{-188,0},{-180,0},{-180,
          -8},{-162,-8}},        color={0,0,127}));
  connect(ctlTConWatEvaLvg.y, valConWatEvaMix.u) annotation (Line(points={{-88,
          60},{-44,60},{-44,100},{-42,100}}, color={0,0,127}));
  connect(ctlTConWatEvaLvg.y, floEva.u) annotation (Line(points={{-88,60},{-44,60},
          {-44,20},{-42,20}},        color={0,0,127}));
  connect(selFloSet.y, valEvaChiHea.u_s)
    annotation (Line(points={{-138,0},{-132,0}},     color={0,0,127}));
  connect(floEva.y, selFloSet.u1) annotation (Line(points={{-18,20},{-10,20},{-10,
          -16},{-174,-16},{-174,8},{-162,8}},         color={0,0,127}));
  connect(TConWatEvaEnt, ctlTConWatEvaEnt.u_m) annotation (Line(points={{-260,
          -480},{0,-480},{0,-472}},
                                  color={0,0,127}));
  connect(anyHeaAndCasAndOn.y, ctlTConWatEvaEnt.uEna) annotation (Line(points={{-38,
          -500},{-4,-500},{-4,-472}},                             color={255,0,255}));
  connect(heaAndCasAndOn.y, anyHeaAndCasAndOn.u) annotation (Line(points={{-98,
          -200},{-90,-200},{-90,-500},{-62,-500}},
                                            color={255,0,255}));
  connect(TConWatEvaEntSet.y, ctlTConWatEvaEnt.u_s)
    annotation (Line(points={{-38,-460},{-12,-460}},  color={0,0,127}));
  connect(ctlTConWatEvaEnt.y, mulMin.u[nChiHea+1])
    annotation (Line(points={{12,-460},{180,-460},{180,-440},{198,-440}},
                                                    color={0,0,127}));
  connect(valConWatEvaMix.y, mulMin.u[1:nChiHea]) annotation (Line(points={{-18,100},
          {0,100},{0,-440},{198,-440}},          color={0,0,127}));
  connect(mulMin.y, yValConWatEvaMix)
    annotation (Line(points={{222,-440},{260,-440}}, color={0,0,127}));
  connect(TConWatConRetSetCst.y, TConWatConRetSet.u) annotation (Line(points={{-188,
          100},{-172,100}},                            color={0,0,127}));
  connect(idxCycTan, TConWatConRetSet.index) annotation (Line(points={{-260,100},
          {-230,100},{-230,80},{-160,80},{-160,88}},    color={255,127,0}));
  connect(mode, isChaAss.u1) annotation (Line(points={{-260,180},{-180,180},{-180,
          160},{-172,160}},      color={255,127,0}));
  connect(chaAss.y, isChaAss.u2) annotation (Line(points={{-188,160},{-184,160},
          {-184,152},{-172,152}}, color={255,127,0}));
  connect(isChaAss.y, ctlTConWatConRet.uEna) annotation (Line(points={{-148,160},
          {-84,160},{-84,168}},   color={255,0,255}));
  connect(TConWatConRetSet.y, ctlTConWatConRet.u_s) annotation (Line(points={{-148,
          100},{-110,100},{-110,180},{-92,180}},       color={0,0,127}));
  connect(TConWatConRet, ctlTConWatConRet.u_m) annotation (Line(points={{-260,140},
          {-80,140},{-80,168}},   color={0,0,127}));
  connect(xFloCon[:, 1].y, floCon.x1) annotation (Line(points={{82,220},{124,220},
          {124,208},{128,208}},
                              color={0,0,127}));
  connect(xFloCon[:, 2].y, floCon.x2) annotation (Line(points={{82,220},{124,220},
          {124,196},{128,196}},
                              color={0,0,127}));
  connect(mode, isTanCha.u2) annotation (Line(points={{-260,180},{-180,180},{-180,
          192},{-172,192}}, color={255,127,0}));
  connect(tanCha.y, isTanCha.u1)
    annotation (Line(points={{-188,200},{-172,200}}, color={255,127,0}));
  connect(TConLvgChi, ctlTConLvgChi[1:nChi].u_m) annotation (Line(points={{-260,
          240},{-60,240},{-60,248}},   color={0,0,127}));
  connect(TConLvgChiHea, ctlTConLvgChi[nChi + 1:nChi + nChiHea].u_m)
    annotation (Line(points={{-260,220},{-60,220},{-60,248}},   color={0,0,127}));
  connect(isTanCha.y, rep9.u)
    annotation (Line(points={{-148,200},{-142,200}}, color={255,0,255}));
  connect(rep9.y, ctlTConLvgChi.uEna) annotation (Line(points={{-118,200},{-64,200},
          {-64,248}},       color={255,0,255}));
  connect(rep10.y, ctlTConLvgChi.u_s)
    annotation (Line(points={{-78,260},{-72,260}}, color={0,0,127}));
  connect(ctlTConWatConRet.y, rep11.u)
    annotation (Line(points={{-68,180},{-52,180}}, color={0,0,127}));
  connect(TConWatConRetSet.y, rep10.u) annotation (Line(points={{-148,100},{-110,
          100},{-110,260},{-102,260}}, color={0,0,127}));
  connect(rep12.y, swiFloSet.u2) annotation (Line(points={{12,200},{28,200}},
                          color={255,0,255}));
  connect(isChaAss.y, rep12.u)
    annotation (Line(points={{-148,160},{-20,160},{-20,200},{-12,200}},
                                                    color={255,0,255}));
  connect(rep11.y, swiFloSet.u1) annotation (Line(points={{-28,180},{16,180},{16,
          208},{28,208}},
                     color={0,0,127}));
  connect(rep9.y, swiFloSet1.u2) annotation (Line(points={{-118,200},{-56,200},
          {-56,240},{-12,240}},color={255,0,255}));
  connect(ctlTConLvgChi.y, swiFloSet1.u1) annotation (Line(points={{-48,260},{
          -20,260},{-20,248},{-12,248}},
                                     color={0,0,127}));
  connect(one.y, swiFloSet1.u3) annotation (Line(points={{-28,220},{-20,220},{-20,
          232},{-12,232}}, color={0,0,127}));
  connect(swiFloSet1.y, swiFloSet.u3) annotation (Line(points={{12,240},{20,240},
          {20,192},{28,192}}, color={0,0,127}));
  connect(swiFloSet.y, floCon.u)
    annotation (Line(points={{52,200},{128,200}}, color={0,0,127}));
  connect(yFloCon[:, 1].y, floCon.f1) annotation (Line(points={{82,180},{120,180},
          {120,204},{128,204}}, color={0,0,127}));
  connect(yFloCon[:, 2].y, floCon.f2) annotation (Line(points={{82,180},{120,180},
          {120,192},{128,192}}, color={0,0,127}));
  connect(scaFloConChi.y, valConChi.u_s)
    annotation (Line(points={{62,360},{68,360}}, color={0,0,127}));
  connect(scaFloConChiHea.y, valConChiHea.u_s)
    annotation (Line(points={{42,-40},{48,-40}},   color={0,0,127}));
  connect(floCon[nChi + 1:nChi + nChiHea].y, scaFloConChiHea.u) annotation (
      Line(points={{152,200},{160,200},{160,150},{4,150},{4,-40},{18,-40}},
        color={0,0,127}));
  connect(floCon[1:nChi].y, scaFloConChi.u) annotation (Line(points={{152,200},{
          160,200},{160,240},{32,240},{32,360},{38,360}}, color={0,0,127}));
  connect(onAndOpe.y, valChiWatMinByp[1:nChi].uEna) annotation (Line(points={{142,340},
          {150,340},{150,448}},                              color={255,0,255}));
  connect(cooOrDirAndOnAndOpe.y, valChiWatMinByp[nChi + 1:nChi + nChiHea].uEna)
    annotation (Line(points={{142,380},{160,380},{160,430},{150,430},{150,448}},
        color={255,0,255}));
  connect(heaAndOnAndOpe.y, valHeaWatMinByp.uEna) annotation (Line(points={{192,
          -340},{200,-340},{200,390},{176,390},{176,408}},
                                                         color={255,0,255}));
  connect(floChiWatMin.y, valChiWatMinByp.u_s) annotation (Line(points={{122,460},
          {142,460}},                            color={0,0,127}));
  connect(floHeaWatMin.y, valHeaWatMinByp.u_s)
    annotation (Line(points={{122,420},{168,420}}, color={0,0,127}));
  connect(max2.y, yValChiWatMinByp)
    annotation (Line(points={{222,460},{260,460}}, color={0,0,127}));
  connect(valChiWatMinByp.y, max2.u)
    annotation (Line(points={{166,460},{198,460}}, color={0,0,127}));
  connect(max3.y, yValHeaWatMinByp) annotation (Line(points={{222,420},{234,420},
          {234,420},{260,420}}, color={0,0,127}));
  connect(valHeaWatMinByp.y, max3.u)
    annotation (Line(points={{192,420},{198,420}},color={0,0,127}));
  connect(mEvaChiHea_flow, valEvaChiHea.u_m) annotation (Line(points={{-260,-20},
          {-120,-20},{-120,-12}}, color={0,0,127}));
  connect(mEvaChiHea_flow, valChiWatMinByp[nChi + 1:nChi + nChiHea].u_m)
    annotation (Line(points={{-260,-20},{96,-20},{96,436},{154,436},{154,448}},
        color={0,0,127}));
  connect(mConChi_flow, valConChi.u_m)
    annotation (Line(points={{-260,280},{80,280},{80,348}}, color={0,0,127}));
  connect(mEvaChi_flow, valEvaChi.u_m) annotation (Line(points={{-260,300},{
          -100,300},{-100,388}},
                            color={0,0,127}));
  connect(mEvaChi_flow, valChiWatMinByp[1:nChi].u_m) annotation (Line(points={{-260,
          300},{0,300},{0,440},{154,440},{154,448}},
                                     color={0,0,127}));
  connect(mConChiHea_flow, valConChiHea.u_m) annotation (Line(points={{-260,-140},
          {60,-140},{60,-52}},  color={0,0,127}));
  connect(mConChiHea_flow, valHeaWatMinByp.u_m)
    annotation (Line(points={{-260,-140},{104,-140},{104,400},{180,400},{180,
          408}},                                            color={0,0,127}));
  connect(mEvaChiSet_flow, rep2.u)
    annotation (Line(points={{-260,400},{-222,400}}, color={0,0,127}));
  connect(rep2.y, valEvaChi.u_s)
    annotation (Line(points={{-198,400},{-112,400}}, color={0,0,127}));
  connect(anyDirHeaCooAndOn.y, rep7.u) annotation (Line(points={{-118,-380},{
          -100,-380},{-100,-340},{-234,-340},{-234,380},{-152,380}},
                                                                color={255,0,255}));
  connect(zer1.y, swi.u3) annotation (Line(points={{-48,500},{-30,500},{-30,492},
          {-12,492}}, color={0,0,127}));
  connect(u1Chi, swi.u2) annotation (Line(points={{-260,360},{-20,360},{-20,500},
          {-12,500}}, color={255,0,255}));
  connect(anyDirHeaCooAndOn.y, noHeaAndCooAndOn.u) annotation (Line(points={{-118,
          -380},{-100,-380},{-100,-340},{-234,-340},{-234,440},{-222,440}},
        color={255,0,255}));
  connect(anyCooAndOn.y, and2.u1) annotation (Line(points={{-198,480},{-190,480},
          {-190,460},{-182,460}}, color={255,0,255}));
  connect(noHeaAndCooAndOn.y, and2.u2) annotation (Line(points={{-198,440},{
          -190,440},{-190,452},{-182,452}},
                                       color={255,0,255}));
  connect(and2.y, rep8.u)
    annotation (Line(points={{-158,460},{-152,460}}, color={255,0,255}));
  connect(yBalChi.y, swi1.u1) annotation (Line(points={{-128,500},{-120,500},{-120,
          478},{-72,478}}, color={0,0,127}));
  connect(rep8.y, swi1.u2) annotation (Line(points={{-128,460},{-100,460},{-100,
          470},{-72,470}}, color={255,0,255}));
  connect(fulOpe.y, swi2.u2)
    annotation (Line(points={{-88,440},{-72,440}}, color={255,0,255}));
  connect(valEvaChi.y, swi2.u3) annotation (Line(points={{-88,400},{-80,400},{
          -80,432},{-72,432}},
                           color={0,0,127}));
  connect(rep7.y, valEvaChi.uEna) annotation (Line(points={{-128,380},{-104,380},
          {-104,388}}, color={255,0,255}));
  connect(one1.y, swi2.u1) annotation (Line(points={{-88,500},{-80,500},{-80,448},
          {-72,448}}, color={0,0,127}));
  connect(swi2.y, swi1.u3) annotation (Line(points={{-48,440},{-44,440},{-44,456},
          {-76,456},{-76,462},{-72,462}}, color={0,0,127}));
  connect(swi1.y, swi.u1) annotation (Line(points={{-48,470},{-40,470},{-40,508},
          {-12,508}}, color={0,0,127}));
  connect(swi.y, yValEvaChi) annotation (Line(points={{12,500},{230,500},{230,-20},
          {260,-20}}, color={0,0,127}));
  connect(heaAndOn.y, valEvaChiHea.uEna) annotation (Line(points={{-98,-240},{-94,
          -240},{-94,-28},{-124,-28},{-124,-12}}, color={255,0,255}));
  connect(u1ChiHea, cooAndOn.u1)
    annotation (Line(points={{-260,-60},{-182,-60}}, color={255,0,255}));
  connect(u1CooChiHea, cooAndOn.u2) annotation (Line(points={{-260,-80},{-200,
          -80},{-200,-68},{-182,-68}}, color={255,0,255}));
  connect(cooAndOn.y, selValPos.u2) annotation (Line(points={{-158,-60},{-120,-60},
          {-120,-76},{-46,-76},{-46,-60},{-42,-60}},
                                     color={255,0,255}));
  connect(yBalChiHea.y, selValPos.u1) annotation (Line(points={{-58,-60},{-50,-60},
          {-50,-52},{-42,-52}},        color={0,0,127}));
  connect(valEvaChiHea.y, selValPos.u3) annotation (Line(points={{-108,0},{-100,
          0},{-100,-10},{-54,-10},{-54,-68},{-42,-68}},    color={0,0,127}));
  connect(selValPos.y, yValEvaChiHea) annotation (Line(points={{-18,-60},{220,-60},
          {220,-80},{260,-80}}, color={0,0,127}));
  connect(anyCooOrDirAndOn.y, rep13.u)
    annotation (Line(points={{-158,420},{-152,420}}, color={255,0,255}));
  connect(rep13.y, fulOpe.u) annotation (Line(points={{-128,420},{-120,420},{
          -120,440},{-112,440}}, color={255,0,255}));
  connect(cooOrDirAndOn.y, anyCooOrDirAndOn.u) annotation (Line(points={{-98,
          -160},{-80,-160},{-80,-120},{-238,-120},{-238,420},{-182,420}}, color=
         {255,0,255}));
  connect(cooAndOn.y, anyCooAndOn.u) annotation (Line(points={{-158,-60},{-140,-60},
          {-140,-46},{-236,-46},{-236,480},{-222,480}},      color={255,0,255}));
  connect(cooAndOn.y, heaOrCooCon.u1) annotation (Line(points={{-158,-60},{-140,
          -60},{-140,-260},{60,-260},{60,-240},{68,-240}},
                                     color={255,0,255}));
  connect(cooAndOn.y, valConChiHea.uEna) annotation (Line(points={{-158,-60},{-140,
          -60},{-140,-116},{56,-116},{56,-52}},      color={255,0,255}));
  connect(heaAndOn.y, booToRea.u) annotation (Line(points={{-98,-240},{-94,-240},
          {-94,-100},{18,-100}}, color={255,0,255}));
  connect(max4.y, yValConChiHea)
    annotation (Line(points={{142,-100},{260,-100}}, color={0,0,127}));
  connect(booToRea.y, max4.u2) annotation (Line(points={{42,-100},{80,-100},{80,
          -106},{118,-106}}, color={0,0,127}));
  connect(valConChiHea.y, max4.u1) annotation (Line(points={{72,-40},{80,-40},{80,
          -94},{118,-94}},    color={0,0,127}));
  connect(isOpe3.y, isCloConChi.u) annotation (Line(points={{128,-40},{112,-40},
          {112,20},{82,20}}, color={255,0,255}));
  connect(isCloConChi.y, allCloAndChaAndEna.u[1:nChi])
    annotation (Line(points={{58,20},{42,20}}, color={255,0,255}));
  connect(enaCtlValConWatByp.y, yValConWatByp)
    annotation (Line(points={{192,100},{260,100}}, color={0,0,127}));
  connect(allCloAndChaAndEna.y, enaCtlValConWatByp.u2) annotation (Line(points={
          {18,20},{12,20},{12,100},{168,100}}, color={255,0,255}));
  connect(ctlTConWatConRet.y, enaCtlValConWatByp.u1) annotation (Line(points={{-68,
          180},{-60,180},{-60,140},{160,140},{160,108},{168,108}}, color={0,0,127}));
  connect(isChaAss.y, allCloAndChaAndEna.u[nChi + 1]) annotation (Line(points={{
          -148,160},{50,160},{50,20},{42,20}}, color={255,0,255}));
  connect(zer2.y, enaCtlValConWatByp.u3) annotation (Line(points={{152,80},{160,
          80},{160,92},{168,92}}, color={0,0,127}));
  connect(yValConWatByp, isOpe4.u) annotation (Line(points={{260,100},{220,100},
          {220,140},{192,140}}, color={0,0,127}));
  connect(isOpe4.y, enaPumConWatCon.u[nChi+nChiHea+1]) annotation (Line(points={{168,140},{164,
          140},{164,300},{168,300}}, color={255,0,255}));
  connect(u1CooOrHea, allCloAndChaAndEna.u[nChi+2]) annotation (Line(points={{-260,-40},
          {-4,-40},{-4,0},{50,0},{50,20},{42,20}}, color={255,0,255}));
  annotation (
  defaultComponentName="valCmd",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,200}}),
                         graphics={
        Rectangle(
          extent={{-100,-202},{100,200}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,210},{150,250}},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-240,-520},{240,520}})),
    Documentation(info="<html>
<p>
This block implements the control logic for the chiller isolation valves,
the HRC isolation and switchover valves, the CHW and HW minimum flow
bypass valves, the HRC evaporator CW mixing valve, and the
CW chiller bypass valve.
It also computes the lead pump Enable signal for the CHW, HW, CWC and CWE
pump groups.
</p>
<h4>Chiller evaporator isolation valve</h4>
<p>
When a chiller is enabled, the valve position is controlled as follows.
</p>
<ul>
<li>
If no HRC is concurrently operating and connected to the CHW loop,
the valve is commanded to a fully open position,
</li>
<li>
If any HRC is concurrently operating in cascading cooling mode,
but no HRC is in direct heat recovery mode, the valve is
commanded to a fixed position ensuring flow balancing proportionally to
design flow.
</li>
<li>
If any HRC is concurrently operating in direct heat recovery mode, the valve
is modulated with a control loop tracking an evaporator flow setpoint
which is reset as described hereunder.
The loop output is mapped to a valve position of <i>10&nbsp;%</i> (resp. <i>100&nbsp;%</i>)
at <i>0&nbsp;%</i> (resp. <i>100&nbsp;%</i>) output signal.
The loop is biased to launch from <i>100&nbsp;%</i>.
</li>
</ul>
<p>Otherwise, the valve is commanded to a closed position.</p>
<h5>Chiller evaporator flow setpoint</h5>
<p>
The setpoint is computed based on the logic implemented in
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.DirectHeatRecovery\">
Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.DirectHeatRecovery</a>.
</p>
<h4>Chiller condenser isolation valve</h4>
<p>
When a chiller is enabled, the condenser isolation valve is modulated with a
control loop tracking a condenser flow setpoint which is reset as described hereunder.
The loop output is mapped to a valve position of <i>10&nbsp;%</i> (resp. <i>100&nbsp;%</i>)
at <i>0&nbsp;%</i> (resp. <i>100&nbsp;%</i>) output signal.
The loop is biased to launch from <i>100&nbsp;%</i>.
</p>
<p>Otherwise, the valve is commanded to a closed position.</p>
<h5>Chiller condenser flow setpoint</h5>
<p>
The condenser flow setpoint varies based on the condenser loop mode and
on the tank cycle index.
</p>
<ul>
<li>
When the condenser loop mode is Charge Assist, a control loop
maintains the condenser loop return temperature at a target setpoint
equal to the highest temperature setpoint of the active tank cycle.
The loop output is mapped to a flow setpoint of <i>10&nbsp;%</i> (resp. <i>100&nbsp;%</i>)
of design flow at <i>0&nbsp;%</i> (resp. <i>100&nbsp;%</i>) output signal.
The loop is biased to launch from <i>20&nbsp;%</i>.
</li>
<li>
When the condenser loop mode is Tank Charge/Discharge, a control loop
maintains the chiller condenser leaving temperature at target setpoint equal
to the highest temperature setpoint of the active tank cycle.
The loop output is mapped to a flow setpoint of <i>5&nbsp;%</i> (resp. <i>100&nbsp;%</i>)
of design flow at <i>0&nbsp;%</i> (resp. <i>100&nbsp;%</i>) output signal.
The loop is biased to launch from <i>50&nbsp;%</i>.
</li>
<li>
When the condenser loop mode is Heat Rejection, the condenser flow setpoint
is set at design value.
</li>
</ul>
<h4>HRC evaporator isolation valve</h4>
<p>
When a HRC is enabled, the valve position is controlled as follows.
</p>
<ul>
<li>
If the HRC is operating in cascading cooling mode, the valve is commanded
to a fixed position ensuring flow balancing proportionally to
design flow.
</li>
<li>
If the HRC is operating either in cascading heating mode or in direct
heat recovery mode, the valve is modulated with a control loop tracking
an evaporator flow setpoint which is reset as described hereunder.
The loop output is mapped to a valve position of <i>10&nbsp;%</i> (resp. <i>100&nbsp;%</i>)
at <i>0&nbsp;%</i> (resp. <i>100&nbsp;%</i>) output signal.
The loop is biased to launch from <i>100&nbsp;%</i>.
</li>
</ul>
<p>Otherwise, the valve is commanded to a closed position.</p>
<h5>HRC evaporator flow setpoint</h5>
<p>In direct heat recovery mode, the setpoint is reset based on the logic implemented in
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.DirectHeatRecovery\">
Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.DirectHeatRecovery</a>.</p>
<p>In cascading heating mode, the setpoint is reset with a control loop
that maintains the evaporator leaving temperature at target setpoint
equal to the lowest temperature setpoint of the active tank cycle.
The loop output is mapped as follows.
From <i>0&nbsp;%</i> to <i>50&nbsp;%</i>, the HRC evaporator
CW mixing valve commanded position is reset from <i>0&nbsp;%</i> (full bypass flow)
to <i>100&nbsp;%</i> (no bypass flow).
From <i>50&nbsp;%</i> to <i>100&nbsp;%</i>, the
evaporator flow setpoint is reset from minimum to design value.
The loop is biased to launch from <i>75&nbsp;%</i>.
When disabled, the loop output is set to <i>75&nbsp;%</i> to
ensure that the HRC evaporator CW mixing valve is fully open
(no bypass flow).
</p>
<h4>HRC condenser isolation valve</h4>
<p>
When a HRC is enabled, the valve position is controlled as follows.
</p>
<ul>
<li>
If the HRC condenser is indexed to the HW loop (cascading heating or
direct heat recovery mode), the valve is commanded to a fully open
position.
</li>
<li>
If the HRC condenser is indexed to the CW loop (cascading cooling mode),
the valve is modulated with a control loop tracking a condenser flow setpoint
which is reset based
on the same logic as for the chiller condenser flow setpoint (see above).
The loop output is mapped to a valve position of <i>10&nbsp;%</i> (resp. <i>100&nbsp;%</i>)
at <i>0&nbsp;%</i> (resp. <i>100&nbsp;%</i>) output signal.
The loop is biased to launch from <i>100&nbsp;%</i>.
</li>
</ul>
<p>Otherwise, the valve is commanded to a closed position.</p>
<h4>HRC condenser and evaporator switchover valve</h4>
<p>
Each valve is commanded to a fully open or fully closed position depending
on the valve index and the current operating mode of the HRC (cascading cooling,
cascading heating or direct heat recovery).
In addition, the condenser switchover valve indexed to the HRC which is nearest to the
interconnection with the condenser loop (highest index) and which is operating
in direct heat recovery mode is modulated with a control loop tracking
the condenser entering temperature.
The condenser entering temperature setpoint is reset based on the logic implemented in
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.DirectHeatRecovery\">
Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.DirectHeatRecovery</a>.
This allows false loading the HRC that is controlled to meet the HW supply
temperature setpoint in direct heat recovery mode, and thus meeting
the CHW supply temperature setpoint simultaneously.
</p>
<h4>HRC evaporator CW mixing valve</h4>
<p>
The valve is modulated based on two control loops:
the HRC evaporator leaving temperature control loop (see the section
<i>HRC evaporator flow setpoint</i>) and another control loop that maintains
the HRC evaporator entering water temperature below the highest tank temperature
setpoint.
This latter control loop is enabled when any HRC is operating in cascading
heating mode.
When the loop is enabled, the loop output is mapped to a valve position
of <i>100&nbsp;%</i> (resp. <i>0&nbsp;%</i>) at <i>0&nbsp;%</i> (resp. <i>100&nbsp;%</i>)
output signal.
When the loop is disabled, the loop output is set to <i>100&nbsp;%</i> (no bypass flow).
The valve control signal is the minimum (maximum bypass flow) of the resulting
signals of those two control loops.
</p>
<h4>CHW and HW minimum flow bypass valve</h4>
<p>
Each chiller and HRC has its own CHW (resp. HW) minimum flow control loop.
The loop is enabled whenever the unit's evaporator (resp. condenser) is indexed
to the CHW (resp. HW) loop and its evaporator (resp. condenser) isolation valve
is commanded open (with a threshold of <i>10&nbsp;%</i>).
When enabled, each loop tracks a flow setpoint equal to <i>1.1</i> times the
minimum CHW (resp. HW) flow rate.
When disabled, each loop output is set to <i>0&nbsp;%</i>.
The valve control signal is the maximum (maximum bypass flow) of the resulting
signals of all control loops.
</p>
<h4>CW chiller bypass valve</h4>
<p>
The valve control is enabled when the plant is enabled either in cooling or
heating mode, the Charge Assist mode is active and
all chiller condenser isolation valves are closed (based on their
commanded position).
</p>
<p>
When the valve control is enabled the valve position is modulated
by the same control loop used to maintain the condenser loop return
temperature at a target setpoint equal to the highest temperature
setpoint of the active tank cycle (see the section \"Chiller condenser flow setpoint\").
</p>
<p>Otherwise, the valve is commanded to a closed position.</p>
<h4>CHW, HW, CWC, CWE lead pump</h4>
<p>
The lead pump of each loop is enabled whenever any chiller or HRC is indexed
to the loop and the corresponding evaporator or condenser isolation valve is
commanded open (with a threshold of <i>10&nbsp;%</i>).
In addition, the CWC lead pump may also be enabled if the CW chiller
bypass valve is commanded open.
</p>
</html>"));
end ValveCondenserEvaporator;
