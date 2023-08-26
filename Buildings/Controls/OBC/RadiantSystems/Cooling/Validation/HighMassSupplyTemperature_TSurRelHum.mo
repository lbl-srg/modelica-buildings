within Buildings.Controls.OBC.RadiantSystems.Cooling.Validation;
model HighMassSupplyTemperature_TSurRelHum
  "Validation model for the room temperature controller that takes the surface temperature set point as an input"
  extends Modelica.Icons.Example;

  Controls.OBC.CDL.Continuous.Sources.TimeTable TPhiRooMea(
    table=[0.0, 18, 0.5;
           0.5, 28, 0.5;
           1.0, 18, 0.5;
           1.0, 18, 0.9;
           1.5, 28, 0.9;
           2.0, 18, 0.9],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint,
    offset={273.15, 0},
    timeScale=3600) "Measured room temperature and relative humidity"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TSurRelHum
                                                                            conCoo(
      TSupSet_min=291.15) "Controller"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Controls.OBC.CDL.Continuous.Sources.Constant TSurSet(final k(
      final unit="K",
      displayUnit="degC") = 293.15) "Set point temperature for surface"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  CDL.Psychrometrics.DewPoint_TDryBulPhi dewPoi "Dew point temperature"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  CDL.Reals.Sources.Ramp     TSur(
    height=1,
    duration=1800,
    offset=293.15)                  "Measured surface temperature"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(TPhiRooMea.y[1], conCoo.TRoo) annotation (Line(points={{-38,-20},{-14,
          -20},{-14,-4},{-2,-4}},
                             color={0,0,127}));
  connect(TPhiRooMea.y[2], conCoo.phiRoo) annotation (Line(points={{-38,-20},{-14,
          -20},{-14,-8},{-2,-8}},color={0,0,127}));
  connect(dewPoi.TDryBul, TPhiRooMea.y[1]) annotation (Line(points={{-2,-24},{-14,
          -24},{-14,-20},{-38,-20}}, color={0,0,127}));
  connect(dewPoi.phi, TPhiRooMea.y[2]) annotation (Line(points={{-2,-36},{-14,-36},
          {-14,-20},{-38,-20}}, color={0,0,127}));
  connect(conCoo.TSurSet, TSurSet.y) annotation (Line(points={{-2,8},{-8,8},{-8,
          40},{-38,40}}, color={0,0,127}));
  connect(TSur.y, conCoo.TSur) annotation (Line(points={{-38,10},{-20,10},{-20,4},
          {-2,4}}, color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<p>
This example validates the room temperature controller
<a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TSurRelHum\">
Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TSurRelHum</a>
for the radiant system.
The validation model applies a
ramp signal for the measured surface temperature and a tabulated signal to the controller input for the measured room air temperature.
The model also calculates the dew point temperature to verify that the supply water temperature is never below the dew point.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 29, 2022, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RadiantSystems/Cooling/Validation/HighMassSupplyTemperature_TSurRelHum.mos" "Simulate and plot"),
    experiment(
      StopTime=7200,
      Tolerance=1e-06));
end HighMassSupplyTemperature_TSurRelHum;
