within Buildings.Fluid.HeatExchangers;
model WetCoilDiscretized
  "Coil with discretization along the flow paths and humidity condensation"
  // When replacing the volume, the Medium is constrained so that the enthalpyOfLiquid
  // function is known. Otherwise, checkModel(...) will fail
  extends DryCoilDiscretized(
    redeclare replaceable package Medium2 =
      Modelica.Media.Interfaces.PartialCondensingGases,
    hexReg(
      redeclare final Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent ele[nPipPar, nPipSeg]),
    temSen_1(m_flow_nominal=m1_flow_nominal),
    temSen_2(m_flow_nominal=m2_flow_nominal));

  Modelica.Units.SI.HeatFlowRate QSen2_flow=Q2_flow - QLat2_flow
    "Sensible heat input into air stream (negative if air is cooled)";

  Modelica.Units.SI.HeatFlowRate QLat2_flow=Buildings.Utilities.Psychrometrics.Constants.h_fg
      *mWat_flow "Latent heat input into air (negative if air is dehumidified)";

  Real SHR(
    min=0,
    max=1,
    unit="1") = QSen2_flow /
      noEvent(if (Q2_flow > 1E-6 or Q2_flow < -1E-6) then Q2_flow else 1)
       "Sensible to total heat ratio";

  Modelica.Units.SI.MassFlowRate mWat_flow=sum(hexReg[:].ele[:, :].vol2.mWat_flow)
    "Water flow rate";

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
July 5, 2022, by Antoine Gautier:<br/>
Restored the addition of heat to <code>mas.T</code> in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent\">
Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent</a>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3065\">#3065</a>.
</li>
<li>
May 26, 2022, by Michael Wetter:<br/>
Removed addition of heat to <code>mas.T</code> in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent\">
Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent</a>
to correct latent heat exchange calculation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3027\">#3027</a>.
</li>
<li>
January 12, 2019, by Michael Wetter:<br/>
Corrected wrong use of <code>each</code>.
</li>
<li>
April 14, 2017, by David Blum:<br/>
Added heat of condensation to coil surface heat balance
and removed it from the air stream.
This gives higher coil surface temperature and avoids
overestimating the latent heat ratio that was
observed in the previous implementation.
The code change was in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent\">
Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent</a>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/711\">#711</a>.
</li>
<li>
April 12, 2017, by Michael Wetter:<br/>
Added new variables <code>QSen2_flow</code>, <code>QLat2_flow</code> and <code>SHR</code>.
</li>
<li>
July 29, 2016, by Michael Wetter:<br/>
Redeclared <code>Medium2</code> to be <code>Modelica.Media.Interfaces.PartialCondensingGases</code>
because it is used in <code>vol2</code>, which requires the medium to extend
from this subclass.<br/>
See also
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/547\">
issue 547</a>.
</li>
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
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/194\">
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
