within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Validation;
model ZoneControl

  CDL.Discrete.Sampler                        samInc(final samplePeriod=300)
    "Sample period for incremental setpoint change"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  CDL.Discrete.UnitDelay delTZonSet(samplePeriod=10, y_start=273.15 + 20)
    "Emulates an external zone temperature setpoint controller that has a small delay of setpoint change after a new setpoint is received"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,50})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneControl
    zonCon(
    airConMod=false, incSetCha=false)
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  CDL.Logical.Sources.Pulse uEnaVar(period=172800)
    "Boolean variable to enable setpoint change when true"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  ZoneSetpointGeneration zonSetGen(
    TDefOccHeaSet=273.15 + 20,
    TDefUnoHeaSet=273.15 + 12,
    TDefOccCooSet=273.15 + 24,
    TDefUnoCooSet=273.15 + 32,
    dTSheHeaSet=4,
    dTSheCooSet=4,
    dTPreHeaSet=1.5,
    dTPreCooSet=1.5,
    occHouSta=7,
    occHouEnd=19,
    setChaEnaUnoFla=true)
    "Block to generate zone setpoints and setpoint targets that vary with time"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  CDL.Integers.Sources.TimeTable                        tabDemFleMod(
    table=[0,1; 14,0; 16,2; 21,3; 23,1; 24,1],
    timeScale=3600,
    period=86400)
    "A table of demand flexibility modes that repeat every day"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneControl
    zonCon1(
    dTShe=0.5,
    dTReb=0.5,
    airConMod=false,
    incSetCha=true)
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  CDL.Discrete.Sampler                        samInc1(final samplePeriod=300)
    "Sample period for incremental setpoint change"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  CDL.Discrete.UnitDelay delTZonSet1(samplePeriod=10, y_start=273.15 + 20)
    "Emulates an external zone temperature setpoint controller that has a small delay of setpoint change after a new setpoint is received"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-50})));
equation
  connect(uEnaVar.y, zonCon.uEna) annotation (Line(points={{-98,70},{-80,70},{
          -80,60},{-2,60}}, color={255,0,255}));
  connect(zonCon.TComZonSet, samInc.u)
    annotation (Line(points={{22,50},{38,50}},color={0,0,127}));
  connect(samInc.y, delTZonSet.u)
    annotation (Line(points={{62,50},{78,50}}, color={0,0,127}));
  connect(delTZonSet.y, zonCon.TCurZonSet) annotation (Line(points={{102,50},{
          120,50},{120,20},{-10,20},{-10,51.8},{-2,51.8}}, color={0,0,127}));
  connect(zonSetGen.TPreTarCooSet, zonCon.TPreTarSet) annotation (Line(points={
          {-98,-72},{-40,-72},{-40,48},{-2,48}}, color={0,0,127}));
  connect(zonSetGen.TSheTarCooSet, zonCon.TSheTarSet) annotation (Line(points={
          {-98,-76},{-30,-76},{-30,44},{-2,44}}, color={0,0,127}));
  connect(zonSetGen.TDefCooSet, zonCon.TDefSet) annotation (Line(points={{-98,
          -80},{-20,-80},{-20,40},{-2,40}}, color={0,0,127}));
  connect(tabDemFleMod.y[1], zonCon.demFleMod) annotation (Line(points={{-98,10},
          {-60,10},{-60,56},{-2,56}}, color={255,127,0}));
  connect(zonCon1.TComZonSet, samInc1.u)
    annotation (Line(points={{22,-50},{38,-50}}, color={0,0,127}));
  connect(samInc1.y, delTZonSet1.u)
    annotation (Line(points={{62,-50},{78,-50}}, color={0,0,127}));
  connect(delTZonSet1.y, zonCon1.TCurZonSet) annotation (Line(points={{102,-50},
          {120,-50},{120,-80},{-10,-80},{-10,-48.2},{-2,-48.2}}, color={0,0,127}));
  connect(tabDemFleMod.y[1], zonCon1.demFleMod) annotation (Line(points={{-98,
          10},{-60,10},{-60,-44},{-2,-44}}, color={255,127,0}));
  connect(uEnaVar.y, zonCon1.uEna) annotation (Line(points={{-98,70},{-80,70},{
          -80,-40},{-2,-40}}, color={255,0,255}));
  connect(zonSetGen.TPreTarCooSet, zonCon1.TPreTarSet) annotation (Line(points=
          {{-98,-72},{-40,-72},{-40,-52},{-2,-52}}, color={0,0,127}));
  connect(zonSetGen.TSheTarCooSet, zonCon1.TSheTarSet) annotation (Line(points=
          {{-98,-76},{-30,-76},{-30,-56},{-2,-56}}, color={0,0,127}));
  connect(zonSetGen.TDefCooSet, zonCon1.TDefSet) annotation (Line(points={{-98,
          -80},{-20,-80},{-20,-60},{-2,-60}}, color={0,0,127}));
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
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-140,-100},{140,
            100}}),
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
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-140,-100},{140,
            100}})));
end ZoneControl;
