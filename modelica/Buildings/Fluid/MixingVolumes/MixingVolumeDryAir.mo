within Buildings.Fluid.MixingVolumes;
model MixingVolumeDryAir
  "Mixing volume with heat port for latent heat exchange, to be used with dry air"
  extends BaseClasses.PartialMixingVolumeWaterPort(
    steBal(final sensibleOnly = true));

protected
  Modelica.Blocks.Sources.Constant
    masExc[Medium.nXi](k=zeros(Medium.nXi)) if
       Medium.nXi > 0 "Block to set mass exchange in volume"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.RealExpression heaInp(y=heatPort.Q_flow)
    "Block to set heat input into volume"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
equation
  // Set connector variables if they are unconnected
  if cardinality(mWat_flow) == 0 then
    mWat_flow = 0;
  end if;
  if cardinality(TWat) == 0 then
    TWat = Medium.T_default;
  end if;
  HWat_flow = 0;
  mXi_flow  = zeros(Medium.nXi);
// Assign output port
  X_w = 0;
  connect(heaInp.y, steBal.Q_flow) annotation (Line(
      points={{-59,90},{-34,90},{-34,18},{-22,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masExc.y, steBal.mXi_flow) annotation (Line(
      points={{-59,70},{-40,70},{-40,14},{-22,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaInp.y, dynBal.Q_flow) annotation (Line(
      points={{-59,90},{26,90},{26,16},{38,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masExc.y, dynBal.mXi_flow) annotation (Line(
      points={{-59,70},{20,70},{20,12},{38,12}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
                       Icon(graphics),
defaultComponentName="vol",
Documentation(info="<html>
Model for an ideally mixed fluid volume and the ability 
to store mass and energy. The volume is fixed, 
and sensible heat can be exchanged.
<p>
This model has the same ports as
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir\">
Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir</a>.
However, there is no mass exchange with the medium other than through the port
<code>ports</code>.
</p>
<p>
For media that do provide water as a species, use the model
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir\">
Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir</a> to add
or subtract moisture using a signal that is connected to the port
<code>mWat_flow</code> and <code>TWat</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 7, 2012 by Michael Wetter:<br>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
August 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end MixingVolumeDryAir;
