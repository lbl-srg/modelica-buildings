within Buildings.ThermalZones.Detailed.BaseClasses;
block to_W "Add unit [W] to data"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y(final quantity="Power", final unit=
        "W") "Power"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  y = u;

  annotation (
    defaultComponentName="toW",
    Documentation(info="<html>This component adds the unit [W] into the data.
</html>", revisions="<html>
<ul>
<li>
January 24, 2014, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255})}));
end to_W;
