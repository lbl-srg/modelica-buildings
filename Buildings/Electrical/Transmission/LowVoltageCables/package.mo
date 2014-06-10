within Buildings.Electrical.Transmission;
package LowVoltageCables "Package of low voltage electricity cables used in distribution grid"
  extends Modelica.Icons.MaterialPropertiesPackage;

// fixme: all cables need an info section. Please also add a revision section.
// See for example Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR
// The info section should also explain the difference between a cable with and
// without the extension _ECM
//
// Also, if a cable has a diameter, then you need to set it to the parameter d.
// Maybe it is cleaner to make a record that only has the data members that are
// actually used by the cables of the respective packages.

annotation (Documentation(info="<html>
<p>
This package contains records of physical properties for low
voltage commercial cables. New cables can be added by extending the
base record
<a href=\"modelia://Buildings.Electrical.Transmission.LowVoltageCables.Generic\">
Buildings.Electrical.Transmission.LowVoltageCables.Generic</a>.
</p>
<p>
For low voltage cables, only the characteristic resistance and reactance are
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
