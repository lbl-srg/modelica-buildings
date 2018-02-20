within Buildings.Fluid.Sources.BaseClasses;
model PartialSource_h "Boundary with prescribed enthalpy"
  extends Buildings.Fluid.Sources.BaseClasses.PartialSource;
  parameter Boolean use_h_in= false
    "Get the specific enthalpy from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));
  parameter Medium.SpecificEnthalpy h = Medium.h_default
    "Fixed value of specific enthalpy"
    annotation (Dialog(enable = not use_h_in, group="Fixed inputs"));
  Modelica.Blocks.Interfaces.RealInput h_in(final unit="J/kg") if use_h_in
    "Prescribed boundary specific enthalpy"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
protected
  Modelica.Blocks.Interfaces.RealInput h_in_internal(final unit="J/kg")
    "Needed to connect to conditional connector";

equation
  connect(h_in, h_in_internal);
  if not use_h_in then
    h_in_internal = h;
  end if;
  for i in 1:nPorts loop
     ports[i].h_outflow  = h_in_internal;
  end for;
  connect(medium.h, h_in_internal);
  annotation (
    Documentation(info="<html>
<p>
Partial model that defines
<code>ports.h_outflow</code> using an optional input for
the specific enthalpy.
Otherwise the parameter value is used.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 2nd, 2018 by Filip Jorissen<br/>
Initial version for refactoring inputs of sources.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>.
</li>
</ul>
</html>"), Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Text(
          visible=use_h_in,
          extent={{-162,34},{-60,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="h")}));
end PartialSource_h;
