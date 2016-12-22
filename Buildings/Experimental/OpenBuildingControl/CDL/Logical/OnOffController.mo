within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block OnOffController "On-off controller"
  extends Modelica.Blocks.Icons.PartialBooleanBlock;
  Modelica.Blocks.Interfaces.RealInput reference
    "Connector of Real input signal used as reference signal"
    annotation (Placement(transformation(extent={{-140,80},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput u
    "Connector of Real input signal used as measurement signal"
    annotation (Placement(transformation(extent={{-140,-40},{-100,-80}})));
  Modelica.Blocks.Interfaces.BooleanOutput y
    "Connector of Real output signal used as actuator signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  parameter Real bandwidth(start=0.1) "Bandwidth around reference signal";
  parameter Boolean pre_y_start=false "Value of pre(y) at initial time";

initial equation
  pre(y) = pre_y_start;
equation
  y = pre(y) and (u < reference + bandwidth/2) or (u < reference - bandwidth/
    2);
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          extent={{-92,74},{44,44}},
          lineThickness=0.5,
          textString="reference"),
        Text(
          extent={{-94,-52},{-34,-74}},
          textString="u"),
        Line(points={{-76.0,-32.0},{-68.0,-6.0},{-50.0,26.0},{-24.0,40.0},{-2.0,42.0},{16.0,36.0},{32.0,28.0},{48.0,12.0},{58.0,-6.0},{68.0,-28.0}},
          color={0,0,127}),
        Line(points={{-78.0,-2.0},{-6.0,18.0},{82.0,-12.0}},
          color={255,0,0}),
        Line(points={{-78.0,12.0},{-6.0,30.0},{82.0,0.0}}),
        Line(points={{-78.0,-16.0},{-6.0,4.0},{82.0,-26.0}}),
        Line(points={{-82.0,-18.0},{-56.0,-18.0},{-56.0,-40.0},{64.0,-40.0},{64.0,-20.0},{90.0,-20.0}},
          color={255,0,255})}), Documentation(info="<html>
<p>The block OnOffController sets the output signal <b>y</b> to <b>true</b> when
the input signal <b>u</b> falls below the <b>reference</b> signal minus half of
the bandwidth and sets the output signal <b>y</b> to <b>false</b> when the input
signal <b>u</b> exceeds the <b>reference</b> signal plus half of the bandwidth.</p>
</html>"));
end OnOffController;
