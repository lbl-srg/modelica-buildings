within Buildings.Templates.Components.HeatPumps;
model AirToWater
  "Air-to-water heat pump - Equation fit model"
  extends Buildings.Templates.Components.Interfaces.PartialHeatPumpEquationFit(
    redeclare final package MediumSou=MediumAir,
    final typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    final allowFlowReversalSou=false);
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mAir_flow(
    final k=mSouHea_flow_nominal)
    "Air mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={60,-60})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal y1Rea
    "Convert on/off command into real"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={60,90})));
  Fluid.Movers.BaseClasses.IdealSource floSou(
    redeclare final package Medium=MediumAir,
    final m_flow_small=1E-4 * mSouHea_flow_nominal,
    final allowFlowReversal=allowFlowReversalSou,
    final control_m_flow=true,
    final control_dp=false)
    "Air flow source"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={80,-90})));
equation
  connect(y1Rea.y, mAir_flow.u)
    annotation (Line(points={{60,78},{60,-48}},color={0,0,127}));
  connect(floSou.port_b, TSouEnt.port_a)
    annotation (Line(points={{80,-80},{80,-20},{40,-20}},color={0,127,255}));
  connect(port_aSou, floSou.port_a)
    annotation (Line(points={{80,-140},{80,-100}},color={0,127,255}));
  connect(mAir_flow.y, floSou.m_flow_in)
    annotation (Line(points={{60,-72},{60,-96},{72,-96}},color={0,0,127}));
  connect(bus.y1, y1Rea.u)
    annotation (Line(points={{0,160},{0,110},{60,110},{60,102}},color={255,204,51},thickness=0.5));
  annotation (
    defaultComponentName="hp",
    Documentation(
      info="<html>
FIXME: Currently bindings involve heaPum.refCyc.refCycHeaPumCoo which is conditional.
This is to be corrected in the HP models, see #3 in
https://docs.google.com/document/d/130SBzYK3YHHSzFvr5FyW_WOXmNGoXKzUJ3Wahq1rx9U/edit
<br/>
FIXME: We use these bindings
coo(final cpCon=cpSou_default, final cpEva=cpChiWat_default) instead
of bindings to parameters of heaPum.refCyc.refCycHeaPumCoo due to a bug
in the HP model, see #1 in above document.
<p>
This is a model for an air-to-water heat pump where the capacity
and drawn power are computed based on the equation fit method.
The model can be configured with the parameter <code>is_rev</code>
to represent either a non-reversible heat pump (heating only) or a
reversible heat pump.
This model uses
<a href=\\\"modelica://Buildings.Fluid.HeatPumps.EquationFitReversible\\\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>,
which the user may refer to for the modeling assumptions.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
Heat pump on/off command signal <code>y1</code>:
DO signal, with a dimensionality of zero
</li>
<li>For reversible heat pumps only (<code>is_rev=true</code>),
Heat pump operating mode command signal <code>y1Hea</code>:
DO signal, with a dimensionality of zero<br/>
(<code>y1Hea=true</code> for heating mode,
<code>y1Hea=false</code> for cooling mode)
<li>
Heat pump supply temperature setpoint <code>TSet</code>:
AO signal, with a dimensionality of zero<br/>
(for reversible heat pumps, the setpoint value must be
switched externally between HW and CHW supply temperature)
</li>
<li>
Heat pump status <code>y1_actual</code>:
DI signal, with a dimensionality of zero
</li>
</ul>
</html>"));
end AirToWater;
