within Buildings.HeatTransfer.Conduction;
model MultiLayer
  "Model for heat conductance through a solid with multiple material layers"
  extends Buildings.HeatTransfer.Conduction.BaseClasses.PartialConductor(
   final R=sum(layers.material[i].R for i in 1:size(layers.material, 1)));
  Modelica.SIunits.Temperature T[sum(nSta)](each nominal = 300)
    "Temperature at the states";
  Modelica.SIunits.HeatFlowRate Q_flow[sum(nSta)+nLay]
    "Heat flow rate from state i to i+1";
  extends Buildings.HeatTransfer.Conduction.BaseClasses.PartialConstruction;

protected
  Buildings.HeatTransfer.Conduction.SingleLayer[nLay] lay(
   each final A=A,
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
    for j in 1:nSta[i] loop
      T[sum(nSta[k] for k in 1:(i-1)) +j] = lay[i].T[j];
    end for;
    for j in 1:nSta[i]+1 loop
      Q_flow[sum(nSta[k] for k in 1:i-1)+(i-1)+j] = lay[i].Q_flow[j];
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
          extent={{-90,2},{92,-4}},
          lineColor={0,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-36,12},{-34,12},{-32,8},{-30,2},{-30,-2},{-32,-8},{-38,-12},
              {-42,-16},{-50,-18},{-54,-14},{-60,-8},{-62,2},{-60,8},{-58,12},{
              -56,14},{-54,16},{-50,18},{-46,18},{-40,16},{-36,12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-54,-12},{-46,-14},{-40,-12},{-34,-10},{-38,-12},{-42,-16},{
              -50,-18},{-56,-16},{-60,-8},{-62,2},{-60,8},{-58,12},{-56,14},{-58,
              4},{-58,-4},{-54,-12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,50},{-68,-52}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{50,10},{52,10},{54,6},{56,0},{56,-4},{54,-10},{48,-14},{44,-18},
              {36,-20},{32,-16},{26,-10},{24,0},{26,6},{28,10},{30,12},{32,14},
              {36,16},{40,16},{46,14},{50,10}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{32,-14},{40,-16},{46,-14},{52,-12},{48,-14},{44,-18},{36,-20},
              {30,-18},{26,-10},{24,0},{26,6},{28,10},{30,12},{28,2},{28,-6},{
              32,-14}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,50},{-8,-52}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{4,50},{16,-52}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Forward),
        Rectangle(
          extent={{64,48},{76,-54}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Forward)}),
    defaultComponentName="heaCon",
    Documentation(info="<html>
<p>
This is a model of a heat conductor with multiple material layers and energy storage.
The construction has at least one material layer, and each layer has
at least one temperature node. The layers are modeled using an instance of
<a href=\"Buildings.HeatTransfer.Conduction.SingleLayer\">
Buildings.HeatTransfer.Conduction.SingleLayer</a>.
</p>
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
To obtain the surface temperature of the construction, use <code>port_a.T</code> (or <code>port_b.T</code>)
and not the variable <code>T[1]</code> because there is a thermal resistance between the surface
and the temperature state.
</p>
</html>", revisions="<html>
<ul>
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
