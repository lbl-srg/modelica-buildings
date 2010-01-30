within Buildings.BaseClasses;
partial class BaseIconExamples "Icon for Examples packages"

  annotation (             Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-100,-100},{80,50}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,50},{-80,70},{100,70},{80,50},{-100,50}},
          lineColor={0,0,0},
          fillColor={179,179,119},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{100,70},{100,-80},{80,-100},{80,50},{100,70}},
          lineColor={0,0,0},
          fillColor={179,179,119},
          fillPattern=FillPattern.Solid)}));

end BaseIconExamples;
