within Buildings.Controls.OBC.RadiantSystems.Cooling.Validation;
model HighMassSupplyTemperature_TRoomRelHum
  "Validation model for the room temperature controller that takes the room temperature set point as an input"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TPhiRooMea(
    table=[0.0, 18, 0.5;
           0.5, 28, 0.5;
           1.0, 18, 0.5;
           1.0, 18, 0.9;
           1.5, 28, 0.9;
           2.0, 18, 0.9],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint,
    offset={273.15, 0},
    timeScale=3600) "Measured room temperature and relative humidity"
    annotation (Placement(transformation(extent={{-62,-30},{-42,-10}})));

  Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum conCoo(
      TSupSet_min=291.15) "Controller"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooSet(final k(
      final unit="K",
      displayUnit="degC") = 297.15) "Set point temperature for room"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

  CDL.Psychrometrics.DewPoint_TDryBulPhi dewPoi "Dew point temperature"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
equation
  connect(TRooSet.y, conCoo.TRooSet) annotation (Line(points={{-38,20},{-16,20},
          {-16,6},{-2,6}},  color={0,0,127}));
  connect(TPhiRooMea.y[1], conCoo.TRoo) annotation (Line(points={{-40,-20},{-14,
          -20},{-14,-4},{-2,-4}},
                             color={0,0,127}));
  connect(TPhiRooMea.y[2], conCoo.phiRoo) annotation (Line(points={{-40,-20},{-14,
          -20},{-14,-8},{-2,-8}},color={0,0,127}));
  connect(dewPoi.TDryBul, TPhiRooMea.y[1]) annotation (Line(points={{-2,-24},{-14,
          -24},{-14,-20},{-40,-20}}, color={0,0,127}));
  connect(dewPoi.phi, TPhiRooMea.y[2]) annotation (Line(points={{-2,-36},{-14,-36},
          {-14,-20},{-40,-20}}, color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<p>
This example validates the room temperature controller
<a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum\">
Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TRoomRelHum</a>
for the radiant system.
The validation model applies a tabulated signal to the controller input for the measured room air temperature.
The model also calculates the dew point temperature to verify that the supply water temperature is never below the dew point.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 7, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RadiantSystems/Cooling/Validation/HighMassSupplyTemperature_TRoomRelHum.mos" "Simulate and plot"),
    experiment(
      StopTime=7200,
      Tolerance=1e-06));
end HighMassSupplyTemperature_TRoomRelHum;
