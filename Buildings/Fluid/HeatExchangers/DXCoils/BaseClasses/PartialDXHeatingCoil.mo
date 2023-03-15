within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial model PartialDXHeatingCoil "Partial model for DX heating coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil(
    final activate_CooCoi = false,
    redeclare Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil dxCoiOpe(
        redeclare package Medium = Medium),
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol);

equation
  connect(TOut, dxCoiOpe.TEvaIn) annotation (Line(points={{-110,30},{-92,30},{-92,
          52},{-21,52}}, color={0,0,127}));
  connect(T.y, dxCoiOpe.TConIn) annotation (Line(points={{-69,28},{-60,28},{-60,
          57},{-21,57}}, color={0,0,127}));
  annotation (
defaultComponentName="dxCoi",
Documentation(info="<html>
<p>
This partial model is the base class for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeed</a>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.MultiStage\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.MultiStage</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.VariableSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.VariableSpeed</a>.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">
Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide</a>
for an explanation of the model.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 19, 2017, by Michael Wetter:<br/>
Added missing <code>replaceable</code> to the medium declaration.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/810\">Buildings #810</a>.
</li>
<li>
April 12, 2017, by Michael Wetter:<br/>
Removed temperature connection that is no longer needed.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>.
</li>
<li>
February 27, 2017 by Yangyang Fu:<br/>
Added <code>redeclare</code> for the type of <code>cooCap</code> in <code>dxCoiOpe</code>.
</li>
<li>
May 6, 2015 by Michael Wetter:<br/>
Added <code>prescribedHeatFlowRate=true</code> for <code>vol</code>.
</li>
<li>
August 31, 2013, by Michael Wetter:<br/>
Updated model due to change in
<code>Buildings.Fluid.BaseClasses.IndexMassFraction</code>.
</li>
<li>
September 24, 2012 by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
September 4, 2012 by Michael Wetter:<br/>
Moved assignments to declaration section to avoid mixing graphical modeling with textual
modeling in <code>equation</code> section.
Redeclare medium model as <code>Modelica.Media.Interfaces.PartialCondensingGases</code>
to remove errors during model check.
Added output connectors for sensible and latent heat flow rate.
</li>
<li>
April 12, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"),
    Icon(graphics={Text(
          extent={{-138,64},{-80,46}},
          textColor={0,0,127},
          textString="TConIn"), Text(
          extent={{58,98},{102,78}},
          textColor={0,0,127},
          textString="P"),      Text(
          extent={{54,60},{98,40}},
          textColor={0,0,127},
          textString="QLat"),   Text(
          extent={{54,80},{98,60}},
          textColor={0,0,127},
          textString="QSen")}));
end PartialDXHeatingCoil;
