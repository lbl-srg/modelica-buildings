within Buildings.Templates.AHUs.Validation;
model SectionDedicatedPressure
  extends Buildings.Templates.AHUs.Validation.SectionNoEconomizer(
    redeclare UserProject.AHUs.SectionDedicatedPressure ahu);
end SectionDedicatedPressure;
