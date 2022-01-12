within Buildings.Fluid.Storage.Ice.Data.IceThermalStorage;
record Generic
  extends Modelica.Icons.Record;
  final parameter Integer nCha = 6 "Number of coefficients for charging characteristic curve";
  final parameter Integer nDisCha = 6 "Number of coefficients for discharging characteristic curve";

  parameter Real coeCha[nCha] "Coefficients for charging curve";
  parameter Real coeDisCha[nDisCha] "Coeffcients for discharging curve";
  parameter Real dtCha "Time step of curve fitting data";
  parameter Real dtDisCha "Time step of curve fitting data";

  annotation (defaultComponentName="datIceTan",
     defaultComponentPrefixes="parameter",
    Documentation(revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
Performance data for ice tank charging and discharging curves.
</html>"));
end Generic;
