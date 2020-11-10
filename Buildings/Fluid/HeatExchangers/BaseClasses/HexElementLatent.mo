within Buildings.Fluid.HeatExchangers.BaseClasses;
model HexElementLatent "Element of a heat exchanger with humidity condensation of fluid 2"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialHexElement(
   redeclare final Buildings.Fluid.MixingVolumes.BaseClasses.MixingVolumeHeatPort vol1(
     final energyDynamics=energyDynamics,
     final massDynamics=energyDynamics,
     final initialize_p=initialize_p1,
     prescribedHeatFlowRate=false),
   redeclare final Buildings.Fluid.MixingVolumes.BaseClasses.MixingVolumeHeatMoisturePort vol2(
     final energyDynamics=energyDynamics,
     final massDynamics=energyDynamics,
     final initialize_p=initialize_p2,
     final simplify_mWat_flow=simplify_mWat_flow,
     prescribedHeatFlowRate=false));

  MassExchange masExc(
     redeclare final package Medium=Medium2) "Model for mass exchange"
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
protected
  constant Boolean simplify_mWat_flow = true
    "Set to true to cause port_a.m_flow + port_b.m_flow = 0 even if mWat_flow is non-zero. Used only if Medium.nX > 1";
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen(
    T(final quantity="ThermodynamicTemperature",
      final unit = "K", displayUnit = "degC", min=0))
    "Temperature sensor of metal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaConVapAir
    "Heat conductor for latent heat flow rate, accounting for latent heat removed with vapor"
    annotation (Placement(transformation(extent={{0,-30},{-20,-10}})));
  Modelica.Blocks.Math.Product pro
    "Product to compute the latent heat flow rate"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.RealExpression h_fg(final y=Buildings.Utilities.Psychrometrics.Constants.h_fg)
    "Enthalpy of vaporization"
    annotation (Placement(transformation(extent={{90,-4},{70,16}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaConVapCoi
    "Heat conductor for latent heat flow rate, accounting for latent heat deposited with vapor on the coil"
    annotation (Placement(transformation(extent={{0,10},{-20,30}})));
  Modelica.Blocks.Math.Gain gain(final k=-1)
    annotation (Placement(transformation(extent={{30,10},{10,30}})));
equation
  connect(temSen.T, masExc.TSur) annotation (Line(points={{-40,0},{20,0},{20,
          -22},{48,-22}},               color={0,0,127}));
  connect(masExc.mWat_flow, vol2.mWat_flow) annotation (Line(points={{71,-30},{
          80,-30},{80,-44},{44,-44},{44,-52},{14,-52}},
                                       color={0,0,127}));
  connect(vol2.X_w, masExc.XInf) annotation (Line(points={{-10,-64},{-20,-64},{
          -20,-44},{30,-44},{30,-30},{48,-30}},
                               color={0,0,127}));
  connect(Gc_2, masExc.Gc) annotation (Line(
      points={{40,-100},{40,-38},{48,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.port, con1.solid) annotation (Line(
      points={{-60,0},{-66,0},{-66,60},{-50,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaConVapAir.Q_flow, pro.y) annotation (Line(points={{0,-20},{0,-20},{
          36,-20},{36,0},{39,0}}, color={0,0,127}));
  connect(masExc.mWat_flow, pro.u2) annotation (Line(points={{71,-30},{80,-30},
          {80,-6},{62,-6}},color={0,0,127}));
  connect(pro.u1, h_fg.y)
    annotation (Line(points={{62,6},{66,6},{69,6}},
                                               color={0,0,127}));
  connect(heaConVapAir.port, con2.fluid) annotation (Line(points={{-20,-20},{-24,
          -20},{-24,-40},{-30,-40}}, color={191,0,0}));
  connect(heaConVapCoi.port, con2.solid) annotation (Line(points={{-20,20},{-66,
          20},{-66,0},{-66,-40},{-50,-40}}, color={191,0,0}));
  connect(gain.y, heaConVapCoi.Q_flow)
    annotation (Line(points={{9,20},{6,20},{0,20}}, color={0,0,127}));
  connect(pro.y, gain.u) annotation (Line(points={{39,0},{36,0},{36,0},{36,20},{
          32,20}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
Element of a heat exchanger with humidity condensation of fluid 2 and
with dynamics of the fluids and the solid.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.PartialHexElement\">
Buildings.Fluid.HeatExchangers.BaseClasses.PartialHexElement</a>
for a description of the physics of the sensible heat exchange.
For the latent heat exchange, this model removes water vapor from the air stream, as
computed by the instance <code>masExc</code>. This effectively moves water vapor molecules
out of the air, and deposits them on the coil. Hence, the latent heat that is carried
by these water vapor molecules is removed from the air stream, and added to the coil
surface. This is done using the heat flow sources <code>heaConVapAir</code> and
<code>heaConVapWat</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 1, 2020, by Michael Wetter:<br/>
Added constant <code>simplify_mWat_flow</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1920\">#1920</a>.
</li>
<li>
April 14, 2017, by David Blum:<br/>
Added heat of condensation to coil surface heat balance and removed it from the air stream.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/711\">Buildings #711</a>.
</li>
<li>
April 12, 2017, by Michael Wetter:<br/>
Removed temperature that is no longer needed.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>.
</li>
<li>
June 18, 2014, by Michael Wetter:<br/>
Added initialization for <code>mas</code> to avoid a warning during translation.
</li>
<li>
September 11, 2013, by Michael Latentter:<br/>
First implementation.
</li>
</ul>
</html>"),    Icon(graphics={
        Polygon(
          points={{-56,-52},{-58,-58},{-60,-66},{-58,-74},{-54,-76},{-44,-76},{-38,
              -70},{-40,-62},{-44,-50},{-50,-38},{-56,-52}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-26,-34},{-28,-40},{-30,-48},{-28,-56},{-24,-58},{-14,-58},{-8,
              -52},{-10,-44},{-14,-32},{-20,-20},{-26,-34}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,-50},{6,-56},{4,-64},{6,-72},{10,-74},{20,-74},{26,-68},{24,
              -60},{20,-48},{14,-36},{8,-50}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{44,-24},{42,-30},{40,-38},{42,-46},{46,-48},{56,-48},{62,-42},
              {60,-34},{56,-22},{50,-10},{44,-24}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end HexElementLatent;
