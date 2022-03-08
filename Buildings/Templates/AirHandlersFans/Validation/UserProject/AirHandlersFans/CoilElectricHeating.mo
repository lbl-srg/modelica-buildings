within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model CoilElectricHeating
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable Buildings.Templates.Components.Coils.ElectricHeating
      coiHeaPre "Electric heating coil",
    nZon=2);
  annotation (
    defaultComponentName="ahu");
end CoilElectricHeating;
