within Buildings.Examples.ChillerPlant;
model DataCenterContinuousTimeControl
  "Model of data center that approximates the trim and respond logic"
  extends Buildings.Examples.ChillerPlant.BaseClasses.DataCenter;
  extends Modelica.Icons.Example;

  BaseClasses.Controls.TrimAndRespondContinuousTimeApproximation triAndRes
    "Continuous time approximation for trim and respond controller"
    annotation (Placement(transformation(extent={{-194,216},{-174,236}})));
equation
  connect(feedback.y, triAndRes.u) annotation (Line(
      points={{-191,200},{-194,200},{-194,226},{-196,226}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(triAndRes.y, linPieTwo.u) annotation (Line(
      points={{-173,226},{-148,226},{-148,200},{-122,200}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/DataCenterContinuousTimeControl.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is the chilled water plant with continuous time control.
The trim and respond logic is approximated by a PI controller which
significantly reduces computing time. The model is described at
<a href=\"Buildings.Examples.ChillerPlant\">
Buildings.Examples.ChillerPlant</a>.
</p>
<p>
See
<a href=\"Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl\">
Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl</a>
for an implementation with the discrete time trim and respond logic.
</p>
</html>", revisions="<html>
<ul>
<li>
January 13, 2015, by Michael Wetter:<br/>
Moved base model to
<a href=\"Buildings.Examples.ChillerPlant.BaseClasses.DataCenter\">
Buildings.Examples.ChillerPlant.BaseClasses.DataCenter</a>.
</li>
<li>
December 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-300},{400,
            300}}), graphics),
    experiment(StartTime=13046400, Tolerance=1e-6, StopTime=13651200));
end DataCenterContinuousTimeControl;
