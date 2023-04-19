within Buildings.Templates.HeatingPlants.HotWater.Components.Controls;
package TypesTmp
  "Temporary type definitions to prepare G36 controller integration"

  package BoilerTypes
    "Definitions for boiler types"

    constant Integer condensingBoiler = 1
      "Condensing boiler";

    constant Integer nonCondensingBoiler = 2
      "Non-condensing boiler";

  annotation (
    Documentation(info="<html>
    <p>
    This package provides constants that indicate the boiler type based on the 
    presence of flue gas heat recovery. 
    The boiler types are enumerated in an order that enables identification of stage
    type as condensing or non-condensing.
    </p>
    </html>",
      revisions="<html>
    <ul>
    <li>
    May 21, 2020, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"),
      Icon(graphics={
           Rectangle(
             lineColor={200,200,200},
             fillColor={248,248,248},
             fillPattern=FillPattern.HorizontalCylinder,
             extent={{-100.0,-100.0},{100.0,100.0}},
             radius=25.0),
           Rectangle(
             lineColor={128,128,128},
             extent={{-100.0,-100.0},{100.0,100.0}},
             radius=25.0)}));
  end BoilerTypes;

  type PrimaryPumpSpeedControlTypes = enumeration(
      localDP "Pump speed regulated to maintain local differential pressure setpoint",
      remoteDP "Pump speed regulated to maintain remote differential pressure setpoint",
      flowrate "Pump speed regulated to maintain flowrate through decoupler",
      temperature "Pump speed regulated to maintain temperature difference between
      primary and secondary loops")
    "Definitions for primary pump speed control types";
  type SecondaryPumpSpeedControlTypes = enumeration(
      localDP "Pump speed regulated to maintain local differential pressure setpoint",
      remoteDP "Pump speed regulated to maintain remote differential pressure setpoint")
    "Definitions for secondary pump speed control types";
  annotation (Documentation(info="<html>
<p>
FIXME: Temporary files to be deleted when merging
issue2180_BoilerPlant_MainController_oct_2021.
</p>
</html>"));
end TypesTmp;
