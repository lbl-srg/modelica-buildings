within Buildings.ChillerWSE;
model WSE "This is a temporary model for WSE"
  extends Buildings.ChillerWSE.BaseClasses.PartialParallelPlant(
   final n=1,
   redeclare each final Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1[n](
      each final R=R,
      each final delta0=delta0,
      redeclare each final replaceable package Medium = Medium1,
      each final m_flow_nominal=m1_flow_nominal,
      each final dpValve_nominal=dpValve1_nominal,
      each final dpFixed_nominal=dp1_nominal,
      each final l=l1,
      each final kFixed=kFixed1,
      each final allowFlowReversal=allowFlowReversal1,
      each final show_T=show_T,
      each final from_dp=from_dp,
      each final homotopyInitialization=homotopyInitialization,
      each final linearized=linearized,
      each final deltaM=deltaM,
      each final rhoStd=rhoStd,
      each final use_inputFilter=use_inputFilter,
      each final riseTime=riseTimeValve,
      each final init=initValve,
      each final y_start=yValve1_start),
    redeclare each final Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val2[n](
      each final R=R,
      each final delta0=delta0,
      redeclare each final replaceable package Medium = Medium2,
      each final m_flow_nominal=m2_flow_nominal,
      each final dpValve_nominal=dpValve2_nominal,
      each final dpFixed_nominal=dp2_nominal,
      each final l=l2,
      each final kFixed=kFixed2,
      each final allowFlowReversal=allowFlowReversal2,
      each final show_T=show_T,
      each final from_dp=from_dp,
      each final homotopyInitialization=homotopyInitialization,
      each final linearized=linearized,
      each final deltaM=deltaM,
      each final rhoStd=rhoStd,
      each final use_inputFilter=use_inputFilter,
      each final riseTime=riseTimeValve,
      each final init=initValve,
      each final y_start=yValve2_start));

  parameter Real R=50 "Rangeability, R=50...100 typically"
  annotation(Dialog(group="Valve"));
  parameter Real delta0=0.01
    "Range of significant deviation from equal percentage law"
    annotation(Dialog(group="Valve"));

  Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final show_T=show_T,
    final from_dp1=from_dp1,
    linearizeFlowResistance1=linearizeFlowResistance1,
    deltaM1=deltaM1,
    from_dp2=from_dp2,
    linearizeFlowResistance2=linearizeFlowResistance2,
    deltaM2=deltaM2,
    final homotopyInitialization=homotopyInitialization) "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Math.BooleanToReal booToRea(each final realTrue=1, each final
            realFalse=0) "Boolean to real (if true then 1 else 0)"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(port_a1, hex.port_a1) annotation (Line(points={{-100,60},{-40,60},{-40,
          6},{-10,6}}, color={0,127,255}));
  connect(hex.port_b1, val1[1].port_a) annotation (Line(points={{10,6},{26,6},{40,
          6},{40,22}}, color={0,127,255}));
  connect(hex.port_b2, val2[1].port_a)
    annotation (Line(points={{-10,-6},{-40,-6},{-40,-22}}, color={0,127,255}));
  connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{40,-6},{40,
          -60},{100,-60}},     color={0,127,255}));
  connect(on,booToRea. u) annotation (Line(points={{-120,40},{-101,40},{-82,40}},
        color={255,0,255}));
  connect(booToRea.y, val2[1].y) annotation (Line(points={{-59,40},{-56,40},{-56,
          -32},{-52,-32}}, color={0,0,127}));
  connect(booToRea.y, val1[1].y) annotation (Line(points={{-59,40},{20,40},{20,32},
          {28,32}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WSE;
