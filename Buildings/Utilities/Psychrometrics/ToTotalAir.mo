within Buildings.Utilities.Psychrometrics;
block ToTotalAir
  "Block to convert absolute humidity from [kg/kg dry air] to [kg/kg total air]"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealOutput XiTotalAir
    "Water vapor concentration in [kg/kg total air]"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput XiDry
    "Water vapor concentration in [kg/kg dry air]"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Modelica.Blocks.Interfaces.RealOutput XNonVapor
    "Mass fraction of remaining substances"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
equation
  XiTotalAir = XiDry / (1+XiDry);
  XNonVapor = 1 - XiTotalAir;
    annotation (
    defaultComponentName="toTotAir",
    Documentation(info="<html>
<p>
Block that converts humidity concentration from [kg/kg dry air] to [kg/kg total air].
</p>
<p>
This block may be used, for example, to convert absolute humidity that is received from
EnergyPlus to [kg/kg total air], which is the convention used by Modelica.Media.
</p>
</html>", revisions="<html>
<ul>
<li>
September 10, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-88,32},{-36,-32}},
          textColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="XiDry"), Text(
          extent={{20,50},{92,-50}},
          textColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="XiTotal")}));
end ToTotalAir;
