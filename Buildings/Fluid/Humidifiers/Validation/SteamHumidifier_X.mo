within Buildings.Fluid.Humidifiers.Validation;
model SteamHumidifier_X
  "Model that demonstrates the steam humidifier model, configured as steady-state model"
  extends Buildings.Fluid.Humidifiers.Validation.SprayAirWasher_X(
    redeclare Buildings.Fluid.Humidifiers.SteamHumidifier_X hum(
      mWatMax_flow=mWat_flow_nominal));

annotation (
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/Validation/SteamHumidifier_X.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Model that validates the use of a spray air washer
configured as a steady-state model with limits on the maximum water mass flow rate
that is added to the air stream.
</p>
</html>", revisions="<html>
<ul>
<li>
November 3, 2017, by Michael Wetter:<br/>
Removed <code>import</code> statement.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/852\">#852</a>.
</li>
<li>
May 3, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=1080,
      Tolerance=1e-6));
end SteamHumidifier_X;
