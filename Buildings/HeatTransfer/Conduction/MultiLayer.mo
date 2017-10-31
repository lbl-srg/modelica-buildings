within Buildings.HeatTransfer.Conduction;
model MultiLayer
  "Model for heat conductance through a solid with multiple material layers"
  extends Buildings.HeatTransfer.Conduction.BaseClasses.PartialConductor(
   final R=sum(lay[i].R for i in 1:nLay));
  Modelica.SIunits.Temperature T[sum(layers.nSta)](
    each nominal = 300) "Temperature at the states";
  Modelica.SIunits.HeatFlowRate Q_flow[sum(layers.nSta)+nLay]
    "Heat flow rate from state i to i+1";
  extends Buildings.HeatTransfer.Conduction.BaseClasses.PartialConstruction;

  parameter Boolean stateAtSurface_a=true
    "=true, a state will be at the surface a"
    annotation (Dialog(tab="Dynamics"),
                Evaluate=true);
  parameter Boolean stateAtSurface_b=true
    "=true, a state will be at the surface b"
    annotation (Dialog(tab="Dynamics"),
                Evaluate=true);

protected
  Buildings.HeatTransfer.Conduction.SingleLayer[nLay] lay(
   final nSta2={layers.nSta[i] for i in 1:nLay},
   each final A=A,
   final stateAtSurface_a = {if i == 1 then stateAtSurface_a else false for i in 1:nLay},
   final stateAtSurface_b = {if i == nLay then stateAtSurface_b else false for i in 1:nLay},
   material = {layers.material[i] for i in 1:size(layers.material, 1)},
   T_a_start = { T_b_start+(T_a_start-T_b_start) * 1/R *
    sum(layers.material[k].R for k in i:size(layers.material, 1)) for i in 1:size(layers.material, 1)},
   T_b_start = { T_a_start+(T_b_start-T_a_start) * 1/R *
    sum(layers.material[k].R for k in 1:i) for i in 1:size(layers.material, 1)},
   each steadyStateInitial = steadyStateInitial) "Material layer"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

equation
  // This section assigns the temperatures and heat flow rates of the layer models to
  // an array that makes plotting the results easier.
  for i in 1:nLay loop
    for j in 1:layers.nSta[i] loop
      T[sum(layers.nSta[k] for k in 1:(i-1)) +j] = lay[i].T[j];
    end for;
    for j in 1:layers.nSta[i]+1 loop
      Q_flow[sum(layers.nSta[k] for k in 1:i-1)+(i-1)+j] = lay[i].Q_flow[j];
    end for;
  end for;
  connect(port_a, lay[1].port_a) annotation (Line(
      points={{-100,5.55112e-16},{-60,5.55112e-16},{-60,6.10623e-16},{-20,
          6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  for i in 1:nLay-1 loop
  connect(lay[i].port_b, lay[i+1].port_a) annotation (Line(
      points={{5.55112e-16,6.10623e-16},{20,6.10623e-16},{20,-20},{-40,-20},{
            -40,6.10623e-16},{-20,6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  end for;
  connect(lay[nLay].port_b, port_b) annotation (Line(
      points={{5.55112e-16,6.10623e-16},{49,6.10623e-16},{49,5.55112e-16},{100,
          5.55112e-16}},
      color={191,0,0},
      smooth=Smooth.None));

  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
   Rectangle(
    extent={{0,80},{80,-80}},       fillColor={175,175,175},
   fillPattern=FillPattern.Solid,    lineColor={175,175,175}),
   Rectangle(
    extent={{-80,80},{0,-80}},      fillColor={215,215,215},
   fillPattern=FillPattern.Solid,    lineColor={175,175,175}),
   Line(points={{-92,0},{90,0}},      color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),
   Line(points={{-18,-40},{-32,-40}},     color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),
   Line(points={{-12,-32},{-38,-32}},     color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),            Line(points={{-25,0},{-25,-32}},
   color = {0, 0, 0}, thickness = 0.5, smooth = Smooth.None),
   Line(points={{32,-40},{18,-40}},       color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),
   Line(points={{38,-32},{12,-32}},       color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),            Line(points={{25,0},{25,-32}},
   color = {0, 0, 0}, thickness = 0.5, smooth = Smooth.None),
                                     Rectangle(extent={{-60,6},{-40,-6}},
   lineColor = {0, 0, 0}, lineThickness =  0.5, fillColor = {255, 255, 255},
   fillPattern = FillPattern.Solid), Rectangle(extent={{-10,6},{10,-6}},
   lineColor = {0, 0, 0}, lineThickness =  0.5, fillColor = {255, 255, 255},
   fillPattern = FillPattern.Solid), Rectangle(extent={{40,6},{60,-6}},
   lineColor = {0, 0, 0}, lineThickness =  0.5, fillColor = {255, 255, 255},
   fillPattern = FillPattern.Solid),
   Line(points={{86,-40},{72,-40}},       color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None,
   visible=stateAtSurface_b),
   Line(points={{92,-32},{66,-32}},       color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None,
   visible=stateAtSurface_b),            Line(points={{79,0},{79,-32}},
   color = {0, 0, 0}, thickness = 0.5, smooth = Smooth.None,
   visible=stateAtSurface_b),
   Line(points={{-79,0},{-79,-32}},
   color = {0, 0, 0}, thickness = 0.5, smooth = Smooth.None,
   visible=stateAtSurface_a),
   Line(points={{-66,-32},{-92,-32}},     color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None,
   visible=stateAtSurface_a),
   Line(points={{-72,-40},{-86,-40}},     color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None,
   visible=stateAtSurface_a)}),
    defaultComponentName="heaCon",
    Documentation(info="<html>
<p>
This is a model of a heat conductor with multiple material layers and energy storage.
The construction has at least one material layer, and each layer has
at least one temperature node. The layers are modeled using an instance of
<a href=\"Buildings.HeatTransfer.Conduction.SingleLayer\">
Buildings.HeatTransfer.Conduction.SingleLayer</a>.
See this model for an explanation of the equations that are applied to
each material layer.
</p>
<h4>Important parameters</h4>
<p>
The construction material is defined by a record of the package
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueConstructions\">
Buildings.HeatTransfer.Data.OpaqueConstructions</a>.
This record allows specifying materials that store energy, and material
that are a thermal conductor only with no heat storage.
To assign the material properties to this model, do the following:
</p>
<ol>
<li>
Create an instance of a record of
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueConstructions\">
Buildings.HeatTransfer.Data.OpaqueConstructions</a>, for example
by dragging the record into the schematic model editor.
</li>
<li>
Make sure the instance has the attribute <code>parameter</code>, which may not be
assigned automatically when you drop the model in a graphical editor. For
example, an instanciation may look like
<pre>
 parameter Data.OpaqueConstructions.Insulation100Concrete200 layers
   \"Material layers of construction\"
   annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
</pre>
</li>
<li>
Assign the instance of the material to the instance of the heat transfer
model as shown in
<a href=\"modelica://Buildings.HeatTransfer.Examples.ConductorMultiLayer\">
Buildings.HeatTransfer.Examples.ConductorMultiLayer</a>.
</li>
</ol>
<p>
The parameters <code>stateAtSurface_a</code> and
<code>stateAtSurface_b</code>
determine whether there is a state variable at these surfaces,
as described above.
Note that if <code>stateAtSurface_a = true</code>,
then there is temperature state on the surface a with prescribed
value, as determined by the differential equation of the heat conduction.
Hence, in this situation, it is not possible to
connect a temperature boundary condition such as
<a href=\"modelica://Buildings.HeatTransfer.Sources.FixedTemperature\">
Buildings.HeatTransfer.Sources.FixedTemperature</a> as this would
yield to specifying the same temperature twice.
To avoid this, either set <code>stateAtSurface_a = false</code>,
or place a thermal resistance
between the boundary condition and the surface of this model.
The same applies for surface b.
See the examples in
<a href=\"modelica://Buildings.HeatTransfer.Examples\">
Buildings.HeatTransfer.Examples</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 16, 2017, by Michael Wetter:<br/>
Corrected wrong result variable <code>R</code> and <code>UA</code>.
These variables are only used for reporting.
All other calculations were not affected by this error.
</li>
<li>
January 05, 2017, by Thierry S. Nouidui:<br/>
Removed parameter <code>nSta2</code>.
</li>
<li>
November 17, 2016, by Thierry S. Nouidui:<br/>
Added parameter <code>nSta2</code> to avoid translation error
in Dymola 2107. This is a work-around for a bug in Dymola
which will be addressed in future releases.
</li>
<li>
October 29, 2016, by Michael Wetter:<br/>
Added option to place a state at the surface.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/565\">issue 565</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set the start value of <code>T</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
<li>
March 18, 2015, by Michael Wetter:<br/>
Replaced <code>nLay</code> in the <code>sum()</code> of the parameter assignment
with <code>size(layers.material, 1)</code> to avoid incorrect results in OpenModelica.
See <a href=\"https://github.com/lbl-srg/modelica-buildings/commit/4578a3d3b80e760cc83d705963f3b17e41c1e7da#diff-9628c0eecd08caed8b30f1f993de7501L12\">github note</a>.
</li>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed assignment of <code>nLay</code> to avoid a translation error
in OpenModelica.
</li>
<li>
October 15, 2014, by Michael Wetter:<br/>
Changed assignment of <code>R</code> to be in the <code>extends</code> statement
to avoid a division by zero in OpenModelica.
</li>
<li>
September 9, 2014, by Michael Wetter:<br/>
Reverted change from March 1 2013 as this causes an error during model check
in Dymola 2015 FD01 beta1.
</li>
<li>
August 12, 2014, by Michael Wetter:<br/>
Reformulated the protected elements and the model instantiation to avoid
a warning in the OpenModelica parser.
</li>
<li>
March 1, 2013, by Michael Wetter:<br/>
Removed <code>initial equation</code> section and assigned the protected parameters
<code>_T_a_start</code> and <code>_T_b_start</code> directly to avoid a warning during
translation.
</li>
<li>
March 6 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MultiLayer;
