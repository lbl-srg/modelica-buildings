within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeams.SetPoints.Validation;
model OperatingMode
  "Validate system operating mode setpoint controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeams.SetPoints.OperatingMode
    operatingMode(
	final schTab=[0,0; 1,1; 2,0; 24,0])
	"Instance of operating mode calculator for validation"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
	
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(final period=4000)
    "Boolean pulse source"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

equation
  connect(booPul.y, operatingMode.uDetOcc)
    annotation (Line(points={{-8,0},{8,0}}, color={255,0,255}));
annotation (
  experiment(
      StopTime=7200,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChilledBeams/SetPoints/Validation/OperatingMode.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeams.SetPoints.OperatingMode\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeams.SetPoints.OperatingMode</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 1, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end OperatingMode;
