within Buildings.Fluid.FMI;
package Adaptors "Package with adaptors to connect models with fluid ports and models with signal ports"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains adaptors that allow connecting models with fluid ports
and models with input and output signals.
These adaptors are used, for example, to export an HVAC system as a Functional Mockup Unit.
</p>
</html>"),
  Icon(graphics={
        Ellipse(
          origin={-70,16},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,0.0},{60.0,60.0}}),
        Ellipse(
          origin={-70,-62},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,0.0},{60.0,60.0}}),
      Polygon(
        points={{26,72},{26,18},{72,46},{26,72}},
        fillColor={135,135,135},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
      Polygon(
        points={{72,-8},{72,-62},{26,-36},{72,-8}},
        fillColor={135,135,135},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None)}));
end Adaptors;
