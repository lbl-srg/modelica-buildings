within Buildings.HeatTransfer.Data;
package GlazingSystems
  "Package with thermophysical properties for glazing systems"

  record Generic "Thermal properties of glazing systems"
      extends Modelica.Icons.Record;
    parameter Integer nLay(min=1, fixed=true) "Number of glass layers"
      annotation (Evaluate=true);
    parameter Boolean haveExteriorShade = false
      "Set to true if window has an exterior shade (at surface a)"
      annotation (Evaluate=true);
    parameter Boolean haveInteriorShade = false
      "Set to true if window has an interior shade (at surface b)"
      annotation (Evaluate=true);
    final parameter Boolean windowHasShade = haveExteriorShade or haveInteriorShade
      "Set to true if the window has an exterior or an interior shade";

    parameter Glasses.Generic glass[nLay]
      "Layer by layer declaration of glass layers, starting from outside to room-side"
      annotation (choicesAllMatching=true, Evaluate=true, Placement(transformation(extent={{60,60},{80,80}})));
    parameter Gases.Generic gas[nLay-1]
      "Layer by layer declaration of glass layers, starting from outside to room-side"
      annotation (choicesAllMatching=true, Evaluate=true, Placement(transformation(extent={{60,20},
              {80,40}})));
    parameter Shades.Generic shade "Shade"
      annotation (choicesAllMatching=true, Evaluate=true,
      Dialog(enable=haveInteriorShade or haveExteriorShade));
    parameter Modelica.SIunits.CoefficientOfHeatTransfer UFra
      "U-value of frame";
    parameter Modelica.SIunits.Emissivity epsLWFra=0.8
      "Long-wave emissivity of window frame";
    parameter Modelica.SIunits.Emissivity epsSWFra=0.5
      "Short-wave emissivity of window frame";
    final parameter Boolean haveShade = haveInteriorShade or haveExteriorShade
      "Parameter that is true if the construction has a shade";

    annotation (Documentation(info="<html>
This record implements thermophysical properties for glazing systems.
</html>",
  revisions="<html>
<ul>
<li>
Sep. 3 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end Generic;

  record SingleClear3 =
      Buildings.HeatTransfer.Data.GlazingSystems.Generic (
         glass={Glasses.ID102()},
         UFra=3,
         final nLay=1) "Single pane, clear glass 3mm";

  record DoubleClearAir13Clear =
      Buildings.HeatTransfer.Data.GlazingSystems.Generic (
      final glass={Glasses.ID101(), Glasses.ID102()},
      final gas={Gases.Air(x=0.0127)},
      UFra=1.4,
      final nLay=2) "Double pane, clear glass 3mm, air 12.7, clear glass 3mm";

  record TripleClearAir13ClearAir13Clear =
      Buildings.HeatTransfer.Data.GlazingSystems.Generic (
      final glass={Glasses.ID102(),Glasses.ID102(),Glasses.ID102()},
      final gas={Gases.Air(x=0.0127),Gases.Air(x=0.0127)},
      UFra=1.4,
      final nLay=3)
    "Triple pane, clear glass 3mm, air 12.7, clear glass 3mm, air 12.7, clear glass 3mm";
annotation (Documentation(info="<html>
This package implements thermophysical properties for glazing systems.
</html>"));
end GlazingSystems;
