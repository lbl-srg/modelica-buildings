within Buildings.Fluid;
package MassExchangers "Package with mass exchanger models"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains models for mass exchangers.
For heat exchanger models without humidity transfer, see the package
<a href=\"modelica://Buildings.Fluid.HeatExchangers\">
Buildings.Fluid.HeatExchangers</a>.
</p>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-82,63},{86,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-84,-57},{84,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,88},{56,-84}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{56,88},{-24,-40}}, color={0,0,0},
          thickness=0.5),
        Line(
          points={{34,-24},{24,-44},{22,-48},{20,-54},{22,-60},{28,-64},{36,-64},
              {44,-60},{46,-54},{44,-46},{34,-24}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{0,-24},{-10,-44},{-12,-48},{-14,-54},{-12,-60},{-6,-64},{2,-64},
              {10,-60},{12,-54},{10,-46},{0,-24}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-32,-24},{-42,-44},{-44,-48},{-46,-54},{-44,-60},{-38,-64},{-30,
              -64},{-22,-60},{-20,-54},{-22,-46},{-32,-24}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(points={{-40,-62},{-54,-84}},
                                         color={0,0,0},
          thickness=0.5)}));
end MassExchangers;
