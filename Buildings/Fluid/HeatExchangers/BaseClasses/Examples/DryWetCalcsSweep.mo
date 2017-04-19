within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model DryWetCalcsSweep
  "Creates a plot of using the DryWetCalcs over a range of input relative humidity"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.Examples.DryWetCalcs(
    wAirInExp(y = wAirIn * R),
    hAirInExp(y = Medium_A.specificEnthalpy_pTX(
      p = pAir,
      T = TAirIn,
      X = {wAirIn * R, 1 - (wAirIn * R)})));
  Real R = time / 10
    "Parameter to adjust wAirIn with time";
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi TWetBul_TDryBulXi(
    redeclare package Medium = Medium_A,
    TDryBul = TAirIn,
    p = pAir,
    Xi = {wAirIn * R})
    "Utility to calculate the wet bulb temperature";
  Modelica.SIunits.Temperature TWetBul = TWetBul_TDryBulXi.TWetBul
    "The wet bulb temperature";
  Modelica.SIunits.HeatFlowRate Q_flow = -dryWetCalcs.QTot_flow
    "The heat transferred from the air to the water stream";

  annotation (
    experiment(Tolerance=1E-6, StopTime=20),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/DryWetCalcsSweep.mos"
      "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">
issue 622</a> for more information.
</li>
</ul>
</html>", info="<html>
<p>
This example duplicates the figure associated with example SM2-1 from Mitchell
and Braun 2012. This example is a further test of the implementation of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs\">
Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs</a>.
</p>

<p>
The plot associated with SM2-1 can be recreated by plotting both
<code>dryWetCalcs.dryFra</code> and <code>dryWetCalcs.QTot</code> versus
<code>TWetBul</code>.
</p>

<h4>References</h4>

<p>
Mitchell, John W., and James E. Braun. 2012.
\"Supplementary Material Chapter 2: Heat Exchangers for Cooling Applications\".
Excerpt from <i>Principles of heating, ventilation, and air conditioning in buildings</i>.
Hoboken, N.J.: Wiley. Available online:
<a href=\"http://bcs.wiley.com/he-bcs/Books?action=index&amp;itemId=0470624574&amp;bcsId=7185\">
http://bcs.wiley.com/he-bcs/Books?action=index&amp;itemId=0470624574&amp;bcsId=7185</a>
</p>
</html>"));
end DryWetCalcsSweep;
