within Buildings.Templates.Components.Controls.Validation;
model MultipleCommands "Validation model for converter of multiple commands"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse y1[3](
    width={0.5,0.6,0.4},
    each period=600,
    shift={100,200,300})
                       "Enable command"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Templates.Components.Controls.MultipleCommands conCom(nUni=3)
    "Converter of multiple commands"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(y1.y, conCom.y1)
    annotation (Line(points={{-58,0},{-12,0}}, color={255,0,255}));
    annotation (
 __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Controls/Validation/MultipleCommands.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=2000.0),
    Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Components.Controls.MultipleCommands\">
Buildings.Templates.Components.Controls.MultipleCommands</a>.
</p>
</html>"));
end MultipleCommands;
