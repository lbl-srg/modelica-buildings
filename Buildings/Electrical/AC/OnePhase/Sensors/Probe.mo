within Buildings.Electrical.AC.OnePhase.Sensors;
model Probe "Model of a probe that measures RMS voltage and angle"
  extends Icons.GeneralizedProbe;
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=120) = 120
    "Nominal voltage (V_nominal >= 0)";
  parameter Boolean PerUnit = true "This flag display voltage in p.u.";
  Interfaces.Terminal_n term "Electrical connector" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-90})));
  Modelica.Blocks.Interfaces.RealOutput V(unit="1") "Voltage in per unit" annotation (Placement(
        transformation(extent={{60,20},{80,40}}), iconTransformation(extent={{60,
            20},{80,40}})));
  Modelica.Blocks.Interfaces.RealOutput theta(unit="deg") "Angle" annotation (Placement(
        transformation(extent={{60,-40},{80,-20}}), iconTransformation(extent={{60,
            -40},{80,-20}})));
equation
  theta = (180.0/Modelica.Constants.pi)*Buildings.Electrical.PhaseSystems.OnePhase.phase(term.v);
  if PerUnit then
    V = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(term.v)/V_nominal;
  else
    V = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(term.v);
  end if;
  term.i = zeros(Buildings.Electrical.PhaseSystems.OnePhase.n);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{40,60},{100,40}},
          lineColor={0,120,120},
          pattern=LinePattern.Dash,
          fillColor={0,120,120},
          fillPattern=FillPattern.Solid,
          textString="V"), Text(
          extent={{18,-40},{140,-60}},
          lineColor={0,120,120},
          pattern=LinePattern.Dash,
          fillColor={0,120,120},
          fillPattern=FillPattern.Solid,
          textString="theta")}),    Documentation(info="<html>
<p>
This model represents a probe that measures the RMS voltage and the angle
of the voltage phasor (in degrees) at a given point.
</p>
<p>
Given a reference voltage the model computes also the voltage in per unit.
</p>
</html>", revisions="<html>
<ul>
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
