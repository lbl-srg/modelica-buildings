within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model UACp "Test model for UACp"
  extends Modelica.Icons.Example;
  package Medium =Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.UACp uacp(
    per=nomVal,
    redeclare package Medium = Medium,
    homotopyInitialization=true) "Calculates UA/Cp value for the coil"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  parameter Data.Generic.BaseClasses.NominalValues
                                 nomVal(
    Q_flow_nominal=-21000,
    COP_nominal=3,
    SHR_nominal=0.8,
    m_flow_nominal=1.5) "Nominal values"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  annotation (Diagram(graphics),
experiment(StopTime=60),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/UACp.mos"
        "Simulate and plot"),
          Documentation(info="<html><p>
This example illustrates calculation of UA/Cp factor of coil (working of <a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.UACp\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.UACp</a>).
</p>
</html>",
revisions="<html>
<ul>
<li>
May 1, 2013, by Michael Wetter:<br/>
Declared the parameter record to be a parameter, as declaring its elements
to be parameters does not imply that the whole record has the variability of a parameter.
</li>
<li>
April 10, 2012 by Kaustubh Phalak:<br/>
First implementation. 
</li>
</ul>
</html>"));
end UACp;
