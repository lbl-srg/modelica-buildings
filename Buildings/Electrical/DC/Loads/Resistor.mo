within Buildings.Electrical.DC.Loads;
model Resistor "Ideal linear electrical resistor"
  extends Buildings.Electrical.Interfaces.ResistiveLoad(
    redeclare package PhaseSystem = PhaseSystems.TwoConductor,
    redeclare Interfaces.Terminal_n terminal,
    final mode=Buildings.Electrical.Types.Load.FixedZ_steady_state,
    final P_nominal=V_nominal^2/max(R, sqrt(Modelica.Constants.small)));
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T = T_ref);
  parameter Modelica.Units.SI.Resistance R(start=1)
    "Resistance at temperature T_ref";
  parameter Modelica.Units.SI.Temperature T_ref=300.15 "Reference temperature";
  parameter Modelica.Units.SI.LinearTemperatureCoefficient alpha=0
    "Temperature coefficient of resistance (R_actual = R*(1 + alpha*(T_heatPort - T_ref))";
  Modelica.Units.SI.Resistance R_actual
    "Actual resistance = R*(1 + alpha*(T_heatPort - T_ref))";
equation
  assert((1 + alpha*(T_heatPort - T_ref)) >= Modelica.Constants.eps, "Temperature outside of scope of model");
  R_actual = R*(1 + alpha*(T_heatPort - T_ref));
  PhaseSystem.systemVoltage(v) = R_actual*PhaseSystem.systemCurrent(i);
  LossPower = PhaseSystem.activePower(v,i);
  sum(i) = 0;
  annotation (
    Documentation(info="<html>
<p>
Model of a linear DC resistor that can vary with respect to temperature.
</p>
<p>
The model implements the Ohm's law
</p>
<p align=\"center\" style=\"font-style:italic;\">
V = R(T) i.
</p>
<p>
The resistance <i>R(T)</i> varies depending on the temperature <i>T</i> as
</p>
<p align=\"center\" style=\"font-style:italic;\">
R(T) = R (1 + &alpha; (T - T<sub>ref</sub>)),
</p>
<p>
where the resistance <i>R</i> is the reference value of the resistance, <i>&alpha;</i> is the
linear temperature coefficient, and <i>T<sub>ref</sub></i> is the reference temperature.
The temperature <i>T</i> is the temperature of the heat port if <code>useHeatPort = true</code>.
</p>
</html>",
 revisions="<html>
<ul>
<li>November 2, 2024, by Michael Wetter:<br/>
Changed guarding against division by zero.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4032\">Buildings, #4032</a>.
</li>
<li>November 3, 2015, by Michael Wetter:<br/>
Set default value for <code>P_nominal</code> to avoid an error when translating
the model in Dymola's pedantic mode.
</li>
<li>May 14, 2015, by Marco Bonvini:<br/>
Changed parent class to <a href=\"modelica://Buildings.Electrical.Interfaces.ResistiveLoad\">
Buildings.Electrical.Interfaces.ResistiveLoad</a> in order
to help openmodelica parsing the model. This fixes issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/415\">#415</a>.
</li>
<li>
February 1, 2013, by Thierry S. Nouidui:<br/>
First implementation.
</li>
<li>
May 28, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
          Rectangle(
            extent={{-70,30},{70,-30}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Text(
            extent={{-144,-40},{142,-72}},
            textColor={0,0,0},
          textString="R=%R"),
          Line(
            visible=useHeatPort,
            points={{0,-100},{0,-30}},
            color={127,0,0},
            smooth=Smooth.None,
            pattern=LinePattern.Dot),
          Text(
            extent={{-152,87},{148,47}},
            textColor={0,0,0},
          textString="%name")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
          Line(points={{-96,0},{-70,0}}, color={0,0,255})}));
end Resistor;
