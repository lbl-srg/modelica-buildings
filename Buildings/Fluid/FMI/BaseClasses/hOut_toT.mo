within Buildings.Fluid.FMI.BaseClasses;
block hOut_toT "Conversion from h to T"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air")));
  Modelica.Blocks.Interfaces.RealInput h(final unit="J/kg") "Specific enthalpy"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput Xi[Medium.nXi](each final unit="kg/kg")
    if Medium.nXi > 0 "Water vapor concentration in kg/kg total air"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput T(final unit="K",
                                            displayUnit="degC") "Temperature"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
protected
  Modelica.Blocks.Interfaces.RealInput Xi_internal[Medium.nXi](
    each final unit = "kg/kg")
    "Internal connector for water vapor concentration in kg/kg total air";

initial equation
  assert(Medium.nXi < 2,
    "The medium must have zero or one independent mass fraction Medium.nXi.");
equation
  // Conditional connectors
  connect(Xi_internal, Xi);
  if Medium.nXi == 0 then
    Xi_internal = zeros(Medium.nXi);
  end if;

  T = Medium.temperature_phX(
    p=Medium.p_default,
    h=h,
    X=cat(1, Xi_internal, {1-sum(Xi_internal)}));

annotation (Documentation(revisions="<html>
<ul>
<li>
November 15, 2026, by Michael Wetter:<br/>
Constructed the full composition vector <code>X</code> from <code>Xi_internal</code> when <code>Medium.reducedX</code> is true before calling <code>Medium.temperature_phX</code>.
</li>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice to moist air only.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
April 28, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Block that converts enthalpy to temperature.
</p>
</html>"));
end hOut_toT;
