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
  parameter Modelica.SIunits.Efficiency eps=0.8 "Efficiency of heat exchangers";

  Buildings.ChillerWSE.BaseClasses.WSEWithTControl hex(
    redeclare package MediumCHW = Medium1,
    redeclare package MediumCW = Medium2,
    dpCHW_nominal=dp1_nominal,
    dpCW_nominal=dp2_nominal,
    mCHW_flow_nominal=m1_flow_nominal,
    mCW_flow_nominal=m2_flow_nominal,
    GaiPi=1,
    tIntPi=60,
    dp_byp_nominal=100000,
    eps=eps)                                             "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,0})));
  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Math.BooleanToReal booToRea(each final realTrue=1, each final
            realFalse=0) "Boolean to real (if true then 1 else 0)"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Interfaces.RealInput TSet "temperature set point"
    annotation (Placement(transformation(extent={{-140,-34},{-100,6}})));
equation
  connect(on,booToRea. u) annotation (Line(points={{-120,40},{-101,40},{-82,40}},
        color={255,0,255}));
  connect(booToRea.y, val2[1].y) annotation (Line(points={{-59,40},{-56,40},{-56,
          -32},{-52,-32}}, color={0,0,127}));
  connect(booToRea.y, val1[1].y) annotation (Line(points={{-59,40},{20,40},{20,32},
          {28,32}}, color={0,0,127}));
  connect(port_a1, hex.port_a_CW) annotation (Line(points={{-100,60},{-42,60},{-42,
          10},{-8,10}}, color={0,127,255}));
  connect(hex.port_b_CW, val1[1].port_a)
    annotation (Line(points={{8,10},{40,10},{40,22}}, color={0,127,255}));
  connect(port_a2, hex.port_a_CHW) annotation (Line(points={{100,-60},{38,-60},{
          38,-10},{8,-10}}, color={0,127,255}));
  connect(hex.port_b_CHW, val2[1].port_a) annotation (Line(points={{-8,-10},{-40,
          -10},{-40,-22}}, color={0,127,255}));
  connect(booToRea.y, hex.on) annotation (Line(points={{-59,40},{-30,40},{2.4,40},
          {2.4,11}}, color={0,0,127}));
  connect(hex.TSet, TSet) annotation (Line(points={{-1.6,11},{-1.6,22},{-56,22},
          {-56,-14},{-120,-14}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WSE;
