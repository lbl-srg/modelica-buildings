within Buildings.Fluid.FixedResistances;
model PlugFlowPipe
  "Pipe model using spatialDistribution for temperature delay"
  extends Buildings.Fluid.FixedResistances.BaseClasses.PlugFlowPipe(
    redeclare final Buildings.Fluid.FixedResistances.HydraulicDiameter res(
      final dh=dh,
      final from_dp=from_dp,
      final length=length,
      final roughness=roughness,
      final fac=fac,
      final ReC=ReC,
      final v_nominal=v_nominal,
      final homotopyInitialization=homotopyInitialization,
      final linearized=linearized,
    dp(nominal=fac*200*length)));

  annotation (
    Line(points={{70,20},{72,20},{72,0},{100,0}}, color={0,127,255}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,30},{100,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-100,50},{100,40}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,-40},{100,-50}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{0,90},{40,62},{20,62},{20,38},{-20,38},{-20,62},{-40,62},{0,
              90}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,30},{28,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,202,187}),
        Text(
          extent={{-102,-76},{98,-104}},
          textColor={0,0,0},
          textString="d = %dh"),
        Text(
          extent={{-100,-56},{100,-74}},
          textColor={0,0,0},
          textString="L = %length")}),
    Documentation(revisions="<html>
<ul>
<li>
October 05, 2021, by Baptiste Ravache:<br/>
Made model symmetrical and extends from
<a href=\"Buildings.Fluid.Interfaces.PartialTwoPortInterface\">
Buildings.Fluid.Interfaces.PartialTwoPortInterface</a>.
</li>
<li>
September 14, 2021, by Michael Wetter:<br/>
Made most instances protected and exposed main variables of interest.
</li>
<li>
July 9, 2021, by Baptiste Ravache:<br/>
Replaced the vectorized outlet port <code>ports_b</code> with
a single outlet port <code>port_b</code>.<br/>
Expanded the core pipe model that was previously a component.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1494\">IBPSA, #1494</a>.<br/>
This change is not backward compatible.<br/>
The previous classes definitions were moved to
<a href=\"modelica://Buildings.Obsolete.Fluid.FixedResistances.PlugFlowPipe\">
Buildings.Obsolete.Fluid.FixedResistances.PlugFlowPipe</a>.
<a href=\"modelica://Buildings.Obsolete.Fluid.FixedResistances.BaseClasses.PlugFlowCore\">
Buildings.Obsolete.Fluid.FixedResistances.BaseClasses.PlugFlowCore</a>.
</li>
</ul>
</html>", info="<html>
<p>
Pipe with heat loss using the time delay based heat losses and transport
of the fluid using a plug flow model, applicable for simulation of long
pipes such as in district heating and cooling systems.</p>
<p>
This model takes into account transport delay along the pipe length idealized
as a plug flow.
The model also includes thermal inertia of the pipe wall.
</p>
<h4>Implementation</h4>
<p>
The
<code>spatialDistribution</code> operator is used for the temperature wave propagation
through the length of the pipe. This operator is contained in
<a href=\"modelica://Buildings.Fluid.FixedResistances.BaseClasses.PlugFlow\">
Buildings.Fluid.FixedResistances.BaseClasses.PlugFlow</a>.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.FixedResistances.BaseClasses.PlugFlowHeatLoss\">
Buildings.Fluid.FixedResistances.BaseClasses.PlugFlowHeatLoss</a>
implements a heat loss in design direction, but leaves the enthalpy unchanged
in opposite flow direction. Therefore it is used in front of and behind the time delay.
</p>
<p>
The pressure drop is implemented using
<a href=\"modelica://Buildings.Fluid.FixedResistances.HydraulicDiameter\">
Buildings.Fluid.FixedResistances.HydraulicDiameter</a>.
</p>
<p>
The thermal capacity of the pipe wall is implemented as a mixing volume
of the fluid in the pipe, of which the thermal capacity is equal to that
of the pipe wall material.
In addition, this mixing volume allows the hydraulic separation of subsequent pipes.
<br/>
The mixing volume is either split between the inlet and outlet ports
(port_a and port_b) or lumped in at the outlet (port_b)
if <code>have_symmetry</code> is set to false.
This mixing volume can be removed from this model with the Boolean parameter
<code>have_pipCap</code>, in cases where the pipe wall heat capacity
is negligible and a state is not needed at the pipe outlet
(see the note below about numerical Jacobians).
</p>
<p>
Note that in order to model a branched network it is recommended to use
<a href=\"modelica://Buildings.Fluid.FixedResistances.Junction\">
Buildings.Fluid.FixedResistances.Junction</a> at each junction and to configure
that junction model with a state
(<code>energyDynamics &lt;&gt; Modelica.Fluid.Types.Dynamics.SteadyState</code>),
see for instance
<a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.PlugFlowAIT\">
Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.PlugFlowAIT</a>.
This will avoid the numerical Jacobian that is otherwise created when
the inlet ports of two instances of the plug flow model are connected together.
</p>
<h4>Assumptions</h4>
<ul>
<li>
Heat losses are for steady-state operation.
</li>
<li>
The axial heat diffusion in the fluid, the pipe wall and the ground are neglected.
</li>
<li>
The boundary temperature is uniform.
</li>
<li>
The thermal inertia of the pipe wall material is lumped on the side of the pipe
that is connected to <code>port_b</code>.
</li>
</ul>
<h4>References</h4>
<p>
Full details on the model implementation and experimental validation can be found
in:
</p>
<p>
van der Heijde, B., Fuchs, M., Ribas Tugores, C., Schweiger, G., Sartor, K.,
Basciotti, D., M&uuml;ller, D., Nytsch-Geusen, C., Wetter, M. and Helsen, L.
(2017).<br/>
Dynamic equation-based thermo-hydraulic pipe model for district heating and
cooling systems.<br/>
<i>Energy Conversion and Management</i>, vol. 151, p. 158-169.
<a href=\"https://doi.org/10.1016/j.enconman.2017.08.072\">doi:
10.1016/j.enconman.2017.08.072</a>.</p>
</html>"));
end PlugFlowPipe;
