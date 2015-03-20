within Buildings.Electrical.Types;
type LoadConnection = enumeration(
    wye_to_wyeg "Wye to wye grounded",
    wye_to_delta "Wye to delta")
  "Enumeration that defines the type of connection can be used for three phases unbalanced systems"
  annotation (Documentation(revisions="<html>
<ul>
<li>
March 19, 2015, by Marco Bonvini:<br/>
Added documentation.
</li>
</ul>
</html>", info="<html>
This type is used to describe different types of connection that can be used in
unbalanced three phases systems.
</html>"));
