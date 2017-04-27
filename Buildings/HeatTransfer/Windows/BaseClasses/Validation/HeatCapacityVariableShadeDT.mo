within Buildings.HeatTransfer.Windows.BaseClasses.Validation;
model HeatCapacityVariableShadeDT
  "Validation model for heat capacity with variable shade signal and different room temperature"
  extends HeatCapacityVariableShade(heaCapSha(T(start=298.15)));
annotation(experiment(Tolerance=1e-6, StopTime=600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/BaseClasses/Validation/HeatCapacityVariableShadeDT.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates the heat capacitor model for the window glass,
with varying control signal and heat conduction to a thermal capacity
that is a surrogate for the room model.
As the thermal capacity is at a different temperature, heat is exchanged.
The window area with the small control signal is smaller, and hence
a smaller amount of heat is exchanged.
</p>
</html>", revisions="<html>
<ul>
<li>
November 1, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatCapacityVariableShadeDT;
