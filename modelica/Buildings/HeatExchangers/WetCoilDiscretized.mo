model WetCoilDiscretized "Coil with condensation" 
  extends DryCoilDiscretized(final allowCondensation=true,
  each hexReg(ele(redeclare each 
          Buildings.Fluids.MixingVolumes.MixingVolumeMoistAir vol_2)));
 annotation (
    Documentation(info="<html>
<p>
Model of a discretized coil with humidity condensation.
This model is identical to 
<a href=\"Modelica:Buildings.HeatExchangers.DryCoilDiscretized\">
Buildings.HeatExchangers.DryCoilDiscretized</a>
but in addition, the mass transfer from fluid 2 to the metal is computed.
The mass transfer is computed based using similarity laws between
heat and mass transfer, as implemented by the model
<a href=\"Modelica:Buildings.HeatExchangers.BaseClasses.MassExchange</a>
Buildings.HeatExchangers.BaseClasses.MassExchange</a>. See this model 
for details.
</p>
<p>
This model can only be used with medium models that
implement the function <tt>enthalpyOfLiquid</tt> and that contain
an integer variable <tt>Water</tt> whose value is the element number where
the water vapor is stored in the species concentration vector. Examples for
such media are
<a href=\"Modelica:Buildings.Media.PerfectGases.MoistAir\">
Buildings.Media.PerfectGases.MoistAir</a> and
<a href=\"Modelica:Modelica.Media.Air.MoistAir\">
Modelica.Media.Air.MoistAir</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 13, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end WetCoilDiscretized;
