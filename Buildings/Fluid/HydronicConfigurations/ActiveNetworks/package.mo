within Buildings.Fluid.HydronicConfigurations;
package ActiveNetworks "Package of hydronic configurations for active networks"
  extends Modelica.Icons.VariantsPackage;

annotation (Documentation(info="<html>
<p>
This package contains models of hydronic configurations
compatible with active primary networks.
</p>
<p>
An active network is defined as a network where the pressure
differential at the boundaries of each connected consumer circuit
is primarily driven by the primary circuit circulating pump.
</p>
<p>
<p>
The primary circuit is necessarily equipped with a circulating 
pump.
The connected consumer circuits may be equipped with 
a circulating pump or not.
</p>
</html>"));
end ActiveNetworks;
