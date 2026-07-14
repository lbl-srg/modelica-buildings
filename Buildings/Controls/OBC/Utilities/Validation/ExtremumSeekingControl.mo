within Buildings.Controls.OBC.Utilities.Validation;
model ExtremumSeekingControl
  "Model validates the extremum seeking control block"
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) "Logic true indicating device ON"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.Utilities.ExtremumSeekingControl esc(
    have_hol=false,
    final iniSet=0,
    final minSet=0,
    final maxSet=1,
    final delTim=1e-13,
    final samplePeriod=1,
    adjFac=5,
    tau=60,
    tauFil=5,
    dtHol=300) "Block implementing extremum seeking control"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.CombiTimeTable timTab(
    tableOnFile=true,
    tableName="refData",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Controls/OBC/Utilities/Validation/ExtremumSeekingControl.mos"),
    columns={2,3}) "Reference data"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes(k=0)
    "Integrator with reset for cost function computation"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant                        con1(final k=false)
    "Logic false"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(k=0) "Constant zero signal"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Compute cost function as the difference between reference signal and integrator output"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
equation

  connect(con.y, esc.uDevSta) annotation (Line(points={{-58,60},{50,60},{50,6},
          {58,6}}, color={255,0,255}));
  connect(con1.y, intWitRes.trigger) annotation (Line(points={{-58,-40},{-10,
          -40},{-10,-22}}, color={255,0,255}));
  connect(con2.y, intWitRes.y_reset_in) annotation (Line(points={{-58,-10},{-40,
          -10},{-40,-18},{-22,-18}}, color={0,0,127}));
  connect(sub.y, esc.uCos) annotation (Line(points={{42,-10},{50,-10},{50,-6},{
          58,-6}}, color={0,0,127}));
  connect(esc.y, intWitRes.u) annotation (Line(points={{82,0},{90,0},{90,16},{
          -32,16},{-32,-10},{-22,-10}}, color={0,0,127}));
  connect(intWitRes.y, sub.u2) annotation (Line(points={{2,-10},{10,-10},{10,
          -16},{18,-16}}, color={0,0,127}));
  connect(timTab.y[1], sub.u1) annotation (Line(points={{-59,-70},{14,-70},{14,
          -4},{18,-4}}, color={0,0,127}));
annotation (experiment(StopTime=10800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/Validation/ExtremumSeekingControl.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Controls.OBC.Utilities.ExtremumSeekingControl\">
Buildings.Controls.OBC.Utilities.ExtremumSeekingControl</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 13, 2026, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-120},{100,100}}),
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
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end ExtremumSeekingControl;
