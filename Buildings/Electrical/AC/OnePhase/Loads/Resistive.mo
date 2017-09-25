within Buildings.Electrical.AC.OnePhase.Loads;
model Resistive "Model of a resistive load"
  extends Buildings.Electrical.Interfaces.ResistiveLoad(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal,
    V_nominal(start = 110));
equation

  if linearized then
    i[1] = -homotopy(actual=  v[1]*P/V_nominal^2, simplified=  v[1]*Modelica.Constants.eps*1e3);
    i[2] = -homotopy(actual=  v[2]*P/V_nominal^2, simplified=  v[2]*Modelica.Constants.eps*1e3);
  else
    if initMode == Buildings.Electrical.Types.InitMode.zero_current then
      i[1] = -homotopy(actual= v[1]*P/(v[1]^2 + v[2]^2),  simplified= 0.0);
      i[2] = -homotopy(actual= v[2]*P/(v[1]^2 + v[2]^2),  simplified= 0.0);
    else
      i[1] = -homotopy(actual= v[1]*P/(v[1]^2 + v[2]^2),
                       simplified= v[1]*P/V_nominal^2);
      i[2] = -homotopy(actual= v[2]*P/(v[1]^2 + v[2]^2),
                       simplified= v[2]*P/V_nominal^2);
    end if;
  end if;
  annotation (
    defaultComponentName="loa",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
          Rectangle(
            extent={{-80,40},{80,-40}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
          origin={0,3.55271e-15},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{12,1.46953e-15}},
                                       color={0,0,0},
          origin={-80,0},
          rotation=180),
        Text(
          extent={{-120,80},{120,40}},
          lineColor={0,0,0},
          textString="%name")}),
          Documentation(info="<html>
<p>
Model of a resistive load. It may be used to model a load that has
a power factor of one.
</p>
<p>
The model computes the complex power vector as
<p align=\"center\" style=\"font-style:italic;\">
S = P + jQ = V &sdot; i<sup>*</sup>
</p>
<p>
where <i>V</i> is the voltage phasor and <i>i<sup>*</sup></i> is the complex
conjugate of the current phasor.
</p>

<p>
The load model takes as input the power consumed by the inductive load and
the power factor <i>pf=cos(&phi;)</i>. The power
can be either fixed using the parameter <code>P_nominal</code>, or
it is possible to specify a variable power using the inputs <code>y</code> or
<code>Pow</code>. The different modes can be selected with the parameter
<code>mode</code>, see <a href=\"modelica://Buildings.Electrical.Interfaces.Load\">
Buildings.Electrical.Interfaces.Load</a> for more information.
</p>

<p>
The equations of the model can be rewritten as
</p>
<p align=\"center\" style=\"font-style:italic;\">
i<sub>1</sub> = (P V<sub>1</sub> + Q V<sub>2</sub>)/(V<sub>1</sub><sup>2</sup> + V<sub>2</sub><sup>2</sup>),
</p>
<p align=\"center\" style=\"font-style:italic;\">
i<sub>2</sub> = (P V<sub>2</sub> - Q V<sub>1</sub>)/(V<sub>1</sub><sup>2</sup> + V<sub>2</sub><sup>2</sup>),
</p>

<p>
where <i>i<sub>1</sub></i>, <i>i<sub>2</sub></i>, <i>V<sub>1</sub></i>, and <i>V<sub>2</sub></i>
are the real and imaginary parts of the current and voltage phasors.
</p>

<p>
Since the model represents a load with a power factor of one, the complex
power is <i>Q = 0</i>. This leads to the following equations where
there are nonlinear equations that relate the current to the voltage
</p>

<p align=\"center\" style=\"font-style:italic;\">
i<sub>1</sub> = P V<sub>1</sub>/(V<sub>1</sub><sup>2</sup> + V<sub>2</sub><sup>2</sup>)
</p>
<p align=\"center\" style=\"font-style:italic;\">
i<sub>2</sub> = P V<sub>2</sub>/(V<sub>1</sub><sup>2</sup> + V<sub>2</sub><sup>2</sup>)
</p>

<p>
The non-linearity is due to the fact that the load consumes the power specified by the variable <i>P</i>,
irrespectively of the voltage of the load. The figure below shows the relationship
between the real part of the current phasor and the real and imaginary voltages of the load.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/OnePhase/Loads/NonlinearLoad_labels.png\"/>
</p>

<p>
When multiple loads are connected in a grid through cables that cause voltage drops,
the dimension of the system of nonlinear equations increases linearly with the number of loads.
This nonlinear system of equations introduces challenges during the initialization,
as Newton solvers may diverge if initialized far from a solution, as well during the simulation.
In this situation, the model can be parameterized to use a linear approximation
as discussed in the next section.
</p>

<h4>Linearized model</h4>
<p>
Given the constraints and the two-dimensional nature of the problem, it is difficult to
find a linearized version of the AC load model. A solution could be to divide the voltage
domain into sectors, and for each sector compute the best linear approximation.
However, the selection of the proper approximation depending on the value of the
voltage can generate events that increase the simulation time. For these reasons, the
linearized model assumes a voltage that is equal to the nominal value
</p>
<p align=\"center\" style=\"font-style:italic;\">
i<sub>1</sub> = P V<sub>1</sub>/V<sub>RMS</sub><sup>2</sup>
</p>
<p align=\"center\" style=\"font-style:italic;\">
i<sub>2</sub> = P V<sub>2</sub>/V<sub>RMS</sub><sup>2</sup>
</p>
<p>
where <i>V<sub>RMS</sub></i> is the Root Mean Square voltage of the AC system.
Even though this linearized version of the load model introduces an approximation
error in the current, it satisfies the constraints related to the ratio of the
active and reactive powers.
</p>
<p>
The image below show the linearized function
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/OnePhase/Loads/LinearLoad_labels.png\"/>
</p>

<h4>Initialization</h4>
<p>
The initialization problem can be simplified using the homotopy operator. The homotopy operator
uses two different types of equations to compute the value of a variable: the actual one
 and a simplified one. The actual equation is the one used during the normal operation.
During initialization, the simplified equation is first solved and then slowly replaced
with the actual equation to compute the initial values for the nonlinear system of
equations. The load model uses the homotopy operator, with the linearized model being used
as the simplified equation. This numerical expedient has proven useful when simulating models
with more than ten connected loads.
</p>
<p>
The load model has a parameter <code>initMode</code> that can be used to select
the assumption to use during the initialization phase by the homotopy operator.
The choices are between a null current or the linearized model.
</p>

</html>", revisions="<html>
<ul>
<li>May 14, 2015, by Marco Bonvini:<br/>
Changed parent class to <a href=\"modelica://Buildings.Electrical.Interfaces.ResistiveLoad\">
Buildings.Electrical.Interfaces.ResistiveLoad</a> in order
to help openmodelica parsing the model. This fixes issue
<a href=https://github.com/lbl-srg/modelica-buildings/issues/415>#415</a>.
</li>
<li>September 4, 2014, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>August 5, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>June 17, 2014, by Marco Bonvini:<br/>
Added parameter <code>initMode</code> that can be used to
select the assumption to be used during initialization phase
by the homotopy operator.
</li>
<li>
January 2, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Resistive;
