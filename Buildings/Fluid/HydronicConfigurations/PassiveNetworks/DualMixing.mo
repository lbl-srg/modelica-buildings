within Buildings.Fluid.HydronicConfigurations.PassiveNetworks;
model DualMixing "Dual mixing circuit"
  extends HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
    final dpBal1_nominal=0,
    dpValve_nominal=3e3);

  annotation (
    defaultComponentName="con",
    Icon(graphics={
    Bitmap(
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/PassiveNetworks/DualMixing.svg")}));
end DualMixing;
