within Buildings.Electrical.DC.Loads;
model Conductor "Model of a generic DC load"
    extends Buildings.Electrical.Interfaces.ResistiveLoad(
     redeclare package PhaseSystem = PhaseSystems.TwoConductor,
     redeclare Interfaces.Terminal_n terminal);
protected
    Modelica.SIunits.Voltage absDV
    "Absolute value of the voltage difference between the two conductors (used by the linearized model)";
equation

  absDV = abs(terminal.v[1]-terminal.v[2]);

  if linearized then

    // Linearized version of the model
    if absDV <= (8/9)*V_nominal then
      terminal.i[1] + P*(2/(0.8*V_nominal) - (terminal.v[1]-terminal.v[2])/(0.8*V_nominal)^2) = 0;
    elseif absDV >= (12/11)*V_nominal then
      terminal.i[1] + P*(2/(1.2*V_nominal) - (terminal.v[1]-terminal.v[2])/(1.2*V_nominal)^2) = 0;
    else
      terminal.i[1] + P*(2/V_nominal - (terminal.v[1]-terminal.v[2])/V_nominal^2) = 0;
    end if;

  else
    // Full nonlinear version of the model
    // PhaseSystem.activePower(terminal.v, terminal.i) + P = 0;
    if initMode == Buildings.Electrical.Types.InitMode.zero_current then
      i[1] = - homotopy(actual= P/(v[1] - v[2]),  simplified= 0);
    else
      i[1] = - homotopy(actual= P/(v[1] - v[2]),  simplified= P*(2/V_nominal - (v[1]-v[2])/V_nominal^2));
    end if;

  end if;

  // Since the connector is a two conductor, the sum of the currents at the terminal
  // is null
  sum(i) = 0;
  annotation (
    Documentation(info="<html>
<p>
Model of a generic DC load. The load can be either constant or variable depending on the value of the
parameter <code>mode</code>.
See the model <a href=\"modelica://Buildings.Electrical.Interfaces.Load\">Buildings.Electrical.Interfaces.Load</a>
for more information.
</p>

<p>
The model computes the current drawn from the load as
</p>
<p align=\"center\" style=\"font-style:italic;\">
P = V i,
</p>
<p>
where <i>P</i> is the power, <i>V</i> is the voltage and <i>i</i> is the current.<br/>
If the component consumes power, then <i>P &lt; 0</i>.
If it feeds power into the electrical grid, then <i>P &gt; 0</i>.
</p>

<h4>Linearization</h4>
<p>
Consider the simple DC circuit shown in the figure below
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/DC/Loads/simpleLoad.png\"/>
</p>
<p>
where <i>V<sub>S</sub></i> is a constant voltage source, and <i>R</i> is the line resistance.
The load has a voltage <i>V</i> across its electrical pins and a current <i>i</i> is flowing through it.
If the power consumption drawn by the load is prescribed by the variable <i>P<sub>LOAD</sub></i>,
 the equation that describes the circuit is
</p>
<p align=\"center\" style=\"font-style:italic;\">
V<sub>S</sub> - R i - P<sub>LOAD</sub>/i = 0
</p>
<p>
The unknown variable <i>i</i> appears in a nonlinear equation. This means that in order to compute the current
that is drawn by the load, a nonlinear equation has to be solved. If the number of loads increases (as typically
happens in real case examples) the number of nonlinear equations to be solved increases too, and the resulting system
of nonlinear equations can slow down the simulation. It is possible to avoid such a problem by introducing a linearized
model.
</p>

<p>
The first step to linearize the load model is to define its nominal voltage conditions <i>V<sub>nom</sub></i>,
around which the equations will be linearized.<br/>
The constitutive equation of the load can be linearized around the nominal voltage condition <i>V<sub>nom</sub></i> as
</p>

<p align=\"center\" style=\"font-style:italic;\">
i = P<sub>LOAD</sub>/V = P<sub>LOAD</sub>/V<sub>nom</sub> +
(V - V<sub>nom</sub>)[&part; (P<sub>LOAD</sub>/V)/ &part;V ]<sub>V = V<sub>nom</sub></sub>
+ &#8338;((V - V<sub>nom</sub>)<sup>2</sup>),
</p>

<p>
which leads to the linearized formulation
</p>

<p align=\"center\" style=\"font-style:italic;\">
i &#8771; P<sub>LOAD</sub> (2/V<sub>nom</sub> - V/V<sub>nom</sub><sup>2</sup>).
</p>

<p>
The linearized formulation approximates the load power consumption (or production),
with the approximation error being proportional to <i>(V - V<sub>nom</sub>)<sup>2</sup></i>.
A further approximation has been introduced to improve the
approximation of the linearized model even if the voltage is far from the nominal condition.
This piecewise linearized approximation instead of approximating the model just in the neighborhood of the nominal
voltage <i>V<sub>nom</sub></i> introduces two new points where the model is approximated.
The points are at <i>0.8 V<sub>nom</sub></i> and <i>1.2 V<sub>nom</sub></i>.
</p>

<table summary=\"equations\" border = \"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collape;\">
<tr><th>Equation</th><th>Condition</th></tr>
<tr>
<td>i &#8771; P<sub>LOAD</sub> (2/(0.8 V<sub>nom</sub>) - V/(0.8 V<sub>nom</sub><sup>2</sup>))</td>
<td>V &lt; 8/9&sdot; V<sub>nom</sub></td>
</tr>

<tr>
<td>i &#8771; P<sub>LOAD</sub> (2/(1.2  V<sub>nom</sub>) - V/(1.2 V<sub>nom</sub><sup>2</sup>))</td>
<td>V &ge; 12/11&sdot; V<sub>nom</sub></td>
</tr>

<tr>
<td>i &#8771; P<sub>LOAD</sub> (2/V<sub>nom</sub> - V/V<sub>nom</sub><sup>2</sup>)</td>
<td>Otherwise</td>
</tr>
</table>

</html>", revisions="<html>
<ul>
<li>May 14, 2015, by Marco Bonvini:<br/>
Changed parent class to <a href=\"modelica://Buildings.Electrical.Interfaces.ResistiveLoad\">
Buildings.Electrical.Interfaces.ResistiveLoad</a> in order
to help openmodelica parsing the model. This fixes issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/415\">#415</a>.
</li>
<li>June 17, 2014, by Marco Bonvini:<br/>
Adde parameter <code>initMode</code> that can be used to
select the assumption to be used during initialization phase
by the homotopy operator.
</li>
<li>
February 1, 2013, by Thierry S. Nouidui:<br/>
First implementation.
</li>
<li>
January 2014, by Marco Bonvini:<br/>
Added linearized version of the model.
</li>
<li>
May 28, 2014, by Marco Bonvini:<br/>
Added and revised documentation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
          Rectangle(
            extent={{-70,30},{70,-30}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,255}),
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Text(
            extent={{-152,87},{148,47}},
            lineColor={0,0,0},
          textString="%name"),
          Text(
            extent={{-144,-38},{142,-70}},
            lineColor={0,0,0},
            textString="G=%G")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
          Line(points={{-96,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{96,0}}, color={0,0,255}),
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255})}));
end Conductor;
