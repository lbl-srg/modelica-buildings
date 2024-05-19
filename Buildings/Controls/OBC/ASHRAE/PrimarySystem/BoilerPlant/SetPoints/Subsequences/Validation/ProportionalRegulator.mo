within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.Validation;
model ProportionalRegulator
    "Validation model for ProportionalRegulator sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.ProportionalRegulator
    proReg(
    final TRetSet=60,
    final TRetMinAll=57.2)
    "Test model for ProportionalRegulator"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin(
    final amplitude=5,
    final freqHz=1/60,
    final offset=60)
    "Sine input"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

equation
  connect(sin.y, proReg.THotWatRet)
    annotation (Line(points={{-28,0},{-12,0}}, color={0,0,127}));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false),
      graphics={Ellipse(
                  lineColor = {75,138,73},
                  fillColor={255,255,255},
                  fillPattern = FillPattern.Solid,
                  extent={{-100,-100},{100,100}}),
                Polygon(
                  lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=60,
      Interval=1,
      Tolerance=1e-06),
      __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/SetPoints/Subsequences/Validation/ProportionalRegulator.mos"
        "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.ProportionalRegulator\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.ProportionalRegulator</a>.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      July 21, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end ProportionalRegulator;
