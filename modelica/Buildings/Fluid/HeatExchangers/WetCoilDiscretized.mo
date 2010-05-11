within Buildings.Fluid.HeatExchangers;
model WetCoilDiscretized
  "Coil with discretization along the flow paths and humidity condensation"
  // When replacing the volume, the Medium is constrained so that the enthalpyOfLiquid
  // function is known. Otherwise, checkModel(...) will fail
  extends DryCoilDiscretized(final allowCondensation=true,
  each hexReg(ele(redeclare each
          Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol2(
          final use_HeatTransfer = true,
          medium(T(stateSelect=StateSelect.never))))));
 annotation (
    Documentation(info="<html>
<p>
Model of a discretized coil with humidity condensation.
This model is identical to 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilDiscretized\">
Buildings.Fluid.HeatExchangers.DryCoilDiscretized</a>
but in addition, the mass transfer from fluid 2 to the metal is computed.
The mass transfer is computed using a similarity law between
heat and mass transfer, as implemented by the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange\">
Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange</a>. 
See this model for details.
</p>
<p>
This model can only be used with medium models that
implement the function <tt>enthalpyOfLiquid</tt> and that contain
an integer variable <tt>Water</tt> whose value is the element number where
the water vapor is stored in the species concentration vector. Examples for
such media are
<a href=\"modelica://Buildings.Media.PerfectGases.MoistAir\">
Buildings.Media.PerfectGases.MoistAir</a> and
<a href=\"Modelica:Modelica.Media.Air.MoistAir\">
Modelica.Media.Air.MoistAir</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 10, 2008 by Michael Wetter:<br>
Added values for <tt>stateSelect</tt> attributes.
</li>
<li>
August 13, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

end WetCoilDiscretized;
