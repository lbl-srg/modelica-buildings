within Buildings.Fluid.HeatPumps.Calibration;
model ScrollWaterToWater
  "Calibration model for scroll water to water heat pump"
  import Buildings;
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.HeatPumps.Calibration.BaseClasses.PartialWaterToWater(
      redeclare Buildings.Fluid.HeatPumps.ScrollWaterToWater heaPum(
      redeclare package Medium1 = Medium1,
      redeclare package Medium2 = Medium2,
      redeclare package ref = ref,
      UACon = UACon,
      UAEva = UAEva,
      volRat=volRat,
      V_flow_nominal=
             v_flow,
      leaCoe=leaCoe,
      etaEle=etaEle,
      PLos=PLos,
      dTSup=dTSup,
      m1_flow_nominal=m1_flow_nominal,
      m2_flow_nominal=m2_flow_nominal,
      dp1_nominal=dp1_nominal,
      dp2_nominal=dp2_nominal), calDat(tableName="ManufacturerData",
      fileName=Modelica.Utilities.Files.loadResource(
          "modelica://Buildings/Resources/Data/Fluid/HeatPumps/Calibration/manufacturerData.txt")));

  parameter Real volRat(min = 1.0, unit = "1")
    "Built-in volume ratio";

  parameter Modelica.SIunits.VolumeFlowRate v_flow(min = 0)
    "Refrigerant volume flow rate at suction";

  parameter Modelica.SIunits.MassFlowRate leaCoe(min = 0)
    "Leakage coefficient";

  parameter Modelica.SIunits.Efficiency etaEle
    "Electro-mechanical efficiency of the compressor";

  parameter Modelica.SIunits.Power PLos(min = 0)
    "Constant part of the compressor power losses";

  parameter Modelica.SIunits.TemperatureDifference dTSup(min = 0)
    "Superheating at compressor suction";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,100}}),
        graphics={Text(
          extent={{-88,92},{-64,90}},
          lineColor={28,108,200},
          textString="fixme: make sure this model is part of the regression tests.")}),
                                                     preferredView="info",
        Documentation(info="<HTML>
<p>
Calibration model for the calibration of models for water to water heat pump 
with scroll compressor. 
</p>
<p>
Source and load temperatures and flow rates are read from an external time
table.
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ScrollWaterToWater;
