within Buildings.Experimental.DHC.BaseClasses;
package Steam "Package for steam systems using the split-medium approach."
  extends Modelica.Icons.VariantsPackage;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains base class models for steam systems. 
These models use the split-medium approach to allow various 
water/steam models to be coupled with a numerically-efficient
liquid water model. This can greatly improve the computing performance
by decoupling the energy and mass balance equations.
</p>
</html>"));
end Steam;
