within Districts.Electrical.AC.Loads;
model SeriesConnection
  extends BaseClasses.SeriesConnections;
  parameter Integer N = 2 "number of loads connected in series";
  Interfaces.SinglePhasePlug seriesLoads[N] annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{
            80,-20},{120,20}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-80,40},{80,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-92,0},{-80,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{80,0},{92,0}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=1),
        Text(
          extent={{-80,10},{80,-10}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="series")}),   Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
equation
  connect(seriesLoads[1].phase[1], sPhasePlug.phase[1]);
  for n in 1:N-1 loop
    connect(seriesLoads[n].neutral, seriesLoads[n+1].phase[1]);
    //seriesLoads[n].phase[1].i + seriesLoads[n].neutral.i = Complex(0);
  end for;
  connect(seriesLoads[N].neutral, sPhasePlug.neutral);
end SeriesConnection;
