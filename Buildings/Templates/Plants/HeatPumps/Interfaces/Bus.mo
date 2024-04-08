within Buildings.Templates.Plants.HeatPumps.Interfaces;
expandable connector Bus
  "Control bus for heat pump plant"
  extends Modelica.Icons.SignalBus;
  annotation (
    defaultComponentName="bus",
    Documentation(
      info="<html>
  <p>
  This expandable connector provides a standard interface for
  all control signals of the heat pump plant models within
  <a href=\"modelica://Buildings.Templates.Plants.HeatPumps\">
  Buildings.Templates.Plants.HeatPumps</a>.
  </p>
  </html>"));
end Bus;
