within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Validation;
model ZoneControl

  CDL.Discrete.Sampler                        samInc(final samplePeriod=300)
    "Sample period for incremental setpoint change"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  CDL.Discrete.UnitDelay                        uniDelTSetInc(samplePeriod=10,
      y_start=273.15 + 20)
    "Emulates an external setpoint controller that sets its output to the input each sample period for incremental setpoint change"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={70,30})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneControl
    zonCon(
    dTShe=0.5,
    dTReb=0.5,
    airConMod=false,
    incSetCha=true)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  CDL.Integers.Sources.TimeTable intTimTab(
    table=[0,1; 14,0; 16,2; 21,3; 23,1; 24,1],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Generic.ZoneSetpointSource                              zoneSetpointSource(
    TDefOccHeaSet=273.15 + 20,
    TDefUnoHeaSet=273.15 + 12,
    TDefOccCooSet=273.15 + 24,
    TDefUnoCooSet=273.15 + 32,
    dTSheHeaSet=4,
    dTSheCooSet=4,
    dTPreHeaSet=1.5,
    dTPreCooSet=1.5,
    occHouEnd=19)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
equation
  connect(con.y, zonCon.uEna) annotation (Line(points={{-78,50},{-70,50},{-70,40},
          {-22,40}}, color={255,0,255}));
  connect(intTimTab.y[1], zonCon.demFleMod) annotation (Line(points={{-98,10},{-80,
          10},{-80,36},{-22,36}}, color={255,127,0}));
  connect(zonCon.TComZonSet, samInc.u)
    annotation (Line(points={{2,30},{18,30}}, color={0,0,127}));
  connect(samInc.y, uniDelTSetInc.u)
    annotation (Line(points={{42,30},{58,30}}, color={0,0,127}));
  connect(uniDelTSetInc.y, zonCon.TCurZonSet) annotation (Line(points={{82,30},{
          100,30},{100,0},{-60,0},{-60,31.8},{-22,31.8}}, color={0,0,127}));
  connect(zoneSetpointSource.TPreTarCooSet, zonCon.TPreTarSet) annotation (Line(
        points={{-78,-32},{-72,-32},{-72,28},{-22,28}}, color={0,0,127}));
  connect(zoneSetpointSource.TSheTarCooSet, zonCon.TSheTarSet) annotation (Line(
        points={{-78,-34.6},{-56,-34.6},{-56,-34},{-36,-34},{-36,24},{-22,24}},
        color={0,0,127}));
  connect(zoneSetpointSource.TDefCooSet, zonCon.TDefSet) annotation (Line(
        points={{-78,-38.2},{-58,-38.2},{-58,-46},{-22,-46},{-22,20}}, color={0,
          0,127}));
  annotation (experiment(StopTime=172800, Interval=60, Tolerance=1e-06),
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
July 20, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-120,-100},{120,100}}),
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
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,-100},{120,
            100}})));
end ZoneControl;
