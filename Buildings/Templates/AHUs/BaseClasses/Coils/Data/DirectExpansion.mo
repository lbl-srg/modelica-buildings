within Buildings.Templates.AHUs.BaseClasses.Coils.Data;
record DirectExpansion
  extends Interfaces.Data.Coil;

  parameter Boolean have_dryCon = true
    "Set to true for purely sensible cooling of the condenser";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DirectExpansion;
