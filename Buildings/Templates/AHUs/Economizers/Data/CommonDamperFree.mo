within Buildings.Experimental.Templates.AHUs.Economizers.Data;
record CommonDamperFree
  extends CommonDamperTandem;

  annotation (
    defaultComponentName="datEco",
    defaultComponentPrefixes="outer parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CommonDamperFree;
