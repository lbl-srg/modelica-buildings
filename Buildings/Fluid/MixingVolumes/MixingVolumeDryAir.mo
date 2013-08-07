within Buildings.Fluid.MixingVolumes;
model MixingVolumeDryAir
  "Mixing volume with heat port for latent heat exchange, to be used with dry air"
  extends BaseClasses.PartialMixingVolumeWaterPort(
    steBal(final sensibleOnly = true));

protected
  Modelica.Blocks.Sources.Constant masExc(final k=0)
    "Block to set mass exchange in volume"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.RealExpression heaInp(y=heatPort.Q_flow)
    "Block to set heat input into volume"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
equation
//  HWat_flow = 0;
// Assign output port
  X_w = 0;
  connect(heaInp.y, steBal.Q_flow) annotation (Line(
      points={{-59,90},{-34,90},{-34,18},{-22,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaInp.y, dynBal.Q_flow) annotation (Line(
      points={{-59,90},{26,90},{26,16},{38,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masExc.y, dynBal.mWat_flow) annotation (Line(
      points={{-59,70},{20,70},{20,12},{38,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masExc.y, steBal.mWat_flow) annotation (Line(
      points={{-59,70},{-40,70},{-40,14},{-22,14}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
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
July 30, 2013 by Michael Wetter:<br/>
Changed connector <code>mXi_flow[Medium.nXi]</code>
to a scalar input connector <code>mWat_flow</code>
in the conservation equation model.
The reason is that <code>mXi_flow</code> does not allow
to compute the other components in <code>mX_flow</code> and
therefore leads to an ambiguous use of the model.
By only requesting <code>mWat_flow</code>, the mass balance
and species balance can be implemented correctly.
</li>
<li>
April 18, 2013 by Michael Wetter:<br/>
Removed the use of the deprecated
<code>cardinality</code> function.
Therefore, all input signals must be connected.
</li>
<li>
February 7, 2012 by Michael Wetter:<br/>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
August 7, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MixingVolumeDryAir;
