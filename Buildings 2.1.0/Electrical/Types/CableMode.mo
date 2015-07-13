within Buildings.Electrical.Types;
type CableMode = enumeration(
    automatic "Select automatically the size of the cable",
    commercial "Select the cable from a list of commercial options")
  "Enumeration that defines how a cable can be parameterized" annotation (
    Documentation(revisions="<html>
<ul>
<li>
March 19, 2015, by Marco Bonvini:<br/>
Added documentation.
</li>
</ul>
</html>", info="<html>
This type is used to indicate in which mode the cable model works.
In automatic mode the cable is automatically sized using basic information like
nominal voltage and power, in commercial mode the user can select among a list of
commercially available cables.
</html>"));
