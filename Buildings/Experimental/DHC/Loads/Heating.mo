within Buildings.Experimental.DHC.Loads;
package Heating "Package of models for district heating loads"
  extends Modelica.Icons.Package;
  package DHW "Package of models for DHW loads served by district heating"
     extends Modelica.Icons.Package;
    package BaseClasses
      "Package with base classes that are used by multiple models"
      extends Modelica.Icons.BasesPackage;

    annotation (Documentation(info="<html>
<p>
This package contains base classes that are used to construct the classes in
<a href=\"modelica://Buildings.Experimental.DHC.Loads.Heating.DHW\">
Buildings.Experimental.DHC.Loads.Heating.DHW</a>.
</p>
</html>"));
    end BaseClasses;
  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains models for building domestic hot water loads served by a district heating network.
</p>
</html>"));
  end DHW;
annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains models for building heating loads served by a district network.
</p>
</html>"));
end Heating;
