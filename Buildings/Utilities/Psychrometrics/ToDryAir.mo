within Buildings.Utilities.Psychrometrics;
block ToDryAir
  "Block to convert absolute humidity from [kg/kg total air] to [kg/kg dry air]"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealOutput XiDry
    "Water vapor concentration in [kg/kg dry air]"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput XiTotalAir
    "Water vapor concentration in [kg/kg total air]"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

equation
  XiDry = XiTotalAir / (1-XiTotalAir);
    annotation (
    defaultComponentName="toDryAir",
    Documentation(info="<html>
<p>
Block that converts humidity concentration from [kg/kg total air] to [kg/kg dry air].
</p>
</html>", revisions="<html>
<ul>
<li>
September 10, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{34,30},{86,-34}},
          textColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="XiDry"), Text(
          extent={{-86,48},{-14,-52}},
          textColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="XiTotal")}));
end ToDryAir;
