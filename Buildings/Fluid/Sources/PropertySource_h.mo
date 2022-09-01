within Buildings.Fluid.Sources;
model PropertySource_h
  "Model for overriding fluid properties that flow through the component, using specific enthalpy input"
  // The parameter declaration is before 'extends',
  // since this affects the parameter order in the parameters window.
  parameter Boolean use_h_in= false
    "Set to true to get the specific enthalpy from the input connector"
    annotation(Evaluate=true, Dialog(group="Inputs"));

  extends Buildings.Fluid.Sources.BaseClasses.PartialPropertySource;

  Modelica.Blocks.Interfaces.RealInput h_in if use_h_in
    "Prescribed value for leaving specific enthalpy" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,120})));
equation
  connect(h_internal_a, h_in);
  connect(h_internal_b, h_in);
  if not (use_h_in) then
    connect(h_internal_a,h_in_b);
    connect(h_internal_b,h_in_a);
  end if;
annotation (defaultComponentName="proSou",
        Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          visible=use_h_in,
          extent={{-90,98},{12,58}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="h")}),
    Documentation(info="<html>
<p>
Model that changes the properties,
but not the mass flow rate,
of the fluid that passes through it.
</p>
<p>
If <code>allowFlowReversal=true</code>, then the properties are changed for both flow directions,
i.e., from <code>port_a</code> to <code>port_b</code> and
from <code>port_b</code> to <code>port_a</code>.
</p>
<h4>Typical use and important parameters</h4>
<p>
The fluid properties <code>h</code>, <code>Xi</code> and <code>C</code>
are only modified when the corresponding boolean parameter
<code>use_h_in</code>, <code>use_Xi_in</code> or <code>use_C_in</code>
is set to <code>true</code>.
</p>
<h4>Dynamics</h4>
<p>
This model has no dynamics.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 30, 2018, by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/881\">#881</a>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}})));
end PropertySource_h;
