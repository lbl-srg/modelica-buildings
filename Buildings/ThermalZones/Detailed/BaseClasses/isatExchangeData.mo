within Buildings.ThermalZones.Detailed.BaseClasses;
function isatExchangeData "Exchange data between ISAT and Modelica"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialExchangeData;

external"C" retVal = isatExchangeData(
    t,
    dt,
    u,
    nU,
    nY,
    modTimRea,
    y) annotation (Include="#include <isatExchangeData.c>", IncludeDirectory=
        "modelica://Buildings/Resources/C-Sources");

  annotation (Documentation(info="<html>
<p>
This function calls a C function to conduct the data exchange between Modelica and ISAT program during the coupled simulation.</p>
</html>", revisions="<html>
<ul>
<li>
November 1, 2019, by Xu Han, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));

end isatExchangeData;
