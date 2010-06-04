within Buildings.HeatTransfer;
package Data "Data for heat transfer models"

  package Solids
    "Package with solid material, characterized by thermal conductance, density and specific heat capacity"
    record Generic "Thermal properties of solids with heat storage"
        extends Buildings.HeatTransfer.Data.BaseClasses.Material(
         final R=x/k);
    end Generic;

    record Brick = Buildings.HeatTransfer.Data.Solids.Generic (
                          k=0.89, d=1920, c=790) "Brick (k=0.89)";
    record Concrete = Buildings.HeatTransfer.Data.Solids.Generic (
                             k=1.4, d=2240, c=840) "Concrete (k=1.4)";
    record InsulationBoard = Buildings.HeatTransfer.Data.Solids.Generic (
                                    k=0.03, d=40, c=1200)
      "Insulation board (k=0.03)";
    record GypsumBoard = Buildings.HeatTransfer.Data.Solids.Generic (
                                k=0.16, d=800, c=1090) "Gypsum board (k=0.58)";
    record Plywood = Buildings.HeatTransfer.Data.Solids.Generic (
                            k=0.12, d=540, c=1210) "Plywood (k=0.12)";
  end Solids;

  package Resistances "Package with thermal resistances"
    record Generic "Thermal properties of heat resistances"
        extends Buildings.HeatTransfer.Data.BaseClasses.Material(
         final c=0,
         final d=0,
         final k=0,
         final x=0,
         nStaRef=0);
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Rectangle(
              extent={{-100,50},{100,-100}},
              fillColor={255,255,127},
              fillPattern=FillPattern.Solid,
              lineColor={0,0,255}), Text(
              extent={{-98,-72},{96,-94}},
              lineColor={0,0,255},
              textString="R=%R")}));
    end Generic;

    record Carpet = Buildings.HeatTransfer.Data.Resistances.Generic (
                                R=0.2165) "Carpet";
  end Resistances;

  package OpaqueConstructions
    "Package with opaque constructions for floors, walls, etc."
    record Generic "Thermal properties of opaque constructions"
      parameter Integer nLay(min=1, fixed=true) "Number of layers";
      parameter Solids.Generic material[nLay]
        "Layer by layer declaration of material"
        annotation (choicesAllMatching=true, Evaluate=true, Placement(transformation(extent={{60,60},{80,80}})));
     final parameter Real R(unit="m2.K/W")=sum(material[:].R)
        "Thermal resistance per unit area";
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
              fillPattern=FillPattern.Backward)}));
    end Generic;

    record Insulation100Concrete200 =
        Buildings.HeatTransfer.Data.OpaqueConstructions.Generic (
        material = {Solids.InsulationBoard(x=0.1),
                    Solids.Concrete(x=0.2)},
        final nLay=2) "Construction with 100 mm insulation and 200 mm concrete";
    record Brick120 =
        Buildings.HeatTransfer.Data.OpaqueConstructions.Generic (
        material = {Solids.Brick(x=0.12)},
        final nLay = 1) "Construction with 120mm brick";
    record Concrete200 =
        Buildings.HeatTransfer.Data.OpaqueConstructions.Generic (
        material = {Solids.Concrete(x=0.2)},
        final nLay = 1) "Construction with 200mm concrete";
  end OpaqueConstructions;

  package BaseClasses "Base classes for package Data"
    extends Modelica.Fluid.Icons.BaseClassLibrary;
    record Material "Thermal properties of materials w/o storage"
      extends Modelica.Icons.Record;
      parameter Modelica.SIunits.Length x "Material thickness";
      parameter Modelica.SIunits.ThermalConductivity k "Thermal conductivity";
      parameter Modelica.SIunits.SpecificHeatCapacity c
        "Specific heat capacity";
      parameter Modelica.SIunits.Density d "Mass density";
      parameter Real R(unit="m2.K/W")
        "Thermal resistance of a unit area of material";
      parameter Integer nStaRef(min=0) = 3
        "Number of state variables in a reference material of 0.2 m concrete";
      parameter Integer nSta(min=1)=max(1, integer(ceil(nStaReal)))
        "Actual number of state variables in material"
        annotation(Evaluate=true, Dialog(tab="Advanced"));
      parameter Boolean steadyState= (c == 0 or d == 0)
        "Flag, if true, then material is computed using steady-state heat conduction"
        annotation(Evaluate=true);
      parameter Real piRef=331.4
        "Ratio x/sqrt(alpha) for reference material of 0.2 m concrete"
        annotation (Dialog(tab="Advanced"));
      parameter Real piMat=if steadyState then piRef else x*sqrt(c*d)/sqrt(k)
        "Ratio x/sqrt(alpha)"
        annotation(Evaluate=true, Dialog(tab="Advanced"));
      parameter Real nStaReal(min=0) = nStaRef*piMat/piRef
        "Number of states as a real number"
        annotation (Dialog(tab="Advanced"));
      annotation (preferedView="info",
      Documentation(info="<html>
This is the base record for materials that declares the thermal properties. 
</p>
<p>
The specific heat capacity can be zero, in which case the material
will be modeled as a thermal resistor that does not store energy.
</p>
<p>
Note that the thermal resistance is in units of <tt>m2*K/W</tt> and not <tt>K/W</tt>
because this record does not have the surface area as a parameter. The surface area
will be defined in the model of the construction that uses this material.
This allows use of the same material in walls, floors
and ceilings of different surface area.
</p>
</html>",
    revisions="<html>
<ul>
<li>
June 3 2010, by Michael Wetter:<br>
Implemented adaptive computation of number of states based on a reference construction of 0.2 m concrete.
</li>
<li>
March 6 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),     Icon(graphics={
            Text(
              extent={{-94,44},{-16,12}},
              lineColor={0,0,0},
              textString="x=%x"),
            Text(
              extent={{8,40},{86,8}},
              lineColor={0,0,0},
              textString="k=%k"),
            Text(
              extent={{-90,-58},{-12,-90}},
              lineColor={0,0,0},
              textString="R=%R"),
            Text(
              extent={{-92,-10},{-14,-42}},
              lineColor={0,0,0},
              textString="U=%U"),
            Rectangle(
              visible=(c == 0),
              extent={{0,0},{100,-100}},
              lineColor={0,0,0},
              fillColor={255,170,170},
              fillPattern=FillPattern.Solid),
            Line(points={{-100,-50},{100,-50}}, color={0,0,0}),
            Text(
              visible=not (c == 0),
              extent={{8,-8},{86,-40}},
              lineColor={0,0,0},
              textString="d=%d"),
            Text(
              visible=not (c == 0),
              extent={{10,-56},{88,-88}},
              lineColor={0,0,0},
              textString="c=%c")}));

    end Material;
  end BaseClasses;

  annotation (Documentation(info="<html>
Package with thermal properties of solid materials.
</html>"));
end Data;
