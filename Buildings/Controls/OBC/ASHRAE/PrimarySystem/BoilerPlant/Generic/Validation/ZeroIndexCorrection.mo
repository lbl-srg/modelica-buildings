within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Validation;
model ZeroIndexCorrection
  "Validation model for zero stage index correction block"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.ZeroIndexCorrection
    zerStaIndCor
    "Validation instance with zero index signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.ZeroIndexCorrection
    zerStaIndCor1
    "Validation instance with index signal one"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conCap(
    final k=10)
    "Constant capacity value"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntZer(
    final k=0)
    "Zero integer signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntOne(
    final k=1)
    "Constant integer one signal"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

equation

  connect(conCap.y, zerStaIndCor.uCap) annotation (Line(points={{-58,-40},{-50,-40},
          {-50,-4},{-42,-4}}, color={0,0,127}));
  connect(conCap.y, zerStaIndCor1.uCap) annotation (Line(points={{-58,-40},{50,-40},
          {50,-4},{58,-4}}, color={0,0,127}));
  connect(conIntZer.y, zerStaIndCor.uInd) annotation (Line(points={{-58,40},{-50,
          40},{-50,4},{-42,4}}, color={255,127,0}));
  connect(conIntOne.y, zerStaIndCor1.uInd) annotation (Line(points={{42,40},{50,
          40},{50,4},{58,4}}, color={255,127,0}));
annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Validation/Up.mos"
    "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This example validates
    <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.ZeroIndexCorrection\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.ZeroIndexCorrection</a>.
    </p>
    <p>
    It contains two instances:
    <ul>
    <li>
    zerStaIndCor: Gets a zero index input signal.
    </li>
    <li>
    zerStaIndCor1: Gets a non-zero index input signal.
    </li>
    </ul>
    The model simulates and plots these two instances to demonstrate that the block
    is performing the modifications correctly.
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    April 3, 2023, by Karthik Devaprasad:<br/>
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
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}})),
  experiment(Tolerance=1e-6));
end ZeroIndexCorrection;
