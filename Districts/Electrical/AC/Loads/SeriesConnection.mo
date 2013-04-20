within Districts.Electrical.AC.Loads;
model SeriesConnection
  extends Districts.Electrical.AC.Loads.BaseClasses.GeneralizedOnePhaseModel;
  parameter Integer N(min=2) = 2 "Number of loads connected in series (min=2)";
  Districts.Electrical.AC.Interfaces.SinglePhasePlug seriesLoads[N] annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{80,-20},
            {120,20}})));
equation
  connect(seriesLoads[1].p[1], sPhasePlug.p[1]);
  for n in 1:N-1 loop
    connect(seriesLoads[n].n, seriesLoads[n+1].p[1]);
  end for;
  connect(seriesLoads[N].n, sPhasePlug.n);
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
          smooth=Smooth.None),
        Text(
          extent={{-80,10},{80,-10}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="series"),
        Line(
          points={{80,6},{92,6}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{80,12},{92,12}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{80,-12},{92,-12}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{86,-10},{86,-2}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dash)}),
                                    Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end SeriesConnection;
