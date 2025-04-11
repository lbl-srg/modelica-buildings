within Buildings.Templates.Components.HeatPumps;
model AirToWater
  "Air-to-water heat pump"
  extends Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDep
                                                                                     (
    redeclare final package MediumSou=MediumAir,
    final typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    final allowFlowReversalSou=false,
    hp(use_intSafCtr=false));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mAir_flow(
    final k=mSouHea_flow_nominal)
    "Air mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={60,-60})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal y1Rea
    "Convert on/off command into real"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={60,20})));
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
    annotation (Line(points={{60,8},{60,-48}}, color={0,0,127}));
  connect(floSou.port_b, TSouEnt.port_a)
    annotation (Line(points={{80,-80},{80,-20},{40,-20}},color={0,127,255}));
  connect(port_aSou, floSou.port_a)
    annotation (Line(points={{80,-140},{80,-100}},color={0,127,255}));
  connect(mAir_flow.y, floSou.m_flow_in)
    annotation (Line(points={{60,-72},{60,-96},{72,-96}},color={0,0,127}));
  connect(hp.on, y1Rea.u) annotation (Line(points={{-12.2,-6},{-14,-6},{-14,12},
          {40,12},{40,40},{60,40},{60,32}}, color={255,0,255}));
  annotation (
    defaultComponentName="hp",
    Documentation(
      info="<html>
<p>
This is a model for an air-to-water heat pump where the capacity
and input power are computed by interpolating manufacturer data
along the condenser entering or leaving temperature, the 
evaporator entering or leaving temperature and the part load ratio.
The model can be configured to represent either a non-reversible 
(heating-only) heat pump (<code>is_rev=false</code>) or a 
reversible heat pump (<code>is_rev=true</code>).
</p>
<p>
This model is a wrapper for
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep</a>,
which the user may refer to for the modeling assumptions.
Note that, by default, internal safeties in this model are disabled.
</p>
<h4>Control points</h4>
<p>
Refer to the documentation of the base class
<a href=\"modelica://Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDep\">
Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDep</a>
for a description of the available control input and output variables.
</p>
</html>", revisions="<html>
<ul>
<li>
March 21, 2025, by Antoine Gautier:<br/>
Refactored with load-dependent 2D table data heat pump model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4152\">#4152</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirToWater;
