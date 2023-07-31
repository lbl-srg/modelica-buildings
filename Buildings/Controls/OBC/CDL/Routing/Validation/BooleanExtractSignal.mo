within Buildings.Controls.OBC.CDL.Routing.Validation;
model BooleanExtractSignal
  "Validation model for extracting boolean signals"
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal extBooSig(
    final nin=4,
    final nout=3,
    final extract={3,2,4})
    "Block that extracts signal from a boolean input signal vector"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal extBooSig1(
    final nin=4,
    final nout=5,
    final extract={3,2,4,1,1})
    "Block that extracts signal from a boolean input signal vector"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=true)
    "Block that outputs true signal"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "Block that outputs false signal"
    annotation (Placement(transformation(extent={{-80,-78},{-60,-58}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=0.2) "Generate pulse signal of type boolean"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final period=0.3)
    "Generate pulse signal of type boolean"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

equation
  connect(con1.y, extBooSig.u[1]) annotation (Line(points={{-58,60},{-10,60},{-10,
          29.25},{38,29.25}}, color={255,0,255}));
  connect(booPul.y, extBooSig.u[2]) annotation (Line(points={{-58,30},{-20,30},{
          -20,29.75},{38,29.75}}, color={255,0,255}));
  connect(booPul1.y, extBooSig.u[3]) annotation (Line(points={{-58,-30},{10,-30},
          {10,30.25},{38,30.25}}, color={255,0,255}));
  connect(con.y, extBooSig.u[4]) annotation (Line(points={{-58,-68},{20,-68},{20,
          30.75},{38,30.75}}, color={255,0,255}));
  connect(con1.y, extBooSig1.u[1]) annotation (Line(points={{-58,60},{-10,60},{-10,
          -30.75},{38,-30.75}}, color={255,0,255}));
  connect(booPul.y, extBooSig1.u[2]) annotation (Line(points={{-58,30},{-20,30},
          {-20,-30.25},{38,-30.25}}, color={255,0,255}));
  connect(booPul1.y, extBooSig1.u[3]) annotation (Line(points={{-58,-30},{10,-30},
          {10,-29.75},{38,-29.75}}, color={255,0,255}));
  connect(con.y, extBooSig1.u[4]) annotation (Line(points={{-58,-68},{20,-68},{20,
          -29.25},{38,-29.25}}, color={255,0,255}));
annotation (
  experiment(StopTime=1.0,Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/BooleanExtractSignal.mos" "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal\">
Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal</a>.
</p>
<p>
The instance <code>extBooSig</code> has the input vector with dimension of 4 and
the extracting vector is <code>[3, 2, 4]</code>. Thus the output vectors is <code>[u[3], u[2], u[4]]</code>.
</p>
<p>
The instance <code>extBooSig1</code> has the input vector with dimension of 4 and
the extracting vector is <code>[3, 2, 4, 1, 1]</code>. Thus the output vectors is <code>[u[3], u[2], u[4], u[1], u[1]]</code>.
</p>
<p>
Note that when the extracting vector <code>extract</code> has any element with the value that
is out of range <code>[1, nin]</code>, e.g. <code>[1, 4]</code> for instance in <code>extBooSig</code>.
It will issue error and the model will not translate.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 5, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end BooleanExtractSignal;
