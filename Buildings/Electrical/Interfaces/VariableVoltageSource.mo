within Buildings.Electrical.Interfaces;
model VariableVoltageSource
  "Partial model of a generic variable voltage source."
  extends Buildings.Electrical.Interfaces.Source;
  parameter Boolean use_V_in = true "If true, the voltage is an input";
  parameter Modelica.Units.SI.Voltage V=1 "Value of constant voltage"
    annotation (Dialog(enable=not use_V_in));
  Modelica.Blocks.Interfaces.RealInput V_in(unit="V", min=0, start = 1)
    if use_V_in "Input voltage"
                    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-100,60}),
                         iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-100,60})));
protected
  Modelica.Blocks.Interfaces.RealInput  V_in_internal(unit="V")
    "Hidden value of the input voltage for the conditional connector";
equation

  // Connection between the conditional and inner connector
  connect(V_in,V_in_internal);

  // If the voltage is fixed, inner connector value is equal to parameter V
  if use_V_in == false then
    V_in_internal = V;
  end if;
  annotation ( Documentation(revisions="<html>
<ul>
<li>
October 14, 2014, by Marco Bonvini:<br/>
Model included into the Buildings library, added documentation.
</li>
</ul>
</html>", info="<html>
<p>
This model represents a generic variable voltage source. The model has a boolean
flag <code>use_V_in</code>, when this flag is equal to <code>true</code>
the voltage of the source is imposed by the input variable <code>V_in</code>.
When the flag is equal to <code>false</code> the voltage source is equal to the parameter <code>V</code>.
</p>
<p>
In case the phase system adopted has <code>PhaseSystem.m &gt; 0</code> and
thus the connectors are over determined,
the source can be selected to serve as reference point.
The parameters <code>potentialReference</code> and <code>definiteReference</code> are used to define if the
source model should be selected as source for the reference angles or not.
More information about overdetermined connectors can be found
in <a href=\"#Olsson2008\">Olsson Et Al. (2008)</a>.
</p>

<h4>References</h4>
<p>
<a name=\"Olsson2008\"/>
Hans Olsson, Martin Otter, Sven Erik Mattson and Hilding Elmqvist.<br/>
<a href=\"http://elib-v3.dlr.de/55892/1/otter2008-modelica-balanced-models.pdf\">
Balanced Models in Modelica 3.0 for Increased Model Quality</a>.<br/>
Proc. of the 7th Modelica Conference, Bielefeld, Germany, March 2008.
</p>
</html>"));
end VariableVoltageSource;
