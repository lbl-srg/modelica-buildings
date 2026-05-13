within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model SingleStepSetpointChange "Single-step setpoint change"


  Buildings.Controls.OBC.DemandFlexibility.Generic.SingleStepSetpointChange sinSteSetCha(setMinMax
      =true)
    "Single-step setpoint change block"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uEnaLim(period=86400, shift=
        43200)
    "Boolean value for the signal to enable single-step setpoint change"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TMinSet(k=273.15 + 16)
    "Minimum temperature setpoint example value"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDelTSet(samplePeriod=10, y_start=
        273.15 + 17)
    "Emulates an external setpoint controller"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,30})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TMaxSet(k=273.15 + 19)
    "Maximum temperature setpoint example value"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(final samplePeriod=300)
    "Sample period for the single-step change"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

equation
  connect(TMinSet.y,sinSteSetCha. uMinSet) annotation (Line(points={{-98,-70},{-60,
          -70},{-60,24},{-22,24}},     color={0,0,127}));
  connect(uniDelTSet.y,sinSteSetCha. uCurSet) annotation (Line(points={{82,30},{
          100,30},{100,-20},{-40,-20},{-40,32},{-22,32}},color={0,0,127}));
  connect(uEnaLim.y,sinSteSetCha. uEnaLim) annotation (Line(points={{-98,70},{-40,70},
          {-40,36},{-22,36}}, color={255,0,255}));
  connect(TMaxSet.y,sinSteSetCha. uMaxSet) annotation (Line(points={{-98,10},{-80,
          10},{-80,28.2},{-22,28.2}}, color={0,0,127}));
  connect(sinSteSetCha.yComSet, sam.u)
    annotation (Line(points={{2,30},{18,30}}, color={0,0,127}));
  connect(sam.y, uniDelTSet.u)
    annotation (Line(points={{42,30},{58,30}}, color={0,0,127}));
   annotation (experiment(
      StopTime=172800,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
       __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/SingleStepSetpointChange.mos"
        "Simulate and plot"),
       Documentation(info="<html>
<p>
This example validates <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SingleStepSetpointChange\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SingleStepSetpointChange</a>.
</p>

<p>
This validation test uses two constant temperature values, the minimum temperature setpoint <code>TMinSet</code>
and the maximum temperature setpoint <code>TMaxSet</code>, to represent the input variables
<code>uMinSet</code> and <code>uMaxSet</code>.
It also uses a boolean pulse signal to represent the 
signal input <code>uEnaLim</code> to enable single-step setpoint change. 
</p>

<p>
A <code>UnitDelay</code> block emulates the behavior of a temperature setpoint 
within an external zone temperature setpoint controller.
When this external zone temperature setpoint controller receives the 
commanded setpoint <code>yComSet</code> from the <code>SingleStepSetpointChange</code> block at
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SingleStepSetpointChange\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SingleStepSetpointChange</a>,
the temperature setpoint within the external zone temperature setpoint controller will be changed to
<code>yComSet</code> a small time delay later, such as <code>10</code> seconds, and the new temperature setpoint value will be sent
back to the <code>uCurSet</code> variable in the <code>SingleStepSetpointChange</code> block, 
completing a full control loop.
</p>

<p>
The setpoint change operation is executed every <code>300</code> seconds, which is represented by 
a <code>Sampler</code> block.
</p>
</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
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
end SingleStepSetpointChange;
