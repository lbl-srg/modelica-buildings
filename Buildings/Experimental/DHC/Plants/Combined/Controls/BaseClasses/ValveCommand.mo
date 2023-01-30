within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block ValveCommand
  "Block that computes command signal for isolation and switchover valves"

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

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput idxCycTan(final min=1,
      final max=2)
    "Index of active tank cycle"
    annotation (Placement(transformation(extent={{-260,-300},{-220,-260}}),
    iconTransformation(extent={{-140,-138},{-100,-98}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Chi[nChi]
    "Cooling-only chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,140}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,100})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiHea[nChiHea]
    "HR chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,0}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooChiHea[nChiHea]
    "HR chiller cooling mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,-20}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,60})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaCooChiHea[nChiHea]
    "HR chiller direct heat recovery switchover command: true for direct HR, false for cascading"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,-40}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode(
    final min=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.tankCharge,
    final max=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.heatRejection)
    "Condenser loop operating mode"
    annotation (Placement(transformation(extent={{-260,-280},{-220,-240}}),
        iconTransformation(extent={{-140,-118},{-100,-78}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChiSet_flow(final
      unit="kg/s") "Chiller evaporator flow setpoint" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,180}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChiHeaSet_flow(final
            unit="kg/s") "HRC evaporator flow setpoint" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChi_flow[nChi](
    each final unit="kg/s")
    "Chiller evaporator mass flow rate" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConChi_flow[nChi](
    each final unit="kg/s")
    "Chiller condenser mass flow rate" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-38})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChiHea_flow[nChiHea](
    each final unit="kg/s")
    "HRC evaporator mass flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,20}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-58})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConChiHea_flow[nChiHea](
    each final unit="kg/s")
    "HRC condenser mass flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,-80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-78})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWat
    "Enable signal for lead CHW pump"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,100})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWat
    "Enable signal for lead HW pump"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-280}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,80})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatCon
    "Enable signal for lead CW pump serving evaporator loop"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,80}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,60})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumConWatEva
    "Enable signal for lead CW pump serving evaporator loop"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-180}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaChi[nChi]
    "Cooling-only chiller evaporator isolation valve commanded position"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,20}), iconTransformation(
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
        origin={240,0}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaChiHea[nChiHea](each final
            unit="1") "HRC evaporator isolation valve commanded position"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-40}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConChiHea[nChiHea](each final
            unit="1") "HRC condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-60}),iconTransformation(
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
    annotation (Placement(transformation(extent={{-130,170},{-110,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floConWatChi[nChi](
      each final k=mConWatChi_flow_nominal) "Chiller CW flow setpoint"
    annotation (Placement(transformation(extent={{-170,130},{-150,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floConWatChiHea[nChiHea](
      each final k=mConWatChiHea_flow_nominal) "HRC CW flow setpoint"
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));

  EnergyTransferStations.Combined.Controls.PIDWithEnable valConChi[nChi](
    each final r=mConWatChi_flow_nominal,
    each k=k,
    each Ti=Ti,
    each final yMin=yMin,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=y_reset,
    each final y_neutral=y_neutral)
    "Chiller condenser isolation valve control"
    annotation (Placement(transformation(extent={{-110,130},{-90,150}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valEvaChiHea[nChiHea](
    each final r=mChiWatChiHea_flow_nominal,
    each k=k,
    each Ti=Ti,
    each final yMin=yMin,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=y_reset,
    each final y_neutral=y_neutral)
    "HRC evaporator isolation valve control"
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
    annotation (Placement(transformation(extent={{-130,-70},{-110,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaSwiChiHea[nChiHea](
      each final unit="1") "HRC evaporator switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConSwiChiHea[nChiHea](
      each final unit="1") "HRC condenser switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-140}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-80})));
  Modelica.Blocks.Continuous.FirstOrder fil6[nChiHea](each T=60, each initType=
        Modelica.Blocks.Types.Init.InitialOutput)
    "Filter to break algebraic loop"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));
  Modelica.Blocks.Continuous.FirstOrder fil7[nChiHea](each T=60, each initType=
        Modelica.Blocks.Types.Init.InitialOutput)
    "Filter to break algebraic loop"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Modelica.Blocks.Continuous.FirstOrder fil2[nChi](each T=60, each initType=
        Modelica.Blocks.Types.Init.InitialOutput)
    "Filter to break algebraic loop"
    annotation (Placement(transformation(extent={{-200,90},{-180,110}})));
  Modelica.Blocks.Continuous.FirstOrder fil3[nChi](each T=60, each initType=
        Modelica.Blocks.Types.Init.InitialOutput)
    "Filter to break algebraic loop"
    annotation (Placement(transformation(extent={{-170,70},{-150,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yValConSwi[nChiHea]
    "HRC condenser switchover valve commanded position"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-240})));
  Buildings.Controls.OBC.CDL.Logical.Not hea[nChiHea] "Return true if heating"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-240})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nChiHea](
    each final integerTrue=1,
    each final integerFalse=0)
    "Convert"
    annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numHeaAndOn(nin=nChiHea)
    "Number of HRC connected to HW loop and On"
    annotation (Placement(transformation(extent={{-50,-250},{-30,-230}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes[nChiHea]
    "Return true if switchover valve to be open for heating operation"
    annotation (Placement(transformation(extent={{20,-250},{40,-230}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(
    final nout=nChiHea)
    "Replicate"
    annotation (Placement(transformation(extent={{-20,-250},{0,-230}})));
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
        origin={-100,-240})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idx[nChiHea](final k={i
        for i in 1:nChiHea}) "HRC index"
    annotation (Placement(transformation(extent={{-180,-194},{-160,-174}})));
  Buildings.Controls.OBC.CDL.Logical.And cooAndOn[nChiHea]
    "Return true if cooling AND On" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,-200})));
  Buildings.Controls.OBC.CDL.Logical.Or cooOrDir[nChiHea]
    "Return true if cooling OR direct HR" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-120})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yValEvaSwi[nChiHea]
    "HRC evaporator switchover valve commanded position" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-120})));
  Buildings.Controls.OBC.CDL.Logical.Not heaAndCas[nChiHea]
    "Return true if cascading heating" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-140,-160})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nChiHea]
    "Convert"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numHeaAndCasAndOn(nin=nChiHea)
    "Number of HRC in cascading heating AND On"
    annotation (Placement(transformation(extent={{-52,-170},{-32,-150}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep1(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-20,-170},{0,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes1[nChiHea]
    "Return true if switchover valve to be open for heating operation"
    annotation (Placement(transformation(extent={{30,-170},{50,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaOrCooEva[nChiHea]
    "Return true if switchover valve to be open for heating or cooling operation"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-120})));
  Buildings.Controls.OBC.CDL.Logical.And cooOrDirAndOn[nChiHea]
    "Return true if (cooling OR direct HR) AND On"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,-120})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndCasAndOn[nChiHea]
    "Return true if cascading heating AND On"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,-160})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe[nChiHea](each t=0.1,
      each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{192,-30},{172,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe1[nChiHea](each t
      =0.1, each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{192,-90},{172,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe2[nChi](each t=0.1,
      each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{192,50},{172,70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe3[nChi](each t=0.1,
      each h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{192,10},{172,30}})));
  Buildings.Controls.OBC.CDL.Logical.And cooOrDirAndOnAndOpe[nChiHea]
    "Return true if (cooling OR direct HR) AND On AND isolation valve open"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-18,-100})));
  Buildings.Controls.OBC.CDL.Logical.And onAndOpe[nChi]
    "Return true if On AND isolation valve open" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,120})));
  Buildings.Controls.OBC.CDL.Logical.And onAndOpe1[nChi]
    "Return true if On AND isolation valve open" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,80})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumChiWat(nin=nChi+nChiHea)
    "Enable signal for lead CHW pump"
                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,120})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumConWatCon(nin=nChi+nChiHea)
    "Enable signal for lead CW pump serving condenser loop"
                                                        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,80})));
  Buildings.Controls.OBC.CDL.Logical.And cooAndOpe[nChiHea]
    "Return true if cooling (necessarily cascading) AND isolation valve open"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-100})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumHeaWat(nin=nChiHea)
    "Enable signal for lead HW pump"
                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-280})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaPumConWatEva(nin=nChiHea)
    "Enable signal for lead CW pump serving evaporator loop"
                                                         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-180})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndOn1AndOpe[nChiHea]
    "Return true if heating AND On AND isolation valve open" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-280})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndCasAndOnAndOpe[nChiHea]
    "Return true if cascading heating AND On AND isolation valve open"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-180})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep2(final nout=nChi)
    "Replicate"
    annotation (Placement(transformation(extent={{-200,170},{-180,190}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep3(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
equation
  connect(u1Chi, valEvaChi.uEna) annotation (Line(points={{-240,140},{-200,140},
          {-200,160},{-124,160},{-124,168}},
                                           color={255,0,255}));
  connect(u1Chi, valConChi.uEna) annotation (Line(points={{-240,140},{-200,140},
          {-200,120},{-104,120},{-104,128}},
                                        color={255,0,255}));
  connect(floConWatChi.y, valConChi.u_s) annotation (Line(points={{-148,140},{
          -112,140}},                color={0,0,127}));
  connect(u1ChiHea, valEvaChiHea.uEna) annotation (Line(points={{-240,0},{-144,
          0},{-144,-16},{-124,-16},{-124,-12}},
                                           color={255,0,255}));
  connect(u1ChiHea, valConChiHea.uEna) annotation (Line(points={{-240,0},{-144,
          0},{-144,-76},{-124,-76},{-124,-72}},color={255,0,255}));
  connect(floConWatChiHea.y, valConChiHea.u_s) annotation (Line(points={{-158,
          -50},{-140,-50},{-140,-60},{-132,-60}},
                                         color={0,0,127}));
  connect(mConChiHea_flow, fil6.u)
    annotation (Line(points={{-240,-80},{-182,-80}}, color={0,0,127}));
  connect(fil6.y, valConChiHea.u_m) annotation (Line(points={{-159,-80},{-120,
          -80},{-120,-72}}, color={0,0,127}));
  connect(fil7.y, valEvaChiHea.u_m) annotation (Line(points={{-159,-20},{-120,
          -20},{-120,-12}}, color={0,0,127}));
  connect(mEvaChiHea_flow, fil7.u) annotation (Line(points={{-240,20},{-190,20},
          {-190,-20},{-182,-20}},      color={0,0,127}));
  connect(valConChiHea.y, yValConChiHea)
    annotation (Line(points={{-108,-60},{240,-60}}, color={0,0,127}));
  connect(valEvaChiHea.y, yValEvaChiHea) annotation (Line(points={{-108,0},{
          -100,0},{-100,-40},{240,-40}}, color={0,0,127}));
  connect(mEvaChi_flow, fil2.u)
    annotation (Line(points={{-240,100},{-202,100}}, color={0,0,127}));
  connect(mConChi_flow, fil3.u)
    annotation (Line(points={{-240,80},{-172,80}}, color={0,0,127}));
  connect(fil3.y, valConChi.u_m) annotation (Line(points={{-149,80},{-100,80},{
          -100,128}}, color={0,0,127}));
  connect(fil2.y, valEvaChi.u_m) annotation (Line(points={{-179,100},{-120,100},
          {-120,168}}, color={0,0,127}));
  connect(valEvaChi.y, yValEvaChi) annotation (Line(points={{-108,180},{200,180},
          {200,20},{240,20}}, color={0,0,127}));
  connect(valConChi.y, yValConChi) annotation (Line(points={{-88,140},{196,140},
          {196,0},{240,0}}, color={0,0,127}));
  connect(rep.y,intLes. u2) annotation (Line(points={{2,-240},{6,-240},{6,-248},
          {18,-248}}, color={255,127,0}));
  connect(intLes.y, heaOrCooCon.u2) annotation (Line(points={{42,-240},{46,-240},
          {46,-248},{68,-248}}, color={255,0,255}));
  connect(heaOrCooCon.y, yValConSwi.u)
    annotation (Line(points={{92,-240},{98,-240}}, color={255,0,255}));
  connect(numHeaAndOn.y, rep.u)
    annotation (Line(points={{-28,-240},{-22,-240}}, color={255,127,0}));
  connect(u1CooChiHea, hea.u) annotation (Line(points={{-240,-20},{-200,-20},{-200,
          -240},{-182,-240}}, color={255,0,255}));
  connect(u1ChiHea, heaAndOn.u1) annotation (Line(points={{-240,0},{-196,0},{-196,
          -220},{-120,-220},{-120,-240},{-112,-240}}, color={255,0,255}));
  connect(hea.y, heaAndOn.u2) annotation (Line(points={{-158,-240},{-140,-240},
          {-140,-248},{-112,-248}},color={255,0,255}));
  connect(heaAndOn.y, booToInt.u)
    annotation (Line(points={{-88,-240},{-82,-240}},   color={255,0,255}));
  connect(yValConSwi.y, yValConSwiChiHea) annotation (Line(points={{122,-240},{
          200,-240},{200,-140},{240,-140}},
                                        color={0,0,127}));
  connect(idx.y, intLes.u1) annotation (Line(points={{-158,-184},{10,-184},{10,-240},
          {18,-240}},        color={255,127,0}));
  connect(cooAndOn.y, heaOrCooCon.u1) annotation (Line(points={{-88,-200},{50,
          -200},{50,-240},{68,-240}}, color={255,0,255}));
  connect(u1ChiHea, cooAndOn.u1) annotation (Line(points={{-240,0},{-196,0},{
          -196,-200},{-112,-200}},
                              color={255,0,255}));
  connect(u1CooChiHea, cooAndOn.u2) annotation (Line(points={{-240,-20},{-200,
          -20},{-200,-208},{-112,-208}},
                                    color={255,0,255}));
  connect(cooOrDir.y,heaAndCas. u) annotation (Line(points={{-158,-120},{-154,-120},
          {-154,-160},{-152,-160}},                         color={255,0,255}));
  connect(booToInt1.y, numHeaAndCasAndOn.u)
    annotation (Line(points={{-58,-160},{-54,-160}}, color={255,127,0}));
  connect(numHeaAndCasAndOn.y, rep1.u)
    annotation (Line(points={{-30,-160},{-22,-160}}, color={255,127,0}));
  connect(rep1.y,intLes1. u2) annotation (Line(points={{2,-160},{10,-160},{10,
          -168},{28,-168}},  color={255,127,0}));
  connect(intLes1.y, heaOrCooEva.u2) annotation (Line(points={{52,-160},{56,-160},
          {56,-128},{68,-128}},       color={255,0,255}));
  connect(heaOrCooEva.y, yValEvaSwi.u)
    annotation (Line(points={{92,-120},{98,-120}}, color={255,0,255}));
  connect(u1CooChiHea, cooOrDir.u1) annotation (Line(points={{-240,-20},{-200,-20},
          {-200,-120},{-182,-120}}, color={255,0,255}));
  connect(u1HeaCooChiHea, cooOrDir.u2) annotation (Line(points={{-240,-40},{-204,
          -40},{-204,-128},{-182,-128}}, color={255,0,255}));
  connect(cooOrDir.y, cooOrDirAndOn.u2) annotation (Line(points={{-158,-120},{-154,
          -120},{-154,-128},{-112,-128}}, color={255,0,255}));
  connect(u1ChiHea, cooOrDirAndOn.u1) annotation (Line(points={{-240,0},{-196,0},
          {-196,-100},{-120,-100},{-120,-120},{-112,-120}}, color={255,0,255}));
  connect(heaAndCas.y, heaAndCasAndOn.u2) annotation (Line(points={{-128,-160},{
          -124,-160},{-124,-168},{-112,-168}}, color={255,0,255}));
  connect(u1ChiHea, heaAndCasAndOn.u1) annotation (Line(points={{-240,0},{-196,0},
          {-196,-100},{-120,-100},{-120,-160},{-112,-160}}, color={255,0,255}));
  connect(heaAndCasAndOn.y, booToInt1.u)
    annotation (Line(points={{-88,-160},{-82,-160}}, color={255,0,255}));
  connect(booToInt.y, numHeaAndOn.u)
    annotation (Line(points={{-58,-240},{-52,-240}}, color={255,127,0}));
  connect(idx.y, intLes1.u1) annotation (Line(points={{-158,-184},{20,-184},{20,
          -160},{28,-160}}, color={255,127,0}));
  connect(cooOrDirAndOn.y, heaOrCooEva.u1)
    annotation (Line(points={{-88,-120},{68,-120}}, color={255,0,255}));
  connect(yValEvaChi, isOpe2.u) annotation (Line(points={{240,20},{200,20},{200,
          60},{194,60}}, color={0,0,127}));
  connect(yValConChi, isOpe3.u) annotation (Line(points={{240,0},{196,0},{196,20},
          {194,20}}, color={0,0,127}));
  connect(yValEvaChiHea, isOpe.u) annotation (Line(points={{240,-40},{200,-40},{
          200,-20},{194,-20}}, color={0,0,127}));
  connect(yValConChiHea, isOpe1.u) annotation (Line(points={{240,-60},{200,-60},
          {200,-80},{194,-80}}, color={0,0,127}));
  connect(isOpe.y, cooOrDirAndOnAndOpe.u1) annotation (Line(points={{170,-20},{-40,
          -20},{-40,-100},{-30,-100}}, color={255,0,255}));
  connect(cooOrDirAndOn.y, cooOrDirAndOnAndOpe.u2) annotation (Line(points={{-88,
          -120},{-40,-120},{-40,-108},{-30,-108}}, color={255,0,255}));
  connect(isOpe2.y, onAndOpe.u2) annotation (Line(points={{170,60},{40,60},{40,112},
          {48,112}},     color={255,0,255}));
  connect(u1Chi, onAndOpe.u1) annotation (Line(points={{-240,140},{-200,140},{-200,
          160},{-80,160},{-80,120},{48,120}},  color={255,0,255}));
  connect(isOpe3.y, onAndOpe1.u2) annotation (Line(points={{170,20},{44,20},{44,
          72},{48,72}},  color={255,0,255}));
  connect(u1Chi, onAndOpe1.u1) annotation (Line(points={{-240,140},{-200,140},{-200,
          120},{-90,120},{-90,80},{48,80}},  color={255,0,255}));
  connect(onAndOpe[1:nChi].y, enaPumChiWat.u[1:nChi])
    annotation (Line(points={{72,120},{98,120}},   color={255,0,255}));
  connect(cooOrDirAndOnAndOpe[1:nChiHea].y, enaPumChiWat.u[nChi+1:nChi+nChiHea]) annotation (Line(points={{-6,-100},
          {80,-100},{80,120},{98,120}},    color={255,0,255}));
  connect(onAndOpe1[1:nChi].y, enaPumConWatCon.u[1:nChi])
    annotation (Line(points={{72,80},{98,80}},  color={255,0,255}));
  connect(u1CooChiHea, cooAndOpe.u1) annotation (Line(points={{-240,-20},{-200,-20},
          {-200,-100},{-82,-100}}, color={255,0,255}));
  connect(isOpe1.y, cooAndOpe.u2) annotation (Line(points={{170,-80},{-90,-80},{
          -90,-108},{-82,-108}}, color={255,0,255}));
  connect(cooAndOpe[1:nChiHea].y, enaPumConWatCon.u[nChi+1:nChi+nChiHea]) annotation (Line(points={{-58,
          -100},{-48,-100},{-48,66},{90,66},{90,80},{98,80}},
                                   color={255,0,255}));
  connect(heaAndOn.y, heaAndOn1AndOpe.u1) annotation (Line(points={{-88,-240},{-84,
          -240},{-84,-280},{68,-280}},  color={255,0,255}));
  connect(isOpe1.y, heaAndOn1AndOpe.u2) annotation (Line(points={{170,-80},{160,
          -80},{160,-260},{60,-260},{60,-288},{68,-288}},    color={255,0,255}));
  connect(heaAndOn1AndOpe.y, enaPumHeaWat.u)
    annotation (Line(points={{92,-280},{98,-280}},   color={255,0,255}));
  connect(heaAndCasAndOn.y, heaAndCasAndOnAndOpe.u1) annotation (Line(points={{-88,
          -160},{-86,-160},{-86,-180},{68,-180}}, color={255,0,255}));
  connect(isOpe.y, heaAndCasAndOnAndOpe.u2) annotation (Line(points={{170,-20},{
          60,-20},{60,-188},{68,-188}}, color={255,0,255}));
  connect(heaAndCasAndOnAndOpe.y, enaPumConWatEva.u)
    annotation (Line(points={{92,-180},{98,-180}}, color={255,0,255}));
  connect(enaPumChiWat.y, y1PumChiWat)
    annotation (Line(points={{122,120},{240,120}}, color={255,0,255}));
  connect(enaPumConWatCon.y, y1PumConWatCon)
    annotation (Line(points={{122,80},{240,80}}, color={255,0,255}));
  connect(enaPumHeaWat.y, y1PumHeaWat) annotation (Line(points={{122,-280},{177,
          -280},{177,-280},{240,-280}}, color={255,0,255}));
  connect(rep2.y, valEvaChi.u_s)
    annotation (Line(points={{-178,180},{-132,180}}, color={0,0,127}));
  connect(rep2.u, mEvaChiSet_flow)
    annotation (Line(points={{-202,180},{-240,180}}, color={0,0,127}));
  connect(rep3.u, mEvaChiHeaSet_flow)
    annotation (Line(points={{-202,40},{-240,40}}, color={0,0,127}));
  connect(rep3.y, valEvaChiHea.u_s) annotation (Line(points={{-178,40},{-140,40},
          {-140,0},{-132,0}}, color={0,0,127}));
  connect(yValEvaSwi.y, yValEvaSwiChiHea) annotation (Line(points={{122,-120},{
          200,-120},{200,-100},{240,-100}}, color={0,0,127}));
  connect(enaPumConWatEva.y, y1PumConWatEva)
    annotation (Line(points={{122,-180},{240,-180}}, color={255,0,255}));
  annotation (
  defaultComponentName="valCmd",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}}),
                         graphics={
        Rectangle(
          extent={{-100,-120},{100,120}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,130},{150,170}},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-220,-300},{220,300}})));
end ValveCommand;
