within Buildings.Controls.OBC.CDL.Reals.Validation;
model Derivative
  "Test model for the derivative block"
  Buildings.Controls.OBC.CDL.Reals.Derivative der1(y_start=1)
    "Derivative block with input gains"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Reals.Sources.Constant con(k=1) "Outputs 1"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Reals.Sources.Ramp ram(
    height=0.09,
    duration=10,
    offset=0.01,
    startTime=5) "Ramp for time constant used in approximating derivative"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.CivilTime modTim
    "Civil time"
    annotation (Placement(transformation(extent={{-110,0},{-90,20}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes(y_start=1)
    "Integration of input"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Logical.Sources.Constant booSig(k=false) "Contant boolean signal"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Cos cos "Cosine of model time"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Reals.Derivative der2(y_start=0)
    "Derivative block with input gains"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Reals.Sources.Constant con2(k=2) "Outputs 2"
    annotation (Placement(transformation(extent={{-40,-72},{-20,-52}})));
  Reals.Sources.Constant T(k=0.1) "Time constant for derivative approximation"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Utilities.Assert assMes(message="Differentiated value differs more than threshold")
    "Issue an error if results differ more than a threshold"
    annotation (Placement(transformation(extent={{170,26},{190,46}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Difference between original signal, and differentiated integral of that signal"
    annotation (Placement(transformation(extent={{80,26},{100,46}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs "Absolute difference"
    annotation (Placement(transformation(extent={{110,26},{130,46}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr(t=0.1, h=0.01)
    "Output true if difference is within expected accuracy"
    annotation (Placement(transformation(extent={{140,26},{160,46}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(final k=1)
    "Dummy gain to avoid unit difference error"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(con.y, der1.k) annotation (Line(points={{-58,80},{-10,80},{-10,58},{38,
          58}}, color={0,0,127}));
  connect(ram.y, der1.T) annotation (Line(points={{-58,50},{-20,50},{-20,54},{38,
          54}}, color={0,0,127}));
  connect(intWitRes.y, der1.u) annotation (Line(points={{22,10},{30,10},{30,50},
          {38,50}}, color={0,0,127}));
  connect(booSig.y, intWitRes.trigger)
    annotation (Line(points={{-18,-20},{10,-20},{10,-2}}, color={255,0,255}));
  connect(intWitRes.u, cos.y)
    annotation (Line(points={{-2,10},{-18,10}}, color={0,0,127}));
  connect(intWitRes.y_reset_in, cos.y) annotation (Line(points={{-2,2},{-10,2},{
          -10,10},{-18,10}}, color={0,0,127}));
  connect(intWitRes.y, der2.u) annotation (Line(points={{22,10},{30,10},{30,-70},
          {38,-70}}, color={0,0,127}));
  connect(con2.y, der2.k) annotation (Line(points={{-18,-62},{38,-62}},
                 color={0,0,127}));
  connect(T.y, der2.T) annotation (Line(points={{22,-80},{34,-80},{34,-66},{38,-66}},
        color={0,0,127}));
  connect(der1.y, sub.u1) annotation (Line(points={{62,50},{70,50},{70,42},{78,42}},
        color={0,0,127}));
  connect(cos.y, sub.u2) annotation (Line(points={{-18,10},{-10,10},{-10,30},{78,
          30}}, color={0,0,127}));
  connect(sub.y, abs.u)
    annotation (Line(points={{102,36},{108,36}}, color={0,0,127}));
  connect(abs.y, lesThr.u)
    annotation (Line(points={{132,36},{138,36}}, color={0,0,127}));
  connect(lesThr.y, assMes.u)
    annotation (Line(points={{162,36},{168,36}}, color={255,0,255}));
  connect(modTim.y, gai.u)
    annotation (Line(points={{-88,10},{-82,10}}, color={0,0,127}));
  connect(gai.y, cos.u)
    annotation (Line(points={{-58,10},{-42,10}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=10.0,
      Tolerance=1e-07),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Validation/Derivative.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Derivative\">
Buildings.Controls.OBC.CDL.Reals.Derivative</a>.
The model integrates a time varying signal, and the differentiates this integrated signal.
Hence, the output <code>der1.y</code> matches the non-integrated signal <code>intWitRes.u</code>,
within a small approximation tolerance.
</p>
<p>
The instance <code>der1</code> uses a varying input for <code>T</code> which controls the accuracy of
the derivative approximation. At the start of the simulation, <code>T</code> is small and hence
the output <code>der1.y</code> matches the signal <code>intWitRes.u</code> well.
As expected, the approximation error increases with increasing <code>der1.T</code>.
</p>
<p>
The instance <code>der2</code> uses a gain of <i>2</i>, and it initializes the output to <i>0</i>.
Hence, there is a fast transient at the beginning, and afterwards the output matches <code>der1.y = der2.y / 2</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 20, 2022, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3022\">Buildings, issue 3022</a>.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
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
    Diagram(coordinateSystem(extent={{-120,-100},{200,100}})));
end Derivative;
