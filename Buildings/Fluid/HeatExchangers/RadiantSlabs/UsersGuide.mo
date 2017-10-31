within Buildings.Fluid.HeatExchangers.RadiantSlabs;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<h4>Heat transfer through the slab</h4>
<p>
The figure below shows the thermal resistance network of the model for an
example in which the pipes are embedded in the concrete slab, and
the layers below the pipes are insulation and reinforced concrete.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/RadiantSlabs/resistances.png\"/>
</p>
<p>
The construction <code>con_a</code> computes transient heat conduction
between the surface heat port <code>surf_a</code> and the
plane that contains the pipes, with the heat port <code>con_a.port_a</code> connecting to <code>surf_a</code>.
Similarly, the construction <code>con_b</code> is between the plane
that contains the pipes and the surface heat port
<code>sur_b</code>, with the heat port <code>con_b.port_b</code> connecting to <code>surf_b</code>.
The temperature of the plane that contains the pipes is computes using a fictitious
resistance <code>RFic</code>, which is computed by
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.AverageResistance\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.AverageResistance</a>.
There is also a resistance for the pipe wall <code>RPip</code>
and a convective heat transfer coefficient between the fluid and the pipe inside wall.
The convective heat transfer coefficient is a function of the mass flow rate and is computed
in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.PipeToSlabConductance\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.PipeToSlabConductance</a>.
</p>

<h4>Material layers</h4>
<p>
The material layers are declared by the parameter <code>layers</code>, which is an instance of
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueConstructions\">
Buildings.HeatTransfer.Data.OpaqueConstructions</a>.
The first layer of this material is the one at the heat port <code>surf_a</code>, and the last layer
is at the heat port <code>surf_b</code>.
The parameter <code>iLayPip</code> must be set to the number of the interface in which the pipes
are located. For example, consider the following floor slab.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/RadiantSlabs/construction.png\"/>
</p>
Then, the construction definition is
<br/>
<pre>
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic layers(
        nLay=3,
        material={
          Buildings.HeatTransfer.Data.Solids.Generic(
            x=0.08,
            k=1.13,
            c=1000,
            d=1400,
            nSta=5),
          Buildings.HeatTransfer.Data.Solids.Generic(
            x=0.05,
            k=0.04,
            c=1400,
            d=10),
          Buildings.HeatTransfer.Data.Solids.Generic(
            x=0.2,
            k=1.8,
            c=1100,
            d=2400)}) \"Material definition for floor construction\";
</pre>
<p>
Note that we set <code>nSta=5</code> in the first material layer. In this example,
this material layer is the concrete layer in which the pipes are embedded. By setting
<code>nSta=5</code> the simulation is forced to be done with five state variables in this layer.
The default setting would have led to only one state variable in this layer.
</p>
<p>
Since the pipes are at the interface of the concrete and the insulation,
we set <code>iLayPip=1</code>.
</p>

<h4>Discretization along the flow path</h4>
<p>
If the parameter <code>heatTransfer=EpsilonNTU</code>, then the heat transfer between the fluid
and the fictitious layer temperature is computed using an <i>&epsilon;-NTU</i> model.
If <code>heatTransfer=FiniteDifference</code>, then the pipe and the slab is
discretized along the water flow direction and a finite difference model is used
to compute the heat transfer. The parameter <code>nSeg</code> determines
how many times the resistance network is instantiated along the flow path.
However, all instances connect to the same surface temperature heat ports
<code>surf_a</code> and <code>surf_b</code>.
</p>
<p>
The default value for is <code>nSeg=1</code> if <code>heatTransfer=EpsilonNTU</code>
and  <code>nSeg=5</code> if <code>heatTransfer=FiniteDifference</code>.
For a typical building simulation, we recommend to use the default settings of
<code>heatTransfer=EpsilonNTU</code> and <code>nSeg=1</code>, as these lead to
fastest computing time.
However, for feedback control design in which the outlet temperature of the slab
is used, one may want to use <code>heatTransfer=FiniteDifference</code> and <code>nSeg=5</code>.
This will cause the model to use <i>5</i> parallel segments in which heat is conducted between the
control volume of the pipe fluid and the surfaces of the slab.
While the heat flow rate at the surface does not change noticeably between these
two configurations, the dynamics of
the water outlet temperature from the slab is significantly different. The
figure below shows the water outlet temperature response to a step change in the
volume flow rate at <i>t=720</i> minutes. One can see that if
<code>heatTransfer=EpsilonNTU</code> and <code>nSeg=1</code>,
the response looks like a first order response (because <code>nSeg=1</code>),
while with <code>heatTransfer=FiniteDifference</code> and <code>nSeg=5</code>,
the response is higher order. This figure was generated using
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.StepResponseFiniteDifference\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.StepResponseFiniteDifference</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.StepResponseEpsilonNTU\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.StepResponseEpsilonNTU\\</a>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/RadiantSlabs/outletTemperatureComparison.png\"/>
</p>

<h4>Initialization</h4>
<p>
The initialization of the fluid in the pipes and of the slab temperature are
independent of each other.
</p>
<p>
To initialize the medium, the same mechanism is used as for any other fluid
volume, such as
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>. Specifically,
the parameters
<code>energyDynamics</code> and <code>massDynamics</code> on the
<code>Dynamics</code> tab are used.
Depending on the values of these parameters, the medium is initialized using the values
<code>p_start</code>,
<code>T_start</code>,
<code>X_start</code> and
<code>C_start</code>, provided that the medium model contains
species concentrations <code>X</code> and trace substances <code>C</code>.
</p>
<p>
To initialize the construction temperatures, the parameters
<code>steadyStateInitial</code>,
<code>T_a_start</code>,
<code>T_b_start</code> and
<code>T_c_start</code> are used.
By default, <code>T_c_start</code> is set to the temperature that leads to steady-state
heat transfer between the surfaces <code>surf_a</code> and <code>surf_b</code>, whose
temperatures are both set to
<code>T_a_start</code> and
<code>T_b_start</code>.
</p>
<p>
The parameter <code>pipe</code>, which is an instance of the record
<a href=\"modelica://Buildings.Fluid.Data.Pipes\">
Buildings.Fluid.Data.Pipes</a>,
defines the pipe material and geometry.
The parameter <code>disPip</code> declares the spacing between the pipes and
the parameter <code>length</code>, with default <code>length=A/disPip</code>
where <code>A</code> is the slab surface area,
declares the whole length of the pipe circuit.
</p>
<p>
The parameter <code>sysTyp</code> is used to select the equation that is used to compute
the average temperature in the plane of the pipes.
It needs to be set to the following values:
</p>
  <table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr>
      <th>sysTyp</th>
      <th>System type</th>
    </tr>
    <tr>
      <td>BaseClasses.Types.SystemType.Floor</td>
      <td>Radiant heating or cooling systems with pipes embedded in the concrete slab above the thermal insulation.</td>
    </tr>
    <tr>
      <td>BaseClasses.Types.SystemType.Ceiling_Wall_or_Capillary</td>
      <td>Radiant heating or cooling systems with pipes embedded in the concrete slab in the ceiling, or
          radiant wall systems. Radiant heating and cooling systems with capillary heat exchanger at the
          construction surface.</td>
    </tr>
  </table>
<h4>Limitations</h4>
<p>
The analogy with a three-resistance network and the corresponding equation for
<code>Rx</code> is based on a steady-state heat transfer analysis. Therefore, it is
only valid during steady-state.
For a fully dynamic model, a three-dimensional finite element method for the radiant slab would need to be implemented.
</p>
<h4>Implementation</h4>
<p>
To separate the material declaration <code>layers</code> into layers between the pipes
and heat port <code>surf_a</code>, and between the pipes and <code>surf_b</code>, the
vector <code>layers.material[nLay]</code> is partitioned into
<code>layers.material[1:iLayPip]</code> and <code>layers.material[iLayPip+1:nLay]</code>.
The respective partitions are then assigned to the models for heat conduction between the
plane with the pipes and the construction surfaces, <code>con_a</code> and <code>con_b</code>.
</p>
</html>"));
end UsersGuide;
