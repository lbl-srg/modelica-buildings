within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
model RP1711_6_9
  "Parallel Chillers, Primary-Distributed Secondary, Air-Cooled"
  //ToDo
  extends Buildings.Templates.ChilledWaterPlant.AirCooled(
    redeclare Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Parallel
      chiSec(final nChi=2),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.HeaderedParallel
      pumPri(final nPum=2, final have_floSen=true),
    redeclare Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumps.Distributed
      pumSec(final nPum=3));

  annotation (
    defaultComponentName="chw");
end RP1711_6_9;
