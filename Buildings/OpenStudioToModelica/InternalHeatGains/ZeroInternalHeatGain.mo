within Buildings.OpenStudioToModelica.InternalHeatGains;
model ZeroInternalHeatGain
  "This model represents an internal heat gain that is null"
  extends Buildings.OpenStudioToModelica.Interfaces.InternalHeatGains;
  Modelica.Blocks.Sources.Constant zeroIhg(k=0)
    "Internal heat gain that is equal to zero"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow zeroHeatFlow(Q_flow=0)
    "Null heat flow"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation

  connect(zeroIhg.y, roomConnector_out.qGai[1]) annotation (Line(
      points={{11,0},{54,0},{54,0.05},{100.05,0.05}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zeroIhg.y, roomConnector_out.qGai[2]) annotation (Line(
      points={{11,0},{56,0},{56,0.05},{100.05,0.05}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zeroIhg.y, roomConnector_out.qGai[3]) annotation (Line(
      points={{11,0},{56,0},{56,0.05},{100.05,0.05}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zeroHeatFlow.port, roomConnector_out.heaPorAir) annotation (Line(
        points={{10,-40},{54,-40},{54,0.05},{100.05,0.05}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-70,34},{70,-24}},
          lineColor={0,0,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="[0,0,0]")}),
    Documentation(revisions="<html>
<ul>
<li>
March 23, 2015, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZeroInternalHeatGain;
