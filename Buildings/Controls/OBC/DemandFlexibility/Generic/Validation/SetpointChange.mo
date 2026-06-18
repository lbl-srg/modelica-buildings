within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model SetpointChange "Setpoint change"

  Buildings.Controls.OBC.CDL.Discrete.Sampler samInc(final samplePeriod=300)
    "Sample period for incremental setpoint change"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samOneSte(final samplePeriod=300)
    "Sample period for one-step setpoint change"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaInc(
    setChaDel=0.5,
    ascSet=true,
    incCha=true) "Incremental setpoint change block"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaOneSte(
    ascSet=true,
    incCha=false) "One-step setpoint change block"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TAllMaxSet(
    k(final unit="K", displayUnit="degC") = 292.15)
    "Allowed maximum temperature setpoint"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TAllMinSet(
    k(final unit="K", displayUnit="degC") = 289.15)
    "Allowed minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uEna(period=1800, shift=900)
    "Boolean value for the signal to enable setpoint change"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDelTSetInc(samplePeriod=10,
      y_start=273.15 + 17)
    "Emulates an external setpoint controller that sets its output to the input each sample period for incremental setpoint change"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,50})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDelTSetOneSte(samplePeriod=10,
      y_start=273.15 + 17)
    "Emulates an external setpoint controller that sets its output to the input each sample period for one-step setpoint change"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-30})));
equation
  connect(TAllMinSet.y, setChaInc.uAllMinSet) annotation (Line(points={{-98,-70},
          {-60,-70},{-60,44},{-22,44}}, color={0,0,127}));
  connect(uniDelTSetInc.y, setChaInc.uCurSet) annotation (Line(points={{82,50},{
          100,50},{100,20},{-40,20},{-40,52},{-22,52}}, color={0,0,127}));
  connect(uEna.y, setChaInc.uEna) annotation (Line(points={{-98,70},{-70,70},{-70,
          56},{-22,56}}, color={255,0,255}));
  connect(TAllMaxSet.y, setChaInc.uAllMaxSet) annotation (Line(points={{-98,10},
          {-80,10},{-80,48.2},{-22,48.2}}, color={0,0,127}));
  connect(samInc.y, uniDelTSetInc.u)
    annotation (Line(points={{42,50},{58,50}}, color={0,0,127}));
  connect(setChaInc.y, samInc.u)
    annotation (Line(points={{2,50},{18,50}}, color={0,0,127}));
  connect(setChaOneSte.y, samOneSte.u)
    annotation (Line(points={{2,-30},{18,-30}}, color={0,0,127}));
  connect(samOneSte.y, uniDelTSetOneSte.u)
    annotation (Line(points={{42,-30},{58,-30}}, color={0,0,127}));
  connect(uEna.y, setChaOneSte.uEna) annotation (Line(points={{-98,70},{-70,70},
          {-70,-24},{-22,-24}}, color={255,0,255}));
  connect(TAllMinSet.y, setChaOneSte.uAllMinSet) annotation (Line(points={{-98,-70},
          {-60,-70},{-60,-36},{-22,-36}}, color={0,0,127}));
  connect(setChaOneSte.uAllMaxSet, TAllMaxSet.y) annotation (Line(points={{-22,-31.8},
          {-80,-31.8},{-80,10},{-98,10}}, color={0,0,127}));
  connect(uniDelTSetOneSte.y, setChaOneSte.uCurSet) annotation (Line(points={{82,
          -30},{100,-30},{100,-60},{-40,-60},{-40,-28},{-22,-28}}, color={0,0,127}));
annotation (experiment(StopTime=3600, Interval=60, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/SetpointChange.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange</a>.
</p>
<p>
This validation test uses two constant temperatures, the minimum temperature setpoint
<code>TAllMinSet</code> and the maximum temperature setpoint <code>TAllMaxSet</code>,
to set the inputs <code>uAllMinSet</code> and <code>uAllMaxSet</code>. It also uses
a boolean pulse signal to set the input <code>uEna</code> to enable the setpoint
change.
</p>
<p>
A <code>UnitDelay</code> block emulates the behavior of a temperature setpoint
within an external zone temperature setpoint controller. When this external zone
temperature setpoint controller receives the setpoint <code>y</code> from the
<code>SetpointChange</code> block at
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange</a>, the
temperature setpoint within the external zone temperature setpoint controller will
be changed to <code>y</code> a small time delay later, set to <code>10</code>
seconds, and the new temperature setpoint value will be sent back to the
<code>uCurSet</code> variable in the <code>SetpointChange</code> block, completing a
full control loop.
</p>
<p>
The setpoint change operation is executed every <code>300</code> seconds, which is 
represented by a <code>Sampler</code> block.
</p>
</html>",revisions="<html>
<ul>
<li>
June 01, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-140,-100},{120,100}})));
end SetpointChange;
