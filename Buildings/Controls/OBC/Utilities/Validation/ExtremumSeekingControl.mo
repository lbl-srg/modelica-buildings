within Buildings.Controls.OBC.Utilities.Validation;
model ExtremumSeekingControl
  "Model validates the extremum seeking control block"

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true)
    "Logic true indicating device ON"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));

  Buildings.Controls.OBC.Utilities.ExtremumSeekingControl esc(
    have_hol=false,
    iniSet=0,
    minSet=0,
    maxSet=1,
    delTim=1e-13,
    samplePeriod=1,
    adjFac=5,
    tau=60,
    tauFil=5,
    dtHol=300)
    "Block implementing extremum seeking control"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Sources.CombiTimeTable timTab(
    tableOnFile=true,
    tableName="refData",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Controls/OBC/Utilities/Validation/ExtremumSeekingControl.mos"),
    columns={2,3,4})
    "Reference data"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));

  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes(
    k=1/60)
    "Integrator with reset for constructing first-order filter"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false)
    "Logic false"
    annotation (Placement(transformation(extent={{-110,-80},{-90,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(
    final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Compute cost function as the difference between reference signal and current output"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Square of the difference to represent system dynamics"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Subtraction function used for representation of first-order filter"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

equation

  connect(con.y, esc.uDevSta) annotation (Line(points={{-88,60},{80,60},{80,6},
          {88,6}}, color={255,0,255}));
  connect(con1.y, intWitRes.trigger) annotation (Line(points={{-88,-70},{60,-70},
          {60,-12}},       color={255,0,255}));
  connect(con2.y, intWitRes.y_reset_in) annotation (Line(points={{-88,-40},{-40,
          -40},{-40,-8},{48,-8}},    color={0,0,127}));
  connect(esc.y, sub.u2) annotation (Line(points={{112,0},{116,0},{116,-20},{
          -90,-20},{-90,4},{-82,4}}, color={0,0,127}));
  connect(sub.y, mul.u1) annotation (Line(points={{-58,10},{-50,10},{-50,16},{
          -42,16}}, color={0,0,127}));
  connect(sub.y, mul.u2) annotation (Line(points={{-58,10},{-50,10},{-50,4},{
          -42,4}}, color={0,0,127}));
  connect(mul.y, sub1.u1) annotation (Line(points={{-18,10},{-10,10},{-10,16},{
          -2,16}}, color={0,0,127}));
  connect(intWitRes.y, esc.uCos)
    annotation (Line(points={{72,0},{80,0},{80,-6},{88,-6}}, color={0,0,127}));
  connect(intWitRes.y, sub1.u2) annotation (Line(points={{72,0},{80,0},{80,-16},
          {-10,-16},{-10,4},{-2,4}}, color={0,0,127}));
  connect(sub1.y, intWitRes.u)
    annotation (Line(points={{22,10},{40,10},{40,0},{48,0}}, color={0,0,127}));
  connect(timTab.y[2], sub.u1) annotation (Line(points={{-89,20},{-86,20},{-86,
          16},{-82,16}}, color={0,0,127}));
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
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
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
    Diagram(coordinateSystem(extent={{-120,-100},{120,100}})));
end ExtremumSeekingControl;
