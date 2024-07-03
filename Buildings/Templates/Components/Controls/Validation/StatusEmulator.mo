within Buildings.Templates.Components.Controls.Validation;
model StatusEmulator "Validation model for status emulator"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse y1(period=10)
    "Enable command"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Templates.Components.Controls.StatusEmulator sta
    "Generate status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(y1.y, sta.y1)
    annotation (Line(points={{-58,0},{-12,0}}, color={255,0,255}));
    annotation (
 __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Controls/Validation/StatusEmulator.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=50.0),
    Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Components.Controls.StatusEmulator\">
Buildings.Templates.Components.Controls.StatusEmulator</a>.
</p>
</html>", revisions="<html>
</html>"));
end StatusEmulator;
