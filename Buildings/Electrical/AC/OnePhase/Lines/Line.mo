within Buildings.Electrical.AC.OnePhase.Lines;
model Line "Model of an electrical line"
  extends Buildings.Electrical.Transmission.BaseClasses.PartialLine(
    V_nominal(start = 110),
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal_n,
    redeclare replaceable Interfaces.Terminal_p terminal_p,
    commercialCable = Buildings.Electrical.Transmission.Functions.selectCable_low(P_nominal, V_nominal));
protected
  replaceable TwoPortRL line(
    R=R/3,
    L=L/3,
    mode=modelMode) constrainedby
    Buildings.Electrical.Transmission.BaseClasses.PartialTwoPortRLC(
      useHeatPort=true,
      M=M,
      T_ref=T_ref) "Model of the line"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(cableTemp.port, line.heatPort)       annotation (Line(
      points={{-40,22},{-28,22},{-28,-10},{4.44089e-16,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(line.terminal_n, terminal_n)       annotation (Line(
      points={{-10,4.44089e-16},{-48,4.44089e-16},{-48,0},{-100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_p, line.terminal_p)       annotation (Line(
      points={{100,0},{56,0},{56,4.44089e-16},{10,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));

  annotation (
defaultComponentName="line",
 Icon(graphics={
        Ellipse(
          extent={{-70,10},{-50,-10}},
          lineColor={0,0,0},
          fillColor={0,94,94},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,10},{60,-10}},
          fillColor={0,94,94},
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
    Documentation(
info="<html>
<p>
This model represents an AC single phase cable. The model is based on
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Lines.TwoPortRLC\">
Buildings.Electrical.AC.OnePhase.Lines.TwoPortRLC</a>
and provides functionalities to parametrize the values of <i>R</i>, <i>L</i> and <i>C</i>,
either using commercial cables or using default values.
</p>
</html>", revisions="<html>
<ul>
<li>
November 8, 2016, by Michael Wetter:<br/>
Added <code>replaceable</code> to terminal redeclaration as they are redeclared by
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Lines.Line\">
Buildings.Electrical.AC.ThreePhasesBalanced.Lines.Line</a>.
</li>
<li>
November 8, 2016, by Michael Wetter:<br/>
Corrected wrong assignment of parameter <code>mode</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/571\">#571</a>.
</li>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Moved here the default declaration of the parameter <code>commercialCable</code>.<br/>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">
<span style=\" font-family:'Courier New,courier';\">commercialCable = </span>
<span style=\" font-family:'Courier New,courier'; color:#ff0000;\"> Buildings.Electrical.Transmission.Functions.selectCable_low</span>
<span style=\" font-family:'Courier New,courier';\">(P_nominal, V_nominal)</span>
</p>
</li>
<li>
August 24, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end Line;
