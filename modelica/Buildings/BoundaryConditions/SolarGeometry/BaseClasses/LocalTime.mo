within Buildings.BoundaryConditions.SolarGeometry.BaseClasses;
block LocalTime "Local time"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput cloTim(quantity="Time", unit="s")
    "Time used in simulation clock"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput locTim(
    final quantity="Time",
    final unit="s",
    displayUnit="h") "Local time"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Modelica.SIunits.Time T0;
initial equation
  T0 = integer(time/86400)*86400;
equation
  when sample(0, 86400) then
    T0 = cloTim;
  end when;
  locTim = cloTim - T0;
  annotation (
    defaultComponentName="locTim",
    Documentation(info="<HTML>
<p>
This component generates local time based on 24 hours scale according to the simualtion time.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
May 15, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-54,38},{42,-24}},
          lineColor={0,0,255},
          textString="t"),
        Text(
          extent={{-4,2},{52,-26}},
          lineColor={0,0,255},
          textString="loc")}));
end LocalTime;
