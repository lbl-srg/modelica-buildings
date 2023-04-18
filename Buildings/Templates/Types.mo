within Buildings.Templates;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type Buildings = enumeration(
      Education "Buildings used for academic or technical classroom instruction",
      FoodSales "Buildings used for retail or wholesale of food",
      FoodServices "Buildings used for preparation and sale of food and beverages for consumption",
      HealthCare "Buildings used as diagnostic and treatment facilities for inpatient care",
      Lodging  "Buildings used to offer multiple accommodations for short-term or long-term residents",
      MercantileRetail "Buildings used for the sale and display of goods other than food",
      MercantileMall "Shopping malls comprised of multiple connected establishments",
      Office "Buildings used for general office space, professional office, or administrative offices",
      PublicAssembly "Buildings in which people gather for social or recreational activities",
      PublicOrderSafety "Buildings used for the preservation of law and order or public safety",
      ReligiousWorkshop "Buildings in which people gather for religious activities",
      Service "Buildings in which some types of services is provided",
      WarehouseStorage "Buildings used to store goods, manufactured products, merchandise, raw materials, or personal belongings",
      Other "All other miscellaneous buildings that do not fit into any other category",
      Vacant "Buildings in which more floor space was vacant than was used for any single commercial activity")
    "Enumeration to specify the building type";
  type Units = enumeration(
      SI
      "SI - International units",
      IP
      "IP - Imperial units")
    "Enumeration to specify the system of units";
  annotation (Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
