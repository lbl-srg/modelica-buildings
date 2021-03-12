within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoilCoolingDXMultiStage
  extends VAVSingleDuct(final id="VAV_1", redeclare
      BaseClasses.Coils.DirectExpansion coiCoo(redeclare
        Buildings.Templates.AHUs.BaseClasses.Coils.HeatExchangers.DXMultiStage
        hex));

  annotation (
    defaultComponentName="ahu");
end CoilCoolingDXMultiStage;
