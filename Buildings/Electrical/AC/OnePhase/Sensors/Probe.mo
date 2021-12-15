within Buildings.Electrical.AC.OnePhase.Sensors;
model Probe "Model of a probe that measures RMS voltage and angle"
  extends Icons.GeneralizedProbe;
  parameter Modelica.Units.SI.Voltage V_nominal(min=0, start=110)
    "Nominal voltage (V_nominal >= 0)";
  parameter Boolean perUnit = true "If true, display voltage in p.u.";
  replaceable Interfaces.Terminal_n term "Electrical connector" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-90})));
  Modelica.Blocks.Interfaces.RealOutput V(unit=if perUnit then "1" else "V")
    "Voltage phasor magnitude"                                                                          annotation (Placement(
        transformation(extent={{60,20},{80,40}}), iconTransformation(extent={{60,
            20},{80,40}})));
  Modelica.Blocks.Interfaces.RealOutput theta(unit="rad", displayUnit="deg")
    "Voltage phasor angle"
                         annotation (Placement(
        transformation(extent={{60,-40},{80,-20}}), iconTransformation(extent={{60,
            -40},{80,-20}})));
equation
  theta = Buildings.Electrical.PhaseSystems.OnePhase.phase(term.v);
  if perUnit then
    V = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(term.v)/V_nominal;
  else
    V = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(term.v);
  end if;
  term.i = zeros(Buildings.Electrical.PhaseSystems.OnePhase.n);
  annotation (
  defaultComponentName="sen",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{40,60},{100,40}},
          textColor={0,0,0},
          pattern=LinePattern.Dash,
          fillColor={0,120,120},
          fillPattern=FillPattern.Solid,
          textString="V"), Text(
          extent={{18,-40},{140,-60}},
          textColor={0,0,0},
          pattern=LinePattern.Dash,
          fillColor={0,120,120},
          fillPattern=FillPattern.Solid,
          textString="theta")}),    Documentation(info="<html>
<p>
This model represents a probe that measures the RMS voltage and the angle
of the voltage phasor at a given point.
</p>
<p>
Optionally, given a reference voltage, the model can compute the voltage in per unit.
</p>
</html>", revisions="<html>
<ul>
<li>
March 30, 2015, by Michael Wetter:<br/>
Made <code>term</code> replaceable. This was detected
by the OpenModelica regression tests.
</li>
<li>September 4, 2014, by Michael Wetter:<br/>
Revised model.
</li>
<li>
August 5, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end Probe;
