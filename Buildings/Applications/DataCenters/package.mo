within Buildings.Applications;
package DataCenters "Package with models for data centers"
  extends Modelica.Icons.VariantsPackage;

annotation (
preferredView="info",
Documentation(info="<html>
<p>
This package contains models for data centers.
They have been developed as part of the project
<a href=\"https://energy.gov/eere/buildings/downloads/improving-data-center-efficiency-end-end-cooling-modeling-and-optimization\">
Improving Data Center Efficiency via End-to-End Cooling Modeling and Optimization
</a> with funding from the US Department of Energy and cost-share contributions
from Schneider Electric and the University of Miami.
</p>
<p>
The package
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled\">
Buildings.Applications.DataCenters.ChillerCooled</a>
contains models for data centers that use chilled water plants,
whereas the package
<a href=\"modelica://Buildings.Applications.DataCenters.DXCooled\">
Buildings.Applications.DataCenters.DXCooled</a>
contains models where cooling is provided with a DX coil.
In both packages, the computers are air-cooled.
</p>
</html>"));
end DataCenters;
