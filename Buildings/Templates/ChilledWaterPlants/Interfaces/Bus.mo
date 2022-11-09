within Buildings.Templates.ChilledWaterPlants.Interfaces;
expandable connector Bus "Control bus for chilled water plant"
  extends Modelica.Icons.SignalBus;

  annotation (
  defaultComponentName="bus",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
                  extent={{-20,2},{22,-2}},
                  lineColor={255,204,51},
                  lineThickness=0.5)}), Documentation(info="<html>
<p>
This expandable connector provides a standard interface for 
all control signals required by a chiller plant controller. 
</p>
</html>"));
end Bus;
