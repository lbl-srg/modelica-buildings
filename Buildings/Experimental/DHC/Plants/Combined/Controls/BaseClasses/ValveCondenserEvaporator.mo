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
  parameter Modelica.Units.SI.Temperature TTanSet[2, 2]
    "Tank temperature setpoints: 2 cycles with 2 setpoints"
    annotation(Dialog(group="CW loop, TES tank and heat pumps"));

  parameter Real k(min=0)=0.05
    "Gain of controller"
    annotation (Dialog(group="Control parameters"));
  parameter Modelica.Units.SI.Time Ti(min=Buildings.Controls.OBC.CDL.Constants.small)= 60
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

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Chi[nChi]
    "Cooling-only chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,360}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,180})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiHea[nChiHea]
    "HR chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,-40}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,160})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooChiHea[nChiHea]
    "HR chiller cooling mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,-60}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,140})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaCooChiHea[nChiHea]
    "HR chiller direct heat recovery switchover command: true for direct HR, false for cascading"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,-80}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChiSet_flow(final
      unit="kg/s") "Chiller evaporator flow setpoint" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,400}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChiHeaSet_flow(final
            unit="kg/s") "HRC evaporator flow setpoint" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,0}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChi_flow[nChi](
    each final unit="kg/s")
    "Chiller evaporator mass flow rate" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,320}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConChi_flow[nChi](
    each final unit="kg/s")
    "Chiller condenser mass flow rate" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,300}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChiHea_flow[nChiHea](
    each final unit="kg/s")
    "HRC evaporator mass flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,-20}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConChiHea_flow[nChiHea](
    each final unit="kg/s")
    "HRC condenser mass flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,-120}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWat
    "Enable signal for lead CHW pump"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,340}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,180})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWat
    "Enable signal for lead HW pump"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-320}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,160})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatCon
    "Enable signal for lead CW pump serving evaporator loop"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,300}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,140})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatEva
    "Enable signal for lead CW pump serving evaporator loop"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-220}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaChi[nChi]
    "Cooling-only chiller evaporator isolation valve commanded position"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-20}),iconTransformation(
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
        origin={240,-40}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaChiHea[nChiHea](each final
            unit="1") "HRC evaporator isolation valve commanded position"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-80}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConChiHea[nChiHea](each final
            unit="1") "HRC condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-100}),
                          iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-40})));

  EnergyTransferStations.Combined.Controls.PIDWithEnable valEvaChi[nChi](
    each k=k,
    each Ti=Ti,
    each final yMin=yMin,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=y_reset,
    each final y_neutral=y_neutral)
    "Chiller evaporator isolation valve control"
    annotation (Placement(transformation(extent={{-130,390},{-110,410}})));

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
    each k=k,
    each Ti=Ti,
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
    annotation (Placement(transformation(extent={{70,-110},{90,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaSwiChiHea[nChiHea](
      each final unit="1") "HRC evaporator switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-140}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConSwiChiHea[nChiHea](
      each final unit="1") "HRC condenser switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-180}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-80})));
  Modelica.Blocks.Continuous.FirstOrder fil6[nChiHea](each T=60, each initType=
        Modelica.Blocks.Types.Init.InitialOutput)
    "Filter to break algebraic loop"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
  Modelica.Blocks.Continuous.FirstOrder fil7[nChiHea](each T=60, each initType=
        Modelica.Blocks.Types.Init.InitialOutput)
    "Filter to break algebraic loop"
    annotation (Placement(transformation(extent={{-178,-50},{-158,-30}})));
  Modelica.Blocks.Continuous.FirstOrder fil2[nChi](each T=60, each initType=
        Modelica.Blocks.Types.Init.InitialOutput)
    "Filter to break algebraic loop"
    annotation (Placement(transformation(extent={{-200,310},{-180,330}})));
  Modelica.Blocks.Continuous.FirstOrder fil3[nChi](each T=60, each initType=
        Modelica.Blocks.Types.Init.InitialOutput)
    "Filter to break algebraic loop"
    annotation (Placement(transformation(extent={{-170,290},{-150,310}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yValConSwi[nChiHea]
    "HRC condenser switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-280})));
  Buildings.Controls.OBC.CDL.Logical.Not hea[nChiHea] "Return true if heating"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-280})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nChiHea](
    each final integerTrue=1,
    each final integerFalse=0)
    "Convert"
    annotation (Placement(transformation(extent={{-80,-290},{-60,-270}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numHeaAndOn(nin=nChiHea)
    "Number of HRC connected to HW loop and On"
    annotation (Placement(transformation(extent={{-50,-290},{-30,-270}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes[nChiHea]
    "Return true if switchover valve to be open for heating operation"
    annotation (Placement(transformation(extent={{20,-290},{40,-270}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(
    final nout=nChiHea)
    "Replicate"
    annotation (Placement(transformation(extent={{-20,-290},{0,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaOrCooCon[nChiHea]
    "Return true if switchover valve to be open for heating or cooling operation"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-280})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndOn[nChiHea]
    "Return true if heating AND On" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-280})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idx[nChiHea](final k={i
        for i in 1:nChiHea}) "HRC index"
    annotation (Placement(transformation(extent={{-180,-234},{-160,-214}})));
  Buildings.Controls.OBC.CDL.Logical.And cooAndOn[nChiHea]
    "Return true if cooling AND On" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-240})));
  Buildings.Controls.OBC.CDL.Logical.Or cooOrDir[nChiHea]
    "Return true if cooling OR direct HR" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-160})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yValEvaSwi[nChiHea]
    "HRC evaporator switchover valve commanded position" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={180,-160})));
  Buildings.Controls.OBC.CDL.Logical.Not heaAndCas[nChiHea]
    "Return true if cascading heating" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-140,-200})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nChiHea]
    "Convert"
    annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numHeaAndCasAndOn(nin=nChiHea)
    "Number of HRC in cascading heating AND On"
    annotation (Placement(transformation(extent={{-52,-210},{-32,-190}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep1(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-20,-210},{0,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes1[nChiHea]
    "Return true if switchover valve to be open for heating operation"
    annotation (Placement(transformation(extent={{30,-210},{50,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaOrCooEva[nChiHea]
    "Return true if switchover valve to be open for heating or cooling operation"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,-160})));
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
    annotation (Placement(transformation(extent={{192,-70},{172,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe1[nChiHea](each t
      =0.1, each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{192,-130},{172,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe2[nChi](each t=0.1,
      each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{192,10},{172,30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe3[nChi](each t=0.1,
      each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{192,-30},{172,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And cooOrDirAndOnAndOpe[nChiHea]
    "Return true if (cooling OR direct HR) AND On AND isolation valve open"
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
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumConWatCon(nin=nChi+nChiHea)
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
        origin={132,270})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumHeaWat(nin=nChiHea)
    "Enable signal for lead HW pump"
                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-320})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumConWatEva(nin=nChiHea)
    "Enable signal for lead CW pump serving evaporator loop"
                                                         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={180,-220})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndOn1AndOpe[nChiHea]
    "Return true if heating AND On AND isolation valve open" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-320})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndCasAndOnAndOpe[nChiHea]
    "Return true if cascading heating AND On AND isolation valve open"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={140,-220})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep2(final nout=nChi)
    "Replicate"
    annotation (Placement(transformation(extent={{-200,390},{-180,410}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep3(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-210,-10},{-190,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput  TConEntChiHeaSet(final unit="K",
      displayUnit="degC") "HRC condenser entering temperature setpoint"
                                                  annotation (Placement(
        transformation(extent={{-260,-400},{-220,-360}}),
                                                       iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConEntChiHea[nChiHea](final
      unit="K", displayUnit="degC") "HRC condenser entering temperature"
    annotation (Placement(transformation(extent={{-260,-420},{-220,-380}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.And dirHeaCooAndOn[nChiHea]
    "Return true if direct HR AND On"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-360})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyDirHeaCooAndOn(nin=nChiHea)
    "Return true if any HRC in direct HR AND On" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-360})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valConSwi(
    k=k,
    Ti=Ti,
    final yMin=0,
    final yMax=1,
    final reverseActing=false,
    final y_reset=0,
    final y_neutral=0) "Condenser switchover valve control"
    annotation (Placement(transformation(extent={{-80,-390},{-60,-370}})));
  Modelica.Blocks.Sources.IntegerExpression idxHig(final y=max({if
        dirHeaCooAndOn[i].y then i else 1 for i in 1:nChiHea}))
    "Highest index of HRC in direct HR (defaulted to 1 if all false)"
    annotation (Placement(transformation(extent={{-180,-350},{-160,-330}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep4(final nout=
        nChiHea) "Replicate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,-380})));
  Buildings.Controls.OBC.CDL.Integers.Equal equIdx[nChiHea]
    "Return true if index equals highest index of HRC in direct HR"
    annotation (Placement(transformation(extent={{-10,-358},{10,-338}})));
  Modelica.Blocks.Sources.IntegerExpression idxChiHea[nChiHea](final y={i for i in
            1:nChiHea}) "HRC index"
    annotation (Placement(transformation(extent={{-50,-366},{-30,-346}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch selCtl[nChiHea]
    "Select control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-380})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer[nChiHea](each final
            k=0) "Constant" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-400})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1[nChiHea]
    "Take into account entering CW temperature control in direct HR mode"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={180,-280})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extT(final nin=nChiHea)
    "Extract value at given index"
    annotation (Placement(transformation(extent={{-180,-410},{-160,-390}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep5(final nout=
        nChiHea) "Replicate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-340})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaLvgChiHea[nChiHea](each final
            unit="K", each displayUnit="degC")
    "HRC evaporator barrel leaving temperature"
                                               annotation (Placement(
        transformation(extent={{-260,20},{-220,60}}),   iconTransformation(
          extent={{-140,-160},{-100,-120}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlTConWatEvaLvg[nChiHea](
    each k=0.01,
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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TConWatEvaLvgSetCst[2](final k=
        TTanSet[:, 1]) "HRC evaporator leaving CW temperature setpoint"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-190,60})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput idxCycTan(final min=1,
      final max=2)
    "Index of active tank cycle"
    annotation (Placement(transformation(extent={{-260,80},{-220,120}}),
    iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode(final min=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.tankCharge,
      final max=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.heatRejection)
    "Condenser loop operating mode"
    annotation (Placement(transformation(extent={{-260,160},{-220,200}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep6(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Line valEvaEnt[nChiHea]
    "Mixing valve opening reset: 1 means no bypass flow"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant xVal[nChiHea,2](final
      k=fill({0,0.5}, nChiHea)) "x-value for mixing valve opening reset"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yVal[nChiHea,2](final k=
        fill({0,1}, nChiHea))
    "y-value for mixing valve opening reset: 1 means no bypass flow"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Line floEva[nChiHea]
    "HRC evaporator flow reset when On AND cascading heating"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant xFlo[nChiHea,2](final
      k=fill({0.5,1}, nChiHea)) "x-value for evaporator flow reset"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFlo[nChiHea,2](final
      k=fill({mChiWatChiHea_flow_min,mChiWatChiHea_flow_nominal}, nChiHea))
    "y-value for evaporator flow reset"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch selFloSet[nChiHea]
    "Select HRC evaporator flow setpoint based on operating mode"
    annotation (Placement(transformation(extent={{-172,-10},{-152,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatEvaEnt(final unit="K",
      displayUnit="degC") "HRC evaporator entering CW temperature " annotation (
     Placement(transformation(extent={{-260,-480},{-220,-440}}),
        iconTransformation(extent={{-140,-200},{-100,-160}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlTConWatEvaEnt(
    k=k,
    Ti=Ti,
    final yMin=0,
    final yMax=1,
    final reverseActing=true,
    final y_reset=1,
    final y_neutral=1)
    "HRC evaporator entering temperature control: 1 means no bypass flow"
    annotation (Placement(transformation(extent={{-30,-450},{-10,-430}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyHeaAndCasAndOn(nin=nChiHea)
    "Return true if ANY HRC cascading heating AND On" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-420})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TConWatEvaEntSet(each final
            k=TTanSet[1, 2]) "HRC evaporator entering CW temperature setpoint"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-190,-440})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin(nin=nChiHea+1)
    "Combine outputs from evaporator entering and leaving temperature control"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={178,-440})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConWatEvaMix
    "HRC evaporator CW mixing valve commanded position" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-440}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-100})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TConWatConRetSetCst[2](final
      k=TTanSet[:, 2]) "CW condenser loop return temperature setpoint"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-190,100})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor TConWatConRetSet(final nin=2)
    "Extract value at given index"
    annotation (Placement(transformation(extent={{-170,90},{-150,110}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlTConWatConRet(
    k=0.01,
    Ti=Ti,
    final yMin=0,
    final yMax=1,
    final reverseActing=false,
    final y_reset=0.2,
    final y_neutral=1.0)
    "Condenser loop CW return temperature control"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isChaAss
    "Check if charge assist mode is active"
    annotation (Placement(transformation(extent={{-170,150},{-150,170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chaAss(final k=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.chargeAssist)
    "Charge assist mode index"
    annotation (Placement(transformation(extent={{-210,150},{-190,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatConRet(each final unit
      ="K", each displayUnit="degC") "Condenser loop CW return temperature"
    annotation (Placement(transformation(extent={{-260,120},{-220,160}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
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
        origin={50,-100})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlTConLvgChi[nChi +
    nChiHea](
    each k=0.01,
    each Ti=Ti,
    each final yMin=0,
    each final yMax=1,
    each final reverseActing=false,
    each final y_reset=0.5,
    each final y_neutral=0) "Condenser leaving temperature control"
    annotation (Placement(transformation(extent={{-70,250},{-50,270}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConLvgChiHea[nChiHea](each final
            unit="K", each displayUnit="degC")
    "HRC condenser barrel leaving temperature" annotation (Placement(
        transformation(extent={{-260,200},{-220,240}}), iconTransformation(
          extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConLvgChi[nChi](each final
      unit="K", each displayUnit="degC")
    "Chiller condenser barrel leaving temperature" annotation (Placement(
        transformation(extent={{-260,220},{-220,260}}), iconTransformation(
          extent={{-140,-140},{-100,-100}})));
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
    annotation (Placement(transformation(extent={{-70,170},{-50,190}})));
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
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiFloSet1[nChi + nChiHea]
    "Switch condenser flow setpoint based on condenser loop operating mode"
    annotation (Placement(transformation(extent={{-10,230},{10,250}})));
  Modelica.Blocks.Sources.RealExpression minChiWatFlo(
    final y=max(0, max(
      max({if onAndOpe[i].y then 1.1 * mChiWatChi_flow_min - mEvaChi_flow[i] else 0 for i in 1:nChi}),
      max({if cooOrDirAndOnAndOpe[i].y then 1.1 * mChiWatChiHea_flow_min - mEvaChiHea_flow[i] else 0 for i in 1:nChiHea}))))
    "Compute minimum CHW flow setpoint"
    annotation (Placement(transformation(extent={{160,450},{180,470}})));
  Modelica.Blocks.Sources.RealExpression minHeaWatFlo(
    final y=max(0,
      max({if heaAndOn1AndOpe[i].y then 1.1 * mHeaWatChiHea_flow_min - mConChiHea_flow[i] else 0 for i in 1:nChiHea})))
    "Compute minimum HW flow setpoint"
    annotation (Placement(transformation(extent={{160,410},{180,430}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mChiWatMinSet_flow(final
      unit="kg/s") "CHW minimum flow setpoint" annotation (Placement(
        transformation(extent={{220,440},{260,480}}), iconTransformation(extent
          ={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mHeaWatMinSet_flow(final
      unit="kg/s") "HW minimum flow setpoint" annotation (Placement(
        transformation(extent={{220,400},{260,440}}), iconTransformation(extent
          ={{100,40},{140,80}})));
equation
  connect(u1Chi, valEvaChi.uEna) annotation (Line(points={{-240,360},{-200,360},
          {-200,380},{-124,380},{-124,388}},
                                           color={255,0,255}));
  connect(u1Chi, valConChi.uEna) annotation (Line(points={{-240,360},{-200,360},
          {-200,340},{76,340},{76,348}},color={255,0,255}));
  connect(u1ChiHea, valEvaChiHea.uEna) annotation (Line(points={{-240,-40},{-196,
          -40},{-196,-56},{-124,-56},{-124,-12}},
                                           color={255,0,255}));
  connect(u1ChiHea, valConChiHea.uEna) annotation (Line(points={{-240,-40},{-196,
          -40},{-196,-116},{76,-116},{76,-112}},
                                               color={255,0,255}));
  connect(mConChiHea_flow, fil6.u)
    annotation (Line(points={{-240,-120},{-182,-120}},
                                                     color={0,0,127}));
  connect(fil6.y, valConChiHea.u_m) annotation (Line(points={{-159,-120},{80,-120},
          {80,-112}},       color={0,0,127}));
  connect(fil7.y, valEvaChiHea.u_m) annotation (Line(points={{-157,-40},{-120,-40},
          {-120,-12}},      color={0,0,127}));
  connect(mEvaChiHea_flow, fil7.u) annotation (Line(points={{-240,-20},{-190,-20},
          {-190,-40},{-180,-40}},      color={0,0,127}));
  connect(valConChiHea.y, yValConChiHea)
    annotation (Line(points={{92,-100},{240,-100}}, color={0,0,127}));
  connect(valEvaChiHea.y, yValEvaChiHea) annotation (Line(points={{-108,0},{-100,
          0},{-100,-80},{240,-80}},      color={0,0,127}));
  connect(mEvaChi_flow, fil2.u)
    annotation (Line(points={{-240,320},{-202,320}}, color={0,0,127}));
  connect(mConChi_flow, fil3.u)
    annotation (Line(points={{-240,300},{-172,300}},
                                                   color={0,0,127}));
  connect(fil3.y, valConChi.u_m) annotation (Line(points={{-149,300},{80,300},{80,
          348}},      color={0,0,127}));
  connect(fil2.y, valEvaChi.u_m) annotation (Line(points={{-179,320},{-120,320},
          {-120,388}}, color={0,0,127}));
  connect(valEvaChi.y, yValEvaChi) annotation (Line(points={{-108,400},{200,400},
          {200,-20},{240,-20}},
                              color={0,0,127}));
  connect(valConChi.y, yValConChi) annotation (Line(points={{92,360},{206,360},{
          206,-40},{240,-40}},
                            color={0,0,127}));
  connect(rep.y,intLes. u2) annotation (Line(points={{2,-280},{6,-280},{6,-288},
          {18,-288}}, color={255,127,0}));
  connect(intLes.y, heaOrCooCon.u2) annotation (Line(points={{42,-280},{46,-280},
          {46,-288},{68,-288}}, color={255,0,255}));
  connect(heaOrCooCon.y, yValConSwi.u)
    annotation (Line(points={{92,-280},{98,-280}}, color={255,0,255}));
  connect(numHeaAndOn.y, rep.u)
    annotation (Line(points={{-28,-280},{-22,-280}}, color={255,127,0}));
  connect(u1CooChiHea, hea.u) annotation (Line(points={{-240,-60},{-200,-60},{-200,
          -280},{-182,-280}}, color={255,0,255}));
  connect(u1ChiHea, heaAndOn.u1) annotation (Line(points={{-240,-40},{-196,-40},
          {-196,-260},{-130,-260},{-130,-280},{-122,-280}},
                                                      color={255,0,255}));
  connect(hea.y, heaAndOn.u2) annotation (Line(points={{-158,-280},{-140,-280},{
          -140,-288},{-122,-288}}, color={255,0,255}));
  connect(heaAndOn.y, booToInt.u)
    annotation (Line(points={{-98,-280},{-82,-280}},   color={255,0,255}));
  connect(idx.y, intLes.u1) annotation (Line(points={{-158,-224},{10,-224},{10,-280},
          {18,-280}},        color={255,127,0}));
  connect(cooAndOn.y, heaOrCooCon.u1) annotation (Line(points={{-98,-240},{50,-240},
          {50,-280},{68,-280}},       color={255,0,255}));
  connect(u1ChiHea, cooAndOn.u1) annotation (Line(points={{-240,-40},{-196,-40},
          {-196,-240},{-122,-240}},
                              color={255,0,255}));
  connect(u1CooChiHea, cooAndOn.u2) annotation (Line(points={{-240,-60},{-200,-60},
          {-200,-248},{-122,-248}}, color={255,0,255}));
  connect(cooOrDir.y,heaAndCas. u) annotation (Line(points={{-158,-160},{-154,-160},
          {-154,-200},{-152,-200}},                         color={255,0,255}));
  connect(booToInt1.y, numHeaAndCasAndOn.u)
    annotation (Line(points={{-58,-200},{-54,-200}}, color={255,127,0}));
  connect(numHeaAndCasAndOn.y, rep1.u)
    annotation (Line(points={{-30,-200},{-22,-200}}, color={255,127,0}));
  connect(rep1.y,intLes1. u2) annotation (Line(points={{2,-200},{10,-200},{10,-208},
          {28,-208}},        color={255,127,0}));
  connect(intLes1.y, heaOrCooEva.u2) annotation (Line(points={{52,-200},{56,-200},
          {56,-168},{118,-168}},      color={255,0,255}));
  connect(heaOrCooEva.y, yValEvaSwi.u)
    annotation (Line(points={{142,-160},{168,-160}},
                                                   color={255,0,255}));
  connect(u1CooChiHea, cooOrDir.u1) annotation (Line(points={{-240,-60},{-200,-60},
          {-200,-160},{-182,-160}}, color={255,0,255}));
  connect(u1HeaCooChiHea, cooOrDir.u2) annotation (Line(points={{-240,-80},{-204,
          -80},{-204,-168},{-182,-168}}, color={255,0,255}));
  connect(cooOrDir.y, cooOrDirAndOn.u2) annotation (Line(points={{-158,-160},{-154,
          -160},{-154,-168},{-122,-168}}, color={255,0,255}));
  connect(u1ChiHea, cooOrDirAndOn.u1) annotation (Line(points={{-240,-40},{-196,
          -40},{-196,-140},{-124,-140},{-124,-160},{-122,-160}},
                                                            color={255,0,255}));
  connect(heaAndCas.y, heaAndCasAndOn.u2) annotation (Line(points={{-128,-200},{
          -126,-200},{-126,-208},{-122,-208}}, color={255,0,255}));
  connect(u1ChiHea, heaAndCasAndOn.u1) annotation (Line(points={{-240,-40},{-196,
          -40},{-196,-140},{-124,-140},{-124,-200},{-122,-200}},
                                                            color={255,0,255}));
  connect(heaAndCasAndOn.y, booToInt1.u)
    annotation (Line(points={{-98,-200},{-82,-200}}, color={255,0,255}));
  connect(booToInt.y, numHeaAndOn.u)
    annotation (Line(points={{-58,-280},{-52,-280}}, color={255,127,0}));
  connect(idx.y, intLes1.u1) annotation (Line(points={{-158,-224},{20,-224},{20,
          -200},{28,-200}}, color={255,127,0}));
  connect(cooOrDirAndOn.y, heaOrCooEva.u1)
    annotation (Line(points={{-98,-160},{118,-160}},color={255,0,255}));
  connect(yValEvaChi, isOpe2.u) annotation (Line(points={{240,-20},{200,-20},{200,
          20},{194,20}}, color={0,0,127}));
  connect(yValConChi, isOpe3.u) annotation (Line(points={{240,-40},{196,-40},{196,
          -20},{194,-20}},
                     color={0,0,127}));
  connect(yValEvaChiHea, isOpe.u) annotation (Line(points={{240,-80},{200,-80},{
          200,-60},{194,-60}}, color={0,0,127}));
  connect(yValConChiHea, isOpe1.u) annotation (Line(points={{240,-100},{200,-100},
          {200,-120},{194,-120}},
                                color={0,0,127}));
  connect(isOpe.y, cooOrDirAndOnAndOpe.u1) annotation (Line(points={{170,-60},{106,
          -60},{106,380},{118,380}},   color={255,0,255}));
  connect(cooOrDirAndOn.y, cooOrDirAndOnAndOpe.u2) annotation (Line(points={{-98,
          -160},{102,-160},{102,388},{118,388}},   color={255,0,255}));
  connect(isOpe2.y, onAndOpe.u2) annotation (Line(points={{170,20},{114,20},{114,
          332},{118,332}},
                         color={255,0,255}));
  connect(u1Chi, onAndOpe.u1) annotation (Line(points={{-240,360},{-200,360},{-200,
          380},{96,380},{96,340},{118,340}},   color={255,0,255}));
  connect(isOpe3.y, onAndOpe1.u2) annotation (Line(points={{170,-20},{110,-20},{
          110,292},{118,292}},
                         color={255,0,255}));
  connect(u1Chi, onAndOpe1.u1) annotation (Line(points={{-240,360},{-200,360},{-200,
          340},{92,340},{92,300},{118,300}}, color={255,0,255}));
  connect(onAndOpe[1:nChi].y, enaPumChiWat.u[1:nChi])
    annotation (Line(points={{142,340},{168,340}}, color={255,0,255}));
  connect(cooOrDirAndOnAndOpe[1:nChiHea].y, enaPumChiWat.u[nChi+1:nChi+nChiHea]) annotation (Line(points={{142,380},
          {160,380},{160,340},{168,340}},  color={255,0,255}));
  connect(onAndOpe1[1:nChi].y, enaPumConWatCon.u[1:nChi])
    annotation (Line(points={{142,300},{168,300}},
                                                color={255,0,255}));
  connect(u1CooChiHea, cooAndOpe.u1) annotation (Line(points={{-240,-60},{94,-60},
          {94,270},{120,270}},     color={255,0,255}));
  connect(isOpe1.y, cooAndOpe.u2) annotation (Line(points={{170,-120},{98,-120},
          {98,262},{120,262}},   color={255,0,255}));
  connect(cooAndOpe[1:nChiHea].y, enaPumConWatCon.u[nChi+1:nChi+nChiHea]) annotation (Line(points={{144,270},
          {160,270},{160,300},{168,300}},
                                   color={255,0,255}));
  connect(heaAndOn.y, heaAndOn1AndOpe.u1) annotation (Line(points={{-98,-280},{-84,
          -280},{-84,-320},{68,-320}},  color={255,0,255}));
  connect(isOpe1.y, heaAndOn1AndOpe.u2) annotation (Line(points={{170,-120},{160,
          -120},{160,-300},{60,-300},{60,-328},{68,-328}},   color={255,0,255}));
  connect(heaAndOn1AndOpe.y, enaPumHeaWat.u)
    annotation (Line(points={{92,-320},{98,-320}},   color={255,0,255}));
  connect(heaAndCasAndOn.y, heaAndCasAndOnAndOpe.u1) annotation (Line(points={{-98,
          -200},{-90,-200},{-90,-220},{128,-220}},color={255,0,255}));
  connect(isOpe.y, heaAndCasAndOnAndOpe.u2) annotation (Line(points={{170,-60},{
          106,-60},{106,-228},{128,-228}},
                                        color={255,0,255}));
  connect(heaAndCasAndOnAndOpe.y, enaPumConWatEva.u)
    annotation (Line(points={{152,-220},{168,-220}},
                                                   color={255,0,255}));
  connect(enaPumChiWat.y, y1PumChiWat)
    annotation (Line(points={{192,340},{240,340}}, color={255,0,255}));
  connect(enaPumConWatCon.y, y1PumConWatCon)
    annotation (Line(points={{192,300},{240,300}},
                                                 color={255,0,255}));
  connect(enaPumHeaWat.y, y1PumHeaWat) annotation (Line(points={{122,-320},{240,
          -320}},                       color={255,0,255}));
  connect(rep2.y, valEvaChi.u_s)
    annotation (Line(points={{-178,400},{-132,400}}, color={0,0,127}));
  connect(rep2.u, mEvaChiSet_flow)
    annotation (Line(points={{-202,400},{-240,400}}, color={0,0,127}));
  connect(rep3.u, mEvaChiHeaSet_flow)
    annotation (Line(points={{-212,0},{-240,0}},   color={0,0,127}));
  connect(yValEvaSwi.y, yValEvaSwiChiHea) annotation (Line(points={{192,-160},{200,
          -160},{200,-140},{240,-140}},     color={0,0,127}));
  connect(enaPumConWatEva.y, y1PumConWatEva)
    annotation (Line(points={{192,-220},{240,-220}}, color={255,0,255}));
  connect(u1ChiHea, dirHeaCooAndOn.u1) annotation (Line(points={{-240,-40},{-196,
          -40},{-196,-360},{-182,-360}},color={255,0,255}));
  connect(u1HeaCooChiHea, dirHeaCooAndOn.u2) annotation (Line(points={{-240,-80},
          {-204,-80},{-204,-368},{-182,-368}},color={255,0,255}));
  connect(dirHeaCooAndOn.y, anyDirHeaCooAndOn.u)
    annotation (Line(points={{-158,-360},{-142,-360}}, color={255,0,255}));
  connect(TConEntChiHeaSet, valConSwi.u_s)
    annotation (Line(points={{-240,-380},{-82,-380}}, color={0,0,127}));
  connect(anyDirHeaCooAndOn.y, valConSwi.uEna) annotation (Line(points={{-118,-360},
          {-100,-360},{-100,-396},{-74,-396},{-74,-392}},       color={255,0,
          255}));
  connect(valConSwi.y, rep4.u)
    annotation (Line(points={{-58,-380},{-52,-380}}, color={0,0,127}));
  connect(equIdx.y, selCtl.u2) annotation (Line(points={{12,-348},{20,-348},{20,
          -380},{28,-380}}, color={255,0,255}));
  connect(rep4.y, selCtl.u1) annotation (Line(points={{-28,-380},{0,-380},{0,-372},
          {28,-372}},       color={0,0,127}));
  connect(zer.y, selCtl.u3) annotation (Line(points={{12,-400},{20,-400},{20,-388},
          {28,-388}},       color={0,0,127}));
  connect(yValConSwi.y, max1.u1) annotation (Line(points={{122,-280},{140,-280},
          {140,-274},{168,-274}}, color={0,0,127}));
  connect(max1.y, yValConSwiChiHea) annotation (Line(points={{192,-280},{200,-280},
          {200,-180},{240,-180}},     color={0,0,127}));
  connect(selCtl.y, max1.u2) annotation (Line(points={{52,-380},{140,-380},{140,
          -286},{168,-286}}, color={0,0,127}));
  connect(TConEntChiHea, extT.u)
    annotation (Line(points={{-240,-400},{-182,-400}}, color={0,0,127}));
  connect(idxHig.y, extT.index) annotation (Line(points={{-159,-340},{-150,-340},
          {-150,-416},{-170,-416},{-170,-412}}, color={255,127,0}));
  connect(extT.y, valConSwi.u_m) annotation (Line(points={{-158,-400},{-70,-400},
          {-70,-392}}, color={0,0,127}));
  connect(idxHig.y, rep5.u)
    annotation (Line(points={{-159,-340},{-82,-340}}, color={255,127,0}));
  connect(idxChiHea.y, equIdx.u2)
    annotation (Line(points={{-29,-356},{-12,-356}}, color={255,127,0}));
  connect(rep5.y, equIdx.u1) annotation (Line(points={{-58,-340},{-20,-340},{-20,
          -348},{-12,-348}},     color={255,127,0}));
  connect(heaAndCasAndOn.y, ctlTConWatEvaLvg.uEna) annotation (Line(points={{-98,
          -200},{-90,-200},{-90,20},{-104,20},{-104,48}},  color={255,0,255}));
  connect(TEvaLvgChiHea, ctlTConWatEvaLvg.u_m) annotation (Line(points={{-240,40},
          {-100,40},{-100,48}},   color={0,0,127}));
  connect(TConWatEvaLvgSetCst.y, TConWatEvaLvgSet.u)
    annotation (Line(points={{-178,60},{-172,60}},   color={0,0,127}));
  connect(idxCycTan, TConWatEvaLvgSet.index) annotation (Line(points={{-240,100},
          {-210,100},{-210,44},{-160,44},{-160,48}},    color={255,127,0}));
  connect(rep6.y, ctlTConWatEvaLvg.u_s)
    annotation (Line(points={{-118,60},{-112,60}},   color={0,0,127}));
  connect(TConWatEvaLvgSet.y, rep6.u)
    annotation (Line(points={{-148,60},{-142,60}},   color={0,0,127}));
  connect(yVal[:, 2].y,valEvaEnt. f2) annotation (Line(points={{-58,80},{-46,80},
          {-46,92},{-42,92}},
                        color={0,0,127}));
  connect(yVal[:, 1].y,valEvaEnt. f1) annotation (Line(points={{-58,80},{-46,80},
          {-46,104},{-42,104}},
                        color={0,0,127}));
  connect(xVal[:, 1].y,valEvaEnt. x1) annotation (Line(points={{-58,120},{-48,120},
          {-48,108},{-42,108}},
                            color={0,0,127}));
  connect(xVal[:, 2].y,valEvaEnt. x2) annotation (Line(points={{-58,120},{-48,120},
          {-48,96},{-42,96}},
                            color={0,0,127}));
  connect(yFlo[:, 2].y, floEva.f2) annotation (Line(points={{-58,0},{-46,0},{-46,
          12},{-42,12}},        color={0,0,127}));
  connect(yFlo[:, 1].y, floEva.f1) annotation (Line(points={{-58,0},{-46,0},{-46,
          24},{-42,24}},        color={0,0,127}));
  connect(xFlo[:, 1].y, floEva.x1) annotation (Line(points={{-58,40},{-48,40},{-48,
          28},{-42,28}},        color={0,0,127}));
  connect(xFlo[:, 2].y, floEva.x2) annotation (Line(points={{-58,40},{-48,40},{-48,
          16},{-42,16}},        color={0,0,127}));
  connect(heaAndCasAndOn.y, selFloSet.u2) annotation (Line(points={{-98,-200},{-90,
          -200},{-90,20},{-176,20},{-176,0},{-174,0}},      color={255,0,255}));
  connect(rep3.y, selFloSet.u3) annotation (Line(points={{-188,0},{-184,0},{-184,
          -8},{-174,-8}},        color={0,0,127}));
  connect(ctlTConWatEvaLvg.y, valEvaEnt.u) annotation (Line(points={{-88,60},{-44,
          60},{-44,100},{-42,100}},  color={0,0,127}));
  connect(ctlTConWatEvaLvg.y, floEva.u) annotation (Line(points={{-88,60},{-44,60},
          {-44,20},{-42,20}},        color={0,0,127}));
  connect(selFloSet.y, valEvaChiHea.u_s)
    annotation (Line(points={{-150,0},{-132,0}},     color={0,0,127}));
  connect(floEva.y, selFloSet.u1) annotation (Line(points={{-18,20},{-10,20},{-10,
          -20},{-180,-20},{-180,8},{-174,8}},         color={0,0,127}));
  connect(TConWatEvaEnt, ctlTConWatEvaEnt.u_m) annotation (Line(points={{-240,-460},
          {-20,-460},{-20,-452}}, color={0,0,127}));
  connect(anyHeaAndCasAndOn.y, ctlTConWatEvaEnt.uEna) annotation (Line(points={{-48,
          -420},{-40,-420},{-40,-456},{-24,-456},{-24,-452}},     color={255,0,255}));
  connect(heaAndCasAndOn.y, anyHeaAndCasAndOn.u) annotation (Line(points={{-98,-200},
          {-90,-200},{-90,-420},{-72,-420}},color={255,0,255}));
  connect(TConWatEvaEntSet.y, ctlTConWatEvaEnt.u_s)
    annotation (Line(points={{-178,-440},{-32,-440}}, color={0,0,127}));
  connect(ctlTConWatEvaEnt.y, mulMin.u[nChiHea+1])
    annotation (Line(points={{-8,-440},{166,-440}}, color={0,0,127}));
  connect(valEvaEnt.y, mulMin.u[1:nChiHea]) annotation (Line(points={{-18,100},{
          154,100},{154,-440},{166,-440}},
                                      color={0,0,127}));
  connect(mulMin.y, yValConWatEvaMix)
    annotation (Line(points={{190,-440},{240,-440}}, color={0,0,127}));
  connect(TConWatConRetSetCst.y, TConWatConRetSet.u) annotation (Line(points={{-178,
          100},{-172,100}},                            color={0,0,127}));
  connect(idxCycTan, TConWatConRetSet.index) annotation (Line(points={{-240,100},
          {-210,100},{-210,80},{-160,80},{-160,88}},    color={255,127,0}));
  connect(mode, isChaAss.u1) annotation (Line(points={{-240,180},{-180,180},{-180,
          160},{-172,160}},      color={255,127,0}));
  connect(chaAss.y, isChaAss.u2) annotation (Line(points={{-188,160},{-184,160},
          {-184,152},{-172,152}}, color={255,127,0}));
  connect(isChaAss.y, ctlTConWatConRet.uEna) annotation (Line(points={{-148,160},
          {-94,160},{-94,168}},   color={255,0,255}));
  connect(TConWatConRetSet.y, ctlTConWatConRet.u_s) annotation (Line(points={{-148,
          100},{-110,100},{-110,180},{-102,180}},      color={0,0,127}));
  connect(TConWatConRet, ctlTConWatConRet.u_m) annotation (Line(points={{-240,140},
          {-90,140},{-90,168}},   color={0,0,127}));
  connect(xFloCon[:, 1].y, floCon.x1) annotation (Line(points={{82,220},{124,220},
          {124,208},{128,208}},
                              color={0,0,127}));
  connect(xFloCon[:, 2].y, floCon.x2) annotation (Line(points={{82,220},{124,220},
          {124,196},{128,196}},
                              color={0,0,127}));
  connect(mode, isTanCha.u2) annotation (Line(points={{-240,180},{-180,180},{-180,
          192},{-172,192}}, color={255,127,0}));
  connect(tanCha.y, isTanCha.u1)
    annotation (Line(points={{-188,200},{-172,200}}, color={255,127,0}));
  connect(TConLvgChi, ctlTConLvgChi[1:nChi].u_m) annotation (Line(points={{-240,
          240},{-60,240},{-60,248}},   color={0,0,127}));
  connect(TConLvgChiHea, ctlTConLvgChi[nChi + 1:nChi + nChiHea].u_m)
    annotation (Line(points={{-240,220},{-60,220},{-60,248}},   color={0,0,127}));
  connect(isTanCha.y, rep9.u)
    annotation (Line(points={{-148,200},{-142,200}}, color={255,0,255}));
  connect(rep9.y, ctlTConLvgChi.uEna) annotation (Line(points={{-118,200},{-64,200},
          {-64,248}},       color={255,0,255}));
  connect(rep10.y, ctlTConLvgChi.u_s)
    annotation (Line(points={{-78,260},{-72,260}}, color={0,0,127}));
  connect(ctlTConWatConRet.y, rep11.u)
    annotation (Line(points={{-78,180},{-72,180}}, color={0,0,127}));
  connect(TConWatConRetSet.y, rep10.u) annotation (Line(points={{-148,100},{-110,
          100},{-110,260},{-102,260}}, color={0,0,127}));
  connect(rep12.y, swiFloSet.u2) annotation (Line(points={{-18,160},{10,160},{10,
          200},{28,200}}, color={255,0,255}));
  connect(isChaAss.y, rep12.u)
    annotation (Line(points={{-148,160},{-42,160}}, color={255,0,255}));
  connect(rep11.y, swiFloSet.u1) annotation (Line(points={{-48,180},{0,180},{0,208},
          {28,208}}, color={0,0,127}));
  connect(rep9.y, swiFloSet1.u2) annotation (Line(points={{-118,200},{-64,200},{
          -64,240},{-12,240}}, color={255,0,255}));
  connect(ctlTConLvgChi.y, swiFloSet1.u1) annotation (Line(points={{-48,260},{-20,
          260},{-20,248},{-12,248}}, color={0,0,127}));
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
    annotation (Line(points={{62,-100},{68,-100}}, color={0,0,127}));
  connect(floCon[nChi + 1:nChi + nChiHea].y, scaFloConChiHea.u) annotation (
      Line(points={{152,200},{160,200},{160,160},{32,160},{32,-100},{38,-100}},
        color={0,0,127}));
  connect(floCon[1:nChi].y, scaFloConChi.u) annotation (Line(points={{152,200},{
          160,200},{160,240},{32,240},{32,360},{38,360}}, color={0,0,127}));
  connect(minChiWatFlo.y, mChiWatMinSet_flow)
    annotation (Line(points={{181,460},{240,460}}, color={0,0,127}));
  connect(minHeaWatFlo.y, mHeaWatMinSet_flow)
    annotation (Line(points={{181,420},{240,420}}, color={0,0,127}));
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
          extent={{-220,-480},{220,480}})),
    Documentation(info="<html>
Isolation valve control loops are biased to launch from 100 % (valve full open).
</html>"));
end ValveCondenserEvaporator;
