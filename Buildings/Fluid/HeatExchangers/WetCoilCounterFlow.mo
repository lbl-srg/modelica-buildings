within Buildings.Fluid.HeatExchangers;
model WetCoilCounterFlow
  "Counterflow coil with discretization along the flow paths and humidity condensation"
  extends Buildings.Fluid.HeatExchangers.DryCoilCounterFlow(
    redeclare replaceable package Medium2 =
      Modelica.Media.Interfaces.PartialCondensingGases,
    redeclare model HexElement =
      Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent(simplify_mWat_flow=simplify_mWat_flow));

  constant Boolean simplify_mWat_flow = true
    "Set to true to cause port_a.m_flow + port_b.m_flow = 0 even if mWat_flow is non-zero. Used only if Medium.nX > 1"
    annotation(HideResult=true);

  Modelica.SIunits.HeatFlowRate QSen2_flow = Q2_flow - QLat2_flow
    "Sensible heat input into air stream (negative if air is cooled)";

  Modelica.SIunits.HeatFlowRate QLat2_flow=
    Buildings.Utilities.Psychrometrics.Constants.h_fg * mWat_flow
    "Latent heat input into air (negative if air is dehumidified)";

  Real SHR(
    min=0,
    max=1,
    unit="1") = QSen2_flow /
      noEvent(if (Q2_flow > 1E-6 or Q2_flow < -1E-6) then Q2_flow else 1)
       "Sensible to total heat ratio";

  Modelica.SIunits.MassFlowRate mWat_flow = sum(ele[i].vol2.mWat_flow for i in 1:nEle)
    "Water flow rate";

 annotation (
defaultComponentName="cooCoi",
    Documentation(info="<html>
<p>
Model of a discretized coil with water vapor condensation.
The coil consists of two flow paths which are, at the design flow direction,
in opposite direction to model a counterflow heat exchanger.
The flow paths are discretized into <code>nEle</code> elements.
Each element is modeled by an instance of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent\">
Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent</a>.
Each element has a state variable for the metal.
</p>
<p>
The convective heat transfer coefficients can, for each fluid individually, be
computed as a function of the flow rate and/or the temperature,
or assigned to a constant. This computation is done using an instance of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil\">
Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil</a>.
</p>
<p>
In this model, the water (or liquid) flow path
needs to be connected to <code>port_a1</code> and <code>port_b1</code>, and
the air flow path needs to be connected to the other two ports.
</p>
<p>
The mass transfer from the fluid 2 to the metal is computed using a similarity law between
heat and mass transfer, as implemented by the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange\">
Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange</a>.
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
<p>
To model this coil for conditions without humidity condensation, use the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.DryCoilCounterFlow</a> instead of this model.
</p>
</html>", revisions="<html>
<ul>
<li>
March 12, 2021, by Michael Wetter:<br/>
Removed <code>final</code> declaration in redeclaration.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2392\">#2392</a>.
</li>
<li>
May 1, 2020, by Michael Wetter:<br/>
Added constant <code>simplify_mWat_flow</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1920\">#1920</a>.
</li>
<li>
October 19, 2018, by Kino:<br/>
Changed model to use a replaceable model as this allows translation in OpenModelica.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1258\">#1258</a>.
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
April 11, 2017, by Michael Wetter:<br/>
Changed computation of <code>QLat_flow</code> to be consistent with
how it is computed in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent\">
Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent</a>.<br/>
Moved variable assignments out of equation section to avoid mixing
textual and graphical modeling in equation section.
</li>
<li>
November 8, 2016, by Michael Wetter:<br/>
Removed wrong usage of <code>each</code> keyword.
</li>
<li>
July 29, 2016, by Michael Wetter:<br/>
Redeclared <code>Medium2</code> to be <code>Modelica.Media.Interfaces.PartialCondensingGases</code>
because it is used in <code>vol2</code> and because
the model calls <code>Medium2.enthalpyOfCondensingGas</code>,
which requires the medium to extend
from this subclass.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/547\">
issue 547</a>.
</li>
<li>
February 2, 2012, by Michael Wetter:<br/>
Corrected error in assignment of <code>dp2_nominal</code> in the base class.
The previous assignment caused a pressure drop in all except one element,
instead of the opposite. This caused too high a flow resistance
of the heat exchanger.
</li>
<li>
May 27, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,80},{40,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,80},{-36,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,80},{2,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,65},{103,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={Text(
          extent={{60,72},{84,58}},
          lineColor={0,0,255},
          textString="water-side"), Text(
          extent={{50,-32},{90,-38}},
          lineColor={0,0,255},
          textString="air-side")}));
end WetCoilCounterFlow;
