within Buildings.Fluid.FMI;
package BaseClasses
  block X_w_toX "Conversion from Xi to X"
    extends Modelica.Blocks.Icons.Block;

    replaceable package Medium =
        Modelica.Media.Interfaces.PartialMedium
      "Medium model within the source"
       annotation (choicesAllMatching=true);
    Modelica.Blocks.Interfaces.RealInput X_w(final unit="kg/kg") if
          Medium.nXi > 0 "Water mass fraction per total air mass"
       annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealOutput X[Medium.nX](
      each final unit="kg/kg",
      final quantity=Medium.substanceNames) "Prescribed fluid composition"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  protected
    Modelica.Blocks.Interfaces.RealInput X_w_internal(final unit="kg/kg")
      "Internal connector for water mass fraction per total air mass";
  equation
    // Conditional connector
    connect(X_w_internal, X_w);
    if Medium.nXi == 0 then
      X_w_internal = 0;
    end if;
    // Assign vector to output connector
   X = cat(1, {X_w_internal}, {1-X_w_internal});
    annotation (Documentation(revisions="<html>
<ul>
<li>
April 15, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>",   info="<html>
<p>
Block that converts a scalar input for the water mass fraction <code>Xi</code>
to a vector output <code>X</code>.
This is needed for models in which a scalar input signal <code>Xi</code> that
may be conditionally removed is to be connected to a model with a vector
input <code>X</code>, because the conversion from scalar to vector
needs to access the conditional connector, but conditional connectors
can only be used in <code>connect</code> statements.
</p>
</html>"));
  end X_w_toX;

  block hOut_toT "Conversion from h to T"
    extends Modelica.Blocks.Icons.Block;

    replaceable package Medium =
        Modelica.Media.Interfaces.PartialMedium
      "Medium model within the source"
       annotation (choicesAllMatching=true);
    Modelica.Blocks.Interfaces.RealInput h(final unit="J/kg")
      "Specific enthalpy"
      annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

    Modelica.Blocks.Interfaces.RealInput Xi[Medium.nXi](each final unit="kg/kg") if
         Medium.nXi > 0 "Water vapor concentration in kg/kg total air"
      annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

    Modelica.Blocks.Interfaces.RealOutput T(final unit="K",
                                              displayUnit="degC") "Temperature"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  protected
    Modelica.Blocks.Interfaces.RealInput Xi_internal[Medium.nXi](
      each final unit = "kg/kg")
      "Internal connector for water vapor concentration in kg/kg total air";

  equation
    // Conditional connectors
    connect(Xi_internal, Xi);
    if Medium.nXi == 0 then
      Xi_internal = zeros(Medium.nXi);
    end if;

   T = Medium.temperature_phX(
        p=Medium.p_default,
        h=h,
        X=Xi_internal);

    annotation (Documentation(revisions="<html>
<ul>
<li>
April 28, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>",   info="<html>
<p>
Block that converts enthalpy to temperature.
</p>
</html>"));
  end hOut_toT;
annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.Fluid.FMI\">Buildings.Fluid.FMI</a>.
</p>
</html>"));
end BaseClasses;
