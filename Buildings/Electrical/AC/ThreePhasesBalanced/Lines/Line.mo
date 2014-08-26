within Buildings.Electrical.AC.ThreePhasesBalanced.Lines;
model Line "Model of an electrical line"
  extends Buildings.Electrical.Transmission.BaseClasses.PartialLine(
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p,
    V_nominal = 480);
protected
  replaceable TwoPortRLC lineRLC(
    useHeatPort=true,
    R=R,
    L=L,
    mode = modelMode,
    M=M,
    C=C,
    T_ref=T_ref,
    V_nominal=V_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(lineRLC.terminal_n, terminal_n) annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(lineRLC.terminal_p, terminal_p) annotation (Line(
      points={{10,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(cableTemp.port, lineRLC.heatPort) annotation (Line(
      points={{-40,22},{-32,22},{-32,-16},{0,-16},{0,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
        Ellipse(
          extent={{-70,10},{-50,-10}},
          lineColor={0,0,0},
          fillColor={11,193,87},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,10},{60,-10}},
          fillColor={11,193,87},
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
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
This model represents a cable for three phases balanced AC systems. The model is based on 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Lines.TwoPortRLC\">
Buildings.Electrical.AC.ThreePhasesBalanced.Lines.TwoPortRLC</a>
and provides functionalities to parametrize the values of <i>R</i>, <i>L</i> and <i>C</i> either
using commercial cables or using default values.
</p>
<p>
See model
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Lines.Line\">
Buildings.Electrical.AC.OnePhase.Lines.Line</a> for more 
information.
</p>
</html>"));
end Line;
