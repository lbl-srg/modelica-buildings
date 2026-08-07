within Buildings.Fluid.Geothermal.Borefields.Examples;
model BorefieldsDarcyPressureDropVariableFlow
  "Validation model for Darcy-Weisbach pressure drop with time-varying mass flow"
  extends Buildings.Fluid.Geothermal.Borefields.Examples.BorefieldsDarcyPressureDrop(
    sou(
      use_m_flow_in=true),
    sou1(
      use_m_flow_in=true),
    sou2(
      use_m_flow_in=true));

  parameter Modelica.Units.SI.Time period = 12000
    "Period of the sinusoidal mass-flow variation";

  parameter Real relAmp(
    min=0,
    max=1) = 0.5
    "Relative amplitude of the mass-flow variation";

  Modelica.Blocks.Sources.Sine mFloUTub(
    amplitude=relAmp*borFieUTubDat.conDat.mBorFie_flow_nominal,
    f=1/period,
    offset=borFieUTubDat.conDat.mBorFie_flow_nominal)
    "Mass-flow signal for the single U-tube borefield"
    annotation (Placement(transformation(extent={{-90.0,-36.0},{-70.0,-16.0}},rotation = 0.0,origin = {0.0,0.0})));

  Modelica.Blocks.Sources.Sine mFlo2UTubPar(
    amplitude=relAmp*borFie2UTubParDat.conDat.mBorFie_flow_nominal,
    f=1/period,
    offset=borFie2UTubParDat.conDat.mBorFie_flow_nominal)
    "Mass-flow signal for the double U-tube parallel borefield"
    annotation (Placement(transformation(extent={{-90.0,24.0},{-70.0,44.0}},rotation = 0.0,origin = {0.0,0.0})));

  Modelica.Blocks.Sources.Sine mFlo2UTubSer(
    amplitude=relAmp*borFie2UTubSerDat.conDat.mBorFie_flow_nominal,
    f=1/period,
    offset=borFie2UTubSerDat.conDat.mBorFie_flow_nominal)
    "Mass-flow signal for the double U-tube series borefield"
    annotation (Placement(transformation(extent={{-92.0,80.0},{-72.0,100.0}},rotation = 0.0,origin = {0.0,0.0})));

equation
  connect(mFloUTub.y, sou.m_flow_in)
    annotation (Line(points={{-69,-26},{-100,-26},{-100,-52},{-94,-52}},
      color={0,0,127}));

  connect(mFlo2UTubPar.y, sou1.m_flow_in)
    annotation (Line(points={{-69,34},{-100,34},{-100,8},{-94,8}},
      color={0,0,127}));

  connect(mFlo2UTubSer.y, sou2.m_flow_in)
    annotation (Line(points={{-71,90},{-100,90},{-100,68},{-94,68}},
      color={0,0,127}));

  annotation (
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/Examples/BorefieldsDarcyPressureDropVariableFlow.mos"
      "Simulate and plot"),
    experiment(
      StopTime=36000,
      Tolerance=1e-6),
    Documentation(info="<html>
<p>
This validation model extends
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.Examples.BorefieldsDarcyPressureDrop\">
Buildings.Fluid.Geothermal.Borefields.Examples.BorefieldsDarcyPressureDrop</a>
and replaces the constant mass-flow boundary conditions with sinusoidal
mass-flow inputs.
</p>
<p>
The Darcy-Weisbach pressure-drop calculation is inherited from
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.Examples.BorefieldsDarcyPressureDrop\">
Buildings.Fluid.Geothermal.Borefields.Examples.BorefieldsDarcyPressureDrop</a>,
where <code>use_DarcyPressureDrop=true</code> is set on each borefield model
instance.
</p>
<p>
The mass-flow rate varies between 50% and 150% of the nominal borefield
mass-flow rate. This verifies that the Darcy-Weisbach pressure drop in the
vertical GHE pipes is recomputed from the instantaneous mass-flow rate.
</p>
<p>
The expected pressure-drop magnitude ordering is
</p>
<pre>
abs(borFie2UTubPar.dp) &lt; abs(borFieUTub.dp) &lt; abs(borFie2UTubSer.dp)
</pre>
<p>
throughout the simulation. The pressure drops should vary periodically with the
imposed mass-flow signals.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 2026, by Lone Meertens:<br/>
Updated documentation to reflect that the Darcy-Weisbach pressure-drop option
is set on the borefield model instances rather than in the borefield
configuration data records.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>
<li>
July 2026, by Lone Meertens:<br/>
First implementation for validating Darcy-Weisbach pressure drop under
time-varying mass-flow conditions.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>
</ul>
</html>"));
end BorefieldsDarcyPressureDropVariableFlow;
