within Buildings.Examples.VAVReheat.Controls;
expandable connector ControlBus
  "Empty control bus that is adapted to the signals connected to it"
  extends Modelica.Icons.SignalBus;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-20,2},{22,-2}},
          lineColor={255,204,51},
          lineThickness=0.5)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),
            graphics),
    Documentation(info="<html>
<p>
This connector defines the \"expandable connector\" ControlBus that
is used as bus in the
<a href=\"Modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a> example.
Note, this connector is \"empty\". When using it, the actual content is
constructed by the signals connected to this bus.
</p>
</html>"));
end ControlBus;
