within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilElectricHeating
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable Buildings.Templates.Components.Coils.ElectricHeating
      coiHeaPre "Electric heating coil",
    nZon=2,
    nGro=1);
  annotation (
    defaultComponentName="ahu");
end CoilElectricHeating;
