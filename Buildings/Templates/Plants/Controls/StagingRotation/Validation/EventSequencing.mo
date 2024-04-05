within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model EventSequencing "Validation model for event sequencing logic"
  Buildings.Templates.Plants.Controls.StagingRotation.EventSequencing seqEveHea(
    have_heaWat=true,
    have_chiWat=false,
    have_valInlIso=true,
    have_valOutIso=false,
    have_pumHeaWatPri=true,
    have_pumHeaWatSec=true)
    "Event sequencing – Heating-only system with primary-secondary distribution"
    annotation (Placement(transformation(extent={{20,6},{40,34}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1(
    table=[0,0,0; 1,1,0; 2,0,0; 3,0,1; 4,0,0; 5,0,0],
    timeScale=900,
    period=4500)
    "Command signal – Index 1 for heating command, 2 for cooling command"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert command signal to real value"
    annotation (Placement(transformation(extent={{50,50},{30,70}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(samplePeriod=1)
    "Hold signal value"
    annotation (Placement(transformation(extent={{20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr
    "Compare to zero to compute equipment status"
    annotation (Placement(transformation(extent={{-10,50},{-30,70}})));
  Buildings.Templates.Plants.Controls.StagingRotation.EventSequencing seqEveHeaCoo(
    have_heaWat=true,
    have_chiWat=true,
    have_valInlIso=true,
    have_valOutIso=true,
    have_pumHeaWatPri=true,
    have_pumChiWatPri=false,
    have_pumHeaWatSec=false,
    have_pumChiWatSec=false)
    "Event sequencing – Heating and cooling system with primary-only distribution"
    annotation (Placement(transformation(extent={{20,-34},{40,-6}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert command signal to real value"
    annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1(samplePeriod=1)
    "Hold signal value"
    annotation (Placement(transformation(extent={{20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1
    "Compare to zero to compute equipment status"
    annotation (Placement(transformation(extent={{-10,-70},{-30,-50}})));
equation
  connect(u1.y[1], seqEveHea.u1Hea) annotation (Line(points={{-58,0},{0,0},{0,
          32},{18,32}},    color={255,0,255}));
  connect(u1.y[1], seqEveHea.u1PumHeaWatSec_actual) annotation (Line(points={{-58,0},
          {0,0},{0,14},{18,14}},        color={255,0,255}));
  connect(booToRea.y,zerOrdHol. u)
    annotation (Line(points={{28,60},{22,60}},
                                             color={0,0,127}));
  connect(zerOrdHol.y,greThr. u)
    annotation (Line(points={{-2,60},{-8,60}},  color={0,0,127}));
  connect(seqEveHea.y1PumHeaWatPri, booToRea.u) annotation (Line(points={{42,12},
          {60,12},{60,60},{52,60}},   color={255,0,255}));
  connect(greThr.y, seqEveHea.u1PumHeaWatPri_actual) annotation (Line(points={{-32,60},
          {-40,60},{-40,20},{18,20}}, color={255,0,255}));
  connect(u1.y[1], seqEveHeaCoo.u1Hea) annotation (Line(points={{-58,0},{0,0},{
          0,-8},{18,-8}}, color={255,0,255}));
  connect(booToRea1.y, zerOrdHol1.u)
    annotation (Line(points={{28,-60},{22,-60}}, color={0,0,127}));
  connect(zerOrdHol1.y, greThr1.u)
    annotation (Line(points={{-2,-60},{-8,-60}}, color={0,0,127}));
  connect(seqEveHeaCoo.y1PumHeaWatPri, booToRea1.u) annotation (Line(points={{
          42,-28},{60,-28},{60,-60},{52,-60}}, color={255,0,255}));
  connect(greThr1.y, seqEveHeaCoo.u1PumHeaWatPri_actual) annotation (Line(
        points={{-32,-60},{-40,-60},{-40,-20},{18,-20}}, color={255,0,255}));
  connect(u1.y[2], seqEveHeaCoo.u1Coo) annotation (Line(points={{-58,0},{0,0},{
          0,-12},{18,-12}}, color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/EventSequencing.mos"
        "Simulate and plot"),
    experiment(
      StopTime=4500.0,
      Tolerance=1e-06),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Documentation(info="<html>
<p>
This model validates 
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.EventSequencing\">
Buildings.Templates.Plants.Controls.StagingRotation.EventSequencing</a>
for the following configurations.
</p>
<ul>
<li>
Heating-only plant with primary-secondary distribution (component <code>seqEveHea</code>)
</li>
<li>
Heating and cooling plant with primary-only distribution (component <code>seqEveHeaCoo</code>)
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end EventSequencing;
