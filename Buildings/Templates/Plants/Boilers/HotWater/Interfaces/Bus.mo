within Buildings.Templates.Plants.Boilers.HotWater.Interfaces;
expandable connector Bus "Control bus for HW plant"
  extends Modelica.Icons.SignalBus;

  annotation (
    defaultComponentName="bus", Documentation(info="<html>
<p>
This expandable connector provides a standard interface for
all control signals of the hot water plant models within
<a href=\"modelica://Buildings.Templates.Plants.Boilers.HotWater\">
Buildings.Templates.Plants.Boilers.HotWater</a>.
</p>
</html>"));
end Bus;
