within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Validation;
model HeatingOrCooling "Validation model for the heating or cooling block"

  CDL.Discrete.Sampler                        samInc(final samplePeriod=300)
    "Sample period for incremental setpoint change"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  CDL.Discrete.UnitDelay                        uniDelTSetInc(samplePeriod=10,
      y_start=273.15 + 20)
    "Emulates an external setpoint controller that sets its output to the input each sample period for incremental setpoint change"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={70,30})));
  CDL.Logical.Sources.Constant con(k=false)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
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
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingOrCooling
    heaOrCoo(
    dTShe=0.5,
    dTReb=0.5,
    dTSheThr=0.5,
    dTSheHys=0.5,
    TResInt=0.5,
    samPerSetCha=300,
    airConMod=false,
    nZon=1,
    nSel=1,
    zonConVar=Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_2)
    annotation (Placement(transformation(extent={{-20,12},{0,48}})));
  CDL.Reals.Sources.TimeTable timTab(table=[0,273.15 + 18; 4,273.15 + 14; 5,
        273.15 + 14; 11,273.15 + 20; 16,273.15 + 22; 18,273.15 + 28.5; 19,
        273.15 + 28; 21,273.15 + 24; 22,273.15 + 22; 24,273.15 + 18], timeScale
      =3600) annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
equation
  connect(samInc.y, uniDelTSetInc.u)
    annotation (Line(points={{42,30},{58,30}}, color={0,0,127}));
  connect(zoneSetpointSource.TPreTarCooSet, heaOrCoo.TPreTarSet[1]) annotation
    (Line(points={{-78,-32},{-50,-32},{-50,22},{-22,22}}, color={0,0,127}));
  connect(zoneSetpointSource.TSheTarCooSet, heaOrCoo.TSheTarSet[1]) annotation
    (Line(points={{-78,-34.6},{-50,-34.6},{-50,18},{-22,18}}, color={0,0,127}));
  connect(zoneSetpointSource.TDefCooSet, heaOrCoo.TDefSet[1]) annotation (Line(
        points={{-78,-38.2},{-50,-38.2},{-50,14},{-22,14}}, color={0,0,127}));
  connect(intTimTab.y[1], heaOrCoo.demFleMod) annotation (Line(points={{-98,10},
          {-60,10},{-60,26},{-22,26}}, color={255,127,0}));
  connect(con.y, heaOrCoo.rouZonFla[1]) annotation (Line(points={{-78,90},{-50,
          90},{-50,46},{-22,46}}, color={255,0,255}));
  connect(heaOrCoo.TComZonSet[1], samInc.u)
    annotation (Line(points={{2,30},{18,30}}, color={0,0,127}));
  connect(uniDelTSetInc.y, heaOrCoo.TCurZonSet[1]) annotation (Line(points={{82,
          30},{100,30},{100,0},{-40,0},{-40,30},{-22,30}}, color={0,0,127}));
  connect(timTab.y[1], heaOrCoo.TCurZon[1]) annotation (Line(points={{-78,50},{
          -50,50},{-50,34},{-22,34}}, color={0,0,127}));
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
end HeatingOrCooling;
