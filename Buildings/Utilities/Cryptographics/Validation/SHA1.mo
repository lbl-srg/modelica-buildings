within Buildings.Utilities.Cryptographics.Validation;
model SHA1 "Model that verifies the SHA1 encryption C function"
  extends Modelica.Icons.Example;

  //Test strings
  parameter String strIn1 = "abc"
    "First test string";
  parameter String strIn2 = ""
    "Second test string";
  parameter String strIn3 = "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
    "Third test string";
  parameter String strIn4 = "1.23e+4"
    "Fourth test string";
  parameter String strIn5 = Modelica.Utilities.Strings.repeat(509, string="a")
    "Fifth test string";

  //Expected outputs
  parameter String strEx1=
    "a9993e364706816aba3e25717850c26c9cd0d89d"
    "Encryption result of first string";
  parameter String strEx2=
    "da39a3ee5e6b4b0d3255bfef95601890afd80709"
    "Encryption result of second string";
  parameter String strEx3=
    "84983e441c3bd26ebaae4aa1f95129e5e54670f1"
    "Encryption result of third string";
  parameter String strEx4=
    "bdd220adb45b392f17915af70ed8a006c382b983"
    "Encryption result of fourth string";
  parameter String strEx5=
    "edff7a135c2e06d4c8084e61b4516c901bd5fcd0"
    "Encryption result of fifth string";

  //Comparison results
  Boolean cmp1,cmp2,cmp3,cmp4,cmp5,cmpAll;

equation
  cmp1 = Modelica.Utilities.Strings.isEqual(Buildings.Utilities.Cryptographics.sha(strIn1),strEx1,false);
  cmp2 = Modelica.Utilities.Strings.isEqual(Buildings.Utilities.Cryptographics.sha(strIn2),strEx2,false);
  cmp3 = Modelica.Utilities.Strings.isEqual(Buildings.Utilities.Cryptographics.sha(strIn3),strEx3,false);
  cmp4 = Modelica.Utilities.Strings.isEqual(Buildings.Utilities.Cryptographics.sha(strIn4),strEx4,false);
  cmp5 = Modelica.Utilities.Strings.isEqual(Buildings.Utilities.Cryptographics.sha(strIn5),strEx5,false);
  cmpAll = cmp1 and cmp2 and cmp3 and cmp4 and cmp5;

  annotation(experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Cryptographics/Validation/SHA1.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This validation function tests the C implementation of the SHA1 encryption for
the following strings:
</p>
<ul>
<li>
<code>&#34;abc&#34;</code>
</li>
<li>
<code>&#34;&#34;</code> <i>(an empty string)</i>
</li>
<li>
<code>&#34;abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq&#34;</code>
</li>
<li>
<code>&#34;1.23e+4&#34;</code>
</li>
<li>
<code>&#34;a&#34;</code> repeated <i>509</i> times.
</li>
</ul>
<p>
If the encrypted strings are identical to the expected (known) encryption
results, the <code>cmpAll</code> boolean variable will be <code>true</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 13, 2019, by Michael Wetter:<br/>
Reduced string length for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1081\">issue 1081</a>.
</li>
<li>
May 30, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end SHA1;
