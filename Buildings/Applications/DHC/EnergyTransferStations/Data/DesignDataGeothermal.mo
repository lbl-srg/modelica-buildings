within Buildings.Applications.DHC.EnergyTransferStations.Data;
record DesignDataGeothermal "Data record with design data for borefield"
  extends
      Modelica.Icons.Record;

  //  parameter Modelica.SIunits.PressureDifference dpHex_nominal(displayUnit="Pa")=50000
  //    "Pressure difference of heat exchanger";

  parameter Modelica.SIunits.PressureDifference dpBor_nominal(displayUnit="Pa")
     =
   1.3E5 "Pressure drop borefield loop, without heat exchanger";

  parameter Modelica.SIunits.Length lBorFie[5]={70,90,40,70,120}*0.5
"Length of borefields";
  parameter Modelica.SIunits.Length wBorFie[5]={44,50,40,40,40}
"Width of borefields";

  annotation (defaultComponentName="datGeo", Documentation(info=
                                                "<html>
<p>
This data record contains design data that is used in various models.
</p>
</html>"));
end DesignDataGeothermal;
