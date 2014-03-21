within Buildings.Electrical.Examples;
model DemandResponse
  extends Buildings.Electrical.Examples.BaseClasses.DemandResponseBase(
    building,
    building1,
    building2,
    line1,
    line2,
    line3,
    battery,
    linear = false);
  Modelica.Blocks.Sources.Constant const
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
equation
  connect(const.y, battery.P) annotation (Line(
      points={{61,70},{64,70},{64,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end DemandResponse;
