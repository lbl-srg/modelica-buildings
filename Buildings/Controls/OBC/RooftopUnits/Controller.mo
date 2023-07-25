within Buildings.Controls.OBC.RooftopUnits;
block Controller "Sequences to rooftop unit heat pump systems"
  extends Modelica.Blocks.Icons.Block;

  annotation (defaultComponentName="RTUCon",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-140},{100,140}}),
        graphics={
          Rectangle(
            extent={{-100,-140},{100,140}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,140},{100,140}},
            textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-140},{200,140}})));
end Controller;
