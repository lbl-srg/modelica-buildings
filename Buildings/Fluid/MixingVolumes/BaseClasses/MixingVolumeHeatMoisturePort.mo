within Buildings.Fluid.MixingVolumes.BaseClasses;
model MixingVolumeHeatMoisturePort
  "Mixing volume with heat and moisture port and initialize_p not set to final"
  extends Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume(
  dynBal(
      final use_mWat_flow = true),
    steBal(
      final use_mWat_flow = true));

   Modelica.Blocks.Interfaces.RealInput mWat_flow(final quantity="MassFlowRate",
                                                 final unit = "kg/s")
    "Water flow rate added into the medium"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput X_w(final unit="kg/kg")
    "Species composition of medium"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));

    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort(
      T(start=T_start)) "Heat port for heat exchange with the control volume"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
protected
  parameter Real s[Medium.nXi] = {
  if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                            string2="Water",
                                            caseSensitive=false) then 1 else 0
                                            for i in 1:Medium.nXi}
    "Vector with zero everywhere except where species is";

  Modelica.Blocks.Sources.RealExpression XLiq(y=s*Xi)
    "Species composition of the medium"
    annotation (Placement(transformation(extent={{72,-52},{94,-28}})));

equation
  connect(mWat_flow, steBal.mWat_flow) annotation (Line(
      points={{-120,80},{-120,80},{4,80},{4,14},{18,14}},
      color={0,0,127}));
  connect(mWat_flow, dynBal.mWat_flow) annotation (Line(
      points={{-120,80},{-50,80},{52,80},{52,12},{58,12}},
      color={0,0,127}));
  connect(XLiq.y, X_w) annotation (Line(
      points={{95.1,-40},{120,-40}},
      color={0,0,127}));
  connect(heaFloSen.port_a, heatPort)
    annotation (Line(points={{-90,0},{-100,0}}, color={191,0,0}));
  annotation (
  defaultComonentName="vol",
  Documentation(info="<html>
<p>
Mixing volume with a heat port.
</p>
<p>
This model is identical to
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume\">
Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume</a>,
except that it has a heat and a moisture port.
</p>
<p>
Note that this model is typically only used to implement new component models that
have staggered volumes.
In contrast to
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir\">
Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir</a>, it does
not set <code>initialize_p</code> to <code>final</code> in order
for this model to be usable in staggered volumes which require one
pressure to be set to <code>initialize_p = not Medium.singleState</code>
and all others to <code>false</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 23, 2017, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1013\">Buildings, issue 1013</a>.
</li>
</ul>
</html>"));
end MixingVolumeHeatMoisturePort;
