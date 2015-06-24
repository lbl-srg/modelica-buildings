within Buildings.Fluid.HeatExchangers;
model WetCoilDiscretized
  "Coil with discretization along the flow paths and humidity condensation"
  // When replacing the volume, the Medium is constrained so that the enthalpyOfLiquid
  // function is known. Otherwise, checkModel(...) will fail
  extends DryCoilDiscretized(
    each hexReg(redeclare final
        Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent ele[nPipPar, nPipSeg]),
    temSen_1(m_flow_nominal=m1_flow_nominal),
    temSen_2(m_flow_nominal=m2_flow_nominal));
 annotation (
defaultComponentName="cooCoi",
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
implement the function <code>enthalpyOfLiquid</code> and that contain
an integer variable <code>Water</code> whose value is the element number where
the water vapor is stored in the species concentration vector. Examples for
such media are
<a href=\"modelica://Buildings.Media.Air\">
Buildings.Media.Air</a> and
<a href=\"modelica://Modelica.Media.Air.MoistAir\">
Modelica.Media.Air.MoistAir</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 29, 2014, by Michael Wetter:<br/>
Removed parameter <code>dl</code> which is no longer needed.
</li>
<li>
December 13, 2013, by Michael Wetter:<br/>
Corrected wrong connection
<code>connect(hexReg[nReg].port_b1, pipMan_b.port_b)</code>
to
<code>connect(hexReg[nReg].port_a1, pipMan_b.port_b)</code>
in the base class
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilDiscretized\">
Buildings.Fluid.HeatExchangers.DryCoilDiscretized</a>.
This closes issue
<a href=\"modelica://https://github.com/lbl-srg/modelica-buildings/issues/194\">
https://github.com/lbl-srg/modelica-buildings/issues/194</a>,
which caused the last register to have no liquid flow.
</li>
<li>
September 10, 2008 by Michael Wetter:<br/>
Added values for <code>stateSelect</code> attributes.
</li>
<li>
August 13, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end WetCoilDiscretized;
