within Buildings.Electrical.DC.Lines;
model Line "Model of a DC electrical line"
  extends Buildings.Electrical.Transmission.BaseClasses.PartialLine(
    redeclare package PhaseSystem_p = PhaseSystems.TwoConductor,
    redeclare package PhaseSystem_n = PhaseSystems.TwoConductor,
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p,
    final modelMode=Types.Load.FixedZ_steady_state,
    commercialCable = Buildings.Electrical.Transmission.Functions.selectCable_low(P_nominal, V_nominal));

  TwoPortRCLine lineRC(
    final useHeatPort=true,
    final R=R,
    final V_nominal=V_nominal,
    final T_ref=T_ref,
    final M=M,
    final C=C,
    final use_C=use_C)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));
equation
  connect(terminal_n, lineRC.terminal_n) annotation (Line(
      points={{-100,0},{-10,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(lineRC.terminal_p, terminal_p) annotation (Line(
      points={{10,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cableTemp.port, lineRC.heatPort) annotation (Line(
      points={{-40,22},{0,22},{0,10}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation ( Icon(graphics={
        Ellipse(
          extent={{-70,10},{-50,-10}},
          lineColor={0,0,0},
          fillColor={96,107,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,10},{60,-10}},
          fillColor={96,107,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{50,10},{70,-10}},
          lineColor={0,0,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-70,0},{-90,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-60,10},{60,10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-60,-10},{60,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{96,0},{60,0}},
          color={0,0,0},
          smooth=Smooth.None)}),
    Documentation(revisions="<html>
<ul>
<li>
March 19, 2015, by Michael Wetter:<br/>
Removed redeclaration of phase system in <code>Terminal_n</code> and
<code>Terminal_p</code> as it is already declared to the be the same
phase system, and it is not declared to be replaceable.
This avoids a translation error in OpenModelica.
</li>
<li>
June 2, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
October 31, 2013, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model represents a DC cable. The model is based on
<a href=\"modelica://Buildings.Electrical.DC.Lines.TwoPortRCLine\">
Buildings.Electrical.DC.Lines.TwoPortRCLine</a>
and provides functionalities to parametrize the values of <i>R</i> and <i>C</i> either
using commercial cables or using default values.
</p>
</html>"));
end Line;
