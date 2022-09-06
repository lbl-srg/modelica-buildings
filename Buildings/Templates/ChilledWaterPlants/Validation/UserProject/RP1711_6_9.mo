within Buildings.Templates.ChilledWaterPlants.Validation.UserProject;
model RP1711_6_9
  "Parallel Chillers, Primary-Distributed Secondary, Air-Cooled"
  //ToDo
  extends Buildings.Templates.ChilledWaterPlants.AirCooled(redeclare
      Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Parallel
      chiSec(final nChi=2, redeclare
        Buildings.Templates.ChilledWaterPlants.Components.PumpsPrimary.HeaderedParallel
        pumPri(final nPum=2, final have_floSen=true)), redeclare
      Buildings.Templates.ChilledWaterPlants.Components.PumpsSecondary.Distributed
      pumSec(final nPum=3));

  annotation (
    defaultComponentName="chw");
end RP1711_6_9;
