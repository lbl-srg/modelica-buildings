within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial model PartialDXCoolingCoil "Partial model for DX cooling coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil(
    final activate_CooCoi=true,
    redeclare Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DXCooling
      dxCoo(redeclare package Medium = Medium),
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol(
      prescribedHeatFlowRate=true));

protected
  Modelica.Blocks.Sources.RealExpression X(final y=XIn[i_x])
    "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-56,24},{-36,44}})));
  Modelica.Blocks.Sources.RealExpression h(final y=hIn)
    "Inlet air specific enthalpy"
    annotation (Placement(transformation(extent={{-56,10},{-36,30}})));
  Modelica.Blocks.Sources.RealExpression p(final y=port_a.p)
    "Inlet air pressure"
    annotation (Placement(transformation(extent={{-90,2},{-70,22}})));
equation
  connect(p.y,dxCoo.p)  annotation (Line(points={{-69,12},{-58,12},{-58,49.6},{
          -21,49.6}}, color={0,0,127}));
  connect(dxCoo.SHR, pwr.SHR) annotation (Line(points={{1,52},{12,52},{12,64},{
          18,64}}, color={0,0,127}));
  connect(dxCoo.mWat_flow, eva.mWat_flow) annotation (Line(
      points={{1,44},{8,44},{8,8},{-22,8},{-22,-70},{-10,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pwr.QLat_flow, QLat_flow) annotation (Line(points={{41,64},{80,64},{80,
          50},{110,50}}, color={0,0,127}));
  connect(X.y,dxCoo.XEvaIn)  annotation (Line(points={{-35,34},{-32,34},{-32,47},
          {-21,47}}, color={0,0,127}));
  connect(h.y,dxCoo.hEvaIn)  annotation (Line(points={{-35,20},{-28,20},{-28,
          44.3},{-21,44.3}}, color={0,0,127}));
  connect(T.y,dxCoo.TEvaIn)  annotation (Line(points={{-69,28},{-62,28},{-62,52},
          {-21,52}}, color={0,0,127}));
  connect(vol.X_w, eva.XEvaOut) annotation (Line(
      points={{13,-6},{40,-6},{40,-90},{-4,-90},{-4,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut,dxCoo.TConIn)  annotation (Line(points={{-110,30},{-92,30},{-92,
          57},{-21,57}}, color={0,0,127}));
  connect(eva.mTotWat_flow, vol.mWat_flow) annotation (Line(points={{13,-70},{22,
          -70},{22,-42},{-20,-42},{-20,-18},{-11,-18}}, color={0,0,127}));
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
end PartialDXCoolingCoil;
