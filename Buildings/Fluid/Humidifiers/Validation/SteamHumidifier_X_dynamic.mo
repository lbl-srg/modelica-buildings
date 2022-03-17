within Buildings.Fluid.Humidifiers.Validation;
model SteamHumidifier_X_dynamic
  "Model that demonstrates the steam humidifier model, configured as dynamic model"
  extends Buildings.Fluid.Humidifiers.Validation.SprayAirWasher_X(
    redeclare Buildings.Fluid.Humidifiers.SteamHumidifier_X hum(
      mWatMax_flow=mWat_flow_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));

annotation (
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/Validation/SteamHumidifier_X_dynamic.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Model that validates the use of a spray air washer
configured as a dynamic model with limits on the maximum water mass flow rate
that is added to the air stream.
</p>
</html>", revisions="<html>
<ul>
<li>
May 3, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=1080,
      Tolerance=1e-6));
end SteamHumidifier_X_dynamic;
