within Buildings.OpenStudioToModelica.InternalHeatGains;
model ZeroInternalHeatGain
  "This model represents an internal heat gain that is null"
  extends Buildings.OpenStudioToModelica.Interfaces.InternalHeatGains;
  Modelica.Blocks.Sources.Constant zero_ihg(k=0)
    "Internal heat gain that is equal to zero"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation

  connect(zero_ihg.y, roomConnector_out.qGai[1]) annotation (Line(
      points={{11,0},{54,0},{54,4.44089e-16},{100,4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zero_ihg.y, roomConnector_out.qGai[2]) annotation (Line(
      points={{11,0},{56,0},{56,4.44089e-16},{100,4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zero_ihg.y, roomConnector_out.qGai[3]) annotation (Line(
      points={{11,0},{56,0},{56,4.44089e-16},{100,4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-70,34},{70,-24}},
          lineColor={0,0,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="[0,0,0]")}));
end ZeroInternalHeatGain;
