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

  constant Boolean simplify_mWat_flow=true
    "Set to true to cause port_a.m_flow + port_b.m_flow = 0 even if mWat_flow is non-zero. Used only if Medium.nX > 1"
    annotation (HideResult=true);

  MassExchange masExc(
     redeclare final package Medium=Medium2) "Model for mass exchange"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Math.Gain gain(final k=-1) "Change sign" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={80,20})));
protected
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen(
    T(final quantity="ThermodynamicTemperature",
      final unit = "K", displayUnit = "degC", min=0))
    "Temperature sensor of metal"
    annotation (Placement(transformation(extent={{-60,-2},{-40,18}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaConVapAir
    "Heat conductor for latent heat flow rate, accounting for latent heat removed with vapor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,-40})));
  Modelica.Blocks.Math.Product pro
    "Product to compute the latent heat flow rate"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.RealExpression h_fg(final y=Buildings.Utilities.Psychrometrics.Constants.h_fg)
    "Enthalpy of vaporization"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  HeatTransfer.Sources.PrescribedHeatFlow heaConVapCoi
    "Heat conductor for latent heat flow rate, accounting for latent heat deposited with vapor on the coil"
    annotation (Placement(transformation(extent={{70,30},{50,50}})));
equation
  connect(temSen.T, masExc.TSur) annotation (Line(points={{-39,8},{-12,8}},
                                        color={0,0,127}));
  connect(vol2.X_w, masExc.XInf) annotation (Line(points={{-10,-64},{-24,-64},{
          -24,0},{-12,0}},     color={0,0,127}));
  connect(Gc_2, masExc.Gc) annotation (Line(
      points={{40,-100},{40,-20},{-20,-20},{-20,-8},{-12,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.port, con1.solid) annotation (Line(
      points={{-60,8},{-66,8},{-66,60},{-50,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(masExc.mWat_flow, pro.u2) annotation (Line(points={{11,0},{26,0},{26,
          -6},{38,-6}},    color={0,0,127}));
  connect(pro.u1, h_fg.y)
    annotation (Line(points={{38,6},{30,6},{30,20},{11,20}},
                                               color={0,0,127}));
  connect(heaConVapAir.port, con2.fluid) annotation (Line(points={{50,-40},{-30,
          -40}},                     color={191,0,0}));
  connect(masExc.mWat_flow, vol2.mWat_flow) annotation (Line(points={{11,0},{26,
          0},{26,-52},{14,-52}},      color={0,0,127}));
  connect(pro.y, heaConVapAir.Q_flow) annotation (Line(points={{61,0},{80,0},{
          80,-40},{70,-40}},color={0,0,127}));
  connect(heaConVapCoi.Q_flow, gain.y)
    annotation (Line(points={{70,40},{80,40},{80,31}}, color={0,0,127}));
  connect(pro.y, gain.u)
    annotation (Line(points={{61,0},{80,0},{80,8}}, color={0,0,127}));
  connect(heaConVapCoi.port, con2.solid) annotation (Line(points={{50,40},{-66,
          40},{-66,-40},{-50,-40}}, color={191,0,0}));
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
computed by the instance <code>masExc</code>, and deposits it on the coil.
Hence, the latent heat is treated such that it transfers to the coil surface.
The latent heat is removed from the air stream using heat flow source <code>heaConVapAir</code>
and deposited on the coil surface using heat flow source <code>heaConVapCoi</code>.
</p>
<p>
Note that the driving potential for latent heat transfer is the temperature of the instance <code>mas</code>.
This is an approximation as it neglects the thermal resistance of the water film that builds up on the coil.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 5, 2022, by Antoine Gautier:<br/>
Restored the addition of heat to <code>mas.T</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3065\">#3065</a>.
</li>
<li>
May 26, 2022, by Michael Wetter:<br/>
Removed addition of heat to <code>mas.T</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3027\">#3027</a>.
</li>
<li>
March 11, 2021, by Michael Wetter:<br/>
Changed constant <code>simplify_mWat_flow</code> from protected to public because it is assigned by
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</a>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2387\">#2387</a>.
</li>
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
