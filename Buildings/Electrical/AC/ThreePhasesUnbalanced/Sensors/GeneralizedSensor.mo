within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors;
model GeneralizedSensor
  "Sensor for power, voltage and current (3 wire system, no neutral cable)"

  Interfaces.Terminal_n terminal_n "Electrical connector side N"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.Terminal_p terminal_p "Electrical connector side P"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput V[3](each final quantity="ElectricPotential",
                                          each final unit="V") "Voltage"           annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={10,-40}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-90})));
  Modelica.Blocks.Interfaces.RealOutput I[3](each final quantity="ElectricCurrent",
                                          each final unit="A") "Current"           annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-40}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-90})));
  Modelica.Blocks.Interfaces.RealOutput S[3, Buildings.Electrical.PhaseSystems.OnePhase.n](
                                          each final quantity="Power",
                                          each final unit="W") "Phase powers"             annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,-40}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,-90})));
equation

  for i in 1:3 loop
    V[i]   = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(terminal_n.phase[i].v);
    I[i]   = Buildings.Electrical.PhaseSystems.OnePhase.systemCurrent(terminal_n.phase[i].i);
    S[i,:] = Buildings.Electrical.PhaseSystems.OnePhase.phasePowers_vi(v=terminal_n.phase[i].v, i=terminal_n.phase[i].i);
  end for;

  connect(terminal_n, terminal_p) annotation (Line(
      points={{-100,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (defaultComponentName="sen",
 Icon(graphics={
        Rectangle(
          extent={{-70,28},{70,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-92,0},{-70,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-120,-42},{0,-82}},
          textColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="S"),
        Polygon(
          points={{-0.48,33.6},{18,28},{18,59.2},{-0.48,33.6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-37.6,15.7},{-54,22}},     color={0,0,0}),
        Line(points={{-22.9,34.8},{-32,50}},     color={0,0,0}),
        Line(points={{0,60},{0,42}}, color={0,0,0}),
        Line(points={{22.9,34.8},{32,50}},     color={0,0,0}),
        Line(points={{37.6,15.7},{54,24}},     color={0,0,0}),
        Line(points={{0,2},{9.02,30.6}}, color={0,0,0}),
        Ellipse(
          extent={{-5,7},{5,-3}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{70,0},{92,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-60,-42},{60,-82}},
          textColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="V"),
        Text(
          extent={{0,-40},{120,-80}},
          textColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="I"),
        Text(
          extent={{-120,100},{120,60}},
          textColor={0,0,0},
          textString="%name")}),
    Documentation(info="<html>
<p>
Ideal sensor that measures power, voltage and current in a three-phase unbalanced system
without a neutral cable.
The two components of the power <i>S</i> are the active and reactive power for each phase.
</p>
</html>", revisions="<html>
<ul>
<li>
November 8, 2016, by Michael Wetter:<br/>
Corrected wrong access to phase system.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/570\">#570</a>.
</li>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end GeneralizedSensor;
