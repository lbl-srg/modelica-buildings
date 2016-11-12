within Buildings.Fluid.FMI.BaseClasses;
block X_w_toX "Conversion from Xi to X"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
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
</html>", info="<html>
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
