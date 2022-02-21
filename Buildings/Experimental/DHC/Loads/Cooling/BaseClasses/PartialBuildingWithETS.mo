within Buildings.Experimental.DHC.Loads.Cooling.BaseClasses;
model PartialBuildingWithETS
  "Partial model with ETS model for cooling and partial building model"
  extends
    Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS(
      nPorts_chiWat=1,
     redeclare
      Buildings.Experimental.DHC.EnergyTransferStations.Cooling.DirectUncontrolled ets(
      final m_flow_nominal=m_flow_nominal,
      final dpSup=dpSup,
      final dpRet=dpRet));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
    final min=0,
    final start=0.5)
    "Nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpSup(
    final min=0,
    displayUnit="Pa")=5000
    "Pressure drop in the ETS supply side";
  parameter Modelica.Units.SI.PressureDifference dpRet(
    final min=0,
    displayUnit="Pa")=5000
    "Pressure drop in the ETS return side";
  annotation (Documentation(info="<html>
<p>
This model is composed of a direct uncontrolled energy transfer station model for cooling 
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Cooling.DirectUncontrolled\">
Buildings.Experimental.DHC.EnergyTransferStations.Cooling.DirectUncontrolled</a>
connected to a repleacable building load model. 
</p>
</html>", revisions="<html>
<ul>
<li>
January 1, 2022, by Chengnan Shi:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialBuildingWithETS;
