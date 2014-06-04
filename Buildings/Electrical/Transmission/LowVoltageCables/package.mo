within Buildings.Electrical.Transmission;
package LowVoltageCables "Package of low voltage electricity cables used in distribution grid"
  extends Modelica.Icons.MaterialPropertiesPackage;


annotation (Documentation(info="<html>
<p>
This package contains records of physical properties of low 
voltage commercial cables. New cables can be added by extending the 
base record 
<a href=\"modelia://Buildings.Electrical.Transmission.LowVoltageCables.Cable\">
Buildings.Electrical.Transmission.LowVoltageCables.Cable</a>.
</p>
<p>
For low voltage cable just the characteristic resistance and reactance are 
specified. See <a href=\"modelia://Buildings.Electrical.Transmission.Base.BaseCable\">
Buildings.Electrical.Transmission.Base.BaseCable</a> for a comprehensive list of 
parameters that can be specified for a cable.
</p>
</html>", revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end LowVoltageCables;
