within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces;
model WyeToDelta "This model represent a connection between wye to delta"

  Terminal_n wye annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Terminal_n delta annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
equation

  for i in 1:3 loop
    Connections.branch(wye.phase[i].theta, delta.phase[i].theta);
    wye.phase[i].theta = delta.phase[i].theta;
  end for;

  delta.phase[1].v[:] = wye.phase[1].v[:] - wye.phase[2].v[:];
  delta.phase[2].v[:] = wye.phase[2].v[:] - wye.phase[3].v[:];
  delta.phase[3].v[:] = wye.phase[3].v[:] - wye.phase[1].v[:];

  wye.phase[1].i[:] = + delta.phase[3].i[:] - delta.phase[1].i[:];
  wye.phase[2].i[:] = + delta.phase[1].i[:] - delta.phase[2].i[:];
  wye.phase[3].i[:] = + delta.phase[2].i[:] - delta.phase[3].i[:];

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{-50,40},{-50,0},{-80,-30}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-50,0},{-20,-30}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{0,-26},{40,34},{80,-26},{0,-26}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5)}),
    Documentation(revisions="<html>
<li>
June 5, 2014, by Marco Bonvini:<br/>
Added model.
</li>
</html>"));
end WyeToDelta;
