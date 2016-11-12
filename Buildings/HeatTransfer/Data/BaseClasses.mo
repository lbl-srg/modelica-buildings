within Buildings.HeatTransfer.Data;
package BaseClasses "Base classes for package Data"
  extends Modelica.Icons.BasesPackage;
  record Material "Thermal properties of materials w/o storage"
    extends Modelica.Icons.Record;
    parameter Modelica.SIunits.Length x "Material thickness";
    parameter Modelica.SIunits.ThermalConductivity k "Thermal conductivity";
    parameter Modelica.SIunits.SpecificHeatCapacity c "Specific heat capacity";
    parameter Modelica.SIunits.Density d "Mass density";
    parameter Real R(unit="m2.K/W")
      "Thermal resistance of a unit area of material";
    parameter Integer nStaRef(min=0) = 3
      "Number of state variables in a reference material of 0.2 m concrete";
    parameter Integer nSta(min=1)=max(1, integer(ceil(nStaReal)))
      "Actual number of state variables in material"
      annotation(Evaluate=true, Dialog(tab="Advanced"));
    parameter Boolean steadyState= (c < Modelica.Constants.eps or d < Modelica.Constants.eps)
      "Flag, if true, then material is computed using steady-state heat conduction"
      annotation(Evaluate=true);
    parameter Real piRef=331.4
      "Ratio x/sqrt(alpha) for reference material of 0.2 m concrete"
      annotation (Dialog(tab="Advanced"));
    parameter Real piMat=if steadyState then piRef else x*sqrt(c*d/k)
      "Ratio x/sqrt(alpha)"
      annotation(Dialog(tab="Advanced"));
    parameter Real nStaReal(min=0) = nStaRef*piMat/piRef
      "Number of states as a real number"
      annotation (Dialog(tab="Advanced"));

    parameter Modelica.SIunits.Temperature TSol
      "Solidus temperature, used only for PCM."
      annotation (Dialog(group="Properties for phase change material"));
    parameter Modelica.SIunits.Temperature TLiq
      "Liquidus temperature, used only for PCM"
      annotation (Dialog(group="Properties for phase change material"));
    parameter Modelica.SIunits.SpecificInternalEnergy LHea
      "Latent heat of phase change"
      annotation (Dialog(group="Properties for phase change material"));

    constant Boolean ensureMonotonicity = false
      "Set to true to force derivatives dT/du to be monotone";

    constant Boolean phasechange = false
      "Flag, true if the material is a phase change material"
          annotation (Dialog(group="Properties for phase change material"));

    annotation (preferredView="info",
    defaultComponentPrefixes="parameter",
    defaultComponentName="datMat",
    Documentation(info="<html>
Base record for materials that declares the thermal properties.
<br/>
<p>
The specific heat capacity can be zero, in which case the material
will be modeled as a thermal resistor that does not store energy.
</p>
<p>
Note that the thermal resistance is in units of
<i>m<sup>2</sup> K &frasl; W</i> and not <i>K &frasl; W</i>
because this record does not have the surface area as a parameter.
The surface area
will be defined in the model of the construction that uses this material.
This allows use of the same material in walls, floors
and ceilings of different surface area.
</p>
</html>",
  revisions="<html>
<ul>
<li>
March 1, 2016, by Michael Wetter:<br/>
Removed test for equality of <code>Real</code> variables.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/493\">issue 493</a>.
</li>
<li>
May 21, 2015, by Michael Wetter:<br/>
Reformulated to reduce use of the division macro
in Dymola.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/417\">issue 417</a>.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
June 3 2010, by Michael Wetter:<br/>
Implemented adaptive computation of number of states based on a reference construction of <i>0.2 m</i> concrete.
</li>
<li>
March 6 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),   Icon(graphics={
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

  record ThermalProperties "Thermal properties of materials with storage"
    extends Modelica.Icons.Record;
    parameter Modelica.SIunits.ThermalConductivity k "Thermal conductivity";
    parameter Modelica.SIunits.SpecificHeatCapacity c "Specific heat capacity";
    parameter Modelica.SIunits.Density d "Mass density";
    parameter Boolean steadyState= (c < Modelica.Constants.eps or d < Modelica.Constants.eps)
      "Flag, if true, then material is computed using steady-state heat conduction"
      annotation(Evaluate=true);
   annotation (preferredView="info",
   defaultComponentPrefixes="parameter",
   defaultComponentName="datThePro",
    Documentation(info="<html>
Base record for materials, used in circular geometry or other configurations, that only declares the thermal properties.
<br/>
<p>
The specific heat capacity can be zero, in which case the material
will be modeled as a thermal resistor that does not store energy.
</p>
</html>",
  revisions="<html>
<ul>
<li>
March 1, 2016, by Michael Wetter:<br/>
Removed test for equality of <code>Real</code> variables.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/493\">issue 493</a>.
</li>
<li>
April 2011, by Pierre Vigouroux:<br/>
</li>
<li>
April 12 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"),   Icon(graphics={
          Line(points={{-100,-50},{100,-50}}, color={0,0,0}),
          Text(
            visible=not (c == 0),
            extent={{-80,36},{-10,12}},
            lineColor={0,0,0},
            textString="d=%d"),
          Text(
            visible=not (c == 0),
            extent={{-80,-58},{-6,-88}},
            lineColor={0,0,0},
            textString="c=%c"),
          Text(
            extent={{-74,-12},{-14,-36}},
            lineColor={0,0,0},
            textString="k=%k"),
          Line(points={{-100,0},{100,0}},     color={0,0,0})}));
  end ThermalProperties;
end BaseClasses;
