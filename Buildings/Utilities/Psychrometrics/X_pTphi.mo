within Buildings.Utilities.Psychrometrics;
block X_pTphi
  "Return steam mass fraction as a function of relative humidity phi and temperature T"
  extends
    Buildings.Utilities.Psychrometrics.BaseClasses.HumidityRatioVaporPressure;

  package Medium = Buildings.Media.Air "Medium model";
  Modelica.Blocks.Interfaces.RealInput T(final unit="K",
                                           displayUnit="degC",
                                           min = 0) "Temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput phi(min = 0, max=1)
    "Relative humidity (0...1)"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput X[Medium.nX](each min=0, each max=1)
    "Steam mass fraction"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Modelica.SIunits.AbsolutePressure pSat "Saturation pressure";
  parameter Integer i_w =
   sum({(
     if Modelica.Utilities.Strings.isEqual(
       string1=Medium.substanceNames[i],
       string2="Water",
       caseSensitive=false)
     then i else 0)
     for i in 1:Medium.nX});
  parameter Integer i_nw = if i_w == 1 then 2 else 1 "Index for non-water substance";
  parameter Boolean found = i_w > 0 "Flag, used for error checking";

initial equation
  assert(Medium.nX==2, "The implementation is only valid if Medium.nX=2.");
  assert(found, "Did not find medium species 'water' in the medium model. Change medium model.");

equation
  pSat =  Buildings.Media.Air.saturationPressure(T);
  X[i_w] =  Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
     pSat=pSat,
     p=p_in_internal,
     phi=phi);
  //sum(X[:]) = 1; // The formulation with a sum in an equation section leads to a nonlinear equation system
  X[i_nw] =  1 - X[i_w];
  annotation (Documentation(info="<html>
<p>
Block to compute the water vapor concentration based on
pressure, temperature and relative humidity.
</p>
<p>
If <code>use_p_in</code> is false (default option), the <code>p</code> parameter
is used as atmospheric pressure,
and the <code>p_in</code> input connector is disabled;
if <code>use_p_in</code> is true, then the <code>p</code> parameter is ignored,
and the value provided by the input connector is used instead.
</p>
</html>", revisions="<html>
<ul>
<li>November 3, 2017 by Filip Jorissen:<br/>
Converted (initial) algorithm section into (initial) equation section.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/847\">#847</a>.
</li>
<li>July 24, 2014 by Michael Wetter:<br/>
Added <code>assert</code> to verify that <code>Medium.nX==2</code>
as the implementation is only valid for such media.
</li>
<li>April 26, 2013 by Michael Wetter:<br/>
Set the medium model to <code>Buildings.Media.Air</code>.
This was required to allow a pedantic model check in Dymola 2014.
</li>
<li>August 21, 2012 by Michael Wetter:<br/>
Added function call to compute water vapor content.
</li>
<li>
February 22, 2010 by Michael Wetter:<br/>
Improved the code that searches for the index of 'water' in the medium model.
</li>
<li>
February 17, 2010 by Michael Wetter:<br/>
Renamed block from <code>MassFraction_pTphi</code> to <code>X_pTphi</code>
</li>
<li>
February 4, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Text(
          extent={{-96,16},{-54,-22}},
          lineColor={0,0,0},
          textString="T"),
        Text(
          extent={{-86,-18},{-36,-100}},
          lineColor={0,0,0},
          textString="phi"),
        Text(
          extent={{26,56},{90,-54}},
          lineColor={0,0,0},
          textString="X_steam")}));
end X_pTphi;
