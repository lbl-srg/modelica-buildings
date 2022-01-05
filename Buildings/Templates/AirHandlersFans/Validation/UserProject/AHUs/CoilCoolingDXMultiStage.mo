within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model CoilCoolingDXMultiStage
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    id="VAV_1",
    nZon=2,
    nGro=1,
    redeclare replaceable Buildings.Templates.Components.Coils.Evaporator
      coiCoo(redeclare replaceable
        Buildings.Templates.Components.HeatExchangers.DXCoilMultiStage hex));

  annotation (
    defaultComponentName="ahu");
end CoilCoolingDXMultiStage;
