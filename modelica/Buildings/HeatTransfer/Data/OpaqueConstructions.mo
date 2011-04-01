within Buildings.HeatTransfer.Data;
package OpaqueConstructions
  "Package with opaque constructions for floors, walls, etc."
    extends Modelica.Icons.MaterialPropertiesPackage;
  record Generic "Thermal properties of opaque constructions"
    parameter Integer nLay(min=1, fixed=true) "Number of layers";
    parameter Solids.Generic material[nLay]
      "Layer by layer declaration of material, starting from outside to room-side"
      annotation (choicesAllMatching=true, Evaluate=true, Placement(transformation(extent={{60,60},{80,80}})));
   final parameter Real R(unit="m2.K/W")=sum(material[:].R)
      "Thermal resistance per unit area";

   parameter Modelica.SIunits.Emissivity epsLW_a=0.9
      "Long wave emissivity of surface a (usually outside-facing surface)";
   parameter Modelica.SIunits.Emissivity epsLW_b=0.9
      "Long wave emissivity of surface b (usually room-facing surface)";
   parameter Modelica.SIunits.Emissivity epsSW_a=0.5
      "Short wave emissivity of surface a (usually outside-facing surface)";
   parameter Modelica.SIunits.Emissivity epsSW_b=0.5
      "Short wave emissivity of surface b (usually room-facing surface)";

    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={
          Rectangle(
            extent={{-100,50},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,85},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-54,42},{-36,-92}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Forward),
          Rectangle(
            extent={{4,42},{54,-92}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.CrossDiag),
          Text(
            extent={{-127,113},{127,53}},
            textString="%name",
            lineColor={0,0,255}),
          Rectangle(
            extent={{-36,42},{4,-92}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Backward)}),
      defaultComponentName="opaCon",
      Documentation(info=
                   "<html>
Generic record with material definitions for constructions
with one or more layers of material.
By convention, <code>layer[1]</code> is facing the outside, and the last
layer is facing the room-side.
This is the same convention as is used in EnergyPlus and in Window 6.
</p>
<p>
The parameters <code>epsLW_a</code> and <code>epsLW_b</code>
are used to compute long-wave heat radiation (in the infrared spectrum).
The parameters <code>epsSW_a</code> and <code>epsSW_b</code>
are used to compute short-wave heat radiation (in the solar spectrum).
</p>
</html>", revisions=
          "<html>
<ul>
<li>
November 16, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  end Generic;

  record Insulation100Concrete200 =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic (material={
          Solids.InsulationBoard(x=0.1),Solids.Concrete(x=0.2)}, final nLay=2)
    "Construction with 100 mm insulation and 200 mm concrete";

  record Brick120 =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic (material={
          Solids.Brick(x=0.12)}, final nLay=1) "Construction with 120mm brick";

  record Concrete200 =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic (material={
          Solids.Concrete(x=0.2)}, final nLay=1)
    "Construction with 200mm concrete";

  annotation (preferedView="info",
Documentation(info="<html>
<p>
Package with material definitions for constructions
with one or more layers of material.
By convention, <code>layer[1]</code> is facing the outside, and the last
layer is facing the room-side.
This is the same convention as is used in EnergyPlus and in Window 6.
</p>
<p>
The parameters <code>epsLW_a</code> and <code>epsLW_b</code>
are used to compute long-wave heat radiation (in the infrared spectrum).
The parameters <code>epsSW_a</code> and <code>epsSW_b</code>
are used to compute short-wave heat radiation (in the solar spectrum).
</p>

</html>",
revisions="<html>
<ul>
<li>
November 16, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

end OpaqueConstructions;
