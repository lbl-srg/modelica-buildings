within Buildings.Templates.Components.Interfaces;
expandable connector Bus "Control bus"
  extends Modelica.Icons.SignalBus;

  Modelica.Units.SI.Temperature TSet
  "Temperature setpoint";

  annotation (
    defaultComponentName="bus", Documentation(info="<html>
<p>
This expandable connector provides a standard interface for
all control signals of the component models.
</p>
</html>"));
end Bus;
