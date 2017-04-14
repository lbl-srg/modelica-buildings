within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model NominalCondition "Test model for NominalCondition"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;
  parameter Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.NominalCondition nomCon(
    redeclare package Medium = Medium,
    per=per)
    "Calculates nominal values"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  parameter AirCooled.Data.Generic.BaseClasses.NominalValues per(
    Q_flow_nominal=-21000,
    COP_nominal=3,
    SHR_nominal=0.8,
    m_flow_nominal=1.5) "Nominal values"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  annotation (experiment(Tolerance=1e-6, StopTime=60),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/NominalCondition.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates the calculation of inlet and outlet parameters at the nominal condition.
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
end NominalCondition;
