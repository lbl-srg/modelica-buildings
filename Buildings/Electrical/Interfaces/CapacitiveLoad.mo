within Buildings.Electrical.Interfaces;
partial model CapacitiveLoad "Partial model of a capacitive load"
  extends Load;
  parameter Boolean use_pf_in = false "If true, the power factor is defined by an input"
    annotation(Dialog(group="Modeling assumption"));
  parameter Real pf(min=0, max=1) = 0.8 "Power factor"
  annotation(Dialog(group="Nominal conditions"));
  Modelica.Blocks.Interfaces.RealInput pf_in(
    min=0,
    max=1,
    unit="1") if (use_pf_in) "Power factor"
                   annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60})));
protected
  function j = PhaseSystem.j "J operator that rotates of 90 degrees";
  Modelica.Blocks.Interfaces.RealInput pf_internal
    "Hidden value of the input load for the conditional connector";
  Modelica.Units.SI.ElectricCharge q[2](each stateSelect=StateSelect.prefer)
    "Electric charge";
  Modelica.Units.SI.Admittance[2] Y "Admittance";
  Modelica.Units.SI.AngularVelocity omega "Angular velocity";
  Modelica.Units.SI.Power Q=P*tan(-acos(pf_internal))
    "Reactive power (negative because capacitive load)";
equation
  connect(pf_in, pf_internal);

  if not use_pf_in then
    pf_internal = pf;
  end if;

  annotation (Documentation(revisions="<html>
<ul>
<li>
June 06, 2014, by Marco Bonvini:<br/>
Added power factor input <code>pf_in</code> and updated documentation.
</li>
<li>
May 15, 2014, by Marco Bonvini:<br/>
Created documentation.
</li>
<li>
October 31, 2013, by Marco Bonvini:<br/>
Model included into the Buildings library.
</li>
</ul>
</html>", info="<html>
<p>
This is a model of a generic capacitive load. This model is an extension of the base load model
<a href=\"modelica://Buildings.Electrical.Interfaces.Load\">Buildings.Electrical.Interfaces.Load</a>.
</p>
<p>
This model assumes a fixed power factor <code>pf</code> when the flag <code>use_pf_in = false</code>
otherwise it uses the power factor specified by the input <code>pf_in</code>.
</p>
<p>The power factor (either the input or the parameter) is used to compute the reactive power
<code>Q</code> given the active power <code>P</code>
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q = - P * tan(arccos(pf))
</p>
</html>"));
end CapacitiveLoad;
