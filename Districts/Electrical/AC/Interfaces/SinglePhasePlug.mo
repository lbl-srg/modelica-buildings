within Districts.Electrical.AC.Interfaces;
connector SinglePhasePlug "AC connector for single phase systems"
  extends Districts.Electrical.AC.Interfaces.Plug(final N=1);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                               graphics={
        Ellipse(
          extent={{-40,-20},{40,-100}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-40,98},{40,18}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-40,60},{40,-60}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Line(
          points={{-40,60},{40,60}},
          smooth=Smooth.None,
          color={215,215,215}),
        Ellipse(
          extent={{-10,70},{10,50}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,-60},{40,-60}},
          smooth=Smooth.None,
          color={215,215,215}),
        Ellipse(
          extent={{-10,-50},{10,-70}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end SinglePhasePlug;
