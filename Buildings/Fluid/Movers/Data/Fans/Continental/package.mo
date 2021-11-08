within Buildings.Fluid.Movers.Data.Fans;
package Continental "Package with performance data for fans of Continental Fan Manufacturing Inc."
  extends Modelica.Icons.Package;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains performance data for Continental fans.
The data are taken from 
<a href=\"https://https://continentalfan.com/e-catalog/industrial/centrifugal-blowers-fans-industrial/tfd-flange-mount-bc-airfoil-blowers/\">
https://continentalfan.com/e-catalog/industrial/centrifugal-blowers-fans-industrial/tfd-flange-mount-bc-airfoil-blowers/</a>.
The original documents use the IP units and conversions are made 
in this implementation.
If a fan model has testing data under more than one speed, 
the larger one is chosen as the nominal speed. 
</p>
</html>"));
end Continental;
