within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.Examples;
model UACp "Test model for UACp"
  extends Modelica.Icons.Example;
  package Medium =Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.UACp uacp(
    redeclare package Medium = Medium,
    homotopyInitialization=true,
    TIn_nominal=cooNomVal.T1In_nominal,
    p_nominal=cooNomVal.p1_nominal,
    phiIn_nominal=cooNomVal.phi1In_nominal,
    Q_flow_nominal=cooNomVal.Q_flow_nominal,
    m_flow_nominal=cooNomVal.m1_flow_nominal,
    SHR_nominal=cooNomVal.SHR_nominal) "Calculates UA/Cp value for the coil"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.BaseClasses.CoolingNominalValues
                                                     cooNomVal(
          Q_flow_nominal=-1877.9,
          COP_nominal=4,
          m1_flow_nominal=0.151008,
          m2_flow_nominal=0.000381695,
          SHR_nominal=0.75) "Nominal values"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  annotation (Diagram(graphics),__Dymola_Commands(
file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/BaseClasses/Examples/UACp.mos"
        "Simulate and plot"),
          Documentation(info="<html><p>
This example illustrates calculation of UA/Cp factor of coil 
(working of <a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.UACp\">
Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.UACp</a>).
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
end UACp;
