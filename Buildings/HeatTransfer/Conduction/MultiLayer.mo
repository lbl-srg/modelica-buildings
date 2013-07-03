within Buildings.HeatTransfer.Conduction;
model MultiLayer
  "Model for heat conductance through a solid with multiple material layers"
  extends Buildings.HeatTransfer.Conduction.BaseClasses.PartialConductor(
   final R=sum(lay[i].R for i in 1:nLay));
  Modelica.SIunits.Temperature T[sum(nSta)](each nominal = 300)
    "Temperature at the states";
  Modelica.SIunits.HeatFlowRate Q_flow[sum(nSta)+nLay]
    "Heat flow rate from state i to i+1";
  extends Buildings.HeatTransfer.Conduction.BaseClasses.PartialConstruction;

protected
  Buildings.HeatTransfer.Conduction.SingleLayer[nLay] lay(
   each final A=A,
   material = layers.material,
   T_a_start = _T_a_start,
   T_b_start = _T_b_start,
   each steadyStateInitial = steadyStateInitial) "Material layer"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

protected
  parameter Modelica.SIunits.Temperature _T_a_start[nLay]=
    { T_b_start+(T_a_start-T_b_start) * 1/R * sum(lay[k].R for k in i:nLay) for i in 1:nLay}
    "Initial temperature at port_a of respective layer, used if steadyStateInitial = false";
  parameter Modelica.SIunits.Temperature _T_b_start[nLay]=
    { T_a_start+(T_b_start-T_a_start) * 1/R * sum(lay[k].R for k in 1:i) for i in 1:nLay}
    "Initial temperature at port_b of respective layer, used if steadyStateInitial = false";
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

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(
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
</p>
<p>
To obtain the surface temperature of the construction, use <code>port_a.T</code> (or <code>port_b.T</code>)
and not the variable <code>T[1]</code> because there is a thermal resistance between the surface
and the temperature state.
</p>
</html>", revisions="<html>
<ul>
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
