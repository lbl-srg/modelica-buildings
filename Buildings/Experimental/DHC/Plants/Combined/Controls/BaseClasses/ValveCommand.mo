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

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput idxCycTan(final min=1,
      final max=2)
    "Index of active tank cycle"
    annotation (Placement(transformation(extent={{-260,-300},{-220,-260}}),
    iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Chi[nChi]
    "Cooling-only chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,140}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiHea[nChiHea]
    "HR chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,0}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,60})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooChiHea[nChiHea]
    "HR chiller cooling mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,-20}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaCooChiHea[nChiHea]
    "HR chiller direct heat recovery switchover command: true for direct HR, false for cascading"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,-40}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,20})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode(
    final min=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.tankCharge,
    final max=Buildings.Experimental.DHC.Plants.Combined.Controls.ModeCondenserLoop.heatRejection)
    "Condenser loop operating mode"
    annotation (Placement(transformation(extent={{-260,-280},{-220,-240}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChi_flow[nChi](
    each final unit="kg/s")
    "Chiller evaporator barrel mass flow rate" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConChi_flow[nChi](
    each final unit="kg/s")
    "Chiller condenser barrel mass flow rate" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEvaChiHea_flow[nChiHea](
    each final unit="kg/s")
    "HRC evaporator barrel mass flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,-60}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mConChiHea_flow[nChiHea](
    each final unit="kg/s")
    "HRC condenser barrel mass flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,-80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-60})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaChi[nChi]
    "Cooling-only chiller evaporator isolation valve commanded position"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,20}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,80})));
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
        origin={120,60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEvaChiHea[nChiHea](each final
            unit="1") "HRC evaporator isolation valve commanded position"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-40}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValConChiHea[nChiHea](each final
            unit="1") "HRC condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={240,-60}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-20})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valEvaChi[nChi](
    each k=0.1,
    each Ti=60,
    each final r=mChiWatChi_flow_nominal,
    each final yMin=0.1,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=0.1,
    each final y_neutral=0) "Chiller evaporator isolation valve control"
    annotation (Placement(transformation(extent={{-130,170},{-110,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floChiWatChi[nChi](
      each final k=mChiWatChi_flow_nominal) "Chiller CHW flow setpoint"
    annotation (Placement(transformation(extent={{-170,170},{-150,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floConWatChi[nChi](
      each final k=mConWatChi_flow_nominal) "Chiller CW flow setpoint"
    annotation (Placement(transformation(extent={{-170,130},{-150,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floConWatChiHea[nChiHea](
      each final k=mConWatChiHea_flow_nominal) "HRC CW flow setpoint"
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floChiWatChiHea[nChiHea](
      each final k=mChiWatChiHea_flow_nominal) "HRC CHW flow setpoint"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));

  EnergyTransferStations.Combined.Controls.PIDWithEnable valConChi[nChi](
    each k=0.1,
    each Ti=60,
    each final r=mConWatChi_flow_nominal,
    each final yMin=0.1,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=0.1,
    each final y_neutral=0) "Chiller condenser isolation valve control"
    annotation (Placement(transformation(extent={{-110,130},{-90,150}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valEvaChiHea[nChiHea](
    each k=0.1,
    each Ti=60,
    each final r=mChiWatChiHea_flow_nominal,
    each final yMin=0.1,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=0.1,
    each final y_neutral=0) "HRC evaporator isolation valve control"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable valConChiHea[nChiHea](
    each k=0.1,
    each Ti=60,
    each final r=mConWatChiHea_flow_nominal,
    each final yMin=0.1,
    each final yMax=1,
    each final reverseActing=true,
    each final y_reset=0.1,
    each final y_neutral=0) "HRC condenser isolation valve control"
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
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nChiHea](each final
            integerTrue=1, each final integerFalse=0)
    "Convert"
    annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numHeaAndOn(nin=nChiHea)
    "Number of HRC connected to HW loop and On"
    annotation (Placement(transformation(extent={{-50,-250},{-30,-230}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes[nChiHea]
    "Return true if switchover valve to be open for heating operation"
    annotation (Placement(transformation(extent={{20,-250},{40,-230}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(final nout=
        nChiHea) "Replicate"
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
    annotation (Placement(transformation(extent={{-180,-190},{-160,-170}})));
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
  Buildings.Controls.OBC.CDL.Integers.Less intLes1
                                                 [nChiHea]
    "Return true if switchover valve to be open for heating operation"
    annotation (Placement(transformation(extent={{30,-170},{50,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaOrCooEva[nChiHea]
    "Return true if switchover valve to be open for heating or cooling operation"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-120})));
  Buildings.Controls.OBC.CDL.Logical.And cooOrDirAndOn[nChiHea]
    "Return true if (cooling OR direct HR) AND On" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,-120})));
  Buildings.Controls.OBC.CDL.Logical.And heaAndCasAndOn[nChiHea]
    "Return true if cascading heating AND On" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,-160})));
equation
  connect(u1Chi, valEvaChi.uEna) annotation (Line(points={{-240,140},{-200,140},
          {-200,160},{-124,160},{-124,168}},
                                           color={255,0,255}));
  connect(floChiWatChi.y, valEvaChi.u_s) annotation (Line(points={{-148,180},{
          -132,180}},                 color={0,0,127}));
  connect(u1Chi, valConChi.uEna) annotation (Line(points={{-240,140},{-200,140},
          {-200,120},{-104,120},{-104,128}},
                                        color={255,0,255}));
  connect(floConWatChi.y, valConChi.u_s) annotation (Line(points={{-148,140},{
          -112,140}},                color={0,0,127}));
  connect(floChiWatChiHea.y, valEvaChiHea.u_s) annotation (Line(points={{-158,20},
          {-140,20},{-140,0},{-132,0}},color={0,0,127}));
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
  connect(mEvaChiHea_flow, fil7.u) annotation (Line(points={{-240,-60},{-190,
          -60},{-190,-20},{-182,-20}}, color={0,0,127}));
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
  connect(valConChi.y, yValConChi) annotation (Line(points={{-88,140},{194,140},
          {194,0},{240,0}}, color={0,0,127}));
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
  connect(u1ChiHea, heaAndOn.u1) annotation (Line(points={{-240,0},{-196,0},{
          -196,-220},{-120,-220},{-120,-240},{-112,-240}},
                                                      color={255,0,255}));
  connect(hea.y, heaAndOn.u2) annotation (Line(points={{-158,-240},{-140,-240},
          {-140,-248},{-112,-248}},color={255,0,255}));
  connect(heaAndOn.y, booToInt.u)
    annotation (Line(points={{-88,-240},{-82,-240}},   color={255,0,255}));
  connect(yValConSwi.y, yValConSwiChiHea) annotation (Line(points={{122,-240},{
          200,-240},{200,-140},{240,-140}},
                                        color={0,0,127}));
  connect(idx.y, intLes.u1) annotation (Line(points={{-158,-180},{10,-180},{10,
          -240},{18,-240}},  color={255,127,0}));
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
  connect(intLes1.y, heaOrCooEva.u2) annotation (Line(points={{52,-160},{60,
          -160},{60,-128},{68,-128}}, color={255,0,255}));
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
  connect(idx.y, intLes1.u1) annotation (Line(points={{-158,-180},{20,-180},{20,
          -160},{28,-160}}, color={255,127,0}));
  connect(cooOrDirAndOn.y, heaOrCooEva.u1)
    annotation (Line(points={{-88,-120},{68,-120}}, color={255,0,255}));
  connect(yValEvaSwi.y, yValEvaSwiChiHea) annotation (Line(points={{122,-120},{
          200,-120},{200,-100},{240,-100}}, color={0,0,127}));
  annotation (
  defaultComponentName="valCmd",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-220,-300},{220,300}})));
end ValveCommand;
