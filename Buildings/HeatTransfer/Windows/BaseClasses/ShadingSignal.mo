within Buildings.HeatTransfer.Windows.BaseClasses;
block ShadingSignal
  "Converts the shading signal to be strictly bigger than 0 and smaller than 1"
  extends Modelica.Blocks.Interfaces.SO;
  parameter Boolean haveShade "Set to true if a shade is present"
    annotation (Evaluate=true);
  Modelica.Blocks.Interfaces.RealInput u if haveShade
    "Shading control signal, 0: unshaded; 1: fully shaded"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput yCom "1-u"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}), iconTransformation(extent={{100,-70},{120,-50}})));
protected
  constant Real y0 = 1E-6 "Smallest allowed value for y if a shade is present";
  constant Real k = 1-2*y0 "Gain for shading signal";
  Modelica.Blocks.Interfaces.RealInput u_in_internal
    "Needed to connect to conditional connector";
equation
  connect(u, u_in_internal);
  if not haveShade then
    u_in_internal = 0;
  end if;
  if haveShade then
    y = y0 + k *  u_in_internal;
    yCom = 1-y;
  else
    y = 0;
    yCom = 1;
  end if;
  annotation ( Icon(graphics={
        Text(
          extent={{-92,22},{-50,-22}},
          textColor={0,0,127},
          textString="u"),
        Text(
          extent={{48,22},{90,-22}},
          textColor={0,0,127},
          textString="u'"),
        Text(
          extent={{-14,-40},{92,-80}},
          textColor={0,0,127},
          textString="1-u'")}),
           Documentation(info="<html>
This model changes the shading control signal to avoid a singularity
in the window model if the input signal is zero or one.
Since the window heat balance multiplies the area of the window by <code>u</code>
or by <code>1-u</code> (if a shade is present), the heat balance can be singular
for <code>u=0</code> or for <code>u=1</code>.
This model avoids this singularity by slightly changing the control signal.
</html>", revisions="<html>
<ul>
<li>
October 28 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ShadingSignal;
