within Buildings.Examples;
package DistrictReservoirNetworks
 extends Modelica.Icons.ExamplesPackage;

annotation (Documentation(info="<html>
<p>
Package with models that compare the performance of a
district heating and cooling system with bidirectional distribution network with
the performance of reservoir network.
There are three different reservoir networks, two having constant mass flow rate
in the distribution pipes, but differently sized pipe diameters, and
one with variable mass flow rate.
</p>
<h4>Implementation</h4>
<p>
The implementation is such that all examples use the same agents for the
borefield and the energy transfer station.
To ensure the correct mass flow rate direction at the connections between the
district loop and the agents, models that are called switching box are used
to redirect the mass flow rate.
</p>
<p>
To simplify the configuration of the parameters, many models such as for
the borefield, the pipes and the T-junctions are extended from the models in
<a href=\"modelica://Buildings.Fluid\">Buildings.Fluid</a>.
In these extensions, the parameters that are common to the examples
are set. This ensures that the same parameters are used for all variants.
</p>
</html>"));
end DistrictReservoirNetworks;
