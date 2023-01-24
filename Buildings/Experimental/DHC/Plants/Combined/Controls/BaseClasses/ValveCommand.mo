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
    annotation (Placement(transformation(extent={{-260,-180},{-220,-140}}),
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
    annotation (Placement(transformation(extent={{-260,-160},{-220,-120}}),
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
  Buildings.Controls.OBC.CDL.Logical.Or cooOrDir[nChiHea]
    "Return true if cooling OR direct HR" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-100})));
  Buildings.Controls.OBC.CDL.Logical.Not heaAndCas[nChi]
    "Return true if heating AND cascading HR" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-100})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yHeaAndCas[nChiHea]
    "Return 1 if heating AND cascading HR" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-100})));
  Buildings.Controls.OBC.CDL.Logical.Not hea[nChiHea] "Return true if heating"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-140})));
  Buildings.Controls.OBC.CDL.Logical.Or heaOrDir[nChiHea]
    "Return true if heating OR direct HR" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-140})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yHeaOrDir[nChiHea]
    "Return 1 if heating OR direct HR" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-140})));
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
  connect(heaAndCas.y, yHeaAndCas.u)
    annotation (Line(points={{-38,-100},{-22,-100}},
                                                   color={255,0,255}));
  connect(cooOrDir.y, heaAndCas.u)
    annotation (Line(points={{-78,-100},{-62,-100}},
                                                 color={255,0,255}));
  connect(hea.y, heaOrDir.u1)
    annotation (Line(points={{-78,-140},{-62,-140}},
                                                 color={255,0,255}));
  connect(heaOrDir.y, yHeaOrDir.u)
    annotation (Line(points={{-38,-140},{-22,-140}},
                                                   color={255,0,255}));
  connect(u1CooChiHea, cooOrDir.u1) annotation (Line(points={{-240,-20},{-200,
          -20},{-200,-100},{-102,-100}},
                                   color={255,0,255}));
  connect(u1CooChiHea, hea.u) annotation (Line(points={{-240,-20},{-200,-20},{
          -200,-140},{-102,-140}},
                             color={255,0,255}));
  connect(u1HeaCooChiHea, heaOrDir.u2) annotation (Line(points={{-240,-40},{
          -210,-40},{-210,-120},{-70,-120},{-70,-148},{-62,-148}},
                                                        color={255,0,255}));
  connect(u1HeaCooChiHea, cooOrDir.u2) annotation (Line(points={{-240,-40},{
          -210,-40},{-210,-108},{-102,-108}},
                                        color={255,0,255}));
  connect(mConChiHea_flow, fil6.u)
    annotation (Line(points={{-240,-80},{-182,-80}}, color={0,0,127}));
  connect(fil6.y, valConChiHea.u_m) annotation (Line(points={{-159,-80},{-120,
          -80},{-120,-72}}, color={0,0,127}));
  connect(fil7.y, valEvaChiHea.u_m) annotation (Line(points={{-159,-20},{-120,
          -20},{-120,-12}}, color={0,0,127}));
  connect(mEvaChiHea_flow, fil7.u) annotation (Line(points={{-240,-60},{-190,
          -60},{-190,-20},{-182,-20}}, color={0,0,127}));
  connect(yHeaAndCas.y, yValEvaSwiChiHea)
    annotation (Line(points={{2,-100},{240,-100}},   color={0,0,127}));
  connect(yHeaOrDir.y, yValConSwiChiHea)
    annotation (Line(points={{2,-140},{240,-140}},   color={0,0,127}));
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
          extent={{-220,-220},{220,220}})));
end ValveCommand;
