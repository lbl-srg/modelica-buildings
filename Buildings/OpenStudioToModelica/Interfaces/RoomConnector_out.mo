within Buildings.OpenStudioToModelica.Interfaces;
connector RoomConnector_out
  parameter Integer nPorts=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  Modelica.Blocks.Interfaces.RealOutput qGai[3]
    "Array of connectors representing the radiant, convective and latent internal heat gains for a room";
  Modelica.Fluid.Interfaces.FluidPort_b ports[nPorts]
    "Fluid connector directly connected to a room";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Polygon(
          points={{-40,100},{-40,0},{60,50},{-40,100}},
          lineColor={0,0,120},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,0},{58,-98}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-30,-10},{48,-88}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end RoomConnector_out;
