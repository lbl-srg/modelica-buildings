within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block ValvesCondenserEvaporator
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
        origin={-120,140})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiHea[nChiHea]
    "HR chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooChiHea[nChiHea]
    "HR chiller cooling mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,60}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,100})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaCooChiHea[nChiHea]
    "HR chiller direct heat recovery switchover command: true for direct HR, false for cascading"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChiSet_flow(final
      unit="kg/s") "Chiller evaporator flow setpoint" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,400}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChiHeaSet_flow(final
            unit="kg/s") "HRC evaporator flow setpoint" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,120}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChi_flow[nChi](
    each final unit="kg/s")
    "Chiller evaporator mass flow rate" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,320}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConChi_flow[nChi](
    each final unit="kg/s")
    "Chiller condenser mass flow rate" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,300}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChiHea_flow[nChiHea](
    each final unit="kg/s")
    "HRC evaporator mass flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConChiHea_flow[nChiHea](
    each final unit="kg/s")
    "HRC condenser mass flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,0}),   iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWat
    "Enable signal for lead CHW pump"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,340}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,100})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWat
    "Enable signal for lead HW pump"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-200}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,80})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatCon
    "Enable signal for lead CW pump serving evaporator loop"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,300}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,60})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatEva
    "Enable signal for lead CW pump serving evaporator loop"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-100}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaChi[nChi]
    "Cooling-only chiller evaporator isolation valve commanded position"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,100}),iconTransformation(
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
        origin={240,80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaChiHea[nChiHea](each final
            unit="1") "HRC evaporator isolation valve commanded position"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConChiHea[nChiHea](each final
            unit="1") "HRC condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,20}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-40})));

  EnergyTransferStations.Combined.Controls.PIDWithEnable valEvaChi[nChi](
    each final r=mChiWatChi_flow_nominal,
    each k=k,
    each Ti=Ti,
    each final yMin=yMin,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=y_reset,
    each final y_neutral=y_neutral)
    "Chiller evaporator isolation valve control"
    annotation (Placement(transformation(extent={{-130,390},{-110,410}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floConWatChi[nChi](
      each final k=mConWatChi_flow_nominal) "Chiller CW flow setpoint"
    annotation (Placement(transformation(extent={{-170,350},{-150,370}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floConWatChiHea[nChiHea](
      each final k=mConWatChiHea_flow_nominal) "HRC CW flow setpoint"
    annotation (Placement(transformation(extent={{-180,20},{-160,40}})));

  EnergyTransferStations.Combined.Controls.PIDWithEnable valConChi[nChi](
    each final r=mConWatChi_flow_nominal,
    each k=k,
    each Ti=Ti,
    each final yMin=yMin,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=y_reset,
    each final y_neutral=y_neutral) "Chiller condenser isolation valve control"
    annotation (Placement(transformation(extent={{-110,350},{-90,370}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valEvaChiHea[nChiHea](
    each final r=mChiWatChiHea_flow_nominal,
    each k=k,
    each Ti=Ti,
    each final yMin=yMin,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=y_reset,
    each final y_neutral=y_neutral) "HRC evaporator isolation valve control"
    annotation (Placement(transformation(extent={{-130,110},{-110,130}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valConChiHea[nChiHea](
    each k=k,
    each Ti=Ti,
    each final r=mConWatChiHea_flow_nominal,
    each final yMin=yMin,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=y_reset,
    each final y_neutral=y_neutral)
    "HRC condenser isolation valve control"
    annotation (Placement(transformation(extent={{-128,10},{-108,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaSwiChiHea[nChiHea](
      each final unit="1") "HRC evaporator switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-20}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConSwiChiHea[nChiHea](
      each final unit="1") "HRC condenser switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-60}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-80})));
  Modelica.Blocks.Continuous.FirstOrder fil6[nChiHea](each T=60, each initType=
        Modelica.Blocks.Types.Init.InitialOutput)
    "Filter to break algebraic loop"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Modelica.Blocks.Continuous.FirstOrder fil7[nChiHea](each T=60, each initType=
        Modelica.Blocks.Types.Init.InitialOutput)
    "Filter to break algebraic loop"
    annotation (Placement(transformation(extent={{-178,70},{-158,90}})));
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
        origin={110,-160})));
  Buildings.Controls.OBC.CDL.Logical.Not hea[nChiHea] "Return true if heating"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-160})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nChiHea](
    each final integerTrue=1,
    each final integerFalse=0)
    "Convert"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numHeaAndOn(nin=nChiHea)
    "Number of HRC connected to HW loop and On"
    annotation (Placement(transformation(extent={{-50,-170},{-30,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes[nChiHea]
    "Return true if switchover valve to be open for heating operation"
    annotation (Placement(transformation(extent={{20,-170},{40,-150}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(
    final nout=nChiHea)
    "Replicate"
    annotation (Placement(transformation(extent={{-20,-170},{0,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaOrCooCon[nChiHea]
    "Return true if switchover valve to be open for heating or cooling operation"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-160})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndOn[nChiHea]
    "Return true if heating AND On" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-160})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idx[nChiHea](final k={i
        for i in 1:nChiHea}) "HRC index"
    annotation (Placement(transformation(extent={{-180,-114},{-160,-94}})));
  Buildings.Controls.OBC.CDL.Logical.And cooAndOn[nChiHea]
    "Return true if cooling AND On" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-120})));
  Buildings.Controls.OBC.CDL.Logical.Or cooOrDir[nChiHea]
    "Return true if cooling OR direct HR" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-40})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yValEvaSwi[nChiHea]
    "HRC evaporator switchover valve commanded position" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-40})));
  Buildings.Controls.OBC.CDL.Logical.Not heaAndCas[nChiHea]
    "Return true if cascading heating" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-140,-80})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nChiHea]
    "Convert"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numHeaAndCasAndOn(nin=nChiHea)
    "Number of HRC in cascading heating AND On"
    annotation (Placement(transformation(extent={{-52,-90},{-32,-70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep1(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes1[nChiHea]
    "Return true if switchover valve to be open for heating operation"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaOrCooEva[nChiHea]
    "Return true if switchover valve to be open for heating or cooling operation"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-40})));
  Buildings.Controls.OBC.CDL.Logical.And cooOrDirAndOn[nChiHea]
    "Return true if (cooling OR direct HR) AND On"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-40})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndCasAndOn[nChiHea]
    "Return true if cascading heating AND On"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-80})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe[nChiHea](each t=0.1,
      each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{192,50},{172,70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe1[nChiHea](each t
      =0.1, each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{192,-10},{172,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe2[nChi](each t=0.1,
      each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{192,130},{172,150}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe3[nChi](each t=0.1,
      each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{192,90},{172,110}})));
  Buildings.Controls.OBC.CDL.Logical.And cooOrDirAndOnAndOpe[nChiHea]
    "Return true if (cooling OR direct HR) AND On AND isolation valve open"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={60,380})));
  Buildings.Controls.OBC.CDL.Logical.And onAndOpe[nChi]
    "Return true if On AND isolation valve open" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,340})));
  Buildings.Controls.OBC.CDL.Logical.And onAndOpe1[nChi]
    "Return true if On AND isolation valve open" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,300})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumChiWat(nin=nChi+nChiHea)
    "Enable signal for lead CHW pump"
                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,340})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumConWatCon(nin=nChi+nChiHea)
    "Enable signal for lead CW pump serving condenser loop"
                                                        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,300})));
  Buildings.Controls.OBC.CDL.Logical.And cooAndOpe[nChiHea]
    "Return true if cooling (necessarily cascading) AND isolation valve open"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={62,270})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumHeaWat(nin=nChiHea)
    "Enable signal for lead HW pump"
                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-200})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumConWatEva(nin=nChiHea)
    "Enable signal for lead CW pump serving evaporator loop"
                                                         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-100})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndOn1AndOpe[nChiHea]
    "Return true if heating AND On AND isolation valve open" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-200})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndCasAndOnAndOpe[nChiHea]
    "Return true if cascading heating AND On AND isolation valve open"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-100})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep2(final nout=nChi)
    "Replicate"
    annotation (Placement(transformation(extent={{-200,390},{-180,410}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep3(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-210,110},{-190,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput  TConEntChiHeaSet(final unit="K",
      displayUnit="degC") "HRC condenser entering temperature setpoint"
                                                  annotation (Placement(
        transformation(extent={{-260,-280},{-220,-240}}),
                                                       iconTransformation(
          extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConEntChiHea[nChiHea](final
      unit="K", displayUnit="degC") "HRC condenser entering temperature"
    annotation (Placement(transformation(extent={{-260,-300},{-220,-260}}),
        iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Logical.And dirHeaCooAndOn[nChiHea]
    "Return true if direct HR AND On"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-240})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyDirHeaCooAndOn(nin=nChiHea)
    "Return true if any HRC in direct HR AND On" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-240})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valConSwi(
    final r=mConWatChiHea_flow_nominal,
    k=k,
    Ti=Ti,
    final yMin=0,
    final yMax=1,
    final reverseActing=false,
    final y_reset=0,
    final y_neutral=0) "Condenser switchover valve control"
    annotation (Placement(transformation(extent={{-80,-270},{-60,-250}})));
  Modelica.Blocks.Sources.IntegerExpression idxHig(final y=max({if
        dirHeaCooAndOn[i].y then i else 1 for i in 1:nChiHea}))
    "Highest index of HRC in direct HR (defaulted to 1 if all false)"
    annotation (Placement(transformation(extent={{-180,-230},{-160,-210}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep4(final nout=
        nChiHea) "Replicate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,-260})));
  Buildings.Controls.OBC.CDL.Integers.Equal equIdx[nChiHea]
    "Return true if index equals highest index of HRC in direct HR"
    annotation (Placement(transformation(extent={{-10,-238},{10,-218}})));
  Modelica.Blocks.Sources.IntegerExpression idxChiHea[nChiHea](final y={i for i in
            1:nChiHea}) "HRC index"
    annotation (Placement(transformation(extent={{-50,-246},{-30,-226}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch selCtl[nChiHea]
    "Select control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-260})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer[nChiHea](each final
            k=0) "Constant" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-280})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1[nChiHea]
    "Take into account entering CW temperature control in direct HR mode"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={180,-160})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extT(final nin=nChiHea)
    "Extract value at given index"
    annotation (Placement(transformation(extent={{-180,-290},{-160,-270}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep5(final nout=
        nChiHea) "Replicate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-220})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaLvgChiHea[nChiHea](each final
            unit="K", each displayUnit="degC")
    "HRC evaporator barrel leaving temperature"
                                               annotation (Placement(
        transformation(extent={{-260,140},{-220,180}}), iconTransformation(
          extent={{-140,-160},{-100,-120}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlTConWatEvaLvg[nChiHea](
    each k=0.01,
    each Ti=Ti,
    each final yMin=0,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=0.75,
    each final y_neutral=0.75) "HRC evaporator leaving temperature control"
    annotation (Placement(transformation(extent={{-110,170},{-90,190}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor TConWatEvaLvgSet(final nin=2)
    "Extract value at given index"
    annotation (Placement(transformation(extent={{-170,170},{-150,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TConWatEvaLvgSetCst[2](final k=
        TTanSet[:, 1])       "HRC evaporator leaving CW temperature setpoint"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-200,180})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput idxCycTan(final min=1,
      final max=2)
    "Index of active tank cycle"
    annotation (Placement(transformation(extent={{-260,200},{-220,240}}),
    iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode(final min=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.tankCharge,
      final max=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.heatRejection)
    "Condenser loop operating mode"
    annotation (Placement(transformation(extent={{-260,240},{-220,280}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep6(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Line valEvaEnt[nChiHea]
    "Mixing valve opening reset: 1 means no bypass flow"
    annotation (Placement(transformation(extent={{-40,210},{-20,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant xVal[nChiHea,2](final
      k=fill({0,0.5}, nChiHea)) "x-value for mixing valve opening reset"
    annotation (Placement(transformation(extent={{-80,230},{-60,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yVal[nChiHea,2](final k=
        fill({0,1}, nChiHea))
    "y-value for mixing valve opening reset: 1 means no bypass flow"
    annotation (Placement(transformation(extent={{-80,190},{-60,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Line floEva[nChiHea]
    "HRC evaporator flow reset when On AND cascading heating"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant xFlo[nChiHea,2](final
      k=fill({0.5,1}, nChiHea)) "x-value for evaporator flow reset"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFlo[nChiHea,2](final
      k=fill({mChiWatChiHea_flow_min,mChiWatChiHea_flow_nominal}, nChiHea))
    "y-value for evaporator flow reset"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch selFloSet[nChiHea]
    "Select HRC evaporator flow setpoint based on operating mode"
    annotation (Placement(transformation(extent={{-172,110},{-152,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatEvaEnt(final unit="K",
      displayUnit="degC") "HRC evaporator entering CW temperature " annotation (
     Placement(transformation(extent={{-260,-360},{-220,-320}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctlTConWatEvaEnt(
    k=k,
    Ti=Ti,
    final yMin=0,
    final yMax=1,
    final reverseActing=true,
    final y_reset=1,
    final y_neutral=1)
    "HRC evaporator entering temperature control: 1 means no bypass flow"
    annotation (Placement(transformation(extent={{-30,-330},{-10,-310}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyHeaAndCasAndOn(nin=nChiHea)
    "Return true if ANY HRC cascading heating AND On" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-300})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TConWatEvaEntSet(each final
            k=TTanSet[1, 2]) "HRC evaporator entering CW temperature setpoint"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-190,-320})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin(nin=nChiHea+1)
    "Combine outputs from evaporator entering and leaving temperature control"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={178,-320})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConWatEvaMix
    "HRC evaporator CW mixing valve commanded position" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-320}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-100})));
equation
  connect(u1Chi, valEvaChi.uEna) annotation (Line(points={{-240,360},{-200,360},
          {-200,380},{-124,380},{-124,388}},
                                           color={255,0,255}));
  connect(u1Chi, valConChi.uEna) annotation (Line(points={{-240,360},{-200,360},
          {-200,340},{-104,340},{-104,348}},
                                        color={255,0,255}));
  connect(floConWatChi.y, valConChi.u_s) annotation (Line(points={{-148,360},{-112,
          360}},                     color={0,0,127}));
  connect(u1ChiHea, valEvaChiHea.uEna) annotation (Line(points={{-240,80},{-196,
          80},{-196,64},{-124,64},{-124,108}},
                                           color={255,0,255}));
  connect(u1ChiHea, valConChiHea.uEna) annotation (Line(points={{-240,80},{-196,
          80},{-196,4},{-122,4},{-122,8}},     color={255,0,255}));
  connect(floConWatChiHea.y, valConChiHea.u_s) annotation (Line(points={{-158,30},
          {-140,30},{-140,20},{-130,20}},color={0,0,127}));
  connect(mConChiHea_flow, fil6.u)
    annotation (Line(points={{-240,0},{-182,0}},     color={0,0,127}));
  connect(fil6.y, valConChiHea.u_m) annotation (Line(points={{-159,0},{-118,0},{
          -118,8}},         color={0,0,127}));
  connect(fil7.y, valEvaChiHea.u_m) annotation (Line(points={{-157,80},{-120,80},
          {-120,108}},      color={0,0,127}));
  connect(mEvaChiHea_flow, fil7.u) annotation (Line(points={{-240,100},{-190,100},
          {-190,80},{-180,80}},        color={0,0,127}));
  connect(valConChiHea.y, yValConChiHea)
    annotation (Line(points={{-106,20},{240,20}},   color={0,0,127}));
  connect(valEvaChiHea.y, yValEvaChiHea) annotation (Line(points={{-108,120},{-100,
          120},{-100,40},{240,40}},      color={0,0,127}));
  connect(mEvaChi_flow, fil2.u)
    annotation (Line(points={{-240,320},{-202,320}}, color={0,0,127}));
  connect(mConChi_flow, fil3.u)
    annotation (Line(points={{-240,300},{-172,300}},
                                                   color={0,0,127}));
  connect(fil3.y, valConChi.u_m) annotation (Line(points={{-149,300},{-100,300},
          {-100,348}},color={0,0,127}));
  connect(fil2.y, valEvaChi.u_m) annotation (Line(points={{-179,320},{-120,320},
          {-120,388}}, color={0,0,127}));
  connect(valEvaChi.y, yValEvaChi) annotation (Line(points={{-108,400},{200,400},
          {200,100},{240,100}},
                              color={0,0,127}));
  connect(valConChi.y, yValConChi) annotation (Line(points={{-88,360},{196,360},
          {196,80},{240,80}},
                            color={0,0,127}));
  connect(rep.y,intLes. u2) annotation (Line(points={{2,-160},{6,-160},{6,-168},
          {18,-168}}, color={255,127,0}));
  connect(intLes.y, heaOrCooCon.u2) annotation (Line(points={{42,-160},{46,-160},
          {46,-168},{68,-168}}, color={255,0,255}));
  connect(heaOrCooCon.y, yValConSwi.u)
    annotation (Line(points={{92,-160},{98,-160}}, color={255,0,255}));
  connect(numHeaAndOn.y, rep.u)
    annotation (Line(points={{-28,-160},{-22,-160}}, color={255,127,0}));
  connect(u1CooChiHea, hea.u) annotation (Line(points={{-240,60},{-200,60},{-200,
          -160},{-182,-160}}, color={255,0,255}));
  connect(u1ChiHea, heaAndOn.u1) annotation (Line(points={{-240,80},{-196,80},{-196,
          -140},{-130,-140},{-130,-160},{-122,-160}}, color={255,0,255}));
  connect(hea.y, heaAndOn.u2) annotation (Line(points={{-158,-160},{-140,-160},{
          -140,-168},{-122,-168}}, color={255,0,255}));
  connect(heaAndOn.y, booToInt.u)
    annotation (Line(points={{-98,-160},{-82,-160}},   color={255,0,255}));
  connect(idx.y, intLes.u1) annotation (Line(points={{-158,-104},{10,-104},{10,-160},
          {18,-160}},        color={255,127,0}));
  connect(cooAndOn.y, heaOrCooCon.u1) annotation (Line(points={{-98,-120},{50,-120},
          {50,-160},{68,-160}},       color={255,0,255}));
  connect(u1ChiHea, cooAndOn.u1) annotation (Line(points={{-240,80},{-196,80},{-196,
          -120},{-122,-120}}, color={255,0,255}));
  connect(u1CooChiHea, cooAndOn.u2) annotation (Line(points={{-240,60},{-200,60},
          {-200,-128},{-122,-128}}, color={255,0,255}));
  connect(cooOrDir.y,heaAndCas. u) annotation (Line(points={{-158,-40},{-154,-40},
          {-154,-80},{-152,-80}},                           color={255,0,255}));
  connect(booToInt1.y, numHeaAndCasAndOn.u)
    annotation (Line(points={{-58,-80},{-54,-80}},   color={255,127,0}));
  connect(numHeaAndCasAndOn.y, rep1.u)
    annotation (Line(points={{-30,-80},{-22,-80}},   color={255,127,0}));
  connect(rep1.y,intLes1. u2) annotation (Line(points={{2,-80},{10,-80},{10,-88},
          {28,-88}},         color={255,127,0}));
  connect(intLes1.y, heaOrCooEva.u2) annotation (Line(points={{52,-80},{56,-80},
          {56,-48},{68,-48}},         color={255,0,255}));
  connect(heaOrCooEva.y, yValEvaSwi.u)
    annotation (Line(points={{92,-40},{98,-40}},   color={255,0,255}));
  connect(u1CooChiHea, cooOrDir.u1) annotation (Line(points={{-240,60},{-200,60},
          {-200,-40},{-182,-40}},   color={255,0,255}));
  connect(u1HeaCooChiHea, cooOrDir.u2) annotation (Line(points={{-240,40},{-204,
          40},{-204,-48},{-182,-48}},    color={255,0,255}));
  connect(cooOrDir.y, cooOrDirAndOn.u2) annotation (Line(points={{-158,-40},{-154,
          -40},{-154,-48},{-122,-48}},    color={255,0,255}));
  connect(u1ChiHea, cooOrDirAndOn.u1) annotation (Line(points={{-240,80},{-196,80},
          {-196,-20},{-124,-20},{-124,-40},{-122,-40}},     color={255,0,255}));
  connect(heaAndCas.y, heaAndCasAndOn.u2) annotation (Line(points={{-128,-80},{-126,
          -80},{-126,-88},{-122,-88}},         color={255,0,255}));
  connect(u1ChiHea, heaAndCasAndOn.u1) annotation (Line(points={{-240,80},{-196,
          80},{-196,-20},{-124,-20},{-124,-80},{-122,-80}}, color={255,0,255}));
  connect(heaAndCasAndOn.y, booToInt1.u)
    annotation (Line(points={{-98,-80},{-82,-80}},   color={255,0,255}));
  connect(booToInt.y, numHeaAndOn.u)
    annotation (Line(points={{-58,-160},{-52,-160}}, color={255,127,0}));
  connect(idx.y, intLes1.u1) annotation (Line(points={{-158,-104},{20,-104},{20,
          -80},{28,-80}},   color={255,127,0}));
  connect(cooOrDirAndOn.y, heaOrCooEva.u1)
    annotation (Line(points={{-98,-40},{68,-40}},   color={255,0,255}));
  connect(yValEvaChi, isOpe2.u) annotation (Line(points={{240,100},{200,100},{200,
          140},{194,140}},
                         color={0,0,127}));
  connect(yValConChi, isOpe3.u) annotation (Line(points={{240,80},{196,80},{196,
          100},{194,100}},
                     color={0,0,127}));
  connect(yValEvaChiHea, isOpe.u) annotation (Line(points={{240,40},{200,40},{200,
          60},{194,60}},       color={0,0,127}));
  connect(yValConChiHea, isOpe1.u) annotation (Line(points={{240,20},{200,20},{200,
          0},{194,0}},          color={0,0,127}));
  connect(isOpe.y, cooOrDirAndOnAndOpe.u1) annotation (Line(points={{170,60},{36,
          60},{36,380},{48,380}},      color={255,0,255}));
  connect(cooOrDirAndOn.y, cooOrDirAndOnAndOpe.u2) annotation (Line(points={{-98,-40},
          {32,-40},{32,388},{48,388}},             color={255,0,255}));
  connect(isOpe2.y, onAndOpe.u2) annotation (Line(points={{170,140},{160,140},{160,
          320},{40,320},{40,332},{48,332}},
                         color={255,0,255}));
  connect(u1Chi, onAndOpe.u1) annotation (Line(points={{-240,360},{-200,360},{-200,
          380},{-80,380},{-80,340},{48,340}},  color={255,0,255}));
  connect(isOpe3.y, onAndOpe1.u2) annotation (Line(points={{170,100},{40,100},{40,
          292},{48,292}},color={255,0,255}));
  connect(u1Chi, onAndOpe1.u1) annotation (Line(points={{-240,360},{-200,360},{-200,
          340},{-90,340},{-90,300},{48,300}},color={255,0,255}));
  connect(onAndOpe[1:nChi].y, enaPumChiWat.u[1:nChi])
    annotation (Line(points={{72,340},{98,340}},   color={255,0,255}));
  connect(cooOrDirAndOnAndOpe[1:nChiHea].y, enaPumChiWat.u[nChi+1:nChi+nChiHea]) annotation (Line(points={{72,380},
          {80,380},{80,340},{98,340}},     color={255,0,255}));
  connect(onAndOpe1[1:nChi].y, enaPumConWatCon.u[1:nChi])
    annotation (Line(points={{72,300},{98,300}},color={255,0,255}));
  connect(u1CooChiHea, cooAndOpe.u1) annotation (Line(points={{-240,60},{24,60},
          {24,270},{50,270}},      color={255,0,255}));
  connect(isOpe1.y, cooAndOpe.u2) annotation (Line(points={{170,0},{28,0},{28,262},
          {50,262}},             color={255,0,255}));
  connect(cooAndOpe[1:nChiHea].y, enaPumConWatCon.u[nChi+1:nChi+nChiHea]) annotation (Line(points={{74,270},
          {90,270},{90,300},{98,300}},
                                   color={255,0,255}));
  connect(heaAndOn.y, heaAndOn1AndOpe.u1) annotation (Line(points={{-98,-160},{-84,
          -160},{-84,-200},{68,-200}},  color={255,0,255}));
  connect(isOpe1.y, heaAndOn1AndOpe.u2) annotation (Line(points={{170,0},{160,0},
          {160,-180},{60,-180},{60,-208},{68,-208}},         color={255,0,255}));
  connect(heaAndOn1AndOpe.y, enaPumHeaWat.u)
    annotation (Line(points={{92,-200},{98,-200}},   color={255,0,255}));
  connect(heaAndCasAndOn.y, heaAndCasAndOnAndOpe.u1) annotation (Line(points={{-98,-80},
          {-90,-80},{-90,-100},{68,-100}},        color={255,0,255}));
  connect(isOpe.y, heaAndCasAndOnAndOpe.u2) annotation (Line(points={{170,60},{60,
          60},{60,-108},{68,-108}},     color={255,0,255}));
  connect(heaAndCasAndOnAndOpe.y, enaPumConWatEva.u)
    annotation (Line(points={{92,-100},{98,-100}}, color={255,0,255}));
  connect(enaPumChiWat.y, y1PumChiWat)
    annotation (Line(points={{122,340},{240,340}}, color={255,0,255}));
  connect(enaPumConWatCon.y, y1PumConWatCon)
    annotation (Line(points={{122,300},{240,300}},
                                                 color={255,0,255}));
  connect(enaPumHeaWat.y, y1PumHeaWat) annotation (Line(points={{122,-200},{240,
          -200}},                       color={255,0,255}));
  connect(rep2.y, valEvaChi.u_s)
    annotation (Line(points={{-178,400},{-132,400}}, color={0,0,127}));
  connect(rep2.u, mEvaChiSet_flow)
    annotation (Line(points={{-202,400},{-240,400}}, color={0,0,127}));
  connect(rep3.u, mEvaChiHeaSet_flow)
    annotation (Line(points={{-212,120},{-240,120}},
                                                   color={0,0,127}));
  connect(yValEvaSwi.y, yValEvaSwiChiHea) annotation (Line(points={{122,-40},{200,
          -40},{200,-20},{240,-20}},        color={0,0,127}));
  connect(enaPumConWatEva.y, y1PumConWatEva)
    annotation (Line(points={{122,-100},{240,-100}}, color={255,0,255}));
  connect(u1ChiHea, dirHeaCooAndOn.u1) annotation (Line(points={{-240,80},{-196,
          80},{-196,-240},{-182,-240}}, color={255,0,255}));
  connect(u1HeaCooChiHea, dirHeaCooAndOn.u2) annotation (Line(points={{-240,40},
          {-204,40},{-204,-248},{-182,-248}}, color={255,0,255}));
  connect(dirHeaCooAndOn.y, anyDirHeaCooAndOn.u)
    annotation (Line(points={{-158,-240},{-142,-240}}, color={255,0,255}));
  connect(TConEntChiHeaSet, valConSwi.u_s)
    annotation (Line(points={{-240,-260},{-82,-260}}, color={0,0,127}));
  connect(anyDirHeaCooAndOn.y, valConSwi.uEna) annotation (Line(points={{-118,-240},
          {-100,-240},{-100,-276},{-74,-276},{-74,-272}},       color={255,0,
          255}));
  connect(valConSwi.y, rep4.u)
    annotation (Line(points={{-58,-260},{-52,-260}}, color={0,0,127}));
  connect(equIdx.y, selCtl.u2) annotation (Line(points={{12,-228},{20,-228},{20,
          -260},{28,-260}}, color={255,0,255}));
  connect(rep4.y, selCtl.u1) annotation (Line(points={{-28,-260},{0,-260},{0,-252},
          {28,-252}},       color={0,0,127}));
  connect(zer.y, selCtl.u3) annotation (Line(points={{12,-280},{20,-280},{20,-268},
          {28,-268}},       color={0,0,127}));
  connect(yValConSwi.y, max1.u1) annotation (Line(points={{122,-160},{140,-160},
          {140,-154},{168,-154}}, color={0,0,127}));
  connect(max1.y, yValConSwiChiHea) annotation (Line(points={{192,-160},{200,-160},
          {200,-60},{240,-60}},       color={0,0,127}));
  connect(selCtl.y, max1.u2) annotation (Line(points={{52,-260},{140,-260},{140,
          -166},{168,-166}}, color={0,0,127}));
  connect(TConEntChiHea, extT.u)
    annotation (Line(points={{-240,-280},{-182,-280}}, color={0,0,127}));
  connect(idxHig.y, extT.index) annotation (Line(points={{-159,-220},{-150,-220},
          {-150,-296},{-170,-296},{-170,-292}}, color={255,127,0}));
  connect(extT.y, valConSwi.u_m) annotation (Line(points={{-158,-280},{-70,-280},
          {-70,-272}}, color={0,0,127}));
  connect(idxHig.y, rep5.u)
    annotation (Line(points={{-159,-220},{-82,-220}}, color={255,127,0}));
  connect(idxChiHea.y, equIdx.u2)
    annotation (Line(points={{-29,-236},{-12,-236}}, color={255,127,0}));
  connect(rep5.y, equIdx.u1) annotation (Line(points={{-58,-220},{-20,-220},{-20,
          -228},{-12,-228}},     color={255,127,0}));
  connect(heaAndCasAndOn.y, ctlTConWatEvaLvg.uEna) annotation (Line(points={{-98,
          -80},{-90,-80},{-90,140},{-104,140},{-104,168}}, color={255,0,255}));
  connect(TEvaLvgChiHea, ctlTConWatEvaLvg.u_m) annotation (Line(points={{-240,160},
          {-100,160},{-100,168}}, color={0,0,127}));
  connect(TConWatEvaLvgSetCst.y, TConWatEvaLvgSet.u)
    annotation (Line(points={{-188,180},{-172,180}}, color={0,0,127}));
  connect(idxCycTan, TConWatEvaLvgSet.index) annotation (Line(points={{-240,220},
          {-180,220},{-180,164},{-160,164},{-160,168}}, color={255,127,0}));
  connect(rep6.y, ctlTConWatEvaLvg.u_s)
    annotation (Line(points={{-118,180},{-112,180}}, color={0,0,127}));
  connect(TConWatEvaLvgSet.y, rep6.u)
    annotation (Line(points={{-148,180},{-142,180}}, color={0,0,127}));
  connect(yVal[:, 2].y,valEvaEnt. f2) annotation (Line(points={{-58,200},{-46,200},
          {-46,212},{-42,212}},
                        color={0,0,127}));
  connect(yVal[:, 1].y,valEvaEnt. f1) annotation (Line(points={{-58,200},{-46,200},
          {-46,224},{-42,224}},
                        color={0,0,127}));
  connect(xVal[:, 1].y,valEvaEnt. x1) annotation (Line(points={{-58,240},{-48,240},
          {-48,228},{-42,228}},
                            color={0,0,127}));
  connect(xVal[:, 2].y,valEvaEnt. x2) annotation (Line(points={{-58,240},{-48,240},
          {-48,216},{-42,216}},
                            color={0,0,127}));
  connect(yFlo[:, 2].y, floEva.f2) annotation (Line(points={{-58,120},{-46,120},
          {-46,132},{-42,132}}, color={0,0,127}));
  connect(yFlo[:, 1].y, floEva.f1) annotation (Line(points={{-58,120},{-46,120},
          {-46,144},{-42,144}}, color={0,0,127}));
  connect(xFlo[:, 1].y, floEva.x1) annotation (Line(points={{-58,160},{-48,160},
          {-48,148},{-42,148}}, color={0,0,127}));
  connect(xFlo[:, 2].y, floEva.x2) annotation (Line(points={{-58,160},{-48,160},
          {-48,136},{-42,136}}, color={0,0,127}));
  connect(heaAndCasAndOn.y, selFloSet.u2) annotation (Line(points={{-98,-80},{-90,
          -80},{-90,140},{-176,140},{-176,120},{-174,120}}, color={255,0,255}));
  connect(rep3.y, selFloSet.u3) annotation (Line(points={{-188,120},{-184,120},{
          -184,112},{-174,112}}, color={0,0,127}));
  connect(ctlTConWatEvaLvg.y, valEvaEnt.u) annotation (Line(points={{-88,180},{-44,
          180},{-44,220},{-42,220}}, color={0,0,127}));
  connect(ctlTConWatEvaLvg.y, floEva.u) annotation (Line(points={{-88,180},{-44,
          180},{-44,140},{-42,140}}, color={0,0,127}));
  connect(selFloSet.y, valEvaChiHea.u_s)
    annotation (Line(points={{-150,120},{-132,120}}, color={0,0,127}));
  connect(floEva.y, selFloSet.u1) annotation (Line(points={{-18,140},{-10,140},{
          -10,100},{-180,100},{-180,128},{-174,128}}, color={0,0,127}));
  connect(TConWatEvaEnt, ctlTConWatEvaEnt.u_m) annotation (Line(points={{-240,-340},
          {-20,-340},{-20,-332}}, color={0,0,127}));
  connect(anyHeaAndCasAndOn.y, ctlTConWatEvaEnt.uEna) annotation (Line(points={{
          -48,-300},{-40,-300},{-40,-336},{-24,-336},{-24,-332}}, color={255,0,255}));
  connect(heaAndCasAndOn.y, anyHeaAndCasAndOn.u) annotation (Line(points={{-98,-80},
          {-90,-80},{-90,-300},{-72,-300}}, color={255,0,255}));
  connect(TConWatEvaEntSet.y, ctlTConWatEvaEnt.u_s)
    annotation (Line(points={{-178,-320},{-32,-320}}, color={0,0,127}));
  connect(ctlTConWatEvaEnt.y, mulMin.u[nChiHea+1])
    annotation (Line(points={{-8,-320},{80,-320},{80,-320},{166,-320}},
                                                    color={0,0,127}));
  connect(valEvaEnt.y, mulMin.u[1:nChiHea]) annotation (Line(points={{-18,220},
          {154,220},{154,-320},{166,-320}},
                                      color={0,0,127}));
  connect(mulMin.y, yValConWatEvaMix)
    annotation (Line(points={{190,-320},{240,-320}}, color={0,0,127}));
  annotation (
  defaultComponentName="valCmd",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,160}}),
                         graphics={
        Rectangle(
          extent={{-100,-160},{100,160}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,170},{150,210}},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-220,-420},{220,420}})),
    Documentation(info="<html>
Isolation valve control loops are biased to launch from 100 % (valve full open).
</html>"));
end ValvesCondenserEvaporator;
