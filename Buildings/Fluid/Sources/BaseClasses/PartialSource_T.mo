within Buildings.Fluid.Sources.BaseClasses;
model PartialSource_T "Boundary with prescribed temperature"
  extends Buildings.Fluid.Sources.BaseClasses.PartialSource;
  parameter Boolean use_T_in= false
    "Get the temperature from the input connector"
    annotation(Evaluate=true, HideResult=true,Dialog(group="Conditional inputs"));
  parameter Medium.Temperature T = Medium.T_default
    "Fixed value of temperature"
    annotation (Dialog(enable = not use_T_in,group="Fixed inputs"));
  Modelica.Blocks.Interfaces.RealInput T_in(final unit="K",
                                            displayUnit="degC") if use_T_in
    "Prescribed boundary temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
protected
  Modelica.Blocks.Interfaces.RealInput T_in_internal(final unit="K",
                                                     displayUnit="degC")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput h_internal = Medium.specificEnthalpy(Medium.setState_pTX(p_in_internal, T_in_internal, X_in_internal));

equation
  connect(T_in, T_in_internal);
  if not use_T_in then
    T_in_internal = T;
  end if;
  for i in 1:nPorts loop
     ports[i].h_outflow  = h_internal;
  end for;
  connect(medium.h, h_internal);
  annotation (
    Documentation(info="<html>
<p>
Partial model that defines
<code>ports.h_outflow</code> using an optional input for
the temperature.
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
          visible=use_T_in,
          extent={{-162,34},{-60,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="T")}));
end PartialSource_T;
