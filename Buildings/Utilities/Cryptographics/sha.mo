within Buildings.Utilities.Cryptographics;
pure function sha
  "SHA1 encryption of a String"
  extends Modelica.Icons.Function;
  input String str "String to be encrypted";
  output String sha1 "SHA1-encrypted string";

external "C" sha1 = cryptographicsHash(str)
  annotation (
  Include="#include <cryptographicsHash.c>",
  IncludeDirectory="modelica://Buildings/Resources/C-Sources");

annotation (
    Documentation(info="<html>
<p>
This function takes a String input and, using an external function written in C,
outputs its SHA1 encryption. The input string can be of any length, though the output
will always be 40 hexadecimal characters.
</p>
</html>", revisions="<html>
<ul>
<li>
December 11, 2021, by Michael Wetter:<br/>
Added <code>pure</code> declaration for MSL 4.0.0.
</li>
<li>
May 31, 2018 by Alex Laferri&egrave;re:<br/>
Changed the encryption to a SHA1 with a string array input (rather than a file
input).
</li>
<li>
January 21, 2018 by Filip Jorissen:<br/>
Revised sha implementation to avoid buffer overflow in borefield.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/755\">
#755</a>.
</li>
</ul>
</html>"));
end sha;
