within Buildings.OpenStudioToModelica.Interfaces;
connector RoomConnector_out
  "Room connector that allows to specify IHG and boundary conditions to fluid ports"
  parameter Integer nPorts=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);
  Modelica.Blocks.Interfaces.RealOutput qGai[3]
    "Array of connectors representing the radiant, convective and latent internal heat gains for a room"
    annotation ();
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorAir
    "Heat port connectd to the air in a room";
  Modelica.Fluid.Interfaces.FluidPort_b ports[nPorts](
  redeclare each final package Medium = Medium)
    "Fluid connector directly connected to a room" annotation ();
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Polygon(
          points={{-40,150},{-40,50},{60,100},{-40,150}},
          lineColor={0,0,120},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,50},{60,-50}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-30,40},{50,-40}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                  Rectangle(
          extent={{-36,-52},{56,-144}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Documentation(revisions="<html>
<ul>
<li>
March 23, 2015, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end RoomConnector_out;
