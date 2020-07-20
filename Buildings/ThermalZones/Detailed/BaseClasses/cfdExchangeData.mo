within Buildings.ThermalZones.Detailed.BaseClasses;
function cfdExchangeData "Exchange data between CFD and Modelica"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialExchangeData;

external"C" retVal = cfdExchangeData(
    t,
    dt,
    u,
    nU,
    nY,
    modTimRea,
    y) annotation (Include="#include <cfdExchangeData.c>", IncludeDirectory=
        "modelica://Buildings/Resources/C-Sources");

  annotation (Documentation(info="<html>
<p>
This function calls a C function to conduct the data exchange between Modelica and CFD program during the coupled simulation.</p>
</html>", revisions="<html>
<ul>
<li>
November 1, 2019, by Xu Han, Wangda Zuo:<br/>
Changed structure.
</li>
<li>
August 16, 2013, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));

end cfdExchangeData;
