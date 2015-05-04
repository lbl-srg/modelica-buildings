within Buildings.Electrical.Types;
type InitMode = enumeration(
    zero_current "Assume i=0 during homotopy initialization",
    linearized "Uses linear model during homotopy initialization")
  "Enumeration that defines the type of initialization assumption can be used for a load model"
  annotation (Documentation(revisions="<html>
<ul>
<li>
March 19, 2015, by Marco Bonvini:<br/>
Added documentation.
</li>
</ul>
</html>", info="<html>
This type is used to indicate how a model
should be initialized.
</html>"));
