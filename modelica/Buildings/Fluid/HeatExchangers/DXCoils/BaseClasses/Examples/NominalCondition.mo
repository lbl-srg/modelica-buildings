within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model NominalCondition "Test model for NominalCondition"
  extends Modelica.Icons.Example;
  package Medium =
      Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.NominalCondition nomCon(
      redeclare package Medium = Medium, per=nomVal)
    "Calculates nominal values"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Data.Generic.BaseClasses.NominalValues
                                 nomVal(
    Q_flow_nominal=-21000,
    COP_nominal=3,
    SHR_nominal=0.8,
    m_flow_nominal=1.5) "Nominal values"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/NominalCondition.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates calculation of inlet and outlet parameters at nominal condition (working of <a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.NominalCondition\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.NominalCondition</a>).
</p>
</html>",
revisions="<html>
<ul>
<li>
April 10, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end NominalCondition;
