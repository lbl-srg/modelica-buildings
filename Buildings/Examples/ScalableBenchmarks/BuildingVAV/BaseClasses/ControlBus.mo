within Buildings.Examples.ScalableBenchmarks.BuildingVAV.BaseClasses;
expandable connector ControlBus
  "Control bus that is adapted to the signals connected to it"
  extends Modelica.Icons.SignalBus;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This connector defines the <code>expandable connector</code> ControlBus that
is used to connect control signals.
Note, this connector is empty. When using it, the actual content is
constructed by the signals connected to this bus.
</p>
</html>"));
end ControlBus;
