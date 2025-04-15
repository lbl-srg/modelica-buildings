within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types;
type BoilerTypes = enumeration(
  condensingBoiler "Condensing boiler",
  nonCondensingBoiler "Non-condensing boiler")
  "Definitions for boiler types"
annotation (
  Documentation(info="<html>
    <p>
    This enumeration provides definitions for the boiler type based on the
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
    </html>"));
