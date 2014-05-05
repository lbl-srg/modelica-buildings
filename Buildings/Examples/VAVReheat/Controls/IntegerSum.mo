within Buildings.Examples.VAVReheat.Controls;
block IntegerSum "Sums all the integer signals"
  extends Modelica.Blocks.Interfaces.IntegerSO;
  parameter Integer nin "Number of inputs";
  Modelica.Blocks.Interfaces.IntegerInput u[nin] "Input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
          rotation=0)));
equation
  y = sum(u);
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="k=%k")}),
                          Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}})));
end IntegerSum;
