within Buildings.OpenStudioToModelica.Interfaces;
partial model InternalHeatGains
  "Model that can be used as a base for modeling internal heat gains"
  extends Buildings.BaseClasses.BaseIcon;
  RoomConnector_out roomConnector_out
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{80,-20},{120,20}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(revisions="<html>
<ul>
<li>
March 23, 2015, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end InternalHeatGains;
