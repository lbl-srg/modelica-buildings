within Buildings.Controls.OBC.RadiantSystems.Heating.Validation;
model HighMassSupplyTemperature_TRoom
  "Validation model for the room temperature controller"
  extends Modelica.Icons.Example;

  Controls.OBC.CDL.Continuous.Sources.TimeTable TRooMea(
    table=[0,18; 1,22; 2,18],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint,
    offset={273.15},
    timeScale=3600) "Measured room temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Controls.OBC.RadiantSystems.Heating.HighMassSupplyTemperature_TRoom conHea(TSupSet_max=303.15) "Controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

protected
  Controls.OBC.CDL.Continuous.Sources.Constant TRooSet(final k(
      final unit="K",
      displayUnit="degC") = 293.15) "Set point temperature for room"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
equation
  connect(TRooSet.y, conHea.TRooSet) annotation (Line(points={{-58,20},{-36,20},
          {-36,6},{-12,6}}, color={0,0,127}));
  connect(TRooMea.y[1], conHea.TRoo) annotation (Line(points={{-58,-30},{-34,-30},
          {-34,-6},{-12,-6}}, color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<p>
This example validates the room temperature controller
<a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.Heating.HighMassSupplyTemperature_TRoom\">
Buildings.Controls.OBC.RadiantSystems.Heating.HighMassSupplyTemperature_TRoom</a>
for the radiant system.
The validation model applies a ramp signal to the controller input for the measured room air temperature.
</p>
</html>",
      revisions="<html>
<ul>
<li>
August 26, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RadiantSystems/Heating/Validation/HighMassSupplyTemperature_TRoom.mos" "Simulate and plot"),
    experiment(
      StopTime=7200,
      Tolerance=1e-06));
end HighMassSupplyTemperature_TRoom;
