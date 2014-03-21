within Buildings.Electrical.Examples;
model DemandResponseCtrl
  extends Buildings.Electrical.Examples.BaseClasses.DemandResponseBase(linear = false);
  Modelica.Blocks.Interfaces.RealInput Pstore(nominal=5000)
    "Power stored in battery (if positive), or extracted from battery (if negative)"
    annotation (Placement(transformation(extent={{8,56},{48,96}})));
equation
  connect(Pstore, battery.P) annotation (Line(
      points={{28,76},{64,76},{64,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end DemandResponseCtrl;
