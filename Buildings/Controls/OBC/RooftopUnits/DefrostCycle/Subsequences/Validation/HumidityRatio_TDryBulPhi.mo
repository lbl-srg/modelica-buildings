within Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Subsequences.Validation;
model HumidityRatio_TDryBulPhi
  "Validation model for defrost time"

  Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Subsequences.HumidityRatio_TDryBulPhi wBulPhi
    "Block for humidity ratio computation"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp phi(
    duration=1800,
    height=1,
    offset=0.001)
    "Relative humidity"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDryBul(k=273.15 + 30)
    "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

equation
  connect(phi.y, wBulPhi.phi) annotation (Line(points={{-18,-30},{0,-30},{0,-6},
          {18,-6}}, color={0,0,127}));
  connect(TDryBul.y, wBulPhi.TOut)
    annotation (Line(points={{-18,30},{0,30},{0,6},{18,6}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/DefrostCycle/Subsequences/Validation/HumidityRatio_TDryBulPhi.mos"
    "Simulate and plot"),
  Documentation(info="<html>
  <p>
  This is a validation model for the controller
  <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Subsequences.HumidityRatio_TDryBulPhi\">
  Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Subsequences.HumidityRatio_TDryBulPhi</a>.
  </p>
  </html>",revisions="<html>
  <ul>
  <li>
  August 10, 2023, by Junke Wang and Karthik Devaprasad:<br/>   First implementation.
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
  Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end HumidityRatio_TDryBulPhi;
