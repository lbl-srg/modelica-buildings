within Buildings.Examples.Tutorial.CDL.Controls.Validation;
model EquipmentOnOff
  "Validation model for the equipment on/off controller"
    extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TBoi(
    height=40,
    duration=3600,
    offset=333.15) "Boiler temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Examples.Tutorial.CDL.Controls.EquipmentOnOff
    conEquSta "Controller for equipment on/off"
              annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse onSys(
    period=600)
    "System on signal"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(TBoi.y, conEquSta.TBoi) annotation (Line(points={{-38,30},{-24,30},{-24,
          6},{-10,6}}, color={0,0,127}));
  connect(onSys.y, conEquSta.onSys) annotation (Line(points={{-38,-10},{-24,-10},
          {-24,-6},{-10,-6}}, color={255,0,255}));
  annotation (
    Documentation(info="<html>
<p>
Validation model for the equipment on/off controller.
The input to the controller is a ramp signal of increasing measured boiler water temperature,
and a on/off signal for the overall system.
The validation shows that the pumps are on/off based on the overall system, and the boiler is
also on/off based on this system unless the return water temperature exceeds <i>90</i>&deg;C.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/CDL/Controls/Validation/EquipmentOnOff.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06));
end EquipmentOnOff;
