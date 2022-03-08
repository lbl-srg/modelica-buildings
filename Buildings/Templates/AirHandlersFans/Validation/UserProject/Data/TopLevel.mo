within Buildings.Templates.AirHandlersFans.Validation.UserProject.Data;
record TopLevel "Top level (whole building) record for testing purposes"
  extends Modelica.Icons.Record;

  parameter .Buildings.Templates.AirHandlersFans.Data.VAVMultiZone VAV_1
    "Multiple-zone VAV air-handling unit" annotation (Dialog(group=
          "Air handlers and fans"), Placement(transformation(extent={{-10,-8},{
            10,12}})));

end TopLevel;
