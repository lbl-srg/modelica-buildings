within Buildings.Fluid.AirFilters.BaseClasses;
model SimpleCharacterization
  "Component that calculates the filter efficiency and the flow coefficient correction factor"
  parameter Real mCon_nominal
  "Contaminant held capacity of the filter";
  parameter Real epsFun[:]
  "Filter efficiency curve";
  parameter Real b( final min = 1 + 1E-3)
  "Resistance coefficient";
  Modelica.Blocks.Interfaces.RealInput mCon(final unit="kg")
    "Mass of the contaminant held by the filter"
   annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput eps(
    final unit="1",
    final min = 0,
    final max = 1) "Filter efficiency"
                        annotation (
      Placement(transformation(extent={{100,38},{140,78}}), iconTransformation(
          extent={{100,38},{140,78}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput kCor(
    final unit="1",
    final min = 1)
   "Flow coefficient correction"
    annotation (
      Placement(transformation(extent={{100,-60},{140,-20}}),
        iconTransformation(extent={{100,-82},{140,-42}})));
protected
  Real Phi "ratio of the mass of the contaminant held by the filter to the nominal capactiy of the filter";
equation
  Phi = Buildings.Utilities.Math.Functions.smoothMin(x1= 1, x2= mCon/mCon_nominal, deltaX=0.1);
  eps = Buildings.Utilities.Math.Functions.polynomial(a=epsFun,x=Phi);
  assert(noEvent(eps > 0) and noEvent(eps < 1),
    "*** Error in " + getInstanceName() + ": The filter efficiency should be in the range of [0, 1], 
    check the filter efficiency curve.",
    level=AssertionLevel.error);
  kCor = b^Phi;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-143,-98},{157,-138}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    defaultComponentName="simCha",
    Documentation(revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model calculates the filter efficiency based on the mass of the contaminants held by the filter.
</p>
<p align=\"center\" style=\"font-style:italic;\">
  eps = epsFun<sub>1</sub> + epsFun<sub>2</sub> &#632; + epsFun<sub>3</sub> &#632;<sup>2</sup> + ...,
</p>
<p>
where <i>&#632;</i> is the ratio of the contaminant mass to the capacity of the filter for holding
the contaminants, and the coefficients <i>epsFun<sub>i</sub></i>
are declared by the parameter <code>epsFun</code>.
</p>
<p>
This model also calculates the flow coefficient of the filter by
</p>
<p align=\"center\" style=\"font-style:italic;\">
  kCor = b<sup>&#632;</sup>,
</p>
<p>
where <i>b</i> is a constant that is larger than 1.
</p>
<P>
<b>Note:</b> 
The upper limit of <i>&#632;</i> is 1 and any value above it is overwritten by 1.
</p>
<h4>References</h4>
<p>
Qiang Li ta al., (2022). Experimental study on the synthetic dust loading characteristics of air filters.
Separation and Purification Technology 284 (2022), 120209
</p>
</html>"));
end SimpleCharacterization;
