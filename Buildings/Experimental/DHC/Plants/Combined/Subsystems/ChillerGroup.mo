within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model ChillerGroup
  "Model of multiple identical chillers in parallel"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    final m1_flow_nominal = mConWat_flow_nominal,
    final m2_flow_nominal = mChiWat_flow_nominal);

  parameter Integer nUni(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation(Evaluate=true);
  final parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    dat.TEvaLvg_nominal
    "Design (minimum) CHW supply temperature";
  final parameter Modelica.Units.SI.Temperature TConWatLvg_nominal=
    dat.TConLvg_nominal
    "Design (maximum) CW leaving temperature";
  final parameter Modelica.Units.SI.HeatFlowRate QChiWatUni_flow_nominal=
    dat.QEva_flow_nominal
    "Design cooling heat flow rate (each unit, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QConWatUni_flow_nominal=
    -dat.QEva_flow_nominal * (1 + 1 / dat.COP_nominal * dat.etaMotor)
    "Design CW heat flow rate (each unit, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QChiWat_flow_nominal=
    nUni * QChiWatUni_flow_nominal
    "Design cooling heat flow rate (all units, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QConWat_flow_nominal=
    nUni * QConWatUni_flow_nominal
    "Design CW heat flow rate (all units, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWatUni_flow_nominal(
    final min=0)=dat.mEva_flow_nominal
    "Design chiller CHW mass flow rate (each unit)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWatUni_flow_nominal(
    final min=0)=dat.mCon_flow_nominal
    "Design chiller CW mass flow rate (each unit)"
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
    "Design chiller evaporator pressure drop (each unit)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Chiller condenser design pressure drop (each unit)"
    annotation(Dialog(group="Nominal condition"));

  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic dat
    "Chiller parameters (each unit)"
    annotation (Placement(transformation(extent={{-10,-134},{10,-114}})));

  // Assumptions
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
    annotation (Placement(transformation(extent={{-140,
            100},{-100,140}}), iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K", displayUnit="degC")
    "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
      iconTransformation(extent={{-140,-110},{-100, -70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(
    final unit="W")
    "Power drawn"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValCon[nUni](
    each final unit="1", each final min=0, each final max=1)
    "Chiller condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,178}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-60,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValEva[nUni](
    each final unit="1", each final min=0, each final max=1)
    "Chiller evaporator isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={0,-180}),   iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-58,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConLvg[nUni](each final
      unit="K", each displayUnit="degC")
    "Chiller condenser leaving temperature" annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={40,180}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mCon_flow[nUni](
    each final unit="kg/s")
    "Chiller condenser barrel mass flow rate" annotation (
      Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={60,180}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={80,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TEvaLvg[nUni](each final
      unit="K", each displayUnit="degC")
    "Chiller evaporator leaving temperature" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,-180}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mEva_flow[nUni](
    each final unit="kg/s")
    "Chiller evaporator barrel mass flow rate" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={60,-180}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={80,-120})));

  Fluid.Chillers.ElectricReformulatedEIR chi(
    PLR1(start=0),
    final per=dat,
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final have_switchover=false,
    final dp1_nominal=0,
    final dp2_nominal=0,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final energyDynamics=energyDynamics,
    final show_T=show_T) "Chiller"
    annotation (Placement(transformation(extent={{-4,-10},{16,10}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulConInl(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulConOut(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulEvaInl(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulEvaOut(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{-30,-70},{-50,-50}})));
  Buildings.Templates.Components.Controls.MultipleCommands com(
    final nUni=nUni)
    "Convert command signals"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  BaseClasses.MultipleValves valEva(
    redeclare final package Medium = Medium2,
    redeclare final Buildings.Fluid.Actuators.Valves.TwoWayLinear val,
    linearized=true,
    final nUni=nUni,
    final mUni_flow_nominal=mChiWatUni_flow_nominal,
    final dpFixed_nominal=dpEva_nominal,
    dpValve_nominal=1E3,
    final allowFlowReversal=allowFlowReversal2,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final show_T=show_T)
    "Chiller evaporator isolation valves"
    annotation (Placement(transformation(extent={{-70,-50},{-90,-70}})));
  BaseClasses.MultipleValves valCon(
    redeclare final package Medium = Medium1,
    redeclare final Buildings.Fluid.Actuators.Valves.TwoWayLinear val,
    linearized=true,
    final nUni=nUni,
    final mUni_flow_nominal=mConWatUni_flow_nominal,
    final dpFixed_nominal=dpCon_nominal,
    dpValve_nominal=1E3,
    final allowFlowReversal=allowFlowReversal1,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final show_T=show_T)
    "Chiller condenser isolation valves"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mulP "Scale power"
    annotation (Placement(transformation(extent={{70,30},{90,10}})));
  Fluid.Sensors.TemperatureTwoPort temConLvg(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=mConWatUni_flow_nominal,
    final allowFlowReversal=allowFlowReversal1)
    "Chiller condenser leaving temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,20})));
  Fluid.Sensors.TemperatureTwoPort temEvaLvg(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=mChiWatUni_flow_nominal,
    final allowFlowReversal=allowFlowReversal2)
    "Chiller evaporator leaving temperature" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-20,-20})));
  Fluid.Sensors.MassFlowRate floCon(
    redeclare final package Medium =Medium1,
    final allowFlowReversal=allowFlowReversal1)
    "Chiller condenser barrel mass flow rate"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={20,40})));
  Fluid.Sensors.MassFlowRate floEva(
    redeclare final package Medium =Medium2,
    final allowFlowReversal=allowFlowReversal2)
    "Chiller evaporator barrel mass flow rate"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-20,-40})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep(nout=nUni)
    "Replicate" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={40,140})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep1(nout=nUni)
    "Replicate" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,140})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep2(nout=nUni)
    "Replicate" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-140})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep3(nout=nUni)
    "Replicate" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={40,-140})));
equation
  connect(mulEvaInl.port_b,chi. port_a2)
    annotation (Line(points={{30,-60},{20,-60},{20,-6},{16,-6}},
    color={0,127,255}));
  connect(TSet,chi. TSet) annotation (Line(points={{-120,-90},{-10,-90},{-10,-3},
          {-6,-3}},  color={0,0,127}));
  connect(mulConOut.uInv, mulConInl.u) annotation (Line(points={{51,66},{54,66},
          {54,80},{-54,80},{-54,66},{-52,66}}, color={0,0,127}));
  connect(mulEvaOut.uInv, mulEvaInl.u) annotation (Line(points={{-51,-54},{-54,-54},
          {-54,-80},{56,-80},{56,-54},{52,-54}}, color={0,0,127}));
  connect(port_a1, mulConInl.port_a)
    annotation (Line(points={{-100,60},{-50,60}}, color={0,127,255}));
  connect(port_a2, mulEvaInl.port_a)
    annotation (Line(points={{100,-60},{50,-60}}, color={0,127,255}));
  connect(port_b2, valEva.port_b)
    annotation (Line(points={{-100,-60},{-90,-60}}, color={0,127,255}));
  connect(mulEvaOut.port_b, valEva.port_a)
    annotation (Line(points={{-50,-60},{-70,-60}}, color={0,127,255}));
  connect(y1, com.y1) annotation (Line(points={{-120,120},{-82,120}},
                     color={255,0,255}));
  connect(chi.P, mulP.u1) annotation (Line(points={{17,9},{60,9},{60,14},{68,14}},
                 color={0,0,127}));
  connect(com.nUniOn, mulP.u2) annotation (Line(points={{-58,120},{56,120},{56,
          26},{68,26}},     color={0,0,127}));
  connect(yValCon, valCon.y) annotation (Line(points={{0,178},{0,122},{64,122},
          {64,66},{68,66}}, color={0,0,127}));
  connect(yValEva, valEva.y) annotation (Line(points={{0,-180},{0,-140},{-60,
          -140},{-60,-66},{-68,-66}}, color={0,0,127}));

  connect(mulConInl.port_b,chi. port_a1) annotation (Line(points={{-30,60},{-20,
          60},{-20,6},{-4,6}},  color={0,127,255}));
  connect(mulP.y, P)
    annotation (Line(points={{92,20},{120,20}}, color={0,0,127}));
  connect(com.nUniOnBou, mulConOut.u) annotation (Line(points={{-58,114},{20,114},
          {20,66},{28,66}},      color={0,0,127}));
  connect(mulConInl.uInv, mulEvaOut.u) annotation (Line(points={{-29,66},{-24,66},
          {-24,-54},{-28,-54}},     color={0,0,127}));
  connect(com.y1One,chi. on) annotation (Line(points={{-58,126},{-10,126},{-10,3},
          {-6,3}},                  color={255,0,255}));
  connect(valCon.port_b, port_b1)
    annotation (Line(points={{90,60},{100,60}}, color={0,127,255}));
  connect(mulConOut.port_b, valCon.port_a)
    annotation (Line(points={{50,60},{70,60}}, color={0,127,255}));
  connect(temEvaLvg.port_a, chi.port_b2)
    annotation (Line(points={{-20,-10},{-20,-6},{-4,-6}}, color={0,127,255}));
  connect(chi.port_b1, temConLvg.port_a)
    annotation (Line(points={{16,6},{20,6},{20,10}}, color={0,127,255}));
  connect(temConLvg.port_b, floCon.port_a)
    annotation (Line(points={{20,30},{20,30}}, color={0,127,255}));
  connect(floCon.port_b, mulConOut.port_a)
    annotation (Line(points={{20,50},{20,60},{30,60}}, color={0,127,255}));
  connect(temEvaLvg.port_b, floEva.port_a)
    annotation (Line(points={{-20,-30},{-20,-30}}, color={0,127,255}));
  connect(floEva.port_b, mulEvaOut.port_a) annotation (Line(points={{-20,-50},{
          -20,-60},{-30,-60}}, color={0,127,255}));
  connect(rep.y, TConLvg)
    annotation (Line(points={{40,152},{40,180}}, color={0,0,127}));
  connect(rep1.y, mCon_flow)
    annotation (Line(points={{60,152},{60,180}}, color={0,0,127}));
  connect(floCon.m_flow, rep1.u)
    annotation (Line(points={{31,40},{60,40},{60,128}}, color={0,0,127}));
  connect(temConLvg.T, rep.u) annotation (Line(points={{9,20},{0,20},{0,100},{
          40,100},{40,128}}, color={0,0,127}));
  connect(rep3.y, TEvaLvg)
    annotation (Line(points={{40,-152},{40,-180},{40,-180}}, color={0,0,127}));
  connect(rep2.y, mEva_flow) annotation (Line(points={{60,-152},{60,-158},{60,
          -158},{60,-180}}, color={0,0,127}));
  connect(floEva.m_flow, rep2.u)
    annotation (Line(points={{-9,-40},{60,-40},{60,-128}}, color={0,0,127}));
  connect(temEvaLvg.T, rep3.u) annotation (Line(points={{-9,-20},{24,-20},{24,-120},
          {40,-120},{40,-128}}, color={0,0,127}));
  annotation (
    defaultComponentName="chi",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,160}})),
    Documentation(info="<html>
<p>
This model represents a set of identical water-cooled compression chillers
that are piped in parallel.
Modulating isolation valves are included on condenser and evaporator side.
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
CHW supply temperature setpoint <code>TSet</code>:
AO signal common to all units, with a dimensionality of zero
</li>
<li>
Condenser and evaporator isolation valve commanded position <code>yVal(Con|Eva)</code>:
AO signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Condenser and evaporator leaving temperature <code>T(Con|Eva)Lvg</code>:
AI signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Condenser and evaporator mass flow rate <code>m(Con|Eva)_flow</code>:
AI signal dedicated to each unit, with a dimensionality of one
</li>
</ul>
<h4>Details</h4>
<h5>Modeling approach</h5>
<p>
In a parallel arrangement, all operating units have the same operating point,
<i>provided that the isolation valves are commanded to the same position</i>.
This allows modeling the heat transfer through the condenser and evaporator
barrel with a single instance of
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricReformulatedEIR\">
Buildings.Fluid.Chillers.ElectricReformulatedEIR</a>.
Hydronics are resolved with mass flow rate multiplier components in
conjunction with instances of
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Combined.Subsystems.BaseClasses.MultipleValves\">
Buildings.Experimental.DHC.Plants.Combined.Subsystems.BaseClasses.MultipleValves</a>
which represent the parallel network of valves and fixed resistances.
</p>
<h5>Actuators</h5>
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
end ChillerGroup;
