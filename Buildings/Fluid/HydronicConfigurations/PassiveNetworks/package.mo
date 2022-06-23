within Buildings.Fluid.HydronicConfigurations;
package PassiveNetworks "Package of hydronic configurations for passive networks"
  extends Modelica.Icons.VariantsPackage;

annotation (Documentation(info="<html>
<p>
This package contains models of hydronic configurations
compatible with passive primary networks.
</p>
<p>
A passive network is defined as a network where the pressure
differential at the boundaries of each connected consumer circuit
is primarily driven by the consumer circuit circulating pump.
</p>
<p>
<p>
The connected consumer circuits are necessarily equipped with 
a circulating pump.
However, the primary circuit may be equipped with a circulating 
pump or not.
In the former case, a decoupling device (such as a fixed bypass, 
a hydraulic separator, or a supply-through loop) is used to 
cancel out the pressure differential created by the primary pump.
</p>
</html>"));
end PassiveNetworks;
