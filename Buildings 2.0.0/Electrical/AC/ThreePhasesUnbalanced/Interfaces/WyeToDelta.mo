within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces;
model WyeToDelta "This model represent a connection between wye to delta"

  Terminal_n wye "Terminal Y" annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Terminal_n delta "Terminal D" annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
equation

  for i in 1:3 loop
    Connections.branch(wye.phase[i].theta, delta.phase[i].theta);
    wye.phase[i].theta = delta.phase[i].theta;
  end for;

  delta.phase[1].v[:] = wye.phase[1].v[:] - wye.phase[2].v[:];
  delta.phase[2].v[:] = wye.phase[2].v[:] - wye.phase[3].v[:];
  delta.phase[3].v[:] = wye.phase[3].v[:] - wye.phase[1].v[:];

  -wye.phase[1].i[:] + delta.phase[3].i[:] = delta.phase[1].i[:];
  -wye.phase[2].i[:] + delta.phase[1].i[:] = delta.phase[2].i[:];
  -wye.phase[3].i[:] + delta.phase[2].i[:] = delta.phase[3].i[:];

  annotation (
  defaultComponentName="y2d",
 Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{-40,-26},{0,34},{40,-26},{-40,-26}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5)}),
    Documentation(revisions="<html>
<ul>
<li>
October 9, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
June 5, 2014, by Marco Bonvini:<br/>
Added model.
</li>
</ul>
</html>", info="<html>
<p>
Adapter from Wye (Y) to Delta (D) connector.
A three-phase unbalanced connector has three AC single phase
connectors. Each AC single phase connector contains the phase voltage,
which is measured between the phase and the neutral.
This model converts the phase voltage to the line voltage, measured between
the phases.
</p>
<p>
The image below show how the phasors are computed when converting from Y to D.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Interfaces/YtoD.png\"/>
</p>
</html>"));
end WyeToDelta;
