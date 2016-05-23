within Buildings.Fluid.FMI;
package Adaptors "Adaptors to connect models with fluid ports and models with signal ports"
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
          origin={-76,22},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,0.0},{60.0,60.0}}),
        Ellipse(
          origin={-76,-64},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,0.0},{60.0,60.0}}),
      Polygon(
        points={{32,76},{32,22},{78,50},{32,76}},
        fillColor={135,135,135},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
      Polygon(
        points={{76,-12},{76,-66},{30,-40},{76,-12}},
        fillColor={135,135,135},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None)}));
end Adaptors;
